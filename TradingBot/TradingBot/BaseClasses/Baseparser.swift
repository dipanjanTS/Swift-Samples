//
//  Baseparser.swift
//  KolkataMeat
//
//  Created by Admin on 22/09/18.
//  Copyright © 2018 dipanjan. All rights reserved.
//

import Foundation
import UIKit
class Baseparser{
    
    class func postURLRequest( endPoint : String, params : [String: Any], header : [String : String], completion: @escaping (Bool, Data?, Error?) -> Void)
    {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let url = "\(CommonConstants.BASEURL)\(endPoint)"
        let urlStr = url.removingWhitespaces()
        if params.isEmpty{
            print("\n \n Api hitting ===>>>",urlStr)
            print("\n \n HEADER ===>>>",header)
            let myURL = URL(string: urlStr)
            let mysession = URLSession.shared
            let mytask = mysession.dataTask(with: myURL!) { (data, response, error) in
                if error != nil
                {
                    print(error ?? "error")
                    DispatchQueue.main.async {
                        completion(false, nil, error )
                    }
                }
                else
                {   DispatchQueue.main.async {
                    completion(true, data, nil)
                    }
                }
            }
            mytask.resume()
        }
        else{
            print("\n \n Api hitting ===>>>",urlStr)
            print("\n \n HEADER ===>>>",header)
            var myurlRQSt = URLRequest(url: URL(string: urlStr)!)
            for field in header.keys {
                myurlRQSt.addValue(header[field]!, forHTTPHeaderField: field)
                print("\n \n header field ===>>>",field)
                print("\n \n header value ===>>>",header[field] ?? "None")
            }
            myurlRQSt.httpMethod = "POST"
            var strParams = String()
            for i in params{
                strParams = strParams + "\(i.key)=\(i.value)"
                strParams = strParams + "&"
            }
            print("\n \n parameters for post ===>>>", strParams)
//            var jsonDataToPost = Data()
//            do{
//                 jsonDataToPost = try JSONSerialization.data(withJSONObject: params)
//            }
//            catch let err{
//                print("parameter encoding error ===>>>",err)
//            }
            myurlRQSt.httpBody = strParams.data(using: String.Encoding.utf8)
            //myurlRQSt.httpBody = jsonDataToPost//dataToPost.data(using: String.Encoding.utf8)
            let mysession = URLSession.shared
            let mytask = mysession.dataTask(with: myurlRQSt) { (data, response, error) in
                if error != nil
                {
                    print(error ?? "error")
                    DispatchQueue.main.async {
                        completion(false, nil, error )
                    }
                }
                else
                {   DispatchQueue.main.async {
                    completion(true, data, nil)
                    }
                }
            }
            mytask.resume()
        }
        }
        
    
}
