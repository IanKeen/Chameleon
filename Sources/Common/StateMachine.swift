public protocol StateRepresentable: Equatable {
    /// The event type that can trigger transitions
    associatedtype StateEvent
    
    /**
     Check if executing an event will result in a new state
     
     - parameter event: Event to trigger
     - returns: The new state if the event would result in one, otherwise nil
     */
    func transition(withEvent event: StateEvent) -> Self?
}

public final class ReadOnlyStateMachine<State: StateRepresentable, Event where State.StateEvent == Event> {
    public typealias StateTransition = (old: State?, new: State) -> Void
    
    private let stateMachine: StateMachine<State, Event>
    
    private init(stateMachine: StateMachine<State, Event>) {
        self.stateMachine = stateMachine
    }
    
    public func observe<T: AnyObject>(observer: T, transition: (T) -> StateTransition) {
        self.stateMachine.observe(observer, transition: transition)
    }
}

public final class StateMachine<State: StateRepresentable, Event where State.StateEvent == Event> {
    public typealias StateTransition = (old: State?, new: State) -> Void
    
    //MARK: - Public Properties
    private(set) public var state: State {
        didSet { self.notifyObservers(from: oldValue, to: self.state) }
    }
    
    //MARK: - Private Properties
    private var observers = [WeakObserver<State, Event>]()
    
    //MARK: - Lifecycle
    public init(startingWith state: State) {
        self.state = state
    }
    
    //MARK: - Public
    public func transition(withEvent event: Event) {
        guard
            let result = self.state.transition(withEvent: event),
            result != self.state
            else { return print("Attempted invalid transition from \(self.state) with event: \(event)") }
        
        self.state = result
    }
    public func observe<T: AnyObject>(_ observer: T, transition: (T) -> StateTransition) {
        let observerWrapper = WeakObserver<State, Event>(observer: observer, transition: transition)
        self.observers.append(observerWrapper)
        transition(observer)(old: nil, new: self.state)
    }
    public var readOnly: ReadOnlyStateMachine<State, Event> {
        return ReadOnlyStateMachine(stateMachine: self)
    }
    
    //MARK: - Private
    private func notifyObservers(from oldState: State?, to newState: State) {
        self.observers = self.observers.filter { $0.observer != nil }
        self.observers.forEach { observer in
            if let object = observer.observer {
                observer.transition(object)(old: oldState, new: newState)
            }
        }
    }
}

final private class WeakObserver<State: StateRepresentable, Event where State.StateEvent == Event> {
    typealias StateTransition = (old: State?, new: State) -> Void
    
    weak var observer: AnyObject?
    let transition: (AnyObject) -> StateTransition
    
    init<T: AnyObject>(observer: T, transition: (T) -> StateTransition) {
        self.observer = observer as AnyObject
        self.transition = { obj in
            guard let obj = obj as? T else { fatalError() }
            return { from, to in
                transition(obj)(old: from, new: to)
            }
        }
    }
}
