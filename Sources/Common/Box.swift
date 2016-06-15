//
//  Box.swift
// Chameleon
//
//  Created by Ian Keen on 22/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public final class Box<T> {
    public let value: T
    public init(value: T) { self.value = value }
}

//This is required to get around a 'recursive value types' limitation
//namely the recursion between `Target` and `Message` (they each reference the other)
//
//It's not ideal - but it doesn't really impact the code that much and is not overly verbose either...
//this can be removed once structs get something along the lines of `indirect`
//
//Finally it seems it must be a class rather than a struct, even when the recursion is only the `T` specifier :(

public final class FailableBox<T> {
    public let value: T
    public init?(_ value: T?) {
        guard let value = value else { return nil }
        self.value = value
    }
}
