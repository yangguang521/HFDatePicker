//
//  DateModel.swift
//  DatePicker
//
//  Created by Joe on 12/17/19.
//  Copyright © 2019 yangguang. All rights reserved.
//

import UIKit

class DateModel: NSObject {
    var yearArray = [YearModel]()
}

class YearModel: NSObject {
    var year = ""
    var monthArray = [MonthModel]()
}

class MonthModel: NSObject {
    var month = ""
    var dayArray = [DayModel]()
}

class DayModel: NSObject {
    var day = ""
}


