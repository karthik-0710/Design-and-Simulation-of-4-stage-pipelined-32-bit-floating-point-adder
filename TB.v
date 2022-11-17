`timescale 1ns / 10ps
module tieee();
	reg [15:0]Number173, Number273;
	reg reset, clk73;
	wire [15:0]result73;
	
	SinglePointFloatingPointAdder ia1(clk73,reset,Number173,Number273,result73);
	
	always 
	#2 clk73 = ~clk73;
	
	initial begin
	#3 clk73=1;
           reset=1;
        
        #1 reset=0;
           
    Number173 = 16'b0101011000100000;   //98
    Number273 = 16'b0101010101001000;   //169
    // Expected output = 16'b0101110001011000 = 267

    #5;
    Number173 = 16'b01001011000110000;   // 99
    Number273 = 16'b11010010110010000;   // -89.0
    // Expected output = 16'b0100100000000000= 10

    #5;
    Number173 = 16'b1101000110100000;   // -45
    Number273 = 16'b0101010011110000;   // 79
    // Expected output = 16'b0101000000000000= 34

    #5;
    Number173 = 16'b1101110001101100;   // -283.0
    Number273 = 16'b1101000110100000;  // -66.0
    // Expected output = 16'b1101110101110100 = -349.0

    #5;
    Number173 = 16'b0000000000000000;   // 0
    Number273 = 16'b0000000000000000;   // 0
    // Expected output = 16'b0000000000000000 = 0

    #5;
    Number173 = 16'b0000000000000000;   // 0
    Number273 = 16'b1101011101010000;   // -117
    // Expected output = 16'b1101011101010000 = -117

    #5;
    Number173 = 16'b1101011011100010;   // -110.125
    Number273 = 16'b0101011000111111;   // 99.87
    // Expected output = 16'b1100100100100000= -10.25

    #5;
    Number173 = 16'b0101011011101110;  // 110.875
    Number273 = 16'b0101011000110010;  // 99.125
    // Expected output = 16'b0101101010010000= 210.0

    #12 $finish;

	end

	initial begin
		$dumpfile("dump.vcd");
      $dumpvars(0);
	end
endmodule
