//
//  PhotoMemoryItem.swift
//  PhotoMemory
//
//  Created by Dave Spina on 1/28/21.
//

import Foundation
import UIKit

class PhotoMemoryItem: Codable, Identifiable {
    var id: UUID
    var fileName: String
    var imageData: Data
    var fileDescription: String
    var rawImage: UIImage
    
    init(fileName: String, image: UIImage, description: String) {
        self.id = UUID()
        self.fileName = fileName
        self.fileDescription = description
        self.rawImage = image
        self.imageData = PhotoMemoryItem.imageToData(image)
    }
    
    required init(from decoder: Decoder) throws {
        // TODO:
        
        self.id = UUID()
        self.fileName = ""
        self.fileDescription = ""
        self.rawImage = UIImage(systemName: "plus")!
        self.imageData = Data()
    }
    
    func encode(to encoder: Encoder) throws {
        // TODO:
    }
    
    static func imageToData(_ image: UIImage) -> Data {
        return image.jpegData(compressionQuality: 0.5) ?? Data()
    }
}

class PhotoItemStream: Codable {
    var photoMemories = [PhotoMemoryItem]()
}
