//
//  PublicKey.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/10/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation

class PublicKey: BTCKey
{

    /* This class deals with Public Keys and inherits ``BTCKey``.
    
    :param String pk: Base58 encoded public key
    :param String prefix: Network prefix (defaults to ``BTS``)
    
    Example:::
    
    PublicKey("BTS6UtYWWs3rkZGV8JA86qrgkG6tyFksgECefKE1MiH4HkLD8PFGL")
    
    .. note:: By default, graphene-based networks deal with **compressed**
    public keys. If an **uncompressed** key is required, the
    method ``unCompressed`` can be used::
     */
    
    //compressedPublicKey and uncompressedPublicKey: BTCKey
    
    
    
    //WIF: BTCKey
    
    //__repr__ : does hex representation. Can definitely work with
    // existing libraries to convert.
    func hexRepresentation() -> String
    {
        return "0x0"
    }
    
    
    
    
    
    
}
