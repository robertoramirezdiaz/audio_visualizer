// Roberto Ramirez-Diaz

/** A generic averaging FIR filter.
    The registers only take samples when the enable signal is true
    and clears them otherwise on the next clock cycle. It averages
    the previous N samples of data and the currently inputted data. **/
module fir #(parameter WIDTH = 24, N = 8)
(
    input logic clk, reset, enable,
    input logic signed [WIDTH - 1:0] data_in,
    output logic signed [WIDTH - 1:0] data_out
);
    // The log base of N, to determine the number of shifts needed
    parameter log2N = $clog2(N);
    integer i;
    
    // 2-D Buffer to hold all samples
    logic signed [WIDTH - 1:0] buffer [N - 1: 0]; 
    // The current sample, divided
    logic signed [WIDTH - 1:0] divSample;
    // The accumulator as shown in the spec diagram
    logic signed [WIDTH - 1:0] accumulator;

    // Assign the incoming dividied sample and the output data
    always_comb begin 
        divSample = {{log2N{data_in[WIDTH - 1]}}, data_in[WIDTH - 1:log2N]};
        data_out = (~buffer[N - 1] +  1) + accumulator + divSample;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            accumulator <= '0; // Clear accumulator
            // Clear the buffer
            for(i = 0; i < N; i++) begin
                buffer[i] <= '0;
            end    
        end else if (enable) begin
            // Adjust the accumulator
            accumulator <= (~buffer[N - 1] +  1) + accumulator + divSample;
            // Add the current sample to the buffer
            buffer[0] <= divSample;
				// Push all the samples an index forward
		      for(i = 1; i < N; i++) begin
                buffer[i] <= buffer[i - 1];
            end
		  
        end 
    end
	 

endmodule

module fir_testbench ();
    parameter WIDTH = 24;
    // Logic setup
    logic clk, reset, enable;
    logic signed [WIDTH - 1:0] data_in;
    logic signed [WIDTH - 1:0] data_out;

    // Init dut
    fir dut (clk, reset, enable, data_in, data_out);

    //clock setup
	parameter clock_period = 100;
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;			
	end //initial

	// Tests
	integer i, j, k;
	initial begin 
		reset <= 1;         		                    @(posedge clk);
		reset <= 0; enable <= 0;                        @(posedge clk);	
        // Wait until sending enable signal
                                                        @(posedge clk);	
                                                        @(posedge clk);	
                                                        @(posedge clk);	
                    enable <= 1;      data_in <= 0;     @(posedge clk);
        // Start sampling
        for (i = 0; i < 200; i++) begin
            data_in <= i; @(posedge clk);
        end
     
                    enable <= 0;                        @(posedge clk);	
                                                        @(posedge clk);	
                                                        @(posedge clk);	
		                                                @(posedge clk);	
                                                        @(posedge clk);				

		$stop;
	end
endmodule
