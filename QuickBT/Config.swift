//
//  Config.swift
//  QuickBT
//
//  Created by Jesse Zhu on 2018/03/19.
//  Copyright © 2018 Jesse Zhu. All rights reserved.
//

import Foundation


enum UserSettings: String {
    case RunAfterCommand = "RunAfterCommand"
    case AutoConnect = "AutoConnect"
    case AutoConnectAddress = "AutoConnectAddress"
    
    func set(value: Int) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func integer() -> Int {
        return UserDefaults.standard.integer(forKey: self.rawValue)
    }
    
    func set(value: Float) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func float() -> Float {
        return UserDefaults.standard.float(forKey: self.rawValue)
    }
    
    func set(value: Double) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func double() -> Double {
        return UserDefaults.standard.double(forKey: self.rawValue)
    }
    
    func set(value: Bool) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func bool() -> Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }
    
    func set(value: Any) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func object() -> Any? {
        return UserDefaults.standard.object(forKey: self.rawValue)
    }
}


enum RunAfterCommand: String {
    case DoNothing = "什么也不做"
    case PlayMusic = "随机播放音乐"
    case PlayMusicAndExit = "随机播放音乐并退出"
    case Exit = "退出"
    case NONE = ""
    
    public static let allCommands: [RunAfterCommand] = [.DoNothing, .PlayMusic, .PlayMusicAndExit]
    
    public static func getCommandByString(value: String) -> RunAfterCommand {
        switch value {
        case "DoNothing":
            return .DoNothing
        case "PlayMusic":
            return .PlayMusic
        case "PlayMusicAndExit":
            return .PlayMusicAndExit
        case "Exit":
            return .Exit
        default:
            return .NONE
        }
    }
}
