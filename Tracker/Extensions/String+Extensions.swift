//
//  Localization.swift
//  Tracker
//
//  Created by Admin on 12/5/23.
//

import Foundation

extension String {
    /// Из какого файла брать строку
    enum Source: String {
        /// Общий файл локализации для всех таргетов
        case common = "Localizable"
        /// Файл локализации для таргета
        case target = "Localizable (English)"
    }
    /**
     Получить локализацию для строки
     - parameter sourceType: источник строки, по умолчанию .common, т.е из общего LocalizableCommon.string
     - parameter comment: комментарий, по умолчанию ""
     - returns: локализованный текст
     */
    func localized(
        from source: Source = .common,
        _ bundle: Bundle = Bundle.main,
        _ comment: String = "") -> String {
        var notFoundValue = self
        // на всякий случай пытаемся найти значение в общем файле, вернем его если не будет найдено в source
        if source != .common {
            notFoundValue = NSLocalizedString(
                self,
                tableName: Source.common.rawValue,
                bundle: bundle,
                comment: comment)
        }
        return NSLocalizedString(
            self,
            tableName: source.rawValue,
            bundle: bundle,
            value: notFoundValue,
            comment: comment)
    }
    /**
      Метод возвращает локализованную строку со склонением подходящим для числительного
     - parameter number: число для которого будет подбираться склонение
     - parameter sourceType: источник строки, по умолчанию .common, т.е из общего LocalizableCommon
     - returns: локализованный текст
     */
    func localizedPlural(for number: Int, from source: Source = .common) -> String {
        // TODO: - пока нет локализации для stringsdict, чтобы правильно определять число задаем локаль русскую
        let locale = Locale(identifier: "ru_RU")
        return String(format: self.localized(from: source), locale: locale, arguments: [number])
    }
}
