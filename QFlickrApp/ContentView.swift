//
//  ContentView.swift
//  QFlickrApp
//
//  Created by Adam Essam on 09/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    let pageTitle = "Flickr Image Search"
    @StateObject private var viewModel = FlickrViewModel(networkManager: NetworkManager())
    @State private var searchTerm = ""
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            if viewModel.isLoading{
                ProgressView()
                    .controlSize(.large)
            } else {
                NavigationView {
                    VStack {
                        FlickrSearchBar(text: $searchTerm, onSearch: {
                            Task {
                                await viewModel.searchPhotos(searchTerm: searchTerm)
                            }
                        })
                        if viewModel.flickrImages.isEmpty {
                            Text("No Results, please search for images.")
                                .font(.title3)
                                .bold()
                                .frame(maxHeight: .infinity)
                        } else {
                            GeometryReader{ geometry in
                                let itemWidth = geometry.size.width * 0.5
                                let itemHeight = itemWidth * 0.75
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 10) {
                                        ForEach(viewModel.flickrImages) { photo in
                                            if let url = viewModel.getPhotoURL(photoObj: photo){
                                                AsyncImage(url: url) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .padding(3)
                                                        .frame(width: itemWidth, height: itemHeight)
                                                        .clipped()
                                                    
                                                } placeholder: {
                                                    Image(systemName: "photo.fill")
                                                        .resizable()
                                                        .frame(width: itemWidth, height: itemHeight)
                                                }
                                                .task {
                                                    if viewModel.hasReachedEnd(of: photo) && !viewModel.isFetching {
                                                        await viewModel.fetchMorePhotos(searchTerm: searchTerm)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .overlay(alignment: .bottom) {
                                    if viewModel.isFetching {
                                        ProgressView()
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    .navigationBarTitle(pageTitle)
                    
                }
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


