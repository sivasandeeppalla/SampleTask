//
//  ApiManager.swift
//  helloWorld
//
//  Created by siva sandeep on 25/07/19.
//  Copyright © 2019 siva sandeep. All rights reserved.
//

import UIKit

class ApiManager: NSObject {

    static func getCategoriesFromServer(_ completionHandler: @escaping ([String: Any]?, Bool?) -> Void) {
        let url = UrlConstants.baseUrl+UrlConstants.categoriesUrl
        NetworkManager.shared.postDataTourl(url, body: [:]) { (data, reponse, error) in
            let jsonObj = ApiManager.dataToJson(data: data ?? Data() )
            guard let result = jsonObj as? [String: Any] else {
                completionHandler(["":""], false)
                return
            }
            completionHandler(result, true)
        }
     
    }
    
    static func getCategoryDetailList(_ slugName:String, completionHandler: @escaping ([String: Any]?, Bool?) -> Void) {
        let url = UrlConstants.baseUrl+slugName
        NetworkManager.shared.postDataTourl(url, body: [:]) { (data, reponse, error) in
            let jsonObj = ApiManager.dataToJson(data: data ?? Data() )
            guard let result = jsonObj as? [String: Any] else {
                completionHandler(["":""], false)
                return
            }
            completionHandler(result, true)
        }
        
    }
    
}

extension ApiManager {
    class  func dataToJson(data: Data) -> AnyObject? {
        do {
            // mutable containers
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
  
}
