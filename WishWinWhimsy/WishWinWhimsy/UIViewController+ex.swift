//
//  UIViewController+ex.swift
//  WishWinWhimsy
//
//  Created by WishWinWhimsy on 2024/10/31.
//

import UIKit

extension UIViewController{
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension UIViewController{
    
    func dateString(from date: Date, format: String = "EEEE, d MMMM yyyy, h:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
        
    }
    
}
