//
//  NoDataViewController.swift
//  Experience
//
//  Created by ali on 2020-02-08.
//  Copyright © 2020 Angus. All rights reserved.
//

import UIKit

class NoDataViewController: UIViewController {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var noRequestLayer1: UIImageView!
    @IBOutlet weak var noRequestLayer2: UIImageView!
    @IBOutlet weak var noRequestLayer3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    static func Show(presenter: UIViewController, message: String?, caption: String?, images: [String]?) -> NoDataViewController {
        let controller = NoDataViewController(nibName: "NoDataViewController", bundle: Bundle.module)
        controller.modalPresentationStyle = .overCurrentContext
        presenter.present(controller, animated: false, completion: nil)
        
        if let message = message {
            controller.message.text = message
        } else {
            controller.message.text = nil
        }
        if let caption = caption {
            controller.caption.text = caption
        } else {
            controller.caption.text = nil
        }
        if let images = images {
            let imageViews = [controller.noRequestLayer1,
                              controller.noRequestLayer2,
                              controller.noRequestLayer3]
            for i in 0..<imageViews.count {
                if i < images.count {
                    imageViews[i]!.image = UIImage(named: images[i])
                } else {
                    imageViews[i]!.image = nil
                }
            }
        }
        return controller
    }
    
    static func addChild(presenter: UIViewController, message: String?, caption: String?, images: [String]?) -> NoDataViewController {
        let controller = NoDataViewController(nibName: "NoDataViewController", bundle: Bundle.module)
        presenter.addChild(controller)
        presenter.view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.didMove(toParent: presenter)
        controller.view.leadingAnchor.constraint(equalTo: presenter.view.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: presenter.view.trailingAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: presenter.view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: presenter.view.bottomAnchor).isActive = true
        controller.view.layoutIfNeeded()
        
        if let message = message {
            controller.message.text = message
        } else {
            controller.message.text = nil
        }
        if let caption = caption {
            controller.caption.text = caption
        } else {
            controller.caption.text = nil
        }
        if let images = images {
            let imageViews = [controller.noRequestLayer1,
                              controller.noRequestLayer2,
                              controller.noRequestLayer3]
            for i in 0..<imageViews.count {
                if i < images.count {
                    imageViews[i]!.image = UIImage(named: images[i])
                } else {
                    imageViews[i]!.image = nil
                }
            }
        }
        return controller
    }
}
