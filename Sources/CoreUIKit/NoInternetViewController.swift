//
//  NoInternetViewController.swift
//  Experience
//
//  Created by ali on 2020-01-22.
//  Copyright © 2020 Angus. All rights reserved.
//

import UIKit


class NoInternetViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "No internet detected"
        descLabel.text = ""
    }

    static func Show(presenter: UIViewController) -> NoInternetViewController {
        let controller = NoInternetViewController(nibName: "NoInternetViewController", bundle: nil)
        controller.modalPresentationStyle = .overCurrentContext
        presenter.present(controller, animated: false, completion: nil)
        return controller
    }
    
    static func addChild(presenter: UIViewController) -> NoInternetViewController {
        let controller = NoInternetViewController(nibName: "NoInternetViewController", bundle: nil)
        presenter.addChild(controller)
        presenter.view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.didMove(toParent: presenter)
        controller.view.leadingAnchor.constraint(equalTo: presenter.view.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: presenter.view.trailingAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: presenter.view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: presenter.view.bottomAnchor).isActive = true
        controller.view.layoutIfNeeded()
        
        return controller
    }
}
