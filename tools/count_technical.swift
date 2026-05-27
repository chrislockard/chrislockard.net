#!/usr/bin/env swift
import Foundation

let technicalCategories: Set<String> = ["infosec", "foss", "coding", "ai", "technology", "dev", "programming"]

func frontmatterCategories(in content: String) -> [String] {
    guard content.hasPrefix("---") else { return [] }

    let lines = content.components(separatedBy: "\n")
    var frontmatterLines: [String] = []
    var pastOpening = false
    var closed = false

    for line in lines {
        let stripped = line.hasSuffix("\r") ? String(line.dropLast()) : line
        if stripped == "---" {
            if !pastOpening { pastOpening = true; continue }
            closed = true; break
        }
        if pastOpening { frontmatterLines.append(stripped) }
    }

    guard closed else { return [] }

    var categories: [String] = []
    var inBlock = false

    for line in frontmatterLines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        if trimmed.lowercased().hasPrefix("categories:") {
            let value = String(trimmed.dropFirst("categories:".count))
                .trimmingCharacters(in: .whitespaces)

            if value.hasPrefix("[") && value.hasSuffix("]") {
                let inner = String(value.dropFirst().dropLast())
                categories = inner.components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces)
                             .trimmingCharacters(in: CharacterSet(charactersIn: "\"'")) }
                    .filter { !$0.isEmpty }
                inBlock = false
            } else if value.isEmpty {
                inBlock = true
            } else {
                categories = [value.trimmingCharacters(in: CharacterSet(charactersIn: "\"'"))]
                inBlock = false
            }
        } else if inBlock {
            if trimmed.hasPrefix("- ") {
                let val = String(trimmed.dropFirst(2))
                    .trimmingCharacters(in: .whitespaces)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\"'"))
                if !val.isEmpty { categories.append(val) }
            } else if !trimmed.isEmpty && !trimmed.hasPrefix("#") {
                inBlock = false
            }
        }
    }

    return categories
}

let postDir = "content/post"
let fm = FileManager.default

guard let files = try? fm.contentsOfDirectory(atPath: postDir) else {
    fputs("Error: cannot read \(postDir)\n", stderr)
    exit(1)
}

var technical = 0
var nonTechnical = 0

for filename in files where filename.hasSuffix(".md") {
    let path = (postDir as NSString).appendingPathComponent(filename)
    guard let content = try? String(contentsOfFile: path, encoding: .utf8) else { continue }

    let cats = frontmatterCategories(in: content)
    if cats.contains(where: { technicalCategories.contains($0.lowercased()) }) {
        technical += 1
    } else {
        nonTechnical += 1
    }
}

print("Technical: \(technical)")
print("Non-technical: \(nonTechnical)")
