//
//  FlickrSearchBar.swift
//  QFlickrApp
//
//  Created by Adam Essam on 09/08/2023.
//

import SwiftUI

struct DropdownView: View {
    var searchHistory: [String]
    var onHistorySelected: (String) -> Void

    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(searchHistory, id: \.self) { term in
                Button(action: {
                    onHistorySelected(term)
                }) {
                    Text(term)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 5)
                }
                Divider()
            }
        }
        .border(Color.secondary, width: 0.5)
        .padding(.horizontal)
        
    }
}

struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownView(searchHistory: [], onHistorySelected: {_ in })
    }
}

struct FlickrSearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    @ObservedObject var viewModel: FlickrViewModel
    @FocusState private var isFouced: Bool
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search for images...", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isFouced)

                Button(action: onSearch) {
                    Text("Search")
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal)
           
            if isFouced && !viewModel.searchHistory.isEmpty {
                DropdownView(searchHistory: viewModel.searchHistory, onHistorySelected: { term in
                    self.text = term
                    self.onSearch()
                })
        
                .transition(.move(edge: .top))
                .animation(.easeIn, value: isFouced)
            }
        }
        .onTapGesture { /// Hide search history when tapped outside
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            isFouced.toggle()
        }
    }
}
