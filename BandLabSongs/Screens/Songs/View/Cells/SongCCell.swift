//
//  SongCCell.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 18.03.2022.
//

import UIKit

class SongCCell: UICollectionViewCell {
    
    // I did not use xib or Storyboard at this project but i can do it :)
    // I just wanna show that i can make layout in code, because in team this is important my opinion
    
    let songView: SongView = {
        let view = SongView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupLayout()
    }
    
    func setup(){
        contentView.addSubview(songView)
    }
    
    func setupLayout() {
        
        songView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        songView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        songView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        songView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        
    }
    
}
