//
//  NetworkStatus.swift
//  Asgl.iOS.SDK.CoreModule
//
//  Created by Davinder S Dhaliwal on 2019-10-03.
//  Copyright © 2019 Nicole Ahadi. All rights reserved.
//

import Foundation
import SystemConfiguration

@available(*, unavailable, renamed: "Connection")
public enum NetworkStatus: CustomStringConvertible {
    case notReachable, reachableViaWiFi, reachableViaWWAN
    public var description: String {
        switch self {
        case .reachableViaWWAN: return "Cellular"
        case .reachableViaWiFi: return "WiFi"
        case .notReachable: return "No Connection"
        }
    }
}
