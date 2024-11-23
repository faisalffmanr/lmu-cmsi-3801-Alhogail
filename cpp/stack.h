#include <stdexcept>
#include <string>
#include <memory>
#include <algorithm>
using namespace std;

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
private:
    unique_ptr<T[]> elements;
    int capacity;
    int top;

    void reallocate(int new_capacity) {
        if (new_capacity > MAX_CAPACITY || new_capacity < INITIAL_CAPACITY) {
            throw overflow_error("Invalid reallocation size");
        }
        unique_ptr<T[]> new_elements = make_unique<T[]>(new_capacity);
        copy(elements.get(), elements.get() + top, new_elements.get());
        elements = move(new_elements);
        capacity = new_capacity;
    }

public:
    Stack() : elements(make_unique<T[]>(INITIAL_CAPACITY)), capacity(INITIAL_CAPACITY), top(0) {}

    int size() const { return top; }

    bool is_empty() const { return top == 0; }

    bool is_full() const { return top >= capacity; }

    void push(const T& item) {
        if (is_full()) {
            if (capacity >= MAX_CAPACITY) {
                throw overflow_error("Stack has reached maximum capacity");
            }
            reallocate(capacity * 2);
        }
        elements[top++] = item;
    }

    T pop() {
        if (is_empty()) {
            throw underflow_error("cannot pop from empty stack");
        }
        T item = elements[--top];

        if (top < capacity / 4 && capacity > INITIAL_CAPACITY) {
            reallocate(max(INITIAL_CAPACITY, capacity / 2));
        }
        return item;
    }
};
