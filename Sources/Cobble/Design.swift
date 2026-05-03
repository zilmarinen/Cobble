//
//  Design.swift
//  Cobble
//
//  Created by Zack Brown on 25/04/2026.
//

import Alluvium
import Bivouac
import Deltille
import Euclid

public enum Design: String,
                    CaseIterable,
                    Codable,
                    Identifiable,
                    Sendable {
    
    case kite
    case rounded
    case wedge
 
    public var id: String { rawValue.capitalized }
    
    internal var tiling: Tiling {
        
        switch self {
            
        case .kite: .divisions
        case .rounded: .rhombus
        case .wedge: .subdivisions
        }
    }
    
    internal func corner(_ corner: Triangle.Corner,
                         _ triangle: Triangle) -> Mesh {
        
        switch self {
            
        case .kite:
            
            kite(corner,
                 triangle)
            
        case .rounded:
            
            rounded(corner,
                    triangle)
            
        case .wedge:
            
            wedge(corner,
                  triangle)
        }
    }
    
    internal func edge(_ edge: Triangle.Edge,
                       _ triangle: Triangle) -> Mesh {
        
        switch self {
            
        case .kite:
            
            kite(edge,
                 triangle)
            
        case .rounded:
            
            rounded(edge,
                    triangle)
            
        case .wedge:
            
            wedge(edge,
                  triangle)
        }
    }
    
    internal func tile(_ corners: [Triangle.Corner],
                       _ triangle: Triangle) -> Mesh {
        
        let vertices = corners.map { triangle.vertex($0).position(.tile) }
        
        let polygons = Polygon.tile(vertices,
                                    0.02,
                                    .white)
        
        return Mesh(polygons)
    }
}

// MARK: Kite

extension Design {
    
    private func kite(_ corner: Triangle.Corner,
                      _ triangle: Triangle) -> Mesh {
        
        .empty
    }
    
    private func kite(_ edge: Triangle.Edge,
                      _ triangle: Triangle) -> Mesh {
        
        .empty
    }
}

// MARK: Rounded

extension Design {
    
    private func rounded(_ corner: Triangle.Corner,
                         _ triangle: Triangle) -> Mesh {
        
        let v0 = triangle.vertex(corner).position(.tile)
        let v1 = triangle.vertex(corner == .c0 ? .c1 : .c0).position(.tile)
        let mid = v0.mid(v1)
        let radius = (v0 - mid).length
        
        let tile = self.tile(triangle.corners,
                             triangle)
        
        let circle = Mesh.cylinder(radius: radius,
                                   height: tile.bounds.size.y * 2.0,
                                   slices: 32)
        
        let translated = circle.translated(by: v0)
        
        return translated.intersection(tile)
    }
    
    private func rounded(_ edge: Triangle.Edge,
                         _ triangle: Triangle) -> Mesh {
        
        let corners = triangle.corners.filter {
            
            !edge.corners.contains($0)
        }
        
        guard let corner = corners.first,
              let lhs = edge.corners.first,
              let rhs = edge.corners.last  else { return .empty }
        
        let v0 = triangle.vertex(lhs).position(.tile)
        let v1 = triangle.vertex(rhs).position(.tile)
        let v2 = triangle.vertex(corner).position(.tile)
        let mid = v0.mid(v1)
        let radius = (v0 - mid).length
        
        let tile = self.tile(triangle.corners,
                             triangle)
        
        let circle = Mesh.cylinder(radius: radius,
                                   height: tile.bounds.size.y * 2.0,
                                   slices: 32)
        
        let translated = circle.translated(by: v2)
        
        return tile.subtracting(translated)
    }
}

// MARK: Wedge

extension Design {
    
    private func wedge(_ corner: Triangle.Corner,
                       _ triangle: Triangle) -> Mesh {
        
        let corners = corner.edges.flatMap {
            
            $0.corners.filter { $0 != corner }
        }
        
        guard let lhs = corners.first,
              let rhs = corners.last else { return .empty }
        
        let v0 = triangle.vertex(lhs).position(.tile)
        let v1 = triangle.vertex(rhs).position(.tile)
        let v2 = triangle.vertex(corner).position(.tile)
        let v3 = v2.mid(v0)
        let v4 = v2.mid(v1)
        
        return Mesh.tile([v4, v3, v2],
                         0.02,
                         .white)
    }
    
    private func wedge(_ edge: Triangle.Edge,
                       _ triangle: Triangle) -> Mesh {
            
        let corners = triangle.corners.filter {
            
            !edge.corners.contains($0)
        }
        
        guard let corner = corners.first,
              let lhs = edge.corners.first,
              let rhs = edge.corners.last  else { return .empty }
        
        let v0 = triangle.vertex(lhs).position(.tile)
        let v1 = triangle.vertex(rhs).position(.tile)
        let v2 = triangle.vertex(corner).position(.tile)
        let v3 = v0.mid(v2)
        let v4 = v1.mid(v2)
        
        return Mesh.tile([v3, v4, v1, v0],
                         0.02,
                         .white)
    }
}
