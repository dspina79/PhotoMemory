//
//  ContentView.swift
//  PhotoMemory
//
//  Created by Dave Spina on 1/27/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showNewSheet = false
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
