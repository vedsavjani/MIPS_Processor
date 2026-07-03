module controller(
    input clk, reset, flushE,
    input [5:0] op, funct,
    input zeroM,
    output regwriteM, regwriteW,
    output memtoregE, memtoregW,
    output memwriteM,
    output [2:0] alucontrolE,
    output alusrcE,
    output pcsrcM,
    output regdstE);

    wire regwriteD, regwriteE;
    wire memtoregD, memtoregM;
    wire memwriteD, memwriteE;
    wire branchD, branchE, branchM;
    wire [2:0] alucontrolD;
    wire alusrcD;
    wire regdstD;
    wire [1:0] aluop;

    maindec md(.op(op),
                .memtoreg(memtoregD), 
                .memwrite(memwriteD),
                .branch(branchD),
                .alusrc(alusrcD),
                .regdst(regdstD),
                .regwrite(regwriteD),
                .aluop(aluop));

    aludec ad(.funct(funct),
                .aluop(aluop),
                .alucontrol(alucontrolD));

    ID_EX_controlpipe cp1(.clk(clk), .reset(reset), .flush(flushE),
                .regwriteD(regwriteD),
                .memtoregD(memtoregD), 
                .memwriteD(memwriteD),
                .branchD(branchD), 
                .alusrcD(alusrcD), 
                .regdstD(regdstD),
                .alucontrolD(alucontrolD),
                .regwriteE(regwriteE), 
                .memtoregE(memtoregE), 
                .memwriteE(memwriteE),
                .branchE(branchE), 
                .alusrcE(alusrcE), 
                .regdstE(regdstE),
                .alucontrolE(alucontrolE));

    EX_MEM_controlpipe cp2(.clk(clk), .reset(reset),
                .regwriteE(regwriteE), 
                .memtoregE(memtoregE), 
                .memwriteE(memwriteE), 
                .branchE(branchE),
                .regwriteM(regwriteM), 
                .memtoregM(memtoregM), 
                .memwriteM(memwriteM),
                .branchM(branchM));

    MEM_WB_controlpipe cp3(.clk(clk), .reset(reset),
                .regwriteM(regwriteM), 
                .memtoregM(memtoregM),
                .regwriteW(regwriteW), 
                .memtoregW(memtoregW));

    assign pcsrcM = branchM && zeroM;
endmodule