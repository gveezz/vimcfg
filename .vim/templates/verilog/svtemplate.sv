`ifdef DEF_NET_NONE
    `default_nettype none
`endif 

// Headers include

module $COMPONENT_NAME #(
    // Configurable parameters
    parameter DATA_W = 8
) /* i_$COMPONENT_NAME */ (
    // System interface
    // -- inputs
    input logic sclk_i,
    input logic arst_i,
    input logic srst_i,
    // Data interface
    // --inputs
    input logic data_vld_i,
    input logic [DATA_W-1:0] data_i,
    // -- outputs
    output logic data_vld_o,
    output logic [DATA_W-1:0] data_o
);

// External functions and tasks includes

// Localparams

// Sequerntial logic

// Combinational logic

// Wires

// Wires assignments

// Modules instantiations

// Module functionality
always_comb begin

end

always_ff @(posedge sclk_i or negedge arst_i) begin
    if (!arst_i) begin
        data_vld_o <= 0;
        data_o <= 0;
    end else begin
        data_vld_o <= data_vld_i;
        data_o <= data_o;

        if (!srst_i) begin
            data_vld_o <= 0;
            data_o <= 0;
        end    
    end
end

endmodule 

