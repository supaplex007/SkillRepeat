import Foundation
import SwiftDate

struct Skill: CustomDebugStringConvertible, Codable, Equatable {
    let name: String
    let period: TimeInterval

    static let defaultPeriod: TimeInterval = 2.weeks.timeInterval

    var debugDescription: String { name }

    static func == (lhs: Skill, rhs: Skill) -> Bool {
        return lhs.name == rhs.name
    }
}

class Skills {
    let items: [Skill]

    init(_ items: [Skill]) {
        self.items = items
    }

    convenience init(resourceName: String) {
        let url = Bundle.main.url(forResource: resourceName, withExtension: nil)!
        let text = try! String(contentsOf: url)
        let lines = text.components(separatedBy: CharacterSet.newlines)
            .filter({ !$0.isEmpty })
        self.init(lines.map { Skills.parseSkillLine($0) })
    }

    private static func parseSkillLine(_ line: String) -> Skill {
        let parts: [String] = line.components(separatedBy: "\t").filter({ !$0.isEmpty })
        let name = parts[0]
        let period: TimeInterval? = (parts.count > 1) ? parsePeriod(parts.last!) : nil
        return Skill(name: name, period: period ?? Skill.defaultPeriod)
    }

    private static func parsePeriod(_ periodStr: String) -> TimeInterval? {
        let parts: [String] = periodStr.components(separatedBy: " ")
        guard let num = Int(parts[0]) else { return nil }
        let unit = parts.last!
        switch unit {
            case "days":
                return num.days.timeInterval
            case "weeks":
                return num.weeks.timeInterval
            default:
                return nil
        }
    }

    static var testInstance: Skills {
        return Skills([
            Skill(name: "reading", period: Skill.defaultPeriod),
            Skill(name: "running", period: Skill.defaultPeriod),
            Skill(name: "programming", period: Skill.defaultPeriod),
            Skill(name: "music", period: Skill.defaultPeriod),
        ])
    }
}
