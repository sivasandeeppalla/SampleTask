//
//  CategoryDBManager.swift
//  Sample
//
//  Created by siva sandeep on 06/09/19.
//  Copyright © 2019 kaha. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryDBManager: DBManager {
    static let shared = CategoryDBManager()
    func storeCaetgoryData(_ categoryModel: CategoryModel?) {
        guard let categoryModel = categoryModel else { return }
        if isAvailable(name: categoryModel.categoryName.lowercased()) {
            update(categoryModel)
        } else {
            store(categoryModel)
        }
    }
    
    func store(_ data: CategoryModel) {
        let categoryNamesObj = CategoryData()
        categoryNamesObj.name = data.categoryName
        categoryNamesObj.imageUrl = data.itemImageUrl
        categoryNamesObj.slug = data.categorySlug
        categoryNamesObj.data = data.imageData
        write {
            realm.add(categoryNamesObj)
            debugPrint("data added")
        }
    }
    
    func update(_ data: CategoryModel) {
         let categoryData = realm.objects(CategoryData.self).filter { $0.name.lowercased() == data.categoryName.lowercased() }
        if let category = categoryData.first {
            write {
                category.name = data.categoryName
                category.imageUrl = data.itemImageUrl
                category.slug = data.categorySlug
                category.data = data.imageData
                debugPrint("data updated")
            }
        }
    }
    
    func readAll() -> [CategoryModel]? {
        let categoryData = realm.objects(CategoryData.self)
        var categoryDataModel: [CategoryModel] = []
        for object in categoryData {
            let category = CategoryModel()
            category.categoryName = object.name
            category.categorySlug = object.slug
            category.itemImageUrl = object.imageUrl
            category.imageData = object.data
            categoryDataModel.append(category)
        }
        return categoryDataModel
    }
    
    
    
    func isAvailable(name: String) -> Bool {
        return realm.objects(CategoryData.self).filter { $0.name.lowercased() == name }.count > 0 ? true : false
    }
    
}

class CategoryData: Object {
    @objc dynamic var name = String()
    @objc dynamic var slug = String()
    @objc dynamic var imageUrl = String()
    @objc dynamic var data = Data()
}
