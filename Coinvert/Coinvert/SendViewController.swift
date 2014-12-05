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
    var secondsLeft: Int!
    var minutes, seconds: Int!
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
    var emailAddressForReciept: String!
    
    var nc = NSNotificationCenter.defaultCenter()

    
    @IBOutlet weak var fixedAmountCover: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var transactionStatusLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var depositAddressLabel: UILabel!
    @IBOutlet weak var withdrawalAddressLabel: UILabel!
    
    @IBOutlet weak var copyDepositAddressButton: UIButton!
    
    @IBOutlet weak var sendAmountLabel: UILabel!
    @IBOutlet weak var copySendAmountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pendingTransaction = true
        qrCodeImageView.image = UIImage.mdQRCodeForString(depositAddressLabel.text, size: qrCodeImageView.bounds.size.width)
        self.view.addSubview(qrCodeImageView)
        
        copyDepositAddressButton.imageView?.image = UIImage(named: "copy")
        copySendAmountButton.removeFromSuperview()
        
        var string = "\(fromCoinString2)_\(toCoinString2)"
        println(withdrawalAddressLabel.text)
        println(fromCoinString2)
        println(toCoinString2)
        println(string)
        
        println(depositAmount)
        withdrawalAddressLabel.text = withDrawalString
        var stringy = "\(depositAmount)"
        let s2 = withdrawalAddressLabel.text
        
        var params: [String:String]
        var shapeshiftURL: String!
        
        timerDone()
        
        //MARK: JSON POST
        
//        nc.addObserverForName("appEnteredForeground", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
//            self.resetTimerwithSpeed(30)
//        })
        
        if depositAmount != nil {
            let s = NSString(format: "%f", depositAmount)
            params = ["amount":s as String!, "withdrawal":s2 as String!, "pair": "\(fromCoinString2)_\(toCoinString2)"] as Dictionary
            shapeshiftURL = "http://shapeshift.io/sendamount"
            fixedAmountCover.removeFromSuperview()
            copySendAmountButton.imageView?.image = UIImage(named: "copy")
            view.addSubview(copySendAmountButton)

        } else {
            
            params = ["withdrawal":s2 as String!, "pair": "\(fromCoinString2)_\(toCoinString2)"] as Dictionary
            shapeshiftURL = "http://shapeshift.io/shift"
            
        }
        
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
//                alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
//                    
//                }))
                self.presentViewController(alert, animated: true, completion: {
                })

            }
                
            else {
     
              
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if self.depositAmount != nil {
                        self.depositAddressString = json["success"]!["deposit"] as String!
                        self.sendAmountLabel.text = json["success"]!["depositAmount"] as String!
                        self.checkTimeRemaining()
                        
                    }
                    
                    self.depositAddressString = json["deposit"] as String!
                    println(self.depositAddressString)

                        self.depositAddressLabel.text = self.depositAddressString
                    self.qrCodeImageView.image = UIImage.mdQRCodeForString(self.depositAddressLabel.text, size: self.qrCodeImageView.bounds.size.width)
                    self.view.addSubview(self.qrCodeImageView)
                    
                  
                })
                
                
                
                
            }
            
        })
      
        task.resume()
        checkTransactionStatus()
        
    }
    
    func checkTransactionStatus() {
        
        if pendingTransaction == true {
        
        let urlAsString = "http://shapeshift.io/txStat/\(depositAddressString)"
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
            
            if jsonResult["status"] != nil {
                
                println(jsonResult["status"] as String!)
                
                var results = jsonResult["status"] as String!
                
                
                if results == "received" {
                    
                    self.transactionStatusLabel.text = "Received"
                    
                } else if results == "complete" {
                    
                    self.txIdForReciept = jsonResult["transaction"] as String!
                    self.transactionStatusLabel.text = "Complete"
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        var alert = UIAlertController(title: "Coinversion complete!", message: "Do you want a receipt?", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
                        
                        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
                        alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                            
                            self.emailAddressForReciept = self.textField.text
                            self.sendEmailReceipt()
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
                    
                    self.transactionStatusLabel.text = "Waiting"

                    
                }
                
                
            }
        })
        
        jsonQuery.resume()
        }
    }
    
    func resetTimerwithSpeed(speed: Double) {
        
        if timer1 != nil { timer1!.invalidate() }
        
        timer1 = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("timerDone"), userInfo: nil, repeats: false)
    }
    
    func timerDone() {
        resetTimerwithSpeed(6)
        checkTransactionStatus()
    }
    
    
    func configurationTextField(textField: UITextField!)
    {
        
        if let tField = textField {
            textField.keyboardType = UIKeyboardType.EmailAddress
            self.textField = textField!
        }
    }
    
    
    func handleCancel(alertView: UIAlertAction!)
    {
        transactionTimeOut()
    }
    
    func sendEmailReceipt() {
        
        var  params = ["email":emailAddressForReciept, "txid": txIdForReciept] as Dictionary
        var  shapeshiftURL = "http://shapeshift.io/mail"
        
        
        
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
        
        let urlAsString = "http://shapeshift.io/timeremaining/\(depositAddressString)"
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
            
            if jsonResult["seconds_remaining"] != nil {
                
                var jsonDate: String! = jsonResult["seconds_remaining"] as String
                println(jsonDate)
                
                
                let numberFormatter = NSNumberFormatter()
                let number = numberFormatter.numberFromString(jsonDate)
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.secondsLeft = number as Int
                    self.countdown()
                    
                    
                })
            }
        })
        
        jsonQuery.resume()
        
    }
    func transactionTimeOut() {
        pendingTransaction = false
        nc.postNotificationName("resetCoinvert", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func copyDepositButtonWasPressed(sender: AnyObject) {
        
        UIPasteboard.generalPasteboard().string = depositAddressString as String
        
        copyDepositAddressButton.imageView?.image = UIImage(named: "copied")

    }
    
    @IBAction func copySendAmountButtonWasPressed(sender: AnyObject) {
        copySendAmountButton.setTitle("Copied!",forState: .Normal)
copySendAmountButton.imageView?.image = UIImage(named: "copied")
        UIPasteboard.generalPasteboard().string = sendAmountLabel.text as String!

    }
    
    func updateTime() {
        if secondsLeft > 1 {
            secondsLeft!--
            minutes = (secondsLeft % 3600) / 60
            seconds = (secondsLeft % 3600) % 60
            timeLabel.text = NSString(format: "%02d:%02d", minutes, seconds)
            timeLabel.textColor = UIColor.redColor()
            println("labelshouldupdate")
            
        } else {
            
            transactionTimeOut()
        }
        
    }
    func countdown() {
        
        if timer2 != nil { timer2!.invalidate() }
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
    }
    
}
