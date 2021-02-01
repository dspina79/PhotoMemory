//
//  PhotoMemoryDetailView.swift
//  PhotoMemory
//
//  Created by Dave Spina on 1/28/21.
//

import SwiftUI
import UIKit

struct PhotoMemoryDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State public var photoItem: PhotoMemoryItem
    @State private var showValidationAlert = false
    @State private var validationError = ""
    
    var body: some View {
        VStack {
            Button("Get") {
                    ImagePicker(image: $photoItem.rawImage)
                
            }
            Image(uiImage: photoItem.wrappedImage)
                .resizable()
                .scaledToFit()
            Spacer()
            Form {
                TextField("Title", text: $photoItem.fileName)
                TextField("Description", text: $photoItem.fileDescription)
            }
            
            Button("Save") {
                save()
            }
        }
        .alert(isPresented: $showValidationAlert) {
            Alert(title: Text("Cannot Save"), message: Text(validationError), dismissButton: .default(Text("Ok")))
        }
        .onDisappear(perform: save)
    }
    
    func save() -> Void {
        validationError = ""
        if (photoItem.fileName == "") {
            showValidationAlert = true
            validationError = "A valid image title must be provided."
            return
        }
        // TOOD: Save document and post
        print("Saving")
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct PhotoMemoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let img = UIImage(systemName: "plus")!
        let photoMemory = PhotoMemoryItem(fileName: "Test Image", image: img, description: "My image")
        return PhotoMemoryDetailView(photoItem: photoMemory)
    }
}
