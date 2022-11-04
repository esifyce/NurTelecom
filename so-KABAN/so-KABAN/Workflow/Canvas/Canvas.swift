//
//  Canvas.swift
//  so-KABAN
//
//  Created by Krasivo on 29.09.2022.
//

import UIKit

extension Canvas {
    struct Appearance {
        var pigUp: UIImage? = .init(named: "up")
        var pigLeft: UIImage? = .init(named: "left")
        var pigDown: UIImage? = .init(named: "down")
        var pigRight: UIImage? = .init(named: "right")
        var wall: UIImage? = .init(named: "wall")
        var grayApoat: UIImage? = .init(named: "grayApoat")
        var apoat: UIImage? = .init(named: "apoat")
        var goal: UIImage? = .init(named: "goal")
        var ground: UIImage? = .init(named: "ground")
        
        var emptySpace = 0
        var player = 1
        var walls = 2
        var box = 3
        var target = 4
        var boxOnTarget = 5
    }
}

public final class Canvas: UIView {
    
    // MARK: - Property
    
    fileprivate let appearance = Appearance()
    fileprivate var model: Model?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBrown
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .systemBrown
    }
    
    // MARK: - Draw UI
    
    public override func draw(_ rect: CGRect) {
        let desktop: [[Int]] = model!.getMap()
        let width: CGFloat = (UIDevice.current.orientation.isLandscape ? frame.height: frame.width) / CGFloat(desktop.count)
        let height: CGFloat = (UIDevice.current.orientation.isLandscape ? frame.height: frame.width) / CGFloat(desktop.count)
        var x: CGFloat = UIDevice.current.orientation.isLandscape ? (frame.width - frame.height) / 2 : 0
        var y: CGFloat = UIDevice.current.orientation.isLandscape ? 0 : (frame.height - frame.width) / 2
        for i in desktop {
            for j in i {
                switch j {
                case appearance.emptySpace:
                    appearance.ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                case appearance.player:
                    movePlayerAppearance(x: x, y: y, width: width, height: height)
                case appearance.walls:
                    appearance.ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    appearance.wall?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                case appearance.box:
                    appearance.ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    appearance.apoat?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                case appearance.target:
                    appearance.ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    appearance.goal?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                case appearance.boxOnTarget:
                    appearance.ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    appearance.grayApoat?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                default:
                    appearance.ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                }
                x += width
            }
            x = UIDevice.current.orientation.isLandscape ? (frame.width - frame.height) / 2 : 0
            y += height
        }
    }
}

// MARK: - fileprivate Canvas methods

fileprivate extension Canvas {
    func movePlayerAppearance(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        appearance.ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
        switch model?.getPlayersDirection() {
        case .down:
            appearance.pigDown?.draw(in: CGRect (x: x, y: y, width: width, height: height))
        case .up:
            appearance.pigUp?.draw(in: CGRect (x: x, y: y, width: width, height: height))
        case .left:
            appearance.pigLeft?.draw(in: CGRect (x: x, y: y, width: width, height: height))
        case .right:
            appearance.pigRight?.draw(in: CGRect (x: x, y: y, width: width, height: height))
        case .none:
            appearance.ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
        }
    }
}

// MARK: - public Canvas methods

public extension Canvas {
    func connectToModel(model: Model) {
        self.model = model
    }
    
    func update() {
        setNeedsDisplay()
    }
}
