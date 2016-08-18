//
//  BrainKey.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/8/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation

class BrainKey
{
    /* Brainkey implementation similar to the graphene-ui web-wallet.
    
    :param str brainkey: Brain Key
    :param int sequence: Sequence number for consecutive keys
    
    Keys in Graphene are derived from a seed brain key which is a string of
    16 words out of a predefined dictionary with 49744 words. It is a
    simple single-chain key derivation scheme that is not compatible with
    BIP44 but easy to use.
    
    Given the brain key, a private key is derived as::
    
    privkey = SHA256(SHA512(brainkey + " " + sequence))
    
    Incrementing the sequence number yields a new key that can be
    regenerated given the brain key.
    
    */
    
    var brainkey: String!
    var sequence: Int!
    
    required init(brainkey: String?, sequence: Int)
    {
        if brainkey != nil
        {
            //TODO: string normalization function
            self.brainkey = brainkey
        }
        else
        {
            self.brainkey = suggest()
        }
        self.sequence = sequence
    }
    
    func getPrivate() -> String
    {
        let encoded = "\(brainkey) \(sequence)"
        let a = typeToBytes(encoded)
        let b = bytesToType(a, NSData.self)
        
        let s = BTCSHA256(BTCSHA512(b))
        return " " //Need PrivateKey class
    }
    
    private func next()
    {
        sequence = sequence + 1
    }
    
    
    private func suggest() -> String
    {
        /* Suggest a new random brain key. Randomness is provided by
         /dev/urandom.
        */
        let wordCount = 16
        var brainKey = [String]()
        let dictLines = words.componentsSeparatedByString(",")
        assert(dictLines.count == 49744, "Dictionary has been tampered with.")
        
        for i in 0 ..< wordCount
        {
        var array = [UInt8](count: 2, repeatedValue: 0)
        
        let fd = open("/dev/urandom", O_RDONLY)
        if fd != -1 {
            read(fd, &array, Int(sizeofValue(array) * array.count))
            let data = NSData(bytes: array, length:2)
            var u16: UInt16 = 0
            
            data.getBytes(&u16, length: 2)
            let rndMult = Int( pow(Double(u16 / 2), 16.0) )
            let wIdx = Int(round(Double(dictLines.count * rndMult)))
            brainKey[i] = dictLines[wIdx]
            
            close(fd)
            print(array)
            return brainKey.joinWithSeparator(" ").uppercaseString
            }
        }
        return ""
    }
    
    
}
