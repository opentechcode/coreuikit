//
//  UIButton+Bindble.swift
//  AngusMobile
//
//  Created by ali on 2019-09-25.
//  Copyright © 2019 Angus Systems. All rights reserved.
//

import Foundation
import UIKit

extension UIButton : BindableProtocol {
    public typealias BindingType = String
    
    public func observingValue() -> String? {
        return self.titleLabel?.text
    }
    
    public func updateValue(with value: String) {
        self.setTitle(value, for: .normal)
    }
    
    public func registerEvent(for observable: Observable<T>) {
        self.addTarget(self, action: #selector(sendControlEvent), for: [.touchUpInside])
        self.removeTarget(self, action: #selector(valueChanged), for: [.valueChanged])
    }
    
    public func unRegisterEvent() {
        self.removeTarget(self, action: #selector(sendControlEvent), for: [.editingChanged, .valueChanged])
        self.removeTarget(self, action: #selector(valueChanged), for: [.editingChanged, .valueChanged])
    }
    
    @objc func valueChanged() {
        self.binder.subscribe?(UIControl.Event.valueChanged)
        if binder.value != self.observingValue() {
            setBinderValue(with: self.observingValue())
        }
    }
    
    @objc func sendControlEvent() {
        self.binder.subscribe?(.touchUpInside)
    }
}
