


module tb();


    reg clk = 0;
    reg rstn = 0;

    always #10 clk = ~clk;

    reg [11:0] data = 0;
    reg valid = 0;
    wire re;
    wire [9:0] addr;

    wire done;
    wire [23:0] result;

    reg [11:0] memory [1023:0];
    
    calculation #(.WIDTH(12), .DEPTH(1000)) DUT (
        .clk(clk),
        .rstn(rstn),
        .data(data),
        .valid(valid),
        .addr(addr),
        .re(re),
        .done(done),
        .result(result)
    );

    always @(posedge clk) begin
        valid <= 1'b0;
        if(re) begin
            data <= memory[addr];
            valid <= 1'b1;
        end
    end


    integer f, i;
    initial begin
        rstn = 0;
        f = $fopen("input.txt","r");
        i = 0;
        while (! $feof(f)) begin
            $fscanf(f,"%b\n",memory[i]);
            i = i + 1;
        end
        $fclose(f);
        #40;
        rstn = 1;
        wait(done);
        $display("%d", result);
        #40;
        $stop;
    end

endmodule