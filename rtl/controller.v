module controller(
    input clk, reset, flushE,
    input [5:0] op, funct,
    input equalD,
    output branchD,
    output regwriteE, regwriteM, regwriteW,
    output memtoregE, memtoregM, memtoregW,
    output memwriteM,
    output [2:0] alucontrolE,
    output alusrcE,
    output pcsrcD,
    output regdstE);

    wire regwriteD;
    wire memtoregD;
    wire memwriteD, memwriteE;
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
                .alusrcD(alusrcD), 
                .regdstD(regdstD),
                .alucontrolD(alucontrolD),
                .regwriteE(regwriteE), 
                .memtoregE(memtoregE), 
                .memwriteE(memwriteE),
                .alusrcE(alusrcE), 
                .regdstE(regdstE),
                .alucontrolE(alucontrolE));

    EX_MEM_controlpipe cp2(.clk(clk), .reset(reset),
                .regwriteE(regwriteE), 
                .memtoregE(memtoregE), 
                .memwriteE(memwriteE), 
                .regwriteM(regwriteM), 
                .memtoregM(memtoregM), 
                .memwriteM(memwriteM));

    MEM_WB_controlpipe cp3(.clk(clk), .reset(reset),
                .regwriteM(regwriteM), 
                .memtoregM(memtoregM),
                .regwriteW(regwriteW), 
                .memtoregW(memtoregW));

    assign pcsrcD = branchD && equalD;
endmodule