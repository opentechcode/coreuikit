//
//  ViewStateManager.swift
//  Experience
//
//  Created by ali on 2020-01-23.
//  Copyright © 2020 Angus. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewStateDelegate: class {
    func loadingState()
    func loadedState()
    func noDataState(text: String?,caption: String?, info: [String]?, tag: Int)
    func errorState(error: String, tag: Int)
    func noInternetState(tag: Int)
    func showProgressOverlay(tag: Int)
    func hideProgressOverlay(tag: Int)
    func retry()
}

public class ViewStateManager {
    
    var vSpinner : UIView?
    weak var mainView: UIView?
    weak var dataView: UIView?
    weak var messageView: UIView?
    let activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var reachibility: Reachability?
    weak var controller: UIViewController!
    weak var delegate: ViewStateDelegate?
    var defaultErrorState: Bool
    var tag: Int
    
    var viewStatus: ViewStatus = .None {
        didSet {
            switch viewStatus {
            case .None:
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            case .Initialized(let mainView, let dataView):
                self.mainView = mainView
                self.dataView = dataView
            case .Loading:
                loadingState()
            case .Loaded:
                loadedState()
            case .NoData(let text, let caption, let info):
                noDataState(text: text, caption: caption, info: info)
            case .Error(let errorMessage):
                errorState(error: errorMessage)
            case .NoInternet:
                noInternetState()
            }
        }
    }
    
    var loadingStyle: LoadingStyle = .Flip
    
    init(controller: UIViewController, viewStatus: Observable<ViewStatus>,
         mainView: UIView?, dataView: UIView?, messageView: UIView? = nil,
         defaultErrorState: Bool = true, tag: Int = 0,
         loadingStyle: LoadingStyle, delegate: ViewStateDelegate? = nil) {
        
        self.controller = controller
        self.loadingStyle = loadingStyle
        self.mainView = mainView
        self.dataView = dataView
        self.messageView = messageView
        self.delegate = delegate
        self.viewStatus = .Initialized(self.mainView, dataView)
        self.defaultErrorState = defaultErrorState
        self.tag = tag
        
        viewStatus.bind { [weak self] (status) in
            guard let status = status else { return }
            self?.viewStatus = status
        }
    }
    
    func viewDidAppear() {
     
    }
    
    //MARK: - View State Methods
    func loadingState() {
      showActivity()
      messageView?.isHidden = true
      delegate?.loadingState()
    }
    
    func loadedState() {
        hideActivity()
        messageView?.isHidden = true
        delegate?.loadedState()
    }
    
    func noDataState(text: String?, caption: String?, info: [String]?) {
        hideActivity()
        messageView?.isHidden = false
        delegate?.noDataState(text: text, caption: caption, info: info, tag: self.tag)
    }
    
    func errorState(error: String) {
        hideActivity()
        if let view = messageView {
            view.isHidden = false
            dataView?.isHidden = true
        } else if defaultErrorState {
            dataView?.isHidden = true
            delegate?.errorState(error: error, tag: self.tag)
        }
    }
    
    func noInternetState() {
        startInternetNotifier()
        hideActivity()
        messageView?.isHidden = true
        delegate?.noInternetState(tag: self.tag)
    }
    
    func retry() {
        delegate?.retry()
    }
    // Mark: ViewState Helper methods
    
    func showActivity() {
        switch loadingStyle {
        case .Flip:
            activityView.color = UIColor.systemTeal// UIColor(named: "tint")
            if let mainView = self.mainView {
             activityView.translatesAutoresizingMaskIntoConstraints = false
              mainView.addSubview(activityView)
              activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
              activityView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: 0).isActive = true
              activityView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0).isActive = true
              activityView.layoutIfNeeded()
              activityView.hidesWhenStopped = true
              activityView.startAnimating()
            }
            self.dataView?.isHidden = true

        case .Overlay:
            delegate?.showProgressOverlay(tag: tag)
            
        case .Embeded(let view):
            view.addSubview(activityView)
            //activityView.color = ThemeManager.shared.themeTintColor
            activityView.translatesAutoresizingMaskIntoConstraints = false
            activityView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            
            if let button = view as? UIButton {
                button.isEnabled = false
            }
            activityView.hidesWhenStopped = true
            activityView.startAnimating()
            activityView.layoutIfNeeded()
            view.layoutIfNeeded()
        case .None:
            print("")
        }
    }
    
    func hideActivity() {
        
        switch loadingStyle {
        case .Flip:
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            self.dataView?.isHidden = false
        case .Overlay:
            delegate?.hideProgressOverlay(tag: tag)
        case .Embeded(let view):
            if let button = view as? UIButton {
                button.isEnabled = true
            }
            activityView.stopAnimating()
        case .None:
            print("Nothing")
        }
    }
    
    //MARK: - Internet reachibility Related methods
    func startInternetNotifier() {
        if self.reachibility == nil {
            self.reachibility =  try? Reachability(hostname: "https://www.google.com")
        }
        if let reachibility = self.reachibility {
            NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: NSNotification.Name.reachabilityChanged, object: reachibility)
            do {
                try reachibility.startNotifier()
            }
            catch {
                print("Start Notifier error")
            }
        }
    }
    
    func stopInternetNotifier() {
        if let reachibility = reachibility {
            reachibility.stopNotifier()
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        guard let reachibility = self.reachibility else {
            return
        }
        if reachibility.connection != .unavailable {
            stopInternetNotifier()
            self.retry()
        }

    }
}
