//
//  ImageDBManager.swift
//  Sample
//
//  Created by siva sandeep on 07/09/19.
//  Copyright © 2019 kaha. All rights reserved.
//

import UIKit
import RealmSwift

class ImageDBManager: DBManager {
    static let shared = ImageDBManager()

    func storeImageData(_ imgData: Data, name: String ) {
        if isAvailable(storeName: name) {
            update(imgData, name: name)
        } else {
            store(imgData, name: name)
        }
    }
    
    func store(_ data: Data, name: String) {
        let imgObj = ImageData()
        imgObj.name = name
        imgObj.imageData = data
        write {
            realm.add(imgObj)
            debugPrint("Image data added")
        }
    }
    
    func update(_ data: Data, name: String) {
        let detailData = realm.objects(ImageData.self).filter { $0.name.lowercased() == name.lowercased() }
        if let imgObj = detailData.first {
            write {
                imgObj.name = name
                imgObj.imageData = data
                debugPrint("data updated")
            }
        }
    }
    
    func readWith(name: String) -> Data? {
        let detail = realm.objects(ImageData.self).filter { $0.name.lowercased() == name.lowercased() }.first
        var imageData = detail?.imageData
        return imageData
     
    }
    
    func isAvailable(storeName: String) -> Bool {
        return realm.objects(ImageData.self).filter { $0.name.lowercased() == storeName.lowercased() }.count > 0 ? true : false
    }
}

class ImageData: Object {
    @objc dynamic var imageData = Data()
    @objc dynamic var name = String()
}
