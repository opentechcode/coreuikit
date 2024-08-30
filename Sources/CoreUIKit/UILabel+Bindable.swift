//
//  UILabel+Bindable.swift
//  AngusMobile
//
//  Created by ali on 2019-09-25.
//  Copyright © 2019 Angus Systems. All rights reserved.
//

import Foundation
import UIKit

extension UILabel : BindableProtocol {
    public typealias BindingType = String
    
    public func observingValue() -> String? {
        return self.text
    }
    
    public func updateValue(with value: String) {
        self.text = value
    }
    
    public func registerEvent(for observable: Observable<String>) {
       //NO need
    }
    
    public func unRegisterEvent() {
      //No Registered Events
    }
}
