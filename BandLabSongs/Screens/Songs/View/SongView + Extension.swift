//
//  SongView + Extension.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation
import UIKit

extension SongView {
    
    func createNameSongLabel() -> UILabel {
        let label = UILabel()
        label.font = FontManager.songTitleFont()
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
       
        return label
    }
    
    func createActionButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        button.addTarget(self, action: #selector(pressButtonSong), for: .touchUpInside)
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }
    
    func createProgressView() -> CircleProgressBar {
        let view = CircleProgressBar(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.lineWidth = 2
        view.progress = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return view
    }
    
}
