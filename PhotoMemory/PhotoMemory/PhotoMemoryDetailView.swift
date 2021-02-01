//
//  PhotoMemoryDetailView.swift
//  PhotoMemory
//
//  Created by Dave Spina on 1/28/21.
//

import SwiftUI
import CoreImage

struct PhotoMemoryDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State public var photoItem: PhotoMemoryItem
    @Binding public var photoStream: PhotoItemStream
    @State private var showValidationAlert = false
    @State private var validationError = ""
    @State private var showPickerSheet = false
    @State private var currentImage: UIImage?
    
    var body: some View {
        VStack {
            Button("Get") {
                    print("Getting image")
                    showPickerSheet = true
                
            }
            if let image = currentImage {
                Image(uiImage: currentImage!)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            Form {
                TextField("Title", text: $photoItem.fileName)
                TextField("Description", text: $photoItem.fileDescription)
            }
            
            Button("Save") {
                save()
            }
        }
        .sheet(isPresented: $showPickerSheet) {
            ImagePicker(image: $currentImage)
        }
        .alert(isPresented: $showValidationAlert) {
            Alert(title: Text("Cannot Save"), message: Text(validationError), dismissButton: .default(Text("Ok")))
        }
        .onDisappear(perform: save)
    }
    
    func save() -> Void {
        self.photoItem.rawImage = currentImage
        validationError = ""
        if (photoItem.fileName == "") {
            showValidationAlert = true
            validationError = "A valid image title must be provided."
            return
        }
        photoStream.upsert(item: photoItem)
        photoStream.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct PhotoMemoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let photoStream = PhotoItemStream()
        let img = UIImage(systemName: "plus")!
        let photoMemory = PhotoMemoryItem(fileName: "Test Image", image: img, description: "My image")
        return PhotoMemoryDetailView(photoItem: photoMemory, photoStream: .constant(photoStream))
    }
}
