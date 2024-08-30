//
//  UISwitch+Bindable.swift
//  AngusMobile
//
//  Created by ali on 2019-09-25.
//  Copyright © 2019 Angus Systems. All rights reserved.
//

import Foundation
import UIKit

extension UISwitch : BindableProtocol {
    
    public typealias T = Bool
    
    public func observingValue() -> Bool? {
        return self.isOn
    }
    
    public func updateValue(with value: Bool) {
        self.isOn = value
    }
    
    public func registerEvent(for observable: Observable<T>) {
        self.addTarget(self, action: #selector(valueChanged), for: [.editingChanged, .valueChanged])
    }
    
    public func unRegisterEvent() {
        self.removeTarget(self, action: #selector(valueChanged), for: [.editingChanged, .valueChanged])
    }
    
    @objc func valueChanged() {
        self.binder.subscribe?(UIControl.Event.valueChanged)
        if binder.value != self.observingValue() {
            setBinderValue(with: self.observingValue())
        }
    }
}
