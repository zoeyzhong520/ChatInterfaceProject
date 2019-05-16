//
//  MessageModel.swift
//  ChatInterfaceProject
//
//  Created by zhifu360 on 2019/5/14.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class MessageModel: NSObject {

    enum MessageSenderType: Int {
        case Me = 0//自己
        case Other//对方
    }
    
    ///消息文本
    var messageText: String?
    
    ///消息时间
    var messageTime: String?
    
    ///用户头像地址
    var iconUrl: String?
    
    ///是否显示消息时间
    var showMessageTime: Bool?
    
    ///用户类型，自己或者对方
    var messageSenderType: MessageSenderType?
    
    ///消息时间frame
    var messageTimeFrame = CGRect.zero
    
    ///用户头像frame
    var iconFrame = CGRect.zero
    
    ///消息文本frame
    var messageTextFrame = CGRect.zero
    
    ///消息背景frame
    var messageBubbleFrame = CGRect.zero
    
    ///行高
    var cellHeight: CGFloat = 0
    
    //MARK: - 初始化方法
    class func initWith(messageText: String?, messageTime: String?, iconUrl: String?, showMessageTime: Bool?, messageSenderType: Int?) -> MessageModel {
        
        let model = MessageModel()
        model.messageText = messageText
        model.messageTime = messageTime
        model.iconUrl = iconUrl
        model.showMessageTime = showMessageTime
        model.messageSenderType = messageSenderType == 1 ? MessageModel.MessageSenderType.Other : MessageModel.MessageSenderType.Me
        model.layoutUIFrames()
        return model
        
    }
    
    //MARK: - 计算messageCell中控件的frame
    
    ///计算相应控件的frame，必须按照控件顺序从上往下进行计算
    func layoutUIFrames() {
        getMessageTimeFrame()
        getIconFrame()
        getMessageTextFrame()
        getMessageBubbleFrame()
        getCellHeight()
    }
    
    func getMessageTimeFrame() {
        var frame = CGRect.zero
        if showMessageTime == true && messageTime != nil {
            let timeSize = messageTime!.sizeWithFont(font: messageTimeFont, maxSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 14))
            frame = CGRect(x: (ScreenSize.width - timeSize.width)/2, y: padding, width: timeSize.width+10, height: 14)
        }
        messageTimeFrame = frame
    }
    
    func getIconFrame() {
        var frame = CGRect.zero
        if messageSenderType == MessageSenderType.Me {
            frame = CGRect(x: ScreenSize.width - iconWidth - padding, y: messageTimeFrame.maxY+padding, width: iconWidth, height: iconWidth)
        } else {
            frame = CGRect(x: padding, y: messageTimeFrame.maxY+padding, width: iconWidth, height: iconWidth)
        }
        iconFrame = frame
    }
    
    func getMessageTextFrame() {
        var frame = CGRect.zero
        //设置最大尺寸
        let maxSize = CGSize(width: ScreenSize.width - iconWidth - padding*5, height: CGFloat.greatestFiniteMagnitude)
        //计算真实尺寸
        var realSize = CGSize.zero
        if messageText != nil {
            realSize = messageText!.sizeWithFont(font: messageTextFont, maxSize: maxSize)
        }
        //调整信息位置
        var offSetX: CGFloat = 0
        if messageSenderType == MessageSenderType.Me {
            offSetX = iconFrame.minX - realSize.width - padding
        } else {
            offSetX = iconFrame.maxX + padding
        }
        frame = CGRect(x: offSetX, y: iconFrame.minY, width: realSize.width, height: realSize.height)
        messageTextFrame = frame
    }
    
    func getMessageBubbleFrame() {
        messageBubbleFrame = messageTextFrame
    }
    
    func getCellHeight() {
        cellHeight = messageTimeFrame.size.height + (messageTextFrame.height < iconWidth ? iconWidth : messageTextFrame.size.height) + padding*2
    }
    
}
