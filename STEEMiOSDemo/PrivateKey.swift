//
//  PrivateKey.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/13/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation

class PrivateKey: BTCKey
{
    
    func signatureForSTEEMMessage(msg: [UInt8]) -> NSData?
    {
        var newMsg = msg
        for i in 1...255
        {
            //determine the k value not for the actual hash, but for
            //the message plus an incrementing value.
            let extraByte = Int("\(i)", radix: 16)
            if extraByte != nil
            {
                print("appending extra byte.")
                let scalar = UnicodeScalar(extraByte!)
                newMsg += "\(scalar)".dataUsingEncoding(NSUTF8StringEncoding)!.bytesArray()
            }
            let k = super.signatureNonceForHash(BTCSHA256(NSData(newMsg)))
            
            //Now, sign the message using the original bytes, but the k value determined
            //from the message + incrementing byte
            return super.signatureForHash(BTCSHA256(NSData(msg)), kValue: k)
        }
        return nil
    }
    
}
