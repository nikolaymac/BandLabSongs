//
//  DownloadMediaTask.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation

class DownloadMediaTask {
    
  var task: URLSessionDownloadTask?
  var item: MediaItem
  
  init(item: MediaItem) {
    self.item = item
  }
}
