module hazard_unit(
    input [4:0] rsD, rtD, rsE, rtE, writeregM, writeregW,
    input regwriteM, regwriteW, memtoregE,
    output reg [1:0] forwardAE, forwardBE,
    output reg stallF, stallD, flushE);

    

    always @(*) begin
        if((rsE != 5'b0) && (rsE == writeregM) && regwriteM) forwardAE = 2'b10;
        else if((rsE != 5'b0) && (rsE == writeregW) && regwriteW) forwardAE = 2'b01;
        else forwardAE = 2'b00;
    end

    always @(*) begin
        if((rtE != 5'b0) && (rtE == writeregM) && regwriteM) forwardBE = 2'b10;
        else if((rtE != 5'b0) && (rtE == writeregW) && regwriteW) forwardBE = 2'b01;
        else forwardBE = 2'b00;
    end

    always @(*) begin
        if(((rsD == rtE) || (rtD == rtE)) && memtoregE) begin
            {stallF, stallD, flushE} = 3'b111;
        end
        else {stallF, stallD, flushE} = 3'b000;
    end

    
endmodule