#include "string_stack.h"
#include <stdlib.h>
#include <string.h>
#include <assert.h>


struct _Stack {
    char** elements;
    int size;
    int capacity;
};


stack_response create() {
    stack_response result;
    
    stack new_stack = malloc(sizeof(struct _Stack));
    if (!new_stack) {
        result.code = out_of_memory;
        result.stack = NULL;
        return result;
    }

    new_stack->capacity = 16;
    new_stack->size = 0;
    new_stack->elements = malloc(sizeof(char*) * new_stack->capacity);
    if (!new_stack->elements) {
        free(new_stack);
        result.code = out_of_memory;
        result.stack = NULL;
        return result;
    }

    result.code = success;
    result.stack = new_stack;
    return result;
}


int size(const stack s) {
    assert(s);
    return s->size;
}

bool is_empty(const stack s) {
    assert(s);
    return s->size == 0;
}

bool is_full(const stack s) {
    assert(s);
    return s->size >= MAX_CAPACITY;
}

response_code push(stack s, char* item) {
    assert(s);

    if (strlen(item) >= MAX_ELEMENT_BYTE_SIZE) {
        return stack_element_too_large;
    }

    if (is_full(s)) {
        return stack_full;
    }

    if (s->size >= s->capacity) {
        int new_capacity = s->capacity * 2;
        if (new_capacity > MAX_CAPACITY) {
            new_capacity = MAX_CAPACITY;
        }

        char** new_elements = realloc(s->elements, sizeof(char*) * new_capacity);
        if (!new_elements) {
            return out_of_memory;
        }

        s->elements = new_elements;
        s->capacity = new_capacity;
    }

    s->elements[s->size] = malloc(strlen(item) + 1);
    if (!s->elements[s->size]) {
        return out_of_memory;
    }

    strcpy(s->elements[s->size], item);
    s->size++;
    return success;
}

string_response pop(stack s) {
    string_response result;
    
    if (is_empty(s)) {
        result.code = stack_empty;
        result.string = NULL;
        return result;
    }

    result.string = s->elements[s->size - 1];
    s->size--;

    if (s->size < s->capacity / 4 && s->capacity > 16) {
        int new_capacity = s->capacity / 2;
        if (new_capacity < 16) {
            new_capacity = 16;
        }

        char** new_elements = realloc(s->elements, sizeof(char*) * new_capacity);
        if (new_elements) {
            s->elements = new_elements;
            s->capacity = new_capacity;
        }
    }

    result.code = success;
    return result;
}

void destroy(stack* s) {
    if (!s || !*s) {
        return;
    }

    for (int i = 0; i < (*s)->size; i++) {
        free((*s)->elements[i]);
    }

    free((*s)->elements);
    free(*s);
    *s = NULL;
}
