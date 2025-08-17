import Foundation
import Compression

struct PlantUMLEncoder {
    static func encode(_ source: String) -> String? {
        guard let data = source.data(using: .utf8),
              let compressed = deflate(data) else {
            return nil
        }
        return encode64(compressed)
    }

    private static func deflate(_ data: Data) -> Data? {
        var output = Data()
        let bufferSize = 64 * 1024
        let destinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { destinationBuffer.deallocate() }

        let compressedSize = data.withUnsafeBytes { (sourceBuffer: UnsafeRawBufferPointer) -> Int in
            guard let sourcePointer = sourceBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return 0
            }
            return compression_encode_buffer(destinationBuffer, bufferSize,
                                             sourcePointer, data.count,
                                             nil,
                                             COMPRESSION_ZLIB)
        }

        guard compressedSize > 0 else { return nil }
        output.append(destinationBuffer, count: compressedSize)
        return output
    }

    private static func encode64(_ data: Data) -> String {
        let alphabet = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_")
        var result = ""

        var i = 0
        while i < data.count {
            let b1 = Int(data[i])
            let b2 = i + 1 < data.count ? Int(data[i + 1]) : 0
            let b3 = i + 2 < data.count ? Int(data[i + 2]) : 0

            let c1 = b1 >> 2
            let c2 = ((b1 & 0x3) << 4) | (b2 >> 4)
            let c3 = ((b2 & 0xF) << 2) | (b3 >> 6)
            let c4 = b3 & 0x3F

            result.append(alphabet[c1])
            result.append(alphabet[c2])
            result.append(i + 1 < data.count ? alphabet[c3] : "=")
            result.append(i + 2 < data.count ? alphabet[c4] : "=")

            i += 3
        }

        return result
    }
}
