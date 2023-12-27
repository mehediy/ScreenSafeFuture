//
//  MonthYearPickerView.swift
//
//  Created by Md. Mehedi Hasan on 19/4/21.
//

import UIKit

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var minimumDate: Date? {
        didSet {
            populateYears()
            //reloadComponent(1)
            reloadAllComponents()
            if let minimumDate = minimumDate {
                if minimumDate > date {
                    date = minimumDate
                }
                selectDateRows(animated: false)
            }

            
        }
    }
    
    var maximumDate: Date? {
        didSet {
            populateYears()
            //reloadComponent(1)
            reloadAllComponents()

            if let maximumDate = maximumDate {
                if maximumDate < date {
                    date = maximumDate
                }
                selectDateRows(animated: false)
            }
        }
    }
    
    var date: Date = Date() {
        didSet {
            month = Calendar.current.component(.month, from: date)
            year = Calendar.current.component(.year, from: date)
        }
    }
    
    var months = [String]()
    var years = [Int]()
    
    var month = Calendar.current.component(.month, from: Date())
    var year = Calendar.current.component(.year, from: Date())
    
    var onDateSelected: ((Date) -> Void)?
    
    
    required init(date: Date?, minimumDate: Date?, maximumDate: Date?) {
        self.date = date ?? Date()
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        //super.init(frame: .zero)
        super.init(frame: .zero)
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    
    func commonSetup() {
        populateYears()
        populateMonths()

        delegate = self
        dataSource = self
        
        selectDateRows(animated: false)
    }
    
    /// population years
    func populateYears() {
        var years: [Int] = []
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
        var minYear = currentYear - 10
        var maxYear = currentYear + 10
        
        if let minimumDate = minimumDate {
            minYear = Calendar(identifier: .gregorian).component(.year, from: minimumDate)
        }
        if let maximumDate = maximumDate {
            maxYear = Calendar(identifier: .gregorian).component(.year, from: maximumDate)
        }
        
        for year in minYear..<currentYear {
            years.append(year)
        }
        for year in currentYear...maxYear {
            years.append(year)
        }
        
        self.years = years
    }
    
    /// population months with localized names
    func populateMonths() {
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
    }
    
    
    func setDate(_ date: Date, animated: Bool) {
        self.date = date
        selectDateRows(animated: animated)
    }
    
    private func selectDateRows(animated: Bool) {
        selectRow(month - 1, inComponent: 0, animated: animated)
        if let firstYearIndex = years.firstIndex(of: year) {
            selectRow(firstYearIndex, inComponent: 1, animated: animated)
        }
    }
    
    
    // Mark: UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedMonth = selectedRow(inComponent: 0) + 1
        let selectedYear = years[selectedRow(inComponent: 1)]
        
        var dateComponents = DateComponents()
        dateComponents.year = selectedYear
        dateComponents.month = selectedMonth
        
        if let selectedDate = Calendar.current.date(from: dateComponents) {
            
            if let minimumDate = minimumDate, minimumDate > selectedDate {
                date = minimumDate
                selectDateRows(animated: true)
                return
            }
            
            if let maximumDate = maximumDate, maximumDate < selectedDate {
                date = maximumDate
                selectDateRows(animated: true)
                return
            }
            
            onDateSelected?(selectedDate)
            self.date = selectedDate
            
            self.month = selectedMonth
            self.year = selectedYear
        }
        
    }
    
}


