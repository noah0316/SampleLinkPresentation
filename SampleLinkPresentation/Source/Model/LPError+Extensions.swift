//
//  LPError+Extensions.swift
//  SampleLinkPresentation
//
//  Created by Noah on 2022/02/19.
//

import Foundation
import LinkPresentation

extension LPError {
  var prettyString: String {
    switch self.code {
    case .metadataFetchCancelled:
      return "Metadata fetch cancelled."
    case .metadataFetchFailed:
      return "Metadata fetch failed."
    case .metadataFetchTimedOut:
      return "Metadata fetch timed out."
    case .unknown:
      return "Metadata fetch unknown."
    @unknown default:
      return "Metadata fetch unknown."
    }
  }
}
