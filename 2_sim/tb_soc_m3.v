`timescale 1ps/1ps

module tb_soc_m3;

reg clk;
reg rstn;


initial begin
    clk  = 1;
    rstn = 0;
    #101
    rstn = 1;
    #100000
    rstn = 0;
    #101
    rstn = 1;
end

always begin
    #10 clk = ~clk;
end

wire [3:0] led;
soc_m3_top #(
    .simpresent     (1)
) soc_m3 (
    .ext_clk_50m    (clk),
    .ext_rstn       (rstn),
    
    .ext_swdio      (),
    .ext_swclk      (),
    
    .txd            (),
    .rxd            (),
    .txdled         (),
    
    .led            (led),
    .reset_led      ()
);

endmodule
