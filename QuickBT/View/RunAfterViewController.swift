//
//  RunAfterViewController.swift
//  QuickBT
//
//  Created by Jesse Zhu on 2018/03/19.
//  Copyright © 2018 Jesse Zhu. All rights reserved.
//

import UIKit

class RunAfterViewController: UITableViewController {
    private let config = UserDefaults.standard
    private let runAfterCommandByIndex = [
        "PlayMusic",
        "Exit"
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建一个重用的单元格
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "commandCell")
        //去除尾部多余的空行
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        //设置分区头部字体颜色和大小
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .textColor = UIColor.gray
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.medium)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RunAfterCommand.allCommands.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //用重用的方式获取标识为bluetoothCell的cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "commandCell",
                                                 for: indexPath)
        cell.textLabel?.text = RunAfterCommand.allCommands[indexPath.row].rawValue
            
        let savedCommand = UserSettings.RunAfterCommand.object() ?? "";
        if (RunAfterCommand.getCommandByString(value: savedCommand as! String) == RunAfterCommand.allCommands[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell:UITableViewCell! = tableView.cellForRow(at: indexPath)
        
        var arry = tableView.visibleCells
        for i in 0 ..< arry.count {
            let cells: UITableViewCell = arry[i]
            cells.accessoryType = .none
        }
        cell.accessoryType = .checkmark
        print(runAfterCommandByIndex[indexPath.row])
        UserSettings.RunAfterCommand.set(value: runAfterCommandByIndex[indexPath.row]);
    }

}
