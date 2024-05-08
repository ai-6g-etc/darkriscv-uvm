class driver_out extends uvm_driver#(packet_darksocv);
    `uvm_component_utils(driver_out)

    virtual darksocv_if darksocv_vif;
    uvm_sequencer#(packet_darksocv) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual darksocv_if)::get(this, "", "darksocv_vif", darksocv_vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".darksocv_vif"})
        
        sequencer = uvm_sequencer#(packet_darksocv)::type_id::create("sequencer", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        seq_item_port.connect(sequencer.seq_item_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            drive_packet();
        join
    endtask

    virtual task drive_packet();
        packet_darksocv req;
        wait(darksocv_vif.XRES === 1);
        @(negedge darksocv_vif.XRES);
        @(posedge darksocv_vif.XCLK);
        
        forever begin
            seq_item_port.get_next_item(req);
            drive_transfer(req);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_transfer(packet_darksocv tr);
        darksocv_vif.UART_TXD = tr.UART_TXD;
        @(posedge darksocv_vif.XCLK); //hold time
    endtask
endclass