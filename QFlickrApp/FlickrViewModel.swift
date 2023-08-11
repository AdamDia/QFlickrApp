//
//  FlickrViewModel.swift
//  QFlickrApp
//
//  Created by Adam Essam on 09/08/2023.
//

import Foundation

class FlickrViewModel: ObservableObject {
    @Published private(set) var flickrImages: [Photo] = []
    @Published private(set) var viewState: ViewState?
    @Published var alertItem: AlertItem?
    private(set) var page = 1
    private(set) var totalPages: Int?
    
    private let userDefaults = UserDefaults.standard
    private let searchHistoryKey = "SearchHistory"
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol) {
        self.networkManager = networkManager
        loadSearchHistory()
    }
    
    @MainActor
    func searchPhotos(searchTerm: String) async{
        reset()
        viewState = .loading
        defer { viewState = .finished }
        do {
            updateSearchHistory(searchTerm: searchTerm)
            let response = try await networkManager.searchFlickrPhotos(searchTerm: searchTerm, page: page)
            self.totalPages = response.pages
            self.flickrImages = response.photo
        } catch {
            handleAPIError(error)
        }
    }
    
    @MainActor
    func fetchMorePhotos(searchTerm: String) async{
        
        guard page != totalPages else { return }
        viewState = .fetching
        defer { viewState = .finished }
        page += 1
        
        do {
            let response = try await networkManager.searchFlickrPhotos(searchTerm: searchTerm, page: page)
            self.totalPages = response.pages
            self.flickrImages.append(contentsOf: response.photo)
        } catch {
            handleAPIError(error)
        }
    }
    
    @Published private(set) var searchHistory: [String] = []
    func addToSearchHistory(_ searchTerm: String) {
        /// check for duplicate terms
        if !searchHistory.contains(searchTerm) {
            searchHistory.insert(searchTerm, at: 0)
            
            /// Limit the search history to 5 items
            if searchHistory.count > 5 {
                searchHistory.removeLast()
            }
            saveSearchHistory()
        }
    }
    private func updateSearchHistory(searchTerm: String) {
        addToSearchHistory(searchTerm)
    }
    
    
    func loadSearchHistory() {
        if let historyData = userDefaults.data(forKey: searchHistoryKey) {
            do {
                 searchHistory = try JSONDecoder().decode([String].self, from: historyData)
            } catch {
                print("Error loading search history: \(error)")
            }
        }
    }
    
    func clearSearchHistory() {
        searchHistory.removeAll()
        saveSearchHistory()
    }
    private func saveSearchHistory() {
        do {
            let historyData = try JSONEncoder().encode(searchHistory)
            userDefaults.set(historyData, forKey: searchHistoryKey)
        } catch {
            print("Error saving search history: \(error)")
        }
    }
    
    func getPhotoURL(photoObj: Photo) -> URL? {
        let urlString = "https://farm\(photoObj.farm).static.flickr.com/\(photoObj.server)/\(photoObj.id)_\(photoObj.secret).jpg"
        return URL(string: urlString)
    }
    
    private func handleAPIError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidURL:
                alertItem = AlertContext.invalidURL
            case .invalidResponse:
                alertItem = AlertContext.invalidResponse
            case .invalidData:
                alertItem = AlertContext.invalidData
            }
        } else {
            alertItem = AlertContext.invalidData
        }
    }
    
    func hasReachedEnd(of photo: Photo) -> Bool{
        return flickrImages.last?.id == photo.id
    }
}

private extension FlickrViewModel {
    func reset() {
        if viewState == .finished {
            flickrImages.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
}

extension FlickrViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

