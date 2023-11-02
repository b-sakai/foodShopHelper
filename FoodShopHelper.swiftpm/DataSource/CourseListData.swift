import SwiftUI

class CourseListData: ObservableObject {
    @Published var courses: [Course] = []
    
    private static func getCourseFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("courses.data")
    }
    
    func add(_ course: Course) {
        courses.append(course)
    }
    
    func remove(_ course: Course) {
        courses.removeAll { $0.id == course.id}
    }
    
    func load() {
        do {
            let fileURL = try CourseListData.getCourseFileURL()
            let data = try Data(contentsOf: fileURL)
            courses = try JSONDecoder().decode([Course].self, from: data)
            print("Course loaded: \(courses.count)")
        } catch {
            print("Failed to load from file. Backup data used")
        }
    }
    
    func save() {
        do {
            let fileURL = try CourseListData.getCourseFileURL()
            let data = try JSONEncoder().encode(courses)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            print("Courses saved")
        } catch {
            print("Unable to save")
        }
    }
}
