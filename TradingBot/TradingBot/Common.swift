//
//  Common.swift
//  DemoChargesScreen
//
//  Created by TradeSocio on 18/03/19.
//  Copyright © 2019 Tradesocio. All rights reserved.
//

import Foundation
import UIKit

class CommonConstants{
    //static let BASEURL = "https://tccoverage.fxsocio.com//webservices_new"
    static let BASEURL = "https://93a26797.ngrok.io/api"
}
class CommonAlert{
    
    class func commonAlert(vc : UIViewController, title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
