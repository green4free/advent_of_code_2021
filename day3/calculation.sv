


module calculation #(
    parameter WIDTH = 5,
    parameter DEPTH = 1000
)(
    input wire clk,
    input wire rstn,

    input wire [WIDTH-1:0]         data,
    input wire                     valid,
    output reg [$clog2(DEPTH)-1:0] addr,
    output reg                     re,

    output reg                done,
    output wire [2*WIDTH-1:0] result
);

    initial begin
        addr = 0;
        re = 1'b0;
        done = 1'b0;
    end

    reg init = 1'b1;

    wire [$clog2(DEPTH)-1:0] next_addr = addr + 1;

    always @(posedge clk, negedge rstn)
        if (!rstn) begin
            addr <= 0;
            re <= 1'b0;
            done <= 1'b0;
            init <= 1'b1;
        end else begin
            init <= 1'b0;
            re <= 1'b0;
            if (init) begin
                addr <= 0;
                re <= 1'b1;
            end else if (valid) begin
                addr <= next_addr;
                if (next_addr < DEPTH)
                    re <= 1'b1;
                else
                    done <= 1'b1;
            end

        end

    wire [2*WIDTH-1:0] mostCommonParity;
    reg signed [$clog2(DEPTH)-1:0] parityCounter [WIDTH-1:0];

    genvar i;
    for (i = 0; i < WIDTH; i = i + 1) begin
        initial
            parityCounter[i] = 0;
        
        assign mostCommonParity[i] = parityCounter[i] > 0;
        assign mostCommonParity[WIDTH + i] = 1'b0;
    
        always @(posedge clk, negedge rstn)
            if (!rstn)
                parityCounter[i] <= 0;
            else
                if (valid)
                    parityCounter[i] <= (data[i]) ? (parityCounter[i] + 1) : (parityCounter[i] - 1);
    end

    assign result = mostCommonParity * ((~mostCommonParity) & ((1 << WIDTH)-1));

endmodule