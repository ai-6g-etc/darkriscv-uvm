class packet_darksocv extends uvm_sequence_item;
    logic UART_RXD;
    logic UART_TXD;
    logic [3:0] LED;
    logic [3:0] DEBUG;

    `uvm_object_utils_begin(packet_darksocv)
        `uvm_field_int(UART_RXD, UVM_ALL_ON)
        `uvm_field_int(UART_TXD, UVM_ALL_ON)
        `uvm_field_int(LED, UVM_ALL_ON)
        `uvm_field_int(DEBUG, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="packet_darksocv");
        super.new(name);
    endfunction: new
endclass: packet_darksocv