import SwiftUI

struct ContentView: View {
    @StateObject private var fetcher = RecipeCollectionFetcher()
    enum ViewType {
        case randomRecipeView
        case todayCourseView
        case favoriteCourseView
    }
    @State private var currentView: ViewType = .todayCourseView
    @State var todayCourse :[Recipe] = []
    @StateObject var favoriteCourses = CourseListData()    
    
    var body: some View {
        TabView(selection: $currentView) {
            RandomRecipeView(todayCourse: $todayCourse)
                .environmentObject(fetcher) 
                .tabItem {
                    Label("Random recipe", systemImage: "questionmark")
                }
                .tag(ViewType.randomRecipeView)
            TodayCourseView(todayCourse: $todayCourse, favoriteCourses: favoriteCourses)
                .tabItem {
                    Label("Today course", systemImage: "list.bullet")
                }
                .tag(ViewType.todayCourseView)
            FavoriteCourseView(todayCourse: $todayCourse, favoriteCourses: favoriteCourses)
                .tabItem {
                    Label("Favorite", systemImage: "star")
                }
                .tag(ViewType.favoriteCourseView)
        }
        .task {
            favoriteCourses.load()
        }
        .onChange(of: favoriteCourses.courses) { _ in
            favoriteCourses.save()
        }
    }
}
