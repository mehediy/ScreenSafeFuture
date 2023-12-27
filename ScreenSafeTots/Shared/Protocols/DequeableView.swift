//
//  DequeableView.swift
//  Radiant Tap Essentials
//	https://github.com/radianttap/swift-essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit


extension UICollectionView {

	//	register for the Class-based cell
	func register<T: UICollectionViewCell>(_: T.Type)
		where T: ReusableView
	{
		register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
	}

	//	register for the Nib-based cell
	func register<T: UICollectionViewCell>(_: T.Type)
		where T:NibReusableView
	{
		register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
	}

	func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T
		where T:ReusableView
	{
		//	this deque and cast can fail if you forget to register the proper cell
		guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			//	thus crash instantly and nudge the developer
			fatalError("Dequeing a cell with identifier: \(T.reuseIdentifier) failed.\nDid you maybe forget to register it in viewDidLoad?")
		}
		return cell
	}

	//	register for the Class-based supplementary view
	func register<T: UICollectionReusableView>(_: T.Type, kind: String)
		where T:ReusableView
	{
		register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
	}

	//	register for the Nib-based supplementary view
	func register<T: UICollectionReusableView>(_: T.Type, kind: String)
		where T:NibReusableView
	{
		register(T.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
	}

	func dequeueReusableView<T: UICollectionReusableView>(kind: String, atIndexPath indexPath: IndexPath) -> T
		where T:ReusableView
	{
		//	this deque and cast can fail if you forget to register the proper cell
		guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			//	thus crash instantly and nudge the developer
			fatalError("Dequeing supplementary view of kind: \( kind ) with identifier: \( T.reuseIdentifier ) failed.\nDid you maybe forget to register it in viewDidLoad?")
		}
		return view
	}
}


extension UITableView {

	//	register for the Class-based cell
    func register<T: UITableViewCell>(_: T.Type)
		where T: ReusableView
	{
		register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
	}

	//	register for the Nib-based cell
    func register<T: UITableViewCell>(_: T.Type)
		where T:NibReusableView
	{
		register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
	}

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T
		where T:ReusableView
	{
		guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			fatalError("Dequeing a cell with identifier: \(T.reuseIdentifier) failed.\nDid you maybe forget to register it in viewDidLoad?")
		}
		return cell
	}
    
    /// this function dequeue cell without reusing it by using different identifier for differennt indexpath
    func dequeueCellWithoutReusing<T: UITableViewCell>(forIndexPath indexPath: IndexPath, identifier: String, register: Bool = true) -> T
    where T:ReusableView {
        
        let reusableID = T.reuseIdentifier + identifier
        
        guard let cell = self.dequeueReusableCell(withIdentifier: reusableID) as? T else {
            self.register(T.self, forCellReuseIdentifier: reusableID)
            return register ? dequeueCellWithoutReusing(forIndexPath: indexPath, identifier: reusableID, register: false) : T()
        }
        return cell
    }

	//	register for the Class-based header/footer view
    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
		register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
	}

	//	register for the Nib-based header/footer view
    func register<T: UITableViewHeaderFooterView>(_: T.Type)
		where T:NibReusableView
	{
		register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
	}

    func dequeueReusableView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("fatalError: Could not dequeue header/footer view with identifier: \(T.reuseIdentifier)")
        }
		return view
	}
}

//extension UITableViewCell: ReusableView {}
//extension UICollectionViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView { }

