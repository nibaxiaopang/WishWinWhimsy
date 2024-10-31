//
//  Untitled.swift
//  WishWinWhimsy
//
//  Created by WishWinWhimsy on 2024/10/31.
//

import UIKit

var arrHistory: [String] = []{
    didSet{
        UserDefaults.standard.setValue(arrHistory, forKey: "hist")
    }
}
