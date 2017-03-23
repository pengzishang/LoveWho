//
//  ZhenaiMethoes.swift
//  LoveWho
//
//  Created by 彭子上 on 2017/3/23.
//  Copyright © 2017年 彭子上. All rights reserved.
//

import UIKit
import SwiftyJSON
class ZhenaiMethoes: NSObject {
    
    
    class func getLogin(success:@escaping (String,String)->Void) ->Void{
        
//        let pwdSha1=self.sha1(password: pwd)
        let body:Dictionary = ["account":"18948711178",
                               "channelId":"902684",
                               "imgCode":"",
                               "lgType":"1",
                               "password":"6conjXcvy49KRmTaAtWi",
                               "platform":"3",
                               "subChannelId":"2"]
//        let body:Dictionary = ["channel":"1",
//                               "channelid":"1",
//                               "clientid":"11",
//                               "dd":"iPhone8,1",
//                               "deviceid":"2cd138a0de1a79fa363fa07d434ee493878e9130",
//                               "ifa":"00000000-0000-0000-0000-000000000000",
//                               "ifa_tracking":"0",
//                               "isJailbreak":"0",
//                               "lang":"zh-Hans-CN",
//                               "logmod":"1",
//                               "name":name,
//                               "osv":"10.2.1",
//                               "password":pwdSha1,
//                               "reallogin":"1",
//                               "secucode":"D265ED79261F166B622C6CCC7D561FC8",
//                               "userinfotypes":"[1,2,3,4,5,6,7,8,27,100,101,102,103,104,105,106,107,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,136,137,144,145,146,147,148,149,150,151,153,154,155,156,160,163,179,180,181,182,184,185,186,187,206,221,231,232,233,234,236,237,238,244,245,247,249,251,252,255,257,258,259]",
//                               "ver":"6.0.2"]
        let urlStr="https://mobileapi.zhenai.com/login/login.do"
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
                print(json)
//                success(json["token"].stringValue,json["uid"].stringValue)
                
            }
            else
            {
                success("","")
            }
        }
        dataTask.resume()
    }
}
