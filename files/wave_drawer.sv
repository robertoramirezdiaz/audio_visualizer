// Roberto Ramirez-Diaz

// The wave drawer module, which begins drawing the sound waveo of 'wave_signal'
// via 'x' and 'y'
// It also sets 'pen' to true when drawing, and false when it should erase. it also
// Only starts reading values from 'wave_signal' when enable is true.
module wave_drawer #(parameter WIDTH = 24, BUFFER_SIZE = 640, DIV = 15, DURATION = 10, N = 16)
(
    input logic clk, reset, start, enable,
    input logic signed [WIDTH - 1:0] wave_signal, // The sound wave data
    output logic pen,
    output logic [9:0] x,
	output logic [8:0] y
);

    // Control and status signals
    logic done, invalidate;
    logic init, draw, idle, erase; 
    // Averaged wave_signal that the datapath module will use
    logic signed [WIDTH - 1:0] signal;

    // FIR filter to process our signal to get a smoother wave
    fir #(WIDTH, N) signal_fir (.clk, .reset, .enable, .data_in(wave_signal), .data_out(signal));
    // The datapath component of the wave_drawer. It is responsible for assigning the x and y values to drawn as well as the color 
    wave_drawer_datapath #(WIDTH, BUFFER_SIZE, DIV, DURATION) datapath (.clk, .reset, .init, .draw, .idle, .erase, .signal, .done, .invalidate, .pen, .x, .y);
    // The controller component of the wave_drawer. It tells the datapath module what calculations and assignments to perform
    wave_drawer_controller controller (.clk, .reset, .start, .done, .invalidate, .init, .draw, .idle, .erase);

endmodule

// Testbench
module wave_drawer_testbench();
 	// Set up testing Logic
    parameter WIDTH = 24, BUFFER_SIZE = 480, DIV = 15, DURATION = 10, N = 16;

    logic clk, reset, start, enable;
    logic signed [WIDTH - 1:0] wave_signal; // The sound wave data
    logic pen;
    logic [9:0] x;
    logic [8:0] y;
    
    // Instantiate dut
    wave_drawer #(WIDTH, BUFFER_SIZE, DIV, DURATION, N) dut (clk, reset, start, enable, wave_signal,  pen, x, y);

 	parameter CLK_Period = 100;
 	initial begin
 		clk <= 1'b0;
 		forever #(CLK_Period/2) clk <= ~clk;
 	end


 	integer i;
 	initial begin 
 		reset <= 1; wave_signal <= 0; enable <= 1; @(posedge clk);
		reset <= 0; wave_signal <= 0; @(posedge clk);

                    start <= 1;  @(posedge clk);
							
        repeat(3) begin
			  for (i = 1; i < 4*480; i++) begin
					wave_signal <= i; @(posedge clk);
			  end
											  @(posedge clk);
			  for (i = 1; i > -4*480; i--) begin
					wave_signal <= i; @(posedge clk);
			  end  
		 end

		$stop;
	end


 endmodule  
