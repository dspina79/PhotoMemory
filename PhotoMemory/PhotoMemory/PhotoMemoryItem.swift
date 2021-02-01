//
//  PhotoMemoryItem.swift
//  PhotoMemory
//
//  Created by Dave Spina on 1/28/21.
//

import Foundation
import UIKit

class PhotoMemoryItem: Codable, Identifiable, Comparable {
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
    
    static func < (lhs: PhotoMemoryItem, rhs: PhotoMemoryItem) -> Bool {
        return lhs.fileName < rhs.fileName
    }
    
    static func ==(lhs: PhotoMemoryItem, rhs: PhotoMemoryItem) -> Bool {
        return lhs.id == rhs.id
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

class PhotoItemStream: Codable, ObservableObject {
    var photoMemories = [PhotoMemoryItem]()
    
    func upsert(item: PhotoMemoryItem) {
        if photoMemories.contains(where: {$0.id == item.id}) {
            let index = photoMemories.firstIndex(where: {$0.id == item.id})
            photoMemories[index!] = item
        } else {
            photoMemories.append(item)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func reload() {
        let photoItemStream: PhotoItemStream
        let fileName = getDocumentsDirectory().appendingPathComponent("personaphotomemory.json")
        do {
            let data = try Data(contentsOf: fileName)
            photoItemStream = try JSONDecoder().decode(PhotoItemStream.self, from: data)
        } catch {
            photoItemStream = PhotoItemStream()
            print("Unable to load data properly")
        }
        self.photoMemories = photoItemStream.photoMemories
    }
    
    func save() {
        do {
            let file = getDocumentsDirectory().appendingPathComponent("personaphotomemory.json")
            let jsonData = try JSONEncoder().encode(self)
            try jsonData.write(to: file, options: [.atomicWrite, .completeFileProtection]) // all of it and encrypted
            reload()
        } catch {
            print("Unable to save data")
            print("\(error.localizedDescription)")
        }
    }
}
