//
//  TableInputView.swift
//
//  Created by Md. Mehedi Hasan on 28/6/21.
//

import UIKit

class TableInputView<T>: UIView, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: BaseTableView = BaseTableView.with {
        
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.register(ActionSheetSelectCell.self)
        //$0.alwaysBounceVertical = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        //$0.estimatedRowHeight = 44
        //$0.rowHeight = UITableView.automaticDimension
        $0.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 8.0, right: 0)
    }
    
    var items: (() -> [T]) = { return [] }
    var didSelect: ((T) -> Void)?
    var text: ((T) -> String) = { _ in return "" }
    var contains: ((T) -> Bool) = {_ in return false }
    var font: UIFont = .systemFont(ofSize: 15)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        tableView.frame = bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    required init(
        items: @escaping (() -> [T]) = { return [] },
        didSelect: ((T) -> Void)? = nil,
        text: @escaping ((T) -> String) = { _ in return "" },
        contains: @escaping ((T) -> Bool) = {_ in return false },
        height: CGFloat,
        font: UIFont = .systemFont(ofSize: 15)
    ) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        self.items = items
        self.didSelect = didSelect
        self.text = text
        self.contains = contains
        self.font = font
        translatesAutoresizingMaskIntoConstraints = false


        addSubview(tableView)
        tableView.edgeAnchors == edgeAnchors
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ActionSheetSelectCell
//        if let option = options[safe: indexPath.row] {

//        }
    
        let currentText = items()[indexPath.row]
        let title = text(currentText)
        let selected = contains(currentText)
        
        cell.configure(title: title, selected: selected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0.dynamic
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let currentText = items()[indexPath.row]
        didSelect?(currentText)
        tableView.reloadData()
    }
}

