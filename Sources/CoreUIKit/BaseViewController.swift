//
//  AngusViewController.swift
//  AngusMobile
//
//  Created by ali on 2019-09-20.
//  Copyright © 2019 Angus Systems. All rights reserved.
//

import UIKit


open class BaseViewController: UIViewController, ViewStateDelegate {
    var isPresented: Bool = false
    var showNavBarOnUnExpectedState = false
    
    
    
    private var viewStateManagers: [ViewStateManager] = []
    private var noInternetController: NoInternetViewController?
    private var errorMessageController: ErrorMessageViewController?
    private var noDataController: NoDataViewController?
    private var spinnerController: SpinnerViewController?
    // Purpose of dismissWait is to avoid the situation where controllers are dismiss and present too quickly
    private var dismissWait: DispatchTime = .now() + 0.0
    
    var NoInternetController: NoInternetViewController? {
        return noInternetController
    }
    
    var ErrorMessageController: ErrorMessageViewController? {
        return errorMessageController
    }
    
    var NoDataController: NoDataViewController? {
        return noDataController
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        definesPresentationContext = true
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.title = title
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        viewStateManagers.forEach {
            $0.viewDidAppear()
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    public func bindViewStatus(viewStatus: Observable<ViewStatus>, mainView: UIView?, dataView: UIView?, messageView: UIView? = nil,
                        defaultErrorState: Bool = true, tag: Int = 0,
                        loadingStyle: LoadingStyle, delegate: ViewStateDelegate? = nil) {
        
        let manager = ViewStateManager(controller: self, viewStatus: viewStatus,
                                      mainView: mainView, dataView: dataView, messageView: messageView,
                                      defaultErrorState: defaultErrorState, tag: tag,
                                      loadingStyle: loadingStyle, delegate: delegate ?? self)
        
        viewStateManagers.append(manager)
    }
    
    func createRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(retry), for: .valueChanged)
        return refreshControl
    }
    
    @objc open func retry() {
        removeControllers()
    }
    

    //MARK: - View State Delegate Methods
    public func loadingState() {
       removeControllers()
    }
    
    public func loadedState() {
       removeControllers()
    }
    
    public func showProgressOverlay(tag: Int) {
        DispatchQueue.main.asyncAfter(deadline: dismissWait) { [weak self] in
              self?.dismissWait = .now() + 0.0
              if let self = self, self.noDataController == nil {
                  self.spinnerController = SpinnerViewController.addChild(presenter: self)
              }
          }
    }
    
    public func hideProgressOverlay(tag: Int) {
          if let spinnerController = self.spinnerController {
               dismissWait = .now() + 0.5
               self.removeChildViewController(viewController: spinnerController)
               self.spinnerController = nil
           }
       }
    
    public func noDataState(text: String?, caption: String?, info: [String]?, tag: Int) {
        DispatchQueue.main.asyncAfter(deadline: dismissWait) { [weak self] in
            self?.dismissWait = .now() + 0.0
            if let self = self, self.noDataController == nil {
                self.noDataController = NoDataViewController.addChild(presenter: self, message: text,
                                                                      caption: caption, images: info)
                if self.showNavBarOnUnExpectedState {
                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                }
            }
        }
       
    }
    
    public func errorState(error: String, tag: Int) {
        DispatchQueue.main.asyncAfter(deadline: dismissWait) { [weak self] in
            self?.dismissWait = .now() + 0.0
            if let self = self, self.errorMessageController == nil {
                let message = "\(error)"
                self.errorMessageController = ErrorMessageViewController.addChild(presenter: self, errorMessage: message,
                                                                                  target: self, selector: #selector(self.retry))
                
                if self.showNavBarOnUnExpectedState {
                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                }
            }
        }
    }
    
    public func noInternetState(tag: Int) {
        DispatchQueue.main.asyncAfter(deadline: dismissWait) { [weak self] in
                self?.dismissWait = .now() + 0.0
                if let self = self, self.noInternetController == nil {
                    self.noInternetController = NoInternetViewController.addChild(presenter: self)
                    if self.showNavBarOnUnExpectedState {
                        self.navigationController?.setNavigationBarHidden(false, animated: false)
                    }
                }
            }
    }
    
    private func removeControllers() {
        if showNavBarOnUnExpectedState {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        if let noInternetController = self.noInternetController {
            dismissWait = .now() + 0.5
            self.removeChildViewController(viewController: noInternetController)
            self.noInternetController = nil
        }
        if let noDataController = self.noDataController {
            dismissWait = .now() + 0.5
            self.removeChildViewController(viewController: noDataController)
            self.noDataController = nil
        }
        if let errorMessageController = self.errorMessageController {
            dismissWait = .now() + 0.5
            self.removeChildViewController(viewController: errorMessageController)
            self.errorMessageController = nil
            
        }
    }
    
    //MARK: - Child view Controller methods
    
    func addChildViewController(viewController: UIViewController) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func removeChildViewController(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
}
