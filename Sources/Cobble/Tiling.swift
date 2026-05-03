//
//  Tiling.swift
//  Cobble
//
//  Created by Zack Brown on 28/04/2026.
//

import Alluvium
import Bivouac
import Deltille
import Euclid

public enum Tiling: String,
                      CaseIterable,
                      Codable,
                      Identifiable,
                      Sendable {
    
    case divisions
    case kites
    case rhombus
    case subdivisions
    case trapezoid

    public var id: String { rawValue.capitalized }
    
    public func mesh(_ triangle: Triangle,
                     _ colorPalette: ColorPalette) -> Mesh {
        
        let stencil = triangle.stencil(.tile)
        
        switch self {
            
        case .divisions:
            
            return divisions(stencil,
                             colorPalette)
            
        case .kites:
            
            return kites(stencil,
                         colorPalette)
            
        case .rhombus:
            
            return rhombus(stencil,
                           colorPalette)
            
        case .subdivisions:
            
            return subdivisions(stencil,
                                colorPalette)
            
        case .trapezoid:
            
            return trapezoid(stencil,
                                colorPalette)
        }
    }
}

// MARK: Divisions

extension Tiling {
    
    private func divisions(_ stencil: Triangle.Stencil,
                           _ colorPalette: ColorPalette) -> Mesh {
        
        var mesh = Mesh.empty
        
        for subdivision in Triangle.Stencil.Division.allCases {
            
            let division = stencil.division(subdivision)
            
            let corners = division.map { stencil.vertex($0) }
            
            let part = Mesh.tile(corners,
                                 0.02,
                                 colorPalette.random())
            
            mesh = mesh.union(part)
        }
        
        return mesh
    }
}

// MARK: Kites

extension Tiling {
    
    private func kites(_ stencil: Triangle.Stencil,
                       _ colorPalette: ColorPalette) -> Mesh {
        
        var polygons: [Euclid.Polygon] = []
        
        for subdivision in Triangle.Stencil.Division.allCases {
            
            let division = stencil.division(subdivision)
            
            let corners = division.map { stencil.vertex($0) }
            let center = corners.center
            
            for i in corners.indices {
                
                let j = (i + 1) % corners.count
                let k = (i + 2) % corners.count
                
                let v0 = corners[i]
                let v1 = v0.mid(corners[j])
                let v2 = v0.mid(corners[k])
                
                polygons.append(contentsOf: Polygon.tile([v0, v1, center, v2],
                                                         0.02,
                                                         colorPalette.random()))
            }
        }
        
        return Mesh(polygons)
    }
}

// MARK: Rhombus

extension Tiling {
    
    private func rhombus(_ stencil: Triangle.Stencil,
                        _ colorPalette: ColorPalette) -> Mesh {
        
        var polygons: [Euclid.Polygon] = []
        
        for subdivision in Triangle.Stencil.Division.allCases {
            
            let division = stencil.division(subdivision)
            
            let corners = division.map { stencil.vertex($0) }
            let center = corners.center
            
            for i in corners.indices {
                
                let j = (i + 1) % corners.count
                
                let v0 = corners[i]
                let v1 = corners[j]
                
                polygons.append(contentsOf: Polygon.tile([v0, v1, center],
                                                         0.02,
                                                         colorPalette.color(for: i)))
            }
        }
        
        return Mesh(polygons)
    }
}

// MARK: Subdivisions

extension Tiling {
    
    private func subdivisions(_ stencil: Triangle.Stencil,
                              _ colorPalette: ColorPalette) -> Mesh {
        
        var polygons: [Euclid.Polygon] = []
        let color = colorPalette.random()
        
        for subdivision in Triangle.Stencil.Division.allCases {
            
            let division = stencil.division(subdivision)
            
            let corners = division.map { stencil.vertex($0) }
            let center = corners.center
            
            for i in corners.indices {
                
                let j = (i + 1) % corners.count
                let k = (i + 2) % corners.count
                
                let v0 = corners[i]
                let v1 = v0.mid(corners[j])
                let v2 = v0.mid(corners[k])
                
                polygons.append(contentsOf: Polygon.tile([v0, v1, v2],
                                                         0.02,
                                                         colorPalette.random()))
                
                //TODO: Re-mesh inner tile
                polygons.append(contentsOf: Polygon.tile([center, v2, v1],
                                                         0.02,
                                                         color))
            }
        }
        
        return Mesh(polygons)
    }
}

// MARK: Trapezoid

extension Tiling {
    
    private func trapezoid(_ stencil: Triangle.Stencil,
                           _ colorPalette: ColorPalette) -> Mesh {
        
        var polygons: [Euclid.Polygon] = []
        
        for subdivision in Triangle.Stencil.Division.allCases {
            
            let division = stencil.division(subdivision)
            
            let corners = division.map { stencil.vertex($0) }
            let center = corners.center
            
            for i in corners.indices {
                
                let j = (i + 1) % corners.count
                let k = (i + 2) % corners.count
                
                let v0 = corners[i]
                let v1 = v0.lerp(corners[j], 1.0 / 3.0)
                let v2 = v0.lerp(corners[k], 1.0 / 1.5)
                
                polygons.append(contentsOf: Polygon.tile([v0, v1, center, v2],
                                                         0.02,
                                                         colorPalette.color(for: i)))
            }
        }
        
        return Mesh(polygons)
    }
}
