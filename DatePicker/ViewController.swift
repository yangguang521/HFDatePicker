//
//  ViewController.swift
//  DatePicker
//
//  Created by Joe on 2019/11/9.
//  Copyright © 2019 yangguang. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    fileprivate var titleArray = ["年", "年月", "年月日"]
    
    fileprivate var firstTitleArray: [String] {
        return ["iOS实现", "iOS实现控件背景", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色渐变实现方式","iOS实现控件背景", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色", "iOS实现控件背景颜色渐变","iOS实现控件背景", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色", "iOS实现控件背景颜色渐变","iOS实现控件背景", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色", "iOS实现控件背景颜色渐变", "iOS实现控件背景", "iOS实现控件背景颜色渐变"]
    }
    fileprivate var secondTitleArray: [String] {
        return ["iOS实现", "iOS实现控件背景", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色渐变实现方式","iOS实现控件背景", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色", "iOS实现控件背景颜色渐变","iOS实现控件背景", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色", "iOS实现控件背景颜色渐变","iOS实现控件背景", "iOS实现控件背景颜色渐变", "iOS实现控件背景颜色", "iOS实现控件背景颜色渐变", "iOS实现控件背景", "iOS实现控件背景颜色渐变"]
    }
    fileprivate var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { [weak self] (maker) in
            guard let `self` = self else { return }
            maker.edges.equalTo(self.view)
        }
    }
    
    func getTextWidth(text: NSString) -> CGFloat {
        return text.boundingRect(with: CGSize(width: CGFloat.infinity, height: 21), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font:UIFont.systemFont(ofSize: 17)], context: nil).size.width
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pickerController = DatePickerViewController()
        pickerController.currentIndex = indexPath.row
        navigationController?.pushViewController(pickerController, animated: true)
    }
}
