//
//  MasterViewController.swift
//  Project7
//
//  Created by Nicolas Audren on 09/03/2016.
//  Copyright © 2016 Nicosoft. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [[String: String]]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urlString : String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0) ) { [unowned self] in
            if let url = NSURL(string: urlString) {
                if let data = try? NSData(contentsOfURL: url, options: []) {
                    let json = JSON(data: data)
                    
                    if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                        // we're OK to parse!
                        self.parseJSON(json)
                    }
                    else {
                        self.showError()
                    }
                }
                else {
                    self.showError()
                }
            }
            else {
                self.showError()
            }
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showError() {
        dispatch_async( dispatch_get_main_queue()) { [unowned self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }
    

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = object["title"]
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }

    // MARK: - JSON
    
    //this is an example of the JSON we will get
    
//    {
//      "metadata":{
//          "responseInfo":{
//          "status":200,
//          "developerMessage":"OK",
//          }
//      },
//      "results":[
//          {
//              "title":"Legal immigrants should get freedom before undocumented immigrants – moral, just and fair",
//              "body":"I am petitioning President Obama's Administration to take a humane view of the plight of legal immigrants. Specifically, legal immigrants in Employment Based (EB) category. I believe, such immigrants were short changed in the recently announced reforms via Executive Action (EA), which was otherwise long due and a welcome announcement.",
//              "issues":[
//                  {
//                      "id":"28",
//                      "name":"Human Rights"
//                  },
//                  {
//                      "id":"29",
//                      "name":"Immigration"
//                  }
//              ],
//              "signatureThreshold":100000,
//              "signatureCount":267,
//              "signaturesNeeded":99733,
//          },
//          {
//              "title":"National database for police shootings.",
//              "body":"There is no reliable national data on how many people are shot by police officers each year. In signing this petition, I am urging the President to bring an end to this absence of visibility by creating a federally controlled, publicly accessible database of officer-involved shootings.",
//              "issues":[
//                  {
//                      "id":"28",
//                      "name":"Human Rights"
//                  }
//               ],
//              "signatureThreshold":100000,
//              "signatureCount":17453,
//              "signaturesNeeded":82547,
//          }
//          ]
//    }
    
    func parseJSON(json: JSON) {
        
        let results = json["results"]
        
        for result in results.arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            let sigsNeeded = result["signaturesNeeded"].stringValue
            let obj = ["title": title, "body": body,"sigs": sigs, "sigsNeeded": sigsNeeded]
            objects.append(obj)
        }
        
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.tableView.reloadData()
        }
    }

    


}

