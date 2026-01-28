//
//  Quantum.swift
//  Units
//
//  Created by Jason Jobe on 1/17/26.
//

import Foundation

/**
 Quantum means that which is divisible into two or more constituent parts,
 of which each is by nature a one and a this. A quantum is a plurality if it is numerable,
 a magnitude if it is measurable. Plurality means that which is divisible potentially into
 non-continuous parts, magnitude that which is divisible into continuous parts;
 of magnitude, that which is continuous in one dimension is length;
 in two breadth, in three depth.
 
 Of these, limited plurality is number, limited length is a line, breadth a surface, depth a solid.
 
— Aristotle, Metaphysics, Book V, Ch. 11-14
 */

/*
 Plurality - Numerable, Countable
 Magnitude - Measurable in Units
 Compound/Mixture -
 */

public struct QuantumType: Equatable, Identifiable, Codable, Sendable {
    public var id: String { token }
    public let token: String
    public let unit: Unit
}

extension QuantumType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        token = value
        unit = .none
    }
    
    public init(_ value: any StringProtocol, unit: Unit = .none) {
        token = value.description
        self.unit = unit
    }
}

public struct Quantum: Equatable {
    public let qtype: QuantumType
    public var magnitude: Double
}

public extension Quantum {
    var unit: Unit { qtype.unit }
    var count: Double { magnitude }
    var isPlurality: Bool { unit == .none }
    var isMeasurable: Bool { unit != .none }
    var countable: Bool { unit == .none }
}

/*
 Equation - Mathematical expressions with single character variables
 
 Money - System of Currency exchange
 Currency: EU, USD, etc
 
 ## ExtendedSwiftMath
 https://swiftpackageindex.com/ChrisGVE/ExtendedSwiftMath
 
 An extended version of SwiftMath with comprehensive LaTeX
 symbol coverage, adding missing mathematical symbols,
 blackboard bold, delimiter sizing, amssymb equivalents,
 and automatic line wrapping.
 
 ## thales
 https://swiftpackageindex.com/ChrisGVE/thales
 Full Documentation on docs.rs
 
 A comprehensive Computer Algebra System (CAS) library for
 symbolic mathematics, equation solving, calculus, and numerical
 methods. Named after Thales of Miletus, the first mathematician
 in the Greek tradition.
 
 Features
 
 - Expression Parsing - Parse mathematical expressions with full operator precedence
 - Equation Solving - Linear, quadratic, polynomial, transcendental, and systems of equations
 - Calculus - Differentiation, integration, limits, Taylor series, ODEs
 - Numerical Methods - Newton-Raphson, bisection, Brent's method when symbolic fails
 - Coordinate Systems - 2D/3D transformations, complex numbers, De Moivre's theorem
 - Units & Dimensions - Dimensional analysis and unit conversion
 - iOS Support - FFI bindings for Swift via swift-bridge
 */

