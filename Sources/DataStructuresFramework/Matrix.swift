import Foundation

/// A class representing a 2D matrix with rows and columns.
public class Matrix {

    /// The data storage for the matrix.
    private var data: [[Double]]

    /// The number of rows in the matrix.
    public let rows: Int

    /// The number of columns in the matrix.
    public let columns: Int

    /// Initializes a matrix with specified dimensions and an initial value.
    /// - Parameters:
    ///   - rows: The number of rows in the matrix.
    ///   - columns: The number of columns in the matrix.
    ///   - initialValue: The value to initialize all elements. Defaults to `0.0`.
    public init(rows: Int, columns: Int, initialValue: Double = 0.0) {
        self.rows = rows
        self.columns = columns
        self.data = Array(repeating: Array(repeating: initialValue, count: columns), count: rows)
    }

    /// Initializes a matrix from a 2D array.
    /// - Parameters:
    ///   - array: A 2D array of `Double` values.
    /// - Throws: `MatrixError.invalidDimensions` if the array is empty or rows have inconsistent column counts.
    public init(fromArray array: [[Double]]) throws {
        guard let firstRow = array.first else {
            throw MatrixError.invalidDimensions
        }
        let columnCount = firstRow.count
        guard array.allSatisfy({ $0.count == columnCount }) else {
            throw MatrixError.invalidDimensions
        }
        self.rows = array.count
        self.columns = columnCount
        self.data = array
    }

    public subscript(row: Int, column: Int) -> Double {
        get {
            guard isValidIndex(row: row, column: column) else {
                fatalError("Index out of bounds")
            }
            return data[row][column]
        }
        set {
            guard isValidIndex(row: row, column: column) else {
                fatalError("Index out of bounds")
            }
            data[row][column] = newValue
        }
    }

    private func isValidIndex(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    /// Transposes a matrix.
    /// - Returns: transposed matrix.
    public func transpose() -> Matrix {
        let transposed = Matrix(rows: columns, columns: rows)
        for i in 0..<rows {
            for j in 0..<columns {
                transposed[j, i] = self[i, j]
            }
        }
        return transposed
    }

    /// Adds two matrices element-wise and returns a new matrix.
    /// - Parameters:
    ///   - lhs: The left-hand matrix.
    ///   - rhs: The right-hand matrix.
    /// - Throws: `MatrixError.dimensionsMismatch` if the matrices' dimensions do not match.
    /// - Returns: A new matrix representing the element-wise sum of `lhs` and `rhs`.
    public static func + (lhs: Matrix, rhs: Matrix) throws -> Matrix {
        guard lhs.rows == rhs.rows && lhs.columns == rhs.columns else {
            throw MatrixError.dimensionsMismatch
        }
        let result = Matrix(rows: lhs.rows, columns: lhs.columns)
        for i in 0..<lhs.rows {
            for j in 0..<lhs.columns {
                result[i, j] = lhs[i, j] + rhs[i, j]
            }
        }
        return result
    }

    /// Subtracts two matrices element-wise and returns a new matrix.
    /// - Parameters:
    ///   - lhs: The left-hand matrix.
    ///   - rhs: The right-hand matrix.
    /// - Throws: `MatrixError.dimensionsMismatch` if the matrices' dimensions do not match.
    /// - Returns: A new matrix representing the element-wise difference of `lhs` and `rhs`.
    public static func - (lhs: Matrix, rhs: Matrix) throws -> Matrix {
        guard lhs.rows == rhs.rows && lhs.columns == rhs.columns else {
            throw MatrixError.dimensionsMismatch
        }
        let result = Matrix(rows: lhs.rows, columns: lhs.columns)
        for i in 0..<lhs.rows {
            for j in 0..<lhs.columns {
                result[i, j] = lhs[i, j] - rhs[i, j]
            }
        }
        return result
    }

    /// Multiplies a matrix by a scalar (each element of the matrix is multiplied by the scalar).
    /// - Parameters:
    ///   - lhs: The matrix to be multiplied.
    ///   - scalar: The scalar to multiply the matrix by.
    /// - Returns: A new matrix representing the result of `lhs * scalar`.
    public static func * (lhs: Matrix, scalar: Double) -> Matrix {
        let result = Matrix(rows: lhs.rows, columns: lhs.columns)
        for i in 0..<lhs.rows {
            for j in 0..<lhs.columns {
                result[i, j] = lhs[i, j] * scalar
            }
        }
        return result
    }

    /// Multiplies two matrices together and returns the resulting matrix.
    /// - Parameters:
    ///   - lhs: The left-hand matrix.
    ///   - rhs: The right-hand matrix.
    /// - Throws: `MatrixError.dimensionsMismatch` if the number of columns in `lhs` does not match the number of rows in `rhs`.
    /// - Returns: A new matrix representing the product of `lhs` and `rhs`.
    public static func * (lhs: Matrix, rhs: Matrix) throws -> Matrix {
        guard lhs.columns == rhs.rows else {
            throw MatrixError.dimensionsMismatch
        }
        let result = Matrix(rows: lhs.rows, columns: rhs.columns)
        for i in 0..<lhs.rows {
            for j in 0..<rhs.columns {
                for k in 0..<lhs.columns {
                    result[i, j] += lhs[i, k] * rhs[k, j]
                }
            }
        }
        return result
    }

    /// Compares two matrices for equality. Two matrices are considered equal if they have the same dimensions and each corresponding element is equal.
    /// - Parameters:
    ///   - lhs: The left-hand matrix.
    ///   - rhs: The right-hand matrix.
    /// - Returns: `true` if the matrices are equal, `false` otherwise.
    public static func == (lhs: Matrix, rhs: Matrix) -> Bool {
        guard lhs.rows == rhs.rows && lhs.columns == rhs.columns else {
            return false
        }
        for i in 0..<lhs.rows {
            for j in 0..<lhs.columns where lhs[i, j] != rhs[i, j] {
                    return false
            }
        }
        return true
    }

    /// Prints a matrix.
    public func printMatrix() {
        for row in data {
            print(row)
        }
    }

    private enum MatrixError: Error {
        case invalidDimensions
        case dimensionsMismatch
    }
}
