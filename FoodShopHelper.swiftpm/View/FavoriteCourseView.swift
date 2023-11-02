import SwiftUI

struct FavoriteCourseView: View {
    @Binding var todayCourse :[Recipe]
    @ObservedObject var favoriteCourses :CourseListData
    
    func addTodayCourse(course: [Recipe]) {
        todayCourse = course
    }
    
    var body: some View {
        List {
            ForEach(favoriteCourses.courses) {
                course in
                ZStack {
                    CourseView(course: course.course)
                    FloatingButton(
                        tappedHandler: {self.addTodayCourse(course: course.course)},
                        systemImageName: "plus")
                }
            }
            .onDelete(perform: { indexSet in
                favoriteCourses.courses.remove(atOffsets: indexSet)
            })                 
        }
    }
}

struct CourseView : View {
    var course :[Recipe]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(course, id:\.self) {
                    item in
                    RecipeView(recipe: item)
                }
            }
        }
    }
}
