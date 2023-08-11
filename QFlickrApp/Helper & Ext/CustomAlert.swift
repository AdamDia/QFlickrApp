//
//  CustomAlert.swift
//  QFlickrApp
//
//  Created by Adam Essam on 10/08/2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    //MARK: - Network Alerts
    static let invalidData = AlertItem(title: Text("Server Error"),
                                              message: Text("The data received from the server was invalid. Please contact support"),
                                              dismissButton: .default(Text("Ok")))
    
    static let invalidResponse = AlertItem(title: Text("Server Error"),
                                              message: Text("Invalid response from the server. Please contact support"),
                                              dismissButton: .default(Text("Ok")) )
    
    static let invalidURL = AlertItem(title: Text("Server Error"),
                                              message: Text("There is an issue connecting to the server if this persists. Please contact support"),
                                              dismissButton: .default(Text("Ok")) )
}
