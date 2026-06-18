import Foundation
import UIKit

extension String {
    /// Конвертирует сырую строку с HTML-тегами в отформатированную AttributedString
    var htmlToAttributedString: AttributedString {
        // Преобразуем строку в Data
        guard let data = data(using: .utf8) else { return AttributedString(self) }
        
        do {
            // Используем системный NSAttributedString для парсинга HTML
            let nsAttributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
            // Конвертируем старый NSAttributedString в современный SwiftUI AttributedString
            return AttributedString(nsAttributedString)
        } catch {
            // Если что-то пошло не так, возвращаем обычный текст без форматирования
            return AttributedString(self)
        }
    }
}
