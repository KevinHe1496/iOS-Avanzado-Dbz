//
//  TransformationDetailViewModel.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 28/10/24.
//

import Foundation

enum StatusTransformationDetail {
    case loading
    case locationUpdated
    case error(_ reason: String)
    case none
}

final class TransformationDetailViewModel {
    
    var transformation: Transformation
    var transformationStatus: Binding<StatusTransformationDetail> = Binding(.none)
    
    init(transformation: Transformation) {
        self.transformation = transformation
    }
    
    
}