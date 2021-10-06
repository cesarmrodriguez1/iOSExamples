//
//  ContentView.swift
//  CoreDataSample
//
//  Created by gdaalumno on 06/10/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors:[NSSortDescriptor(keyPath: \Meal.name, ascending: false)])
    
    private var meals: FetchedResults<Meal>
    
    var body: some View {
        NavigationView{
            List{
                ForEach(meals) {meal in
                    Text(meal.name ?? "Noname meal")
                        .onTapGesture (count: 1, perform:{
                            updateMeal(meal)
                        })
                }
                .onDelete(perform: deleteMeals)
            }
            .navigationTitle("OrdersList")
            .navigationBarItems(trailing: Button("Add meal"){
                addMeal()
            })
        }
    }
    
    private func updateMeal(_ meal: FetchedResults<Meal>.Element){
        meal.name = "New Value for meal"
        saveContext()
    }
    
    private func deleteMeals(offsets: IndexSet){
        withAnimation{
            offsets.map{ meals[$0]}.forEach(viewContext.delete)
        }
    }
    
    
    private func addMeal(){
        withAnimation{
            let newMeal = Meal(context: viewContext)
            newMeal.name = "New meal \(Date())"
            newMeal.price = 120.0
            newMeal.meal_description = "This is a new Meal"
            
        }
    }
    
    private func saveContext(){
        do{
            try viewContext.save()
        }catch{
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


self.performSegueWithIdentifier("ToNextView", sender: self)


