// Roberto Ramirez-Diaz

/** The Top Level Module: Communicates with the audio interface - samples audio, draws
    the selected audio channel (chosen by SW 1) on the VGA and writes audio for playback.
																			**/
module DE1_SoC (CLOCK_50, CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT,
	AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT,
	KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS
	);

	input logic CLOCK_50, CLOCK2_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;

	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;

	
	// Local wires
	logic read_ready, write_ready, read, write;
	logic signed [23:0] readdata_left, readdata_right, wave_signal;
	logic signed [23:0] writedata_left, writedata_right;
	logic reset;
    logic pen;

	// Parameters for wave_drawer
	// WIDTH is signal size
	// BUFFER_SIZE is the number of y values that should be stored for drawing
	// DIV is the mapping function divisor (240 - (signal / 2^(DIV)))
	// DURATION is the time each image is shown before being erased
	// N is the number of values of signal that are average to be drawn
	parameter WIDTH = 24, BUFFER_SIZE = 640, DIV = 15, DURATION = 2**14, N = 2048;
	
	// The wave drawer module: starts drawing when start is true and only reads data from the signal when enabled
	// The signal read is the read_data (one channel) and it outputs whether it should draw through 'pen'.
	// It also outputs the x and y values to be drawn
	wave_drawer #(WIDTH, BUFFER_SIZE, DIV, DURATION, N) drawer (.clk(CLOCK_50), .reset, .start(SW[0]), .enable(read), .wave_signal,  .pen, .x, .y);


	// Data assignments
	always_comb begin
	    case(SW[1])
			1'b1: begin // SW 1 draws the right channel
				wave_signal = readdata_right;
				VGA_R = r;
				VGA_G = g;
				VGA_B = '0;
			end
			default: begin // default draws the left channel
			    wave_signal = readdata_left;
			    VGA_R = '0;
				VGA_G = g;
				VGA_B = b;
			end
		endcase
			
    	writedata_left = readdata_left;
    	writedata_right = readdata_right;
    	
    	HEX0 = '1;
	    HEX1 = '1;
	    HEX2 = '1;
	    HEX3 = '1;
	    HEX4 = '1;
	    HEX5 = '1;
	    
	    LEDR = SW;
	
    	// only read or write when both are possible
        read = read_ready & write_ready;
    	write = read_ready & write_ready;
	    reset = 0;
	end

    // VGA Code
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	logic frame_start;
	
	VGA_framebuffer fb(.clk(CLOCK_50), .rst(1'b0), .x, .y,
				.pixel_color(pen), .pixel_write(1'b1), .dfb_en, .frame_start,
				.VGA_R(r), .VGA_G(g), .VGA_B(b), .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_N, .VGA_SYNC_N);

/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		1'b0,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		1'b0,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		1'b0,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


