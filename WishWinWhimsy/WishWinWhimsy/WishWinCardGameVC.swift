//
//  CardGameVC.swift
//  WishWinWhimsy
//
//  Created by jin fu on 2024/10/31.
//

import UIKit
import CoreMotion

class WishWinCardGameVC: UIViewController {
    
    @IBOutlet weak var viewTopUser: UIView!
    @IBOutlet weak var viewDownUser: UIView!
    @IBOutlet var viewHideScreen: UIVisualEffectView!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var imgP1: UIImageView!
    @IBOutlet weak var imgP2: UIImageView!
    
    @IBOutlet weak var lblScore1: UILabel!
    @IBOutlet weak var lblScore2: UILabel!
    
    @IBOutlet weak var btnShow: UIButton!
    
    let motionManager = CMMotionManager()

    let arrCards = [
        ["🂢", "🂣", "🂤", "🂥", "🂦", "🂧", "🂨", "🂩", "🂪", "🂫", "🂭", "🂮", "🂡"], // Spades
        ["🂲", "🂳", "🂴", "🂵", "🂶", "🂷", "🂸", "🂹", "🂺", "🂻", "🂽", "🂾", "🂱"], // Hearts
        ["🃂", "🃃", "🃄", "🃅", "🃆", "🃇", "🃈", "🃉", "🃊", "🃋", "🃍", "🃎", "🃁"], // Diamonds
        ["🃒", "🃓", "🃔", "🃕", "🃖", "🃗", "🃘", "🃙", "🃚", "🃛", "🃝", "🃞", "🃑"]  // Clubs
    ]
    
    var p1: WishWinPlayerModel = WishWinPlayerModel(name: "Noob 1", img: nil)
    var p2: WishWinPlayerModel = WishWinPlayerModel(name: "Noob 2", img: nil)
    
    var score1: Int = 120{
        didSet{
            if score1 <= 0{
                AlertGameOver(str: "Player: \(p2.name) win the match with \(score2) score. Player: \(p1.name) lose all play points.")
                return
            }
            lblScore1.text = """
            P1:
            \(score1)
            """
        }
    }
    
    var score2: Int = 120{
        didSet{
            if score2 <= 0{
                AlertGameOver(str: "Player: \(p1.name) win the match with \(score1) score. Player: \(p2.name) lose all play points.")
                return
            }
            lblScore2.text = """
            P2:
            \(score2)
            """
        }
    }
    
    
    //MARK: is upside down
    
    var isUpsideDown: Bool = false{
        didSet{
            view.addSubview(viewHideScreen)
            
            if isUpsideDown{
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
                    
                    self.viewHideScreen.transform = CGAffineTransform(rotationAngle: 0)
                    self.viewHideScreen.transform = CGAffineTransform(rotationAngle: 0)
                }
            }else{
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
                    
                    self.viewHideScreen.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    self.viewHideScreen.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
            }
            
            viewTopUser.alpha = 0
            viewDownUser.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                
                self.viewHideScreen.removeFromSuperview()
                
                if self.isUpsideDown{
                    self.viewDownUser.alpha = 1
                }else{
                    self.viewTopUser.alpha = 1
                }
                
            }
        }
    }
    
    
    //MARK: cards
    
    var id1: Int?{
        didSet{
            guard let id1 else{
                return
            }
            card1 = arrCards.randomElement()?[id1]
        }
    }
    
    var id2: Int?{
        didSet{
            guard let id2 else{
                return
            }
            card2 = arrCards.randomElement()?[id2]
        }
    }
    
    var card1: String?{
        didSet{
//            guard let card1 else{
//                return
//            }
            lbl1.text = card1
        }
    }
    
    var card2: String?{
        didSet{
//            guard let card2 else{
//                return
//            }
            lbl2.text = card2
        }
    }
    
    
    //MARK: did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgP1.image = p1.img ?? UIImage(named: "icon")
        imgP2.image = p2.img ?? UIImage(named: "icon")
        
        setNewCard()
        startUserUpdate()
        
        viewTopUser.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        lblScore1.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
        lblScore2.transform = CGAffineTransform(rotationAngle: CGFloat.pi*3/4)
        
        viewHideScreen.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        let fSize = lbl1.bounds.height * 0.6
        lbl1.font = UIFont.systemFont(ofSize: fSize)
        lbl2.font = UIFont.systemFont(ofSize: fSize)
        
        let longPressRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress1(_:)))
        let longPressRecognizer2 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress2(_:)))
        
        lbl1.addGestureRecognizer(longPressRecognizer1)
        lbl2.addGestureRecognizer(longPressRecognizer2)
        
        
        //MARK: temprary rotate
        
        isUpsideDown = false

        DispatchQueue.main.asyncAfter(deadline: .now()+3){
            self.isUpsideDown = true
        }
        
    }
    
    
    
    @objc func handleLongPress1(_ sender: UILongPressGestureRecognizer) {
        
        let lbl = lbl1
        
        if sender.state == .began {
            lbl?.center = sender.location(in: self.view)
        }else{
            lbl?.removeFromSuperview()
        }
    }
    
    @objc func handleLongPress2(_ sender: UILongPressGestureRecognizer) {
        
        let lbl = lbl2
        
        if sender.state == .began {
            lbl?.center = sender.location(in: self.view)
        }else{
            lbl?.removeFromSuperview()
        }
    }
    
    //MARK: set cards
    
    func setNewCard(){
        
        id1 = (0...12).randomElement()
        id2 = (0...12).randomElement()
        
        self.motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            if let acceleration = data?.acceleration {
                
                if self.isUpsideDown != (acceleration.y < 0){
                    self.isUpsideDown = acceleration.y < 0
                }
            }
        }
        
    }
    
    
    //MARK: reload cards
    
    @IBAction func btnReload(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are Your Sure To Start New Game.", message: "Press Ok To Start.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
            self.motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                if let acceleration = data?.acceleration {
                    
                    if self.isUpsideDown != (acceleration.y < 0){
                        self.isUpsideDown = acceleration.y < 0
                    }
                }
            }
            self.setNewCard()
        }))
        
        alertController.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: update motion
    
    func startUserUpdate(){
        
        motionManager.accelerometerUpdateInterval = 1
        
        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            if let acceleration = data?.acceleration {
                
                if self.isUpsideDown != (acceleration.y < 0){
                    self.isUpsideDown = acceleration.y < 0
                }
//                print("y",acceleration.y)
                
                if self.isUpsideDown {
                    print("Device is upside down")
                } else {
                    print("Device is not upside down")
                }
                
            }
        }
        
    }
    
    //MARK: show cards
    
    @IBAction func btnShow(_ sender: Any) {
        
        guard let id1 else{
            return
        }
        
        guard let id2 else{
            return
        }
        
        motionManager.stopAccelerometerUpdates()
        
        viewTopUser.alpha = 1
        viewDownUser.alpha = 1
        
        if id1 > id2{
            print("Player 1 win")
            score1 += 10
            score2 -= 10
        }else if id1 < id2{
            print("Player 2 win")
            score2 += 10
            score1 -= 10
        }else{
            print("Game Draw. Get Lucky Score +20 each.")
            score1 += 20
            score2 += 20
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        motionManager.stopAccelerometerUpdates()
    }
    
    
    //MARK: Game over
    
    func AlertGameOver(str: String){
        
        arrHistory.append("CARD GAME STARED AT: \(dateString(from: Date())).")
        
        let alertController = UIAlertController(title: str, message: "GAME OVER...!", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "RESTART", style: .default, handler: { _ in
            self.score1 = 120
            self.score2 = 120
            self.setNewCard()
            self.motionManager.startAccelerometerUpdates()
        }))
        
        alertController.addAction(UIAlertAction(title: "GO BACK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
        
        present(alertController, animated: true, completion: nil)
    }
    
}
