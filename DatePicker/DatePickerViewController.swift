//
//  DatePickerViewController.swift
//  DatePicker
//
//  Created by Joe on 12/7/19.
//  Copyright © 2019 yangguang. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    //当前选择的日期类型
    var currentIndex = 0
    fileprivate let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        //显示日期选择器
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.showDatePicker()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        //print("当前viewSafeAreaInsetsDidChange")
    }
    
    fileprivate func showDatePicker() {
        switch currentIndex {
        case 0:
            showDatePickerOfYear()
        case 1:
            showDatePickerOfYearMonth()
        case 2:
            showDatePickerOfYearMonthDay()
        default: break
            
        }
    }
    
    fileprivate func showDatePickerOfYear() {
        //年
        let startDate = formatter.getDateTime(dateString: "2007-03-13")
        let datePicker = DatePickerView(type: .year, delegate: self, startDate: startDate, endDate: Date())
        //datePicker.updateOriginDate(startDate: Date(timeIntervalSince1970: 365000000), endDate: Date())
        UIApplication.shared.keyWindow?.addSubview(datePicker)
        datePicker.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    fileprivate func showDatePickerOfYearMonth() {
        //年月
        let startDate = formatter.getDateTime(dateString: "2001-02-03")
        let datePicker = DatePickerView(type: .yearMonth, delegate: self, startDate: startDate, endDate: Date())
        //datePicker.updateOriginDate(startDate: Date(timeIntervalSince1970: 365000000), endDate: Date())
        UIApplication.shared.keyWindow?.addSubview(datePicker)
        datePicker.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    fileprivate func showDatePickerOfYearMonthDay() {
        //年月日
        let startDate = formatter.getDateTime(dateString: "1992-05-25")
        let datePicker = DatePickerView(type: .yearMonthDay, delegate: self, startDate: startDate, endDate: Date())
        //datePicker.updateOriginDate(startDate: Date(timeIntervalSince1970: 365000000), endDate: Date())
        UIApplication.shared.keyWindow?.addSubview(datePicker)
        datePicker.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
//            datePicker.updateOriginDate(startDate: Date(), endDate: Date())
//        }
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

extension DatePickerViewController: DatePickerViewDelegate {
    func datePickerViewDelegateWithCancelAction() {
        print("点击了取消")
    }
    
    func datePickerViewDelegateWithEnsureActionOfSelectDate(selectYear: String, selectMonth: String, selectDay: String) {
        print("点击了确定")
        print("selectYear=\(selectYear)年，selectMonth=\(selectMonth)月，selectDay=\(selectDay)日")
    }
}
