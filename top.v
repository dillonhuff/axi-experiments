module top();

   parameter DATA_WIDTH = 32;
   parameter ADDR_WIDTH = 5;
   parameter STRB_WIDTH = (DATA_WIDTH/8);
   
   reg clk, rst;

   reg [ADDR_WIDTH-1:0] s_axil_awaddr;

   // Not used   
   reg [2:0]            s_axil_awprot;

   reg                  s_axil_awvalid;

   wire                 s_axil_awready;

   reg [DATA_WIDTH-1:0] s_axil_wdata;
   reg [STRB_WIDTH-1:0] s_axil_wstrb;
   reg                  s_axil_wvalid;

   wire                 s_axil_wready;

   wire [1:0]           s_axil_bresp;
   wire                 s_axil_bvalid;

   reg                  s_axil_bready;
   reg [ADDR_WIDTH-1:0] s_axil_araddr;

   // Not used
   reg [2:0]            s_axil_arprot;

   reg                  s_axil_arvalid;

   wire                 s_axil_arready;
   wire [DATA_WIDTH-1:0] s_axil_rdata;
   wire [1:0]            s_axil_rresp;
   wire                  s_axil_rvalid;

   reg                   s_axil_rready;
   

   axil_ram #(.DATA_WIDTH(32), .ADDR_WIDTH(5))
   ram(.clk(clk),
       .rst(rst),
       .s_axil_awaddr(s_axil_awaddr),
       .s_axil_awprot(s_axil_awprot),
       .s_axil_awvalid(s_axil_awvalid),
       .s_axil_awready(s_axil_awready));
   
endmodule
