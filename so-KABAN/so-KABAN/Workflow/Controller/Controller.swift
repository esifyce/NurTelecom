//
//  Controller.swift
//  so-KABAN
//
//  Created by Krasivo on 29.09.2022.
//

import UIKit
import AVFoundation

public final class Controller {
    
    // MARK: - Property
    
    fileprivate let model: Model
    fileprivate let recognizer: UISwipeGestureRecognizer
    public var player: AVAudioPlayer?
    
    // MARK: - Init
    
    init(viewer: Viewer) {
        model = Model(viewer: viewer)
        recognizer = UISwipeGestureRecognizer()
    }
    
    // MARK: - Selectors
    
    @objc
    public func panPerformed(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .down:
            move(direction: .down)
        case .left:
            move(direction: .left)
        case .right:
            move(direction: .right)
        case .up:
            move(direction: .up)
        default:
            break
        }
    }
}

// MARK: - fileprivate Controller methods

fileprivate extension Controller {
    func move(direction: ActionDirection) {
        switch direction {
        case .left:
            model.move(to: .left)
        case .right:
            model.move(to: .right)
        case .up:
            model.move(to: .up)
        case .down:
            model.move(to: .down)
        }
    }
}

// MARK: - public Controller methods

public extension Controller {
    func getModel() -> Model {
        return model
    }
    
    func getRecognizer() -> UISwipeGestureRecognizer {
        return recognizer
    }
    
    func goToLevel(number: Int) {
        model.startLevel(number)
    }
    
    func restartTheLevel() {
        model.startNewLevel()
    }
    
    func pigSound() {
        guard let url = Bundle.main.url(forResource: "pig", withExtension: "wav") else { return }
        player = try! AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops =  -1 // set your count here
        player?.play()
    }
    
    func completeSound() {
        guard let url = Bundle.main.url(forResource: "completed", withExtension: "mp3") else { return }
        player = try! AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}
