//
//  ViewController.swift
//  TradingBot
//
//  Created by TradeSocio on 31/05/19.
//  Copyright © 2019 Tradesocio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfUserName: UITextField!
    var objLogin : LoginModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tfUserName.layer.borderColor = UIColor.black.cgColor
        tfUserName.layer.borderWidth = 1.0
        btnLogin.layer.borderColor = UIColor.black.cgColor
        btnLogin.layer.borderWidth = 1.0
        self.navigationController?.navigationBar.isHidden = true
//        viewContainer.layer.borderColor = UIColor.black.cgColor
//        viewContainer.layer.borderWidth = 1.0
    }

    @IBAction func btnLoginAction(_ sender: Any) {
        
        let params = ["username" : tfUserName.text ?? ""] as [String : Any]
        BaseNetwork.parse(endPoint: "/user/login", dataToPost: params, header: [:], instanceTypeToBeDecoded: objLogin) { (modelLogin) in
            if (modelLogin?.status ?? 0) == 1 {
                
                let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                chatVC.username = self.tfUserName.text ?? ""
                self.tfUserName.text = ""
                self.navigationController?.pushViewController(chatVC, animated: true)
                
            }
            else{
                CommonAlert.commonAlert(vc: self, title: "Warning", message: modelLogin?.msg ?? "")
            }
        }
    }
    
}

