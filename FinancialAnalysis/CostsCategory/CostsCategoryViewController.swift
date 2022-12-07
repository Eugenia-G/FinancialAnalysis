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
    private let addCostButton = UIButton()
    private let incomeLabel = UILabel()
    private let incomeInfoLabel = UILabel()
    private let addIncomeButton = UIButton()
    
    private var balance: Double {
        presenter?.getIncome() ?? 0
    }
    
    private var costs: [CostsCategory] {
        presenter?.getCostsCategory() ?? []
    }
    
    private var costsKeys: [String] {
        self.costs.map({$0.costsName})
    }
    private var costsName: [String] {
        self.costs.map({$0.costsNumber})
    }
    private var costsDate: [String] {
        self.costs.map({$0.costsDate})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.setTitle(title: presenter?.category ?? "", subtitle: "")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUI()
        presenter?.start()
        
        
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
        
    }
    
    @objc func updateTable() {
        tableView.reloadData()
    }
    
    @objc func updateIncome() {
        incomeInfoLabel.text = "\(balance) ₽"
    }
        
}

private extension CostsCategoryViewController {
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(addCostButton)
        view.addSubview(incomeLabel)
        view.addSubview(incomeInfoLabel)
        view.addSubview(addIncomeButton)
        
        incomeLabel.text = "Текущий баланс: "
        incomeLabel.font = UIFont(name: "Arial", size: 16)
        incomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(110)
            make.left.equalToSuperview().inset(16)
        }
        
        incomeInfoLabel.text = "\(balance) ₽"
        incomeInfoLabel.font = UIFont(name: "Arial", size: 16)
        incomeInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(110)
            make.left.equalTo(incomeLabel.snp.right).offset(5)
        }
        
        addIncomeButton.setTitle("+", for: .normal)
        addIncomeButton.backgroundColor = .white
        addIncomeButton.setTitleColor(.gray, for: .normal)
        addIncomeButton.titleLabel?.font = UIFont(name: "Arial", size: 22)
        addIncomeButton.addTarget(self, action: #selector(addIncomeButtonClick), for: .touchUpInside)
        addIncomeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.right.equalToSuperview().inset(10)
        }
        
        addCostButton.setTitle("Добавить расход", for: .normal)
        addCostButton.layer.cornerRadius = 24
        addCostButton.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        addCostButton.tintColor = .white
        addCostButton.addTarget(self, action: #selector(addCostButtonClick), for: .touchUpInside)
        
        addCostButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(145)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(addCostButton).inset(50)
        }
        
        tableView.register(CostsCategoryTableCell.self, forCellReuseIdentifier: "CostsCategoryTableCell")
    }
    
    @objc func addCostButtonClick() {
        presenter?.add(navController: navigationController!, type: .cost)
    }
    
    @objc func addIncomeButtonClick() {
        presenter?.add(navController: navigationController!, type: .income)
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
        cell.costLabel.text = costsName[indexPath.row]
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
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
}
