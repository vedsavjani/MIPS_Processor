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
    always @(negedge clk) begin         // negedge becoz the write happens on the rising edge, so you check after it - at the falling edge, when the result has settled and is stable
        if (memwriteM) begin
            $display("Time=%0t | Store: Addr=%h, Data=%h", $time, aluoutM, writedataM);
            
            if (aluoutM === 84 && writedataM === 7) begin
                $display("=== SUCCESS ===");
                $finish;
            end
        end
    end

    // Timeout safety
    initial begin
        #10000
        $display("Simulation timeout!");
        $finish;
    end

endmodule