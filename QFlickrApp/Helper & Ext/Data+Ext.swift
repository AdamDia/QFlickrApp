//
//  Data+Ext.swift
//  QFlickrApp
//
//  Created by Adam Essam on 10/08/2023.
//

import Foundation

extension Data {
    func jsonToString(){
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []), let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]), let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return }
        let randomNumber = Int.random(in: 101..<200)
        print("\(randomNumber)------------------------ START START START START START START START START START START START ------------------------")
        print("\(prettyPrintedString)")
        print("\(randomNumber)------------------------ END END END END END END END END END END END END END END END END ------------------------")
    }
    
    var hexString: String {
           let hexString = map { String(format: "%02.2hhx", $0) }.joined()
           return hexString
       }
}
