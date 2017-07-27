//
//  CommonConstants.swift
//  TheBot
//
//  Created by Daman on 27/07/17.
//  Copyright © 2017 Tarsem. All rights reserved.
//

import UIKit

class CommonConstants: NSObject {

}


extension UITextView{
    
    func placeholder(text: String) -> UILabel{
        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.sizeToFit()
        self.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint.init(x:5, y:self.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor.darkGray
        placeholderLabel.isHidden = !self.text.isEmpty
        return placeholderLabel
    }
}

extension String{
    static func trim(_ string: String?) -> String {
        return string?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
    }
    
    var numericString:String {
        let stringArray = String.trim(self).components(
            separatedBy: CharacterSet.decimalDigits.inverted)
        let newString = stringArray.joined(separator: "")
        return newString
    }
    
    func sizeWithMyFont(font:UIFont, size:CGSize) -> CGSize{
        
        let textRext = (self as NSString).boundingRect(with: CGSize(width: size.width, height: size.height),
                                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                       attributes: [NSFontAttributeName: font],
                                                       context: nil)
        return CGSize.init(width: CGFloat(ceilf(Float(textRext.width))), height: CGFloat(ceilf(Float(textRext.height))))
    }
}

extension DateFormatter {
    convenience init(dateFormat: String, timeZone: TimeZone? = TimeZone.current) {
        self.init()
        self.timeZone = timeZone
        self.dateFormat =  dateFormat
    }
}

extension Date {
    struct Formatter {
        static let timeFormatter = DateFormatter(dateFormat: "hh:mm a")
        static let backendDateFormatter = DateFormatter(dateFormat: "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'", timeZone: TimeZone.init(identifier: "GMT"))
        static let dateTimeFormatter = DateFormatter(dateFormat:"dd MMM yyyy' | 'hh:mm a", timeZone: TimeZone.init(identifier: "GMT"))
        static let gmtToCurrentDateFormatter = DateFormatter(dateFormat: "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'")
    }
    var customFormattedTime: String {
        return Formatter.timeFormatter.string(from: self)
    }
    var customFormattedDate: String {
        return Formatter.dateTimeFormatter.string(from: self)
    }
    var backendFormattedDate: String {
        return Formatter.backendDateFormatter.string(from: self)
    }
    
    func timeAgo(_ numericDates:Bool) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
}

extension String {
    var asDate: Date? {
        return Date.Formatter.backendDateFormatter.date(from: self)
    }
    func asDateFormatted(with dateFormat: String) -> Date? {
        return DateFormatter(dateFormat: dateFormat).date(from: self)
    }
    
    
}
