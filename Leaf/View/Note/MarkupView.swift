import SwiftUI
import PencilKit
import Vision

struct MarkupView: View {
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    @Binding var photoData: Data?
    @Binding var detectedText: String
    @Environment(\.dismiss) private var dismiss
    @State private var zoomScale: CGFloat = 1.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let photoData = photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            PencilKitManager(canvasView: $canvasView, backgroundImage: uiImage, onDrawingChanged: handleDrawingChanged)
                                .background(.clear)
                        )
                        .scaleEffect(zoomScale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { gestureScale in
                                    zoomScale = gestureScale.magnitude
                                }
                        )
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button("Clear") {
                        canvasView.drawing = PKDrawing()
                    }
                    Button(action: {undoManager?.undo()}, label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                    })
                    Button(action: {undoManager?.redo()}, label: {
                        Image(systemName: "arrow.uturn.forward.circle")
                    })
                    Button("Save") {
                        saveDrawing()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: {
                        dismiss()
                    })
                }
            }
        }
    }
    
    private func handleDrawingChanged() {
        if let image = UIImage(data: photoData ?? Data()) {
            let highlightedImage = drawHighlightsOnImage(image)
            performOCR(on: highlightedImage)
        }
    }
    
    private func drawHighlightsOnImage(_ image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            context.cgContext.setAlpha(0.3)
            context.cgContext.setBlendMode(.normal)
            
            canvasView.drawing.strokes.forEach { stroke in
                if stroke.ink.color == .yellow {  // Assuming yellow is used for highlighting
                    context.cgContext.setStrokeColor(UIColor.yellow.cgColor)
                    context.cgContext.setLineWidth(20)  // Fixed width for highlight
                    context.cgContext.setLineCap(.round)
                    context.cgContext.setLineJoin(.round)
                    
                    let path = UIBezierPath()
                    if let firstPoint = stroke.path.first {
                        path.move(to: firstPoint.location)
                        for point in stroke.path.dropFirst() {
                            path.addLine(to: point.location)
                        }
                    }
                    
                    context.cgContext.addPath(path.cgPath)
                    context.cgContext.strokePath()
                }
            }
        }
    }
    
    private func performOCR(on image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            DispatchQueue.main.async {
                self.detectedText = recognizedStrings.joined(separator: " ")
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform OCR: \(error)")
        }
    }
    
    private func saveDrawing() {
        if let backgroundImage = UIImage(data: photoData ?? Data()) {
            UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, 0)
            backgroundImage.draw(in: canvasView.bounds)
            canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale).draw(in: canvasView.bounds)
            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let combinedImageData = combinedImage?.jpegData(compressionQuality: 0.8) {
                photoData = combinedImageData
            }
        }
        dismiss()
    }
}

struct MarkupView_Previews: PreviewProvider {
    @State static var photoData: Data? = nil
    @State static var detectedText: String = ""
    
    static var previews: some View {
        MarkupView(photoData: $photoData, detectedText: $detectedText)
    }
}
