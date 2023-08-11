//
//  FlickrSearchBar.swift
//  QFlickrApp
//
//  Created by Adam Essam on 09/08/2023.
//

import SwiftUI

struct FlickrSearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search for images...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: onSearch) {
                Text("Search")
            }
            .disabled(text.isEmpty)
        }
        .padding()
    }
}

struct FlickrSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        FlickrSearchBar(text: .constant(""), onSearch: {})
    }
}
