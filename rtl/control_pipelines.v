module ID_EX_controlpipe(
    input clk, reset, flush,
    input regwriteD, memtoregD, memwriteD,
    input branchD, alusrcD, regdstD,
    input [2:0] alucontrolD,
    output reg regwriteE, memtoregE, memwriteE,
    output reg branchE, alusrcE, regdstE,
    output reg [2:0] alucontrolE);

    always @(posedge clk) begin
        if (reset | flush) begin
            regwriteE <= 0;
            memtoregE <= 0;
            memwriteE <= 0;
            branchE <= 0;
            alusrcE <= 0;
            regdstE <= 0;
            alucontrolE <= 3'b0;
        end
        else begin
            regwriteE <= regwriteD;
            memtoregE <= memtoregD;
            memwriteE <= memwriteD;
            branchE <= branchD;
            alusrcE <= alusrcD;
            regdstE <= regdstD;
            alucontrolE <= alucontrolD;
        end
    end
endmodule

module EX_MEM_controlpipe(
    input clk, reset,
    input regwriteE, memtoregE, memwriteE, branchE,
    output reg regwriteM, memtoregM, memwriteM, branchM);

    always @(posedge clk) begin
        if (reset) begin
            regwriteM <= 0;
            memtoregM <= 0;
            memwriteM <= 0;
            branchM <= 0;
        end
        else begin
            regwriteM <= regwriteE;
            memtoregM <= memtoregE;
            memwriteM <= memwriteE;
            branchM <= branchE;
        end
    end
endmodule


module MEM_WB_controlpipe(
    input clk, reset,
    input regwriteM, memtoregM,
    output reg regwriteW, memtoregW);

    always @(posedge clk) begin
        if (reset) begin
            regwriteW <= 0;
            memtoregW <= 0;    
        end
        else begin
            regwriteW <= regwriteM;
            memtoregW <= memtoregM;
        end
    end
endmodule