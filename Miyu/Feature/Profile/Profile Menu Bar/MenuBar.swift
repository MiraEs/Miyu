//
//  MenuBar.swift
//  Miyu
//
//  Created by Mira Estil on 3/10/18.
//  Copyright © 2018 ME. All rights reserved.
//

import UIKit

class MenuBar: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    weak var customDelegate: CustomTabViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: Constants.menuBarCollectionCell)

        addSubview(collectionView)
        addConstraints(format: "H:|[v0]|", views: collectionView)
        addConstraints(format: "V:|[v0]|", views: collectionView)
        
        initialLoad()
    }
    
    func initialLoad() {
        let selectedPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedPath, animated: false, scrollPosition: .centeredHorizontally)
    }
}

extension MenuBar: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.menuBarCollectionCell, for: indexPath) as? MenuCell else { return UICollectionViewCell() }
        
        cell.imageView.image?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TAPPED IT \(indexPath)")

        customDelegate?.tappedThat(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width)/2, height: frame.height)
    }

}


