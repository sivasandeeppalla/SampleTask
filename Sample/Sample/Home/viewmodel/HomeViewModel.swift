//
//  HomeViewModel.swift
//  Sample
//
//  Created by siva sandeep on 05/09/19.
//  Copyright © 2019 kaha. All rights reserved.
//

import UIKit
protocol HomeVMProtocol {
    func responseForCategoryFromServer(_ status: Bool, category: [CategoryModel], offLine: Bool)
    func responseForCategoryDetailsFromServer(_ status: Bool, category: [CategoryDetailDataModel], offLine: Bool)

}

class HomeViewModel: NSObject {
    let homeDataModel = HomeDataModel()
    let categoryDetailsModel = CategoryDetailModel()
    var homeDelegate: HomeVMProtocol!
    let categoryDbManager = CategoryDBManager.shared
    let detailDBManager = DetailsDBManager.shared
    let imageDBManager = ImageDBManager.shared

    var categoryList = [CategoryModel]()
    var itemsList = [CategoryDetailDataModel]()

    func getCategoriesFromServer() {
        ApiManager.getCategoriesFromServer({ (response, status) in
            if status ?? false {
                self.homeDataModel.assignDataToModel(response ?? ["":""])
                self.categoryList = self.homeDataModel.categoryModelsList
                self.storeCategoryListInDB()
                self.homeDelegate.responseForCategoryFromServer(status ?? false, category: self.categoryList, offLine: false)
            } else {
                self.homeDelegate.responseForCategoryFromServer(false, category: self.categoryList, offLine: false)
            }
        })
    }
    
    func getCategoryDetailList(_ slugName: String) {
        ApiManager.getCategoryDetailList(slugName) { (response, status) in
            if status ?? false {
                self.categoryDetailsModel.assignDataToModel(response ?? ["":""])
                self.storeDetailListInDB()
                self.itemsList = self.categoryDetailsModel.categoryDetailModels
                self.homeDelegate.responseForCategoryDetailsFromServer(status ?? false, category: self.itemsList, offLine: false)

            } else {
                self.homeDelegate.responseForCategoryDetailsFromServer(false, category: self.itemsList, offLine: false)
            }
        }
    }

    
    func storeCategoryListInDB() {
        guard let count = self.homeDataModel.categoryModelsList.count as? Int else { return }
        for index in 0..<count {
            let obj = self.homeDataModel.categoryModelsList[index]
            categoryDbManager.storeCaetgoryData(obj)
        }
    }
    
    func storeDetailListInDB() {
        guard let count = self.categoryDetailsModel.categoryDetailModels.count as? Int else { return }
        for index in 0..<count {
            let obj = self.categoryDetailsModel.categoryDetailModels[index]
            detailDBManager.storeDetailList(obj)
        }
    }
    
    func readCateogryNamesFromDB() {
      let models =  categoryDbManager.readAll()
        self.categoryList = models ?? [CategoryModel]()
        self.homeDelegate.responseForCategoryFromServer(true, category: self.categoryList, offLine: true)
    }
    
    func readItemsListWithName(_ name: String) {
        let models =  detailDBManager.readWith(name: name)
        self.itemsList = models ?? [CategoryDetailDataModel]()
        self.homeDelegate.responseForCategoryDetailsFromServer(true, category: self.itemsList, offLine: true)
    }
    
    
    func storeImage(_ img: UIImage, name:String) {
        let data = NSData(data: img.pngData() ?? Data())
        imageDBManager.storeImageData(data as Data, name: name)
    }
    
    func retriveImage(_ name: String) -> Data {
        guard let data =  imageDBManager.readWith(name: name) else { return Data() }
        return data
    }
}
