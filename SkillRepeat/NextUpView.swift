import SwiftUI

struct NextUpView: View {
    let skills: Skills
    @ObservedObject private(set) var log: Log

    var body: some View {
        List(log.sortSkillsByDeadline(skills: skills), id: \.name) { skill in
            NextUpRow(
                skill: skill,
                isDoneToday: self.log.isDoneToday(skill),
                doneTodayAction: { self.log.toggleDoneToday(skill) },
                isDoneYesterday: self.log.isDoneYesterday(skill),
                doneYesterdayAction: { self.log.toggleDoneYesterday(skill) },
                calendarViewFactory: self.calendarViewFactory())
        }
        .navigationBarTitle("Next up")
    }

    private func calendarViewFactory() -> NextUpRow.CalendarViewFactory {
        weak var weakLog = self.log
        return { skill in
            if let log = weakLog {
                return CalendarView(skill: skill, log: log)
            }
            return nil
        }
    }
}

struct NextUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NextUpView(
               skills: Skills.testInstance,
               log: Log.testInstance)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
