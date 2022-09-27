// Roberto Ramirez-Diaz

// The controller module for the wave drawer.
// The control signals it sends to the datapath module for
// the wave drawer are 'init', 'draw, 'idle', and 'erase'.
// The status signals it reads are 'start', 'done', and 'invalidate'
module wave_drawer_controller
(
    input logic clk, reset, start, done, invalidate,
    output logic init, draw, idle, erase // Control signals
);
    // State Encodings
    enum {INIT, DRAW, IDLE, ERASE} ps, ns; // Present state, next state

    // FSM Transition Logic
    always_comb begin
        case (ps)

            INIT:   if (start)
                        ns = DRAW;
                    else
                        ns = ps;
                
            DRAW:   if (done) // x == 1
                        ns = IDLE;
                    else
                        ns = ps;

            IDLE:   if (invalidate) // count > DURATION
                        ns = ERASE;
                    else
                        ns = ps;

            ERASE:  if (done)
                        ns = DRAW;
                    else
                        ns = ps;

            default:    ns = INIT;
        
        endcase
    end

    // Control and communication signal assignments
    always_comb begin
        init = (ps == INIT);
        draw = (ps == DRAW);
        idle = (ps == IDLE);
        erase = (ps == ERASE);
    end

    // Sequential Logic
    always_ff @(posedge clk) begin
        if (reset) 
            ps <= INIT; 
        else 
            ps <= ns;
    end

endmodule


// Testbench
module wave_drawer_controller_testbench();
 	// Set up testing Logic
    logic clk, reset, start, done, invalidate;
    logic init, draw, idle, erase; // Control signals

    wave_drawer_controller dut (clk, reset, start, done, invalidate, init, draw, idle, erase);

 	parameter CLK_Period = 100;
 	initial begin
 		clk <= 1'b0;
 		forever #(CLK_Period/2) clk <= ~clk;
 	end
 	integer i;
 	initial begin 
 		reset <= 0;	start <= 0; done <= 0; invalidate <= 0; @(posedge clk);

        repeat(5) @(posedge clk)
        
        // Test the start signal being on
        reset <= 0;	start <= 1; done <= 0; invalidate <= 0; @(posedge clk);
                                                            @(posedge clk);
        // Test first done
        reset <= 0;	start <= 0; done <= 1; invalidate <= 0; @(posedge clk);
        reset <= 0;	start <= 0; done <= 0; invalidate <= 0; @(posedge clk);

        reset <= 0;	start <= 0; done <= 0; invalidate <= 0; @(posedge clk);

        // Test invalidate 
        reset <= 0;	start <= 0; done <= 0; invalidate <= 1; @(posedge clk);
        reset <= 0;	start <= 0; done <= 0; invalidate <= 0; @(posedge clk);

         // Test second done
        reset <= 0;	start <= 0; done <= 1; invalidate <= 0; @(posedge clk);
        reset <= 0;	start <= 0; done <= 0; invalidate <= 0; @(posedge clk);

        reset <= 0;	start <= 0; done <= 0; invalidate <= 0; @(posedge clk);
        reset <= 0;	start <= 0; done <= 0; invalidate <= 0; @(posedge clk);

        // Test reset
        reset <= 1;	start <= 0; done <= 0; invalidate <= 0; @(posedge clk);
						
																
			repeat(5) @(posedge clk)
        
                                        

      
		$stop;
	end


 endmodule  


