//
//  MessageCell.swift
//  ChatInterfaceProject
//
//  Created by zhifu360 on 2019/5/14.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

///自定义聊天Cell
class MessageCell: UITableViewCell {

    ///消息时间
    lazy var messageTimeLb: UILabel = {
        let label = UILabel()
        label.font = messageTimeFont
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        return label
    }()
    
    ///消息文本
    lazy var messageTextLb: UILabel = {
        let label = UILabel()
        label.font = messageTextFont
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    ///消息背景
    lazy var messageBubbleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    ///用户头像
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func addViews() {
        backgroundColor = .clear
        contentView.addSubview(messageTimeLb)
        contentView.addSubview(iconImageView)
        contentView.addSubview(messageBubbleImageView)
        contentView.addSubview(messageTextLb)
    }
    
    func configWith(messageModel: MessageModel?) {
        
        if let model = messageModel {
            //消息时间
            messageTimeLb.text = model.messageTime
            messageTimeLb.frame = model.messageTimeFrame
            
            //用户icon
            iconImageView.frame = model.iconFrame
            iconImageView.kf.setImage(with: URL(string: model.iconUrl ?? ""), placeholder: UIImage(named: "占位图片"))
            
            //消息背景
            messageBubbleImageView.image = model.messageSenderType == MessageModel.MessageSenderType.Me ? UIImage(named: "me")?.stretchableImage(withLeftCapWidth: 20, topCapHeight: 40) : UIImage(named: "other")?.stretchableImage(withLeftCapWidth: 20, topCapHeight: 40)
            messageBubbleImageView.frame = model.messageBubbleFrame
            
            //消息文本
            messageTextLb.text = model.messageText
            messageTextLb.frame = model.messageTextFrame
            
        }
        
    }
    
    ///创建Cell
    class func createCellWith(tableView: UITableView, indexPath: IndexPath, messageModel: MessageModel?) -> MessageCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: BaseTableReuseIdentifier, for: indexPath) as? MessageCell
        if cell == nil {
            cell = MessageCell(style: .default, reuseIdentifier: BaseTableReuseIdentifier)
        }
        cell?.selectionStyle = .none
        cell?.configWith(messageModel: messageModel)
        return cell!
        
    }
}
