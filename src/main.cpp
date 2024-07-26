// #include <iostream>
#include "c_functions.h"
#include "cpp_class.hpp"

int main() {

#if 0
    std::cout << "Mixed C/C++ Project Demonstration" << std::endl;

    // Using C++ class
    CppClass cpp_obj;
    cpp_obj.print_cpp_message("Hello from C++!");
    int mult_result = cpp_obj.multiply_numbers(5, 7);
    std::cout << "C++ multiplication result: " << mult_result << std::endl;

    // Using C functions
    print_c_message("Hello from C!");
    int add_result = add_numbers(10, 20);
    std::cout << "C addition result: " << add_result << std::endl;
#endif
  return 0;
}
