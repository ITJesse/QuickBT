//
//  TableViewController.swift
//  QuickBT
//
//  Created by Jesse Zhu on 2018/03/17.
//  Copyright © 2018 Jesse Zhu. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController, QuickBTDelegate {
    
    private let quickBT = QuickBT.sharedInstance
    private let config = UserDefaults.standard
    @IBOutlet weak var autoConnectSwitch: UISwitch!
    @IBOutlet weak var scanSwitch: UISwitch!
    @IBOutlet weak var runAfterCommandLabel: UILabel!
    
    
    func receivedQuickBTNotification(notification: QuickBTNotification) {
        print("BeeTeeNotification: " + String(describing: notification))
        switch notification {
        case .DeviceDiscovered:
            tableView.reloadData()
            let savedAddress = UserSettings.AutoConnectAddress.object() as? String ?? ""
            if let i = quickBT.availableDevices.index(where: { $0.address == savedAddress }) {
                self.connect(deviceIndex: i)
            }
            break
        case .DeviceRemoved,
             .DeviceUpdated:
            tableView.reloadData()
            break
        case .DiscoveryStateChanged:
            scanSwitch.setOn(self.quickBT.isScanning(), animated: true)
            break
        case .DeviceConnectSuccess:
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quickBT.delegate = self

        self.autoConnectSwitch.setOn(UserSettings.AutoConnect.bool(), animated: false)
        //创建一个重用的单元格
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "bluetoothCell")
        //去除尾部多余的空行
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        //设置分区头部字体颜色和大小
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .textColor = UIColor.gray
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.medium)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let savedCommand = UserSettings.RunAfterCommand.object() ?? "Exit";
        let command = RunAfterCommand.getCommandByString(value: savedCommand as! String).rawValue
        self.runAfterCommandLabel.text = command
    }
    
    //返回分区数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //返回每个分区中单元格的数量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            if section == 1 {
                return quickBT.availableDevices.count
            }else{
                return 3
            }
    }
    
    //设置cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            //只有第二个分区是动态的，其它默认
            if indexPath.section == 1 {
                //用重用的方式获取标识为bluetoothCell的cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell",
                                                         for: indexPath)
                cell.textLabel?.text = quickBT.availableDevices[indexPath.row].name
                cell.accessoryType = .detailButton
                return cell
            }else{
                return super.tableView(tableView, cellForRowAt: indexPath)
            }
    }
    
    //因为第二个分区单元格动态添加，会引起cell高度的变化，所以要重新设置
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 44
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    //当覆盖了静态的cell数据源方法时需要提供一个代理方法。
    //因为数据源对新加进来的cell一无所知，所以要使用这个代理方法
    override func tableView(_ tableView: UITableView,
                            indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 1{
            //当执行到日期选择器所在的indexPath就创建一个indexPath然后强插
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }else{
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
           self.connect(deviceIndex: indexPath.row)
        }
    }
    
    private func connect(deviceIndex: Int) {
        quickBT.stopScanForDevices()
        let indexPath = IndexPath(row: deviceIndex, section: 1)
        let cell:UITableViewCell! = tableView.cellForRow(at: indexPath)
        let spinner:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        spinner.frame = CGRect(x:0, y:0, width:24, height:24)
        cell.accessoryView = spinner;
        spinner.startAnimating()
        let deviceInfo = quickBT.availableDevices[indexPath.row];
        deviceInfo.device?.connect()
        if (self.autoConnectSwitch.isOn) {
            UserSettings.AutoConnectAddress.set(value: deviceInfo.address)
        }
    }
    
    @IBAction func onAutoConnectSwitchChange(_ sender: UISwitch) {
        print("here", sender)
        UserSettings.AutoConnect.set(value: sender.isOn)
    }
    
    @IBAction func onScanSwitchChange(_ sender: UISwitch) {
        if (sender.isOn) {
            quickBT.startScanForDevices()
        } else {
            quickBT.stopScanForDevices()
        }
    }
}
