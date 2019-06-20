
//
//  ChatModel.swift
//  TradingBot
//
//  Created by TradeSocio on 31/05/19.
//  Copyright © 2019 Tradesocio. All rights reserved.
//

import Foundation
struct ChatModel : Decodable{
    var status : Int?
    var options : [String]?
    var isMine : Int?
    var msg : String?
    var portfolio : [ObjPortfolioModel]?
}

struct ObjPortfolioModel : Decodable{
    var symbol : String?
    var percAlloc : Float?
}

