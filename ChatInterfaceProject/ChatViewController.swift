//
//  ChatViewController.swift
//  ChatInterfaceProject
//
//  Created by zhifu360 on 2019/5/14.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController {

    ///数据源
    var dataArray = [MessageModel]()
    
    lazy var chatView: ChatView = {
        let chatView = ChatView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ContentHeight))
        return chatView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPage()
        requestAPI()
    }
    
    func setPage() {
        title = "演示"
        view.addSubview(chatView)
    }
    
    func requestAPI() {
        let dic = Bundle.readDataWith(fileName: "content", fileType: "json")
        let tmpArr = dic["data"] as! [[String: Any]]
        for tmpDic in tmpArr {
            let messageModel = MessageModel()
            messageModel.messageTime = tmpDic["messageTime"] as? String
            messageModel.messageText = tmpDic["messageText"] as? String
            let senderType = tmpDic["messageSenderType"] as? Int
            messageModel.messageSenderType = senderType == 1 ? MessageModel.MessageSenderType.Other : MessageModel.MessageSenderType.Me
            messageModel.iconUrl = tmpDic["iconUrl"] as? String
            messageModel.showMessageTime = tmpDic["showMessageTime"] as? Bool
            messageModel.layoutUIFrames()
            dataArray.append(messageModel)
        }
        
        chatView.dataArr = dataArray
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
