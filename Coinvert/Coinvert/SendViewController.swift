//
//  SendViewController.swift
//  Coinvert
//
//  Created by JOSH HENDERSHOT on 11/18/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {
    var pendingTransaction: Bool!
    var coinsReceived: Bool!
    var secondsLeft: Int!
//    var minutes, seconds: Int!
    var textField: UITextField!
    var fromCoinString2: String!
    var toCoinString2: String!
    var depositAddressString: String!
    var depositAmount: Float!
    var withDrawalString: String!
    var txIdForReciept: String!
    var timer1 = NSTimer?()
    var transactionTimer = NSTimer?()
    var timer2 = NSTimer?()
    var timer3 = NSTimer?()
    var emailAddressForReciept: String!
    var toDate: NSDate!
    var params: [String:String]!
    var shapeshiftURL: String!
    
    var nc = NSNotificationCenter.defaultCenter()
    let view2 = UIImageView()
    let currentTimeIntVale = Int()
    //    var toCoinImageView1 = UIImageView()
    //    var fromCoinImageView1 = UIImageView()
    
    
    
    @IBOutlet weak var fromCoinImageView1: UIImageView!
    @IBOutlet weak var toCoinImageView1: UIImageView!
    @IBOutlet weak var fixedAmountCover: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var transactionStatusLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var depositAddressLabel: UILabel!
    @IBOutlet weak var withdrawalAddressLabel: UILabel!
    
    @IBOutlet weak var copyDepositAddressButton: UIButton!
    
    @IBOutlet weak var sendAmountLabel: UILabel!
    @IBOutlet weak var copySendAmountButton: UIButton!
    @IBOutlet weak var depositAddressPopup: UIView!
    
    //    @IBOutlet weak var toCoinImageView: UIImageView!
    //    @IBOutlet weak var fromCoinImageView: UIImageView!
    @IBOutlet weak var depositAmountPopup: UIView!
    @IBOutlet weak var sendStringLabel: UILabel!
    @IBOutlet weak var sendCoinsToLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
//        fromCoinImageView1.hidden = true
//        toCoinImageView1.hidden = true

        depositAmountPopup.hidden = true
        depositAddressPopup.hidden = true
        copySendAmountButton.hidden = true
        
        coinsReceived = false
        checkCoinViews()
        sendCoinsToLabel.text = "Send \(fromCoinString2.uppercaseString) to:"
        resetTimerwithSpeed(6)
        pendingTransaction = true
//        animateCoins()
        
        self.view2.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        self.view2.image = UIImage(named: "launchscreen")
        self.view.addSubview(self.view2)
    
        var string = "\(fromCoinString2)_\(toCoinString2)"
        
        withdrawalAddressLabel.text = withDrawalString
        var stringy = "\(depositAmount)"
        let s2 = withdrawalAddressLabel.text!
        
        
        
        
        //MARK: JSON POST SETUP
        
        nc.addObserverForName("appEnteredForeground", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            
            if self.depositAmount != nil && self.coinsReceived == false {
                self.checkTimeRemaining()
            } else if self.depositAmount != nil && self.coinsReceived == true {
                self.checkTransactionStatus()
                println("this just might work")
            }
        })
        if depositAmount != nil {
            let s = NSString(format: "%f", depositAmount)
            params = ["amount":s as String!, "withdrawal":s2 as String!, "pair": "\(fromCoinString2)_\(toCoinString2)"] as Dictionary
            shapeshiftURL = "https://shapeshift.io/sendamount"
            fixedAmountCover.removeFromSuperview()
            copySendAmountButton.hidden = false
            sendStringLabel.text = fromCoinString2.uppercaseString
            
        } else {
            
            params = ["withdrawal":s2 as String!, "pair": "\(fromCoinString2)_\(toCoinString2)"] as Dictionary
            shapeshiftURL = "https://shapeshift.io/shift"
            
        }
        jsonPOST()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: JSON REQUESTS
    
    func jsonPOST() {
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: shapeshiftURL)!)
        
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        
        println(params)
        
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            println("Response: \(response)")
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            println("Body: \(strData)\n\n")
            
            
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            
            
            if json["error"] != nil {
                
                
                
                
                var alert = UIAlertController(title: "Uh-Oh!", message: json["error"] as String + ".", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
                
                self.presentViewController(alert, animated: true, completion: {
                    self.pendingTransaction = false
                })
            }
                
            else {
                
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if self.depositAmount != nil {
                        self.depositAddressString = json["success"]!["deposit"] as String!
                        self.sendAmountLabel.text = json["success"]!["depositAmount"] as String!
                        self.checkTimeRemaining()
                        println(json["success"]!["deposit"] as String!)
                        
                    }
                    else  {
                        self.depositAddressString = json["deposit"] as String!
                        
                    }
                    println(self.depositAddressString)
                    
                    self.depositAddressLabel.text = self.depositAddressString
                    
                    
                    
                })
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIView.animateWithDuration(1.5, animations: { () -> Void in
                        self.view2.frame.size.height = 0
                        
                        }, completion: { (Bool) -> Void in
                            self.view2.removeFromSuperview()
                            self.qrCodeImageView.image = UIImage.mdQRCodeForString(self.depositAddressLabel.text, size: self.qrCodeImageView.bounds.size.width)
                    })
                })
                
                
            }
            
        })
        
        task.resume()
        checkTransactionStatus()
    }
    
    func checkTransactionStatus() {
        
        if pendingTransaction == true {
            
            let urlAsString = "https://shapeshift.io/txStat/\(depositAddressString)"
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
                
                if jsonResult["status"] != nil {
                    
                    
                    var results = jsonResult["status"] as String!
                    
                    
                    if results == "received" {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.transactionStatusLabel.layer.removeAllAnimations()
                            
                            self.transactionStatusLabel.text = "Received"
                            self.transactionStatusLabel.textColor = UIColor.redColor()
                            if self.timer2 != nil { self.timer2!.invalidate() }
                            self.timeLabel.text = "N/A"
                            
                            self.coinsReceived == true
                            
                            UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                                self.transactionStatusLabel.alpha = 1
                                
                                }) { (Bool) -> Void in
                                    UIView.animateWithDuration(3, animations: { () -> Void in
                                        self.transactionStatusLabel.alpha = 0
                                        
                                    })
                            }
                        })
                        
                    } else if results == "complete" {
                        
                        self.txIdForReciept = jsonResult["transaction"] as String!
                        self.transactionStatusLabel.text = "Complete"
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            var alert = UIAlertController(title: "Coinversion complete!", message: "Would you like a receipt?   Enter e-mail address below.", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
                            
                            alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
                            alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                                
                                self.emailAddressForReciept = ((alert.textFields![0] as UITextField).text)
                                
                                self.sendEmailReceipt(3)
                            }))
                            self.presentViewController(alert, animated: true, completion: {
                            })
                            
                        })
                        
                        
                    } else if results == "failed" {
                        self.transactionStatusLabel.text = "Failed"
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            var alert = UIAlertController(title: "Coinversion failed", message: "Lets try again!", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
                            
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
                            
                            self.presentViewController(alert, animated: true, completion: {
                            })
                            
                        })
                        
                        
                    } else if results == "no_deposits" {
                        println("checked status: no deposits")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.transactionStatusLabel.layer.removeAllAnimations()
                            
                            self.transactionStatusLabel.text = "Waiting"
                            self.transactionStatusLabel.textColor = UIColor.whiteColor()
                            
                            UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                                self.transactionStatusLabel.alpha = 1
                                
                                }) { (Bool) -> Void in
                                    UIView.animateWithDuration(3, animations: { () -> Void in
                                        self.transactionStatusLabel.alpha = 0
                                        
                                    })
                            }
                        })
                        
                    }
                    
                    
                }
            })
            
            jsonQuery.resume()
        }
    }
  
    func timerDone2() {
        
        var  params = ["email":emailAddressForReciept, "txid": txIdForReciept] as Dictionary
        var  shapeshiftURL = "https://shapeshift.io/mail"
        
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: shapeshiftURL)!)
        
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        
        println(params)
        
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            var err: NSError?
            
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            
            if((err) != nil) {
                
                println(err!.localizedDescription)
                
            }
            
            
        })
        
        task.resume()
        transactionTimeOut()
        
    }
    func checkTimeRemaining() {
        
        let urlAsString = "https://shapeshift.io/timeremaining/\(depositAddressString)"
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
            
            println(jsonResult["status"])
            
            if jsonResult["status"] as String == "pending" {
                
                var jsonDate: String! = jsonResult["seconds_remaining"] as String
                println(jsonDate)
                
                
                let numberFormatter = NSNumberFormatter()
                let number = numberFormatter.numberFromString(jsonDate)
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.secondsLeft = number as Int
                    self.countdown()
                    
                    
                })
            } else if jsonResult["status"] as String == "expired" {
                println("right before everything breaks")
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                    
                    self.timeLabel.text = "N/A"
                    if self.timer2 != nil { self.timer2!.invalidate() }
                    
                    var alert = UIAlertController(title: "Coinversion Expired", message: "Your current Coinversion has expired. If you still wish you exchange coins, you must begin a new Coinversion.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
                    
                    
                    self.presentViewController(alert, animated: true, completion: {})
                    
                })
            } else if jsonResult["status"] == nil {
                self.checkTimeRemaining()
                println("somethingwrong with shapeshift")
            }
            
        })
        
        jsonQuery.resume()
        
    }
    // MARK: TIMERS & RELATED
    
    func resetTimerwithSpeed(speed: Double) {
        
        if timer1 != nil { timer1!.invalidate() }
        
        timer1 = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("timerDone"), userInfo: nil, repeats: false)
    }
    
    func timerDone() {
        resetTimerwithSpeed(6)
        checkTransactionStatus()
    }
    func updateTime() {
        
        if secondsLeft > 1 {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.secondsLeft!--
                let minutes = (self.secondsLeft % 3600) / 60
                let seconds = (self.secondsLeft % 3600) % 60
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.timeLabel.text = NSString(format: "%02d:%02d", minutes, seconds)
                    self.timeLabel.textColor = UIColor.redColor()
                    
                })
            })
            
        } else {
            
            transactionTimeOut()
        }
        
    }
    func countdown() {
        
        if timer2 != nil { timer2!.invalidate() }
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        
    }
    func handleCancel(alertView: UIAlertAction!)
    {
        transactionTimeOut()
    }
    
    // MARK: tx Over
    func sendEmailReceipt(speed: Double) {
        if timer3 != nil { timer3!.invalidate() }
        
        timer3 = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("timerDone2"), userInfo: nil, repeats: false)
        println(self.emailAddressForReciept)
        
    }
    func transactionTimeOut() {
        pendingTransaction = false
        nc.postNotificationName("resetCoinvert", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    //MARK: Button Presses
    @IBAction func copyDepositButtonWasPressed(sender: AnyObject) {
        
        UIPasteboard.generalPasteboard().string = depositAddressString as String
        self.depositAddressPopup.hidden = false
        self.depositAddressPopup.alpha = 1
        
        UIView.animateWithDuration(0.5, delay: 1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.depositAddressPopup.alpha = 0.0
            }) { (Bool) -> Void in
                
                self.depositAddressPopup.hidden = true
                
        }
        
    }
    
    @IBAction func copySendAmountButtonWasPressed(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = sendAmountLabel.text
        self.depositAmountPopup.hidden = false
        self.depositAmountPopup.alpha = 1
        
        UIView.animateWithDuration(0.5, delay: 1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.depositAmountPopup.alpha = 0.0
            }) { (Bool) -> Void in
                
                self.depositAmountPopup.hidden = true
        }
        
    }
    
    @IBAction func cxlButtonWasPressed(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Cancel Coinversion", message: "Cancel current Coinversion?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler:nil))
        
        
        self.presentViewController(alert, animated: true, completion: {
        })
    }
    // MARK: Animations
    func checkCoinViews() {
        
        if fromCoinString2 == "btc" {
            fromCoinImageView1.image = UIImage(named: "bitcoin")
            
            
        } else if fromCoinString2 == "ltc" {
            fromCoinImageView1.image = UIImage(named: "litecoin")
            
            
        } else if fromCoinString2 == "drk" {
            fromCoinImageView1.image = UIImage(named: "darkcoin")
            
            
        } else if fromCoinString2 == "doge" {
            fromCoinImageView1.image = UIImage(named: "dogecoin")
            
            
        } else if fromCoinString2 == "ftc" {
            fromCoinImageView1.image = UIImage(named: "feathercoin")
            
            
        } else if fromCoinString2 == "nmc" {
            fromCoinImageView1.image = UIImage(named: "namecoin")
            
            
        } else if fromCoinString2 == "ppc" {
            fromCoinImageView1.image = UIImage(named: "peercoin")
            
            
        } else if fromCoinString2 == "bc" {
            fromCoinImageView1.image = UIImage(named: "blackcoin")
            
        }
        
        /// checking to coins
        
        
        if toCoinString2 == "btc" {
            toCoinImageView1.image = UIImage(named: "bitcoin")
            
            
        } else if toCoinString2 == "ltc" {
            toCoinImageView1.image = UIImage(named: "litecoin")
            
            
        } else if toCoinString2 == "drk" {
            toCoinImageView1.image = UIImage(named: "darkcoin")
            
            
        } else if toCoinString2 == "doge" {
            toCoinImageView1.image = UIImage(named: "dogecoin")
            
            
        } else if toCoinString2 == "ftc" {
            toCoinImageView1.image = UIImage(named: "feathercoin")
            
            
        } else if toCoinString2 == "nmc" {
            toCoinImageView1.image = UIImage(named: "namecoin")
            
            
        } else if toCoinString2 == "ppc" {
            toCoinImageView1.image = UIImage(named: "peercoin")
            
            
        } else if toCoinString2 == "bc" {
            toCoinImageView1.image = UIImage(named: "blackcoin")
            
        }
        
    }
//    func animateCoins() {
//        
//        fromCoinImageView1.layer.removeAllAnimations()
//        toCoinImageView1.layer.removeAllAnimations()
//        if pendingTransaction == true {
//
//            
//            fromCoinImageView1.hidden = false
//            
//            UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//                self.fromCoinImageView1.alpha = 0
//
//
//                }) { (Bool) -> Void in
//                 
//                    self.animateCoins2()
//            }
//            
//        }
//    }
//    func animateCoins2() {
//        
//        self.toCoinImageView1.alpha = 0
//        self.toCoinImageView1.hidden = false
//        UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//            self.toCoinImageView1.alpha = 1
//            
//            }) { (Bool) -> Void in
//                self.toCoinImageView1.hidden = true
//                self.animateCoins()
//                
//                
//        }
//    }
    // MARK: CONFIGURATION
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    func configurationTextField(textField: UITextField!)
    {
        
        if let tField = textField {
            textField.keyboardType = UIKeyboardType.EmailAddress
            
            self.textField = textField!
        }
    }
    
}
