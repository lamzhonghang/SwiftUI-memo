//
//  IdeasView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI
import CoreData

struct IdeaView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        entity: Idea.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Idea.timestamp, ascending: true),
            NSSortDescriptor(keyPath: \Idea.title, ascending: true),
            NSSortDescriptor(keyPath: \Idea.subtitle, ascending: true),
            NSSortDescriptor(keyPath: \Idea.id, ascending: true)
        ],animation: .default
    )
    
    var ideas: FetchedResults<Idea>
    @State private var showingAddIdeas = false
    
    var body: some View {
        NavigationView {
            List {
                Section{
                    ForEach(ideas, id: \.self) { idea in
                        NavigationLink(destination: IdeaDetailView(ideas: idea)){
                            Section{
                                VStack(alignment: .leading, spacing: 8){
                                Text(idea.title ?? "Title")
                                    .font(.body)
                                    .lineLimit(1)
                                HStack{
                                    Text(idea.timestamp!, formatter: IdeasFormatter)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    Text(idea.subtitle ?? "")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            }
                        }
                    }
                    .onDelete(perform: deleteIdea)
                }header: {
                    Text("Todo")}
                Section{
                    
                }header: {
                    Text("Done")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Ideas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add") {
                        showingAddIdeas = true
                    }
                    .sheet(isPresented: $showingAddIdeas){
                        AddIdeaView().environment(\.managedObjectContext, self.viewContext)
                    }
                }
            }
            Text("Select an Ideas")
        }
    }
    
    private func deleteIdea(offsets: IndexSet) {
        withAnimation {
            offsets.map { ideas[$0] }.forEach(viewContext.delete)
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


struct IdeasView_Previews: PreviewProvider {
    static var previews: some View {
        IdeaView()
    }
}

