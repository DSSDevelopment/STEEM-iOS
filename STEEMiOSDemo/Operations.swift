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

struct Vote {
    var voter: String
    var author: String
    var permlink: String
    var weight: Int16
    
    func description() -> OrderedDictionary<String, String>
    {
        return OrderedDictionary(dictionaryLiteral:
            ("voter", voter),
            ("author", author),
            ("permlink", permlink),
            ("weight", "\(weight)")
        )
    }
}

struct Comment {
    var parentAuthor: String
    var parentPermlink: String
    var author: String
    var permlink : String
    var title: String
    var body: String
    var jsonMetadata: String
    
    func description() -> OrderedDictionary<String, String>
    {
        return OrderedDictionary(dictionaryLiteral:
            ("parent_author", parentAuthor),
            ("parent_permlink", parentPermlink),
            ("author", author),
            ("permlink", permlink),
            ("title", "\(title)"),
            ("body", "\(body)"),
            ("jsonMetadata", "\(jsonMetadata)")
        )
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
    
}

struct AccountCreate {
    var fee: Amount
    var creator: String
    var newAccountName: String
    //var owner: Permission
    //var active: Permission
    //var posting: Permission
    var memoKey: PublicKey
    var jsonMetadata: String
}



class Operations
{
    
    let prefix = "STM"
    
    var opID: OperationID
    
    required init(operation: OperationID) {
        self.opID = operation
    }
    
    
    
}
