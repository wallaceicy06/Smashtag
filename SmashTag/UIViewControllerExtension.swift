//
//  UIViewControllerExtension.swift
//  SmashTag
//
//  Created by Sean Harger on 10/1/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    var contentViewController: UIViewController {
        if let navCon = self as? UINavigationController {
            return navCon.topViewController ?? self
        } else {
            return self
        }
    }
}
