//
//  RestJsonUtil.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 1/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import Foundation
class RestJsonUtil{
    // tranformar diccionarios en json y viceversa
    static func dictToJson(data: [String:Any]) -> Data? {
        guard let json = try? JSONSerialization.data(withJSONObject: data as Any,
                                                     options: []) else {
                                                        return nil
        }
        return json//Yeeh
    }
    static func jsonToDict(data: Data) -> [String: Any]? {
        guard let diccionario = try? JSONSerialization.jsonObject(with: data,
                                                                  options: []) as? [String: Any] else {
                                                                    return nil
        }
        return diccionario
    }
}
