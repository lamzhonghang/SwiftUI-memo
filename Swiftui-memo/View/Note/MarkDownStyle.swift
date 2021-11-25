//
//  Markdown.swift
//
//
//  Created by Kyle Nazario on 5/26/21.
//

import SwiftUI
import HighlightedTextEditor

private let inlineCodeRegex = try! NSRegularExpression(pattern: "`[^`]*`", options: [])
private let codeBlockRegex = try! NSRegularExpression(
    pattern: "(`){3}((?!\\1).)+\\1{3}",
    options: [.dotMatchesLineSeparators]
)
private let headingRegex = try! NSRegularExpression(pattern: "^#{1}\\s", options: [.anchorsMatchLines])
private let heading2Regex = try! NSRegularExpression(pattern: "^#{2}\\s", options: [.anchorsMatchLines])
private let heading3Regex = try! NSRegularExpression(pattern: "^#{3,6}\\s", options: [.anchorsMatchLines])
private let hashTag = try! NSRegularExpression(pattern: "#{1}\\s.*$", options: [.anchorsMatchLines])
private let hash2Tag = try! NSRegularExpression(pattern: "#{2}\\s.*$", options: [.anchorsMatchLines])
private let hash3Tag = try! NSRegularExpression(pattern: "#{3,6}\\s.*$", options: [.anchorsMatchLines])
private let linkOrImageRegex = try! NSRegularExpression(pattern: "!?\\[([^\\[\\]]*)\\]\\((.*?)\\)", options: [])
private let linkOrImageTagRegex = try! NSRegularExpression(pattern: "!?\\[([^\\[\\]]*)\\]\\[(.*?)\\]", options: [])
private let boldRegex = try! NSRegularExpression(pattern: "((\\*|_){2})((?!\\1).)+\\1", options: [])
private let underscoreEmphasisRegex = try! NSRegularExpression(pattern: "(?<!_)_[^_]+_(?!\\*)", options: [])
private let asteriskEmphasisRegex = try! NSRegularExpression(pattern: "(?<!\\*)(\\*)((?!\\1).)+\\1(?!\\*)", options: [])
private let boldEmphasisAsteriskRegex = try! NSRegularExpression(pattern: "(\\*){3}((?!\\1).)+\\1{3}", options: [])
private let blockquoteRegex = try! NSRegularExpression(pattern: "^>.*", options: [.anchorsMatchLines])
private let horizontalRuleRegex = try! NSRegularExpression(pattern: "\n\n(-{3}|\\*{3})\n", options: [])
private let unorderedListRegex = try! NSRegularExpression(pattern: "^(\\-|\\*)\\s", options: [.anchorsMatchLines])
private let orderedListRegex = try! NSRegularExpression(pattern: "^\\d*\\.\\s", options: [.anchorsMatchLines])
private let buttonRegex = try! NSRegularExpression(pattern: "<\\s*button[^>]*>(.*?)<\\s*/\\s*button>", options: [])
private let strikethroughRegex = try! NSRegularExpression(pattern: "(~)((?!\\1).)+\\1", options: [])
private let tagRegex = try! NSRegularExpression(pattern: "^\\[([^\\[\\]]*)\\]:", options: [.anchorsMatchLines])
private let footnoteRegex = try! NSRegularExpression(pattern: "\\[\\^(.*?)\\]", options: [])
// courtesy https://www.regular-expressions.info/examples.html
private let htmlRegex = try! NSRegularExpression(
    pattern: "<([A-Z][A-Z0-9]*)\\b[^>]*>(.*?)</\\1>",
    options: [.dotMatchesLineSeparators, .caseInsensitive]
)

#if os(macOS)
let codeFont = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .thin)
let headingTraits: NSFontDescriptor.SymbolicTraits = [.bold, .expanded]
let boldTraits: NSFontDescriptor.SymbolicTraits = [.bold]
let emphasisTraits: NSFontDescriptor.SymbolicTraits = [.italic]
let boldEmphasisTraits: NSFontDescriptor.SymbolicTraits = [.bold, .italic]
let secondaryBackground = NSColor.windowBackgroundColor
let lighterColor = NSColor.quaternaryLabelColor
let textColor = NSColor.labelColor

#else
let codeFont = UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .thin)
let headingFont = UIFont.systemFont(ofSize: 36, weight: .bold)
let heading2Font = UIFont.systemFont(ofSize: 28, weight: .bold)
let heading3Font = UIFont.systemFont(ofSize: 20, weight: .bold)
let headingTraits: UIFontDescriptor.SymbolicTraits = [.traitBold, .traitExpanded]
let boldTraits: UIFontDescriptor.SymbolicTraits = [.traitBold]
let emphasisTraits: UIFontDescriptor.SymbolicTraits = [.traitItalic]
let boldEmphasisTraits: UIFontDescriptor.SymbolicTraits = [.traitBold, .traitItalic]
let secondaryBackground = UIColor.secondarySystemBackground
let lighterColor = UIColor.quaternaryLabel
let hashTagColor = UIColor.quaternaryLabel
let blueColor = UIColor.blue
let textColor = UIColor.label

        
 


#endif

public extension Sequence where Iterator.Element == HighlightRule {
    static var markdown2: [HighlightRule] {
        [
            HighlightRule(pattern: inlineCodeRegex, formattingRules: [
                TextFormattingRule(key: .font, value: codeFont),
                TextFormattingRule(key: .foregroundColor, value: blueColor)
                                                                     ]),
            HighlightRule(pattern: codeBlockRegex, formattingRules: [
                TextFormattingRule(key: .font, value: codeFont),
                TextFormattingRule(key: .foregroundColor, value: blueColor)
            ]),
            HighlightRule(pattern: hashTag, formattingRules: [
                TextFormattingRule(fontTraits: headingTraits),
                TextFormattingRule(key: .kern, value: 0.5),
                TextFormattingRule(key: .foregroundColor, value: textColor),
                TextFormattingRule(key: .font, value: headingFont),
                
                
            ]),
            HighlightRule(pattern: hash2Tag, formattingRules: [
                TextFormattingRule(fontTraits: headingTraits),
                TextFormattingRule(key: .kern, value: 0.5),
                TextFormattingRule(key: .foregroundColor, value: textColor),
                TextFormattingRule(key: .font, value: heading2Font)
                
            ]),
            HighlightRule(pattern: hash3Tag, formattingRules: [
                TextFormattingRule(fontTraits: headingTraits),
                TextFormattingRule(key: .kern, value: 0.5),
                TextFormattingRule(key: .foregroundColor, value: textColor),
                TextFormattingRule(key: .font, value: heading3Font)
                
            ]),
            HighlightRule(pattern: headingRegex, formattingRules: [
                TextFormattingRule(fontTraits: headingTraits),
                TextFormattingRule(key: .kern, value: 0.5),
                TextFormattingRule(key: .foregroundColor, value: hashTagColor),
                TextFormattingRule(key: .font, value: headingFont)
                
            ]),
            HighlightRule(pattern: heading2Regex, formattingRules: [
                TextFormattingRule(fontTraits: headingTraits),
                TextFormattingRule(key: .kern, value: 0.5),
                TextFormattingRule(key: .foregroundColor, value: hashTagColor),
                TextFormattingRule(key: .font, value: heading2Font)
                
            ]),
            HighlightRule(pattern: heading3Regex, formattingRules: [
                TextFormattingRule(fontTraits: headingTraits),
                TextFormattingRule(key: .kern, value: 0.5),
                TextFormattingRule(key: .foregroundColor, value: hashTagColor),
                TextFormattingRule(key: .font, value: heading3Font)
                
            ]),
          
            HighlightRule(
                pattern: linkOrImageRegex,
                formattingRule: TextFormattingRule(key: .underlineStyle, value: NSUnderlineStyle.single.rawValue)
            ),
            HighlightRule(
                pattern: linkOrImageTagRegex,
                formattingRule: TextFormattingRule(key: .underlineStyle, value: NSUnderlineStyle.single.rawValue)
            ),
            HighlightRule(pattern: boldRegex, formattingRule: TextFormattingRule(fontTraits: boldTraits)),
            HighlightRule(
                pattern: asteriskEmphasisRegex,
                formattingRule: TextFormattingRule(fontTraits: emphasisTraits)
            ),
            HighlightRule(
                pattern: underscoreEmphasisRegex,
                formattingRule: TextFormattingRule(fontTraits: emphasisTraits)
            ),
            HighlightRule(
                pattern: boldEmphasisAsteriskRegex,
                formattingRule: TextFormattingRule(fontTraits: boldEmphasisTraits)
            ),
            HighlightRule(
                pattern: blockquoteRegex,
                formattingRule: TextFormattingRule(key: .backgroundColor, value: secondaryBackground)
            ),
            HighlightRule(
                pattern: horizontalRuleRegex,
                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
            ),
            HighlightRule(
                pattern: unorderedListRegex,
                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
            ),
            HighlightRule(
                pattern: orderedListRegex,
                formattingRules: [
                    TextFormattingRule(key: .foregroundColor, value: lighterColor),
                    TextFormattingRule(key: .font, value: headingFont)
                ]
                
            ),
            HighlightRule(
                pattern: buttonRegex,
                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
            ),
            HighlightRule(pattern: strikethroughRegex, formattingRules: [
                TextFormattingRule(key: .strikethroughStyle, value: NSUnderlineStyle.single.rawValue),
                TextFormattingRule(key: .strikethroughColor, value: textColor)
            ]),
            HighlightRule(
                pattern: tagRegex,
                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
            ),
            HighlightRule(
                pattern: footnoteRegex,
                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
            ),
            HighlightRule(pattern: htmlRegex, formattingRules: [
                TextFormattingRule(key: .font, value: codeFont),
                TextFormattingRule(key: .foregroundColor, value: lighterColor)
            ])
        ]
    }
}
