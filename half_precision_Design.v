

module SinglePointFloatingPointAdder(input clk73, input reset73, input [15:0]Number173, input [15:0]Number273, output [15:0]result73);
    
    reg    [15:0] Numshift73; 
    reg    [4:0]  Largerexp73,Finalexpo73;
    reg    [9:0] Smallexpmantissa73,Smantissa73,Lmantissa73,Largemantissa73,Finalmant73;
    reg    [10:0] Addmant73,Add1mant73;
    reg    [4:0]  e173,e273;
    reg    [9:0] m173,m273;
    reg           s173,s273,Finalsign73;
    reg    [3:0]  renormshift73;
    integer signed   renormexp73;
    //reg           renormexp73;
    reg    [15:0] Result73;

    assign Result = Result73;


    always @(posedge clk73) begin
    //----------------stage 1----------------------
	e173 = Number173[14:10];
	e273 = Number273[14:10];
    	m173 = Number173[9:0];
	m273 = Number273[9:0];
	s173 = Number173[15];
	s273 = Number273[15];
        
        if (e173  > e273) begin
            Numshift73           = e173 - e273;              // mantissa shift
            Largerexp73           = e173;                     // lower exponent
            Smallexpmantissa73  = m273;
            Largemantissa73      = m173;
        end
        
        else begin
            Numshift73           = e273 - e173;
            Largerexp73           = e273;
            Smallexpmantissa73  = m173;
            Largemantissa73      = m273;
        end

	if (e173 == 0 | e273 ==0) begin
	    Numshift73 = 0;
	end
	else begin
	    Numshift73 = Numshift73;
	end
	
	//-------------------stage 2---------------------
    //if check both for normalization then append 1 and shift
	if (e173 != 0) begin
            Smallexpmantissa73  = {1'b1,Smallexpmantissa73[9:1]};
	    Smallexpmantissa73  = (Smallexpmantissa73 >> Numshift73);
        end
	else begin
	    Smallexpmantissa73 = Smallexpmantissa73;
	end

	if (e273!= 0) begin
            Largemantissa73 = {1'b1,Largemantissa73[9:1]};
	    Largemantissa73 = (Largemantissa73 >> Numshift73);
	end
	else begin
	    Largemantissa73 = Largemantissa73;
	end
		

    //---------------------stage 3-------------------
                                      
            if (Smallexpmantissa73  < Largemantissa73) begin
               
		Smantissa73 = Smallexpmantissa73;
		Lmantissa73 = Largemantissa73;
            end
            else begin
              
			
		Smantissa73 = Largemantissa73;
		Lmantissa73 = Smallexpmantissa73;
             end       
        //-----------------------stage 4------------------------
        //add the two mantissa's
	
	if (e173!=0 & e273!=0) begin
		if (s173 == s273) begin
        		Addmant73 = Smantissa73 + Lmantissa73;
		end else begin
			Addmant73 = Lmantissa73 - Smantissa73;
		end
	end	
	else begin
		Addmant73 = Lmantissa73;
	end
         
	//renormalization for mantissa and exponent
	if (Addmant73[10]) begin
		renormshift73 = 2'd1;
		renormexp73 = 2'd1;
	end
	else if (Addmant73[9])begin
		renormshift73 = 2'd2;
		renormexp73 = 0;		
	end
	else if (Addmant73[8])begin
		renormshift73 = 2'd3; 
		renormexp73 = -1;
	end 
	else if (Addmant73[7])begin
		renormshift73 = 2'd4; 
		renormexp73 = -2;		
	end  
	else if (Addmant73[6])begin
		renormshift73 = 2'd5; 
		renormexp73 = -3;		
	end      

	//-------------------------stage 5----------------------

        Finalexpo73 =  Largerexp73 + renormexp73;
	
	Add1mant73 = Addmant73 << renormshift73;

	Finalmant73 = Add1mant73[10:1];  	

        
	if (s173 == s273) begin
		Finalsign73 = s173;
	end 

	if (e173 > e273) begin
		Finalsign73 = s173;	
	end else if (e273 > e173) begin
		Finalsign73 = s273;
	end
	else begin

		if (m173 > m273) begin
			Finalsign73 = s173;		
		end else begin
			Finalsign73 = s273;
		end
	end	
	
	result73 = {Finalsign73,Finalexpo73,Finalmant73}; 
	//result73 = result73 - 16'b0000010000000000;

    end
    
    always @(posedge clk73) begin
            if(reset73) begin
                Numshift73 <= #1 0;
            end
    end
    
endmodule
