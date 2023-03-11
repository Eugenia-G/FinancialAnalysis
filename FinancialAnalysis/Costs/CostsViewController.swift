//
//  CostsViewController.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 08.10.2022.
//

import UIKit
import SnapKit
import Foundation

final class CostsViewController: UIViewController, UITextFieldDelegate {
    public var presenter: CostsPresenterInput?
    
    private let tableView = UITableView()
    private let addCategoryButton = UIButton()
    private let incomeLabel = UILabel()
    private let incomeInfoLabel = UILabel()
    private let addIncomeButton = UIButton()
    
    private let emptyLabel = UILabel()
    
    private var category: [String] {
        presenter?.getCategories() ?? []
    }
    private var balance: Double {
        presenter?.getIncome() ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setTitle(title: "Расходы", subtitle: "")
        navigationItem.backButtonTitle = ""
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUI()
        
        if category.count > 0 {
            emptyLabel.removeFromSuperview()
        } else {
            tableView.isHidden = true
        }
        
        presenter?.start()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTable),
            name: NSNotification.Name(rawValue: "categoryAdd"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateIncome),
            name: NSNotification.Name(rawValue: "incomeAdd"),
            object: nil)
    }

}

private extension CostsViewController {
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
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
        
        addCategoryButton.setTitle("Добавить категорию расходов", for: .normal)
        addCategoryButton.layer.cornerRadius = 24
        addCategoryButton.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        addCategoryButton.tintColor = .white
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonClick), for: .touchUpInside)
        
        addCategoryButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(145)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(addCategoryButton).inset(50)
        }
        
        tableView.register(CostsTableCell.self, forCellReuseIdentifier: "CostsTableCell")
        
        view.addSubview(emptyLabel)
        emptyLabel.text = "Вы ещё не добавили ни одной категории"
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont(name: "Arial", size: 16)
        emptyLabel.textColor = .lightGray
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension CostsViewController {
    @objc func addCategoryButtonClick() {
        presenter?.add(navController: navigationController!, type: .category)
    }
    
    @objc func addIncomeButtonClick() {
        presenter?.add(navController: navigationController!, type: .income)
    }
    
    @objc func updateTable() {
        tableView.reloadData()
        if category.count == 1 {
            tableView.isHidden = false
            emptyLabel.removeFromSuperview()
        }
    }
    
    @objc func updateIncome() {
        incomeInfoLabel.text = "\(balance) ₽"
    }
}

extension CostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        category.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CostsTableCell", for: indexPath) as! CostsTableCell
        
        cell.contentView.addSubview(cell.nameLabel)
        cell.nameLabel.text = category[indexPath.row]
        cell.nameLabel.numberOfLines = 0
        cell.nameLabel.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        cell.nameLabel.textColor = .black
        cell.accessoryType = .disclosureIndicator
        
        cell.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cell.contentView.snp.top).offset(24)
            make.left.equalTo(cell.contentView.snp.left).offset(16)
            make.right.equalTo(cell.contentView.snp.right).offset(-55)
            make.bottom.equalTo(cell.contentView.snp.bottom).offset(-24)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteCategory(at: indexPath.row, for: category[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changedBD"), object: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.openCostsCategory(navController: navigationController!, category: category[indexPath.row])
        UIView.animate(withDuration: 0.2,  animations: {
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        })
    }
}
