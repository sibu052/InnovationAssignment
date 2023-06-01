
import UIKit

class TaskListController: UIViewController {

    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var tableList: UITableView!
    var taskList = TaskListModel()
    var arrTaskList : [TaskListModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.seuUpUi()
    }
    
    func seuUpUi() {
        viewAdd.dropShadow()
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 0.94)
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arrTaskList = self.taskList.fetchAllTaskList()
        self.arrTaskList = self.taskList.getSortedTimeTime(arrTaskList: self.arrTaskList)
        self.heightTable.constant = CGFloat(self.arrTaskList.count * 75)
        self.tableList.reloadData()
    }

    @IBAction func clickAdd(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTaskController") as? AddTaskController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
