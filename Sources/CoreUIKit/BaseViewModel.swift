//
//  BaseViewModel.swift
//  Experience
//
//  Created by Davinder S Dhaliwal on 2019-11-21.
//  Copyright © 2019 Angus. All rights reserved.
//

import Foundation

open class BaseViewModel: NSObject {
    let isBusy = Observable<Bool>(value: false)
    private var loadCount = 0
    
    public var viewStatus: Observable<ViewStatus> = Observable<ViewStatus>(value: .none)
    
    @MainActor
    public func changeViewStatus(viewStatus: ViewStatus, isRefresh: Bool = false) {
        switch viewStatus {
        case .Loading:
            loadCount += 1
            if !isRefresh && loadCount == 1 {
                self.viewStatus.value = viewStatus
            }
        case .Loaded:
            if loadCount > 0{
                loadCount -= 1
            }
            if !isRefresh && loadCount == 0 {
                self.viewStatus.value = viewStatus
            }
        default:
            loadCount = 0
            self.viewStatus.value = viewStatus
        }
    }
    
}
