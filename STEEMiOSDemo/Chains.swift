//
//  Chains.swift
//  STEEM-iOS
//
//  Created by Derek Sanchez on 8/1/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation

let known_chains: [String : [String:String] ] = ["STEEM" :
    ["chain_id" : "0000000000000000000000000000000000000000000000000000000000000000", //64 zeroes
                            "core_symbol" : "STEEM",
                            "prefix" : "STM"
    ],
    
                    "TEST" :
                        ["chain_id" : "18dcf0a285365fc58b71f18b3d3fec954aa0c141c44e4e5cb4cf777b9eab274e",
                            "core_symbol" : "TESTS",
                            "prefix" : "TST"
                    ],
    ]