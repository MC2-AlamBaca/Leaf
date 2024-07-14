//
//  PencilKit.swift
//  Leaf
//
//  Created by Marizka Ms on 02/07/24.
//

import Foundation
import SwiftUI
import PencilKit


struct PencilKitManager: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    let picker = PKToolPicker.init()
    var backgroundImage: UIImage?
    var onDrawingChanged: () -> Void
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .default
        self.canvasView.tool = PKInkingTool(.marker, color: .yellow, width: 20)
        
        self.canvasView.backgroundColor = .clear
        self.canvasView.becomeFirstResponder()
        
        canvasView.delegate = context.coordinator
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        picker.addObserver(canvasView)
        picker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilKitManager
        
        init(_ parent: PencilKitManager) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.onDrawingChanged()
        }
    }
}


