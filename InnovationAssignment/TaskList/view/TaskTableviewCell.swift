
import UIKit

class TaskTableviewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    var btnCrossAction: (() -> Void)?
    var btnCheckboxAction: (() -> Void)?

    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickCheckBox(_ sender: Any) {
        self.btnCheckboxAction?()
    }
    
    func setData(objTaskListModel: TaskListModel){
        
        self.lblTime.text = objTaskListModel.taskTime
        self.lblTime.textColor = colorWithHexString(hexString: "161717", alpha: 0.50)

        if objTaskListModel.taskStatus == "N" {
            self.lblStatus.isHidden = true
            self.btnCheckBox.isSelected = false
            self.btnCheckBox.isUserInteractionEnabled = true
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(objTaskListModel.taskName)")
            self.lblTitle.attributedText = attributeString
            self.lblTitle.textColor = colorWithHexString(hexString: "161717")

        }else if objTaskListModel.taskStatus == "C"{
            self.lblStatus.isHidden = true
            self.btnCheckBox.isSelected = true
            self.btnCheckBox.isUserInteractionEnabled = true
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(objTaskListModel.taskName)")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            self.lblTitle.attributedText = attributeString
            self.lblTitle.textColor = colorWithHexString(hexString: "161717")

        }else{
            self.lblStatus.isHidden = false
            self.btnCheckBox.isSelected = false
            self.btnCheckBox.isUserInteractionEnabled = false
            self.lblStatus.text = "pending"
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(objTaskListModel.taskName)")
            self.lblTitle.attributedText = attributeString
            self.lblTitle.textColor = colorWithHexString(hexString: "EF0000")
            self.lblStatus.textColor = colorWithHexString(hexString: "000000", alpha: 0.45)


        }
    }
    
    
    func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {

            // Convert hex string to an integer
            let hexint = Int(self.intFromHexString(hexStr: hexString))
            let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
            let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
            let blue = CGFloat((hexint & 0xff) >> 0) / 255.0

            // Create color object, specifying alpha as well
            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            return color
        }
    
    func intFromHexString(hexStr: String) -> UInt32 {
           var hexInt: UInt32 = 0
           // Create scanner
           let scanner: Scanner = Scanner(string: hexStr)
           // Tell scanner to skip the # character
           scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
           // Scan hex value
           hexInt = UInt32(bitPattern: scanner.scanInt32(representation: .hexadecimal) ?? 0)
           return hexInt
       }
    
    @IBAction func clickCross(_ sender: Any) {
        self.btnCrossAction?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
