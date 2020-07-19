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
    button.isHidden = true
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
  
  var topTimerInitialTime = 5401.0
  private var topTimerTimeRemaining = 5401.0
  private var topTimerLabel: UILabel?
  private var topTimer: Timer?
  
  var bottomTimerInitialTime = 120.0
  private var bottomTimerTimeRemaining = 120.0
  private var bottomTimerLabel: UILabel?
  private var bottomTimer: Timer?
  
  private var topTurnCount = 0
  private var topTurnCountLabel: UILabel?
  
  private var bottomTurnCount = 0
  private var bottomTurnCountLabel: UILabel?
  
  
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
    
    refreshButton.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
    middleBarBackground.addSubview(refreshButton)
    refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width*0.2).isActive = true
    refreshButton.centerYAnchor.constraint(equalTo: middleBarBackground.centerYAnchor).isActive = true
    refreshButton.heightAnchor.constraint(equalTo: middleBarBackground.heightAnchor, multiplier: 0.5).isActive = true
    refreshButton.widthAnchor.constraint(equalTo: middleBarBackground.heightAnchor, multiplier: 0.5).isActive = true
    
    pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
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
    formatTimeRemaining(timeRemaining: topTimerTimeRemaining, timerLabel: topTimerLabel!)
    topTimerLabel?.font = UIFont.boldSystemFont(ofSize: 80)
    topTimerLabel?.translatesAutoresizingMaskIntoConstraints = false
    topBackground.addSubview(topTimerLabel!)
    topTimerLabel!.centerXAnchor.constraint(equalTo: topBackground.centerXAnchor).isActive = true
    topTimerLabel!.centerYAnchor.constraint(equalTo: topBackground.centerYAnchor).isActive = true
    
    bottomTimerLabel = UILabel()
    formatTimeRemaining(timeRemaining: bottomTimerTimeRemaining, timerLabel: bottomTimerLabel!)
    bottomTimerLabel?.font = UIFont.boldSystemFont(ofSize: 80)
    bottomTimerLabel?.translatesAutoresizingMaskIntoConstraints = false
    bottomBackground.addSubview(bottomTimerLabel!)
    bottomTimerLabel!.centerXAnchor.constraint(equalTo: bottomBackground.centerXAnchor).isActive = true
    bottomTimerLabel!.centerYAnchor.constraint(equalTo: bottomBackground.centerYAnchor).isActive = true
    
    topTurnCountLabel = UILabel()
    topTurnCountLabel?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    topTurnCountLabel?.text = "\(topTurnCount)"
    topTurnCountLabel?.textColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
    topTurnCountLabel?.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(topTurnCountLabel!)
    topTurnCountLabel?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    topTurnCountLabel?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    
    bottomTurnCountLabel = UILabel()
    bottomTurnCountLabel?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    bottomTurnCountLabel?.text = "\(bottomTurnCount)"
    bottomTurnCountLabel?.textColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
    bottomTurnCountLabel?.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bottomTurnCountLabel!)
    bottomTurnCountLabel?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    bottomTurnCountLabel?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
  }
  
  @objc func topCounter() {
    topTimerTimeRemaining -= 0.1
    formatTimeRemaining(timeRemaining: topTimerTimeRemaining, timerLabel: topTimerLabel!)
  }
  
  @objc func bottomCounter() {
    
    bottomTimerTimeRemaining -= 0.1
    formatTimeRemaining(timeRemaining: bottomTimerTimeRemaining, timerLabel: bottomTimerLabel!)
  }
  
  @objc func topCounterClicked() {
    if bottomTimer != nil && bottomTimer!.isValid { return }
    pauseButton.isHidden = false
    topBackground.backgroundColor = .brown
    topTimerLabel?.textColor = .white
    bottomBackground.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    bottomTimerLabel?.textColor = .black
    bottomTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(bottomCounter), userInfo: nil, repeats: true)
    topTimer?.invalidate()
    topTurnCount += 1
    topTurnCountLabel?.text = "\(topTurnCount)"
  }
  
  @objc func bottomTimerClicked() {
    if topTimer != nil && topTimer!.isValid { return }
    pauseButton.isHidden = false
    bottomBackground.backgroundColor = .brown
    bottomTimerLabel?.textColor = .white
    topBackground.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    topTimerLabel?.textColor = .black
    topTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(topCounter), userInfo: nil, repeats: true)
    bottomTimer?.invalidate()
    bottomTurnCount += 1
    bottomTurnCountLabel?.text = "\(topTurnCount)"
  }
  
  @objc func pause() {
    pauseButton.isHidden = true
    topTimer?.invalidate()
    bottomTimer?.invalidate()
    topBackground.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    bottomBackground.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    topTimerLabel?.textColor = .black
    bottomTimerLabel?.textColor = .black
  }
  
  @objc func refreshButtonClicked() {
    let resetAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let cancelAction = UIAlertAction(title: "Reset", style: .default) { (action) in
      self.reset()
    }
    cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(resetAction)
    alert.addAction(cancelAction)
    
    pause()
    
    self.present(alert, animated: true, completion: nil)
  }
  
  private func reset() {
    pause() // sets a lot of the views to their original state
    topTurnCount = 0
    bottomTurnCount = 0
    topTurnCountLabel?.text = "\(topTurnCount)"
    bottomTurnCountLabel?.text = "\(bottomTurnCount)"
    topTimerTimeRemaining = topTimerInitialTime
    bottomTimerTimeRemaining = bottomTimerInitialTime
    topTimerLabel?.text = "\(topTimerTimeRemaining)"
    bottomTimerLabel?.text = "\(bottomTimerTimeRemaining)"
  }
  
  private func formatTimeRemaining(timeRemaining: Double, timerLabel: UILabel) {
    let hours = timeRemaining / 3600
    let minutes = hours.truncatingRemainder(dividingBy: 1) * 60
    let seconds = minutes.truncatingRemainder(dividingBy: 1) * 60
    let decaseconds = seconds.truncatingRemainder(dividingBy: 1) * 10
    
    if hours >= 1 {
      timerLabel.text = String(format: "%d:%02d:%02d", Int(hours), Int(minutes), Int(seconds))
    } else if minutes >= 1 || seconds >= 10 {
      timerLabel.text = String(format: "%d:%02d", Int(minutes), Int(seconds))
    } else {
      timerLabel.text = String(format: "%d:%02d:%d", Int(minutes), Int(seconds), Int(decaseconds))
    }
  }
  
}

