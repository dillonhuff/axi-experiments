module top();

   parameter DATA_WIDTH = 32;
   parameter ADDR_WIDTH = 5;
   parameter STRB_WIDTH = (DATA_WIDTH/8);
   
   reg clk, rst;

   reg [ADDR_WIDTH-1:0] s_axil_awaddr;

   // Not used   
   reg [2:0]            s_axil_awprot;
   // Not used
   reg [2:0]            s_axil_arprot;

   reg                  s_axil_awvalid;
   reg [DATA_WIDTH-1:0] s_axil_wdata;
   reg [STRB_WIDTH-1:0] s_axil_wstrb;
   reg                  s_axil_wvalid;
   reg                  s_axil_bready;

   reg [ADDR_WIDTH-1:0] s_axil_araddr;
   reg                  s_axil_arvalid;
   reg                   s_axil_rready;

   
   wire                 s_axil_awready;
   wire                 s_axil_wready;
   wire [1:0]           s_axil_bresp;
   wire                 s_axil_bvalid;


   wire                 s_axil_arready;
   wire [DATA_WIDTH-1:0] s_axil_rdata;
   wire [1:0]            s_axil_rresp;
   wire                  s_axil_rvalid;


   initial begin
      #1 rst = 1;

      s_axil_wdata = 2345;
      s_axil_wvalid = 1;
      s_axil_awvalid = 1;
      s_axil_wstrb = 5'b11111;

      s_axil_arvalid = 0;
      
      #1 clk = 0;
      #1 clk = 1;
      

      #1 rst = 0;

      $display("slave write is ready   = %d", s_axil_awready);
      $display("slave write data ready = %d", s_axil_wready);
      $display("slave write data valid = %d", s_axil_bvalid);
      $display("slave write response   = %d", s_axil_bresp);
      $display("-------------------------");
      
      #1 clk = 0;
      #1 clk = 1;

      $display("slave write is ready   = %d", s_axil_awready);
      $display("slave write data ready = %d", s_axil_wready);
      $display("slave write data valid = %d", s_axil_bvalid);
      $display("slave write response   = %d", s_axil_bresp);
      $display("-------------------------");
      
      #1 clk = 0;
      #1 clk = 1;

      $display("slave write is ready   = %d", s_axil_awready);
      $display("slave write data ready = %d", s_axil_wready);
      $display("slave write data valid = %d", s_axil_bvalid);
      $display("slave write response   = %d", s_axil_bresp);
      $display("-------------------------");

      #1 clk = 0;
      #1 clk = 1;

      $display("slave write is ready   = %d", s_axil_awready);
      $display("slave write data ready = %d", s_axil_wready);
      $display("slave write data valid = %d", s_axil_bvalid);
      $display("slave write response   = %d", s_axil_bresp);
      $display("-------------------------");

      #1 clk = 0;
      #1 clk = 1;

      $display("slave write is ready   = %d", s_axil_awready);
      $display("slave write data ready = %d", s_axil_wready);
      $display("slave write data valid = %d", s_axil_bvalid);
      $display("slave write response   = %d", s_axil_bresp);
      $display("-------------------------");


      #1 clk = 0;
      #1 clk = 1;

      $display("slave read is ready   = %d", s_axil_arready);
      $display("-------------------------");

      #1 clk = 0;
      #1 clk = 1;

      $display("slave read is ready   = %d", s_axil_arready);
      $display("-------------------------");

      #1 clk = 0;
      #1 clk = 1;

      $display("slave read is ready   = %d", s_axil_arready);
      $display("-------------------------");

      #1 clk = 0;
      #1 clk = 1;

      $display("slave read is ready   = %d", s_axil_arready);
      $display("-------------------------");
      
   end // initial begin

   always @(posedge clk) begin
      if (s_axil_bvalid) begin
         $display("Write address valid");

         s_axil_wvalid <= 0;
         s_axil_awvalid <= 0;

         s_axil_rready <= 1;
         s_axil_arvalid <= 1;
         s_axil_araddr <= 1;

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
