import Vision
import UIKit

class OCRManager: ObservableObject {
    @Published var recognizedTitle: String = ""
    @Published var recognizedAuthor: String = ""
    
    func performOCR(on image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            self?.processRecognizedText(observations)
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform OCR: \(error)")
        }
    }
    
    private func processRecognizedText(_ observations: [VNRecognizedTextObservation]) {
        // Sort observations from top to bottom
        let sortedObservations = observations.sorted { $0.boundingBox.origin.y > $1.boundingBox.origin.y }
        
        var authorLines: [String] = []
        var titleLines: [String] = []
        var authorFound = false
        
        for observation in sortedObservations {
            guard let candidate = observation.topCandidates(1).first else { continue }
            let text = candidate.string.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !authorFound {
                if authorLines.count < 2 && !text.isEmpty {
                    authorLines.append(text)
                    if authorLines.count == 2 {
                        authorFound = true
                    }
                }
            } else if titleLines.count < 2 && !text.isEmpty {
                titleLines.append(text)
            }
        }
        
        let author = authorLines.joined(separator: " ")
        let title = titleLines.joined(separator: " ")
        
        DispatchQueue.main.async {
            self.recognizedAuthor = self.toSentenceCase(author)
            self.recognizedTitle = self.toSentenceCase(title)
        }
    }
    
    private func toSentenceCase(_ input: String) -> String {
        guard !input.isEmpty else { return input }
        let sentences = input.components(separatedBy: ". ")
        let capitalizedSentences = sentences.map { sentence -> String in
            let trimmedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedSentence.isEmpty else { return sentence }
            return trimmedSentence.prefix(1).uppercased() + trimmedSentence.dropFirst().lowercased()
        }
        return capitalizedSentences.joined(separator: ". ")
    }
}
