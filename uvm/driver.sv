`default_nettype none

class driver extends uvm_driver #(packet_darksocv);
    `uvm_component_utils(driver)
    virtual darksocv_if darksocv_vif;

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual darksocv_if)::get(this, "", "darksocv_vif", darksocv_vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".darksocv_vif"})
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            get_and_drive(phase);
        join
    endtask

    virtual protected task reset_signals();
        wait (darksocv_vif.XRES === 1);
        forever begin
            darksocv_vif.UART_TXD <= '0;
            @(posedge darksocv_vif.XRES);
        end
    endtask

    virtual protected task get_and_drive(uvm_phase phase);
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

    virtual protected task drive_transfer(packet_darksocv tr);
        darksocv_vif.UART_TXD = tr.UART_TXD;
        @(posedge darksocv_vif.XCLK); //hold time
    endtask
endclass