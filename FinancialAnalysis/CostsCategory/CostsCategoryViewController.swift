//
//  CostsCategoryViewController.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 27.11.2022.
//

import Foundation
import UIKit

final class CostsCategoryViewController: UIViewController {
    
    public var presenter: CostsCategoryPresenterInput?
    
    private let tableView = UITableView()
    private let incomeInfoLabel = UILabel()
    private let graphButton = UIButton()
    let forWhatLabel = UILabel()
    let whenLabel = UILabel()
    let howManyLabel = UILabel()
    
    private let emptyLabel = UILabel()
    
    private var balance: Double {
        presenter?.getIncome() ?? 0
    }
    
    private var costs: [CostsCategory] {
        get {
            (self.presenter?.getCostsCategory() ?? []).sorted(by: { $0.costsDate > $1.costsDate })
        }
        set {
            tableView.reloadData()
        }
    }
    
    private var costsKeys: [String] {
        get {
            self.costs.map({$0.costsName})
        }
        set {
        }
    }
    private var costsName: [String] {
        get {
            self.costs.map({$0.costsNumber})
        }
        set {
        }
    }
    private var costsDate: [String] {
        get {
            self.costs.map({$0.costsDate})
        }
        set {
        }
    }
    private var costsDays: Int {
        var key = costsDate.first
        var keys: [String] = []
        for (index, element) in costsDate.enumerated() {
            if element != key  {
                keys.append(key ?? "")
                key = element
                
                if index == costsDate.count - 1 {
                    keys.append(key ?? "")
                }
            }
        }
        if keys.filter({ $0 == key }).isEmpty {
            keys.append(key ?? "")
        }
        return keys.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.setTitle(title: presenter?.category ?? "", subtitle: "")
        navigationItem.backButtonTitle = ""
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUI()
        presenter?.start()
        
        if costsDays > 1 {
            graphButton.isHidden = false
        } else {
            graphButton.isHidden = true
        }
        
        if costs.isEmpty {
            forWhatLabel.isHidden = true
            whenLabel.isHidden = true
            howManyLabel.isHidden = true
            tableView.isHidden = true
        } else {
            forWhatLabel.isHidden = false
            whenLabel.isHidden = false
            howManyLabel.isHidden = false
            emptyLabel.removeFromSuperview()
        }
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTable),
            name: NSNotification.Name(rawValue: "costAdd"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateIncome),
            name: NSNotification.Name(rawValue: "incomeAdd"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showMassageCostDidntAdd),
            name: NSNotification.Name(rawValue: "costDidntAdd"),
            object: nil)
        
    }
}

private extension CostsCategoryViewController {
    func setupUI() {
        let addCostButton = UIButton()
        let incomeLabel = UILabel()
        let addIncomeButton = UIButton()
        
        view.addSubview(forWhatLabel)
        view.addSubview(whenLabel)
        view.addSubview(howManyLabel)
        view.addSubview(tableView)
        view.addSubview(addCostButton)
        view.addSubview(graphButton)
        view.addSubview(incomeLabel)
        view.addSubview(incomeInfoLabel)
        view.addSubview(addIncomeButton)
        
        incomeLabel.text = "Текущий баланс: "
        incomeLabel.font = UIFont(name: "Arial", size: 16)
        incomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.left.equalToSuperview().inset(16)
        }
        
        incomeInfoLabel.text = "\(balance) ₽"
        incomeInfoLabel.font = UIFont(name: "Arial", size: 16)
        incomeInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.left.equalTo(incomeLabel.snp.right).offset(5)
        }
        
        addIncomeButton.setTitle("+", for: .normal)
        addIncomeButton.backgroundColor = .white
        addIncomeButton.setTitleColor(.gray, for: .normal)
        addIncomeButton.titleLabel?.font = UIFont(name: "Arial", size: 22)
        addIncomeButton.addTarget(self, action: #selector(addIncomeButtonClick), for: .touchUpInside)
        addIncomeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalToSuperview().inset(10)
        }
        
        addCostButton.setTitle("Добавить расход", for: .normal)
        addCostButton.layer.cornerRadius = 24
        addCostButton.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        addCostButton.tintColor = .white
        addCostButton.addTarget(self, action: #selector(addCostButtonClick), for: .touchUpInside)
        
        addCostButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        graphButton.setTitle("График платежей", for: .normal)
        graphButton.layer.cornerRadius = 24
        graphButton.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        graphButton.tintColor = .white
        graphButton.addTarget(self, action: #selector(addGraphButtonClick), for: .touchUpInside)
        
        graphButton.snp.makeConstraints { make in
            make.top.equalTo(incomeLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        forWhatLabel.text = "На что"
        forWhatLabel.textColor = .systemGray
        forWhatLabel.font = UIFont(name: "Arial", size: 16)
        forWhatLabel.textAlignment = .left
        forWhatLabel.snp.makeConstraints { make in
            make.top.equalTo(graphButton.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo((view.bounds.width - 32) / 3)
        }
        
        whenLabel.text = "Когда"
        whenLabel.textColor = .systemGray
        whenLabel.font = UIFont(name: "Arial", size: 16)
        whenLabel.textAlignment = .center
        whenLabel.snp.makeConstraints { make in
            make.top.equalTo(graphButton.snp.bottom).offset(20)
            make.left.equalTo(forWhatLabel.snp.right)
            make.width.equalTo((view.bounds.width - 32) / 3)
        }
        
        howManyLabel.text = "Сколько"
        howManyLabel.textColor = .systemGray
        howManyLabel.font = UIFont(name: "Arial", size: 16)
        howManyLabel.textAlignment = .right
        howManyLabel.snp.makeConstraints { make in
            make.top.equalTo(graphButton.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo((view.bounds.width - 32) / 3)
        }
        

        tableView.snp.makeConstraints { make in
            make.top.equalTo(forWhatLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(addCostButton).inset(24)
        }
        
        tableView.register(CostsCategoryTableCell.self, forCellReuseIdentifier: "CostsCategoryTableCell")
        
        view.addSubview(emptyLabel)
        emptyLabel.text = "Вы ещё не добавили ни одного расхода"
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont(name: "Arial", size: 16)
        emptyLabel.textColor = .lightGray
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension CostsCategoryViewController {
    @objc func addCostButtonClick() {
        presenter?.add(navController: navigationController!, type: .cost)
    }
    
    @objc func addGraphButtonClick() {
        presenter?.graphButtonDidTap(costs: costs)
    }
    
    @objc func addIncomeButtonClick() {
        presenter?.add(navController: navigationController!, type: .income)
    }
    
    @objc func updateTable() {
        tableView.reloadData()
        forWhatLabel.isHidden = false
        whenLabel.isHidden = false
        howManyLabel.isHidden = false
        
        if costsDays > 1 {
            graphButton.isHidden = false
        } else {
            graphButton.isHidden = true
        }
        
        if costs.count == 1 {
            tableView.isHidden = false
            emptyLabel.removeFromSuperview()
        }
    }
    
    @objc func updateIncome() {
        incomeInfoLabel.text = "\(balance) ₽"
    }
            
    @objc func showMassageCostDidntAdd() {
        presenter?.showAlert(title: "Ваши расходы превышают доходы", subtitle: "Добавьте доход и повторите попытку", action: ["Ок": { Void in }])
    }
}

extension CostsCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        costsKeys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CostsCategoryTableCell", for: indexPath) as! CostsCategoryTableCell
        
        cell.accessoryType = .none
        cell.isUserInteractionEnabled = false
        cell.layer.borderColor = .init(red: 0.882, green: 0.871, blue: 0.871, alpha: 1)
        
        cell.contentView.addSubview(cell.nameLabel)
        cell.nameLabel.text = costsKeys[indexPath.row]
        cell.nameLabel.numberOfLines = 0
        cell.nameLabel.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        cell.nameLabel.textColor = .black
        cell.nameLabel.textAlignment = .left
        
        cell.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cell.contentView.snp.top).offset(24)
            make.left.equalTo(cell.contentView.snp.left).offset(16)
            make.bottom.equalTo(cell.contentView.snp.bottom).offset(-24)
            make.width.equalTo((cell.contentView.bounds.width - 32) / 3)
            }
        
        cell.contentView.addSubview(cell.dateLabel)
        cell.dateLabel.text = costsDate[indexPath.row]
        cell.dateLabel.numberOfLines = 0
        cell.dateLabel.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        cell.dateLabel.textColor = .black
        cell.dateLabel.textAlignment = .center
        
        cell.dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cell.contentView.snp.top).offset(24)
            make.left.equalTo(cell.nameLabel.snp.right)
            make.width.equalTo(cell.contentView.bounds.width / 3)
            make.bottom.equalTo(cell.contentView.snp.bottom).offset(-24)
            }
        
        cell.contentView.addSubview(cell.costLabel)
        cell.costLabel.text = costsName[indexPath.row] + " ₽"
        cell.costLabel.numberOfLines = 0
        cell.costLabel.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        cell.costLabel.textColor = .black
        cell.costLabel.textAlignment = .right
        
        cell.costLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cell.contentView.snp.top).offset(24)
            make.left.equalTo(cell.dateLabel.snp.right)
            make.right.equalTo(cell.contentView.snp.right).inset(16)
            make.width.equalTo((cell.contentView.bounds.width - 32) / 3)
            make.bottom.equalTo(cell.contentView.snp.bottom).offset(-24)
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteCost(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changedBD"), object: nil)
        }
    }
}
