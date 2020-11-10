module ahb_sram
#(
    parameter ADDR_WIDTH = 16
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
    
    
    localparam DEPTH = 1 << (ADDR_WIDTH-2) ;
    
    reg [7:0] mem0 [0:49151] ;
    reg [7:0] mem1 [0:49151] ;
    reg [7:0] mem2 [0:49151] ;
    reg [7:0] mem3 [0:49151] ;
    
    reg         aphase_hsel     ;
    reg         aphase_hwrite   ;
    reg [ 1:0]  aphase_htrans   ;
    reg [31:0]  aphase_haddr    ;
    reg [ 2:0]  aphase_hsize    ;

    always @(posedge hclk or negedge hresetn)
        if(!hresetn)begin
            aphase_hsel   <= 1'b0  ;
            aphase_hwrite <= 1'b0  ;
            aphase_htrans <= 2'b00 ;
            aphase_haddr  <= 32'h0 ;
            aphase_hsize  <= 3'h0  ;
	    end
        else if(hready)begin
            aphase_hsel   <= hsel  ;
            aphase_hwrite <= hwrite;
            aphase_htrans <= htrans;
            aphase_haddr  <= haddr ;
            aphase_hsize  <= hsize ;
        end

    // Decode the bytes lanes depending on HSIZE & HADDR[1:0]
    wire tx_byte = ~aphase_hsize[1] & ~aphase_hsize[0];
    wire tx_half = ~aphase_hsize[1] &  aphase_hsize[0];
    wire tx_word =  aphase_hsize[1];
  
    wire byte_at_00 = tx_byte & ~aphase_haddr[1] & ~aphase_haddr[0];
    wire byte_at_01 = tx_byte & ~aphase_haddr[1] &  aphase_haddr[0];
    wire byte_at_10 = tx_byte &  aphase_haddr[1] & ~aphase_haddr[0];
    wire byte_at_11 = tx_byte &  aphase_haddr[1] &  aphase_haddr[0];
  
    wire half_at_00 = tx_half & ~aphase_haddr[1];
    wire half_at_10 = tx_half &  aphase_haddr[1];
  
    wire word_at_00 = tx_word;
  
    wire byte0 = word_at_00 | half_at_00 | byte_at_00;
    wire byte1 = word_at_00 | half_at_00 | byte_at_01;
    wire byte2 = word_at_00 | half_at_10 | byte_at_10;
    wire byte3 = word_at_00 | half_at_10 | byte_at_11;

    always @(posedge hclk)begin
        if(aphase_hsel & aphase_hwrite & aphase_htrans[1])begin
            if(byte0)
                mem0[{aphase_haddr[ADDR_WIDTH-1:2]}] <= hwdata[7:0];
            if(byte1)
                mem1[{aphase_haddr[ADDR_WIDTH-1:2]}] <= hwdata[15:8];
            if(byte2)
                mem2[{aphase_haddr[ADDR_WIDTH-1:2]}] <= hwdata[23:16];
            if(byte3)
                mem3[{aphase_haddr[ADDR_WIDTH-1:2]}] <= hwdata[31:24];
	    end
    end
    
    assign hrdata[ 7: 0] = mem0[{aphase_haddr[ADDR_WIDTH-1:2]}];
    assign hrdata[15: 8] = mem1[{aphase_haddr[ADDR_WIDTH-1:2]}];
    assign hrdata[23:16] = mem2[{aphase_haddr[ADDR_WIDTH-1:2]}];
    assign hrdata[31:24] = mem3[{aphase_haddr[ADDR_WIDTH-1:2]}];
    assign hreadyout = 1'b1; // Always ready (no waitstate)
    assign hresp     = 2'b00; // Always response with OKAY
    
    
    

endmodule