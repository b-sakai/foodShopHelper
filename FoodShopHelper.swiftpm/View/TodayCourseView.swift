import SwiftUI
import Collections

// TODO: ネストが深すぎるのでサブビュー化する
struct TodayCourseView: View {
    @Binding var todayCourse :[Recipe]
    @State var shopList :[Item] = []
    @StateObject var favoriteCourses :CourseListData
    @State var isFavorite = false
    
    func rowRemove(offsets: IndexSet) {
        for index in offsets {
            for material in todayCourse[index].recipeMaterial {
                shopList.removeAll(where: {$0.name == material})
            }
        } 
        todayCourse.remove(atOffsets: offsets)
    }
    
    var body: some View {
        if !todayCourse.isEmpty {
            ZStack {
                VStack {                    
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
                }
                // お気に入り追加を行うボタン
                FloatingButton(
                    tappedHandler: {
                        if (!isFavorite) {
                            favoriteCourses.add(Course(course:todayCourse))
                            isFavorite = true
                        }
                    },
                    systemImageName: isFavorite ? "star.fill" : "star")
            }
            .onChange(of: todayCourse) { _ in 
                isFavorite = false
                for recipe in todayCourse {
                    for material in recipe.recipeMaterial {
                        if (shopList.filter { $0.name == material }.isEmpty) {
                            shopList.append(Item(material)) 
                        }
                    }
                }
            }
        } else {
            Text("No recipe is appended")
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
