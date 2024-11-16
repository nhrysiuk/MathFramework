import Foundation

/// A priority queue that stores elements with their priorities.
struct SimplePriorityQueue<Element: Comparable> {
    private var elements: [(element: Element, priority: Int)] = []

    /// Checks if the queue is empty.
    /// - Returns: `true` if the queue is empty, `false` otherwise.
    var isEmpty: Bool {
        return elements.isEmpty
    }

    /// Adds an element to the queue with a specified priority.
    /// - Parameter element: The element to add.
    /// - Parameter priority: The priority of the element. Lower values mean higher priority.
    mutating func enqueue(_ element: Element, withPriority priority: Int) {
        elements.append((element, priority))
    }

    /// Removes and returns the element with the highest priority.
    /// - Returns: The element with the highest priority, or `nil` if the queue is empty.
    mutating func dequeue() -> Element? {
        guard !isEmpty else { return nil }

        if let index = elements.enumerated().min(by: { $0.element.priority < $1.element.priority })?.offset {
            return elements.remove(at: index).element
        }

        return nil
    }

    /// Returns the element with the highest priority without removing it.
    /// - Returns: The element with the highest priority, or `nil` if the queue is empty.
    func peek() -> Element? {
        return elements.min(by: { $0.priority < $1.priority })?.element
    }
}