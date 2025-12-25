//
//  AppViewModel.swift
//  Cobble Viewer
//
//  Created by Zack Brown on 17/11/2025.
//

import Cobble
import Combine
import Deltille
import Euclid
import Foundation
import Lattice
import SceneKit
import SwiftUI

@MainActor
internal class AppViewModel: ObservableObject {
    
    internal let triangle = Triangle.zero
    
    internal let scene = SCNScene()
    
    internal let gridColor: NSColor = .grid
    internal let gridAlternateColor: NSColor = .gridAlternate
    
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
        
        let tiles = [triangle] + triangle.perimeter
        
        for tile in tiles {
         
            let vertices = tile.vertices.filter { triangle.vertices.contains($0) }
            
            let wedge = Wedge(tile,
                              vertices)
            
            let part = Mesh.footpath(tile,
                                     wedge)
            
            mesh = mesh.merge(part).translated(by: .init(0.0, 0.001, 0.0))
        }
        
        model.geometry = .init(mesh)
        wireframe.geometry = .init(wireframe: mesh)
    }
    
    private func updateSurface() {
        
        var mesh = Mesh([])
        
        for tile in triangle.perimeter {
            
            let color = tile.isPointy ? gridColor : gridAlternateColor
            
            mesh = mesh.merge(tile.mesh(.tile,
                                        .init(color)))
        }
        
        surface.geometry = .init(mesh)
    }
}
