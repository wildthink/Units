//
//  Formatter.swift
//  Units
//  (aka Fountation.FormatStyle)
//
//  Created by Jason Jobe on 10/24/25.
//

public extension Measurement {
    struct Formatter<Output> {
        let format: (Measurement) -> Output
    }
    
    func formatted<Output>(_ formatter: Formatter<Output>) -> Output {
        formatter.format(self)
    }
    
    func formatted(_ formatter: Formatter<String> = .measurement()) -> String {
        formatter.format(self)
    }
    
    func formatted(
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 4
    ) -> String {
        Formatter
            .measurement(
                minimumFractionDigits: minimumFractionDigits,
                maximumFractionDigits: maximumFractionDigits)
            .format(self)
    }
}

extension Measurement.Formatter where Output == String {
    public static func measurement(
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 4
    ) -> Self {
        self.init { value in
            value.value
                .formatted(
                    minimumFractionDigits: minimumFractionDigits,
                    maximumFractionDigits: maximumFractionDigits)
            + " \(value.unit.symbol)"
        }
    }
}


// MARK: Percent Formatter

public extension Percent {
    struct Formatter<Output> {
        let format: (Percent) -> Output
    }
    
    func formatted<Output>(_ formatter: Formatter<Output>) -> Output {
        formatter.format(self)
    }
}

public extension Percent {
    func formatted(fractionDigits: Int = 2) -> String {
        Formatter(fractionDigits: fractionDigits).format(self)
    }
}

public extension Percent.Formatter where Output == String {
    
    init (fractionDigits: Int) {
        self.init { value in
            (value.magnitude * 100)
                .formatted(
                    minimumFractionDigits: 0,
                    maximumFractionDigits: fractionDigits)
            + value.unit.symbol
        }
    }
}

public extension BinaryFloatingPoint {
    func formatted(minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 4) -> String {
        let minDigits = max(0, minimumFractionDigits)
        let maxDigits = max(minDigits, maximumFractionDigits)
        let s = String(format: "%.\(maxDigits)f", Double(self))
        if maxDigits > minDigits, s.contains(".") {
            var trimmed = s
            while trimmed.last == "0" { trimmed.removeLast() }
            if trimmed.last == "." { trimmed.removeLast() }
            if let dotIndex = trimmed.firstIndex(of: ".") {
                let fractionalCount = trimmed.distance(from: trimmed.index(after: dotIndex), to: trimmed.endIndex)
                if fractionalCount < minDigits {
                    return String(format: "%.\(minDigits)f", Double(self))
                }
            }
            return trimmed
        }
        return s
    }
}
