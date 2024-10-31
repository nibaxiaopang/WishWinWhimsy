//
//  HistoryVC.swift
//  WishWinWhimsy
//
//  Created by jin fu on 2024/10/31.
//

import UIKit

class WishWinHistoryVC: UIViewController {

    @IBOutlet weak var cvList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvList.delegate = self
        cvList.dataSource = self
        
    }
    
}

extension WishWinHistoryVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrHistory.isEmpty ? 1 : arrHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cvList.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath)as! WishWinHistoryCell
        
        cell.lbl.text = arrHistory.isEmpty ? "PLAY GAME FIRST." : arrHistory[arrHistory.count - indexPath.item - 1]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvList.bounds.width/3, height: cvList.bounds.width/5)
    }
}
