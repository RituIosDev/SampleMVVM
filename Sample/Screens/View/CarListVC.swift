//
//  CarListVC.swift
//  BellTechnical
//
//  Created by Ritu on 2022-08-31.
//

import UIKit

class CarListVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tblVwList: UITableView!
    @IBOutlet weak var txtCarModel: UITextField!
    @IBOutlet weak var txtCarMake: UITextField!
    
    
    //MARK: - Variables
    lazy var viewModel = {
        CarListViewModel()
    }()

    //MARK: - ViewDid LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize View Model
        initViewModel()

        //Adding tap getsure for filter view
        let carModelTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCarModelTap(_:)))
        txtCarModel.addGestureRecognizer(carModelTap)
        let carMakeTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCarMakeTap(_:)))
        txtCarMake.addGestureRecognizer(carMakeTap)
    }

    //MARK: - Initializing View with data
    func initViewModel() {
        //Get Data and load the cells
        viewModel.getData()

        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tblVwList.reloadData()
            }
        }
        
        viewModel.filterData = { value,category in
            DispatchQueue.main.async {
                if category == "Make"{
                    if value == Model.anyMake.rawValue{
                        self.txtCarMake.text = ""
                    }else{
                        self.txtCarMake.text = value
                        self.txtCarModel.text = ""
                    }
                }else{
                    if value == Model.anyModel.rawValue{
                        self.txtCarModel.text = ""
                    }else{
                        self.txtCarModel.text = value
                        self.txtCarMake.text = ""
                    }
                }
            }
        }
    }
    
    //MARK: - Tap Geture Handling for filter
    @objc func handleCarModelTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let actionSheet = viewModel.actionSheetForCarModel()
        self.present(actionSheet, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func handleCarMakeTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let actionSheet = viewModel.actionSheetForCarMake()
        self.present(actionSheet, animated: true, completion: { () -> Void in
            print("completion block")
        })
    }
    
}


extension CarListVC: UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.carCellViewModels.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarListTableCell.identifier, for: indexPath) as? CarListTableCell else { fatalError("xib does not exists") }

        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateExpandedCell(at: indexPath)
    }
}
