//
//  ActionSheetView.swift
//
//  Created by Md. Mehedi Hasan on 19/5/21.


import UIKit

protocol ActionSheetProtocol {
    var itemIndex: Int { get }
    var title: String { get }
    var imageName: String? { get }
    var isEnabled: Bool { get }
    ///provide value to show, else set nil for hiding it
    var isSwitch: Bool? { get set }
}

struct ActionSheetModel: ActionSheetProtocol {
    
    var itemIndex: Int
    
    var title: String
    
    var isEnabled: Bool
    
    var imageName: String?
    
    var isSwitch: Bool?
}

//enum ActionSheetSelectionStyle {
//    case single
//    case multiple
//}

//class PrepaidReceiptModalView: UIView, Modal {
class ActionSheetView: UIView, ActionSheetable {
    
    var dismissCallback: (() -> Void)?
   
    var bottomLayoutConstraint: NSLayoutConstraint!
    
    var backgroundView: UIView {
        return self
    }
    
    internal lazy var actionSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Color.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saferAreaBottomView: BaseView = BaseView.with {
        $0.backgroundColor = Theme.Color.background
    }
    
    private lazy var closeButton: BaseButton = BaseButton.with {
        $0.setImage(UIImage(named: "icon_close"), for: .normal)
        $0.tintColor = Theme.Color.label
        $0.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    lazy var logoImageView: BaseImageView = BaseImageView.with { _ in
    }
    
    private lazy var titleLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.bold.withSize(17.0.dynamic)
        $0.textColor = Theme.Color.labelSecondary
        $0.textAlignment = .left
        $0.minimumScaleFactor = 0.6
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var tableView: BaseTableView = BaseTableView.with {
        //let tableView = UITableView(frame: .zero, style: .grouped)
        //        let leastRect = CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude))
        //        tableView.tableHeaderView = UIView(frame: leastRect)
        //        tableView.tableFooterView = UIView(frame: leastRect)
        //$0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.register(ActionSheetViewCell.self)
        $0.alwaysBounceVertical = false
        //$0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12.0, right: 0)
        //$0.rowHeight = UITableView.automaticDimension
        //$0.estimatedRowHeight = 56.0.dynamic
    }
    
    var rowHeight: CGFloat {
        return 52.0
    }
    
    var sectionHeight: CGFloat {
        return 1.0
    }
    
    var actionSheetViewHeight: CGFloat {
        
        let adjustedHeight: CGFloat = 86.0
        let sectionCount = 1
        let rowCount: Int = options.count
        
        let totalHeight = adjustedHeight + sectionHeight * CGFloat(sectionCount) + rowHeight * CGFloat(rowCount)
        return totalHeight > maxContainerHeight ? maxContainerHeight : totalHeight
    }
    
    var eventCallback: ((_ itemIndex: Int) -> Void)?
    var switchCallback: ((_ itemIndex: Int, _ value: Bool) -> Bool)?
    
    
    private let title: String
    private let titleImage: UIImage?
    private let options: [ActionSheetProtocol]
    private var maxContainerHeight: CGFloat
    
    init(title: String, titleImage: UIImage? = nil, options: [ActionSheetProtocol], maxHeight: CGFloat) {
        self.title = title
        self.titleImage = titleImage
        self.options = options
        self.maxContainerHeight = maxHeight
        //self.viewController = viewController
        super.init(frame: UIScreen.main.bounds)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("TransactionActionSheetView deinit")
    }
    
    private func setupView() {
        self.backgroundColor = Theme.Color.backgroundOpaque
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(actionSheetView)
        addSubview(saferAreaBottomView)
        
        actionSheetView.addSubview(closeButton)
        actionSheetView.addSubview(titleLabel)
        actionSheetView.addSubview(tableView)
        if titleImage != nil {
            actionSheetView.addSubview(logoImageView)
            logoImageView.image = titleImage
        }
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: actionSheetViewHeight)
        actionSheetView.roundTopCorners(radius: 12.0.dynamic, frame: frame)

        titleLabel.text = title
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        tap.cancelsTouchesInView = true
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    func setupLayout() {
        
        actionSheetView.heightAnchor == actionSheetViewHeight
        actionSheetView.horizontalAnchors == horizontalAnchors
        bottomLayoutConstraint = actionSheetView.bottomAnchor == saferAreaLayoutGuide.bottomAnchor + actionSheetViewHeight
        
        saferAreaBottomView.topAnchor == saferAreaLayoutGuide.bottomAnchor
        saferAreaBottomView.horizontalAnchors == horizontalAnchors
        saferAreaBottomView.bottomAnchor == bottomAnchor
        
        if titleImage != nil {
            logoImageView.topAnchor == actionSheetView.topAnchor + 24.0.dynamic
            logoImageView.leftAnchor == actionSheetView.leftAnchor + 20.0.dynamic
            logoImageView.heightAnchor == 32.0.dynamic
            logoImageView.widthAnchor == 32.0.dynamic
            
            titleLabel.centerYAnchor == logoImageView.centerYAnchor
            titleLabel.leftAnchor == logoImageView.rightAnchor + 6.0.dynamic
        } else {
            titleLabel.topAnchor == actionSheetView.topAnchor + 24.0.dynamic
            titleLabel.leftAnchor == actionSheetView.leftAnchor + 24.0.dynamic
        }
        

        
        //closeButton.topAnchor == actionSheetView.topAnchor + 16.0.dynamic
        closeButton.centerYAnchor == titleLabel.centerYAnchor
        closeButton.leftAnchor == titleLabel.rightAnchor + 8.0.dynamic
        closeButton.rightAnchor == actionSheetView.rightAnchor - 16.0.dynamic
        closeButton.heightAnchor == 32.0.dynamic
        closeButton.widthAnchor == 32.0.dynamic
        
        tableView.topAnchor == titleLabel.bottomAnchor + 24.0.dynamic
        tableView.horizontalAnchors == actionSheetView.horizontalAnchors
        tableView.bottomAnchor == actionSheetView.bottomAnchor
        
    }
    
    
    //MARK:- ACTION
    @objc func backgroundViewTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func closeButtonTapped() {
        //actionEventCallback?(.close)
        dismiss(animated: true)
    }
    
    //MARK:- Helpers
    func getCellRect(for rowIndex: Int) -> CGRect? {
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let rectOfCell = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperView = tableView.convert(rectOfCell, to: tableView.superview?.superview)
        return rectOfCellInSuperView
        //return tableView.cellForRow(at: IndexPath(row: rowIndex, section: 0))
    }
    
}

extension ActionSheetView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if let touchedView = touch.view, touchedView.isDescendant(of: actionSheetView) {
            return false
        }
        
        return touch.view == gestureRecognizer.view
    }
}

extension ActionSheetView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ActionSheetViewCell
        if let option = options[safe: indexPath.row] {
            
            cell.configure(title: option.title, titleImage: option.imageName, switchChecked: option.isSwitch, isEnabled: option.isEnabled,
                           indexPath: indexPath)
            { [weak self] (cellIndexPath, switchValue) in
                let success = self?.switchCallback?(option.itemIndex, switchValue)
                if success == false {
                    //revert back to previous switchValue
                    if let actionSheetViewCell = self?.tableView.cellForRow(at: cellIndexPath) as? ActionSheetViewCell {
                        actionSheetViewCell.changeSwitchValue(!switchValue, animated: false)
                    }
                }
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let option = options[safe: indexPath.row] {
            // if option has switch then don't dismiss
            if option.isSwitch == nil, option.isEnabled {
                eventCallback?(option.itemIndex)
                dismiss(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let view = UIView()
    //        view.backgroundColor = .clear
    //        return view
    //    }
}
