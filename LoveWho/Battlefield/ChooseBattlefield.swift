//
//  ChooseBattlefield.swift
//  LoveWho
//
//  Created by 彭子上 on 2016/12/14.
//  Copyright © 2016年 彭子上. All rights reserved.
//

import UIKit
import CoreLocation


class ChooseBattlefield: UITableViewController,CLLocationManagerDelegate {
    
    var userJiayuan=UserDefaults.standard.object(forKey: "userJiayuan") as? String
    var pwdJiayuan=UserDefaults.standard.object(forKey: "pwdJiayuan") as? String
    var token=String.init()
    var uid=String.init()
    var resultList:Array<JiaYuanModel>?
    var locationManager:CLLocationManager!
    var location:String?
    var latitude:Double?
    var longitude:Double?
    @IBOutlet weak var loadingJiayuan: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate=self
        if CLLocationManager.locationServicesEnabled(){
            // 开启定位服务
            locationManager.startUpdatingLocation()
        }else{
            print("没有定位服务")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localInfo=locations.last
        latitude = (localInfo?.coordinate.latitude)! as Double
        longitude = (localInfo?.coordinate.longitude)! as Double
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//       MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row==0
        {
            self.loadingJiayuan.startAnimating()
            let alert=UIAlertController.init(title: "输入佳缘账号", message: "输入你的佳缘账号", preferredStyle: UIAlertControllerStyle.alert)
            let cancle=UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
                
            })
            let ok=UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (action) in
                if (alert.textFields?[0].text != nil)&&(alert.textFields?[1].text != nil){
                    self.userJiayuan=(alert.textFields?[0].text)!
                    self.pwdJiayuan=(alert.textFields?[1].text)!
                    UserDefaults.standard.set(self.userJiayuan, forKey: "userJiayuan")
                    UserDefaults.standard.set(self.pwdJiayuan, forKey: "pwdJiayuan")
                    PZSTool.getLogin(loginName: self.userJiayuan!, password: self.pwdJiayuan!, success: { (token, uid) in
                        print(token);
                        if token.characters.count>0{
                            self.token=token
                            self.uid=uid
                            DispatchQueue.main.async {
                                self.loadingJiayuan.stopAnimating()
                                self.performSegue(withIdentifier: "Jiayuan", sender: nil)
                            }
                        }
                        else
                        {
                            self.loadingJiayuan.stopAnimating()
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })
            alert.addTextField(configurationHandler: { (username) in
                if (self.userJiayuan != nil){
                    username.text=self.userJiayuan
                }
            })
            alert.addTextField(configurationHandler: { (pwd) in
                if (self.pwdJiayuan != nil){
                    pwd.text=self.pwdJiayuan
                }
            })
            alert.addAction(cancle)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: {
                
            })
        }
        else if indexPath.row == 1
        {
            ZhenaiMethoes.getLogin(success: { (str1, str2) in
                
            })
//            ZhenaiMethoes.getLogin(loginName: <#T##String#>, password: <#T##String#>, success: <#T##(String, String) -> Void#>)
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Jiayuan"{
            let target=segue.destination as! JiayuanCollectionViewController
            target.uid=self.uid
            target.token=self.token
            target.location="{\"lng\":" +  String(describing: longitude!) + ",\"lat\":" + String(describing: latitude!) + "}"
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
