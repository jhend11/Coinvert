//
//  ViewController.swift
//  Coinvert
//
//  Created by JOSH HENDERSHOT on 11/16/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

import UIKit
let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
class ViewController: UIViewController, QRCodeReaderDelegate, UITextFieldDelegate {
    
    var timer = NSTimer?()
    var fromCoinChoice: Int!
    var fromCoinString: String!
    var toCoinChoice: Int!
    var toCoinString: String!
    var fromSwitchNumber: Int!
    var toSwitchNumber: Int!
    var fromSwitchString: String!
    var toSwitchString: String!
    lazy var reader: QRCodeReader = QRCodeReader(cancelButtonTitle: "Cancel")

    @IBOutlet weak var returnCoinAddress: UITextField!
    @IBOutlet weak var yourPaymentAddress: UITextField!
    @IBOutlet weak var currentRateLabel: UILabel!
    @IBOutlet weak var timerBar: UIView!
    @IBOutlet weak var fromCoinImage: UIImageView!
    @IBOutlet weak var fromCoinLabel: UILabel!
    @IBOutlet weak var toCoinImage: UIImageView!
    @IBOutlet weak var toCoinLabel: UILabel!
    @IBOutlet weak var depositLimitLabel: UILabel!
    
    var nc = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromCoinImage.image = UIImage(named: "bitcoin")
        fromCoinLabel.text = "Bitcoin"
        toCoinImage.image = UIImage(named: "litecoin")
        toCoinLabel.text = "Litecoin"
        fromCoinChoice = 0
        toCoinChoice = 1
        fromCoinString = "btc"
        toCoinString = "ltc"
        
        yourPaymentAddress.delegate = self
        returnCoinAddress.delegate = self
        yourPaymentAddress.text = "LNsJKWYhz3tswFrEzDddwYALAtmpCQdX2A"
        timerBar.backgroundColor = UIColor.blueColor()
        timerBar.frame = CGRectMake(0, 0, 0, 20)
        self.view.addSubview(timerBar)
        resetTimerwithSpeed(0)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        ///// INTO COINS  ///////
        
        nc.addObserverForName("bitcointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 0
            self.fromCoinString = "btc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
self.resetTimerwithSpeed(30)
        })
        
        nc.addObserverForName("litecointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 1
            self.fromCoinString = "ltc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("darkcointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 2
            self.fromCoinString = "drk"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("dogecointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 3
            self.fromCoinString = "doge"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("feathercointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 4
            self.fromCoinString = "ftc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("namecointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 5
            self.fromCoinString = "nmc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("peercointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 6
            self.fromCoinString = "ppc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("blackcointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 7
            self.fromCoinString = "bc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        ////////// FROM COINS //////////
        
        nc.addObserverForName("bitcoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 0
            self.toCoinString = "btc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)
        })
        
        nc.addObserverForName("litecoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 1
            self.toCoinString = "ltc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("darkcoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 2
            self.toCoinString = "drk"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("dogecoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 3
            self.toCoinString = "doge"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("feathercoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 4
            self.toCoinString = "ftc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("namecoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 5
            self.toCoinString = "nmc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("peercoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 6
            self.toCoinString = "ppc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        nc.addObserverForName("blackcoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 7
            self.toCoinString = "bc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate()
            self.resetTimerwithSpeed(30)

        })
        
        
    }
    
    @IBAction func qrCameraWasClicked(sender: AnyObject) {
        
        reader.delegate = self
        
        reader.completionBlock = { (result: String?) in
            println(result)
            self.yourPaymentAddress.text = result
        }
        
        reader.modalPresentationStyle = .FormSheet
        presentViewController(reader, animated: true, completion: nil)
    
    }
    func reader(reader: QRCodeReader, didScanResult result: String) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func readerDidCancel(reader: QRCodeReader) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showToCoin") {
            var svc = segue.destinationViewController as MenuViewController2
            
            svc.fromCoinSelected = fromCoinChoice
            
        }
        if (segue.identifier == "showFromCoin") {
            var svc = segue.destinationViewController as MenuViewController
            
            svc.toCoinSelected = toCoinChoice
            
        }
        if (segue.identifier == "showSendScreen") {
            var svc = segue.destinationViewController as SendViewController
            if yourPaymentAddress.text == "" {
                
            } else {
                println(yourPaymentAddress.text)
                
                svc.withDrawalString = yourPaymentAddress.text
svc.toCoinString2 = toCoinString
                svc.fromCoinString2 = fromCoinString
}
            
        }
    }
    
    @IBAction func switchButtonWasClicked(sender: AnyObject) {
        fromSwitchNumber = fromCoinChoice
        toSwitchNumber = toCoinChoice
        fromCoinChoice = toSwitchNumber
        toCoinChoice = fromSwitchNumber
        
        fromSwitchString = fromCoinString
        toSwitchString = toCoinString
        fromCoinString = toSwitchString
        toCoinString = fromSwitchString
        
        checkToCoins()
        checkFromCoins()
        checkDepositLimit()
    }
    
    func checkDepositLimit() {
        
        let urlAsString = "http://shapeshift.io/limit/\(fromCoinString)_\(toCoinString)"
        let url = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        println(urlAsString)
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            if jsonResult["limit"] != nil {
                var jsonDate: String! = jsonResult["limit"] as String
                let numberFormatter = NSNumberFormatter()
                let number = numberFormatter.numberFromString(jsonDate)
                let numberFloatValue = number!.floatValue
            
            
            let newFromCoinString = self.fromCoinString.uppercaseString

            dispatch_async(dispatch_get_main_queue(), {
                self.depositLimitLabel.text = NSString(format:"%.4f" + " " + newFromCoinString, numberFloatValue)

            })
            }
        })
        
        jsonQuery.resume()
        
    }
    
    @IBAction func startButtonWasClicked(sender: AnyObject) {
    }
    
    func checkFromCoins() {
        
        if fromCoinChoice == 0 {
            fromCoinImage.image = UIImage(named: "bitcoin")
            fromCoinLabel.text = "Bitcoin"
            fromCoinString = "btc"

        } else if fromCoinChoice == 1 {
            fromCoinImage.image = UIImage(named: "litecoin")
            fromCoinLabel.text = "Litecoin"
            fromCoinString = "ltc"

        } else if fromCoinChoice == 2 {
            fromCoinImage.image = UIImage(named: "darkcoin")
            fromCoinLabel.text = "Darkcoin"
            fromCoinString = "drk"

        } else if fromCoinChoice == 3 {
            fromCoinImage.image = UIImage(named: "dogecoin")
            fromCoinLabel.text = "Dogecoin"
            fromCoinString = "doge"

        } else if fromCoinChoice == 4 {
            fromCoinImage.image = UIImage(named: "feathercoin")
            fromCoinLabel.text = "Feathercoin"
            fromCoinString = "ftc"

        } else if fromCoinChoice == 5 {
            fromCoinImage.image = UIImage(named: "namecoin")
            fromCoinLabel.text = "Namecoin"
            fromCoinString = "nmc"

        } else if fromCoinChoice == 6 {
            fromCoinImage.image = UIImage(named: "peercoin")
            fromCoinLabel.text = "Peercoin"
            fromCoinString = "ppc"

        } else if fromCoinChoice == 7 {
            fromCoinImage.image = UIImage(named: "blackcoin")
            fromCoinLabel.text = "Blackcoin"
            fromCoinString = "bc"

        }
    }
    func checkToCoins() {
        
        if toCoinChoice == 0 {
            toCoinImage.image = UIImage(named: "bitcoin")
            toCoinLabel.text = "Bitcoin"
        } else if toCoinChoice == 1 {
            toCoinImage.image = UIImage(named: "litecoin")
            toCoinLabel.text = "Litecoin"
        } else if toCoinChoice == 2 {
            toCoinImage.image = UIImage(named: "darkcoin")
            toCoinLabel.text = "Darkcoin"
        } else if toCoinChoice == 3 {
            toCoinImage.image = UIImage(named: "dogecoin")
            toCoinLabel.text = "Dogecoin"
        } else if toCoinChoice == 4 {
            toCoinImage.image = UIImage(named: "feathercoin")
            toCoinLabel.text = "Feathercoin"
        } else if toCoinChoice == 5 {
            toCoinImage.image = UIImage(named: "namecoin")
            toCoinLabel.text = "Namecoin"
        } else if toCoinChoice == 6 {
            toCoinImage.image = UIImage(named: "peercoin")
            toCoinLabel.text = "Peercoin"
        } else if toCoinChoice == 7 {
            toCoinImage.image = UIImage(named: "blackcoin")
            toCoinLabel.text = "Blackcoin"
        }
    }
    func resetTimerwithSpeed(speed: Double) {
        
        if timer != nil { timer!.invalidate() }
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("timerDone"), userInfo: nil, repeats: false)
        
        
        timerBar.layer.removeAllAnimations()
        timerBar.frame.size.width = SCREEN_WIDTH
        
        UIView.animateWithDuration(speed, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            
            self.timerBar.frame.size.width = 0
            
            }) { (succeeded:Bool) -> Void in
                
        }
    }
    func timerDone() {
        println("Game Over")
        resetTimerwithSpeed(30)
        checkCurrentRate()
    }
    func checkCurrentRate() {
        
        let urlAsString = "http://shapeshift.io/rate/\(fromCoinString)_\(toCoinString)"
        let url = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        println(urlAsString)
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            if jsonResult["rate"] != nil {
                var jsonDate: String! = jsonResult["rate"] as String
                let numberFormatter = NSNumberFormatter()
                let number = numberFormatter.numberFromString(jsonDate)
                let numberFloatValue = number!.floatValue
                
                
                let newFromCoinString = self.fromCoinString.uppercaseString
                let newToCoinString = self.toCoinString.uppercaseString
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.currentRateLabel.text = NSString(format: "1.00 " + newFromCoinString + " = %.4f" + " " + newToCoinString, numberFloatValue)
                    
                })
            }
        })
        
        jsonQuery.resume()
        
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        self.view.endEditing(true);
        return false;
    }
}

