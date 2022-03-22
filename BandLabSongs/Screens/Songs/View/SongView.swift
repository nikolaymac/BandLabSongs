//
//  SongView.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation
import UIKit

protocol SongViewDelegate: AnyObject {
    func pressButton(_ item: MediaItem)
}

class SongView: UIView {
    
    var song: MediaItem? {
        didSet {
            setNeedsLayout()
        }
    }
    weak var delegate: SongViewDelegate?
    
    lazy var nameSongLabel = createNameSongLabel()
    lazy var actionSongButton = createActionButton()
    lazy var progressSongView = createProgressView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateData()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .lightGray
        layer.cornerRadius = 8
    }
    
    private func updateData() {
        guard let song = self.song else {return}
        nameSongLabel.text = song.name
        actionSongButton.isHidden = false
        progressSongView.isHidden = true
        
        switch song.state {
            
        case .needToDownload:
            actionSongButton.setImage(UIImage(named:  "download-icon"), for: .normal)
        case .downloading:
            progressSongView.progress = CGFloat(song.progressValue)
            progressSongView.isHidden = false
            actionSongButton.isHidden = true
        case .downloaded, .paused:
            actionSongButton.setImage(UIImage(named: "pause-icon"), for: .normal)
        case .played:
            actionSongButton.setImage(UIImage(named: "play-icon"), for: .normal)
 
        }
    }
    
    @objc func pressButtonSong() {
        guard let song = self.song else {return}
        delegate?.pressButton(song)
    }
    
}

