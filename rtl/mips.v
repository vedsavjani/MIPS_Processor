module mips(
    input clk ,reset,
    input [31:0] instrF,
    input [31:0] readdataM,
    output [31:0] aluoutM, writedataM,
    output [31:0] pcF,
    output memwriteM);

    wire [31:0] instrD;
    wire [2:0] alucontrolE;
    wire equalD;
    wire pcsrcD, memtoregM, memtoregW, alusrcE, regdstE, regwriteE, regwriteW;
    wire stallF, stallD, flushE, memtoregE, regwriteM;
    wire [1:0] forwardAE, forwardBE;
    wire [4:0] rsD, rtD, rsE, rtE, writeregE, writeregM, writeregW;
    wire forwardAD, forwardBD, branchD;

    controller c(.clk(clk), .reset(reset), .flushE(flushE),
                .op(instrD[31:26]), .funct(instrD[5:0]),
                .equalD(equalD),
                .branchD(branchD),
                .regwriteE(regwriteE), .regwriteM(regwriteM), .regwriteW(regwriteW),
                .memtoregE(memtoregE), .memtoregM(memtoregM), .memtoregW(memtoregW),
                .memwriteM(memwriteM),
                .alucontrolE(alucontrolE),
                .alusrcE(alusrcE),
                .pcsrcD(pcsrcD),
                .regdstE(regdstE));

    datapath dp(.clk(clk), .reset(reset),
                .regwriteW(regwriteW), .alusrcE(alusrcE),
                .regdstE(regdstE), .memtoregW(memtoregW),
                .pcsrcD(pcsrcD),
                .alucontrolE(alucontrolE),
                .instrF(instrF),
                .readdataM(readdataM),
                .equalD(equalD),
                .pcF(pcF),
                .writedataM(writedataM), .aluoutM(aluoutM),
                .instrD(instrD),
                .rsD(rsD), .rtD(rtD), .rsE(rsE), .rtE(rtE),
                .forwardAE(forwardAE), .forwardBE(forwardBE),
                .writeregE(writeregE), .writeregM(writeregM), .writeregW(writeregW),
                .stallF(stallF), .stallD(stallD), .flushE(flushE),
                .forwardAD(forwardAD), .forwardBD(forwardBD));

    hazard_unit hu(.rsD(rsD), .rtD(rtD), .rsE(rsE), .rtE(rtE), 
                .writeregE(writeregE), .writeregM(writeregM), .writeregW(writeregW),
                .regwriteE(regwriteE), .regwriteM(regwriteM), .regwriteW(regwriteW), 
                .memtoregE(memtoregE), .memtoregM(memtoregM), .branchD(branchD),
                .forwardAE(forwardAE), .forwardBE(forwardBE),
                .stallF(stallF), .stallD(stallD), .flushE(flushE),
                .forwardAD(forwardAD), .forwardBD(forwardBD));
endmodule