//
//  InfiniteScrollView.swift
//  Sparq_TakeHome
//
//  Created by Casey Millstein on 1/20/26.
//

import SwiftUI

struct InfiniteScrollView<Content: View, Item: Identifiable>: View {
    let items: [Item]
    let hasMore: Bool
    let onLoadMore: () async -> Void
    let content: (Item) -> Content
    
    @State private var isLoadingMore = false
    
    init(
        items: [Item],
        hasMore: Bool,
        onLoadMore: @escaping () async -> Void,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.hasMore = hasMore
        self.onLoadMore = onLoadMore
        self.content = content
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .onAppear {
                            let threshold = max(3, items.count - 3)
                            if index >= threshold && hasMore && !isLoadingMore {
                                Task {
                                    isLoadingMore = true
                                    await onLoadMore()
                                    isLoadingMore = false
                                }
                            }
                        }
                }
                
                if isLoadingMore && hasMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                }
            }
        }
    }
}

struct PreviewItem: Identifiable {
    let id = UUID()
    let number: Int
}

#Preview {
    InfiniteScrollView(
        items: (1...20).map { PreviewItem(number: $0) },
        hasMore: true,
        onLoadMore: {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
    ) { item in
        HStack {
            Text("Item \(item.number)")
                .padding()
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}
