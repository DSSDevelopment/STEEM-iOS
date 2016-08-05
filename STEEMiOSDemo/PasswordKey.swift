//
//  PasswordKey.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/5/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation


class PasswordKey
{
    var account: Account!
    var password: String!
    var role: String!
    
    required init (account: Account, password: String, role: String = "active")
    {
        self.account = account
        self.password = password
        self.role = role
    }
    
    func getPrivateKey() -> String
    {
        let a: [UInt8] = typeToBytes("\(account)\(role)\(password)")
        let s = BTC256FromNSString("\(a)")
        let h = hexlify(NSDataFromBTC256(s))
        return h
    }
}