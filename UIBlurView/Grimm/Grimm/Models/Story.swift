
import Foundation

class Story {
  var title: String
  var content: String
  
  init(title: String, content: String) {
    self.title = title
    self.content = content
  }
  
  static func loadStories(_ completion: (@escaping ([Story]) -> Void)) {
    
    let path = Bundle.main.bundlePath
    let manager = FileManager.default
    
    var stories: [Story] = []
    
    if var contents = try? manager.contentsOfDirectory(atPath: path) {
      contents = contents.sorted(by: <)
      
      for file in contents {
        
        if file.hasSuffix(".grm") {
          
          guard let filePath = URL(string: "file://" + path)?.appendingPathComponent(file) else { continue }
          let title = String(file.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true)[0])
          
          if let content = try? NSString(contentsOf: filePath, encoding: String.Encoding.utf8.rawValue) {
            let story = Story(title: title, content: content as String)
            stories.append(story)
          }
        }
      }
    }
    
    DispatchQueue.main.async {
      completion(stories)
    }
  }
  
}

extension Story: CustomStringConvertible {
  
  var description: String {
    return title
  }
  
}
