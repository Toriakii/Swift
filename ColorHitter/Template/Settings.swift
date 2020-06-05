//
//  Settings.swift
//  ColorHitter
//
//  Created by Ricardo Moreira on 05/06/2020.
//  Copyright © 2020 Ricardo Moreira. All rights reserved.
//
// Basically holds all the constants that will be used

import SpriteKit

enum PhysicsCategories {
    static let none: UInt32 = 0 // 0
    static let ballCategory: UInt32 = 0x1 // 01
    static let switchCategory: UInt32 = 0x1 << 1 // -> shifts all the bits by one to the left so, in this case, it's 10
}

// Layers positions in the screen. This is so we can have the score and the game in different layers
enum ZPositions {
    static let label: CGFloat = 0.0
    static let ball: CGFloat = 1.0
    static let colorSwitch: CGFloat = 2.0
}
