import Foundation
import UIKit

extension TaskListController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        self.tableList.layer.borderColor = UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 0.94).cgColor
        self.tableList.layer.borderWidth = 0.5
        self.tableList.delegate = self
        self.tableList.dataSource = self
        self.tableList.rowHeight = UITableView.automaticDimension
        self.tableList.estimatedRowHeight =  85
        self.tableList.separatorStyle = .none
        self.tableList.backgroundColor = .clear
        self.tableList.register(TaskTableviewCell.nib, forCellReuseIdentifier: TaskTableviewCell.identifier)
    }
    
    private func reloadTable() {
        UIView.performWithoutAnimation {
            self.tableList.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: Int = 0
        
        if self.arrTaskList.count > 0 {
            self.tableList.backgroundView = nil
            numOfSection = 1
        }
        else
        {
            self.heightTable.constant = 100.0
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableList.bounds.size.width, self.tableList.bounds.size.height))
            noDataLabel.text = "Empty Task List"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableList.backgroundView = noDataLabel
        }
        return numOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableviewCell.identifier, for: indexPath) as! TaskTableviewCell
        let objTaskList = self.arrTaskList[indexPath.row]
        cell.setData(objTaskListModel: objTaskList)
        cell.btnCrossAction = { () in
            let alertController = UIAlertController(title: "Warning", message: "Do you want to delete \"\(objTaskList.taskName)\", this action can’t be undone."
                                                    , preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default) { action in
                self.taskList.deleteRecordFromDatabaseForId(id: objTaskList.id)
                self.arrTaskList = self.taskList.fetchAllTaskList()
                self.arrTaskList = self.taskList.getSortedTimeTime(arrTaskList: self.arrTaskList)
                self.heightTable.constant = CGFloat(self.arrTaskList.count * 75)
                self.tableList.reloadData()
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                // "String with \"Double Quotes\""
            }
            alertController.addAction(actionOk)
            alertController.addAction(actionCancel)
            self.present(alertController, animated: true)
        }
        cell.btnCheckboxAction = { () in
            if objTaskList.taskStatus == "P"{
                
            }else if objTaskList.taskStatus == "N"{
                self.taskList.updateFollowedPatient(id: objTaskList.id, taskStatus: "C")
                self.arrTaskList = self.taskList.fetchAllTaskList()
                self.arrTaskList = self.taskList.getSortedTimeTime(arrTaskList: self.arrTaskList)
                self.tableList.reloadData()
            }else{
                self.taskList.updateFollowedPatient(id: objTaskList.id, taskStatus: "N")
                self.arrTaskList = self.taskList.fetchAllTaskList()
                self.arrTaskList = self.taskList.getSortedTimeTime(arrTaskList: self.arrTaskList)
                self.tableList.reloadData()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}


extension UIView {
    
    func dropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }
}
extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482458385
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                
                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}
