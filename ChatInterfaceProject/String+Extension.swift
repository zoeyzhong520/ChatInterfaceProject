//
//  String+Extension.swift
//  ChatInterfaceProject
//
//  Created by zhifu360 on 2019/5/14.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

extension String {
    
    ///计算文本尺寸
    func sizeWithFont(font: UIFont, maxSize: CGSize) -> CGSize {
        
        let attrs = [NSAttributedString.Key.font: font]
        return (self as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil).size
        
    }
    
}
