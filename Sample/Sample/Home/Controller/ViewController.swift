//
//  ViewController.swift
//  Sample
//
//  Created by siva sandeep on 05/09/19.
//
//

import UIKit
import SDWebImage
class ViewController: BaseVC {
    static let InternetOffline = "Internet seems to be offline..."
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    var selectedIndex = 0
    var homeVM = HomeViewModel()
    @IBOutlet weak var noDataimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    func bindViewModel() {
        homeVM.homeDelegate = self
        if Connectivity.isConnectedToNetwork() {
             showLoaderWithStatus("Loading Categories...")
             homeVM.getCategoriesFromServer()
        } else {
            homeVM.readCateogryNamesFromDB()
            showErrorMessage(ViewController.InternetOffline)
        }
      
    }
}

extension ViewController: HomeVMProtocol {
    func responseForCategoryDetailsFromServer(_ status: Bool, category: [CategoryDetailDataModel], offLine: Bool) {
        if status {
            debugPrint("details list \(homeVM.categoryDetailsModel.categoryDetailModels)")
            DispatchQueue.main.async {
                self.dismissLoader()
                if category.count == 0 {
                    self.detailCollectionView.isHidden = true
                    self.noDataimage.isHidden = false
                } else {
                    self.detailCollectionView.isHidden = false
                    self.noDataimage.isHidden = true
                }
                self.detailCollectionView.reloadData()
            }
        } else {
            debugPrint("error in parsing")
        }
    }
    
    func responseForCategoryFromServer(_ status: Bool, category: [CategoryModel], offLine: Bool) {
        debugPrint("status is \(status)")
        if status {
            debugPrint("success response \(category)")
            if category.count > 0 {
                let slugName = category[0].categorySlug
                if Connectivity.isConnectedToNetwork() {
                    showLoaderWithStatus("Loading \(slugName.capitalized) List...")
                    homeVM.getCategoryDetailList(slugName)
                } else {
                    if offLine {
                        homeVM.readItemsListWithName(slugName)
                    } else {
                        showErrorMessage(ViewController.InternetOffline)
                    }
                }
                DispatchQueue.main.async {
                    self.selectedIndex = 0
                    self.categoryCollectionView.reloadData()
                }
            }
            
        } else {
            debugPrint("error in parsing")
        }
    }
  
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return homeVM.categoryList.count
        } else if collectionView == detailCollectionView {
            return homeVM.itemsList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionCell else {
                return UICollectionViewCell()
            }
            if selectedIndex == indexPath.item {
                cell.underLine.isHidden = false
            } else {
                cell.underLine.isHidden = true
            }
            cell.cellTittleLbl.text = homeVM.categoryList[indexPath.item].categoryName.capitalized
            let imgUrl = homeVM.categoryList[indexPath.item].itemImageUrl
            if Connectivity.isConnectedToNetwork() {
                 cell.cellImageView.sd_setImage(with: URL(string: imgUrl) , placeholderImage: UIImage(), options: .cacheMemoryOnly, completed: nil)
                homeVM.storeImage(cell.cellImageView.image ?? UIImage(), name:homeVM.categoryList[indexPath.item].categoryName.lowercased())
            } else {
                let data = homeVM.retriveImage(homeVM.categoryList[indexPath.item].categoryName.lowercased())
                cell.cellImageView.image = UIImage(data: data )
            }
           
            return cell
        } else  if collectionView == detailCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellId", for: indexPath) as? DetailCollectionViewcell  else {
                return UICollectionViewCell()
            }
            let singleItem = homeVM.itemsList[indexPath.item]
            cell.nameLbl.text = singleItem.storeName
            cell.offerLbl.text = singleItem.offer
            let imgUrl = singleItem.logo
            if Connectivity.isConnectedToNetwork() {
                  cell.cellImage.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(), options: .cacheMemoryOnly, completed: nil)
                  homeVM.storeImage(cell.cellImage.image ?? UIImage(), name:singleItem.storeName.lowercased())
            } else {
                  let data = homeVM.retriveImage(singleItem.storeName.lowercased())
                cell.cellImage.image = UIImage(data: data )
            }
          
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            selectedIndex = indexPath.item
            if Connectivity.isConnectedToNetwork() {
                let slugName = homeVM.categoryList[indexPath.item].categorySlug
                showLoaderWithStatus("Loading \(slugName.capitalized) List...")
                homeVM.getCategoryDetailList(slugName)
                homeVM.categoryDetailsModel.categoryDetailModels.removeAll()
                DispatchQueue.main.async {
                    self.detailCollectionView.reloadData()
                    self.categoryCollectionView.reloadData()
                }
            } else {
                showErrorMessage(ViewController.InternetOffline)
                let slugName = homeVM.categoryList[indexPath.item].categorySlug
                homeVM.readItemsListWithName(slugName)
                DispatchQueue.main.async {
                    self.detailCollectionView.reloadData()
                    self.categoryCollectionView.reloadData()
                }
            }
        }
      
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: collectionView.bounds.width/3, height: 50)
        } else if collectionView == detailCollectionView {
            return CGSize(width: collectionView.bounds.width/2, height: 200)
        }
        return CGSize(width: 0, height: 0)

    }
}
