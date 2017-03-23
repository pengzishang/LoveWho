//
//  JiayuanCollectionViewController.swift
//  LoveWho
//
//  Created by 彭子上 on 2016/12/26.
//  Copyright © 2016年 彭子上. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh
import FTPopOverMenu
private let reuseIdentifier = "girlCell"

class JiayuanCollectionViewController: UICollectionViewController {
    var girlList=Array<JiaYuanModel>.init()
    var repeatList=Timer()
    var isSearching=false
    var manger=PZSTool.init()
    var token:String?
    var uid:String?
    var location:String?
    var mode = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let width=(self.view.bounds.width-20)/2
        let height=width
        layout.itemSize=CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.collectionView?.collectionViewLayout=layout
        self.manger.myuid=self.uid
        self.manger.token=self.token;
        self.manger.location=self.location;
        
        self.collectionView?.mj_header=MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.collectionView?.mj_header.beginRefreshing()
    }
    
    func refreshAction() -> Void {
        self.collectionView?.mj_header.beginRefreshing()
        DispatchQueue.global().async {
            if self.mode==0 {
                self.manger.getModel({ (resultList) in
                    self.girlList=resultList
                    DispatchQueue.main.async {
                        self.collectionView?.mj_header.endRefreshing()
                        self.collectionView?.reloadData()
                    }
                })
            }
            else if self.mode == 1{
                self.manger.getModelMode1({ (resultList) in
                    self.girlList=resultList
                    DispatchQueue.main.async {
                        self.collectionView?.mj_header.endRefreshing()
                        self.collectionView?.reloadData()
                    }
                })
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func switchMode(_ sender: UIBarButtonItem,forEvent event:UIEvent) {
        FTPopOverMenu.show(from: event, withMenuArray: ["模式0","模式1(质量高,20min一波)"], imageArray: ["",""], doneBlock: { (chooseIndex) in
            if chooseIndex==0{
                self.mode=0
                
            }
            else if chooseIndex==1{
                self.mode=1
            }
            self.collectionView?.mj_header.beginRefreshing()
        }, dismiss: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.girlList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let model = self.girlList[indexPath.row]
        let heightLab:UILabel=cell.viewWithTag(1002) as! UILabel
        heightLab.text=model.height
        let disLab=cell.viewWithTag(1003) as! UILabel
        disLab.text=model.dis
        let imageView=cell.viewWithTag(101) as! UIImageView
        imageView.sd_setImage(with: URL(string: (model.pic))!, placeholderImage:UIImage.init(named: "reading"))
        
        if !model.highlight
        {
            cell.backgroundColor=UIColor.white
        }
        else
        {
            cell.backgroundColor=UIColor.lightGray
        }
        
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.girlList[indexPath.row]
        let cell:UICollectionViewCell=collectionView.cellForItem(at: indexPath)!
        cell.backgroundColor=UIColor.lightGray
        manger.sendingLetterSingle((model.uid)) { (isSuccess) in
        }
        
        model.highlight = true
        if !model.highlight
        {
            cell.backgroundColor=UIColor.white
        }
        else
        {
            cell.backgroundColor=UIColor.lightGray
        }
    }

    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
