//
//  ThemeHelper.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import Foundation
import UIKit

enum Theme: String {
    case light, dark, system
}

class ThemeManager {
    static let shared = ThemeManager()
    
    private let themeKey = "selectedTheme"
    
    var currentTheme: Theme {
        get {
            let storedTheme = UserDefaults.standard.string(forKey: themeKey) ?? Theme.system.rawValue
            return Theme(rawValue: storedTheme) ?? .system
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: themeKey)
            applyTheme(newValue)
        }
    }
    
    func applyTheme(_ theme: Theme) {
        guard let window = UIApplication.shared.windows.first else { return }
        switch theme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        case .system:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
}
