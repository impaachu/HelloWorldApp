//
//  TodayViewController.swift
//  HelloWorldWidget
//
//  Created by Mai Kachaban on 28/01/2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
  
    fileprivate var data: Array<NSDictionary> = Array()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
      
        let dictUSD:[String:String] = ["title": "USD", "value": "Loading..."]
        let dictINR:[String:String] = ["title": "INR", "value": "Loading..."]
        let dictTHB:[String:String] = ["title": "THB", "value": "Loading..."]
        self.data.append(dictUSD as NSDictionary)
        self.data.append(dictINR as NSDictionary)
        self.data.append(dictTHB as NSDictionary)
      
    }
  
    override func viewDidAppear(_ animated: Bool){
      super.viewDidAppear(animated)
      
      if #available(iOSApplicationExtension 10.0, *) {
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
      }
      self.preferredContentSize.height = 200
      
    }
  
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
      return UIEdgeInsets.zero
    }
  
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
      if activeDisplayMode == .expanded {
        preferredContentSize = CGSize(width: maxSize.width, height: 300)
      }
      else if activeDisplayMode == .compact {
        preferredContentSize = maxSize
      }
    }
  
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        let urlPath: String = "https://blockchain.info/ticker"
        let url: NSURL = NSURL(string: urlPath)!
        let request: URLRequest = URLRequest(url: url as URL)
        let queue:OperationQueue = OperationQueue()
      
      NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: URLResponse!, data: Data!, error: Error!) -> Void in
        
        if(error != nil){
          completionHandler(NCUpdateResult.failed)
        }else{
          do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
            let formatter = NumberFormatter()
            self.data.removeAll()
            if let dictionary = jsonResult as? [String: Any] {
              
              if let nestedDictionary = dictionary["USD"] as? [String: Any] {
                let value = formatter.string(from: nestedDictionary["last"] as! NSNumber) ?? ""
                let dictUSD:[String:String] = ["title": "USD", "value": value]
                self.data.append(dictUSD as NSDictionary)
              }
            
              if let nestedDictionary = dictionary["INR"] as? [String: Any] {
                let value = formatter.string(from: nestedDictionary["last"] as! NSNumber) ?? ""
                let dictINR:[String:String] = ["title": "INR", "value": value]
                self.data.append(dictINR as NSDictionary)
              }
              
              if let nestedDictionary = dictionary["THB"] as? [String: Any] {
                let value = formatter.string(from: nestedDictionary["last"] as! NSNumber) ?? ""
                let dictTHB:[String:String] = ["title": "THB", "value": value]
                self.data.append(dictTHB as NSDictionary)
              }
              
              DispatchQueue.main.async {
                self.tableView.reloadData()
                completionHandler(NCUpdateResult.newData)
              }
          }
          } catch let error as NSError {
            print(error)
          }
          
        }
        
      })

    }
  
  
    //this function returns total row count of table view based on data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return data.count
    }
  
    //this function sets cell elements (Title, Value) of table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetItem", for: indexPath) as! WidgetItemTableViewCell
      
      let item = data[indexPath.row]
      cell.widgetItemTitle.text = item["title"] as? String
      cell.widgetItemValue.text = item["value"] as? String
      
      return cell
      
    }
}
