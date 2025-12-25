//
//  Mesh.swift
//  Cobble
//
//  Created by Zack Brown on 17/11/2025.
//

import Alluvium
import Deltille
import Euclid
import Lattice

extension Mesh {
    
    public static func footpath(_ triangle: Triangle,
                                _ wedge: Wedge,
                                _ colorPalette: ColorPalette) -> Self {
        
        let scale = Triangle.Scale.tile
        let size = 0.2
        
        switch wedge {
            
        case .corner(let corner):
            
            let corners = corner.edges.flatMap {
                
                $0.corners.filter { $0 != corner }
            }
            
            guard let lhs = corners.first,
                  let rhs = corners.last else { return .empty }
            
            let v0 = triangle.vertex(lhs).position(scale)
            let v1 = triangle.vertex(rhs).position(scale)
            let v2 = triangle.vertex(corner).position(scale)
            let v3 = v2.lerp(v0, size)
            let v4 = v2.lerp(v1, size)
            
            let path = [v4, v3, v2].path(colorPalette.color(for: .primary))
            
            guard let polygon = Polygon(shape: path) else { return .empty }
            
            return Mesh([polygon])
            
        case .edge(let edge):
            
            let corners = triangle.corners.filter {
                
                !edge.corners.contains($0)
            }
            
            guard let corner = corners.first,
                  let lhs = edge.corners.first,
                  let rhs = edge.corners.last  else { return .empty}
            
            let v0 = triangle.vertex(lhs).position(scale)
            let v1 = triangle.vertex(rhs).position(scale)
            let v2 = triangle.vertex(corner).position(scale)
            let v3 = v0.lerp(v2, size)
            let v4 = v1.lerp(v2, size)
            
            let path = [v3, v4, v1, v0].path(colorPalette.color(for: .secondary))
            
            guard let polygon = Polygon(shape: path) else { return .empty }
            
            return Mesh([polygon])
            
        case .tile: return triangle.mesh(.tile,
                                         colorPalette.color(for: .tertiary))
        }
    }
}
