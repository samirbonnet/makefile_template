#include "cpp_class.hpp"
#include <iostream>

void CppClass::print_cpp_message(const std::string& message) const {
    std::cout << "C++ class says: " << message << std::endl;
}

int CppClass::multiply_numbers(int a, int b) const {
    return a * b;
}