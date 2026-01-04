`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2026 05:11:11 PM
// Design Name: 
// Module Name: TL_System_Design
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Traffic light controller for a 4-way intersection with main road
//              priority and left-turn signals.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Added detailed comments for clarity
//////////////////////////////////////////////////////////////////////////////////

module TL_System_Design(
    // Defining the north/south lights to be on main road (prioritized)
    input wire clk,
    input wire reset,
    
    // Straight signals
    output reg northsouth_red, northsouth_yellow, northsouth_green,
    output reg eastwest_red,  eastwest_yellow,  eastwest_green,
    
    // Left-turn signals
    output reg northsouth_left_red, northsouth_left_yellow, northsouth_left_green,
    output reg eastwest_left_red,  eastwest_left_yellow,  eastwest_left_green
    );
    
    // State definitions for FSM
    parameter initial_state       = 4'b0000,  // NS left green is initial state
              ns_left_yellow      = 4'b0001,  // NS left yellow
              ns_straight_green   = 4'b0010,  // NS straight green
              ns_straight_yellow  = 4'b0011,  // NS straight yellow
              ew_left_green       = 4'b0100,  // EW left green
              ew_left_yellow      = 4'b0101,  // EW left yellow
              ew_straight_green   = 4'b0110,  // EW straight green
              ew_straight_yellow  = 4'b0111,  // EW straight yellow
              all_red             = 4'b1000;  // all red for safety

    reg [3:0] state;       // current state of FSM
    reg [3:0] prev_state;  // previous non-all-red state, needed for sequencing
    reg [3:0] next_state;  // next state of FSM
    
    // Timing parameters for each phase (Me and Suren defined these as it's our implementation)
    parameter left_green_time       = 5;   // number of clock cycles for left green
    parameter northsouth_green_time = 15;  // clock cycles for NS straight green
    parameter eastwest_green_time   = 10;  // clock cycles for EW straight green
    parameter yellow_time           = 2;   // clock cycles for yellow
    parameter all_red_time          = 2;   // clock cycles for all red

    reg [7:0] timer;    // simple counter for tracking how long current state has been active    
    
    // FSM sequential logic: update state and timer
    always @(posedge clk or posedge reset)
    begin
        if(reset) begin
            state <= initial_state;  // go to initial NS left green
            prev_state <= initial_state;
            timer <= 0;              // reset timer
        end
        else begin
            state <= next_state;     // advance to next state
            
            // remember last non-all-red state for sequencing
            if(state != all_red && next_state == all_red) begin
                prev_state <= state;
            end

            // reset timer if state changes, else increment
            if(state != next_state) begin
                timer <= 0;
            end
            else begin
                timer <= timer + 1; // count cycles in current state
            end
        end
    end
    
    // FSM combinational logic: determine next state based on timer
    always @(*) begin
        next_state = state;  // default is to stay in same state
        case (state)
            initial_state: begin
                if (timer >= left_green_time) begin
                    next_state = ns_left_yellow; // NS left turns done, go to yellow
                end
            end
            ns_left_yellow: begin
                if (timer >= yellow_time) begin
                    next_state = all_red; // safety red before next phase
                end
            end
            ns_straight_green: begin
                if (timer >= northsouth_green_time) begin
                    next_state = ns_straight_yellow; // NS straight done, yellow
                end
            end
            ns_straight_yellow: begin
                if (timer >= yellow_time) begin
                    next_state = all_red; // safety red
                end
            end
            ew_left_green: begin
                if (timer >= left_green_time) begin
                    next_state = ew_left_yellow; // EW left turn done
                end
            end
            ew_left_yellow: begin
                if (timer >= yellow_time) begin
                    next_state = all_red; // safety red
                end
            end
            ew_straight_green: begin
                if (timer >= eastwest_green_time) begin
                    next_state = ew_straight_yellow; // EW straight done
                end
            end
            ew_straight_yellow: begin
                if (timer >= yellow_time) begin
                    next_state = all_red; // safety red
                end
            end
            all_red: begin
                if (timer >= all_red_time) begin
                    // determine next state based on previous non-red state
                    case(prev_state)
                        ns_left_yellow: next_state = ns_straight_green;
                        ns_straight_yellow: next_state = ew_left_green;
                        ew_left_yellow: next_state = ew_straight_green;
                        ew_straight_yellow: next_state = initial_state;
                        default: next_state = initial_state;
                    endcase
                end
            end
        endcase
    end
    
    // Output logic: this sets the traffic lights based on the current state
    always@(*) begin
        // default all red
        northsouth_red = 1;
        northsouth_yellow = 0;
        northsouth_green = 0;
        
        northsouth_left_red = 1;
        northsouth_left_yellow = 0;
        northsouth_left_green = 0;
        
        eastwest_red = 1;
        eastwest_yellow = 0;
        eastwest_green = 0;
        
        eastwest_left_red = 1;
        eastwest_left_yellow = 0;
        eastwest_left_green = 0;
        
        case(state)
            initial_state: begin
                northsouth_left_red = 0;
                northsouth_left_green = 1; // NS left green
            end
            ns_left_yellow: begin
                northsouth_left_red = 0;
                northsouth_left_green = 0;
                northsouth_left_yellow = 1; // NS left yellow
            end
            all_red: begin
                // explicitly assign all red for safety
                northsouth_red = 1;
                northsouth_yellow = 0;
                northsouth_green = 0;
                
                northsouth_left_red = 1;
                northsouth_left_yellow = 0;
                northsouth_left_green = 0;
                
                eastwest_red = 1;
                eastwest_yellow = 0;
                eastwest_green = 0;
                
                eastwest_left_red = 1;
                eastwest_left_yellow = 0;
                eastwest_left_green = 0;
            end
            ns_straight_green: begin
                northsouth_left_yellow = 0;
                northsouth_red = 0;
                northsouth_green = 1; // NS straight green
            end
            ns_straight_yellow: begin
                northsouth_red = 0;
                northsouth_green = 0;
                northsouth_yellow = 1; // NS straight yellow
            end
            ew_left_green: begin
                eastwest_left_red = 0;
                eastwest_left_green = 1; // EW left green
            end
            ew_left_yellow: begin
                eastwest_left_red = 0;
                eastwest_left_green = 0;
                eastwest_left_yellow = 1; // EW left yellow
            end
            ew_straight_green: begin
                eastwest_red = 0;
                eastwest_green = 1; // EW straight green
            end
            ew_straight_yellow: begin
                eastwest_red = 0;
                eastwest_green = 0;
                eastwest_yellow = 1; // EW straight yellow
            end
        endcase
    end
    
endmodule
