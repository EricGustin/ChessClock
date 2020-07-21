//
//  ClockViewController.swift
//  ChessClock
//
//  Created by Eric Gustin on 7/17/20.
//  Copyright © 2020 Eric Gustin. All rights reserved.
//

import UIKit
import AVFoundation

class ClockViewController: UIViewController {
  
  let topBackground: UIView = {
    let view = UIView()
    view.backgroundColor = StandardColors.customLightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let middleBarBackground: UIView = {
    let view = UIView()
    view.backgroundColor = StandardColors.customDarkGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let refreshButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
    button.tintColor = StandardColors.customLightGray
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  var pauseButton: UIButton = {
    let button = UIButton()
    button.isHidden = true
    button.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
    button.tintColor = StandardColors.customLightGray
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let settingsButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(UIImage(systemName: "gear"), for: .normal)
    button.tintColor = StandardColors.customLightGray
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let bottomBackground: UIView = {
    let view = UIView()
    view.backgroundColor = StandardColors.customLightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var topTimerInitialTime = 300.0
  var topTimerTimeRemaining = 300.0
  private var topTimerLabel: UILabel?
  private var topTimer: Timer?
  
  var bottomTimerInitialTime = 300.0
  var bottomTimerTimeRemaining = 300.0
  private var bottomTimerLabel: UILabel?
  private var bottomTimer: Timer?
  
  var topTurnCount = 0
  private var topTurnCountLabel: UILabel?
  
  var bottomTurnCount = 0
  private var bottomTurnCountLabel: UILabel?
  
  private var audioPlayer: AVAudioPlayer!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.setNavigationBarHidden(true, animated: true)
    
    formatTimeRemaining(timeRemaining: topTimerTimeRemaining, timerLabel: topTimerLabel!)
    formatTimeRemaining(timeRemaining: bottomTimerTimeRemaining, timerLabel: bottomTimerLabel!)
    topTurnCountLabel?.text = "\(topTurnCount)"
    bottomTurnCountLabel?.text = "\(bottomTurnCount)"
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
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
    
    settingsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsButtonClicked)))
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
    topTurnCountLabel?.textColor = StandardColors.customDarkGray
    topTurnCountLabel?.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(topTurnCountLabel!)
    topTurnCountLabel?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    topTurnCountLabel?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    
    bottomTurnCountLabel = UILabel()
    bottomTurnCountLabel?.text = "\(bottomTurnCount)"
    bottomTurnCountLabel?.textColor = StandardColors.customDarkGray
    bottomTurnCountLabel?.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bottomTurnCountLabel!)
    bottomTurnCountLabel?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    bottomTurnCountLabel?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
  }
  
  @objc func topCounter() {
    topTimerTimeRemaining -= 0.1
    formatTimeRemaining(timeRemaining: topTimerTimeRemaining, timerLabel: topTimerLabel!)
    if topTimerTimeRemaining <= 0.0 {
      gameOver(loserBackground: topBackground, loserLabel: topTimerLabel!)
    }
  }
  
  @objc func bottomCounter() {
    bottomTimerTimeRemaining -= 0.1
    formatTimeRemaining(timeRemaining: bottomTimerTimeRemaining, timerLabel: bottomTimerLabel!)
    if bottomTimerTimeRemaining <= 0.0 {
      gameOver(loserBackground: bottomBackground, loserLabel: bottomTimerLabel!)
    }
  }
  
  @objc func topCounterClicked() {
    if bottomTimer != nil && bottomTimer!.isValid { return }
    playSound(nameOfSound: "click")
    pauseButton.isHidden = false
    bottomBackground.backgroundColor = .brown
    bottomTimerLabel?.textColor = .white
    topBackground.backgroundColor = StandardColors.customLightGray
    topTimerLabel?.textColor = .black
    bottomTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(bottomCounter), userInfo: nil, repeats: true)
    topTimer?.invalidate()
    topTurnCount += 1
    topTurnCountLabel?.text = "\(topTurnCount)"
  }
  
  @objc func bottomTimerClicked() {
    if topTimer != nil && topTimer!.isValid { return }
    playSound(nameOfSound: "click")
    pauseButton.isHidden = false
    topBackground.backgroundColor = .brown
    topTimerLabel?.textColor = .white
    bottomBackground.backgroundColor = StandardColors.customLightGray
    bottomTimerLabel?.textColor = .black
    topTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(topCounter), userInfo: nil, repeats: true)
    bottomTimer?.invalidate()
    bottomTurnCount += 1
    bottomTurnCountLabel?.text = "\(topTurnCount)"
  }
  
  @objc func pause() {
    playSound(nameOfSound: "pauseButton")
    pauseButton.isHidden = true
    topTimer?.invalidate()
    bottomTimer?.invalidate()
    topBackground.backgroundColor = StandardColors.customLightGray
    bottomBackground.backgroundColor = StandardColors.customLightGray
    topTimerLabel?.textColor = .black
    bottomTimerLabel?.textColor = .black
  }
  
  @objc func refreshButtonClicked() {
    pauseButton.isHidden = true
    topTimer?.invalidate()
    bottomTimer?.invalidate()
    topBackground.backgroundColor = StandardColors.customLightGray
    bottomBackground.backgroundColor = StandardColors.customLightGray
    topTimerLabel?.textColor = .black
    bottomTimerLabel?.textColor = .black
    if topTimerTimeRemaining <= 0 {
      topBackground.backgroundColor = .red
      topTimerLabel?.textColor = .white
    } else if bottomTimerTimeRemaining <= 0 {
      bottomBackground.backgroundColor = .red
      bottomTimerLabel?.textColor = .white
    }
    
    let resetAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let cancelAction = UIAlertAction(title: "Reset", style: .default) { (action) in
      self.reset()
    }
    cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(resetAction)
    alert.addAction(cancelAction)
    
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
    formatTimeRemaining(timeRemaining: topTimerTimeRemaining, timerLabel: topTimerLabel!)
    formatTimeRemaining(timeRemaining: bottomTimerTimeRemaining, timerLabel: bottomTimerLabel!)
    topBackground.isUserInteractionEnabled = true
    bottomBackground.isUserInteractionEnabled = true
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
  
  private func gameOver(loserBackground: UIView, loserLabel: UILabel) {
    playSound(nameOfSound: "gameOver")
    topTimer?.invalidate()
    bottomTimer?.invalidate()
    loserBackground.backgroundColor = .red
    loserLabel.textColor = .white
    pauseButton.isHidden = true
    topBackground.isUserInteractionEnabled = false
    bottomBackground.isUserInteractionEnabled = false
  }
  
  private func playSound(nameOfSound: String) {
    guard let pathToSound = Bundle.main.path(forResource: nameOfSound, ofType: "wav") else { return }
    let url = URL(fileURLWithPath: pathToSound)
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer.play()
    } catch {
      print("Error when trying to play click sound")
    }
  }
  
  @objc func settingsButtonClicked() {
    pause()
    navigationController?.pushViewController(SettingsViewController(self), animated: true)
  }
  
}
