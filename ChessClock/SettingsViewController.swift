//
//  SettingsViewController.swift
//  ChessClock
//
//  Created by Eric Gustin on 7/19/20.
//  Copyright © 2020 Eric Gustin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = StandardColors.customDarkGray
    navigationController?.navigationBar.backgroundColor = StandardColors.customLightGray
    navigationController?.navigationBar.tintColor = StandardColors.customLightGray
    navigationController?.navigationBar.barTintColor = StandardColors.customDarkGray
  }
  
}
