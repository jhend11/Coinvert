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
    var timer2 = NSTimer?()
    var fromCoinChoice: Int!
    var fromCoinString: String!
    var toCoinChoice: Int!
    var toCoinString: String!
    var fromSwitchNumber: Int!
    var toSwitchNumber: Int!
    var fromSwitchString: String!
    var toSwitchString: String!
    var currentTransactionToggle: Bool!
    var depositLimitFloat: Float!
    var currentRateFloat: Float!
    var mathNumber: Float!
    weak var toolBar: UIToolbar!
    
    lazy var reader: QRCodeReader = QRCodeReader(cancelButtonTitle: "Cancel")
    
    @IBOutlet weak var coinvertButton: UIButton!
    @IBOutlet weak var returnCoinAddress: UITextField!
    @IBOutlet weak var yourPaymentAddress: UITextField!
    @IBOutlet weak var currentRateLabel: UILabel!
    @IBOutlet weak var timerBar: UIView!
    @IBOutlet weak var fromCoinImage: UIImageView!
    @IBOutlet weak var fromCoinLabel: UILabel!
    @IBOutlet weak var toCoinImage: UIImageView!
    @IBOutlet weak var toCoinLabel: UILabel!
    @IBOutlet weak var depositLimitLabel: UILabel!
    @IBOutlet weak var fixedAmountField: UITextField!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var estMaxLabel: UILabel!
    @IBOutlet weak var estMaxPopup: UIImageView!
    
    
    var nc = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     

        
        infoView.hidden = true
        estMaxPopup.hidden = true
        yourPaymentAddress.leftView = UIView(frame: CGRectMake(0, 0, 7, 30))
        returnCoinAddress.leftView = UIView(frame: CGRectMake(0, 0, 7, 30))
        fixedAmountField.leftView = UIView(frame: CGRectMake(0, 0, 7, 30))
        yourPaymentAddress.leftViewMode = UITextFieldViewMode.Always
        returnCoinAddress.leftViewMode = UITextFieldViewMode.Always
        fixedAmountField.leftViewMode = UITextFieldViewMode.Always
        
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 50))
        var item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("textEnd"))
        toolbar.setItems([item], animated: true)
        toolbar.sizeToFit()
        fixedAmountField.inputAccessoryView = toolbar
        self.toolBar = toolbar
        
        fromCoinImage.image = UIImage(named: "bitcoin")
        fromCoinLabel.text = "Bitcoin"
        toCoinImage.image = UIImage(named: "litecoin")
        toCoinLabel.text = "Litecoin"
        fromCoinChoice = 0
        toCoinChoice = 1
        fromCoinString = "btc"
        toCoinString = "ltc"
        currentTransactionToggle = false
        yourPaymentAddress.delegate = self
        returnCoinAddress.delegate = self
        fixedAmountField.delegate = self
        
        yourPaymentAddress.tag = 1
        fixedAmountField.tag = 2
        

        resetTimerwithSpeed(0.1)
        
        
     
        ///// INTO COINS  ///////
        
        
        
        nc.addObserverForName("appEnteredForeground", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            if self.currentTransactionToggle == false {
                self.resetTimerwithSpeed(30)
                
            }
        })
        nc.addObserverForName("resetCoinvert", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.resetCoinvert()
        })
        nc.addObserverForName("bitcointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 0
            self.fromCoinString = "btc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
        })
        
        nc.addObserverForName("litecointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 1
            self.fromCoinString = "ltc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("darkcointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 2
            self.fromCoinString = "drk"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("dogecointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 3
            self.fromCoinString = "doge"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("feathercointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 4
            self.fromCoinString = "ftc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("namecointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 5
            self.fromCoinString = "nmc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("peercointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 6
            self.fromCoinString = "ppc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("blackcointo", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.fromCoinChoice = 7
            self.fromCoinString = "bc"
            self.checkFromCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        ////////// FROM COINS //////////
        
        nc.addObserverForName("bitcoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 0
            self.toCoinString = "btc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
        })
        
        nc.addObserverForName("litecoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 1
            self.toCoinString = "ltc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("darkcoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 2
            self.toCoinString = "drk"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("dogecoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 3
            self.toCoinString = "doge"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("feathercoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 4
            self.toCoinString = "ftc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("namecoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 5
            self.toCoinString = "nmc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("peercoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 6
            self.toCoinString = "ppc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        nc.addObserverForName("blackcoin", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            self.toCoinChoice = 7
            self.toCoinString = "bc"
            self.checkToCoins()
            self.checkDepositLimit()
            self.checkCurrentRate(1)
            self.resetTimerwithSpeed(30)
            
        })
        
        
    }

    
    @IBAction func returnAddressQRWasClicked(sender: AnyObject) {
        reader.delegate = self
        
        reader.completionBlock = { (result: String?) in
            println(result)
            self.returnCoinAddress.text = result
        }
        
        reader.modalPresentationStyle = .FormSheet
        presentViewController(reader, animated: true, completion: nil)
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
            
            if (yourPaymentAddress.text.isEmpty == false && fixedAmountField.text.isEmpty == true) {
                
                println(yourPaymentAddress.text)
                
                svc.withDrawalString = yourPaymentAddress.text
                svc.toCoinString2 = toCoinString
                svc.fromCoinString2 = fromCoinString
                currentTransactionToggle = true
            } else if yourPaymentAddress.text.isEmpty == true {
                yourPaymentAddress.text == " "
                println(yourPaymentAddress.text)
                currentTransactionToggle = true
                
                svc.withDrawalString = yourPaymentAddress.text
                svc.toCoinString2 = toCoinString
                svc.fromCoinString2 = fromCoinString
            } else {
                currentTransactionToggle = true
                
                println(yourPaymentAddress.text)
                let fixedString = fixedAmountField.text as String!
                let numberFormatter = NSNumberFormatter()
                let number = numberFormatter.numberFromString(fixedString)
                let numberFloatValue = number!.floatValue
                svc.depositAmount = numberFloatValue
                svc.withDrawalString = yourPaymentAddress.text
                svc.toCoinString2 = toCoinString
                svc.fromCoinString2 = fromCoinString
                println("made it")
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
        
        checkDepositLimit()
        
        checkToCoins()
        checkFromCoins()
        checkCurrentRate(1)
        resetTimerwithSpeed(30)
    }
    
    func checkDepositLimit() {
        
        let urlAsString = "https://shapeshift.io/limit/\(fromCoinString)_\(toCoinString)"
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
                self.depositLimitFloat = number!.floatValue
                
                
                let newFromCoinString = self.fromCoinString.uppercaseString
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.depositLimitLabel.text = NSString(format:"Limit: " + "%.4f" + " " + newFromCoinString, number!.floatValue)
                    

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
        timerBar.frame.size.width = 287
        
        UIView.animateWithDuration(speed, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            
            self.timerBar.frame.size.width = 0
            
            }) { (succeeded:Bool) -> Void in
                
        }
    }
    func timerDone() {
        if currentTransactionToggle == false {
            resetTimerwithSpeed(30)
            checkDepositLimit()
            checkCurrentRate(1)
        }
        
    }
    func timerDone2() {
        
        if currentTransactionToggle == false {
            
            let urlAsString = "https://shapeshift.io/rate/\(fromCoinString)_\(toCoinString)"
            let url = NSURL(string: urlAsString)!
            let urlSession = NSURLSession.sharedSession()
            
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
                    self.currentRateFloat = number!.floatValue
                    
                    
                    let newFromCoinString = self.fromCoinString.uppercaseString
                    let newToCoinString = self.toCoinString.uppercaseString
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentRateLabel.text = NSString(format: "1.00 " + newFromCoinString + " = %f" + " " + newToCoinString, number!.floatValue)
                        
                        if self.depositLimitFloat != nil {
                            self.mathNumber = self.depositLimitFloat * self.currentRateFloat
                            self.estMaxLabel.text = String(format: "Est. max:    %f \(newToCoinString.uppercaseString)", self.mathNumber)
                            self.textEnd()
                        } else if self.depositLimitFloat == nil {
                            self.checkCurrentRate(1)
                        }
                        
                        
                    })
                }
            })
            
            jsonQuery.resume()

        }
    }
    func checkCurrentRate(speed: Double) {
        
        if timer2 != nil { timer2!.invalidate() }
        
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("timerDone2"), userInfo: nil, repeats: false)
        
        
    }
    func textFieldDidBeginEditing(textField: UITextField!) -> Bool {
        if textField.tag == 1 {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.view.frame.origin.y -= 186
            })
        } else if textField.tag == 2 {
            
        }
        return true
        
    }
    func textFieldDidEndEditing(textField: UITextField!) -> Bool {
        
        if textField.tag == 1 {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.view.frame.origin.y += 186
            })
        } else if fixedAmountField.text.isEmpty == false  {
          var fixedAMT = fixedAmountField.text
            let numberFormatter = NSNumberFormatter()
            let number = numberFormatter.numberFromString(fixedAMT)
            
            if number?.floatValue > mathNumber {
                estMaxPopup.hidden = false
            } else if number?.floatValue < mathNumber {
                estMaxPopup.hidden = true
            }
        }
        return true
        
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        
        self.view.endEditing(true)
        return false
    }
    func resetCoinvert(){
        
        currentTransactionToggle = false
        fromCoinImage.image = UIImage(named: "bitcoin")
        fromCoinLabel.text = "Bitcoin"
        toCoinImage.image = UIImage(named: "litecoin")
        toCoinLabel.text = "Litecoin"
        fromCoinChoice = 0
        toCoinChoice = 1
        fromCoinString = "btc"
        toCoinString = "ltc"
        fixedAmountField.text = nil
        yourPaymentAddress.text = nil
        returnCoinAddress.text = nil
        estMaxPopup.hidden = true
        checkDepositLimit()
        checkCurrentRate(1)
    }
    
    @IBAction func infoButtonWasPressed(sender: AnyObject) {
        self.infoView.hidden = false
        
    }
    @IBAction func cancelButtonWasPressed(sender: AnyObject) {
        self.infoView.hidden = true
        
    }
    func textEnd() {
        
        if fixedAmountField.text.isEmpty == false  {
            var fixedAMT = fixedAmountField.text
            let numberFormatter = NSNumberFormatter()
            let number = numberFormatter.numberFromString(fixedAMT)
            
            if number?.floatValue > mathNumber {
                estMaxPopup.hidden = false
            } else if number?.floatValue < mathNumber {
                estMaxPopup.hidden = true
            }
        } else if fixedAmountField.text.isEmpty == true {
            estMaxPopup.hidden = true

        }
        fixedAmountField.resignFirstResponder()

    }
    
}

