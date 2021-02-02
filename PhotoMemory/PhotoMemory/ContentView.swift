//
//  ContentView.swift
//  PhotoMemory
//
//  Created by Dave Spina on 1/27/21.
//

import SwiftUI
import FileProvider
import MapKit

struct ContentView: View {
    @State private var showNewSheet = false
    @State private var photoStream = PhotoItemStream()
    var body: some View {
        NavigationView {
            VStack{
                
                List(photoStream.photoMemories.sorted()) {item in
                    NavigationLink(destination: PhotoMemoryDetailView(photoItem: item, photoStream: $photoStream, currentLocation: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))) {
                        HStack {
                            Image(uiImage: item.wrappedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("\(item.fileName)")
                                    .font(.headline)
                                Text("\(item.fileDescription)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }.navigationBarTitle(Text("Photo Memory"))
            .navigationBarItems(trailing: Button("New"){
                self.showNewSheet = true
            })
        }
        .onAppear(perform: loadData)
        .sheet(isPresented: $showNewSheet, onDismiss: loadData) {
            let photoItem = PhotoMemoryItem(fileName: "", image: nil, description: "", longitude: 0, latitude: 0)
            PhotoMemoryDetailView(photoItem: photoItem, photoStream: $photoStream, currentLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let fileName = getDocumentsDirectory().appendingPathComponent("personaphotomemory.json")
        do {
            let data = try Data(contentsOf: fileName)
            self.photoStream = try JSONDecoder().decode(PhotoItemStream.self, from: data)
        } catch {
            self.photoStream = PhotoItemStream()
            print("Unable to load data properly")
        }
    }
    
    func saveStream() {
        loadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
