import SwiftUI
import Collections

struct TodayCourseView: View {
    @Binding var todayCourse :[Recipe]
    @State var shopList :[Item] = []
    
    func rowRemove(offsets: IndexSet) {
        for index in offsets {
            for material in todayCourse[index].recipeMaterial {
                shopList.removeAll(where: {$0.name == material})
            }
        } 
        todayCourse.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack {
            if !todayCourse.isEmpty {
                List {
                    ForEach(todayCourse, id:\.self) {
                        item in
                        HStack(spacing: 0) {
                            Spacer()
                            RecipeView(recipe: item)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: rowRemove)
                }
                .onAppear { 
                    for recipe in todayCourse {
                        for material in recipe.recipeMaterial {
                            if (shopList.filter { $0.name == material }.isEmpty) {
                                shopList.append(Item(material)) 
                            }
                        }
                    }
                }
                Divider()
                List() {
                    ForEach (0 ..< shopList.count, id: \.self) { index in
                        HStack {
                            Image(systemName: shopList[index].isChecked ? "checkmark.square" : "square")
                                .onTapGesture {
                                    shopList[index].isChecked.toggle()
                                }
                            Text(shopList[index].name)
                        }
                    }
                }
            } else {
                Text("No recipe is appended")
            }
        }
    }
}

struct Item : Hashable {
    var isChecked: Bool
    var name: String
    init(_ name: String) {
        self.isChecked = false
        self.name = name
    }
}
