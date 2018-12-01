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

   initial begin
      #1 rst = 1;

      s_axil_wdata = 2345;
      s_axil_wvalid = 1;
      s_axil_awvalid = 1;
      
      #1 clk = 0;
      #1 clk = 1;
      

      #1 rst = 0;

      $display("slave write is ready = %d", s_axil_awready);
      $display("slave read is ready  = %d", s_axil_arready); 
      $display("-------------------------");
      
      
      #1 clk = 0;
      #1 clk = 1;

      $display("slave write is ready = %d", s_axil_awready);
      $display("slave read is ready  = %d", s_axil_arready); 
      $display("-------------------------");
      
      
      #1 clk = 0;
      #1 clk = 1;

      $display("slave write is ready = %d", s_axil_awready);
      $display("slave read is ready  = %d", s_axil_arready); 
      $display("-------------------------");
      
   end // initial begin

   always @(posedge clk) begin
      if (s_axil_arready) begin
      end
   end
   

   axil_ram #(.DATA_WIDTH(32), .ADDR_WIDTH(5))
   ram(.clk(clk),
       .rst(rst),
       .s_axil_awaddr(s_axil_awaddr),
       .s_axil_awprot(s_axil_awprot),
       .s_axil_awvalid(s_axil_awvalid),
       .s_axil_awready(s_axil_awready),
       .s_axil_wdata(s_axil_wdata),
       .s_axil_wstrb(s_axil_wstrb),
       .s_axil_wvalid(s_axil_wvalid),
       .s_axil_wready(s_axil_wready),
       .s_axil_bresp(s_axil_bresp),
       .s_axil_bvalid(s_axil_bvalid),
       .s_axil_bready(s_axil_bready),
       .s_axil_araddr(s_axil_araddr),
       .s_axil_arprot(s_axil_arprot),
       .s_axil_arvalid(s_axil_arvalid),
       .s_axil_arready(s_axil_arready),
       .s_axil_rdata(s_axil_rdata),
       .s_axil_rresp(s_axil_rresp),
       .s_axil_rvalid(s_axil_rvalid),
       .s_axil_rready(s_axil_rready));
   
       
   
endmodule
