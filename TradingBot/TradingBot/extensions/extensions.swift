//
//  extensions.swift
//  DemoChargesScreen
//
//  Created by TradeSocio on 07/05/19.
//  Copyright © 2019 Tradesocio. All rights reserved.
//

import Foundation
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
