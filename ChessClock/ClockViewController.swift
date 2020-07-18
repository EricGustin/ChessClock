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
  
  let bottomBackground: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private var topTimerTimeRemaining = 60
  private var topTimerLabel: UILabel?
  private var topTimer: Timer?
  
  private var bottomTimerTimeRemaining = 60
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
  
    bottomBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bottomTimerClicked)))
    view.addSubview(bottomBackground)
    bottomBackground.topAnchor.constraint(equalTo: middleBarBackground.bottomAnchor).isActive = true
    bottomBackground.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    bottomBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
    
    topTimerLabel = UILabel()
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
    topTimerTimeRemaining -= 1
    topTimerLabel?.text = "\(topTimerTimeRemaining)"
  }
  
  @objc func bottomCounter() {
    bottomTimerTimeRemaining -= 1
    bottomTimerLabel?.text = "\(bottomTimerTimeRemaining)"
  }
  
  @objc func topCounterClicked() {
    if bottomTimer != nil && bottomTimer!.isValid { return }
    bottomTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bottomCounter), userInfo: nil, repeats: true)
    topTimer?.invalidate()
  }
  
  @objc func bottomTimerClicked() {
    if topTimer != nil && topTimer!.isValid { return }
    topTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(topCounter), userInfo: nil, repeats: true)
    bottomTimer?.invalidate()
  }
  
}

