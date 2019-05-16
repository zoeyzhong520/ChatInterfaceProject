//
//  InputTextBar.swift
//  ChatInterfaceProject
//
//  Created by zhifu360 on 2019/5/15.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

@objc protocol InputTextBarDelegate: NSObjectProtocol {
    @objc optional
    func keyboardWillChangeFrameWith(duration: Double, keyboardFrame: CGRect)
    
    @objc optional
    func sendWith(text: String)
    
    @objc optional
    func textViewDidChangeWith(textSize: CGSize)
}

class InputTextBar: UIView {

    weak var delegate: InputTextBarDelegate?
    
    ///输入框
    lazy var inputTV: UITextView = {
        let inputTV = UITextView(frame: CGRect(x: padding, y: padding, width: self.bounds.size.width - padding - 100, height: self.bounds.size.height - padding*2))
        inputTV.delegate = self
        inputTV.font = messageTextFont
        inputTV.textColor = UIColor.black
        inputTV.returnKeyType = UIReturnKeyType.send
        inputTV.enablesReturnKeyAutomatically = true//当没有文字时禁用回车
        inputTV.layer.cornerRadius = 3
        return inputTV
    }()
    
    ///发送按钮
    lazy var sendBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: self.inputTV.frame.maxX, y: 0, width: 100, height: self.bounds.size.height))
        btn.setTitle("发送", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.isUserInteractionEnabled = false
        btn.addTarget(self, action: #selector(sendBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        backgroundColor = UIColor.gray
        addSubview(inputTV)
        addSubview(sendBtn)
        
        //添加键盘监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        //获取键盘尺寸
        let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //获取键盘动画时长
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        //修改输入bar的约束
        if delegate != nil {
            delegate?.keyboardWillChangeFrameWith?(duration: duration, keyboardFrame: keyboardRect)
        }
    }
    
    @objc func sendBtnClick(_ btn: UIButton) {
        if delegate != nil {
            delegate?.sendWith!(text: inputTV.text)
        }
        //发送完清空输入框
        inputTV.text = ""
        textViewDidChange(inputTV)
    }
    
    func calculateTextSizeWith(text: String) {
        //设置最大尺寸
        let maxSize = CGSize(width: self.bounds.size.width - padding - 100, height: 120)
        //计算真实尺寸
        let textSize = text.sizeWithFont(font: messageTextFont, maxSize: maxSize)
        if delegate != nil {
            delegate?.textViewDidChangeWith?(textSize: textSize)
        }
    }
    
    deinit {
        //移除监听
        NotificationCenter.default.removeObserver(self)
    }
}

extension InputTextBar: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //设置发送按钮样式
        sendBtn.isUserInteractionEnabled = textView.text.count > 0
        sendBtn.setTitleColor(textView.text.count > 0 ? UIColor.white : UIColor.lightGray, for: .normal)
        //计算文本尺寸
        calculateTextSizeWith(text: textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //回收按钮收起键盘
        if text == "\n" {
            if delegate != nil {
                delegate?.sendWith!(text: inputTV.text)
            }
            //发送完清空输入框
            inputTV.text = ""
            textViewDidChange(inputTV)
            return false
        }
        
        //限制输入内容长度
        if range.location >= 200 {
            return false
        }
        return true
    }
    
}
