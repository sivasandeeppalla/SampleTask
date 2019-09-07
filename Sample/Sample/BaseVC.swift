//
//  BaseVC.swift
//  Sample
//
//  Created by siva sandeep on 05/09/19.
//  Copyright © 2019 kaha. All rights reserved.
//

import UIKit
import SVProgressHUD
class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showLoaderWithStatus(_ messgae: String ) {
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: messgae)
        }
    }
    
    func dismissLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }

    
    func showSuccessMessage(_ message: String ) {
        DispatchQueue.main.async {
            SVProgressHUD.showSuccess(withStatus: message)
        }
    }
    
    func showErrorMessage(_ error: String? ) {
        DispatchQueue.main.async {
            SVProgressHUD.showError(withStatus: error ?? "Error")
        }
    }
    
    func showInfoMessage(_ info: String ) {
        DispatchQueue.main.async {
            SVProgressHUD.showInfo(withStatus: info)
        }
    }
}
