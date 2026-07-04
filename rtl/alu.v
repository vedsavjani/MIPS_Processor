module alu(
    input [31:0] srca, srcb,
    input [2:0] alucontrol,
    output reg [31:0] aluresult
    );

    always @(*) begin
        case(alucontrol) 
            3'b000 : aluresult = srca & srcb;
            3'b001 : aluresult = srca | srcb;
            3'b010 : aluresult = srca + srcb;
            3'b011 : aluresult = 32'bx; // not used, so dont care
            3'b100 : aluresult = srca & ~srcb;
            3'b101 : aluresult = srca | ~srcb;
            3'b110 : aluresult = srca - srcb;
            // 3'b111 : aluresult = (srca-srcb <0)? 32'b1 : 32'b0; this wont work becoz 
            // srca and srcb are declared unsigned (by default). so you have to extract
            // the sign bit from srca-srcb, if its 1, then its negative, else positive
            3'b111 : aluresult = (srca - srcb) >> 31;
        endcase
    end
endmodule