//
//  PZSTool.swift
//  LoveWho
//
//  Created by 彭子上 on 2016/12/14.
//  Copyright © 2016年 彭子上. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
class PZSTool: NSObject {
    
    typealias InputClosureType = (String,String) -> Void
    typealias getUIDClosureType = (Array<String>)->Void
    
    var myuid:String!
    var token:String!
    var location:String!
    
    override init() {
        super.init()
    }
    
    
    class func getLogin(loginName name:String,password pwd:String, success:@escaping (String,String)->Void) ->Void{
        
        let pwdSha1=self.sha1(password: pwd)
        let body:Dictionary = ["channel":"1",
                               "channelid":"1",
                               "clientid":"11",
                               "dd":"iPhone8,1",
                               "deviceid":"2cd138a0de1a79fa363fa07d434ee493878e9130",
                               "ifa":"00000000-0000-0000-0000-000000000000",
                               "ifa_tracking":"0",
                               "isJailbreak":"0",
                               "lang":"zh-Hans-CN",
                               "logmod":"1",
                               "name":name,
                               "osv":"10.2.1",
                               "password":pwdSha1,
                               "reallogin":"1",
                               "secucode":"D265ED79261F166B622C6CCC7D561FC8",
                            "userinfotypes":"[1,2,3,4,5,6,7,8,27,100,101,102,103,104,105,106,107,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,136,137,144,145,146,147,148,149,150,151,153,154,155,156,160,163,179,180,181,182,184,185,186,187,206,221,231,232,233,234,236,237,238,244,245,247,249,251,252,255,257,258,259]",
                               "ver":"6.0.2"]
        let urlStr="https://passport.jiayuan.com/api/sign/signoninfo.php?"
        var request=URLRequest.init(url: URL(string: urlStr)!)
        request.httpMethod = "POST"
        let bodylist  = NSMutableArray()
        for subDic in body {
            let tmpStr = "\(subDic.0)=\(subDic.1)"
            bodylist.add(tmpStr)
        }
        
        let paraStr=bodylist.componentsJoined(by: "&")
        let paraData = paraStr.data(using: String.Encoding.utf8)
        request.httpBody=paraData
        let dataTask=URLSession.shared.dataTask(with: request) { (datada, response, error ) in
            if datada != nil
            {
                let json=JSON(data:datada!)
                success(json["token"].stringValue,json["uid"].stringValue)

            }
            else
            {
                success("","")
            }
                    }
        dataTask.resume()
    }
    
    class func sha1(password pwd:String) -> String {
        let str=pwd.cString(using: String.Encoding.utf8)
        let strlen=CUnsignedInt(pwd.lengthOfBytes(using: String.Encoding.utf8))
        let digestlen=Int(CC_SHA1_DIGEST_LENGTH)
        let result=UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestlen)
        CC_SHA1(str!, strlen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestlen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return hash as String
    }
    
    
    /// 快速获得列表
    ///
    /// - Parameter success: <#success description#>
    func getModel( _ success:@escaping (Array<JiaYuanModel>)->Void) -> Void{
        var returnList=Array<JiaYuanModel>()
        let body:Dictionary = ["changearray":"1",
                               "channel":"1",
                              "channelid":"1",
                              "clientid":"11",
                              "cursor":"0",
                              "flag":"yjzq",
                              "isJailbreak":"0",
                              "lang":"zh-Hans-CN",
                              "loc":self.location,
                              "offset":"30",
                              "token":self.token,
                              "uid":self.myuid,
                              "userinfotypes":"[2,3,300,126,206,112,114,104,246]",
                              "ver":"6.0.2"]
        var urlStr="http://api2.jiayuan.com/geo/fast_getid_cached.php?"

        let bodylist  = NSMutableArray()
        for subDic in body {
            let tmpStr = "\(subDic.0)=\(subDic.1!)"
            bodylist.add(tmpStr)
        }
        
        let paraStr=bodylist.componentsJoined(by: "&")
        urlStr=urlStr+paraStr
        urlStr=urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var request=URLRequest.init(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        
        let config=URLSessionConfiguration.default
        let datasession=URLSession(configuration: config)
        
        let dataTask=datasession.dataTask(with: URL(string: urlStr)!) { (datada, response, error ) in
            let json=JSON(data:datada!)
            let peopleList:Array=json["node"].arrayValue
            for single in peopleList
            {
                
                if single["dis"].intValue<18 && single["112"].intValue>156
                {
                    print(single)
                    let model=JiaYuanModel()
                    model.uid=(single["uid"].stringValue)
                    model.height=single["112"].stringValue
                    model.pic=single["300"].stringValue
                    model.name=single["3"].stringValue
                    let dis=single["dis"].stringValue
                    let index=dis.index(dis.startIndex, offsetBy: 4)
                    model.dis=dis.substring(to: index)
                    model.sex=single["f"].stringValue
                    returnList.append(model)
                }
                
            }
            success(returnList)
        }
        dataTask.resume()
    }
    
    func getModelMode1( _ success:@escaping (Array<JiaYuanModel>)->Void) -> Void {
        var returnList=Array<JiaYuanModel>()
        let body:Dictionary = ["action":"meetFindBack",
                               "channel":"1",
                               "channelid":"1",
                               "clientid":"11",
                               "fun":"findmeet",
                               "isJailbreak":"0",
                               "lang":"zh-Hans-CN",
                               "uid":self.myuid,
                               "token":self.token,
                               "ver":"6.0.2"]
        var urlStr="http://api.jiayuan.com/app.php?"
        
        let bodylist  = NSMutableArray()
        for subDic in body {
            let tmpStr = "\(subDic.0)=\(subDic.1!)"
            bodylist.add(tmpStr)
        }
        
        let paraStr=bodylist.componentsJoined(by: "&")
        urlStr=urlStr+paraStr
        urlStr=urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var request=URLRequest.init(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        
        let config=URLSessionConfiguration.default
        let datasession=URLSession(configuration: config)
        
        let dataTask=datasession.dataTask(with: URL(string: urlStr)!) { (datada, response, error ) in
            let json=JSON(data:datada!)
            let peopleList:Array=json["uids"].arrayValue
            print(peopleList)
            for single in peopleList
            {
                
                if single["112"].intValue>155
                {
                    print(single)
                    let model=JiaYuanModel()
                    model.uid=(single["uid"].stringValue)
                    model.height=single["112"].stringValue
                    model.pic=single["221"].stringValue
                    model.name=single["3"].stringValue
                    model.dis="0"
                    model.sex=single["f"].stringValue
                    returnList.append(model)
                }
                
            }
            success(returnList)
        }
        dataTask.resume()
    }
    
    func superStar(hei height:Int,dis distance:Int,complete:@escaping (Bool)->Void) -> Void{
        self.getUid(hei: height, dis: distance) { (uids) in
            self.sendMutiLetter(uids, complete: { (isSuccess) in
                if isSuccess{
                    complete(true)
                }
            })
        }
    }
    
    
    func sendMutiLetter(_ targetUidList:Array<String>,complete:@escaping (Bool)->Void) ->Void{
        for i in 0..<targetUidList.count{
            let uid:String=targetUidList[i]
            self.sendingLetterSingle(uid, withHandler: { (isSuccess) in
                if isSuccess&&i==targetUidList.count-1{
                    complete(true)
                }
            })
        }
    }
    
    func sendingLetterSingle(_ targetUid:String,withHandler handler:@escaping (Bool)->Void)->Void{
        let urlstr="http://api.jiayuan.com/msg/dosend.php?channel=1&channelid=1&clientid=11&from=" + self.myuid + "&isJailbreak=0&lang=zh-Hans-CN&page_id=0&src=1&to=" + targetUid + "&token="+self.token+"&ver=6.0.2&withtype=1"
        let request=URLRequest(url: URL(string: urlstr)!)
        let dataTask=URLSession.shared.dataTask(with: request) { (datada, response, error) in
            let json=JSON(data:datada!)
            print(targetUid + json["msg"].stringValue)
            if json["msg"] == "发信成功"{
                handler(true)
            }
            else{
                handler(false)
            }
            } as URLSessionTask
        
        dataTask.resume()
        
    }
    
    /// 返回UID列表
    ///
    /// - Parameter success: <#success description#>
    func getUid(hei height:Int,dis distance:Int,success:@escaping getUIDClosureType)->Void
    {
        var returnList=Array<String>()
        let body:Dictionary = ["changearray":"1",
                               "channel":"1",
                               "channelid":"1",
                               "clientid":"11",
                               "cursor":"0",
                               "flag":"yjzq",
                               "isJailbreak":"0",
                               "lang":"zh-Hans-CN",
                               "loc":self.location,
                               "offset":"30",
                               "token":self.token,
                               "uid":self.myuid,
                               "userinfotypes":"[2,3,300,126,206,112,114,104,246]",
                               "ver":"6.0.2"]
        var urlStr="http://api2.jiayuan.com/geo/fast_getid_cached.php?"
        let bodylist  = NSMutableArray()
        for subDic in body {
            let tmpStr = "\(subDic.0)=\(subDic.1!)"
            bodylist.add(tmpStr)
        }
        
        let paraStr=bodylist.componentsJoined(by: "&")
        urlStr=urlStr+paraStr
        urlStr=urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var request=URLRequest.init(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        
        let config=URLSessionConfiguration.default
        let datasession=URLSession(configuration: config)
        
        let dataTask=datasession.dataTask(with: request){ (datada, response, error) in
            let json=JSON(data:datada!)
            let peopleList:Array=json["node"].arrayValue
            for single in peopleList
            {
                if single["112"].intValue>=height&&single["dis"].intValue<=distance{
                    let uid=single["uid"].stringValue
                    returnList.append(uid)
                }
            }
            success(returnList)
        }
        dataTask.resume()
    }
    
    class func showAnimation(_ targetView:UIView) -> Void {
        let hud = MBProgressHUD.showAdded(to: targetView, animated: true)
        hud.removeFromSuperViewOnHide=true
        hud.label.text="开始发送"
        hud.tag=3000
        hud.show(animated: true)
    }
    
    
    class func stopAnimation(_ targetView:UIView) -> Void {
        let hud:MBProgressHUD=targetView.viewWithTag(3000) as! MBProgressHUD
        hud.label.text="发送成功"
        hud.hide(animated: true, afterDelay: 0.5)
    }
    
    
}
