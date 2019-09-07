//
//  HomeDataModel.swift
//  Sample
//
//  Created by siva sandeep on 05/09/19.
//  Copyright © 2019 kaha. All rights reserved.
//

import UIKit

class CategoryModel: NSObject {
    var categorySlug = ""
    var categoryName = ""
    var itemImageUrl = ""
    var imageData = Data()
  
}

class HomeDataModel: NSObject {
    var categoryModelsList = [CategoryModel]()

    func assignDataToModel(_ response: [String: Any]) {
        if response.keys.contains("categories") {
            guard let categoryList = response["categories"] as? [[String: Any]] else {
                return
            }
            if categoryList.count > 0 {
                categoryModelsList.removeAll()
                for index in 0..<categoryList.count {
                    let individualItem = categoryList[index]
                    guard let slug = individualItem["category_slug"] as? String else { return }
                    guard let name = individualItem["bcategory_name"] as? String else { return }
                    guard let imageUrl = individualItem["icon"] as? String else { return }
                   // let data = URL(string: imageUrl)?.convertURlToData()
                   // imageUrl.downloaded(from: imageUrl, contentMode: .scaleAspectFit)
                    let data = Data()
                    let model = CategoryModel()
                    model.categoryName = name
                    model.categorySlug = slug
                    model.itemImageUrl = imageUrl
                    model.imageData = data ?? Data()
                    categoryModelsList.append(model)
                }
            } else {
                debugPrint("empty response")
            }
        }
    }
    
}

extension URL {
    
    func convertURlToData() -> Data {
        do {
            let imageData = try Data(contentsOf: self)
            return imageData
        } catch {
            print("Unable to load data: \(error)")
        }
        return Data()
    }
}

extension String {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }
            DispatchQueue.main.async() {
               
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
