//
//  MemoView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI
import CoreData

struct MemoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Memo.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Memo.timestamp, ascending: false),
            NSSortDescriptor(keyPath: \Memo.author, ascending: true),
            NSSortDescriptor(keyPath: \Memo.title, ascending: true),
            NSSortDescriptor(keyPath: \Memo.id, ascending: true)
        ],animation: .default
    )
    
    private var memos: FetchedResults<Memo>
    @State private var showingAddMemo = false
    @State private var showingMemoDetail = false
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea(.all)
                ScrollView(showsIndicators: false){
                    VStack(spacing: 16){
                        ForEach(memos, id: \.self) { memo in
                            Section{
                                NavigationLink(destination: MemoDetailView(memos: memo)){
                                    VStack(alignment: .leading, spacing: 8){
                                        HStack{
                                            Text(memo.timestamp!, formatter: IdeasFormatter)
                                                .font(.footnote)
                                                .foregroundColor(Color(UIColor.tertiaryLabel))
                                            Spacer()
                                        }
                                        Text(memo.title ?? "Title")
                                            .foregroundColor(.primary)
                                            .font(.body)
                                            .multilineTextAlignment(.leading)
                                        
                                        HStack{
                                            Spacer()
                                            Text(memo.author ?? "lan")
                                                .font(.subheadline)
                                                .foregroundColor(Color(UIColor.tertiaryLabel))
                                        }
                                    }
                                    .padding()
                                    .background(Color(UIColor.secondarySystemGroupedBackground))
                                    .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .contextMenu() {
                                Button(role: .destructive) {
                                    withAnimation(){
                                        viewContext.delete(memo)
                                        try! viewContext.save()
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete(perform: deleteMemos)
                    }
                    .padding()
                }
            }
            .navigationTitle("Memo")
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        showingAddMemo = true
                    }
                    .sheet(isPresented: $showingAddMemo){
                        AddNewMemoView().environment(\.managedObjectContext, self.viewContext)
                    }
                }
            }
            Text("Select an Ideas")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private func addIdeas() {
        withAnimation {
            let newMemo = Memo(context: viewContext)
            newMemo.timestamp = Date()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteMemos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let memo = memos[index]
                viewContext.delete(memo)
            }
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let IdeasFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    //    formatter.timeStyle = .medium
    return formatter
}()

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        MemoView()
    }
}

