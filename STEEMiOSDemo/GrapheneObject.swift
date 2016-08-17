//
//  GrapheneObject.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/13/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//
//
//  GrapheneObject exists so that we have a way to get raw bytes
//  in STEEM's wire format from out higher-level objects
//

import Foundation


class GrapheneObject
{
    var idByte: UInt8 = 0
    var data: OrderedDictionary<String , String>?
    var data16: OrderedDictionary<String, UInt16>?
    var data32: OrderedDictionary<String, UInt32>?
    
    func getBytes() -> [UInt8]
    {
        if data == nil
        {
            return [UInt8(0)]
        }
        var bytes = [UInt8]()
        
        if data16 != nil
        {
            for int in data16!.orderedValues
            {
                let int16 = UInt16(int)
                bytes += typeToBytes(int16)
            }
        }
        
        if data32 != nil
        {
            for int in data32!.orderedValues
            {
                let int32 = UInt32(int)
                bytes += typeToBytes(int32)
            }
        }
        
        bytes += [UInt8(01)]
        bytes += [idByte]
        
        
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
        return bytes
    }
    
    
}
