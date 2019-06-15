//
//  Token.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 30/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import Foundation

public class Token {
    
    static let newToken = "pk_0edeb80249f64c679daefb77e6b576f4"
    static let testToken = "Tpk_0929897a70334ba0b67d963c8ff14ca0"
    
    func testURL(symbol: String, info: String) -> String {
        
        var url = ""
        url = "https://sandbox.iexapis.com/stable/stock/" + symbol + info + "/quote?token=" + Token.testToken
        return url
    }
    
}
