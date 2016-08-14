import Common

public extension SlackModelType {
    public func makeDictionary() -> [String: Any] {
        return Mirror(reflecting: self).makeDictionary()
    }
}

extension Optional: SlackModelValueType {
    public var modelValue: Any? {
        switch self {
        case .some(let value):
            if let value = value as? [SlackModelType] {
                return value.map { $0.makeDictionary() }
                
            } else if let value = value as? SlackModelType {
                return value.makeDictionary()
                
            } else if let value = value as? SlackModelValueType {
                return value.modelValue
            }
            return value
        case .none: return nil
        }
    }
}

extension Array: SlackModelValueType {
    public var modelValue: Any? {
        return self
            .flatMap { $0 as? SlackModelValueType }
            .map { $0.modelValue }
    }
}
extension SlackModelValueType where Self: RawRepresentable {
    public var modelValue: Any? {
        return self.rawValue
    }
}

extension FailableBox: SlackModelValueType {
    public var modelValue: Any? {
        if let value = self.value as? SlackModelType {
            return value.makeDictionary()
        } else if let value = value as? SlackModelValueType {
            return value.modelValue
        }
        return self.value
    }
}

private extension Mirror {
    func makeDictionary() -> [String: Any] {
        let output = self.children.reduce([:]) { (result: [String: Any], child) in
            guard let key = child.label else { return result }
            
            let childMirror = Mirror(reflecting: child.value)
            if let style = childMirror.displayStyle, style == .collection {
                let converted: [Any] = childMirror.children
                    .filter { $0.value is SlackModelType || $0.value is SlackModelValueType }
                    .flatMap { collectionChild in
                        if let convertable = collectionChild.value as? SlackModelType {
                            return convertable.makeDictionary()
                            
                        } else if let value = collectionChild.value as? SlackModelValueType {
                            return value.modelValue
                            
                        } else {
                            return collectionChild.value
                        }
                }
                return result + [key: converted]
                
            } else {
                if let value = child.value as? SlackModelType {
                    return result + [key: value.makeDictionary()]
                    
                } else if let dictionaryValue = child.value as? SlackModelValueType, let value = dictionaryValue.modelValue {
                    return result + [key: value]
                    
                } else {
                    return result + [key: child.value]
                }
            }
        }
        
        if let superClassMirror = self.superclassMirror {
            return output + superClassMirror.makeDictionary()
        }
        return output
    }
}
