module  ahb_rom #(
    parameter ADDR_WIDTH = 10
)(
    input   wire                    hclk        ,
    input   wire                    hresetn     ,
    input   wire                    hsel        ,
    input   wire                    hready      ,
    input   wire[           1:0]    htrans      ,
    input   wire[           2:0]    hsize       ,
    input   wire[ADDR_WIDTH-1:0]    haddr       ,
    input   wire[           2:0]    hburst      ,
    input   wire                    hwrite      ,
    input   wire[          31:0]    hwdata      ,
    output  wire                    hreadyout   ,
    output  wire[          31:0]    hrdata      ,
    output  wire[           1:0]    hresp 

);
my_rom my_rom0(
	.address                (haddr[ADDR_WIDTH-1 : 2]),
	.clock                  (hclk),
	.q                      (hrdata)
);

assign hreadyout = 1'b1;
assign hresp     = 2'b00;


	


endmodule