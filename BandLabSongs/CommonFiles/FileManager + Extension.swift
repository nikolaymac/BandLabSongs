//
//  FileManager + Extension.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import Foundation
extension FileManager {
     static func isNotEmptySizeFile(path: String) -> Bool {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path)
            return (attr[FileAttributeKey.size] as! UInt64) != 0
        } catch {
            return false
        }
    }
}
