//
//  CustomTabView.swift
//  Miyu
//
//  Created by Mira Estil on 3/13/18.
//  Copyright © 2018 ME. All rights reserved.
//

//TODO: REFACTOR
import UIKit

class CustomTabView: UIView, CustomTabViewDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var viewModel: ProfileUserDataModel? = {
        return ProfileUserDataModel()
    }()
    
    private var userPosts = [Post]()
    
    private weak var store = DataStore.sharedInstance
    private weak var storeManager = DataStoreManager()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        setupTableView()
        loadData()
        tableView.isHidden = true
    }
    
    func initialLoad() {
        if (store?.userPosts.isEmpty)! {
            loadData()
        }
        tableView.isHidden = true
    }
    
    func reloadData() {
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    // MARK: SETUP
    func setupTableView() {
        addSubview(tableView)
        
        addConstraints(format: "H:|[v0]|", views: tableView)
        addConstraints(format: "V:|[v0]|", views: tableView)
        tableView.register(UINib(nibName: Constants.homeXib, bundle: nil),
                           forCellReuseIdentifier: Constants.homeCell)
    }
    
    func setupCollectionView() {
        addSubview(collectionView)
        
        addConstraints(format: "H:|[v0]|", views: collectionView)
        addConstraints(format: "V:|[v0]|", views: collectionView)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: Constants.customCollectionCell)
    }
    
    func loadData() {
        viewModel?.loadUserPosts({ [weak self] (post) in
            self?.store?.userPosts.append(post)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.tableView.reloadData()
            }
        })
        storeManager?.saveData((self.store?.userPosts)!, store: store!, pathComponent: .userData)
    }
    
    // MARK: FUNCTIONALITY
    func tappedThat(_ viewInt: Int) {
        switch viewInt {
        case 0:
            collectionView.isHidden = false
            tableView.isHidden = true
        case 1:
            collectionView.isHidden = true
            tableView.isHidden = false
        default:
            break
        }
    }
}

extension CustomTabView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return userPosts.count
        guard let count = store?.userPosts.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeCell, for: indexPath) as! HomepageTableViewCell
        
        guard let userPosts = store?.userPosts else { return UITableViewCell() }
        let currentCell = userPosts[(userPosts.count-1) - indexPath.row]
        let uid = currentCell.uid!
        
        // Setup
        cell.setupCell(uid)
        cell.post = currentCell
        
        if let url = currentCell.data {
            cell.contentImage.loadCachedImage(url)
        }

        return cell
    }
}

extension CustomTabView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = store?.userPosts.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.customCollectionCell, for: indexPath) as? ProfileCollectionViewCell
        
        guard let userPosts = store?.userPosts else { return UICollectionViewCell() }
        let currentCell = userPosts[(userPosts.count-1) - indexPath.row]
        
        if let contentUrl = currentCell.data {
            cell?.imageView.loadCachedImage(contentUrl)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TAPPED IT AGAIN \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width)/3, height: (self.frame.height)/3)
    }
}

// TODO: REFACTOR TO OWN file

class ProfileCollectionViewCell: BaseCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addConstraints(format: "H:|[v0]|", views: imageView)
        addConstraints(format: "V:|[v0]|", views: imageView)
    }
}


