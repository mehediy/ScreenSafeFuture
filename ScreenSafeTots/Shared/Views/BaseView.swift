//
//  BaseView.swift
//
//  Created by Md. Mehedi Hasan on 10/9/20.

import UIKit


protocol LayoutBased {
    func setupLayout()
}

extension LayoutBased where Self: UIView {
    func setupLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

protocol BaseViewProtocol: LayoutBased {
    func setupView()
}

class BaseView: UIView, BaseViewProtocol, Initializable, WithInitialization {
    
    required init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.setupView()
        self.setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() { }
    func setupLayout() { }
    
    //    static func with(task: (BaseView) -> Void) -> BaseView {
    //        let view = BaseView()
    //        task(view)
    //        return view
    //    }
}

class BaseScrollView: UIScrollView, BaseViewProtocol, Initializable, WithInitialization {
    
    required init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.setupView()
        self.setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() { }
    func setupLayout() { }
}


class BaseImageView: UIImageView, LayoutBased, Initializable, WithInitialization {
    
    required init() {
        super.init(image: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BaseLabel: UILabel, LayoutBased, Initializable, WithInitialization {
    
    enum LabelType {
        case singleline
        case multiline
    }
    
    var type: LabelType = .singleline {
        didSet {
            self.setType()
        }
    }
    
    required init(){
        super.init(frame: CGRect.zero)
        self.setType()
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.setType()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setType() {
        switch self.type {
        case .singleline:
            self.numberOfLines = 1
            self.lineBreakMode = .byTruncatingTail
        case .multiline:
            self.numberOfLines = 0
            self.lineBreakMode = .byWordWrapping
        }
    }
}

class BaseButton: UIButton, LayoutBased, Initializable, WithInitialization {
    
    required init() {
        super.init(frame: CGRect.zero)
        self.titleLabel?.font = Theme.Font.medium
        //self.setTitleColor(Theme.Color.link, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}

class BaseSwitch: UISwitch, LayoutBased, Initializable, WithInitialization {
    
    required init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseTextField: UITextField, LayoutBased, UITextFieldDelegate, Initializable, WithInitialization  {
    
    var charecterLimit: Int = 100
    
    required init() {
        super.init(frame: CGRect.zero)
        self.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        self.setupView()
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() { }
    func setupLayout() { }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= self.charecterLimit
    }
}

class BaseTextView: UITextView, LayoutBased, Initializable, WithInitialization {
    
    required init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func with(task: (BaseTextView) -> Void) -> BaseTextView {
        let textView = BaseTextView()
        task(textView)
        return textView
    }
}


class BasePickerView: UIPickerView, LayoutBased, Initializable, WithInitialization {
    
    required init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class BaseActivityIndicatorView: UIActivityIndicatorView, LayoutBased, Initializable, WithInitialization {
    
    
    required init() {
        super.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BaseTableView: UITableView, LayoutBased, Initializable, WithInitialization {
    
    required init() {
        super.init(frame: CGRect.zero, style: UITableView.Style.plain)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BaseCollectionView: UICollectionView, LayoutBased, Initializable, WithInitialization {
    
    required init(){
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    }
    
    init(collectionViewLayout: UICollectionViewLayout){
        super.init(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseTableViewCell: UITableViewCell, BaseViewProtocol, ReusableView {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.selectionStyle = .none
    }
    
    func setupLayout() { }
}


class BaseCollectionViewCell: UICollectionViewCell, BaseViewProtocol {
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() { }
    func setupLayout() { }
}
