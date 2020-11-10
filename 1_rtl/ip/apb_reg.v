module apb_reg(
    input    wire           pclk       ,
    input    wire           presetn    ,
                                      
    input    wire           psels      ,
    input    wire [11:2]    paddr      ,
    input    wire           penable    ,
    input    wire           pwrites    ,
    input    wire [31:0]    pwdatas    ,
    
    output   reg  [31:0]    prdatas    ,
    output   wire           pready     ,
    output   wire           pslverr    ,
    
    output   reg  [ 3:0]    led        
);


    always @(posedge pclk or negedge presetn)
        if(!presetn)begin
            led <= 4'b0;
        end
        else if(psels&pwrites&penable)begin
            case(paddr[5:2])
                4'h3 : led <= pwdatas[3:0];
            endcase 
        end
    always @(posedge pclk or negedge presetn)
        if(!presetn)begin
            prdatas <= 32'b0;
        end
        else if(psels&(!pwrites)&penable)begin
            prdatas <= {28'b0,led[3:0]};
        end
    
     
    assign pready  = 1'b1;
    assign pslverr = 1'b0;

endmodule
