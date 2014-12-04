//
//  MenuViewController.swift
//  2UP
//
//  Created by JOSH HENDERSHOT on 10/10/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

import UIKit

class MenuViewController2: UIViewController {
    let transitionManager2 = MenuTransitionManager2()
    let transitionManger2 = TransitionManager()
    var fromCoinSelected: Int!
    var nc = NSNotificationCenter.defaultCenter()
    
    let vC: ViewController!
    
    @IBOutlet weak var bitcoinIcon2: UIButton!
    @IBOutlet weak var bitcoinLabel2: UILabel!
    @IBOutlet weak var litecoinIcon2: UIButton!
    @IBOutlet weak var litecoinLabel2: UILabel!
    @IBOutlet weak var darcoinIcon2: UIButton!
    @IBOutlet weak var darkcoinLabel2: UILabel!
    @IBOutlet weak var dogecoinIcon2: UIButton!
    @IBOutlet weak var dogecoinLabel2: UILabel!
    @IBOutlet weak var feathercoinIcon2: UIButton!
    @IBOutlet weak var feathercoinLabel2: UILabel!
    @IBOutlet weak var namecoinIcon2: UIButton!
    @IBOutlet weak var namecoinLabel2: UILabel!
    @IBOutlet weak var peercoinIcon2: UIButton!
    @IBOutlet weak var peercoinLabel2: UILabel!
    @IBOutlet weak var blackcoinIcon2: UIButton!
    @IBOutlet weak var blackcoinLabel2: UILabel!
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self.transitionManager2

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if fromCoinSelected == 0 {
            bitcoinIcon2.highlighted = true
            bitcoinIcon2.enabled = false
        } else if fromCoinSelected == 1 {
            litecoinIcon2.highlighted = true
            litecoinIcon2.enabled = false
        } else if fromCoinSelected == 2 {
            darcoinIcon2.highlighted = true
            darcoinIcon2.enabled = false
        } else if fromCoinSelected == 3 {
            dogecoinIcon2.highlighted = true
            dogecoinIcon2.enabled = false
        } else if fromCoinSelected == 4 {
            feathercoinIcon2.highlighted = true
            feathercoinIcon2.enabled = false
        } else if fromCoinSelected == 5 {
            namecoinIcon2.highlighted = true
            namecoinIcon2.enabled = false
        } else if fromCoinSelected == 6 {
            peercoinIcon2.highlighted = true
            peercoinIcon2.enabled = false
        } else if fromCoinSelected == 7 {
            blackcoinIcon2.highlighted = true
            blackcoinIcon2.enabled = false
        }
    }
    
    
   
    
    @IBAction func bitcoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("bitcoin", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func litecoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("litecoin", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func darkcoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("darkcoin", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func dogecoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("dogecoin", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func feathercoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("feathercoin", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func namecoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("namecoin", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func peercoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("peercoin", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func blackcoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("blackcoin", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
