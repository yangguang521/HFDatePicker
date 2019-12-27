//
//  HFUtils.swift
//  DatePicker
//
//  Created by Joe on 12/7/19.
//  Copyright © 2019 yangguang. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

let statusBarHeight = UIApplication.shared.statusBarFrame.size.height

extension UIColor {
    public static func rgbColor(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ alpha:CGFloat = 1.0) -> UIColor {
        let color:UIColor = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
        return color
    }
    
    public static func randomColor() -> UIColor {
        return UIColor(red: randomColorCount(0, 256)/255.0, green: randomColorCount(0, 256)/255.0, blue: randomColorCount(0, 256)/255.0, alpha: 1.0)
    }
    
    public static func randomColorCount(_ startIndex:Int, _ endIndex:Int) -> CGFloat {
        let range = Range<Int>(startIndex...endIndex)
        let count = UInt32(range.upperBound - range.lowerBound)
        let v = Int(arc4random_uniform(count))+range.lowerBound
        return CGFloat(v)
    }
    
    public static func colorWithHexString(_ stringToConvert: String) -> UIColor {
        let scanner = Scanner(string: stringToConvert)
        var hexNum: UInt32 = 0
        guard scanner.scanHexInt32(&hexNum) else {
            return UIColor.red
        }
        return UIColor.colorWithRGBHex(hexNum)
    }
    
    public static func colorWithRGBHex(_ hex: UInt32) -> UIColor {
        let r = (hex >> 16) & 0xFF
        let g = (hex >> 8) & 0xFF
        let b = (hex) & 0xFF
        return UIColor(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: 1.0)
    }
}

extension DateFormatter {
    public func getDateString(date: Date) -> String {
        //改成中文
        //self.locale = Locale(identifier: "zh_CN")
        //self.dateStyle = .medium
        //self.timeStyle = .medium
        self.dateFormat = "yyyy-MM-dd"
        let dateString = self.string(from: date)
        return dateString
    }
    
    public func getDateTime(dateString: String) -> Date {
        self.dateFormat = "yyyy-MM-dd"
        let date = self.date(from: dateString)
        return date ?? Date()
    }
}

extension Date {
    public static func compareTwoDate(startDate: Date, endDate: Date) -> Bool {
        let formatter = DateFormatter()
        let startDateStr = formatter.getDateString(date: startDate)
        let endDateStr = formatter.getDateString(date: endDate)
        let result =  startDateStr.compare(endDateStr)
        switch result {
        case .orderedAscending:
            return true
        case .orderedDescending:
            return false
        case .orderedSame:
            return true
        default:
            return false
        }
    }
}
