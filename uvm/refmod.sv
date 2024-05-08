class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
    packet_darksocv tr_in;
    packet_darksocv tr_out;
    uvm_get_port #(packet_darksocv) in;
    uvm_put_port #(packet_darksocv) out;
    
    function new(string name = "refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = packet_darksocv::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            in.get(tr_in);
            tr_out.UART_TXD = tr_in.UART_RXD;
            tr_out.LED = 4'b1111;
            tr_out.DEBUG = 4'b1111;
            out.put(tr_out);
        end
    endtask: run_phase
endclass: refmod
