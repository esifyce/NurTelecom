//
//  LaunchScreen.swift
//  so-KABAN
//
//  Created by Krasivo on 29.09.2022.
//

import UIKit

@main
public class LaunchScreen: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    public override init() {
        super.init()
        window = .init(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: Viewer())
        window?.makeKeyAndVisible()
    }
}
