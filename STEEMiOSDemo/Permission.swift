//
//  Permission.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/13/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation

class Permission : GrapheneObject
{
    var authKeys: [(String, Int)]?
    var authAccounts: [(String, Int)]?
    
    required init(keyAuths: [(String, Int)], accountAuths: [(String, Int)], weightThreshold: UInt32)
    {
        super.init()
        authKeys = keyAuths.sort({ (s1: (key: String, num: Int), s2: (key: String, num: Int)) -> Bool in
            //sort the keys using the hexadecimal representation of their first byte
            //after hashing
            let hashS1 = PublicKey(publicKey: s1.key.dataUsingEncoding(NSUTF8StringEncoding))!
            let hashS2 = PublicKey(publicKey: s2.key.dataUsingEncoding(NSUTF8StringEncoding))!

            let ptr1 = UnsafeMutablePointer<Int>.alloc(hashS1.uncompressedPublicKey.length)
            var buf1 = UnsafeMutableBufferPointer(start: ptr1, count:hashS1.uncompressedPublicKey.length)

            let ptr2 = UnsafeMutablePointer<Int>.alloc(hashS2.uncompressedPublicKey.length)
            var buf2 = UnsafeMutableBufferPointer(start: ptr2, count:hashS2.uncompressedPublicKey.length)
            
            hashS1.uncompressedPublicKey.getBytes(&buf1, length: 1)
            hashS2.uncompressedPublicKey.getBytes(&buf2, length: 1)
            
            return buf1[0] > buf2[0]
        })
        authAccounts = accountAuths
        data = OrderedDictionary<String,String>()
        if authKeys != nil
        {
            for e in authKeys!
            {
                let newElem = (e.0, "\(e.1)")
                data?.insertElement(newElem, atIndex: data!.endIndex)
            }
        }
        
        if authAccounts != nil
        {
            for e in authAccounts!
            {
                let newElem = (e.0, "\(e.1)")
                data?.insertElement(newElem, atIndex: data!.endIndex)
            }
        }
        
        
    }
}
