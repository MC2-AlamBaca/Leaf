//
//  ViewModel.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 26/06/24.
//

import SwiftUI

class PhotoViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var data: String = ""
    
    func saveDataToPhoto() {
        guard let image = image else { return }
        
        if let newImage = addMetadataToImage(image: image, metadata: data) {
            // Save the new image to the photo library
            UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        }
    }
    
    private func addMetadataToImage(image: UIImage, metadata: String) -> UIImage? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        let source = CGImageSourceCreateWithData(imageData as CFData, nil)
        guard let cgImage = CGImageSourceCreateImageAtIndex(source!, 0, nil) else { return nil }
        
        let uti = CGImageSourceGetType(source!)
        let mutableData = NSMutableData(data: imageData)
        guard let destination = CGImageDestinationCreateWithData(mutableData, uti!, 1, nil) else { return nil }
        
        let properties = NSMutableDictionary()
        properties[kCGImagePropertyIPTCDictionary as String] = [
            kCGImagePropertyIPTCKeywords: [metadata]
        ]
        
        CGImageDestinationAddImage(destination, cgImage, properties as CFDictionary)
        CGImageDestinationFinalize(destination)
        
        return UIImage(data: mutableData as Data)
    }
}
