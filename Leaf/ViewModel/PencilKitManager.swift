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
    
    func makeUIView(context: Context) -> PKCanvasView {
      canvasView.drawingPolicy = .default
      self.canvasView.tool = PKInkingTool(.pen, color: .red, width: 15)
        
//        if let backgroundImage = backgroundImage {
//            let imageView = UIImageView(image: backgroundImage)
//            canvasView.insertSubview(imageView, at: 0)
//        }
        
        
      self.canvasView.backgroundColor = .clear
      self.canvasView.becomeFirstResponder()
      return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
      picker.addObserver(canvasView)
      picker.setVisible(true, forFirstResponder: uiView)
      DispatchQueue.main.async {
        uiView.becomeFirstResponder()
      }
    }
}

struct MarkupView_Previews: PreviewProvider {
    @State static var photoData: Data? = nil
    
    static var previews: some View {
        MarkupView(photoData: $photoData)
    }
}


