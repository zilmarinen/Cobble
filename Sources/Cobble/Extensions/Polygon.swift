//
//  Polygon.swift
//  Cobble
//
//  Created by Zack Brown on 28/04/2026.
//

import Euclid

extension Polygon {
    
    internal static let tileHeight = 0.02
    
    internal static func tile(_ vectors: [Vector],
                              _ color: Color) -> [Polygon] {
        
        let elevation = Vector(0.0, Self.tileHeight, 0.0)
        
        guard let surface = Polygon.surface(vectors.map { $0 + elevation },
                                            color),
              let base = Polygon.surface(vectors.reversed(),
                                         color) else { return [] }
        
        var polygons = [surface, base]
        
        for i in vectors.indices {
            
            let j = (i + 1) % vectors.count
            
            let v0 = vectors[i]
            let v1 = vectors[j]
            let v2 = v1 + elevation
            let v3 = v0 + elevation
            
            guard let face = Polygon.surface([v0, v1, v2, v3],
                                             color) else { continue }
            
            polygons.append(face)
        }
        
        return polygons
    }
}
