//
//  MediaLoader.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation

protocol LoaderMediaProtocol {
    func startDownload(_ song: MediaItem)
    func stopAllTasks()
    var updateProgress:((MediaItem)->Void)? { get set }
    var showAlert: ((String, String, (() -> Void)?) -> Void)? { get set }
}

protocol LoaderProtocol: LoaderMediaProtocol{
    var songsDownloadTasks: [URL : DownloadMediaTask] { get }
}

final class MediaLoader: NSObject, LoaderProtocol  {
    
    static var shared: MediaLoader = MediaLoader()

    var songsDownloadTasks: [URL : DownloadMediaTask] = [:]
    
    fileprivate let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.test.bandlabsongs.bgSession")
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    var updateProgress:((MediaItem)->Void)?
    var showAlert: ((String, String, (() -> Void)?) -> Void)?
    
   
    
    func startDownload(_ song: MediaItem) {
        guard let urlString = song.url, let url = URL(string: urlString) else {return}
        if let download = songsDownloadTasks[url] {
            if download.item.state == .downloading {
                return
            }else{
                download.task?.cancel()
                songsDownloadTasks[url] = nil
            }
        }
        
        if !NetworkMonitor.shared.isConnectionInternet{
            self.showAlert?("Error LoadData", NetworkResponseError.noInternetConnection.localizedDescription, nil)
            return
        }

        let downloadTask = DownloadMediaTask(item: song)
        downloadTask.task = downloadsSession.downloadTask(with: url)
        downloadTask.task?.resume()
        downloadTask.item.changeState(.downloading)
        songsDownloadTasks[url] = downloadTask
    }
    
    func stopAllTasks() {
        songsDownloadTasks.values.forEach { downloadTask in
            downloadTask.task?.cancel()
        }
        songsDownloadTasks.removeAll()
    }
    
    fileprivate func getLocalFilePath(for item: MediaItem) -> URL {
        let dataPath = documentsPath.appendingPathComponent(SettingsApp.folderForSongs)
        if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        return dataPath.appendingPathComponent("\(item.name ?? String(Date().timeIntervalSince1970))")
    }
    fileprivate func errorDownload(item: MediaItem, textError: String) {
        item.changeState(.needToDownload)
        self.showAlert?("Error Download", textError, nil)
    }

}
extension MediaLoader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        guard let url = downloadTask.originalRequest?.url else {
            return
        }
        
        let download = songsDownloadTasks[url]
        songsDownloadTasks[url] = nil
        
        guard let item = download?.item else {return}
        
        if let error = downloadTask.error {
            errorDownload(item: item, textError: error.localizedDescription)
            return
        }
        
        if let httpResponse = downloadTask.response as? HTTPURLResponse, httpResponse.statusCode != 200{
            errorDownload(item: item, textError: "Unknown error")
            return
        }
        let destinationURL = getLocalFilePath(for: item)
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            if FileManager.isNotEmptySizeFile(path: destinationURL.path) {
                item.saveLocalPath(destinationURL)
                item.changeState(.downloaded)
            }else{
                item.changeState(.needToDownload)
            }
            
            updateProgress?(item)
            
        } catch {
            showAlert?("Error Loader", error.localizedDescription, nil)
            print("Error wirte file to disk: \(error.localizedDescription)")
        }
        
    }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                  totalBytesExpectedToWrite: Int64) {
      
      guard let url = downloadTask.originalRequest?.url, let download = songsDownloadTasks[url] else {
          return
      }

      download.item.progressValue = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)//download.progress
      download.item.changeState(.downloading)
      self.updateProgress?(download.item)
  }
}


