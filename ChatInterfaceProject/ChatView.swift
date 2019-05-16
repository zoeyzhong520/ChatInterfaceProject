//
//  ChatView.swift
//  ChatInterfaceProject
//
//  Created by zhifu360 on 2019/5/14.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class ChatView: UIView {

    ///数据源
    var dataArr: [MessageModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    ///记录inputTextBar的新高度
    var inputTextBarNewH: CGFloat = 60
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height - 60), style: .plain)
        tableView.backgroundColor = ChatViewBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MessageCell.self, forCellReuseIdentifier: BaseTableReuseIdentifier)
        return tableView
    }()
    
    lazy var inputTextBar: InputTextBar = {
        let bar = InputTextBar(frame: CGRect(x: 0, y: self.bounds.size.height - 60, width: self.bounds.size.width, height: 60))
        bar.delegate = self
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(tableView)
        addSubview(inputTextBar)
    }

}

extension ChatView: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let messageModel = dataArr?[indexPath.row]
        return messageModel?.cellHeight ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageModel = dataArr?[indexPath.row]
        let cell = MessageCell.createCellWith(tableView: tableView, indexPath: indexPath, messageModel: messageModel)
        return cell
    }
    
    ///UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //点击拖拽聊天区域时，回收键盘
        endEditing(true)
    }
    
}

extension ChatView: InputTextBarDelegate {
    
    func keyboardWillChangeFrameWith(duration: Double, keyboardFrame: CGRect) {
        //需要减去InputTextBar即工具条的高度
        //注：此处需剔除工具条增长的高度，否则工具条随着键盘弹起、回收会有UI问题
        let transformY = keyboardFrame.origin.y - frame.size.height - inputTextBar.frame.size.height - 4 + (inputTextBarNewH - 60)
        
        if transformY < 0 {
            //键盘弹起，tableView自动滚动到底部
            if let count = dataArr?.count {
                tableView.scrollToRow(at: IndexPath(row: count-1, section: 0), at: .bottom, animated: true)
            }
        }
        
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(translationX: 0, y: transformY)
        }
    }
    
    func sendWith(text: String) {
        //插入一条新消息
        tableView.beginUpdates()
        let newMessage = MessageModel.initWith(messageText: text, messageTime: "今天 17:31", iconUrl: "http://k.zol-img.com.cn/sjbbs/7692/a7691515_s.jpg", showMessageTime: true, messageSenderType: 0)
        let cnt = dataArr?.count ?? 0
        dataArr?.insert(newMessage, at: cnt)
        tableView.insertRows(at: [IndexPath(row: cnt, section: 0)], with: .left)
        tableView.endUpdates()
        
        tableView.scrollToRow(at: IndexPath(row: cnt, section: 0), at: .bottom, animated: false)
    }
    
    func textViewDidChangeWith(textSize: CGSize) {
        //更新UI
        UIView.animate(withDuration: 0.2) {
            let realHeight = textSize.height < (60 - padding*2) ? (60 - padding*2) : textSize.height
            let inputTextBarH = realHeight + padding*2
            self.inputTextBarNewH = inputTextBarH
            
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - inputTextBarH)
            self.inputTextBar.frame = CGRect(x: 0, y: self.frame.size.height - inputTextBarH, width: self.frame.size.width, height: inputTextBarH)
            self.inputTextBar.inputTV.frame = CGRect(x: padding, y: padding, width: self.inputTextBar.frame.size.width - padding - 100, height: realHeight)
            
        }
    }
    
}
