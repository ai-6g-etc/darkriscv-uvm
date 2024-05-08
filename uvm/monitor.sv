
class monitor extends uvm_monitor;
    virtual darksocv_if darksocv_vif;
    packet_darksocv tr;
    uvm_analysis_port #(packet_darksocv) item_collected_port;
    `uvm_component_utils(monitor)
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual darksocv_if)::get(this, "", "darksocv_vif", darksocv_vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".darksocv_vif"})
        tr = packet_darksocv::type_id::create("tr", this);
        item_collected_port = new ("item_collected_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_transactions(phase);
        join
    endtask

    virtual task collect_transactions(uvm_phase phase);
        wait(darksocv_vif.XRES === 1);
        @(negedge darksocv_vif.XRES);
        
        forever begin
            do begin
                @(posedge darksocv_vif.XCLK);
            end while (darksocv_vif.UART_RXD === 0);
            
            tr.UART_RXD = darksocv_vif.UART_RXD;
            item_collected_port.write(tr);

            @(posedge darksocv_vif.XCLK);
        end
    endtask
endclass