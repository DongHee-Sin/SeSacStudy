//
//  FontStyle.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import Foundation


enum FontStyle {
    case display_R20
    case title1_M16
    case title2_R16
    case title3_M14
    case title4_R14
    case title5_M12
    case title6_R12
    
    case body1_M16
    case body2_R16
    case body3_R14
    case body4_R12
    
    case caption_R10
}




extension FontStyle {
    
    var size: CGFloat {
        switch self {
        case .display_R20:
            return 20
        case .title1_M16, .title2_R16, .body1_M16, .body2_R16:
            return 16
        case .title3_M14, .title4_R14, .body3_R14:
            return 14
        case .title5_M12, .title6_R12, .body4_R12:
            return 12
        case .caption_R10:
            return 10
        }
    }
}




extension FontStyle {
    
    var weight: NotoSansCJK {
        switch self {
        case .display_R20, .title2_R16, .title4_R14, .title6_R12, .body2_R16, .body3_R14, .body4_R12, .caption_R10:
            return .Regular
        case .title1_M16, .title3_M14, .title5_M12, .body1_M16:
            return .Medium
        }
    }
}




extension FontStyle {
    
    var lineHeight: CGFloat {
        switch self {
        case .display_R20, .title1_M16, .title2_R16, .title3_M14, .title4_R14, .caption_R10:
            return self.size * 1.6
        case .title5_M12, .title6_R12:
            return self.size * 1.5
        case .body1_M16, .body2_R16:
            return self.size * 1.85
        case .body3_R14:
            return self.size * 1.7
        case .body4_R12:
            return self.size * 1.8
        }
    }
    
}
