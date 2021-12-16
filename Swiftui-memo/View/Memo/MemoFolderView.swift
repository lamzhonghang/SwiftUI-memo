//
//  MemoFolderView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/12/14.
//

import SwiftUI
import CoreData

struct MemoFolderView: View { 
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Memo.folder, ascending: true),
        ],
        animation: .default)
    
    private var memos: FetchedResults<Memo>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(memos) { Note in
                    NavigationLink {
                        MemoGridView()
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
            offsets.map { memos[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
               
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

struct MemoFolderView_Previews: PreviewProvider {
    static var previews: some View {
        MemoFolderView()
    }
}
