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
        //var newMsg = msg
        for i in 1...255
        {
            //determine the k value not for the actual hash, but for
            //the message plus an incrementing value.
            let extraByte = UInt8("\(0)", radix: 16)
            if extraByte != nil
            {
                print("appending extra byte.")
                //let scalar = UnicodeScalar(extraByte!)
                //newMsg//.append(UInt8(1))
                //.dataUsingEncoding(NSUTF8StringEncoding)!.bytesArray()
                //newMsg += scalar
            }
            let newMsg = NSMutableData(msg)//
            //newMsg.appendBytes([UInt8(0)], length: 1)
            newMsg.appendData("\u{00}".dataUsingEncoding(NSUTF8StringEncoding)!)
            let k = super.signatureNonceForHash(BTCSHA256(newMsg))
            let kNum = BTCMutableBigNumber(unsignedBigEndian: k)
            print("k: \(kNum)")
            //Now, sign the message using the original bytes, but the k value determined
            //from the message + incrementing byte
            return super.signatureForHash(BTCSHA256(NSData(msg)), kValue: k)
            
        }
        return nil
    }
    
}