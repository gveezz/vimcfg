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
    input wire sclk_i,
    input wire arst_i,
    input wire srst_i,
    // Data interface
    // -- inputs
    input wire data_vld_i,
    input wire [DATA_W-1:0] data_i,
    // -- outputs
    output reg data_vld_o,
    output reg [DATA_W-1:0] data_o
);

// External functions and tasks includes

// Localparams

// Sequerntial logic

// Combinational logic

// Wires

// Wires assignments

// Modules instantiations

// Module functionality
always @(posedge sclk_i or negedge arst_i) begin
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

