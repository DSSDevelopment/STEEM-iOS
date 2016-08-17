//
//  Tests.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/14/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation

class Tests
{
    func testComment()
    {
        let wif                 = "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
        let ref_block_num: UInt16       = 34294
        let ref_block_prefix: UInt32    = 3707022213
        let expiration          = "2016-04-06T08:29:27"
        
        let op = Comment(parentAuthor: "foobara", parentPermlink: "foobarb", author: "foobarc", permlink: "foobard", title: "foobare", body: "foobarf", jsonMetadata: "{\"foo\": \"bar\"}")
        
        let ops = Operations(operation: op)
        let tx = SignedTransaction(refNum: ref_block_num, refPrefix: ref_block_prefix, expiration: expiration, operations: [ops], signatures: nil, extensions: nil)
        
        tx.sign([wif])
        let txWire = hexlify(NSData(bytes: tx.getWireFormat(), length: tx.getWireFormat().count))
        
        let compare = "f68585abf4dce7c80457010107666f6f6261726107666f6f6261726207666f6f6261726307666f6f6261726407666f6f6261726507666f6f626172660e7b22666f6f223a2022626172227d00011f34a882f3b06894c29f52e06b8a28187b84b817c0e40f124859970b32511a778736d682f24d3a6e6da124b340668d25bbcf85ffa23ca622b307ffe10cf182bb82"
        assert(compare.substringToIndex(compare.startIndex.advancedBy(130)) == txWire.substringToIndex(txWire.startIndex.advancedBy(130)), "comparison failure.")
    }
    
    func testVote()
    {
        let wif                 = "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
        let ref_block_num: UInt16       = 34294
        let ref_block_prefix: UInt32    = 3707022213
        let expiration          = "2016-04-06T08:29:27"
        
        let op = Vote(voter: "foobara", author: "foobarc", permlink: "foobard", weight: 1000)
        
        let ops = Operations(operation: op)
        let tx = SignedTransaction(refNum: ref_block_num, refPrefix: ref_block_prefix, expiration: expiration, operations: [ops], signatures: nil, extensions: nil)
        
        tx.sign([wif])
        let txWire = hexlify(NSData(bytes: tx.getWireFormat(), length: tx.getWireFormat().count))
        
        let compare = "f68585abf4dce7c80457010007666f6f6261726107666f6f6261726307666f6f62617264e8030001202e09123f732a438ef6d6138484d7adedfdcf4a4f3d171f7fcafe836efa2a3c8877290bd34c67eded824ac0cc39e33d154d0617f64af936a83c442f62aef08fec"
        
        assert(compare.substringToIndex(compare.startIndex.advancedBy(130)) == txWire.substringToIndex(txWire.startIndex.advancedBy(130)), "comparison failure.")

        
    }
    
}
