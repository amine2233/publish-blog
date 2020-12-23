//
//  File.swift
//  
//
//  Created by Amine Bensalah on 23/12/2020.
//

import Foundation

extension Optional {
    /// Returns true if the optional is empty
    public var isNone: Bool {
        switch self {
        case .some:
            return false
        default:
            return true
        }
    }

    /// Returns true if the optional is not empty
    public var isSome: Bool {
        switch self {
        case .some:
            return true
        default:
            return false
        }
    }
}

extension Optional {
    /// Return the value of the Optional or the `default` parameter
    /// - param: The value to return if the optional is empty
    public func or(_ default: Wrapped) -> Wrapped {
        self ?? `default`
    }

    /// Returns the unwrapped value of the optional *or*
    /// the result of an expression `else`
    /// I.e. optional.or(else: print("Arrr"))
    public func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        self ?? `else`()
    }

    /// Returns the unwrapped value of the optional *or*
    /// the result of calling the closure `else`
    /// I.e. optional.or(else: {
    /// ... do a lot of stuff
    /// })
    public func or(else: () -> Wrapped) -> Wrapped {
        self ?? `else`()
    }

    /// Returns the unwrapped contents of the optional if it is not empty
    /// If it is empty, throws exception `throw`
    public func or(throw exception: Error) throws -> Wrapped {
        guard let unwrapped = self else { throw exception }
        return unwrapped
    }
}

extension Optional where Wrapped == Error {
    /// Only perform `else` if the optional has a non-empty error value
    public func or(_ else: (Error) -> Void) {
        guard let error = self else { return }
        `else`(error)
    }
}

extension Optional {
    /// Maps the output *or* returns the default value if the optional is nil
    /// - parameter fn: The function to map over the value
    /// - parameter or: The value to use if the optional is empty
    public func map<T>(_ fct: (Wrapped) throws -> T, default: T) rethrows -> T {
        try map(fct) ?? `default`
    }

    /// Maps the output *or* returns the result of calling `else`
    /// - parameter fn: The function to map over the value
    /// - parameter else: The function to call if the optional is empty
    public func map<T>(_ fct: (Wrapped) throws -> T, else: () throws -> T) rethrows -> T {
        try map(fct) ?? `else`()
    }
}

extension Optional {
    /// Tries to unwrap `self` and if that succeeds continues to unwrap the parameter `optional`
    /// and returns the result of that.
    public func and<B>(_ optional: B?) -> B? {
        guard self != nil else { return nil }
        return optional
    }

    /// Executes a closure with the unwrapped result of an optional.
    /// This allows chaining optionals together.
    public func and<T>(then: (Wrapped) throws -> T?) rethrows -> T? {
        guard let unwrapped = self else { return nil }
        return try then(unwrapped)
    }

    /// Zips the content of this optional with the content of another
    /// optional `other` only if both optionals are not empty
    public func zip2<A>(with other: A?) -> (Wrapped, A)? {
        guard let first = self, let second = other else { return nil }
        return (first, second)
    }

    /// Zips the content of this optional with the content of another
    /// optional `other` only if both optionals are not empty
    public func zip3<A, B>(with other: A?, another: B?) -> (Wrapped, A, B)? {
        guard let first = self,
            let second = other,
            let third = another else { return nil }
        return (first, second, third)
    }
}

extension Optional {
    /// Executes the closure `some` if and only if the optional has a value
    public func on(some: () throws -> Void) rethrows {
        if self != nil { try some() }
    }

    /// Executes the closure `none` if and only if the optional has no value
    public func on(none: () throws -> Void) rethrows {
        if self == nil { try none() }
    }
}

extension Optional {
    /// Returns the unwrapped value of the optional only if
    /// - The optional has a value
    /// - The value satisfies the predicate `predicate`
    public func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let unwrapped = self,
            predicate(unwrapped) else { return nil }
        return self
    }

    /// Returns the wrapped value or crashes with `fatalError(message)`
    public func expect(_ message: String) -> Wrapped {
        guard let value = self else { fatalError(message) }
        return value
    }
}

extension Optional {
    public var isEmpty: Bool {
        self == nil
    }

    public var exists: Bool {
        self != nil
    }
}
