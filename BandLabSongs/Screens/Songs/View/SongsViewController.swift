//
//  SongsViewController.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 18.03.2022.
//

import UIKit

final class SongsViewController: UIViewController {
    
    // I did not use xib or Storyboard at this project but i can do it :)
    // I just wanna show that i can make layout in code, because in team this is important my opinion
    
  
    var viewModel: SongsViewModelClientProtocol!
    
    init(viewModel: SongsViewModelClientProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Use collectionView because in landscape orientation need two columns of items..
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(classes: [SongCCell.self])
        collectionView.refreshControl = refresher
        return collectionView
        
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresher
    }()

    
    //  This is for landscape orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setupViewModel()
    }
    
    private func setupScreen() {
        title = "Songs"
        view.addSubview(collectionView)
        setupLayout()
    }
    
    private func setupLayout() {
      
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true

    }
    
    private func setupViewModel() {
        
        viewModel.updateSongsData = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
        viewModel.updateOneSongByIndex = { [weak self] indexSong in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                
                if let cell = self.collectionView.cellForItem(at: IndexPath(item: indexSong, section: 0)) as? SongCCell {
                    cell.songView.song = self.viewModel.items[indexSong]
                }
            }
        }
        viewModel.showAlert = { [weak self] title, message, completion in
            DispatchQueue.main.async { [weak self] in
                let errorVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
                errorVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    completion?()
                }))
                self?.present(errorVC, animated: true, completion: nil)
            }
        }
        viewModel.setup()
        
    }
    
    @objc func refreshData() {
        viewModel.refreshData()
    }
    
}

// MARK: CollectionView - List of songs

extension SongsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongCCell.identifire, for: indexPath) as! SongCCell
        cell.songView.song = viewModel.items[indexPath.item]
        cell.songView.delegate = viewModel
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // just for example
        viewModel.tapOnSong(by: indexPath.item)
    }
   
}

extension SongsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if UIDevice.current.orientation == .portrait {
            return CGSize(width: collectionView.frame.width - 24, height: 200)
        }else{
            return CGSize(width: (collectionView.frame.width / 2) - 24, height: 100)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
}

