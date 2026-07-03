module tb();
    reg clk, reset;
    wire [31:0] writedataM, aluoutM;
    wire memwriteM;

    top dut(.clk(clk), .reset(reset), 
            .writedataM(writedataM), 
            .aluoutM(aluoutM), 
            .memwriteM(memwriteM));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #22 reset = 0;
    end

    // Monitor successful final write
    always @(negedge clk) begin
        if (memwriteM) begin
            $display("Time=%0t | Store: Addr=%h, Data=%h", $time, aluoutM, writedataM);
            
            if (aluoutM === 32'h54 && writedataM === 32'd42) begin
                $display("=== SIMULATION SUCCEEDED! ===");
                $display("Final value 42 written to address 84");
                #20 $finish;
            end
        end
    end

    // Timeout safety
    initial begin
        #2000;  // adjust based on your program length
        $display("Simulation timeout!");
        $finish;
    end

endmodule