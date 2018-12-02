// Q: I can get the slave to write data and read data, how do I encapsulate
//    this in to something I can use in my HLS tool?
// A: Maybe create write modules and communicate modules?
//    1. Assume write data and valid show up at the same time
//    2. Handle waiting for the write response to return

// NOTE: Part of the problem with hardware modularity is that you can't
// hide the interface to a shared resource inside another component, it
// has to be instantiated and shared across components to be usable.

module axi_write_handler(input clk,
                         input                           rst,

                         // User facing API
                         input [DATA_WIDTH - 1 : 0]      write_data,
                         input [ADDR_WIDTH - 1 : 0]      write_addr,
                         input                           start_write,

                         output                          ready,

                         // AXI module API
                         output reg                      s_axil_awvalid,
                         output reg                      s_axil_wvalid,

                         output reg [DATA_WIDTH - 1 : 0] s_axil_wdata,
                         output reg [ADDR_WIDTH - 1 : 0] s_axil_awaddr,

                         input                           s_axil_bvalid,
                         input [1:0]                     s_axil_bresp,

                         output [STRB_WIDTH-1:0]         s_axil_wstrb,
                         output                          s_axil_bready
                        );

   parameter DATA_WIDTH = 32;
   parameter ADDR_WIDTH = 5;
   parameter STRB_WIDTH = (DATA_WIDTH/8);

   reg                         ready_reg;

   assign ready = ready_reg;

   assign s_axil_bready = 1'b1;
   assign s_axil_wstrb = 5'b11111;
   
   always @(posedge clk) begin
      if (rst) begin
         ready_reg <= 1;

         s_axil_wvalid <= 0;
         s_axil_awvalid <= 0;

         $display("Reset");
         
      end else if (start_write) begin

         s_axil_wvalid <= 1;
         s_axil_awvalid <= 1;

         s_axil_wdata <= write_data;
         s_axil_awaddr <= write_addr;

         ready_reg <= 0;

      end else if (s_axil_bvalid && (!s_axil_bresp)) begin
         ready_reg <= 1;

         s_axil_wvalid <= 0;
         s_axil_awvalid <= 0;
      end
   end

endmodule // axi_write_handler

module axi_read_handler(input clk,
                        input                           rst,

                        // User facing API
                        output reg [DATA_WIDTH - 1 : 0] read_data,
                        input [ADDR_WIDTH - 1 : 0]      read_addr,
                        input                           start_read,

                        output reg                      ready,

                        // AXI facing API
                        output reg                      s_axil_rready,
                        output reg                      s_axil_arvalid,
                        output reg [ADDR_WIDTH - 1 : 0] s_axil_araddr,
                        input                           s_axil_arready, 
                        input [DATA_WIDTH - 1 : 0]      s_axil_rdata);
   
   parameter DATA_WIDTH = 32;
   parameter ADDR_WIDTH = 5;
   parameter STRB_WIDTH = (DATA_WIDTH/8);

   always @(posedge clk) begin
      if (rst) begin
         ready <= 1;
         s_axil_arvalid <= 0;
         
      end else if (start_read) begin
         ready <= 0;

         s_axil_rready <= 1;
         s_axil_arvalid <= 1;
         s_axil_araddr <= read_addr;
         
      end else if (s_axil_arready) begin
         read_data <= s_axil_rdata;
      end
   end

      // $display("slave read is ready   = %d", s_axil_arready);
      // $display("slave data            = %d", s_axil_rdata);      

endmodule

module top();

   parameter DATA_WIDTH = 32;
   parameter ADDR_WIDTH = 5;
   parameter STRB_WIDTH = (DATA_WIDTH/8);
   
   reg clk, rst;

   reg [ADDR_WIDTH-1:0] write_addr;
   reg [DATA_WIDTH-1:0] write_data;
   reg                  start_write;
   wire                 write_ready;
   

   reg [ADDR_WIDTH-1:0] read_addr;
   wire [DATA_WIDTH-1:0] read_data;
   reg                  start_read;
   wire                  read_ready;
   
   // Not used   
   reg [2:0]            s_axil_awprot;
   // Not used
   reg [2:0]            s_axil_arprot;

   wire [ADDR_WIDTH-1:0] s_axil_awaddr;

   wire [DATA_WIDTH-1:0] s_axil_wdata;
   wire [STRB_WIDTH-1:0] s_axil_wstrb;
   wire                  s_axil_wvalid;
   wire                 s_axil_bready;

   wire [ADDR_WIDTH-1:0] s_axil_araddr;
   wire                 s_axil_arvalid;
   wire                   s_axil_rready;

   
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

      #1 clk = 0;
      #1 clk = 1;

      #1 rst = 0;      

      #1 write_addr = 1;
      #1 write_data = 2345;
      #1 start_write = 1;

      $display("slave write is ready   = %d", s_axil_awready);
      $display("slave write data ready = %d", s_axil_wready);
      $display("slave write data valid = %d", s_axil_bvalid);
      $display("slave write response   = %d", s_axil_bresp);
      $display("-------------------------");
      
      #1 clk = 0;
      #1 clk = 1;

      #1 start_write = 0;

      $display("slave write is ready   = %d", s_axil_awready);
      $display("slave write data ready = %d", s_axil_wready);
      $display("slave write data valid = %d", s_axil_bvalid);
      $display("slave write response   = %d", s_axil_bresp);
      $display("-------------------------");
      
      #1 clk = 0;
      #1 clk = 1;

      #1 start_write = 0;

      $display("slave write is ready   = %d", s_axil_awready);
      $display("slave write data ready = %d", s_axil_wready);
      $display("slave write data valid = %d", s_axil_bvalid);
      $display("slave write response   = %d", s_axil_bresp);
      $display("-------------------------");

      read_addr = 1;
      start_read = 1;
      
      #1 clk = 0;
      #1 clk = 1;

      #1 start_read = 0;
      
      $display("slave read is ready   = %d", read_data);
      $display("-------------------------");
      
      #1 clk = 0;
      #1 clk = 1;

      $display("slave read is ready   = %d", read_data);
      $display("-------------------------");
      
      #1 clk = 0;
      #1 clk = 1;

      $display("slave read is ready   = %d", read_data);
      $display("-------------------------");
      
      #1 clk = 0;
      #1 clk = 1;

      $display("slave read is ready   = %d", read_data);
      $display("-------------------------");
      
      #1 clk = 0;
      #1 clk = 1;


      #1 clk = 0;
      #1 clk = 1;

   end // initial begin

   always @(posedge clk) begin
      if (s_axil_bvalid) begin
         $display("Write address valid");

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
   
       
   axi_write_handler write_handler(.clk(clk),
                                   .rst(rst),

                                   // User facing API
                                   .write_data(write_data),
                                   .write_addr(write_addr),
                                   .start_write(start_write),

                                   .ready(write_ready),

                                   // AXI module API
                                   .s_axil_awvalid(s_axil_awvalid),
                                   .s_axil_wvalid(s_axil_wvalid),

                                   .s_axil_wdata(s_axil_wdata),
                                   .s_axil_awaddr(s_axil_awaddr),

                                   .s_axil_bvalid(s_axil_bvalid),
                                   .s_axil_bresp(s_axil_bresp),

                                   .s_axil_wstrb(s_axil_wstrb),
                                   .s_axil_bready(s_axil_bready)
                                   );

   axi_read_handler read_handle(.clk(clk),
                                .rst(rst),

                                .read_data(read_data),
                                .read_addr(read_addr),
                                .start_read(start_read),

                                .ready(read_ready),

                                .s_axil_rready(s_axil_rready),
                                .s_axil_arvalid(s_axil_arvalid),
                                .s_axil_araddr(s_axil_araddr),
                                .s_axil_arready(s_axil_arready), 
                                .s_axil_rdata(s_axil_rdata)
                                );
   
endmodule
