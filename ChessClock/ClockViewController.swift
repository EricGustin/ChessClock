//
//  ClockViewController.swift
//  ChessClock
//
//  Created by Eric Gustin on 7/17/20.
//  Copyright © 2020 Eric Gustin. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {

  let topBackground: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let middleBarBackground: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let refreshButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
    button.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  var pauseButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
    button.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let settingsButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(UIImage(systemName: "gear"), for: .normal)
    button.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let bottomBackground: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private var topTimerTimeRemaining = 60.0
  private var topTimerLabel: UILabel?
  private var topTimer: Timer?
  
  private var bottomTimerTimeRemaining = 60.0
  private var bottomTimerLabel: UILabel?
  private var bottomTimer: Timer?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpSubviews()
  }

  private func setUpSubviews() {
    
    topBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topCounterClicked)))
    view.addSubview(topBackground)
    topBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    topBackground.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    topBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
    
    view.addSubview(middleBarBackground)
    middleBarBackground.topAnchor.constraint(equalTo: topBackground.bottomAnchor).isActive = true
    middleBarBackground.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    middleBarBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    
    middleBarBackground.addSubview(refreshButton)
    refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width*0.2).isActive = true
    refreshButton.centerYAnchor.constraint(equalTo: middleBarBackground.centerYAnchor).isActive = true
    refreshButton.heightAnchor.constraint(equalTo: middleBarBackground.heightAnchor, multiplier: 0.5).isActive = true
    refreshButton.widthAnchor.constraint(equalTo: middleBarBackground.heightAnchor, multiplier: 0.5).isActive = true
    
    middleBarBackground.addSubview(pauseButton)
    pauseButton.centerXAnchor.constraint(equalTo: middleBarBackground.centerXAnchor).isActive = true
    pauseButton.centerYAnchor.constraint(equalTo: middleBarBackground.centerYAnchor).isActive = true
    pauseButton.heightAnchor.constraint(equalTo: middleBarBackground.heightAnchor, multiplier: 0.5).isActive = true
    pauseButton.widthAnchor.constraint(equalTo: middleBarBackground.heightAnchor, multiplier: 0.5).isActive = true
    
    middleBarBackground.addSubview(settingsButton)
    settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width*0.2).isActive = true
    settingsButton.centerYAnchor.constraint(equalTo: middleBarBackground.centerYAnchor).isActive = true
    settingsButton.heightAnchor.constraint(equalTo: middleBarBackground.heightAnchor, multiplier: 0.5).isActive = true
    settingsButton.widthAnchor.constraint(equalTo: middleBarBackground.heightAnchor, multiplier: 0.5).isActive = true
    
    
    bottomBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bottomTimerClicked)))
    view.addSubview(bottomBackground)
    bottomBackground.topAnchor.constraint(equalTo: middleBarBackground.bottomAnchor).isActive = true
    bottomBackground.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    bottomBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
    
    topTimerLabel = UILabel()
    topTimerLabel?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    topTimerLabel?.text = "\(topTimerTimeRemaining)"
    topTimerLabel?.font = UIFont.boldSystemFont(ofSize: 80)
    topTimerLabel?.translatesAutoresizingMaskIntoConstraints = false
    topBackground.addSubview(topTimerLabel!)
    topTimerLabel!.centerXAnchor.constraint(equalTo: topBackground.centerXAnchor).isActive = true
    topTimerLabel!.centerYAnchor.constraint(equalTo: topBackground.centerYAnchor).isActive = true
    
    bottomTimerLabel = UILabel()
    bottomTimerLabel?.text = "\(bottomTimerTimeRemaining)"
    bottomTimerLabel?.font = UIFont.boldSystemFont(ofSize: 80)
    bottomTimerLabel?.translatesAutoresizingMaskIntoConstraints = false
    bottomBackground.addSubview(bottomTimerLabel!)
    bottomTimerLabel!.centerXAnchor.constraint(equalTo: bottomBackground.centerXAnchor).isActive = true
    bottomTimerLabel!.centerYAnchor.constraint(equalTo: bottomBackground.centerYAnchor).isActive = true
  }
  
  @objc func topCounter() {
    topTimerTimeRemaining -= 0.1
    topTimerLabel?.text = String(format: "%.1f", topTimerTimeRemaining)
  }
  
  @objc func bottomCounter() {
    bottomTimerTimeRemaining -= 0.1
    bottomTimerLabel?.text = String(format: "%.1f", bottomTimerTimeRemaining)
  }
  
  @objc func topCounterClicked() {
    if bottomTimer != nil && bottomTimer!.isValid { return }
    topBackground.backgroundColor = .brown
    topTimerLabel?.textColor = .white
    bottomBackground.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    bottomTimerLabel?.textColor = .black
    bottomTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(bottomCounter), userInfo: nil, repeats: true)
    topTimer?.invalidate()
  }
  
  @objc func bottomTimerClicked() {
    if topTimer != nil && topTimer!.isValid { return }
    bottomBackground.backgroundColor = .brown
    bottomTimerLabel?.textColor = .white
    topBackground.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    topTimerLabel?.textColor = .black
    topTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(topCounter), userInfo: nil, repeats: true)
    bottomTimer?.invalidate()
  }
  
}

