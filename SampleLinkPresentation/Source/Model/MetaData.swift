//
//  MetaData.swift
//  SampleLinkPresentation
//
//  Created by Noah on 2022/02/19.
//

import Foundation
import LinkPresentation

struct MetaData {
    static func fetchMetaData(for url: URL, completion: @escaping ((Result<LPLinkMetadata ,LPError>) -> Void)) {
        let metaDataProvider = LPMetadataProvider()
        metaDataProvider.timeout = 3
        
        metaDataProvider.startFetchingMetadata(for: url) { metadata, error in
            guard let metadata = metadata, error == nil
            else {
                if let error = error as? LPError {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(metadata))
        }
    }
    
}
