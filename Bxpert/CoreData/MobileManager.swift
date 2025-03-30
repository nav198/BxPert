//
//  MobileManager.swift
//  Bxpert
//
//  Created by Naveen on 28/03/25.
//


import Foundation
import CoreData
import UIKit

class MobileManager {
    static let shared = MobileManager()
    private init() {}

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveMobile(_ mobile: MobilesModel) {
          let entity = MobileEntity(context: context)
          entity.id = mobile.id
          entity.name = mobile.name
          entity.color = mobile.data?.color
          entity.capacity = mobile.data?.capacity
          entity.price = mobile.data?.price ?? 0.0

          do {
              try context.save()
          } catch {
              print("❌ Failed to save mobile: \(error.localizedDescription)")
          }
      }
   
    func fetchMobiles() -> [MobilesModel] {
           let request: NSFetchRequest<MobileEntity> = MobileEntity.fetchRequest()
           do {
               let results = try context.fetch(request)
               return results.map { entity in
                   MobilesModel(
                       id: entity.id ?? "",
                       name: entity.name ?? "",
                       data: MobileData(
                           color: entity.color,
                           capacity: entity.capacity,
                           price: entity.price
                       )
                   )
               }
           } catch {
               print("❌ Failed to fetch mobiles: \(error.localizedDescription)")
               return []
           }
       }

    func deleteMobile(byId id: String) {
          let request: NSFetchRequest<MobileEntity> = MobileEntity.fetchRequest()
          request.predicate = NSPredicate(format: "id == %@", id)

          do {
              if let entity = try context.fetch(request).first {
                  context.delete(entity)
                  try context.save()
              }
          } catch {
              print("❌ Failed to delete mobile: \(error.localizedDescription)")
          }
      }
}
