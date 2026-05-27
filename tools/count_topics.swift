#!/usr/bin/env swift
import Foundation

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

var counts: [String: Int] = [:]

for filename in files where filename.hasSuffix(".md") {
    let path = (postDir as NSString).appendingPathComponent(filename)
    guard let content = try? String(contentsOfFile: path, encoding: .utf8) else { continue }

    for cat in frontmatterCategories(in: content) {
        let key = cat.lowercased().trimmingCharacters(in: .whitespaces)
        guard !key.isEmpty else { continue }
        counts[key, default: 0] += 1
    }
}

for (cat, count) in counts.sorted(by: { $0.value > $1.value || ($0.value == $1.value && $0.key < $1.key) }) {
    print("\(cat): \(count)")
}
