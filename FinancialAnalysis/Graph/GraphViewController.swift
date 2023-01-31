//
//  GraphViewController.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 08.10.2022.
//

import UIKit

class GraphViewController: UIViewController {
    public var presenter: GraphPresenterInput?
    
    var datePicker: UIDatePicker? = UIDatePicker()
    
    private var costsForCategory: [CostsCategory]? {
        presenter?.getCostsForCategory()?.sorted(by: { $0.costsDate < $1.costsDate })
    }
    
    private var income: [Income]? {
        presenter?.getIncome()?.sorted(by: { $0.incomeDate < $1.incomeDate })
    }
    
    private var costs: [CostsCategory]? {
        presenter?.getCosts()?.sorted(by: { $0.costsDate < $1.costsDate })
    }
    
    private var type: GraphType = .costs
    
    private var lineCharCostsDate: [String]?
    private var lineCharCostsNumber: [CGFloat]?
    private var lineCharIncomeDate: [String]?
    private var lineCharIncomeNumber: [CGFloat]?
    
    private var lineChart = LineChart()
    private var weekButton = UIButton()
    private var monthButton = UIButton()
    private var quarterButton = UIButton()
    private var allButton = UIButton()
    private var stackViewButton = UIStackView()
    
    private var segmentControl = UISegmentedControl(items: ["Расходы", "Доходы"])
    private var emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setTitle(title: "График", subtitle: "")
        navigationItem.backButtonTitle = ""
        type = presenter?.type ?? .costs
        
        setView()
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        setupUI()
    }

}

private extension GraphViewController {
    func setupUI() {
        weekButton.setTitle("Неделя", for: .normal)
        weekButton.backgroundColor = .white
        weekButton.setTitleColor(.black, for: .normal)
        weekButton.addTarget(self, action: #selector(weekButtonClick), for: .touchUpInside)
        
        monthButton.setTitle("Месяц", for: .normal)
        monthButton.backgroundColor = .white
        monthButton.setTitleColor(.black, for: .normal)
        monthButton.addTarget(self, action: #selector(monthButtonClick), for: .touchUpInside)
        
        quarterButton.setTitle("Квартал", for: .normal)
        quarterButton.backgroundColor = .white
        quarterButton.setTitleColor(.black, for: .normal)
        quarterButton.addTarget(self, action: #selector(quarterButtonClick), for: .touchUpInside)
        
        allButton.setTitle("Всё", for: .normal)
        allButton.backgroundColor = .white
        allButton.setTitleColor(.black, for: .normal)
        allButton.addTarget(self, action: #selector(allButtonClick), for: .touchUpInside)
        
        stackViewButton.addArrangedSubview(weekButton)
        stackViewButton.addArrangedSubview(monthButton)
        stackViewButton.addArrangedSubview(quarterButton)
        stackViewButton.addArrangedSubview(allButton)
        
        stackViewButton.alignment = .center
        stackViewButton.spacing = 5
        stackViewButton.distribution = .fillEqually
        stackViewButton.axis = .horizontal
        stackViewButton.isUserInteractionEnabled = true
        
        segmentControl.isHidden = type == .costsCategory
        
        view.addSubview(stackViewButton)
        stackViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(160)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(150)
            make.height.equalTo(40)
            make.left.equalToSuperview().inset(48)
            make.right.equalToSuperview().inset(48)
        }
    }
    
    func setupLineChart() {
        stackViewButton.isHidden = false
        
        view.addSubview(lineChart)
        lineChart.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.height.equalToSuperview().inset(view.bounds.height * 1/3)
            make.left.equalToSuperview().inset(48)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    func setupEmptyView() {
        stackViewButton.isHidden = true
        
        emptyLabel.text = "У вас недостаточно данных для построения графика. Добавьте данные и попробуйте ещё раз."
        emptyLabel.font = UIFont.systemFont(ofSize: 28)
        emptyLabel.textColor = .darkGray
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}

private extension GraphViewController {
    func setGraph() {
        lineChart.clearAll()
        
        lineChart.area = false
        // расстояние для label
        lineChart.y.axis.inset = 36
        // анимация
        lineChart.animation = .init(enabled: true, duration: 0.3)
        // названия (точки по оси x)
        lineChart.x.labels.visible = true
        
        if self.type == .income {
            self.lineChart.x.labels.values = self.lineCharIncomeDate ?? []
            self.lineChart.addLine(self.lineCharIncomeNumber ?? [])
        } else {
            self.lineChart.x.labels.values = self.lineCharCostsDate ?? []
            self.lineChart.addLine(self.lineCharCostsNumber ?? [])
        }
    }
    
    func getCosts(_ costs: [CostsCategory]?, graphType: GraphTimeType) {
        if let costs = costs {
            let array: [CostsCategory]
            switch graphType {
            case .week:
                array = costs.filter({ $0.costsDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()) })
            case .month:
                array = costs.filter({ $0.costsDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()) })
            case .quarter:
                array = costs.filter({ $0.costsDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -90, to: Date()) ?? Date()) })
            case .all:
                array = costs
            }
            var key = array.first?.costsDate
            var value = 0.0
            var keys: [String] = []
            var values: [Double] = []
            for (index, element) in array.enumerated() {
                if element.costsDate == key {
                    value += Double(element.costsNumber) ?? 0
                } else {
                    keys.append(key ?? "")
                    values.append(value)
                    key = element.costsDate
                    value = Double(element.costsNumber) ?? 0
                    
                    if index == array.count - 1 {
                        keys.append(key ?? "")
                        values.append(value)
                    }
                }
            }
            if keys.filter({ $0 == key }).isEmpty {
                keys.append(key ?? "")
                values.append(value)
            }
            lineCharCostsDate = keys
            lineCharCostsNumber = values.map({ CGFloat($0) })
        }
    }
    
    func getIncome(_ income: [Income]?, graphType: GraphTimeType) {
        if let income = income {
            let array: [Income]
            switch graphType {
            case .week:
                array = income.filter({ $0.incomeDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()) })
            case .month:
                array = income.filter({ $0.incomeDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()) })
            case .quarter:
                array = income.filter({ $0.incomeDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -90, to: Date()) ?? Date()) })
            case .all:
                array = income
            }
            var key = array.first?.incomeDate
            var value = 0.0
            var keys: [String] = []
            var values: [Double] = []
            for (index, element) in array.enumerated() {
                if element.incomeDate == key {
                    value += Double(element.income)
                } else {
                    keys.append(key ?? "")
                    values.append(value)
                    key = element.incomeDate
                    value = Double(element.income)
                    
                    if index == array.count - 1 {
                        keys.append(key ?? "")
                        values.append(value)
                    }
                }
            }
            if keys.filter({ $0 == key }).isEmpty {
                keys.append(key ?? "")
                values.append(value)
            }
            lineCharIncomeDate = keys
            lineCharIncomeNumber = values.map({ CGFloat($0) })
        }
    }
}

private extension GraphViewController {
    func setButtonTypeCosts() -> GraphTimeType{
        let arrayCosts = type == .costs ? costs : costsForCategory
        if let arr = arrayCosts?.filter({ $0.costsDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()) }), Array(Set(arr)).count > 1 {
            return .week
        } else if let arr = arrayCosts?.filter({ $0.costsDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()) }), Array(Set(arr)).count > 1 {
            return .month
        } else if let arr = arrayCosts?.filter({ $0.costsDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -90, to: Date()) ?? Date()) }), Array(Set(arr)).count > 1 {
            return .quarter
        } else {
            return .all
        }
    }
    
    func setButtonTypeIncome() -> GraphTimeType{
        let arrayIncome = income
        if let arr1 = arrayIncome?.filter({ $0.incomeDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()) }), Array(Set(arr1)).count > 1 {
            return .week
        } else if let arr1 = arrayIncome?.filter({ $0.incomeDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()) }), Array(Set(arr1)).count > 1 {
            return .month
        } else if let arr1 = arrayIncome?.filter({ $0.incomeDate.getDate >= (datePicker?.calendar.date(byAdding: .day, value: -90, to: Date()) ?? Date()) }), Array(Set(arr1)).count > 1 {
            return .quarter
        } else {
            return .all
        }
    }
    
    func setView() {
        switch type == .income ? setButtonTypeIncome() : setButtonTypeCosts() {
        case .week:
            weekButton.isHidden = false
            monthButton.isHidden = false
            quarterButton.isHidden = false
            allButton.isHidden = false
            weekButtonClick()
        case .month:
            weekButton.isHidden = true
            monthButton.isHidden = false
            quarterButton.isHidden = false
            allButton.isHidden = false
            monthButtonClick()
        case .quarter:
            weekButton.isHidden = true
            monthButton.isHidden = true
            quarterButton.isHidden = false
            allButton.isHidden = false
            quarterButtonClick()
        case .all:
            weekButton.isHidden = true
            monthButton.isHidden = true
            quarterButton.isHidden = true
            allButton.isHidden = false
            allButtonClick()
        }
    }
    
    @objc func weekButtonClick() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.weekButton.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
            self.weekButton.layer.borderWidth = 1
            self.monthButton.layer.borderWidth = 0
            self.quarterButton.layer.borderWidth = 0
            self.allButton.layer.borderWidth = 0
        })
        
        if type != .income {
            getCosts(type == .costs ? costs : costsForCategory, graphType: .week)
        } else {
            getIncome(income, graphType: .week)
        }
        
        if self.type == .income, lineCharIncomeDate?.count ?? 0 <= 1 {
            lineChart.removeFromSuperview()
            setupEmptyView()
        } else if type != .income, lineCharCostsDate?.count ?? 0 <= 1 {
            lineChart.removeFromSuperview()
            setupEmptyView()
        } else {
            emptyLabel.removeFromSuperview()
            setupLineChart()
            setGraph()
        }
    }
    
    @objc func monthButtonClick() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.monthButton.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
            self.monthButton.layer.borderWidth = 1
            self.weekButton.layer.borderWidth = 0
            self.quarterButton.layer.borderWidth = 0
            self.allButton.layer.borderWidth = 0
        })
        
        if type != .income {
            getCosts(type == .costs ? costs : costsForCategory, graphType: .month)
        } else {
            getIncome(income, graphType: .month)
        }
        
        if self.type == .income, lineCharIncomeDate?.count ?? 0 <= 1 {
            lineChart.removeFromSuperview()
            setupEmptyView()
        } else if type != .income, lineCharCostsDate?.count ?? 0 <= 1 {
            lineChart.removeFromSuperview()
            setupEmptyView()
        } else {
            emptyLabel.removeFromSuperview()
            setupLineChart()
            setGraph()
        }
    }
    
    @objc func quarterButtonClick() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.quarterButton.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
            self.quarterButton.layer.borderWidth = 1
            self.monthButton.layer.borderWidth = 0
            self.weekButton.layer.borderWidth = 0
            self.allButton.layer.borderWidth = 0
        })
        
        if type != .income {
            getCosts(type == .costs ? costs : costsForCategory, graphType: .quarter)
        } else {
            getIncome(income, graphType: .quarter)
        }
        
        if self.type == .income, lineCharIncomeDate?.count ?? 0 <= 1 {
            lineChart.removeFromSuperview()
            setupEmptyView()
        } else if type != .income, lineCharCostsDate?.count ?? 0 <= 1 {
            lineChart.removeFromSuperview()
            setupEmptyView()
        } else {
            emptyLabel.removeFromSuperview()
            setupLineChart()
            setGraph()
        }
    }
    
    @objc func allButtonClick() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.allButton.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
            self.allButton.layer.borderWidth = 1
            self.monthButton.layer.borderWidth = 0
            self.weekButton.layer.borderWidth = 0
            self.quarterButton.layer.borderWidth = 0
        })
        
        if type != .income {
            getCosts(type == .costs ? costs : costsForCategory, graphType: .all)
        } else {
            getIncome(income, graphType: .all)
        }
        
        if self.type == .income, lineCharIncomeDate?.count ?? 0 <= 1 {
            lineChart.removeFromSuperview()
            setupEmptyView()
        } else if type != .income, lineCharCostsDate?.count ?? 0 <= 1 {
            lineChart.removeFromSuperview()
            setupEmptyView()
        } else {
            emptyLabel.removeFromSuperview()
            setupLineChart()
            setGraph()
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            type = .costs
        } else {
            type = .income
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.setView()
        })
    }
}
