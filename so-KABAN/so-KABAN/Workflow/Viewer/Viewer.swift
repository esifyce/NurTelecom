//
//  Viewer.swift
//  so-KABAN
//
//  Created by Krasivo on 29.09.2022.
//

import UIKit

public final class Viewer: UIViewController {
    
    // MARK: - Property
    
    private var controller: Controller?
    private var canvas: Canvas?

    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        canvas = Canvas()
        controller = .init(viewer: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        canvas = Canvas()
        controller = .init(viewer: self)
    }
    
    // MARK: - lifecycle VC
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getCanvasModel()
        setAllSwipes()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        update()
    }
    
    /// turn on landscape mode
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }

    /// accept landscape mode
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    // MARK: - Selectors
    
    @objc
    private func rightButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Пожалуйста выберите уровень!", message: nil, preferredStyle: .alert)
        for i in 1...9 {
            alert.addAction(UIAlertAction(title: "Уровень \(i)", style: .default, handler: { [weak self] (_) in
                self?.controller?.goToLevel(number: i)
                self?.turnDevice(i)
            }))
        }
        alert.view.tintColor = .black
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func leftButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Ты уверен, что хочешь начать сначала?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Нет.", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Да.", style: .default, handler: { (_) in
            self.controller?.restartTheLevel()
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - fileprivate Viewer methods

fileprivate extension Viewer {
    
    // MARK: - ConfigureUI
    
    func configureUI() {
        view.backgroundColor = .white
        playFarm()
        setNavigation()
        setViews()
        setConstraints()
    }
    
    func setNavigation() {
        title = "КАБАН"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Уровень", style: .plain, target: self, action: #selector(rightButtonTapped(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Перезапустить", style: .plain, target: self, action: #selector(leftButtonTapped(_:)))
    }
    
    func setViews() {
        view.addSubview(canvas!)
    }
    
    func setConstraints() {
        canvas!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvas!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            canvas!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            canvas!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            canvas!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - Helpers
    
    func getCanvasModel() {
        let model = controller!.getModel()
        canvas!.connectToModel(model: model)
    }

    func setAllSwipes() {
        let up = UISwipeGestureRecognizer(target: controller, action: #selector(controller!.panPerformed(_:)))
        let left = UISwipeGestureRecognizer(target: controller, action: #selector(controller!.panPerformed(_:)))
        let down = UISwipeGestureRecognizer(target: controller, action: #selector(controller!.panPerformed(_:)))
        let right = UISwipeGestureRecognizer(target: controller, action: #selector(controller!.panPerformed(_:)))
        
        up.direction = .up
        left.direction = .left
        down.direction = .down
        right.direction = .right
        
        view.addGestureRecognizer(up)
        view.addGestureRecognizer(left)
        view.addGestureRecognizer(down)
        view.addGestureRecognizer(right)
    }
    
    func playFarm() {
        controller?.pigSound()
    }
    
    func playComplete() {
        controller?.completeSound()
    }
}

// MARK: - public Viewer methods

public extension Viewer {
    func update() {
        canvas!.update()
    }
    
    func congratulate(_ level: Int) {
        controller?.player?.stop()
        playComplete()
        let alert = UIAlertController(title: "Поздравляю!", message: "Ты прошел уровень \(level)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { [weak self] alert in
            self?.playFarm()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func turnDevice(_ level: Int) {
        if level == 7 || level == 8 || level == 9 {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            guard !UIApplication.shared.statusBarOrientation.isLandscape else { return }
            let alert = UIAlertController(title: "ПОВЕРНИТЕ УСТРОЙСТВО!", message: "Пожалуйста, поверните устройство в ландшафтный режим, чтобы отобразить карту полностью.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
}
