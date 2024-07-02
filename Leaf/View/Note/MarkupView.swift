import SwiftUI
import PencilKit

struct MarkupView: View {
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    @Binding var photoData: Data?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let photoData = photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            PencilKitManager(canvasView: $canvasView)
                                .background(.clear) // Ensure the canvas is tappable
                        )
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button("Clear") {
                        canvasView.drawing = PKDrawing()
                    }
                    Button(action: {undoManager?.redo()}, label: {
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
        .onAppear {
            if let photoData = photoData, let backgroundImage = UIImage(data: photoData) {
                let imageView = UIImageView(image: backgroundImage)
                imageView.frame = canvasView.bounds
                canvasView.insertSubview(imageView, at: 0)
            }
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

//#Preview {
//    MarkupView(undoManager: <#T##arg#>, canvasView: <#T##arg#>, photoData: <#T##Data?#>, dismiss: <#T##arg#>)
//}
