// swiftlint:disable all
import Amplify
import Foundation

public struct LastMessage: Embeddable {
  var body: String
  var datetime: Temporal.DateTime
  var projectId: String
}