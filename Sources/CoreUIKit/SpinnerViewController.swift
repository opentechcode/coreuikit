//
//  SpinnerViewController.swift
//  Experience
//
//  Created by ali on 2019-12-24.
//  Copyright © 2019 Angus. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayView.layer.cornerRadius = 10.0
        
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.overlayView.alpha = 0.8
            self?.activityIndicator.alpha = 1.0
        }
    }

    static func Show(presenter: UIViewController) -> SpinnerViewController {
        let controller = SpinnerViewController(nibName: "SpinnerViewController", bundle: nil)
        controller.modalPresentationStyle = .overCurrentContext
        presenter.present(controller, animated: false, completion: nil)
        return controller
    }
    
    static func addChild(presenter: UIViewController) -> SpinnerViewController {
        let controller = SpinnerViewController(nibName: "SpinnerViewController", bundle: nil)
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
