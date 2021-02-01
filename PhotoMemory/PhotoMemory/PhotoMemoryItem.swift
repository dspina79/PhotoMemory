//
//  PhotoMemoryItem.swift
//  PhotoMemory
//
//  Created by Dave Spina on 1/28/21.
//

import Foundation
import UIKit

class PhotoMemoryItem: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case id, fileName, imageData, fileDescription
    }
    
    var id: UUID
    var fileName: String
    var imageData = Data()
    var fileDescription: String
    var rawImage: UIImage? {
        didSet{
            if rawImage != nil {
                self.imageData = PhotoMemoryItem.imageToData(rawImage!)
            }
        }
    }
    
    
    init(fileName: String?, image: UIImage?, description: String?) {
        self.id = UUID()
        self.fileName = fileName ?? ""
        self.fileDescription = description ?? ""
        
        if image != nil {
            self.rawImage = image!
            self.imageData = PhotoMemoryItem.imageToData(image!)
        }
    }
    
    var wrappedImage: UIImage {
        rawImage ?? UIImage(systemName: "plus")!
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.fileName = try container.decode(String.self, forKey: .fileName)
        self.fileDescription = try container.decode(String.self, forKey: .fileDescription)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.imageData = try container.decode(Data.self, forKey: .imageData)
        self.rawImage = UIImage(data: self.imageData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.fileName, forKey: .fileName)
        try container.encode(self.fileDescription, forKey: .fileDescription)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.imageData, forKey: .imageData)
    }
    
    static func imageToData(_ image: UIImage) -> Data {
        return image.jpegData(compressionQuality: 0.5) ?? Data()
    }
}

class PhotoItemStream: Codable {
    var photoMemories = [PhotoMemoryItem]()
}
