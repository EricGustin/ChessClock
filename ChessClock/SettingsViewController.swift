//
//  SettingsViewController.swift
//  ChessClock
//
//  Created by Eric Gustin on 7/19/20.
//  Copyright © 2020 Eric Gustin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  private var tableView: UITableView!
  private var timeControlLabels: [String]!
  private var startButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = StandardColors.customDarkGray
    navigationController?.navigationBar.backgroundColor = StandardColors.customLightGray
    navigationController?.navigationBar.tintColor = StandardColors.customLightGray
    navigationController?.navigationBar.barTintColor = StandardColors.customDarkGray
    
    setUpSubview()
  }
  
  private func setUpSubview() {
    timeControlLabels = ["3 min", "3 min | 2 sec", "5 min", "15 min | 2 sec"]

    tableView = UITableView()
    tableView.backgroundColor = StandardColors.customDarkGray
    tableView.separatorColor = .black
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -(navigationController?.navigationBar.frame.height)!).isActive = true
    
    startButton = UIButton()
    startButton.setTitle("Start", for: .normal)
    startButton.backgroundColor = .brown
    startButton.titleLabel?.textColor = .white
    startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    startButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(startButton)
    startButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    startButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
    startButton.heightAnchor.constraint(equalToConstant: (navigationController?.navigationBar.frame.height)!).isActive = true
  }
  
  @objc func startButtonClicked() {
    navigationController?.popViewController(animated: true)
  }
  
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let backgroundView = UIView()
    backgroundView.backgroundColor = StandardColors.customLightGray
    cell.selectedBackgroundView = backgroundView
    cell.backgroundColor = StandardColors.customDarkGray
    cell.textLabel?.textColor = .white
    cell.textLabel!.text = timeControlLabels[indexPath.row]
    return cell
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return timeControlLabels.count
  }
  
}
