import SwiftUI

extension Color {
    static let laylaCream   = Color("Colors/LaylaCream",   bundle: .main)
    static let laylaSurface = Color("Colors/LaylaSurface", bundle: .main)
    static let laylaOlive   = Color("Colors/LaylaOlive",   bundle: .main)
    static let laylaGold    = Color("Colors/LaylaGold",    bundle: .main)
    static let laylaRose    = Color("Colors/LaylaRose",    bundle: .main)
    static let laylaInk     = Color("Colors/LaylaInk",     bundle: .main)
    static let laylaMuted   = Color("Colors/LaylaMuted",   bundle: .main)
    static let laylaBorder  = Color("Colors/LaylaBorder",  bundle: .main)
    static let laylaSuccess = Color("Colors/LaylaSuccess", bundle: .main)
    static let laylaTagBg   = Color("Colors/LaylaTagBg",   bundle: .main)
}

// Surface the tokens through ShapeStyle so SwiftUI APIs like
// `.foregroundStyle(.laylaInk)` resolve via implicit member lookup.
extension ShapeStyle where Self == Color {
    static var laylaCream:   Color { .laylaCream   }
    static var laylaSurface: Color { .laylaSurface }
    static var laylaOlive:   Color { .laylaOlive   }
    static var laylaGold:    Color { .laylaGold    }
    static var laylaRose:    Color { .laylaRose    }
    static var laylaInk:     Color { .laylaInk     }
    static var laylaMuted:   Color { .laylaMuted   }
    static var laylaBorder:  Color { .laylaBorder  }
    static var laylaSuccess: Color { .laylaSuccess }
    static var laylaTagBg:   Color { .laylaTagBg   }
}
