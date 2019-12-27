//
//  DatePickerView.swift
//  DatePicker
//
//  Created by Joe on 12/3/19.
//  Copyright © 2019 yangguang. All rights reserved.
//

import UIKit

enum DatePickerType {
    case year  //年
    case yearMonth  //年月
    case yearMonthDay  //年月日
}

//MARK: - DatePickerViewDelegate
protocol DatePickerViewDelegate {
    //取消
    func datePickerViewDelegateWithCancelAction()
    //确定
    func datePickerViewDelegateWithEnsureActionOfSelectDate(selectYear: String, selectMonth: String, selectDay: String)
}

class DatePickerView: UIView {
    //delegate
    fileprivate var pickerDelegate: DatePickerViewDelegate?
    //日期类型
    fileprivate var pickerType = DatePickerType.year
    //日期model
    fileprivate let dateModel = DateModel()
    //起始日期 默认当前时间
    fileprivate var beginComponents: DateComponents = Calendar.current.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: Date())
    //结束日期 默认当前时间
    fileprivate var endComponents: DateComponents = Calendar.current.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: Date())
    //总高度50+230+底部安全区域高度
    fileprivate let totalHeight = 280 + (statusBarHeight == 44 ? 34:0)
    
    //日期PickerView
    fileprivate let bottomPicker = UIPickerView()
    //日期视图View
    fileprivate let dateContentView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    //工具栏View
    fileprivate let topToolView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    //取消
    fileprivate let cancelButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.colorWithRGBHex(0x999999), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    //确定
    fileprivate let ensureButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.colorWithRGBHex(0xFD5E5E), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    init(type: DatePickerType, delegate: DatePickerViewDelegate, startDate: Date, endDate: Date) {
        super.init(frame: .zero)
        pickerType = type
        pickerDelegate = delegate
        setUpSubViews()
        updateOriginDate(startDate: startDate, endDate: endDate)
    }
    
    init(frame: CGRect, type: DatePickerType, delegate: DatePickerViewDelegate, startDate: Date, endDate: Date) {
        super.init(frame: frame)
        pickerType = type
        pickerDelegate = delegate
        setUpSubViews()
        updateOriginDate(startDate: startDate, endDate: endDate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpSubViews() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        //ContentView
        setUpContentView()
        setUpToolView()
        setUpPickerView()
        //showAnimation
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            self.showPickerViewWithAnimation()
        }
    }
    
    fileprivate func setUpContentView() {
        self.addSubview(dateContentView)
        dateContentView.snp.makeConstraints { [weak self] (maker) in
            guard let `self` = self else { return }
            maker.bottom.equalTo(self.snp.bottom).offset(totalHeight)
            maker.left.right.equalTo(self)
            maker.height.equalTo(totalHeight)
        }
    }
    
    fileprivate func setUpToolView() {
        dateContentView.addSubview(topToolView)
        topToolView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(dateContentView)
            maker.height.equalTo(50)
        }
        //取消
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        topToolView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(topToolView)
            maker.left.equalTo(topToolView.snp.left).offset(10)
            maker.width.greaterThanOrEqualTo(30)
        }
        //确定
        ensureButton.addTarget(self, action: #selector(ensureButtonClick), for: .touchUpInside)
        topToolView.addSubview(ensureButton)
        ensureButton.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(topToolView)
            maker.right.equalTo(topToolView.snp.right).offset(-10)
            maker.width.greaterThanOrEqualTo(30)
        }
        //请选择日期
        let titleLabel = UILabel()
        titleLabel.text = "请选择日期"
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        topToolView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.center.equalTo(topToolView.snp.center)
            maker.height.equalTo(20)
        }
    }
    
    fileprivate func setUpPickerView() {
        bottomPicker.delegate = self
        bottomPicker.dataSource = self
        dateContentView.addSubview(bottomPicker)
        bottomPicker.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(dateContentView)
            maker.top.equalTo(topToolView.snp.bottom)
            maker.height.equalTo(230)
        }
    }
    
    //MARK: - 取消
    @objc fileprivate func cancelButtonClick() {
        dismissPickerViewWithAnimation()
        pickerDelegate?.datePickerViewDelegateWithCancelAction()
    }
    
    //MARK: - 确定
    @objc fileprivate func ensureButtonClick() {
        dismissPickerViewWithAnimation()
        //selectDate
        var selectYear = ""
        var selectMonth = ""
        var selectDay = ""
        if pickerType == .year {
            let yearRow = bottomPicker.selectedRow(inComponent: 0)
            selectYear = dateModel.yearArray[yearRow].year
        }else if pickerType == .yearMonth {
            let yearRow = bottomPicker.selectedRow(inComponent: 0)
            let monthRow = bottomPicker.selectedRow(inComponent: 1)
            selectYear = dateModel.yearArray[yearRow].year
            selectMonth = dateModel.yearArray[yearRow].monthArray[monthRow].month
        }else if pickerType == .yearMonthDay {
            let yearRow = bottomPicker.selectedRow(inComponent: 0)
            let monthRow = bottomPicker.selectedRow(inComponent: 1)
            let dayRow = bottomPicker.selectedRow(inComponent: 2)
            selectYear = dateModel.yearArray[yearRow].year
            selectMonth = dateModel.yearArray[yearRow].monthArray[monthRow].month
            selectDay = dateModel.yearArray[yearRow].monthArray[monthRow].dayArray[dayRow].day
        }
        pickerDelegate?.datePickerViewDelegateWithEnsureActionOfSelectDate(selectYear: selectYear, selectMonth: selectMonth, selectDay: selectDay)
    }
    
    //MARK: - 显示PickerView
    func showPickerViewWithAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.dateContentView.snp.updateConstraints { [weak self] (maker) in
                guard let `self` = self else { return }
                maker.bottom.equalTo(self.snp.bottom)
            }
            self.layoutIfNeeded()
        }) { (isFinished) in
            
        }
    }
    
    //MARK: - 隐藏并移除PickerView
    func dismissPickerViewWithAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.dateContentView.snp.updateConstraints { [weak self] (maker) in
                guard let `self` = self else { return }
                maker.bottom.equalTo(self.snp.bottom).offset(self.totalHeight)
            }
            self.layoutIfNeeded()
        }) { (isFinished) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - 设置选中的日期,不设置默认选中结束日期
    func updateSelectDate(selectDate: Date) {
        let currentCalendar = Calendar.current
        let selectComponents = currentCalendar.dateComponents(in: TimeZone.current, from: selectDate)
        if pickerType == .year {
            //年
            
            //bottomPicker.selectRow(<#T##row: Int##Int#>, inComponent: 0, animated: true)
        }else if pickerType == .yearMonth {
            //年月
            
            //bottomPicker.selectRow(<#T##row: Int##Int#>, inComponent: 0, animated: true)
            //bottomPicker.selectRow(<#T##row: Int##Int#>, inComponent: 1, animated: true)
        }else if pickerType == .yearMonthDay {
            //年月日
            
            //bottomPicker.selectRow(<#T##row: Int##Int#>, inComponent: 0, animated: true)
            //bottomPicker.selectRow(<#T##row: Int##Int#>, inComponent: 1, animated: true)
            //bottomPicker.selectRow(<#T##row: Int##Int#>, inComponent: 2, animated: true)
        }
    }
    
    //MARK: - 输入起始日期
    func updateOriginDate(startDate: Date, endDate: Date) {
        //比较二个日期的大小
        let result =  Date.compareTwoDate(startDate: startDate, endDate: endDate)
        if !result {
            print("起期不能大于止期！")
            return
        }
        //清除更新日期之前的数据
        if dateModel.yearArray.count > 0 {
            dateModel.yearArray.removeAll()
        }
        //获取当前的Calendar(用于作为转换Date和DateComponents的桥梁)
        let currentCalendar = Calendar.current
        //使用（时区）重载函数进行转换
        beginComponents = currentCalendar.dateComponents(in: TimeZone.current, from: startDate)
        endComponents = currentCalendar.dateComponents(in: TimeZone.current, from: endDate)
        
        //使用另一个重载函数进行转换（第一个参数给一个Set集合对象）
        //beginComponents = currentCalendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: startDate)
        //endComponents = currentCalendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: endDate)
        //guard let startComponent = beginComponents else { return print("开始日期不能为空！") }
        //guard let lastComponent = endComponents else { return print("结束日期不能为空！") }
        
        if pickerType == .year {
            //年
            handleYearType()
        }else if pickerType == .yearMonth {
            //年月
            handleYearMonthType()
        }else if pickerType == .yearMonthDay {
            //年月日
            handleYearMonthDayType()
        }
    }
    
    //MARK: - 年类型的数据
    fileprivate func handleYearType() {
        guard let startYear = beginComponents.year else { return print("开始年份不能为空！") }
        guard let lastYear = endComponents.year else { return print("结束年份不能为空！") }
        
        for year in startYear...lastYear {
            let yearModel = YearModel()
            yearModel.year = "\(year)"
            dateModel.yearArray.append(yearModel)
        }
        bottomPicker.reloadAllComponents()
    }
    
    //MARK: - 年月类型的数据
    fileprivate func handleYearMonthType() {
        guard let startYear = beginComponents.year else { return print("开始年份不能为空！") }
        guard let lastYear = endComponents.year else { return print("结束年份不能为空！") }
        //第一年的月份和最后一年的月份
        guard let startMonth = beginComponents.month else { return print("开始月份不能为空！") }
        guard let lastMonth = endComponents.month else { return print("结束月份不能为空！") }
        
        //遍历年
        for year in startYear...lastYear {
            let yearModel = YearModel()
            yearModel.year = "\(year)"
            //遍历月
            let minMonth = year == startYear ? startMonth:1
            let maxMonth = year == lastYear ? lastMonth:12
            for month in minMonth...maxMonth {
                let monthModel = MonthModel()
                monthModel.month = "\(month)"
                yearModel.monthArray.append(monthModel)
            }
            dateModel.yearArray.append(yearModel)
        }
        bottomPicker.reloadAllComponents()
    }
    
    //MARK: - 年月日类型的数据
    fileprivate func handleYearMonthDayType() {
        guard let startYear = beginComponents.year else { return print("开始年份不能为空！") }
        guard let lastYear = endComponents.year else { return print("结束年份不能为空！") }
        //第一年的月份和最后一年的月份
        guard let startMonth = beginComponents.month else { return print("开始月份不能为空！") }
        guard let lastMonth = endComponents.month else { return print("结束月份不能为空！") }
        //第一年的天和最后一年的天
        guard let startDay = beginComponents.day else { return print("开始日期不能为空！") }
        guard let lastDay = endComponents.day else { return print("结束日期不能为空！") }
        
        //遍历年
        for year in startYear...lastYear {
            let yearModel = YearModel()
            yearModel.year = "\(year)"
            //遍历月
            let minMonth = year == startYear ? startMonth:1
            let maxMonth = year == lastYear ? lastMonth:12
            for month in minMonth...maxMonth {
                let monthModel = MonthModel()
                monthModel.month = "\(month)"
                //遍历日
                let minDay = year == startYear && month == startMonth ? startDay:1
                let maxDay = year == lastYear && month == lastMonth ? lastDay:getOneMonthInMaxDay(year: year, month: month)
                for day in minDay...maxDay {
                    let dayModel = DayModel()
                    dayModel.day = "\(day)"
                    monthModel.dayArray.append(dayModel)
                }
                yearModel.monthArray.append(monthModel)
            }
            dateModel.yearArray.append(yearModel)
        }
        bottomPicker.reloadAllComponents()
    }
    
    //MARK: - 一个月中最大的日期
    fileprivate func getOneMonthInMaxDay(year: Int, month: Int) -> Int {
        switch month {
        case 1,3,5,7,8,10,12:
            return 31
        case 4,6,9,11:
            return 30
        case 2:
            return year%4 == 0 ? 29:28
        default:
            return 0
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

extension DatePickerView: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerType == .year {
            return 1
        }else if pickerType == .yearMonth {
            return 2
        }else if pickerType == .yearMonthDay {
            return 3
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dateModel.yearArray.count
        }else if component == 1 {
            let yearRow = pickerView.selectedRow(inComponent: 0)
            let yearModel = dateModel.yearArray[yearRow]
            return yearModel.monthArray.count
        }else if component == 2 {
            let yearRow = pickerView.selectedRow(inComponent: 0)
            let monthRow = pickerView.selectedRow(inComponent: 1)
            let yearModel = dateModel.yearArray[yearRow]
            let monthModel = yearModel.monthArray[monthRow]
            return monthModel.dayArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return kScreenWidth/3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let yearModel = dateModel.yearArray[row]
            return "\(yearModel.year)年"
        }else if component == 1 {
            let yearRow = pickerView.selectedRow(inComponent: 0)
            let yearModel = dateModel.yearArray[yearRow]
            let monthModel = yearModel.monthArray[row]
            return "\(monthModel.month)月"
        }else if component == 2 {
            let yearRow = pickerView.selectedRow(inComponent: 0)
            let monthRow = pickerView.selectedRow(inComponent: 1)
            let yearModel = dateModel.yearArray[yearRow]
            let monthModel = yearModel.monthArray[monthRow]
            let dayModel = monthModel.dayArray[row]
            return "\(dayModel.day)日"
        }
        return ""
    }
    
    /*
     func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
     return nil
     }
     
     func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
     return nil
     }
     */
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("didSelectRow--\(component)--\(row)")
        DispatchQueue.main.async {
            pickerView.reloadAllComponents()
            if self.pickerType == .year {
                
            }else if self.pickerType == .yearMonth {
                if component == 0 {
                    pickerView.reloadComponent(1)
                }
            }else if self.pickerType == .yearMonthDay {
                if component == 0 {
                    pickerView.reloadComponent(1)
                    DispatchQueue.main.async {
                        pickerView.reloadComponent(2)
                    }
                }else if component == 1 {
                    pickerView.reloadComponent(2)
                }
            }
        }
    }
}
