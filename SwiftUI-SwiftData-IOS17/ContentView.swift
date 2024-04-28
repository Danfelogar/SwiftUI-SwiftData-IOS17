//
//  ContentView.swift
//  SwiftUI-SwiftData-IOS17
//
//  Created by Daniel Felipe on 25/02/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //MARK: - Properties
    @Environment(\.modelContext) private var context
    @State private var isShowingItemSheet: Bool = false
    @Query(sort: \Expense.date) var expenses: [Expense]
    //@Query(filter: #Predicate<Expense> {$0.value > 1000}, sort: \Expense.date) var expenses: [Expense]
    @State private var expenseToEdit: Expense?
    //MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    ExpenseCell(expense: expense)
                        .onTapGesture {
                            print(expense)
                            expenseToEdit = expense
                        }
                }//: Loop
                .onDelete(perform: { indexSet in
                    print("esto es lo que manda indexSet \(indexSet)")
                    for index in indexSet {
                        print("esto es lo que manda index \(index)")
                        context.delete(expenses[index])
                    }
                })
            }//: List
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddExpenseSheet() }
            .sheet(item: $expenseToEdit) {expense in
                UpdateExpenseSheet(expense: expense)
            }
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }//: Btn
                }
            }//: Toolbar
            .overlay(
                Group {
                    if expenses.isEmpty {
                        ContentUnavailableView(label: {
                            Label("No expenses", systemImage: "list.bullet.rectangle.portrait")
                        }, description: {
                            Text("Start adding expenses to see your list.")
                        }, actions: {
                            Button("Add Expense") { isShowingItemSheet = true }
                        })
                        .offset(y: -60)
                    }
                }
            )//: overlay
        }//: Navigation
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Expense.self])
}

//MARK: - ExpenseCell
struct ExpenseCell: View {
    //MARK: - Properties
    let expense: Expense
    //MARK: - Body
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.value, format: .currency(code: "USD"))
        }//: HStack
    }
}

//MARK: - AddSheet
struct AddExpenseSheet: View {
    //MARK: - Properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0
    //MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }//: Form
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel"){ dismiss() }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save"){
                        //Save code goes here
                        let expense = Expense(name: name, date: date, value: value)
                        context.insert(expense)
                        //try! context.save()
                        dismiss()
                    }
                }
            }//: toolbar
        }//: NavigationStack
    }
}

//MARK: - Update
struct UpdateExpenseSheet: View {
    //MARK: - Properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var expense: Expense
    //MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }//: Form
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done"){
                        //Save code goes here
                        dismiss()
                    }
                }
            }//: toolbar
        }//: NavigationStack
    }
}
