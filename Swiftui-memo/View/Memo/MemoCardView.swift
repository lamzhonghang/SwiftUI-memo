//
//  MemoCardView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/28.
//

import SwiftUI

struct MemoCardView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var memos: Memo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            HStack{
                if let timestamp = memos.timestamp {
                    Text(timestamp, formatter: IdeasFormatter)
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                } else {
                    Text("--")
                }
                
                Spacer()
            }
            Text(memos.title ?? "Title")
                .foregroundColor(.primary)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            HStack{
                Spacer()
                Text(memos.author ?? "lan")
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

private let IdeasFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
//        formatter.timeStyle = .medium
    return formatter
}()


