//
//  MenuViewController.swift
//  2UP
//
//  Created by JOSH HENDERSHOT on 10/10/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    let transitionManager = MenuTransitionManager()
    let transitionManger2 = TransitionManager()
    var toCoinSelected: Int!
    var VC: ViewController!
    var nc = NSNotificationCenter.defaultCenter()
    
    @IBOutlet weak var bitcoinIcon: UIButton!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var litecoinIcon: UIButton!
    @IBOutlet weak var litecoinLabel: UILabel!
    @IBOutlet weak var darcoinIcon: UIButton!
    @IBOutlet weak var darkcoinLabel: UILabel!
    @IBOutlet weak var dogecoinIcon: UIButton!
    @IBOutlet weak var dogecoinLabel: UILabel!
    @IBOutlet weak var feathercoinIcon: UIButton!
    @IBOutlet weak var feathercoinLabel: UILabel!
    @IBOutlet weak var namecoinIcon: UIButton!
    @IBOutlet weak var namecoinLabel: UILabel!
    @IBOutlet weak var peercoinIcon: UIButton!
    @IBOutlet weak var peercoinLabel: UILabel!
    @IBOutlet weak var blackcoinIcon: UIButton!
    @IBOutlet weak var blackcoinLabel: UILabel!
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self.transitionManager
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if toCoinSelected == 0 {
            bitcoinIcon.highlighted = true
            bitcoinIcon.enabled = false
        } else if toCoinSelected == 1 {
            litecoinIcon.highlighted = true
            litecoinIcon.enabled = false
        } else if toCoinSelected == 2 {
            darcoinIcon.highlighted = true
            darcoinIcon.enabled = false
        } else if toCoinSelected == 3 {
            dogecoinIcon.highlighted = true
            dogecoinIcon.enabled = false
        } else if toCoinSelected == 4 {
            feathercoinIcon.highlighted = true
            feathercoinIcon.enabled = false
        } else if toCoinSelected == 5 {
            namecoinIcon.highlighted = true
            namecoinIcon.enabled = false
        } else if toCoinSelected == 6 {
            peercoinIcon.highlighted = true
            peercoinIcon.enabled = false
        } else if toCoinSelected == 7 {
            blackcoinIcon.highlighted = true
            blackcoinIcon.enabled = false
        }
    }

 
    
    @IBAction func bitcoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("bitcointo", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func litecoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("litecointo", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func darkcoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("darkcointo", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func dogecoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("dogecointo", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func feathercoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("feathercointo", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func namecoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("namecointo", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func peercoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("peercointo", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func blackcoinWasClicked(sender: AnyObject) {
        nc.postNotificationName("blackcointo", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
}
