//
//  Operations.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/13/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation

// Operation ids
enum OperationID: Int {
    case Vote,
    Comment,
    Transfer,
    TransferToVesting,
    WithdrawVesting,
    LimitOrderCreate,
    LimitOrderCancel,
    FeedPublish,
    Convert,
    AccountCreate,
    AccountUpdate,
    WitnessUpdate,
    AccountWitnessVote,
    AccountWitnessProxy,
    Pow,
    Custom,
    ReportOverProduction,
    FillConvertRequest,
    CommentReward,
    CurateReward,
    LiquidityReward,
    Interest,
    FillVestingWithdraw,
    FillOrder
}

enum AssetClass: String {
    case STEEM = "STEEM"
    case VESTS = "VESTS"
    case SBD = "SBD"
}

protocol SerializableSTEEMOperation : Glossy
{
    func bytes() -> [UInt8]
}


class Operations
{
    
    let prefix = "STM"
    
    var Operation: SerializableSTEEMOperation
    //var fields: OrderedDictionary<String, String>
    //var fields16: OrderedDictionary<String, Int16>?
    
    required init(operation: SerializableSTEEMOperation) {
        self.Operation = operation
    }
    

    /*func description() -> String
    {
        //let opName = "\(opID)"
        var desc = ""
        var i = 0
        for field in fields.orderedValues
        {
            if fields.elementAtIndex(i)!.0 == "json_metadata"
            {
                desc.appendContentsOf("\u{0e}")
            }
            else if Int(field) == nil
            {
                desc.appendContentsOf("\u{07}")
            }
            /*if Int16(field) != nil
            {
                
                let bytes = [UInt8(val! >> 8), UInt8(val! & 0x00ff)]
                for byte in bytes
                {
                    let hex = hexlify(NSData([byte]))
                    if let str = Int(hex, radix: 16).map({ i in
                        Character(UnicodeScalar(i)) })
                    {
                        desc.append(str)
                    }
                }
                
            }
            */
            else
            {
                desc.appendContentsOf("\(field)")
            }
            i += 1
        }
        
        if fields16 != nil
        {
            for field in fields16!.orderedValues
            {
                //print(typeToBytes(field
                for byte in typeToBytes(field)
                {
                    let code = UnicodeScalar(byte)
                    let string = "\(code)"
                    print("string: \(string)")
                    desc.appendContentsOf(string)
                }
                

            }
        }
        return desc
    }
    
    */
    
}
 
 

/*
for val in data!.orderedValues
{
    print ("VAL: \(val)")
    //var byteArray = [Byte]()
    //let data = key.dataUsingEncoding(NSUTF8StringEncoding)
    var buff = [UInt8]()
    //print("CHARACTERS: \(val.characters.split("/"))")
    buff += val.utf8
    let hexString = NSMutableString()
    for byte in buff {
        hexString.appendFormat("%02x", UInt(byte))
    }
    print("\(val) : \(hexString)")
    bytes += buff
    //bytes.appendContentsOf(typeToBytes(data![key]))
}
 */

extension String
{
    func toSTEEMWireFormat() -> [UInt8]
    {
        var buff = [UInt8]()
        let length = self.utf8.count
        buff += typeToBytes(UInt8(length))
        buff += self.utf8
        /*let hexString = NSMutableString()
        for byte in buff
        {
            hexString.appendFormat("%02x", UInt(byte))
        }*/
        var bytes = [UInt8]()
        bytes += buff
        return bytes
    }
}

extension Int16
{
    func toSTEEMWireFormat() -> [UInt8]
    {
        return typeToBytes(self)
    }
}

extension UInt16
{
    func toSTEEMWireFormat() -> [UInt8]
    {
        return typeToBytes(self)
    }
}

extension UInt32
{
    func toSTEEMWireFormat() -> [UInt8]
    {
        return typeToBytes(self)
    }
}

class Vote : SerializableSTEEMOperation {
    var voter: String = ""
    var author: String = ""
    var permlink: String = ""
    var weight: Int16 = 0
    
    init(voter: String, author: String, permlink: String, weight: Int16) {
        self.voter = voter
        self.author = author
        self.permlink = permlink
        self.weight = weight
    }
    
    func bytes() -> [UInt8] {
        var desc = [UInt8]()
        desc += [UInt8(01)]
        desc += [UInt8(00)]
        for str in [self.voter, self.author, self.permlink]
        {
            print("String: \(str) Hex: \(str.toSTEEMWireFormat())")
            desc.appendContentsOf(str.toSTEEMWireFormat())
        }
        desc.appendContentsOf(self.weight.toSTEEMWireFormat())
        
        return desc
    }
    
    required init?(json: JSON) {
        self.voter = ("voter" <~~ json)!
        self.author = ("author" <~~ json)!
        self.permlink = ("permlink" <~~ json)!
        self.weight = ("weight" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        let inner = jsonify([
            "voter" ~~> self.voter,
            "author" ~~> self.author,
            "permlink" ~~> self.permlink,
            "weight" ~~> "\(self.weight)"
            ])
        let outer = ["vote" : inner!]
        return outer
    }
    
    /*func description() -> OrderedDictionary<String, String>
    {
        return OrderedDictionary(dictionaryLiteral:
            ("voter", voter),
            ("author", author),
            ("permlink", permlink),
            ("weight", "\(weight)")
        )
    }
 */

}

class Comment : SerializableSTEEMOperation {
    var parentAuthor: String
    var parentPermlink: String
    var author: String
    var permlink : String
    var title: String
    var body: String
    var jsonMetadata: String
    
    init(parentAuthor: String, parentPermlink: String, author: String, permlink: String, title: String, body: String, jsonMetadata: String)
    {
        self.parentAuthor = parentAuthor
        self.parentPermlink = parentPermlink
        self.author = author
        self.permlink = permlink
        self.title = title
        self.body = body
        self.jsonMetadata = jsonMetadata
    }
    
    func description() -> OrderedDictionary<String, String>
    {
        return OrderedDictionary(dictionaryLiteral:
            ("parent_author", parentAuthor),
            ("parent_permlink", parentPermlink),
            ("author", author),
            ("permlink", permlink),
            ("title", "\(title)"),
            ("body", "\(body)"),
            ("json_metadata", "\(jsonMetadata)")
        )
    }
    
    func bytes() -> [UInt8] {
        var desc = [UInt8]()
        desc += [UInt8(01)]
        desc += [UInt8(01)]
        for str in [self.parentAuthor, self.parentPermlink, self.author, self.permlink, self.title, self.body]
        {
            //desc.appendContentsOf("\u{07}".toSTEEMWireFormat())
            desc.appendContentsOf(str.toSTEEMWireFormat())
            print("String: \(str) Hex: \(str.toSTEEMWireFormat())")
        }
        //desc.appendContentsOf("\u{0e}".toSTEEMWireFormat())
        desc.appendContentsOf(self.jsonMetadata.toSTEEMWireFormat())
        
        return desc
    }
    
    required init?(json: JSON) {
        self.parentAuthor = ("parent_author" <~~ json)!
        self.parentPermlink = ("parent_permlink" <~~ json)!
        self.author = ("author" <~~ json)!
        self.permlink = ("permlink" <~~ json)!
        self.title = ("title" <~~ json)!
        self.body = ("body" <~~ json)!
        self.jsonMetadata = ("json_metadata" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        let inner = jsonify([
            "parent_author" ~~> self.parentAuthor,
            "parent_permlink" ~~> self.parentPermlink,
            "author" ~~> self.author,
            "permlink" ~~> self.permlink,
            "title" ~~> self.title,
            "body" ~~> self.body,
            "json_metadata" ~~> self.jsonMetadata
            ])
        let outer = ["comment" : inner!]
        return outer
    }

}

class Transfer: SerializableSTEEMOperation
{
    var from: String
    var to: String
    var amount: String
    var memo: String
    
    func bytes() -> [UInt8] {
        var desc = [UInt8]()
        desc += [UInt8(01)]
        desc += [UInt8(02)]
        for str in [self.from, self.to, self.amount, self.memo]
        {
            desc.appendContentsOf(str.toSTEEMWireFormat())
        }
        return desc
    }
    
    required init?(json: JSON) {
        self.from = ("from" <~~ json)!
        self.to = ("to" <~~ json)!
        self.amount = ("amount" <~~ json)!
        self.memo = ("memo" <~~ json)!
        
    }
    
    func toJSON() -> JSON? {
        let inner = jsonify([
            "from" ~~> self.from,
            "to" ~~> self.to,
            "amount" ~~> self.amount,
            "memo" ~~> self.memo
            ])
        let outer = ["transfer" : inner!]
        return outer
    }
}

class TransferToVesting: SerializableSTEEMOperation
{
    var from: String
    var to: String
    var amount: String
    
    func bytes() -> [UInt8] {
        var desc = [UInt8]()
        desc += [UInt8(01)]
        desc += [UInt8(03)]
        for str in [self.from, self.to, self.amount]
        {
            desc.appendContentsOf(str.toSTEEMWireFormat())
        }
        return desc
    }
    
    required init?(json: JSON) {
        self.from = ("from" <~~ json)!
        self.to = ("to" <~~ json)!
        self.amount = ("amount" <~~ json)!
        
    }
    
    func toJSON() -> JSON? {
        let inner = jsonify([
            "from" ~~> self.from,
            "to" ~~> self.to,
            "amount" ~~> self.amount,
            ])
        let outer = ["transfer_to_vesting" : inner!]
        return outer
    }
}

class WithdrawVesting: SerializableSTEEMOperation
{
    var from: String
    var to: String
    var amount: String
    
    func bytes() -> [UInt8] {
        var desc = [UInt8]()
        desc += [UInt8(01)]
        desc += [UInt8(04)]
        for str in [self.from, self.to, self.amount]
        {
            desc.appendContentsOf(str.toSTEEMWireFormat())
        }
        return desc
    }
    
    required init?(json: JSON) {
        self.from = ("from" <~~ json)!
        self.to = ("to" <~~ json)!
        self.amount = ("amount" <~~ json)!
        
    }
    
    func toJSON() -> JSON? {
        let inner = jsonify([
            "from" ~~> self.from,
            "to" ~~> self.to,
            "amount" ~~> self.amount,
            ])
        let outer = ["withdraw_vesting" : inner!]
        return outer
    }
}

struct Amount {
    var amount: Double
    var asset: AssetClass
    var precision: Int {
        get {
            switch asset
            {
            case .STEEM:
                return 3
            case .VESTS:
                return 6
            case .SBD:
                return 3
            }
        }
        set(newValue) {
            precision = newValue
        }
    }
    
    func description() -> String
    {
        let desc = "%.\(precision)f %@"
        return String(format: desc, amount, asset.rawValue)
    }
    
    func bytes() -> [UInt8]
    {
        return description().toSTEEMWireFormat()
    }
    
}

struct AccountCreate {
    var fee: Amount
    var creator: String
    var newAccountName: String
    var owner: Permission
    var active: Permission
    var posting: Permission
    var memoKey: PublicKey
    var jsonMetadata: String
    
    func description() -> OrderedDictionary<String, String>
    {
        return OrderedDictionary(dictionaryLiteral:
            ("fee", fee.description()),
            ("creator", creator),
            ("new_account_name", newAccountName),
            ("owner", "\(owner.data!)"),
            ("active", "\(active.data!)"),
            ("posting", "\(posting.data!)"),
            ("memo_key", "\(memoKey.uncompressedPublicKey)")
        )
    }
    
    func bytes() -> [UInt8]
    {
        let grapheneRepresentation = GrapheneObject()
        grapheneRepresentation.data = description()
        return grapheneRepresentation.getBytes()
    }
}

