module imem(
    input [5:0] a,
    output [31:0] rd
);

    reg [31:0] RAM[0:63];

    initial begin
        $readmemh("mem/memfile.dat", RAM);
    end

    assign rd = RAM[a];

endmodule