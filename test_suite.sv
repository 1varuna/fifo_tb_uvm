/*
* File: test.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Test Suite containing all test files
* Disable comment to run test
*/

// Include and Import TB files
`include "fifo_tb_pkg.sv"
import fifo_tb_pkg::*;

`include "test.sv"		// Random test

`include "write_only_test.sv"	// Write only test

`include "write_read_test.sv"	// Test to verify read after write
