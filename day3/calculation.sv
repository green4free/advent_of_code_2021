


module calculation #(
    parameter WIDTH = 5,
    parameter MAX_DEPTH = 1000
)(
    input wire                clk,
    input wire                rstn,
    input wire [WIDTH-1:0]    data,
    input wire                valid,
    output wire [2*WIDTH-1:0] result
);
    wire [2*WIDTH-1:0] mostCommonParity;
    reg signed [$clog2(MAX_DEPTH)-1:0] parityCounter [WIDTH-1:0];

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