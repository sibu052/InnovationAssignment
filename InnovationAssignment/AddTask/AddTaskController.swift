
import UIKit
import DropDown

class AddTaskController: UIViewController {
    @IBOutlet weak var viewTaskTitle: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewAmPm: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAMPm: UILabel!
    @IBOutlet weak var txtTaskName: UITextField!

    let dropTime = DropDown()
    let dropDownAmPm = DropDown()
    let taskListModel = TaskListModel()
    let arrTime = ["1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00"]
    let arrAmPm = ["AM","PM"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
    }
    
    func setUpUi() {
        self.title = "Add Task"
        self.lblTime.text = "7:00"
        self.lblAMPm.text = "PM"
        self.viewTaskTitle.layer.borderColor = UIColor.black.cgColor
        self.viewTaskTitle.layer.borderWidth = 1
        self.viewTime.layer.borderColor = UIColor.black.cgColor
        self.viewTime.layer.borderWidth = 1
        self.viewAmPm.layer.borderColor = UIColor.black.cgColor
        self.viewAmPm.layer.borderWidth = 1
        self.btnCancel.backgroundColor = .clear
        self.btnCancel.layer.cornerRadius = 15
        self.btnCancel.layer.borderWidth = 1
        self.btnCancel.layer.borderColor = UIColor.black.cgColor
        self.btnAdd.layer.cornerRadius = 15
        let tapTime = UITapGestureRecognizer(target: self, action: #selector(self.handleTapForTime(_:)))
        self.viewTime.addGestureRecognizer(tapTime)
        let tapViewAMPM = UITapGestureRecognizer(target: self, action: #selector(self.handleTapForTimeAMPM(_:)))
        self.viewAmPm.addGestureRecognizer(tapViewAMPM)
    }
    
    @objc func handleTapForTime(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.timeDropDown(view: self.dropTime)
    }
    
    @objc func handleTapForTimeAMPM(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.timeAMPMDropDown(view: self.dropTime)
    }
    
    private func timeDropDown(view: UIView) {
        let dropDown = DropDown()
        dropDown.anchorView = self.viewTime
        dropDown.bottomOffset = CGPoint(x: 0, y: self.viewTime.frame.size.height)
        dropDown.width = self.viewTime.frame.size.width
        dropDown.dataSource = self.arrTime
            dropDown.selectionAction = { [weak self] (index, item) in
                self?.lblTime.text = item
            }
            dropDown.textColor = .black
            dropDown.backgroundColor = .white
            dropDown.show()
    }
    
    private func timeAMPMDropDown(view: UIView) {
        let dropDown = DropDown()
        dropDown.anchorView = self.viewAmPm
        dropDown.bottomOffset = CGPoint(x: 0, y: self.viewAmPm.frame.size.height)
        dropDown.width = self.viewAmPm.frame.size.width
        dropDown.dataSource = self.arrAmPm
            dropDown.selectionAction = { [weak self] (index, item) in
                self?.lblAMPm.text = item
            }
            dropDown.textColor = .black
            dropDown.backgroundColor = .white
            dropDown.show()
    }
    
    @IBAction func clickAdd(_ sender: Any) {
        if self.txtTaskName.text == "" {
            let alertController = UIAlertController(title: "", message: "Please enter task title", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default) { action in
            }
            alertController.addAction(actionOk)
            self.present(alertController, animated: true)
        }
        else {
            let objTaskListModel = TaskListModel()
            objTaskListModel.taskStatus = "N"
            objTaskListModel.taskTime = "\(self.lblTime.text ?? "") \(self.lblAMPm.text ?? "")"
            objTaskListModel.taskName = self.txtTaskName.text ?? ""
            let arrTaskList = self.taskListModel.fetchAllTaskList()
            let count = (arrTaskList.count == 0) ? 1 : (Int(arrTaskList.last?.id ?? "0") ?? 0) + 1
            objTaskListModel.id = "\(count)"
            self.taskListModel.insertTask(objTaskListModel)
            self.navigationController?.popViewController(animated: true)

        }
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
