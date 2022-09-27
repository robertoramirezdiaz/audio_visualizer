// Roberto Ramirez-Diaz

// The datapath module for the wave_drawer module
// It is controllled by the controller through status signals and 
// performs the calculations at each state.
// The status signals sent to the controller are done and invalidate
module wave_drawer_datapath #(parameter WIDTH = 24, BUFFER_SIZE = 640, DIV = 15, DURATION = 10)
(
    input logic clk, reset,
    input logic init, draw, idle, erase, // Control signals
    input logic signed [WIDTH - 1:0] signal,
    output logic done, invalidate, pen, // Status signals
    output logic [9:0] x, // X-value of coordinate to be drawn
	output logic [8:0] y // Y-value of coordinate to be drawn
    
);
    integer i;
    // Idx, Counter
    logic [9:0] idx;
    logic [31:0] count;
    // 2-D Buffer to store y-values
    logic signed [WIDTH - 1:0] buffer [BUFFER_SIZE - 1: 0]; 

    logic signed [WIDTH - 1:0] y_buffer; // Y-value from buffer at idx
    logic signed [WIDTH - 1: 0] y_divided; // Y-value after being divided by 2^DIV to map to the VGA
	 
	logic signed [WIDTH - 1:0] first_condition; // Y value for first case
	logic signed [WIDTH - 1:0] second_condition; // Y-value for second case
	logic signed [WIDTH - 1:0] third_condition; // Y-value for third case

    // Sequential datapath logic
    always_ff @(posedge clk) begin
        if (reset || init) begin
            // Clear buffer
            for (i = 0; i < BUFFER_SIZE; i++) begin
                buffer[i] <= '0;
            end    
            // Clear x and y values
            x <= '0;
            y <= '0;
            // Clear the pen, count, and idx
            pen <= '0;
            count <= '0;
            idx <= '0;
        end else if (draw) begin
            x <= (BUFFER_SIZE - 1) - idx;

            if (240 + (~y_divided + 1) < 0) begin
                y <= first_condition[8:0];
            end else if (240 + (~y_divided + 1) > 480) begin
                y <= second_condition[8:0];
            end else begin
                y <= third_condition[8:0];
            end
            
            pen <= '1;
			
            if (done) begin
                idx <= 0;
            end else begin
                idx <= idx + 1;
            end

        end else if (idle) begin
            count <= count + 1;
            idx <= '0;
            x <= '0;
            y <= '0;
            pen <= '0;
        end else if (erase) begin
            x <= (BUFFER_SIZE - 1) - idx;

            if (240 + (~y_divided + 1) < 0) begin
                y <= first_condition[8:0];
            end else if (240 + (~y_divided + 1) > 480) begin
                y <= second_condition[8:0];
            end else begin
                y <= third_condition[8:0];
            end

            count <= '0;

            if (done) begin
                idx <= 0;
                // Shift Buffer
                // Add the current sample signal to the buffer
                buffer[0] <= signal;
				// Push all the samples an index forward
		        for (i = 1; i < BUFFER_SIZE; i++) begin
                    buffer[i] <= buffer[i - 1]; 
                end 

            end else begin
                idx <= idx + 1;
            end
        end
    end

    // Combinational datapath logic	
    always_comb begin
        // Status signal assignments
        done = (x == 1);
        invalidate = (count > DURATION);

        // Intermediate values for calculating y_pos
        y_buffer = buffer[idx];
        y_divided =  {{DIV{y_buffer[WIDTH - 1]}}, y_buffer[WIDTH - 1:DIV]};
		// Y values for each case  
		first_condition = 0 + 1;
	    second_condition = 480 - 1;;
		third_condition = 240 + (~y_divided + 1);

    end
    
endmodule


// Testbench
module wave_drawer_datapath_testbench();
 	// Set up testing Logic
    parameter WIDTH = 24, BUFFER_SIZE = 480, DIV = 15;
    logic clk, reset, start, done, invalidate;
    logic init, draw, idle, erase; // Control signals
    logic signed [WIDTH - 1:0] signal;
    logic [9:0] x; // X-value of coordinate to be drawn
	logic [8:0] y;// Y-value of coordinate to be drawn
    logic pen;

    // Instantiate dut
    wave_drawer_datapath #(.WIDTH(WIDTH), .BUFFER_SIZE(BUFFER_SIZE), .DIV(15), .DURATION(10)) dut (clk, reset, init, draw, idle, erase, signal, done, invalidate, pen, x, y );
    // Instantiate controller
    wave_drawer_controller controller (clk, reset, start, done, invalidate, init, draw, idle, erase);

 	parameter CLK_Period = 100;
 	initial begin
 		clk <= 1'b0;
 		forever #(CLK_Period/2) clk <= ~clk;
 	end


 	integer i;
 	initial begin 
 		reset <= 1; signal <= 0; @(posedge clk);
		reset <= 0; signal <= 0; @(posedge clk);

                    start <= 1;  @(posedge clk);
							
        repeat(3) begin
			  for (i = 1; i < 4*480; i++) begin
					signal <= i; @(posedge clk);
			  end
											  @(posedge clk);
			  for (i = 1; i > -4*480; i--) begin
					signal <= i; @(posedge clk);
			  end  
		 end

		$stop;
	end


 endmodule  

