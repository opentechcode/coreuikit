//
//  ViewStatus.swift
//  Experience
//
//  Created by ali on 2019-12-24.
//  Copyright © 2019 Angus. All rights reserved.
//

import Foundation
import UIKit

public enum ViewStatus {
    case None
    case Initialized(UIView?, UIView?)
    case Loading
    case Loaded
    case NoData(String?, String?, [String]?)
    case Error(String)
    case NoInternet
}

public enum LoadingStyle {
    case None
    case Embeded(UIView)
    case Flip
    case Overlay
}
