//
//  FontsManager.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation
import UIKit
final class FontManager {
    static func songTitleFont() -> UIFont {
        var fontSize: CGFloat = 12.0
        let size = UIApplication.shared.preferredContentSizeCategory
        
        switch size {
        case .extraLarge:
            fontSize = 12.0
        case .small:
            fontSize = 16.0
        case .medium:
            fontSize = 20.0
        case .large:
            fontSize = 26.0
        case .extraLarge:
            fontSize = 30.0
        case .extraExtraLarge:
            fontSize = 36.0
        default:
            fontSize = 12.0
        }
        return UIFont(name: "Helvetica", size: fontSize)!
    }
}
