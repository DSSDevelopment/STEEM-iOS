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
    // If signatureForHash isn't finding canonical signatures, we add a larger byte
    // to the end of the digest and try again. The chance of BTCKey failing this
    // many times is astronomical.
    let incrementingBytes = ["\u{01}", "\u{02}", "\u{03}", "\u{04}", "\u{05}", "\u{06}", "\u{07}", "\u{08}", "\u{09}", "\u{0a}", "\u{0b}", "\u{0c}", "\u{0d}", "\u{0e}", "\u{0f}", "\u{10}", "\u{11}", "\u{12}", "\u{13}", "\u{14}", "\u{15}", "\u{16}", "\u{17}", "\u{18}", "\u{19}", "\u{1a}",]
    
    func signatureForSTEEMMessage(msg: NSData) -> NSData?
    {
        for b in incrementingBytes
        {
        let newMsg = msg.mutableCopy()//
        newMsg.appendData(b.dataUsingEncoding(NSUTF8StringEncoding)!)
        print("Final Message: \(hexlify(newMsg.copy() as! NSData))")
        let k = super.signatureNonceForHash(BTCSHA256(newMsg.copy() as! NSData))
        let kNum = BTCMutableBigNumber(unsignedBigEndian: k)
        print("k: \(kNum)")
    
        //Now, sign the message using the original bytes, but the k value determined
        //from the message + incrementing byte
            let sig = super.signatureForHash(NSData(data: msg), kValue: k)
            if sig != nil
            {
                //let rparam = calculateRecoveryParameter(sig, hash: NSData(data: msg))
                let finalSig = attachRecoveryParameter(sig, hash: NSData(data:msg))
                return finalSig
            }
        }
        return nil
    }
    
    func stripDERFormatting(signature: NSData) -> (r: NSData, s:NSData)
    {
        let r = signature.subdataWithRange(NSRange(location: 4, length: 32))
        let s = signature.subdataWithRange(NSRange(location:38, length: 32))
        return(r, s)
    }
    
    func attachRecoveryParameter(sig: NSData, hash: NSData) -> NSData
    {
        //ECDSA_SIG_recover_key_GFp(key->_key, sig, (unsigned char*)hash.bytes, (int)hash.length, rec, 0)
        let sigComponents = stripDERFormatting(sig)
        let reid = self.recoveryParameterForKey(self.compressedPublicKey.copy() as! NSData, withSignatureR: hexlify(sigComponents.0), andSignatureS: hexlify(sigComponents.1), andHash: hash)
        let revalue = reid + 4 + 24
        print("revalue: \(revalue)")
        let rebyte = unhexlify(String(format:"%2x", revalue))
 
        let predata = NSMutableData()
        predata.appendData(rebyte!)
        predata.appendData(sigComponents.0)
        predata.appendData(sigComponents.1)

        return predata
    }
    
}
