//
//  AppViewModel.swift
//  Cobble Viewer
//
//  Created by Zack Brown on 17/11/2025.
//

import Bivouac
import Alluvium
import Cobble
import Combine
import Deltille
import Euclid
import Foundation
import SceneKit
import SwiftUI

@MainActor
internal class AppViewModel: ObservableObject {
    
    @Published internal var design: Design = .rounded {
            
        didSet {
            
            guard oldValue != design else { return }
            
            updateScene()
        }
    }
    
    @Published internal var tiling: Tiling = .rhombus {
            
        didSet {
            
            guard oldValue != tiling else { return }
            
            updateScene()
        }
    }
    
    internal let vertices: [Triangle.Vertex] = [.init(1, 0, 0),
                                                .init(0, 1, 0),
                                                .init(0, 0, 1),
                                                .init(0, -1, 2),
                                                .init(2, 0, -1),
                                                .init(-1, 2, 0)]
    
    internal var tiles: [Triangle] {
        
        Array(Set(vertices.flatMap {
            
            $0.tiles
        }))
    }
    
    internal let scene = SCNScene()
    
    internal let gridColor: NSColor = .grid
    internal let gridAlternateColor: NSColor = .gridAlternate
    
    internal let colorPalette = ColorPalette(.primary,
                                             .secondary,
                                             .tertiary,
                                             .quaternary)
    
    internal let model = SCNNode()
    internal let wireframe = SCNNode()
    internal let surface = SCNNode()
    
    internal init() {
        
        updateScene()
        
        scene.rootNode.addChildNode(model)
        scene.rootNode.addChildNode(surface)
        
        model.addChildNode(wireframe)
    }
}

extension AppViewModel {
    
    private func updateScene() {
        
        updateModel()
        
        updateSurface()
    }
    
    private func updateModel() {
        
        var mesh = Mesh.empty
        
        for tile in tiles {
         
            let vertices = tile.vertices.filter { self.vertices.contains($0) }
            
            let wedge = Wedge(tile,
                              vertices)
            
            let part = Mesh.footpath(wedge,
                                     design,
                                     tiling,
                                     colorPalette)
            
            mesh = mesh.merge(part)
        }
        
        model.geometry = .init(mesh)
        wireframe.geometry = .init(wireframe: mesh)
    }
    
    private func updateSurface() {
        
        var mesh = Mesh.empty
        
        for tile in tiles {
            
            let color = tile.isPointy ? gridColor : gridAlternateColor
            
            guard let surface = Mesh.surface(tile.vertices.position(.tile),
                                             .init(color)) else { continue }
            
            mesh = mesh.merge(surface)
        }
        
        surface.geometry = .init(mesh)
    }
}
