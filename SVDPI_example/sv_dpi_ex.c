#include <stdio.h>
#include <stdlib.h>
#include <svdpi.h>

//using namespace std;

extern "C" void sv_method();

extern "C" void cpp_method()
{
	printf("\t HELLO from C++ file\n");
	sv_method();
}

extern "C" int factorial(int num)
{
	if(num==1)
		return 1;
	else return num*factorial(num);
}
