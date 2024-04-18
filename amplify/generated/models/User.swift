// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var useramen: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      useramen: String) {
    self.init(id: id,
      useramen: useramen,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      useramen: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.useramen = useramen
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}