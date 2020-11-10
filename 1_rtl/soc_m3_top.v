module soc_m3_top #(
    parameter   simpresent = 0
)(
    input wire  ext_clk_50m,
    input wire  ext_rstn,
    
    //SWD   
    inout wire  ext_swdio,
    inout wire  ext_swclk,
    
    //UART
    output wire  txd,
    input  wire  rxd,
    output wire  txdled,

    //LED
    output wire [3:0] led,
    output wire       reset_led
);


assign txdled = ~txd;

//GLOBAL BUF
wire    clk;
wire    swck;

generate
    if(simpresent) begin : simclock
                assign swck = ext_swclk;
                assign clk  = ext_clk_50m;
            end else begin : synclock
                GLOBAL  sw_clk(
                        .in     (ext_swclk),
                        .out    (swck)
                );
                pll pll(
	                    .inclk0 (ext_clk_50m),
	                    .c0     (clk)
                        );
                
            end
endgenerate

/*****************************************************/
//DEBUG IOBUF

wire    swdo;
wire    swdoen;
wire    swdi;

generate
    if(simpresent) begin : simiobuf
            assign swdi = ext_swdio;
            assign ext_swdio = (swdoen) ? swdo : 1'bz;
        end else begin : syniobuf
            IOBUF_iobuf_bidir_30p SWIOBUF(
                .datain     (swdo),
                .oe         (swdoen),
                .dataout    (swdi),
                .dataio     (ext_swdio)
            );
        end
endgenerate

/*****************************************************/

//REST

wire    sysresetreq;
reg     cpuresetn;

assign reset_led = cpuresetn;

always @(posedge clk or negedge ext_rstn)
    begin 
        if (~ext_rstn)
            cpuresetn <= 1'b0;
        else if (sysresetreq)
            cpuresetn <= 1'b0;
        else
            cpuresetn <= 1'b1;
    end

wire    sleeping;

/*****************************************************/

//DEBUG CONFIG

wire    cdbgpwrupreq;
reg     cdbgpwrupack;



always @(posedge clk or negedge ext_rstn)
begin
   if(~ext_rstn)
      cdbgpwrupack <= 1'b0;
   else
      cdbgpwrupack <= cdbgpwrupreq;
end


//INTERRUPT

wire    [230 : 0] irq;

/*****************************************************/

//------------------------------------------------------------
//CORE BUS
//------------------------------------------------------------

//CPU I-CODE
wire    [31 : 0] haddri;
wire    [1 : 0]  htransi;
wire    [2 : 0]  hsizei;
wire    [2 : 0]  hbursti;
wire    [3 : 0]  hproti;
wire    [31 : 0] hrdatai;
wire             hreadyi;
wire    [1 : 0]  hrespi;


//CPU D-CODE
wire    [31 : 0] haddrd;
wire    [1 : 0]  htransd;
wire    [2 : 0]  hsized;
wire    [2 : 0]  hburstd;
wire    [3 : 0]  hprotd;
wire    [31 : 0] hwdatad;
wire             hwrited;
wire    [31 : 0] hrdatad;
wire             hreadyd;
wire    [1 : 0]  hrespd;
wire    [1 : 0]  hmasterd;


//CPU SYSTEM BUS
wire    [31 : 0] haddrs;
wire    [1 : 0]  htranss;
wire             hwrites;
wire    [2 : 0]  hsizes;
wire    [31 : 0] hwdatas;
wire    [2 : 0]  hbursts;
wire    [3 : 0]  hprots;
wire             hreadys;
wire    [31 : 0] hrdatas;
wire    [1 : 0]  hresps;
wire    [1 : 0]  hmasters;
wire             hmasterlocks;



cortexm3ds_logic m3_logic(
    // PMU
    .ISOLATEn                           (1'b1),
    .RETAINn                            (1'b1),

    // RESETS
    .PORESETn                           (ext_rstn),
    .SYSRESETn                          (cpuresetn),
    .SYSRESETREQ                        (sysresetreq),
    .RSTBYPASS                          (1'b0),
    .CGBYPASS                           (1'b0),
    .SE                                 (1'b0),

    // CLOCKS
    .FCLK                               (clk),
    .HCLK                               (clk),
    .TRACECLKIN                         (1'b0),

    // SYSTICK
    .STCLK                              (1'b0),
    .STCALIB                            (26'b0),
    .AUXFAULT                           (32'b0),

    // CONFIG - SYSTEM
    .BIGEND                             (1'b0),
    .DNOTITRANS                         (1'b1),
    
    // SWJDAP
    .nTRST                              (1'b1),
    .SWDITMS                            (swdi),
    .SWCLKTCK                           (swck),
    .TDI                                (1'b0),
    .CDBGPWRUPACK                       (cdbgpwrupack),
    .CDBGPWRUPREQ                       (cdbgpwrupreq),
    .SWDO                               (swdo),
    .SWDOEN                             (swdoen),

    // IRQS
    .INTISR                             (irq),
    .INTNMI                             (1'b0),
    
    // I-CODE BUS
    .HREADYI                            (hreadyi),
    .HRDATAI                            (hrdatai),
    .HRESPI                             (hrespi),
    .IFLUSH                             (1'b0),
    .HADDRI                             (haddri),
    .HTRANSI                            (htransi),
    .HSIZEI                             (hsizei),
    .HBURSTI                            (hbursti),
    .HPROTI                             (hproti),

    // D-CODE BUS
    .HREADYD                            (hreadyd),
    .HRDATAD                            (hrdatad),
    .HRESPD                             (hrespd),
    .EXRESPD                            (1'b0),
    .HADDRD                             (haddrd),
    .HTRANSD                            (htransd),
    .HSIZED                             (hsized),
    .HBURSTD                            (hburstd),
    .HPROTD                             (hprotd),
    .HWDATAD                            (hwdatad),
    .HWRITED                            (hwrited),
    .HMASTERD                           (hmasterd),

    // SYSTEM BUS
    .HREADYS                            (hreadys),
    .HRDATAS                            (hrdatas),
    .HRESPS                             (hresps),
    .EXRESPS                            (1'b0),
    .HADDRS                             (haddrs),
    .HTRANSS                            (htranss),
    .HSIZES                             (hsizes),
    .HBURSTS                            (hbursts),
    .HPROTS                             (hprots),
    .HWDATAS                            (hwdatas),
    .HWRITES                            (hwrites),
    .HMASTERS                           (hmasters),
    .HMASTLOCKS                         (hmasterlocks),

    // SLEEP
    .RXEV                               (1'b0),
    .SLEEPHOLDREQn                      (1'b1),
    .SLEEPING                           (sleeping),
    
    // EXTERNAL DEBUG REQUEST
    .EDBGRQ                             (1'b0),
    .DBGRESTART                         (1'b0),
    
    // DAP HMASTER OVERRIDE
    .FIXMASTERTYPE                      (1'b0),

    // WIC
    .WICENREQ                           (1'b0),

    // TIMESTAMP INTERFACE
    .TSVALUEB                           (48'b0),

    // CONFIG - DEBUG
    .DBGEN                              (1'b1),
    .NIDEN                              (1'b1),
    .MPUDISABLE                         (1'b0)
);

/*****************************************************/

//master3 signal

wire    [31 : 0] haddrm;
wire    [1 : 0]  htransm;
wire             hwritem;
wire    [2 : 0]  hsizem;
wire    [31 : 0] hwdatam;
wire    [2 : 0]  hburstm;
wire    [3 : 0]  hprotm;
wire             hredaym;
wire    [31 : 0] hrdatam;
wire    [1 : 0]  hrespm;
wire    [1 : 0]  hmasterm;
wire             hmasterlockm;  

assign haddrm       = 32'b0;
assign htransm      = 2'b0;
assign hwritem      = 1'b0;
assign hsizem       = 3'b0;
assign hwdatam      = 32'b0;
assign hburstm      = 3'b0;
assign hprotm       = 4'b0;
assign hmasterm     = 2'b0;
assign hmasterlockm = 1'b0;  

/*****************************************************/

//master4 signal

wire    [31 : 0] haddrx;
wire    [1 : 0]  htransx;
wire             hwritex;
wire    [2 : 0]  hsizex;
wire    [31 : 0] hwdatax;
wire    [2 : 0]  hburstx;
wire    [3 : 0]  hprotx;
wire             hredayx;
wire    [31 : 0] hrdatax;
wire    [1 : 0]  hrespx;
wire    [1 : 0]  hmasterx;
wire             hmasterlockx;  

assign haddrx       = 32'b0;
assign htransx      = 2'b0;
assign hwritex      = 1'b0;
assign hsizex       = 3'b0;
assign hwdatax      = 32'b0;
assign hburstx      = 3'b0;
assign hprotx       = 4'b0;
assign hmasterx     = 2'b0;
assign hmasterlockx = 1'b0;  

/*****************************************************/

//ROM signal
    
wire           rom_hsel         ; 
wire           rom_hready       ; 
wire    [ 1:0] rom_htrans       ; 
wire    [ 2:0] rom_hsize        ; 
wire    [16:0] rom_haddr        ; 
wire    [ 2:0] rom_hburst       ; 
wire           rom_hwrite       ; 
wire    [31:0] rom_hwdata       ; 
wire           rom_hreadyout    ; 
wire    [31:0] rom_hrdata       ; 
wire    [ 1:0] rom_hresp        ; 

/*****************************************************/

//SRAM signal

wire           sram_hsel        ;
wire           sram_hready      ;
wire    [ 1:0] sram_htrans      ;
wire    [ 2:0] sram_hsize       ;
wire    [17:0] sram_haddr       ;
wire    [ 2:0] sram_hburst      ;
wire           sram_hwrite      ;
wire    [31:0] sram_hwdata      ;
wire           sram_hreadyout   ;
wire    [31:0] sram_hrdata      ;
wire    [ 1:0] sram_hresp       ;

/*****************************************************/

//AHB_TO_APB_BRIDGE signal

wire    [31 : 0] ahbbridge_haddr;
wire    [1 : 0]  ahbbridge_htrans;
wire             ahbbridge_hwrite;
wire    [2 : 0]  ahbbridge_hsize;
wire    [31 : 0] ahbbridge_hwdata;
wire    [2 : 0]  ahbbridge_hburst;
wire    [3 : 0]  ahbbridge_hprot;
wire             ahbbridge_hready;
wire    [31 : 0] ahbbridge_hrdata;
wire    [1 : 0]  ahbbridge_hresp;
wire             ahbbridge_hreadyout;
wire             ahbbridge_hsel;
wire    [1 : 0]  ahbbridge_hmaster;
wire             ahbbridge_hmasterlock;

/*****************************************************/

//ahb_slave2

wire    [31 : 0]  ahb_slave2_haddr  ;  
wire    [1 : 0]   ahb_slave2_htrans  ;  
wire              ahb_slave2_hwrite  ;  
wire    [2 : 0]   ahb_slave2_hsize  ;  
wire    [31 : 0]  ahb_slave2_hwdata  ;  
wire    [2 : 0]   ahb_slave2_hburst  ;  
wire    [3 : 0]   ahb_slave2_hprot  ;  
wire              ahb_slave2_hready  ;  
wire    [31 : 0]  ahb_slave2_hrdata  ;  
wire    [1 : 0]   ahb_slave2_hresp  ;  
wire              ahb_slave2_hreadyout  ;  
wire              ahb_slave2_hsel  ;  
wire    [1 : 0]   ahb_slave2_hmaster  ;  
wire              ahb_slave2_hmasterlock  ;  


/*****************************************************/

//ahb_slave4

wire    [31 : 0]  ahb_slave4_haddr  ;  
wire    [1 : 0]   ahb_slave4_htrans  ;  
wire              ahb_slave4_hwrite  ;  
wire    [2 : 0]   ahb_slave4_hsize  ;  
wire    [31 : 0]  ahb_slave4_hwdata  ;  
wire    [2 : 0]   ahb_slave4_hburst  ;  
wire    [3 : 0]   ahb_slave4_hprot  ;  
wire              ahb_slave4_hready  ;  
wire    [31 : 0]  ahb_slave4_hrdata  ;  
wire    [1 : 0]   ahb_slave4_hresp  ;  
wire              ahb_slave4_hreadyout  ;  
wire              ahb_slave4_hsel  ;  
wire    [1 : 0]   ahb_slave4_hmaster  ;  
wire              ahb_slave4_hmasterlock  ;


/*****************************************************/

//ahb_slave5

wire    [31 : 0]  ahb_slave5_haddr  ;  
wire    [1 : 0]   ahb_slave5_htrans  ;  
wire              ahb_slave5_hwrite  ;  
wire    [2 : 0]   ahb_slave5_hsize  ;  
wire    [31 : 0]  ahb_slave5_hwdata  ;  
wire    [2 : 0]   ahb_slave5_hburst  ;  
wire    [3 : 0]   ahb_slave5_hprot  ;  
wire              ahb_slave5_hready  ;  
wire    [31 : 0]  ahb_slave5_hrdata  ;  
wire    [1 : 0]   ahb_slave5_hresp  ;  
wire              ahb_slave5_hreadyout  ;  
wire              ahb_slave5_hsel  ;  
wire    [1 : 0]   ahb_slave5_hmaster  ;  
wire              ahb_slave5_hmasterlock  ;

/*****************************************************/

//ahb_slave6

wire    [31 : 0]  ahb_slave6_haddr  ;  
wire    [1 : 0]   ahb_slave6_htrans  ;  
wire              ahb_slave6_hwrite  ;  
wire    [2 : 0]   ahb_slave6_hsize  ;  
wire    [31 : 0]  ahb_slave6_hwdata  ;  
wire    [2 : 0]   ahb_slave6_hburst  ;  
wire    [3 : 0]   ahb_slave6_hprot  ;  
wire              ahb_slave6_hready  ;  
wire    [31 : 0]  ahb_slave6_hrdata  ;  
wire    [1 : 0]   ahb_slave6_hresp  ;  
wire              ahb_slave6_hreadyout  ;  
wire              ahb_slave6_hsel  ;  
wire    [1 : 0]   ahb_slave6_hmaster  ;  
wire              ahb_slave6_hmasterlock  ;

/*****************************************************/

mybusmatrix5x7_lite  ahb_bus_5x7(

    // Common AHB signals
    .HCLK                (clk),
    .HRESETn             (cpuresetn),

    // System Address Remap control
    .REMAP               (4'b0),

    // Input port SI0 (inputs from master 0)
    .HADDRM0             (haddri),
    .HTRANSM0            (htransi),
    .HWRITEM0            (1'b0),
    .HSIZEM0             (hsizei),
    .HBURSTM0            (hbursti),
    .HPROTM0             (hproti),
    .HWDATAM0            (32'b0),
    .HMASTLOCKM0         (1'b0),
    .HAUSERM0            (32'b0),
    .HWUSERM0            (32'b0),


    // Input port SI1 (inputs from master 1)
    .HADDRM1             (haddrd),
    .HTRANSM1            (htransd),
    .HWRITEM1            (hwrited),
    .HSIZEM1             (hsized),
    .HBURSTM1            (hburstd),
    .HPROTM1             (hprotd),
    .HWDATAM1            (hwdatad),
    .HMASTLOCKM1         (1'b0),
    .HAUSERM1            (32'b0),
    .HWUSERM1            (32'b0),

    // Input port SI2 (inputs from master 2)
    .HADDRM2             (haddrs),
    .HTRANSM2            (htranss),
    .HWRITEM2            (hwrites),
    .HSIZEM2             (hsizes),
    .HBURSTM2            (hbursts),
    .HPROTM2             (hprots),
    .HWDATAM2            (hwdatas),
    .HMASTLOCKM2         (hmasterlocks),
    .HAUSERM2            (32'b0),
    .HWUSERM2            (32'b0),

    // Input port SI3 (inputs from master 3)
    .HADDRM3             (haddrm),
    .HTRANSM3            (htransm),
    .HWRITEM3            (hwritem),
    .HSIZEM3             (hsizem),
    .HBURSTM3            (hburstm),
    .HPROTM3             (hprotm),
    .HWDATAM3            (hwdatam),
    .HMASTLOCKM3         (hmasterlockm),
    .HAUSERM3            (32'b0),
    .HWUSERM3            (32'b0),

    // Input port SI4 (inputs from master 4)
    .HADDRM4             (haddrx),
    .HTRANSM4            (htransx),
    .HWRITEM4            (hwritex),
    .HSIZEM4             (hsizex),
    .HBURSTM4            (hburstx),
    .HPROTM4             (hprotx),
    .HWDATAM4            (hwdatax),
    .HMASTLOCKM4         (hmasterlockx),
    .HAUSERM4            (32'b0),
    .HWUSERM4            (32'b0),

    // Output port MI0 (inputs from slave 0)
    .HRDATAS0            (rom_hrdata),
    .HREADYOUTS0         (rom_hreadyout),
    .HRESPS0             (rom_hresp),
    .HRUSERS0            (),

    // Output port MI1 (inputs from slave 1)
    .HRDATAS1            (sram_hrdata),
    .HREADYOUTS1         (sram_hreadyout),
    .HRESPS1             (sram_hresp),
    .HRUSERS1            (),

    // Output port MI2 (inputs from slave 2)
    .HRDATAS2            (ahb_slave2_hrdata),
    .HREADYOUTS2         (ahb_slave2_hreadyout),
    .HRESPS2             (ahb_slave2_hresp),
    .HRUSERS2            (),

    // Output port MI3 (inputs from slave 3)
    .HRDATAS3            (ahbbridge_hrdata),
    .HREADYOUTS3         (ahbbridge_hreadyout),
    .HRESPS3             (ahbbridge_hresp),
    .HRUSERS3            (),

    // Output port MI4 (inputs from slave 4)
    .HRDATAS4            (ahb_slave4_hrdata),
    .HREADYOUTS4         (ahb_slave4_hreadyout),
    .HRESPS4             (ahb_slave4_hresp),
    .HRUSERS4            (),

    // Output port MI5 (inputs from slave 5)
    .HRDATAS5            (ahb_slave5_hrdata),
    .HREADYOUTS5         (ahb_slave5_hreadyout),
    .HRESPS5             (ahb_slave5_hresp),
    .HRUSERS5            (),

    // Output port MI6 (inputs from slave 6)
    .HRDATAS6            (ahb_slave6_hrdata),
    .HREADYOUTS6         (ahb_slave6_hreadyout),
    .HRESPS6             (ahb_slave6_hresp),
    .HRUSERS6            (),


    // Scan test dummy signals; not connected until scan insertion
    .SCANENABLE          (1'b0),   // Scan Test Mode Enable
    .SCANINHCLK          (1'b0),   // Scan Chain Input


    // Output port MI0 (outputs to slave 0)
    .HSELS0              (rom_hsel),
    .HADDRS0             (rom_haddr),
    .HTRANSS0            (rom_htrans),
    .HWRITES0            (rom_hwrite),
    .HSIZES0             (rom_hsize),
    .HBURSTS0            (rom_hburst),
    .HPROTS0             (          ),
    .HWDATAS0            (rom_hwdata),
    .HMASTLOCKS0         (          ),
    .HREADYMUXS0         (rom_hready),
    .HAUSERS0            (          ),
    .HWUSERS0            (          ),

    // Output port MI1 (outputs to slave 1)
    .HSELS1              (sram_hsel),
    .HADDRS1             (sram_haddr),
    .HTRANSS1            (sram_htrans),
    .HWRITES1            (sram_hwrite),
    .HSIZES1             (sram_hsize),
    .HBURSTS1            (sram_hburst),
    .HPROTS1             (   ),
    .HWDATAS1            (sram_hwdata),
    .HMASTLOCKS1         (   ),
    .HREADYMUXS1         (sram_hready),
    .HAUSERS1            (   ),
    .HWUSERS1            (   ),

    // Output port MI2 (outputs to slave 2)
    .HSELS2              (ahb_slave2_hsel),
    .HADDRS2             (ahb_slave2_haddr),
    .HTRANSS2            (ahb_slave2_htrans),
    .HWRITES2            (ahb_slave2_hwrite),
    .HSIZES2             (ahb_slave2_hsize),
    .HBURSTS2            (ahb_slave2_hburst),
    .HPROTS2             (ahb_slave2_hprot),
    .HWDATAS2            (ahb_slave2_hwdata),
    .HMASTLOCKS2         (ahb_slave2_hmasterlock),
    .HREADYMUXS2         (ahb_slave2_hready),
    .HAUSERS2            (),
    .HWUSERS2            (),

    // Output port MI3 (outputs to slave 3)
    .HSELS3              (ahbbridge_hsel),
    .HADDRS3             (ahbbridge_haddr),
    .HTRANSS3            (ahbbridge_htrans),
    .HWRITES3            (ahbbridge_hwrite),
    .HSIZES3             (ahbbridge_hsize),
    .HBURSTS3            (ahbbridge_hburst),
    .HPROTS3             (ahbbridge_hprot),
    .HWDATAS3            (ahbbridge_hwdata),
    .HMASTLOCKS3         (ahbbridge_hmasterlock),
    .HREADYMUXS3         (ahbbridge_hready),
    .HAUSERS3            (),
    .HWUSERS3            (),

    // Output port MI4 (outputs to slave 4)
    .HSELS4              (ahb_slave4_hsel),
    .HADDRS4             (ahb_slave4_haddr),
    .HTRANSS4            (ahb_slave4_htrans),
    .HWRITES4            (ahb_slave4_hwrite),
    .HSIZES4             (ahb_slave4_hsize),
    .HBURSTS4            (ahb_slave4_hburst),
    .HPROTS4             (ahb_slave4_hprot),
    .HWDATAS4            (ahb_slave4_hwdata),
    .HMASTLOCKS4         (ahb_slave4_hmasterlock),
    .HREADYMUXS4         (ahb_slave4_hready),
    .HAUSERS4            (),
    .HWUSERS4            (),

    // Output port MI5 (outputs to slave 5)
    .HSELS5              (ahb_slave5_hsel),
    .HADDRS5             (ahb_slave5_haddr),
    .HTRANSS5            (ahb_slave5_htrans),
    .HWRITES5            (ahb_slave5_hwrite),
    .HSIZES5             (ahb_slave5_hsize),
    .HBURSTS5            (ahb_slave5_hburst),
    .HPROTS5             (ahb_slave5_hprot),
    .HWDATAS5            (ahb_slave5_hwdata),
    .HMASTLOCKS5         (ahb_slave5_hmasterlock),
    .HREADYMUXS5         (ahb_slave5_hready),
    .HAUSERS5            (),
    .HWUSERS5            (),

    // Output port MI6 (outputs to slave 6)
    .HSELS6              (ahb_slave6_hsel),
    .HADDRS6             (ahb_slave6_haddr),
    .HTRANSS6            (ahb_slave6_htrans),
    .HWRITES6            (ahb_slave6_hwrite),
    .HSIZES6             (ahb_slave6_hsize),
    .HBURSTS6            (ahb_slave6_hburst),
    .HPROTS6             (ahb_slave6_hprot),
    .HWDATAS6            (ahb_slave6_hwdata),
    .HMASTLOCKS6         (ahb_slave6_hmasterlock),
    .HREADYMUXS6         (ahb_slave6_hready),
    .HAUSERS6            (),
    .HWUSERS6            (),

    // Input port SI0 (outputs to master 0)
    .HRDATAM0            (hrdatai),
    .HREADYM0            (hreadyi),
    .HRESPM0             (hrespi),
    .HRUSERM0            (),

    // Input port SI1 (outputs to master 1)
    .HRDATAM1            (hrdatad),
    .HREADYM1            (hreadyd),
    .HRESPM1             (hrespd),
    .HRUSERM1            (),

    // Input port SI2 (outputs to master 2)
    .HRDATAM2            (hrdatas),
    .HREADYM2            (hreadys),
    .HRESPM2             (hresps),
    .HRUSERM2            (),

    // Input port SI3 (outputs to master 3)
    .HRDATAM3            (hrdatam),
    .HREADYM3            (hredaym),
    .HRESPM3             (hrespm),
    .HRUSERM3            (),            

    // Input port SI4 (outputs to master 4)
    .HRDATAM4           (hrdatax),
    .HREADYM4           (hredayx),
    .HRESPM4            (hrespx),
    .HRUSERM4           (),        

    // Scan test dummy signals; not connected until scan insertion
    .SCANOUTHCLK         ()    // Scan Chain Output

);

/*****************************************************/

ahb_rom #(    .ADDR_WIDTH         (17)
)   ahb_slave0_m3_rom(
    .hclk               (clk),
    .hresetn            (cpuresetn),
    .hsel               (rom_hsel),
    .hready             (rom_hready),
    .htrans             (rom_htrans),
    .hsize              (rom_hsize),
    .haddr              (rom_haddr),
    .hburst             (rom_hburst),
    .hwrite             (rom_hwrite),
    .hwdata             (rom_hwdata),
    .hreadyout          (rom_hreadyout),
    .hrdata             (rom_hrdata),
    .hresp              (rom_hresp)   
);


/*****************************************************/

ahb_sram #(  .ADDR_WIDTH         (18)
)   ahb_slave1_m3_sram  (
    .hclk               (clk),
    .hresetn            (cpuresetn),
    .hsel               (sram_hsel),
    .hready             (sram_hready),
    .htrans             (sram_htrans),
    .hsize              (sram_hsize),
    .haddr              (sram_haddr),
    .hburst             (sram_hburst),
    .hwrite             (sram_hwrite),
    .hwdata             (sram_hwdata),
    .hreadyout          (sram_hreadyout),
    .hrdata             (sram_hrdata),
    .hresp              (sram_hresp)
);

/*****************************************************/

ahb_default_slave   ahb_slave2(
    // Inputs
    .HCLK               (clk),      // Clock
    .HRESETn            (cpuresetn),   // Reset
    .HSEL               (ahb_slave2_hsel),      // Slave select
    .HTRANS             (ahb_slave2_htrans),    // Transfer type
    .HREADY             (ahb_slave2_hready),    // System ready
             
    // Outputs
    .HREADYOUT          (ahb_slave2_hreadyout), // Slave ready
    .HRESP              (ahb_slave2_hresp[0])  // Slave response
);    

assign  ahb_slave2_hresp[1] = 1'b0;
assign  ahb_slave2_hrdata   = 32'b0;  

/*****************************************************/

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
wire            txint;
wire            rxint;
wire            txovrint;
wire            rxovrint;
wire            uartint;                   

/*****************************************************/

apb_top #(
    .ADDRWIDTH          (16)
)   ahb_slave3_apb_top(
     
    .hclk               (clk),    // Clock
    .hresetn            (cpuresetn),    // Reset
    .pclken             (1'b1),    // APB clock enable signal
    
    .hsel               (ahbbridge_hsel),    // Device select
    .haddr              (ahbbridge_haddr),    // Address
    .htrans             (ahbbridge_htrans),    // Transfer control
    .hsize              (ahbbridge_hsize),    // Transfer size
    .hprot              (ahbbridge_hprot),    // Protection control
    .hwrite             (ahbbridge_hwrite),    // Write control
    .hready             (ahbbridge_hready),    // Transfer phase done
    .hwdata             (ahbbridge_hwdata),    // Write data
    
    .hreadyout          (ahbbridge_hreadyout),    // Device ready
    .hrdata             (ahbbridge_hrdata),    // Read data output
    .hresp              (ahbbridge_hresp[0]),    // Device response 


    .txd                (txd),
    .rxd                (rxd),
	 
    .txint              (txint),
    .rxint              (rxint),
    .txovrint           (txovrint),
    .rxovrint           (rxovrint),
    .uartint            (uartint),
    .led                (led)
);
assign  ahbbridge_hresp[1] = 1'b0;

/*****************************************************/

ahb_default_slave   ahb_slave4(
    // Inputs
    .HCLK               (clk),      // Clock
    .HRESETn            (cpuresetn),   // Reset
    .HSEL               (ahb_slave4_hsel),      // Slave select
    .HTRANS             (ahb_slave4_htrans),    // Transfer type
    .HREADY             (ahb_slave4_hready),    // System ready
             
    // Outputs
    .HREADYOUT          (ahb_slave4_hreadyout), // Slave ready
    .HRESP              (ahb_slave4_hresp[0])  // Slave response
);    

assign  ahb_slave4_hresp[1] = 1'b0;
assign  ahb_slave4_hrdata   = 32'b0; 

/*****************************************************/

ahb_default_slave   ahb_slave5(
    // Inputs
    .HCLK               (clk),      // Clock
    .HRESETn            (cpuresetn),   // Reset
    .HSEL               (ahb_slave5_hsel),      // Slave select
    .HTRANS             (ahb_slave5_htrans),    // Transfer type
    .HREADY             (ahb_slave5_hready),    // System ready
             
    // Outputs
    .HREADYOUT          (ahb_slave5_hreadyout), // Slave ready
    .HRESP              (ahb_slave5_hresp[0])  // Slave response
);    

assign  ahb_slave5_hresp[1] = 1'b0;
assign  ahb_slave5_hrdata   = 32'b0; 

/*****************************************************/

ahb_default_slave   ahb_slave6(
    // Inputs
    .HCLK               (clk),      // Clock
    .HRESETn            (cpuresetn),   // Reset
    .HSEL               (ahb_slave6_hsel),      // Slave select
    .HTRANS             (ahb_slave6_htrans),    // Transfer type
    .HREADY             (ahb_slave6_hready),    // System ready
             
    // Outputs
    .HREADYOUT          (ahb_slave6_hreadyout), // Slave ready
    .HRESP              (ahb_slave6_hresp[0])  // Slave response
);    

assign  ahb_slave6_hresp[1] = 1'b0;
assign  ahb_slave6_hrdata   = 32'b0; 

/*****************************************************/

assign irq = {237'b0,txovrint|rxovrint,txint,rxint};



endmodule
