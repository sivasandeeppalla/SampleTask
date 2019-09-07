//
//  DetailsDBManager.swift
//  Sample
//
//  Created by siva sandeep on 06/09/19.
//  Copyright © 2019 kaha. All rights reserved.
//

import UIKit
import RealmSwift
class DetailsDBManager: DBManager {
    static let shared = DetailsDBManager()
    func storeDetailList(_ detailModel: CategoryDetailDataModel?) {
        guard let detailModel = detailModel else { return }
        if isAvailable(storeId: detailModel.storeId.lowercased()) {
            update(detailModel)
        } else {
            store(detailModel)
        }
    }
    
    func store(_ data: CategoryDetailDataModel) {
        let detailObj = DetailData()
        detailObj.name = data.storeName
        detailObj.imageUrl = data.logo
        detailObj.offer = data.offer
        detailObj.storeId = data.storeId
        detailObj.slugName = data.slugname
        detailObj.imageData = data.imageData
        write {
            realm.add(detailObj)
            debugPrint("data added")
        }
    }
    
    func update(_ data: CategoryDetailDataModel) {
        let detailData = realm.objects(DetailData.self).filter { $0.storeId.lowercased() == data.storeId.lowercased() }
        if let detailObj = detailData.first {
            write {
                detailObj.name = data.storeName
                detailObj.imageUrl = data.logo
                detailObj.offer = data.offer
                detailObj.storeId = data.storeId
                detailObj.slugName = data.slugname
                detailObj.imageData = data.imageData
                debugPrint("data updated")
            }
        }
    }
    
    func readWith(name: String) -> [CategoryDetailDataModel]? {
        let detail = realm.objects(DetailData.self).filter { $0.slugName.lowercased() == name.lowercased() }
        var categoryDetailDataModel: [CategoryDetailDataModel] = []
        for object in detail {
            let category = CategoryDetailDataModel()
           category.storeName = object.name
            category.logo = object.imageUrl
            category.offer = object.offer
            category.imageData = object.imageData
            categoryDetailDataModel.append(category)
        }
        return categoryDetailDataModel
    }
    
    func isAvailable(storeId: String) -> Bool {
        return realm.objects(DetailData.self).filter { $0.storeId.lowercased() == storeId }.count > 0 ? true : false
    }
}


class DetailData: Object {
    @objc dynamic var name = String()
    @objc dynamic var offer = String()
    @objc dynamic var imageUrl = String()
    @objc dynamic var slugName = String()
    @objc dynamic var storeId = String()
    @objc dynamic var imageData = Data()

}
