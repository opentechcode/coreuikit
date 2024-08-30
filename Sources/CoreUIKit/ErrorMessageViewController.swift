//
//  ErrorMessageViewController.swift
//  Experience
//
//  Created by ali on 2020-02-26.
//  Copyright © 2020 Angus. All rights reserved.
//

import UIKit

class ErrorMessageViewController: UIViewController {

    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var errorMessageTitleLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    static func Show(presenter: UIViewController, errorMessage: String, target: Any?, selector: Selector?) -> ErrorMessageViewController {
        let controller = ErrorMessageViewController(nibName: "ErrorMessageViewController", bundle: Bundle.module)
        controller.modalPresentationStyle = .overCurrentContext
        presenter.present(controller, animated: false) {
            controller.errorMessageLabel.text = ""
            controller.errorMessageTitleLabel.text = errorMessage
            
            if let target = target, let selector = selector {
                controller.retryButton.addTarget(target, action: selector, for: .touchUpInside)
            }
        }
        
        return controller
    }
    
    static func addChild(presenter: UIViewController, errorMessage: String, target: Any?, selector: Selector?) -> ErrorMessageViewController {
        let controller = ErrorMessageViewController(nibName: "ErrorMessageViewController", bundle: Bundle.module)
        presenter.addChild(controller)
        presenter.view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.didMove(toParent: presenter)
        controller.view.leadingAnchor.constraint(equalTo: presenter.view.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: presenter.view.trailingAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: presenter.view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: presenter.view.bottomAnchor).isActive = true
        controller.view.layoutIfNeeded()
        controller.errorMessageLabel.text = ""
        controller.errorMessageTitleLabel.text = errorMessage
        
        if let target = target, let selector = selector {
            controller.retryButton.addTarget(target, action: selector, for: .touchUpInside)
        }
        return controller
    }
}
