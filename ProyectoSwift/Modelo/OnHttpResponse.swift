//
//  OnHttpResponse.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 1/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import Foundation
protocol OnHttpResponse {
    func onDataReceived(data: Data)
    func onErrorReceivingData(message: String)
}
