//
//  AddPlayerVC.swift
//  WishWinWhimsy
//
//  Created by WishWinWhimsy on 2024/10/31.
//

import UIKit

class WishWinAddPlayerVC: UIViewController {
    
    @IBOutlet var viewAddPlayer: UIVisualEffectView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var fielName: UITextField!
    
    @IBOutlet weak var imgP1: UIImageView!
    @IBOutlet weak var lblP1: UILabel!
    @IBOutlet weak var imgP2: UIImageView!
    @IBOutlet weak var lblP2: UILabel!
    
    var imagePicker = UIImagePickerController()

    var profileImage: UIImage?{
        didSet{
            imgProfile.image = profileImage
        }
    }
    
    var isFirst: Bool = true
    
    var p1: WishWinPlayerModel?{
        didSet{
            imgP1.image = p1?.img
            lblP1.text = p1?.name ?? "Player Name"
        }
    }
    
    var p2: WishWinPlayerModel?{
        didSet{
            imgP2.image = p2?.img
            lblP2.text = p2?.name ?? "Player Name"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewAddPlayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    
    @IBAction func btnShowAdd(_ sender: UIButton) {
        view.addSubview(viewAddPlayer)
        isFirst = (sender.tag == 0)
    }
    
    
    @IBAction func btnGetImg(_ sender: UIButton) {
        openGallery()
    }
    
    
    @IBAction func btnAddPlayer(_ sender: Any) {
        
        guard let name = fielName.text , name.count > 3 else{
            return
        }
        
        if isFirst{
            p1 = WishWinPlayerModel(name: name, img: profileImage)
        }else{
            p2 = WishWinPlayerModel(name: name, img: profileImage)
        }
        
        viewAddPlayer.removeFromSuperview()
    }
    
    @IBAction func btnCloase(_ sender: Any) {
        viewAddPlayer.removeFromSuperview()
    }
    
    @IBAction func btnStart(_ sender: Any) {
        
        guard let p1 else{
            return
        }
        
        guard let p2 else{
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CardGameVC")as! WishWinCardGameVC
        
        vc.p1 = p1
        vc.p2 = p2
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension WishWinAddPlayerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }else{
            openGallery()
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImage = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
