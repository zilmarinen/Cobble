//
//  ContentView.swift
//  Cobble Viewer
//
//  Created by Zack Brown on 17/11/2025.
//

import Deltille
import Lattice
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
        Text("Toolbar")
//        Picker("Stoop",
//               selection: $viewModel.stoop) {
//            
//            ForEach(Stoop.allCases, id: \.self) { stoop in
//                
//                Text(stoop.id)
//                    .id(stoop)
//            }
//        }
    }
}
