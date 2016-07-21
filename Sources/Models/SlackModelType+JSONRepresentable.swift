//
//  SlackModelType+JSONRepresentable.swift
//  Chameleon
//
//  Created by Ian Keen on 20/07/2016.
//
//

extension JSONRepresentable where Self: SlackModelType {
    public func makeJSON() -> JSON {
        return Mirror(reflecting: self).makeJSON()
    }
}

extension Array: JSONRepresentable {
    public func makeJSON() -> JSON {
        let items = self
            .flatMap { $0 as? JSONRepresentable }
            .map { $0.makeJSON() }
        
        return JSON(items)
    }
}
extension Optional: JSONRepresentable {
    public func makeJSON() -> JSON {
        switch self {
        case .some(let value):
            if let json = value as? [JSONRepresentable] {
                return json.makeJSON()
            } else if let json = value as? JSONRepresentable {
                return json.makeJSON()
            }
            return .null
        case .none: return .null
        }
    }
}

extension JSONRepresentable where Self: RawRepresentable {
    public func makeJSON() -> JSON {
        if let value = self.rawValue as? JSONRepresentable {
            return value.makeJSON()
        }
        return .null
    }
}

private extension Mirror {
    func makeJSON() -> JSON {
        let output = self.children.reduce(JSON.object([:])) { (result: JSON, child) in
            guard let key = child.label else { return result }
            
            var result = result
            
            let childMirror = Mirror(reflecting: child.value)
            if let style = childMirror.displayStyle where style == .collection {
                let items = childMirror.children
                    .flatMap { $0.value as? JSONRepresentable }
                    .map { $0.makeJSON() }
                    .filter { !$0.isNull }
                
                let json = JSON(items)
                result[key] = json
                
            } else if let value = child.value as? JSONRepresentable {
                let json = value.makeJSON()
                if (!json.isNull) {
                    result[key] = json
                }
            }
            
            return result
        }
        
        if let superClassMirror = self.superclassMirror {
            return output + superClassMirror.makeJSON()
        }
        
        return output
    }
}

func +(left: JSON, right: JSON) -> JSON {
    switch left {
    case .object(let object):
        guard case let .object(otherObject) = right else { return right }
        
        var merged = object
        for (key, value) in otherObject {
            if let original = object[key] {
                merged[key] = original + value
            } else {
                merged[key] = value
            }
        }
        return .object(merged)
        
    case .array(let array):
        guard case let .array(otherArray) = right else { return right }
        
        return .array(array + otherArray)
        
    default:
        return right
    }
}

