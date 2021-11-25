//
//  NoteView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//


import SwiftUI
import CoreData

struct NoteView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    //read the managed object context right out
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)],
        animation: .default)
    // fetch from database
    
    private var notes: FetchedResults<Note>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { Note in
                    NavigationLink {
                        Texteditor()
                    } label: {
                        VStack(alignment: .leading){
                            Text("Title")
                                .font(.body)
                            Text(Note.timestamp!, formatter: NoteFormatter)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("Notes")
            .toolbar {
                //                ToolbarNote(placement: .navigationBarTrailing) {
                //                    EditButton()
                //                }
                ToolbarItem {
                    Button(action: addNote) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
            }
            Text("Select an Note")
        }
    }
    
    private func addNote() {
        withAnimation {
            let newNote = Note(context: viewContext)
            newNote.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let NoteFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    //    formatter.timeStyle = .medium
    return formatter
}()



struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView()
    }
}

