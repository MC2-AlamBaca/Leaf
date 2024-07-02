
import SwiftUI
import PencilKit

struct MarkupView: View {
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    @Binding var photoData: Data?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if let photoData = photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)
            }
            
            PencilKitManager(canvasView: $canvasView)
                .background(Color.white.opacity(0.01)) // Ensure the canvas is tappable
            
            VStack {
                HStack(spacing: 20) {
                    Button("Clear") {
                        canvasView.drawing = PKDrawing()
                    }
                    Button("Undo") {
                        undoManager?.undo()
                    }
                    Button("Redo") {
                        undoManager?.redo()
                    }
                    Button("Save") {
                        saveDrawing()
                    }
                }
                .padding(20)
                Spacer()
            }
        }
    }
    
    private func saveDrawing() {
        if let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale).jpegData(compressionQuality: 0.8) {
            photoData = drawingImage
        }
        dismiss()
    }
}

//struct MarkupView_Previews: PreviewProvider {
//  static var previews: some View {
//      MarkupView(photoData: <#Binding<Data?>#>)
//  }
//}
