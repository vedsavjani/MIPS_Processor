module hazard_unit(
    input [4:0] rsD, rtD, rsE, rtE, writeregE, writeregM, writeregW,
    input regwriteE, regwriteM, regwriteW, memtoregE, memtoregM, branchD,
    output reg [1:0] forwardAE, forwardBE,
    output reg stallF, stallD, flushE,
    output reg forwardAD, forwardBD);

    reg lwstall, branchstall;

    // normal forwarding into alusrca
    always @(*) begin
        if((rsE != 5'b0) && (rsE == writeregM) && regwriteM) forwardAE = 2'b10;
        else if((rsE != 5'b0) && (rsE == writeregW) && regwriteW) forwardAE = 2'b01;
        else forwardAE = 2'b00;
    end

    // normal forwarding into alusrcb
    always @(*) begin
        if((rtE != 5'b0) && (rtE == writeregM) && regwriteM) forwardBE = 2'b10;
        else if((rtE != 5'b0) && (rtE == writeregW) && regwriteW) forwardBE = 2'b01;
        else forwardBE = 2'b00;
    end


    // stalling logic
    always @(*) begin
        lwstall = ((rsD == rtE) || (rtD == rtE)) && memtoregE;
        branchstall = (branchD && regwriteE && (writeregE==rsD || writeregE==rtD)) || (branchD && memtoregM && (writeregM==rsD || writeregM==rtD));
        if(lwstall || branchstall) begin
            {stallF, stallD, flushE} = 3'b111;
        end
        else {stallF, stallD, flushE} = 3'b000;
    end

    // beq forwarding fix
    always @(*) begin
        forwardAD = (rsD != 5'b0) && (rsD == writeregM) && regwriteM;
        forwardBD = (rtD != 5'b0) && (rtD == writeregM) && regwriteM;
    end
endmodule