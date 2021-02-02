//
//  PhotoMemoryDetailView.swift
//  PhotoMemory
//
//  Created by Dave Spina on 1/28/21.
//

import SwiftUI
import CoreImage
import MapKit

struct PhotoMemoryDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State public var photoItem: PhotoMemoryItem
    @Binding public var photoStream: PhotoItemStream
    @State private var showValidationAlert = false
    @State private var validationError = ""
    @State private var showPickerSheet = false
    @State private var currentImage: UIImage?
    @State public var currentLocation: CLLocationCoordinate2D
    @State private var showMapDetails = false
    @State private var annotation: MKPointAnnotation?
    
    public var locationFetcher = LocationFetcher()
    
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
            
            if photoItem.latitude != 0 && annotation != nil {
                MapView(centerCoordinate: $currentLocation, selectedPlace: $annotation, showingPlaceDetails: $showMapDetails, annotations: [annotation!])
            }
            
            Text("Location: \(photoItem.longitude), \(photoItem.latitude)")
            
            Button("Save") {
                save()
            }
        }
        .onAppear(perform: loadAnnotationData)
        .sheet(isPresented: $showPickerSheet) {
            ImagePicker(image: $currentImage)
        }
        .alert(isPresented: $showValidationAlert) {
            Alert(title: Text("Cannot Save"), message: Text(validationError), dismissButton: .default(Text("Ok")))
        }
        .onDisappear(perform: save)
    }
    
    func loadAnnotationData() {
        locationFetcher.start()
        if photoItem.latitude != 0 {
            currentLocation = CLLocationCoordinate2D(latitude: photoItem.latitude, longitude: photoItem.longitude)
            self.annotation = MKPointAnnotation()
            self.annotation?.coordinate = currentLocation
            self.annotation?.title = photoItem.fileName
        }
    }
    
    func save() -> Void {
        self.photoItem.rawImage = currentImage
        validationError = ""
        if (photoItem.fileName == "") {
            showValidationAlert = true
            validationError = "A valid image title must be provided."
            return
        }
        
        if let location = self.locationFetcher.lastKnownLocation {
            photoItem.longitude = location.longitude
            photoItem.latitude = location.latitude
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
        let photoMemory = PhotoMemoryItem(fileName: "Test Image", image: img, description: "My image", longitude: 0, latitude:  0)
        let cfLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        return PhotoMemoryDetailView(photoItem: photoMemory, photoStream: .constant(photoStream), currentLocation: cfLocation)
    }
}
