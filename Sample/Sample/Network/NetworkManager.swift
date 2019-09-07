//
//  NetworkManager.swift
//  sample
//
//  Created by siva sandeep on 05/09/19.
//  Copyright © 2019 siva sandeep. All rights reserved.
//


import Foundation
import UIKit

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    func getDatafromUrl(_  url: String, completionHandler: @escaping (Data?, URLResponse?, NSError?) -> Void) {
        DispatchQueue.main.async {
           // AppDelegate.startAnimation()
        }
        let getUrl = URL(string: url)
        var request = URLRequest(url: getUrl!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            completionHandler(data, response, error as NSError?)
            DispatchQueue.main.async {
               // AppDelegate.hideIndicator()
            }
        }
        task.resume()
    }

    func postDataTourl(_  url: String, body: [String:Any], completionHandler: @escaping (Data?, URLResponse?, NSError?) -> Void) {
        DispatchQueue.main.async {
            // AppDelegate.startAnimation()
        }
        do {
            let headers = ["lat":"12.9716","lng":"77.5946", "usrtoken":"74c14fa62349c91c67607d8382656c431eb8e0b6-084e0343a0486ff05530df6c705c8bb4"]
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            let posturl = URL(string: url)
            var request = URLRequest(url: posturl!)
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                completionHandler(data, response, error as NSError?)
                DispatchQueue.main.async {
                    // AppDelegate.hideIndicator()
                }
            }
            task.resume()
            
        } catch {
            print(error.localizedDescription)
        }
       
    }
    
    
    func showAlert(_ actionMessage : String) -> UIAlertController {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: actionMessage, message: "", preferredStyle: .alert)
        // Initialize Actions
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
        }
        // Add Actions
        alertController.addAction(okAction)
        return alertController
        
    }
    

}
