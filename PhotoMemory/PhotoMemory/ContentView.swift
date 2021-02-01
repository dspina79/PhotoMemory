//
//  ContentView.swift
//  PhotoMemory
//
//  Created by Dave Spina on 1/27/21.
//

import SwiftUI
import FileProvider

struct ContentView: View {
    @State private var showNewSheet = false
    @State private var photoStream = PhotoItemStream()
    var body: some View {
        NavigationView {
            VStack{
                Text("To Be Completed!")
            }.navigationBarTitle(Text("Photo Memory"))
            .navigationBarItems(trailing: Button("New"){
                self.showNewSheet = true
            })
        }.sheet(isPresented: $showNewSheet) {
            PhotoMemoryDetailView(photoItem: PhotoMemoryItem(fileName: "", image: nil, description: ""))
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let fileName = getDocumentsDirectory().appendingPathComponent("PersonalPhotoStream")
        do {
            let data = try Data(contentsOf: fileName)
            self.photoStream = try JSONDecoder().decode(PhotoItemStream.self, from: data)
        } catch {
            self.photoStream = PhotoItemStream()
            print("Unable to load data properly")
        }
    }
    
    func saveStream() {
        do {
            let file = getDocumentsDirectory().appendingPathComponent("PersonalPhotoStream")
            let jsonData = try JSONEncoder().encode(self.photoStream)
            try jsonData.write(to: file, options: [.atomicWrite, .completeFileProtection]) // all of it and encrypted
        } catch {
            print("Unable to save data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
