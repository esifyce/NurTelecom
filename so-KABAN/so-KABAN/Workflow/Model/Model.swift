//
//  Model.swift
//  so-KABAN
//
//  Created by Krasivo on 29.09.2022.
//

import Foundation

extension Model {
    struct Appearance {
        var xPig = 0
        var yPig = 0
        var playersFaceLookingDirection: PlayersDirection = .down
        var numberOfTargets = 0
        var currentLevel = 1
        
        var emptySpace = 0
        var player = 1
        var wall = 2
        var box = 3
        var target = 4
        var boxOnTarget = 5
    }
}

public final class Model {

    // MARK: - Property
    
    fileprivate var appearance = Appearance()
    fileprivate let viewer: Viewer
    fileprivate let levels: Levels
    fileprivate var map: [[Int]]
    
    // MARK: - INIT
    
    init(viewer: Viewer) {
        self.viewer = viewer
        levels = Levels()
        map = levels.getLevel(number: appearance.currentLevel)
        getPlayerPositions()
        initData()
    }
    
    fileprivate func initData() {
        appearance.numberOfTargets = 0
        for i in map {
            for j in i {
                if j == 4 {
                    appearance.numberOfTargets += 1
                }
            }
        }
    }
}

// MARK: - fileprivate Model methods

fileprivate extension Model {
    
    // MARK: - getting players position
    
    func getPlayerPositions() {
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x] == appearance.player {
                    appearance.yPig = y
                    appearance.xPig = x
                }
            }
        }
    }
    
    // MARK: - move Left
    
    func moveLeft() {
        if map[appearance.yPig][appearance.xPig - 1] == appearance.emptySpace {
            map[appearance.yPig][appearance.xPig - 1] = appearance.player
            map[appearance.yPig][appearance.xPig] = appearance.emptySpace
            
        } else if map[appearance.yPig][appearance.xPig - 1] == appearance.box {
            if map[appearance.yPig][appearance.xPig - 2] == appearance.emptySpace {
                map[appearance.yPig][appearance.xPig - 2] = appearance.box
                map[appearance.yPig][appearance.xPig - 1] = appearance.player
                map[appearance.yPig][appearance.xPig] = appearance.emptySpace
                
            } else if map[appearance.yPig][appearance.xPig - 2] == appearance.target {
                map[appearance.yPig][appearance.xPig - 2] = appearance.boxOnTarget
                map[appearance.yPig][appearance.xPig - 1] = appearance.player
                map[appearance.yPig][appearance.xPig] = appearance.emptySpace
                
            }
        }
        appearance.playersFaceLookingDirection = .left
    }
    
    // MARK: - move Right
    
    func moveRight() {
        if map[appearance.yPig][appearance.xPig + 1] == appearance.emptySpace {
            map[appearance.yPig][appearance.xPig + 1] = appearance.player
            map[appearance.yPig][appearance.xPig] = appearance.emptySpace
            
        } else if map[appearance.yPig][appearance.xPig + 1] == appearance.box {
            if map[appearance.yPig][appearance.xPig + 2] == appearance.emptySpace {
                map[appearance.yPig][appearance.xPig + 2] = appearance.box
                map[appearance.yPig][appearance.xPig + 1] = appearance.player
                map[appearance.yPig][appearance.xPig] = appearance.emptySpace
                
            } else if map[appearance.yPig][appearance.xPig + 2] == appearance.target {
                map[appearance.yPig][appearance.xPig + 2] = appearance.boxOnTarget
                map[appearance.yPig][appearance.xPig + 1] = appearance.player
                map[appearance.yPig][appearance.xPig] = appearance.emptySpace
                
            }
        }
        appearance.playersFaceLookingDirection = .right
    }
    
    // MARK: - move Up
    
    func moveUp() {
        if map[appearance.yPig - 1][appearance.xPig] == appearance.emptySpace {
            map[appearance.yPig - 1][appearance.xPig] = appearance.player
            map[appearance.yPig][appearance.xPig] = appearance.emptySpace
        } else if map[appearance.yPig - 1][appearance.xPig] == appearance.box {
            if map[appearance.yPig - 2][appearance.xPig] == appearance.emptySpace {
                map[appearance.yPig - 2][appearance.xPig] = appearance.box
                map[appearance.yPig - 1][appearance.xPig] = appearance.player
                map[appearance.yPig][appearance.xPig] = appearance.emptySpace
            } else if map[appearance.yPig - 2][appearance.xPig] == appearance.target {
                map[appearance.yPig - 2][appearance.xPig] = appearance.boxOnTarget
                map[appearance.yPig - 1][appearance.xPig] = appearance.player
                map[appearance.yPig][appearance.xPig] = appearance.emptySpace
            }
        }
        appearance.playersFaceLookingDirection = .up
    }
        
    // MARK: - move down
    
    func moveDown() {
        if map[appearance.yPig + 1][appearance.xPig] == appearance.emptySpace {
            map[appearance.yPig + 1][appearance.xPig] = appearance.player
            map[appearance.yPig][appearance.xPig] = appearance.emptySpace
        } else if map[appearance.yPig + 1][appearance.xPig] == appearance.box {
            if map[appearance.yPig + 2][appearance.xPig] == appearance.emptySpace {
                map[appearance.yPig + 2][appearance.xPig] = appearance.box
                map[appearance.yPig + 1][appearance.xPig] = appearance.player
                map[appearance.yPig][appearance.xPig] = appearance.emptySpace
            } else if map[appearance.yPig + 2][appearance.xPig] == appearance.target {
                map[appearance.yPig + 2][appearance.xPig] = appearance.boxOnTarget
                map[appearance.yPig + 1][appearance.xPig] = appearance.player
                map[appearance.yPig][appearance.xPig] = appearance.emptySpace
            }
        }
        appearance.playersFaceLookingDirection = .down
    }
    
    func checkIfWin() {
        var targetsDone = 0
        for i in map {
            for j in i {
                if j == appearance.boxOnTarget {
                    targetsDone += 1
                }
            }
        }
        if targetsDone == appearance.numberOfTargets {
            viewer.congratulate(appearance.currentLevel)
            appearance.currentLevel += 1
            startNewLevel()
        }
    }
}

// MARK: - public Model methods

public extension Model {
    
    // MARK: - move action switcher
    
    func move(to: ActionDirection) {
        getPlayerPositions()
        switch to {
        case .left:
            moveLeft()
            break
        case .right:
            moveRight()
            break
        case .up:
            moveUp()
            break
        case .down:
            moveDown()
            break
        }
        viewer.update()
        checkIfWin()
    }
    
    func startNewLevel() {
        map = levels.getLevel(number: appearance.currentLevel)
        appearance.playersFaceLookingDirection = .down
        initData()
        viewer.update()
    }
    
    func getPlayersDirection() -> PlayersDirection {
        return appearance.playersFaceLookingDirection
    }
    
    // MARK: - returning map
    
    func getMap() -> [[Int]] {
        return map
    }
    
    func startLevel(_ number: Int) {
        appearance.currentLevel = number
        startNewLevel()
    }
}
