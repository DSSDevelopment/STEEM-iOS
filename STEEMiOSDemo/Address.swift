//
//  Address.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/8/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation

class Address
{
    var address: String?
    var pubkey: String?
    var prefix: String!
    
    required init (address: String?, pubkey: String?, prefix: String = "BTS")
    {
        self.prefix = prefix
        if pubkey != nil
        {
            // TODO: Base58 Needs to take the prefix as an argument
            // and deal with it properly.
            self.pubkey = encode(typeToBytes(pubkey!))
            self.address = nil
        }
        else if address != nil
        {
            self.pubkey = nil
            self.address = encode(typeToBytes(address!))
        }
        else
        {
            assertionFailure("Address has to be initialized with either the pubkey OR the address.")
        }
    }
    
    func deriveSHA256() -> String
    {
        // Derive address using ``RIPEMD160(SHA256(x))``
        if let pkbin = unhexlify(pubkey!) where pubkey != nil
        {
            let addressbin = BTCRIPEMD160( hexlify(NSDataFromBTC256(BTC256FromNSData(pkbin))).dataUsingEncoding(NSASCIIStringEncoding) )
            
            return encode(typeToBytes(hexlify(addressbin)))
        }
        
        return " "
    }
    
    func deriveSHA512() -> String
    {
        // Derive address using ``RIPEMD160(SHA512(x))``
        if let pkbin = unhexlify(pubkey!) where pubkey != nil
        {
            let addressbin = BTCRIPEMD160( hexlify(NSDataFromBTC512(BTC512FromNSData(pkbin))).dataUsingEncoding(NSASCIIStringEncoding) )
            
            return encode(typeToBytes(hexlify(addressbin)))
        }
        return " "
    }
    
    func formatAsString(useBTCFormat: Bool) -> String
    {
        if address == nil
        {
            if useBTCFormat
            {
                return deriveSHA256()
            }
            else
            {
                return deriveSHA512()
            }
        }
        else
        {
            return address!
        }
     
    }
}
