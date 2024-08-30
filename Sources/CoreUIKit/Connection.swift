//
//  Connection.swift
//  Asgl.iOS.SDK.CoreModule
//
//  Created by Davinder S Dhaliwal on 2019-10-03.
//  Copyright © 2019 Nicole Ahadi. All rights reserved.
//

import Foundation

public enum Connection: CustomStringConvertible {
    @available(*, deprecated, renamed: "unavailable")
    case none
    case unavailable, wifi, cellular
    public var description: String {
        switch self {
        case .cellular: return "Cellular"
        case .wifi: return "WiFi"
        case .unavailable: return "No Connection"
        case .none: return "unavailable"
        }
    }
}
