//
//  Inventory.swift
//  Units
//
//  Created by Jason Jobe on 1/28/26.
//
import Foundation

// MARK: SKU for Inventory
public typealias SKU = URL
public typealias Stock = Quantum

public extension QuantumType {
    var sku: SKU { URL(sku: "\(self)") }
}

// MARK: Inventory - a collection of Quamtum
public struct Inventory {
    public private(set) var items: [Stock]
    public var count: Int { items.count }
}

public extension Inventory {

    func adding(_ q: Quantum) -> Self {
        var newSelf = self
        newSelf.add(q)
        return newSelf
    }
    
    func subtracting(_ q: Quantum) -> Self {
        var newSelf = self
        newSelf.subtract(q)
        return newSelf
    }

    mutating func subtract(_ q: Quantum) {
        if let ndx = items.firstIndex(where: { $0.qtype == q.qtype }) {
            items[ndx].magnitude -= q.magnitude
            if items[ndx].magnitude == 0 {
                items.remove(at: ndx)
            }
        } else {
            items.append(q)
        }
    }

    mutating func add(_ q: Quantum) {
        if let ndx = items.firstIndex(where: { $0.qtype == q.qtype }) {
            items[ndx].magnitude += q.magnitude
            if items[ndx].magnitude == 0 {
                items.remove(at: ndx)
            }
       } else {
            items.append(q)
        }
    }

    func amount(of qt: QuantumType) -> Double {
        items.reduce(0) { partial, elem in partial + (elem.qtype == qt ? elem.magnitude : 0) }
    }
}

public extension Inventory {
    static func += (lhs: inout Self, rhs: Quantum) {
        lhs.add(rhs)
    }
    static func -= (lhs: inout Self, rhs: Quantum) {
        lhs.subtract(rhs)
    }
}

public extension Inventory {
    static func += (lhs: inout Self, rhs: Inventory) {
        rhs.items.forEach { lhs.add($0) }
    }

    static func -= (lhs: inout Self, rhs: Inventory) {
        rhs.items.forEach { lhs.subtract($0) }
    }

    static func *= (lhs: inout Self, rhs: Double) {
        for i in lhs.items.indices {
            lhs.items[i].magnitude *= rhs
        }
    }

    static func /= (lhs: inout Self, rhs: Double) {
        for i in lhs.items.indices {
            lhs.items[i].magnitude /= rhs
        }
    }

    static func + (lhs: Self, rhs: Inventory) -> Inventory {
        var result = lhs
        for element in rhs.items {
            result.add(element)
        }
        return result
    }
}

// MARK: SKU Extenstion to URL
extension URL {
    /**
     A SKU URL has the scheme 'sku' and has the general format of
     sku:<host>/<id>:=material[25units]
     Guarenteed to create something
     */
    public init(sku: String) {
        self = Self.parse(sku: sku)
    }
    
    public static func parse(sku: String) -> URL {
        if sku.lowercased().hasPrefix("sku:") {
            if let url = URL(string: sku) {
                return url
            }
        }
        
        // Ensure we always create a valid URL with the `sku` scheme.
        // We build components and percent-encode the path so arbitrary SKU tokens are safe.
        var comps = URLComponents()
        comps.scheme = "sku"
        
        // Treat the whole string as the URL path
        // Valid URL MUST have single leading slash
        let rawPath = sku.hasPrefix("/") ? sku : "/" + sku
        // URLComponents expects path to be unescaped
        // it will handle encoding when producing .url
        comps.path = rawPath
        
        if let url = comps.url {
            return url
        }
        
        // Absolute fallback: construct from a minimally encoded string.
        // Replace spaces with %20 and remove illegal characters conservatively.
        let allowed = CharacterSet.urlPathAllowed.union(CharacterSet(charactersIn: "/"))
        let encodedPath = rawPath.unicodeScalars.map { allowed.contains($0) ? String($0) : String(format: "%%%02X", $0.value) }.joined()
        return URL(string: "sku:\\" + encodedPath)
        ?? URL(string: "sku:/UNKOWN")!
    }
}

#if PLAY_TIME
import Playgrounds
#Playground {
    if let sku = URL(string: "sku:joe@wildthink.com/role[3]:=12345")
    {
        print("SKU:", sku)
        print("SKU.path:", sku.path)
    } else {
        print("BAD")
    }
}
#endif
