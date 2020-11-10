module  apb_top #(
  parameter                   ADDRWIDTH = 16
)(
  input  wire                 hclk          ,      // Clock
  input  wire                 hresetn       ,   // Reset
  input  wire                 pclken        ,    // APB clock enable signal

  input  wire                 hsel          ,      // Device select
  input  wire [ADDRWIDTH-1:0] haddr         ,     // Address
  input  wire           [1:0] htrans        ,    // Transfer control
  input  wire           [2:0] hsize         ,     // Transfer size
  input  wire           [3:0] hprot         ,     // Protection control
  input  wire                 hwrite        ,    // Write control
  input  wire                 hready        ,    // Transfer phase done
  input  wire          [31:0] hwdata        ,    // Write data

  output wire                 hreadyout     , // Device ready
  output wire          [31:0] hrdata        ,    // Read data output
  output wire                 hresp         ,     // Device response


  output wire                 txd           ,
  input  wire                 rxd           ,

  output wire                 txint         ,
  output wire                 rxint         ,
  output wire                 txovrint      ,
  output wire                 rxovrint      ,
  output wire                 uartint       ,
  output wire          [ 3:0] led
);







//ABP signal
wire    [15: 0] paddr;
wire            penable;
wire            pwrite;
wire    [3 : 0] pstrb;
wire    [2 : 0] pprot;
wire    [31: 0] pwdata;
wire            psel;
wire            apbactive;
wire    [31: 0] prdata;
wire            pready;
wire            pslverr;
                    

ahb_to_apb #(
    .ADDRWIDTH (16),
    .REGISTER_RDATA (1),
    .REGISTER_WDATA (1)
)   bridge(
     
    .HCLK               (hclk),    // Clock
    .HRESETn            (hresetn),    // Reset
    .PCLKEN             (pclken),    // APB clock enable signal
    
    .HSEL               (hsel),    // Device select
    .HADDR              (haddr),    // Address
    .HTRANS             (htrans),    // Transfer control
    .HSIZE              (hsize),    // Transfer size
    .HPROT              (hprot),    // Protection control
    .HWRITE             (hwrite),    // Write control
    .HREADY             (hready),    // Transfer phase done
    .HWDATA             (hwdata),    // Write data
    
    .HREADYOUT          (hreadyout),    // Device ready
    .HRDATA             (hrdata),    // Read data output
    .HRESP              (hresp),    // Device response
                             // APB Output
    .PADDR              (paddr),    // APB Address
    .PENABLE            (penable),    // APB Enable
    .PWRITE             (pwrite),    // APB Write
    .PSTRB              (pstrb),    // APB Byte Strobe
    .PPROT              (pprot),    // APB Prot
    .PWDATA             (pwdata),    // APB write data
    .PSEL               (psel),    // APB Select
    
    .APBACTIVE          (apbactive),    // APB bus is active, for clock gating
                             // of APB bus
    
                             // APB Input
    .PRDATA             (prdata),    // Read data for each APB slave
    .PREADY             (pready),    // Ready for each APB slave
    .PSLVERR            (pslverr)
);



wire             apb0_psel    ;
wire             apb0_pready  ; 
wire    [31 : 0] apb0_prdata  ;   
wire             apb0_pslverr ;   

wire             apb1_psel    ;
wire             apb1_pready  ; 
wire    [31 : 0] apb1_prdata  ;   
wire             apb1_pslverr ;   



apb_slave_mux #(
  // Parameters to enable/disable ports
  .PORT0_ENABLE         (1),
  .PORT1_ENABLE         (1),
  .PORT2_ENABLE         (0),
  .PORT3_ENABLE         (0),
  .PORT4_ENABLE         (0),
  .PORT5_ENABLE         (0),
  .PORT6_ENABLE         (0),
  .PORT7_ENABLE         (0),
  .PORT8_ENABLE         (0),
  .PORT9_ENABLE         (0),
  .PORT10_ENABLE        (0),
  .PORT11_ENABLE        (0),
  .PORT12_ENABLE        (0),
  .PORT13_ENABLE        (0),
  .PORT14_ENABLE        (0),
  .PORT15_ENABLE        (0)
) apb_top (
  .DECODE4BIT           (paddr[15 : 12]),
  .PSEL                 (psel),

  .PSEL0                (apb0_psel),
  .PREADY0              (apb0_pready),
  .PRDATA0              (apb0_prdata),
  .PSLVERR0             (apb0_pslverr),

  .PSEL1                (apb1_psel),
  .PREADY1              (apb1_pready),
  .PRDATA1              (apb1_prdata),
  .PSLVERR1             (apb1_pslverr),

  .PSEL2                (),
  .PREADY2              (1'b0),
  .PRDATA2              (32'b0),
  .PSLVERR2             (1'b0),

  .PSEL3                (),
  .PREADY3              (1'b0),
  .PRDATA3              (32'b0),
  .PSLVERR3             (1'b0),

  . PSEL4               (),
  . PREADY4             (1'b0),
  . PRDATA4             (32'b0),
  . PSLVERR4            (1'b0),

  .PSEL5                (),
  .PREADY5              (1'b0),
  .PRDATA5              (32'b0),
  .PSLVERR5             (1'b0),

  .PSEL6                (),
  .PREADY6              (1'b0),
  .PRDATA6              (32'b0),
  .PSLVERR6             (1'b0),

  .PSEL7                (),
  .PREADY7              (1'b0),
  .PRDATA7              (32'b0),
  .PSLVERR7             (1'b0),

  .PSEL8                (),
  .PREADY8              (1'b0),
  .PRDATA8              (32'b0),
  .PSLVERR8             (1'b0),

  .PSEL9                (),
  .PREADY9              (1'b0),
  .PRDATA9              (32'b0),
  .PSLVERR9             (1'b0),

  .PSEL10               (),
  .PREADY10             (1'b0),
  .PRDATA10             (32'b0),
  .PSLVERR10            (1'b0),

  .PSEL11               (),
  .PREADY11             (1'b0),
  .PRDATA11             (32'b0),
  .PSLVERR11            (1'b0),

  .PSEL12               (),
  .PREADY12             (1'b0),
  .PRDATA12             (32'b0),
  .PSLVERR12            (1'b0),

  .PSEL13               (),
  .PREADY13             (1'b0),
  .PRDATA13             (32'b0),
  .PSLVERR13            (1'b0),

  .PSEL14               (),
  .PREADY14             (1'b0),
  .PRDATA14             (32'b0),
  .PSLVERR14            (1'b0),

  .PSEL15               (),
  .PREADY15             (1'b0),
  .PRDATA15             (32'b0),
  .PSLVERR15            (1'b0),

  .PREADY               (pready),
  .PRDATA               (prdata),
  .PSLVERR              (pslverr)
);




apb_uart uart(
  .PCLK                 (hclk),     // Clock
  .PCLKG                (hclk),    // Gated Clock
  .PRESETn              (hresetn),  // Reset

  .PSEL                 (apb0_psel),     // Device select
  .PADDR                (paddr[11:2]),    // Address
  .PENABLE              (penable),  // Transfer control
  .PWRITE               (pwrite),   // Write control
  .PWDATA               (pwdata),   // Write data

  .PRDATA               (apb0_prdata),   // Read data
  .PREADY               (apb0_pready),   // Device ready
  .PSLVERR              (apb0_pslverr),  // Device error response

  .RXD                  (rxd),      // Serial input
  .TXD                  (txd),      // Transmit data output
  .TXEN                 (TXEN),     // Transmit enabled

  .TXINT                (txint),    // Transmit Interrupt
  .RXINT                (rxint),    // Receive Interrupt
  .TXOVRINT             (txovrint), // Transmit overrun Interrupt
  .RXOVRINT             (rxovrint), // Receive overrun Interrupt
  .UARTINT              (uartint)
);


apb_reg apb_led(
  .pclk                 (hclk), 
  .presetn              (hresetn), 

  .psels                (apb1_psel), 
  .paddr                (paddr[11:2]), 
  .penable              (penable),
  .pwrites              (pwrite), 
  .pwdatas              (pwdata), 

  .prdatas              (apb1_prdata), 
  .pready               (apb1_pready), 
  .pslverr              (apb1_pslverr),

  .led                  (led)  
);



endmodule