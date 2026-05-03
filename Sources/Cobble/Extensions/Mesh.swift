//
//  Mesh.swift
//  Cobble
//
//  Created by Zack Brown on 17/11/2025.
//

import Alluvium
import Bivouac
import Deltille
import Euclid

extension Mesh {
    
    //TODO: Remove method variant used for debugging
    public static func footpath(_ wedge: Wedge,
                                _ design: Design,
                                _ tiling: Tiling,
                                _ colorPalette: ColorPalette) -> Self {
        
        switch wedge {
            
        case .corner(let triangle,
                     let corner):
            
            let surface = tiling.mesh(triangle,
                                      colorPalette)
            
            let stencil = design.corner(corner,
                                        triangle)
            
            return stencil.intersection(surface)
            
        case .edge(let triangle,
                   let edge):
            
            let surface = tiling.mesh(triangle,
                                      colorPalette)
            
            let stencil = design.edge(edge,
                                      triangle)
            
            return stencil.intersection(surface)
            
        case .tile(let triangle,
                   let corners):
            
            let surface = tiling.mesh(triangle,
                                      colorPalette)
            
            let stencil = design.tile(corners,
                                      triangle)
            
            return stencil.intersection(surface)
        }
    }
    
    public static func footpath(_ wedge: Wedge,
                                _ design: Design,
                                _ colorPalette: ColorPalette) -> Self {
        
        switch wedge {
            
        case .corner(let triangle,
                     let corner):
            
            let surface = design.tiling.mesh(triangle,
                                             colorPalette)
            
            let stencil = design.corner(corner,
                                        triangle)
            
            return stencil.intersection(surface)
            
        case .edge(let triangle,
                   let edge):
            
            let surface = design.tiling.mesh(triangle,
                                             colorPalette)
            
            let stencil = design.edge(edge,
                                      triangle)
            
            return stencil.intersection(surface)
            
        case .tile(let triangle,
                   let corners):
            
            let surface = design.tiling.mesh(triangle,
                                             colorPalette)
            
            let stencil = design.tile(corners,
                                      triangle)
            
            return stencil.intersection(surface)
        }
    }
}
