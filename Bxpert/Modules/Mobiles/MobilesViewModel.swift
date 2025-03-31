//
//  MobilesViewModel.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import Foundation

class MobilesViewModel{
    let apiManager = APIManager.shared
    var mobilesList: [MobilesModel] = [] {
        didSet {
            onDataUpdate?()
        }
    }
    var onDataUpdate: (() -> Void)?
    
    func saveData() {
        for mobile in mobilesList {
            MobileManager.shared.saveMobile(mobile)
        }
    }
    
    
    func getData() {
        apiManager.fetchData { [weak self] result in
            switch result {
            case .success(let mobiles):
                self?.mobilesList = mobiles
                self?.saveData()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteItem(at index: Int) {
        guard index >= 0, index < mobilesList.count else { return }
        mobilesList.remove(at: index)
        let mobileId = mobilesList[index].id
        MobileManager.shared.deleteMobile(byId: mobileId)
        onDataUpdate?()
    }
    
    func updateItem(at index: Int, newName: String) {
        guard index < mobilesList.count else { return }
        mobilesList[index].name = newName
        saveData()
        onDataUpdate?()
    }
}
