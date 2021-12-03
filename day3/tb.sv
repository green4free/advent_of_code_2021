


module tb();


    reg clk = 0;

    always #10 clk = ~clk;

    reg [11:0] data = 0;
    wire [23:0] result;
    reg valid = 0;
    reg rstn = 0;

    calculation #(.WIDTH(12)) DUT (
        .clk(clk),
        .rstn(rstn),
        .data(data),
        .valid(valid),
        .result(result)
    );

    integer f;
    initial begin
        f = $fopen("input.txt","r");
        rstn = 1;
        @(posedge clk);
        while (! $feof(f)) begin
            $fscanf(f,"%b\n",data);
            valid = 1;
            @(posedge clk);
        end
        valid = 0;
        #200;
        $fclose(f);
        $stop;
    end

endmodule