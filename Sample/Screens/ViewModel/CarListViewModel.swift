//
//  CarListViewModel.swift
//  BellTechnical
//
//  Created by Ritu on 2022-09-01.
//

import Foundation
import UIKit
import CoreData

enum Model : String{
    case anyModel = "Any Model"
    case anyMake = "Any Make"
}

class CarListViewModel: NSObject{
    //MARK: - Variables
    var cars = Cars()
    var filteredCars = Cars()

    var reloadTableView: (() -> Void)?
    var filterData: ((String,String) -> Void)?
    
    

    var carCellViewModels = [CarListTableCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    //MARK: - Get Data
    func getData(){
        let noteFetch: NSFetchRequest<CarsLocal> = CarsLocal.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(noteFetch)
            if results.isEmpty{
                print("FROM JSON FILE")
                getDataFromFile()
            }else{
                print("FROM COREDATA FILE")

                for item in (results as! [CarsLocal]){
                    let carObj = Car(customerPrice: item.customerPrice, make: item.make!, marketPrice: item.marketPrice, model: item.model!, rating: Int(item.rating), prosList: item.prosList as! [String], consList: item.consList as! [String])
                    cars.append(carObj)
                }
                print(cars)
                self.filteredCars.append(contentsOf: self.cars)
                var vms = [CarListTableCellViewModel]()
                for i in 0..<cars.count{
                    if i == 0{
                        vms.append(createCellModel(car: cars[i],index: i))
                    }else{
                        vms.append(createCellModel(car: cars[i],index: Int.max))
                    }
                }
                carCellViewModels = vms
            }
        } catch let error as NSError {
               print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    //MARK: - Get Data from JSON File
    func getDataFromFile(){
        if let path = Bundle.main.path(forResource: "car_list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.cars = try JSONDecoder().decode([Car].self, from: data)
                self.filteredCars.append(contentsOf: self.cars)
                saveInCoreData()
                var vms = [CarListTableCellViewModel]()
                for i in 0..<cars.count{
                    if i == 0{
                        vms.append(createCellModel(car: cars[i],index: i))
                    }else{
                        vms.append(createCellModel(car: cars[i],index: Int.max))
                    }
                }
                carCellViewModels = vms
              } catch {
                   // handle error
                  print(error.localizedDescription)
              }
        }
    }
    
    //MARK: - Save In CoreData
    func saveInCoreData(){
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        for item in cars{
            let newNote = CarsLocal(context: managedContext)
            newNote.setValue(item.make, forKey: #keyPath(CarsLocal.make))
            newNote.setValue(item.model, forKey: #keyPath(CarsLocal.model))
            newNote.setValue(item.customerPrice, forKey: #keyPath(CarsLocal.customerPrice))
            newNote.setValue(item.marketPrice, forKey: #keyPath(CarsLocal.marketPrice))
            newNote.setValue(item.rating, forKey: #keyPath(CarsLocal.rating))
            newNote.setValue(item.prosList, forKey: #keyPath(CarsLocal.prosList))
            newNote.setValue(item.consList, forKey: #keyPath(CarsLocal.consList))
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
        }
    }



    //MARK: - Set data for Cell
    func createCellModel(car: Car,index:Int) -> CarListTableCellViewModel {
        var imgCar = UIImage(named: "Tacoma")!
        if car.make == "Mercedes Benz"{
            imgCar = UIImage(named: "Mercedez_benz_GLC")!
        }else if car.make == "Land Rover"{
            imgCar = UIImage(named: "Range_Rover")!
        }else if car.make == "BMW"{
            imgCar = UIImage(named: "BMW_330i")!
        }
        return CarListTableCellViewModel(lblCarPrice: car.marketPrice, lblCarName: car.make, imgVwCar: imgCar,rating: car.rating,expandedCell: index,arrPros: car.prosList, arrCons: car.consList)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> CarListTableCellViewModel {
        return carCellViewModels[indexPath.row]
    }
    
    func updateExpandedCell(at indexPath:IndexPath){
        var vms = [CarListTableCellViewModel]()
        for i in 0..<filteredCars.count{
            if i == indexPath.row{
                if carCellViewModels[indexPath.row].expandedCell == indexPath.row{
                    vms.append(createCellModel(car: filteredCars[i],index: Int.max))
                }else{
                    vms.append(createCellModel(car: filteredCars[i],index: i))
                }
            }else{
                vms.append(createCellModel(car: filteredCars[i],index: Int.max))
            }
        }
        carCellViewModels = vms
    }
    
    //MARK: - Filter the data in Cell
    func filterDataWithMake(make: String){
        filteredCars.removeAll()
        if make == Model.anyMake.rawValue{
            filteredCars.append(contentsOf: cars)
        }else{
            for item in self.cars{
                if item.make == make{
                    filteredCars.append(item)
                    print(filteredCars)
                    print(item)
                }
            }
        }

        var vms = [CarListTableCellViewModel]()
        for i in 0..<filteredCars.count{
            if i == 0{
                vms.append(createCellModel(car: filteredCars[i],index: i))
            }else{
                vms.append(createCellModel(car: filteredCars[i],index: Int.max))
            }
        }
        carCellViewModels = vms
    }
    
    func filterDataWithModel(model: String){
        filteredCars.removeAll()
        if model == Model.anyModel.rawValue {
            filteredCars.append(contentsOf: cars)
        }else{
            for item in self.cars{
                if item.model == model{
                    filteredCars.append(item)
                }
            }
        }
        var vms = [CarListTableCellViewModel]()
        for i in 0..<filteredCars.count{
            if i == 0{
                vms.append(createCellModel(car: filteredCars[i],index: i))
            }else{
                vms.append(createCellModel(car: filteredCars[i],index: Int.max))
            }
        }
        carCellViewModels = vms
    }


    //MARK: - Action Sheet for filter listing
    func actionSheetForCarMake() -> UIAlertController{
        let alert = UIAlertController(title: "Choose", message: "Please Select Car Make", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Any Make", style: .default , handler:{ (UIAlertAction)in
            self.filterDataWithMake(make: Model.anyMake.rawValue)
            self.filterData?(Model.anyMake.rawValue,"Make")
        }))

        for item in cars{
            alert.addAction(UIAlertAction(title: item.make, style: .default , handler:{ (UIAlertAction)in
                self.filterDataWithMake(make: item.make)
                self.filterData?(item.make,"Make")
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))

        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        return alert
    }
    
    func actionSheetForCarModel() -> UIAlertController{
        let alert = UIAlertController(title: "Choose", message: "Please Select Car Model", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Any Model", style: .default , handler:{ (UIAlertAction)in
            self.filterDataWithModel(model: Model.anyModel.rawValue)
            self.filterData?(Model.anyModel.rawValue,"Model")
        }))

        for item in cars{
            alert.addAction(UIAlertAction(title: item.model, style: .default , handler:{ (UIAlertAction)in
                self.filterDataWithModel(model: item.model)
                self.filterData?(item.model,"Model")
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        return alert
    }
    
    
}

