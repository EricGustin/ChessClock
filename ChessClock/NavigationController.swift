//
//  NavigationController.swift
//  ChessClock
//
//  Created by Eric Gustin on 7/19/20.
//  Copyright © 2020 Eric Gustin. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
  init(_ rootVC: UIViewController) {
    super.init(nibName: nil, bundle: nil)
    pushViewController(rootVC, animated: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
