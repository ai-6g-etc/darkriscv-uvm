interface darksocv_if(input XCLK, XRES);
    logic UART_RXD;
    logic UART_TXD;
    logic [3:0] LED;
    logic [3:0] DEBUG;
    
    modport port(input XCLK, XRES, output UART_TXD, LED, DEBUG, input UART_RXD);
endinterface
