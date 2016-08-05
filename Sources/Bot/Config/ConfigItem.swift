//
//  ConfigItem.swift
//  Chameleon
//
//  Created by Ian Keen on 4/08/2016.
//
//

protocol ConfigItem {
    static var variableName: String { get }
    static var description: String { get }
    static var required: Bool { get }
    static var `default`: String? { get }
    static var itemSet: [ConfigItem.Type] { get }
}

extension ConfigItem {
    static var required: Bool { return false }
    static var `default`: String? { return nil }
    static var itemSet: [ConfigItem.Type] { return [Self.self] }
}

//MARK: - Helpers
extension Collection where Iterator.Element == ConfigItem.Type {
    func makeSets() -> [[Iterator.Element]] {
        var items = Array(self)
        var sets = [[ConfigItem.Type]]()
        
        while items.count > 0 {
            var setIndices = [Int]()
            var setItems = [ConfigItem.Type]()
            
            for (index, item) in items.enumerated().reversed() {
                for type in items.first?.itemSet ?? [] {
                    if (item == type) {
                        setItems.append(item)
                        setIndices.append(index)
                    }
                }
            }
            for index in setIndices {
                items.remove(at: index)
            }
            
            sets.append(setItems)
        }
        
        return sets
    }
}
