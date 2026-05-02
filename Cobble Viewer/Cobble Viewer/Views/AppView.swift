//
//  ContentView.swift
//  Cobble Viewer
//
//  Created by Zack Brown on 17/11/2025.
//

import Bivouac
import Cobble
import Deltille
import SceneKit
import SwiftUI

struct AppView: View {
    
    @ObservedObject private var viewModel = AppViewModel()
    
    var body: some View {
            
        #if os(iOS)
            NavigationStack {
        
                viewer
            }
        #else
            viewer
        #endif
    }
    
    var viewer: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            sceneView
        }
    }
    
    var sceneView: some View {
        
        SceneView(scene: viewModel.scene,
                  options: [.allowsCameraControl,
                            .autoenablesDefaultLighting])
        .toolbar {
            
            ToolbarItemGroup {
                
                toolbar
            }
        }
        .navigationTitle("Cobble")
    }
    
    @ViewBuilder
    var toolbar: some View {

        Picker("Design",
               selection: $viewModel.design) {
            
            ForEach(Design.allCases, id: \.self) { design in
                
                Text(design.id)
                    .id(design)
            }
        }
        
        Picker("Tiling",
               selection: $viewModel.tiling) {
            
            ForEach(Tiling.allCases, id: \.self) { tiling in
                
                Text(tiling.id)
                    .id(tiling)
            }
        }
    }
}
