//
//  CategoryDetailModel.swift
//  Sample
//
//  Created by siva sandeep on 06/09/19.
//  Copyright © 2019 kaha. All rights reserved.
//

import UIKit
class CategoryDetailDataModel: NSObject {
    var storeName = ""
    var offer = ""
    var logo = ""
    var storeId = ""
    var slugname = ""
    var imageData = Data()
    
}
class CategoryDetailModel: NSObject {
    var categoryDetailModels = [CategoryDetailDataModel]()
    func assignDataToModel(_ response: [String: Any]) {
        var slugName = ""
        if response.keys.contains("category") {
            guard let slugArray = response["category"] as? [[String: Any]] else {
                return
            }
            if slugArray.count > 0 {
                guard let slugDict = slugArray[0] as? [String: Any] else {
                    return
                }
                guard let slugNm = slugDict["category_slug"] as? String else { return }
                slugName = slugNm
            }
        }
        if response.keys.contains("data") {
            guard let categoryList = response["data"] as? [[String: Any]] else {
                return
            }
            if categoryList.count > 0 {
                categoryDetailModels.removeAll()
                for index in 0..<categoryList.count {
                    let individualItem = categoryList[index]
                    guard let offer = individualItem["offer"] as? String else { return }
                    guard let name = individualItem["store_name"] as? String else { return }
                    guard let imageUrl = individualItem["logo"] as? String else { return }
                    guard let storeCode = individualItem["store_code"] as? String else {
                        return
                    }
                    //let data = URL(string: imageUrl)?.convertURlToData()
                    let data = Data()
                    let model = CategoryDetailDataModel()
                    model.storeName = name
                    model.offer = offer
                    model.logo = imageUrl
                    model.storeId = storeCode
                    model.slugname = slugName
                    model.imageData = data ?? Data()
                    categoryDetailModels.append(model)
                }
            } else {
                debugPrint("empty response")
            }
            
        } else {
            debugPrint("error")
        }
        
    }
}
