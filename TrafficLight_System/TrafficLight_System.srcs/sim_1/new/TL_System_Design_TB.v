`timescale 1ns / 1ps

module TL_System_Design_TB;

    // --------------------------------
    // Clock and reset
    // --------------------------------
    reg clk;
    reg reset;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10 ns period
    end

    // --------------------------------
    // DUT outputs
    // --------------------------------
    wire northsouth_red, northsouth_yellow, northsouth_green;
    wire eastwest_red,  eastwest_yellow,  eastwest_green;
    wire northsouth_left_red, northsouth_left_yellow, northsouth_left_green;
    wire eastwest_left_red,  eastwest_left_yellow,  eastwest_left_green;

    // --------------------------------
    // Instantiate DUT
    // --------------------------------
    TL_System_Design dut (
        .clk(clk),
        .reset(reset),
        .northsouth_red(northsouth_red),
        .northsouth_yellow(northsouth_yellow),
        .northsouth_green(northsouth_green),
        .eastwest_red(eastwest_red),
        .eastwest_yellow(eastwest_yellow),
        .eastwest_green(eastwest_green),
        .northsouth_left_red(northsouth_left_red),
        .northsouth_left_yellow(northsouth_left_yellow),
        .northsouth_left_green(northsouth_left_green),
        .eastwest_left_red(eastwest_left_red),
        .eastwest_left_yellow(eastwest_left_yellow),
        .eastwest_left_green(eastwest_left_green)
    );

    integer errors;
    integer cycle_count;

    // --------------------------------
    // Safety check: only one green
    // --------------------------------
    task check_no_conflicting_greens;
        integer g;
    begin
        g = northsouth_green +
            northsouth_left_green +
            eastwest_green +
            eastwest_left_green;

        if (g > 1) begin
            $display("ERROR: Conflicting greens at time %0t", $time);
            errors = errors + 1;
        end
    end
    endtask

    // --------------------------------
    // Monitor and log all states
    // --------------------------------
    always @(posedge clk) begin
        $display("time=%0t | NS:[R=%b Y=%b G=%b] NSL:[R=%b Y=%b G=%b] EW:[R=%b Y=%b G=%b] EWL:[R=%b Y=%b G=%b]",
                 $time,
                 northsouth_red, northsouth_yellow, northsouth_green,
                 northsouth_left_red, northsouth_left_yellow, northsouth_left_green,
                 eastwest_red, eastwest_yellow, eastwest_green,
                 eastwest_left_red, eastwest_left_yellow, eastwest_left_green);

        check_no_conflicting_greens();
    end

    // --------------------------------
    // Test sequence
    // --------------------------------
    initial begin
        errors = 0;
        reset  = 1;
        cycle_count = 0;

        // Apply synchronous reset
        repeat (2) @(posedge clk);
        reset = 0;

        // Loop through the full traffic cycle 3 times
        while (cycle_count < 3) begin

            // Wait NS left green
            wait (northsouth_left_green);
            while (northsouth_left_green) @(posedge clk);

            // Wait NS left yellow
            wait (northsouth_left_yellow);
            while (northsouth_left_yellow) @(posedge clk);

            // Wait ALL RED
            wait (northsouth_red && eastwest_red);
            while (northsouth_red && eastwest_red) @(posedge clk);

            // Wait NS straight green
            wait (northsouth_green);
            while (northsouth_green) @(posedge clk);

            // Wait NS straight yellow
            wait (northsouth_yellow);
            while (northsouth_yellow) @(posedge clk);

            // Wait ALL RED
            wait (northsouth_red && eastwest_red);
            while (northsouth_red && eastwest_red) @(posedge clk);

            // Wait EW left green
            wait (eastwest_left_green);
            while (eastwest_left_green) @(posedge clk);

            // Wait EW left yellow
            wait (eastwest_left_yellow);
            while (eastwest_left_yellow) @(posedge clk);

            // Wait ALL RED
            wait (northsouth_red && eastwest_red);
            while (northsouth_red && eastwest_red) @(posedge clk);

            // Wait EW straight green
            wait (eastwest_green);
            while (eastwest_green) @(posedge clk);

            // Wait EW straight yellow
            wait (eastwest_yellow);
            while (eastwest_yellow) @(posedge clk);

            // Wait final ALL RED
            wait (northsouth_red && eastwest_red);
            while (northsouth_red && eastwest_red) @(posedge clk);

            cycle_count = cycle_count + 1;
            $display("------ Completed cycle %0d ------", cycle_count);

        end

        // -------- RESULTS --------
        if (errors == 0)
            $display("✅ ALL TESTS PASSED after %0d full cycles", cycle_count);
        else
            $display("❌ TEST FAILED - Errors: %0d", errors);

        $finish;
    end

endmodule
