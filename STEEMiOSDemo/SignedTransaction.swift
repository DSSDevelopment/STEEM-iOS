//
//  SignedTransaction.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/14/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation

class SignedTransaction: GrapheneObject, Encodable
{
    var refNum: UInt16?
    var refPrefix: UInt32?
    var expiration: String?
    var operations: [Operations]?
    var signatures: [[UInt8]] = [[UInt8]]()
    var extensions: [String] = [String]()
    var message: NSData?
    var digest: NSMutableData?
    
    required init(refNum: UInt16, refPrefix: UInt32, expiration: String, operations: [Operations], signatures: [[UInt8]]?, extensions: [String]?)
    {
        self.operations = operations
        if signatures != nil
        {
            self.signatures = signatures!
        }
        
        if extensions != nil
        {
            self.extensions = extensions!
        }
        
        self.refNum = refNum
        self.refPrefix = refPrefix
        self.expiration = expiration
        
        super.init()
        //let opString = "=====> comment {'author': 'densmirnov', 'body': 'nice nickname', 'json_metadata': '{'tags':['steem']}', 'parent_author': 'steemiscrap', 'parent_permlink': 're-cryptorune-steem-dollar-poloniex-pump-is-a-arbitrage-goldmine-20160719t133438897z', 'permlink': 're-steemiscrap-re-cryptorune-steem-dollar-poloniex-pump-is-a-arbitrage-goldmine-20160719t133602671z', 'title': ''}"
        
        
        self.data16 = OrderedDictionary(dictionaryLiteral:
            ("ref_block_num", refNum)
        )
        
        self.data32 = OrderedDictionary(dictionaryLiteral:
            ("ref_block_prefix", refPrefix),
            ("expiration", UInt32(NSDate.dateFromISOString(expiration).timeIntervalSince1970))
        )
        print("DATE: \(NSDate.dateFromISOString(expiration).timeIntervalSince1970)")
        
        self.data = OrderedDictionary(dictionaryLiteral:
            ("ref_block_num", "\(self.refNum!)"),
            ("ref_block_prefix", "\(self.refPrefix!)"),
            ("expiration", self.expiration!),
            ("extensions", self.extensions.joinWithSeparator(" ")),
            ("signatures", String(data:NSData(self.signatures.flatMap({$0})), encoding: NSUTF8StringEncoding)!)
        )
    }
    
    func deriveDigest(chain: [String : [String:String]])
    {
        var chainParams = [String : String]()
        if known_chains.keys.contains(chain.keys.first!)
        {
            chainParams = known_chains[chain.keys.first!]!
        }
        else
        {
            chainParams = chain[chain.keys.first!]!
        }
        
        let chainId = chainParams["chain_id"]!
        let sigs = self.data!["signatures"]!
        self.data!["signatures"] = ""
        
        message = unhexlify("\(chainId)\(self.getWireFormat())")
        digest = BTCSHA256(message)
        
        self.data!["signatures"] = sigs
    }
    
    func deriveDigest(chainNamed: String)
    {
        
        let sigs = self.signatures
        self.signatures = [[UInt8]]()
        //self.data!["signatures"] = ""
        //print("0000000000000000000000000000000000000000000000000000000000000000\(self.getBytes())")
        //let chainID = unhexlify("0000000000000000000000000000000000000000000000000000000000000000")
        let chainData = NSMutableData()
        for _ in 0...31
        {
            chainData.appendData("\u{00}".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        chainData.appendData(NSData(self.getWireFormat()))
        //message = "\(chainID)\(self.getWireFormat()))".dataUsingEncoding(NSUTF8StringEncoding)
        message = (chainData.copy() as! NSData)
        print("MESSAGE: \(hexlify(message!))")
        digest = BTCSHA256(message)
        print("DIGEST: \(hexlify(digest!))")
        
        self.signatures = sigs
    }
    
    func getWireFormat() -> [UInt8]
    {
        var bytes = [UInt8]()
        if refNum != nil
        {
            bytes.appendContentsOf(refNum!.toSTEEMWireFormat())
        }
        if refPrefix != nil
        {
            bytes.appendContentsOf(refPrefix!.toSTEEMWireFormat())
        }
        if expiration != nil
        {
            let exp = UInt32(NSDate.dateFromISOString(expiration!).timeIntervalSince1970)
            bytes.appendContentsOf(exp.toSTEEMWireFormat())
        }
        for op in operations!
        {
            bytes.appendContentsOf(op.Operation.bytes())
        }
        bytes.appendContentsOf("\u{00}".dataUsingEncoding(NSUTF8StringEncoding)!.bytesArray())
        bytes.appendContentsOf("\u{01}".dataUsingEncoding(NSUTF8StringEncoding)!.bytesArray())
        for sig in signatures
        {
            print("HEX SIGNATURE: \(NSData(sig).hexString())")
            bytes.appendContentsOf(sig)
        }
        
        return bytes
    }
    
    func verify(pubkeys: [String], chain: [String : [String:String]])
    {
        deriveDigest(chain)
        let signatures = (self.data!["signatures"])?.componentsSeparatedByString(" ")
        
        // for each signature:
        var foundKeys = [BTCKey]()
        for _ in pubkeys
        {
            
            // use verifySignature: forMessage:
            for sig in signatures!
            {
                // instantiate a BTCKey with public key
                let newKey = BTCKey.verifySignature(sig.dataUsingEncoding(NSUTF8StringEncoding), forBinaryMessage: self.message!)
                if newKey != nil
                {
                    foundKeys.append(newKey)
                }
            }
        }
        
       //for each public key returned above:
        if foundKeys.count > 0
        {
            for key in foundKeys
            {
                //check to see if our list of public keys (the ones passed into the function)
                //are are all included in the keys we found by verifying the signatures.
                if !pubkeys.contains(key.uncompressedPublicKey.base58String())
                {
                    assertionFailure("invalid public key found.")
                }
                //If they are, return true.
            }
        }
        else
        {
            assertionFailure("No valid signatures for given public keys!")
        }
        
    }
    
    func sign(wifKeys: [String])
    {
        self.deriveDigest("BTS")
        var signatures = [[UInt8]]()
        //foreach key
        for wif in wifKeys
        {
            //Instantiate a BTCKey with WIF key
            let key = PrivateKey(WIF: wif)
            //use signatureForHash to get signature using self.message and this WIF key
            let sig = key.signatureForSTEEMMessage(self.digest!)
            //let sig = key.compactSignatureForHash(BTCSHA256(self.digest!))
            //append signature to array
            print("Found raw signature: \(sig!.bytesArray())")
            signatures.append(sig!.bytesArray())
        }
        // join array with space, then set as self.data["signature"]
        let newSigs = signatures
        self.signatures = signatures
        self.data!["signatures"] = "\(NSString(data: NSData(newSigs.flatMap({$0})), encoding: NSUTF8StringEncoding))"
    }
    
    func buildJSON()
    {
        var json = JSON()
        for op in operations!
        {
            json.add(op.Operation.toJSON()!)
        }
        print("JSON: ")
        print("\(json)")
        print("###############")
    }
    
    func toJSON() -> JSON? {
        var inner = JSON()
        for op in operations!
        {
            inner.add(op.Operation.toJSON()!)
        }
        let sigArray = NSMutableArray()
        for sig in self.signatures
        {
            sigArray.addObject(NSData(sig).hexString())
        }
        let outer = jsonify([
            "ref_block_num" ~~> "\(self.refNum!)",
            "ref_block_prefix" ~~> "\(self.refPrefix!)",
            "expiration" ~~> self.expiration,
            "operations" ~~> inner,
            "extensions" ~~> self.extensions,
            "signatures" ~~> sigArray
        ])
        return outer
    }
}
