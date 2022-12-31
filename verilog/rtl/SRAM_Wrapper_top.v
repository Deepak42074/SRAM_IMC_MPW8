// Design name : SRAM_top

module SRAM_Wrapper_top #(
	parameter WIDTH_WB_DATA = 32,
	parameter WIDTH_ADD = 32,
	parameter IMC_OUT_WIDTH = 16,				// Deepak -30/12/22 -edited to 16 bit(previously 64 bit)for MPW8
	parameter SRAM_OUT_WIDTH = 16,
	parameter MEM_ROW = 16
) (

inout VCLP,							// connect to Analog IO
inout EN,							// connect to Analog IO			
inout Iref0,							// connect to Analog IO
inout Iref1,							// connect to Analog IO
inout Iref2,							// connect to Analog IO
inout Iref3,							// connect to Analog IO
inout VDD,
inout VSS,

inout Iout0,							// Deepak -30/12/22 - added for MPW8
inout Iout1,							// Deepak -30/12/22 - added for MPW8
inout Iout2,							// Deepak -30/12/22 - added for MPW8
inout Iout3,							// Deepak -30/12/22 - added for MPW8

input clk,							//Common clock
input reset_n,							//wb_rst_i	
input wbs_we_i ,						//wbs_we_i=0 for read ;wbs_we_i=1 for write		
input [WIDTH_WB_DATA - 1 : 0] wishbone_buffer_data_in, 	//wbs_dat_i
input [WIDTH_ADD - 1 : 0] wishbone_rw_addr,			//wishbone_addr

output [WIDTH_WB_DATA - 1 : 0] wishbone_databus_out,	 	//wbs_dat_o
output EN_VCLP,						//Deepak_28/11/22: needs to be passed to analog_DUT for EN & VCLP enable
								//currently taking out to LA
output MAC_starting,						// Deepak : Enable for MUX for Iref			
output  [1:0] OB_demux,					// Deepak: select line for Irefs
output [2:0]controller_opcode,
output [1:0]controller_ext_state,
output [2:0]controller_int_state,
output full_IB,
output full_WB, 
output full_SA, 
output full_OB,
output empty_IB, 
output empty_WB, 
output empty_SA, 
output empty_OB


);

//=============================== Signal Declaration =========================================
			
wire [IMC_OUT_WIDTH -1 : 0] IMC_out;
wire [SRAM_OUT_WIDTH -1 : 0] SA_out;
wire [MEM_ROW -1 : 0] SRAM_Din;   				// RICHA : New!!
wire  PRE_SRAM;
wire  [MEM_ROW -1: 0] WWL;
wire  WE;
wire  PRE_VLSA;
wire  PRE_CLSA;
wire  PRE_A;
wire  [MEM_ROW -1: 0] RWL; 
wire  [MEM_ROW -1: 0] RWLB;
wire  SAEN; 
wire  EN_VCLP;							// RICHA : enable for EN and VCLP				
reg [7:0] WWLD;

//===========================================================================

//===========SRAM Controller Instantiation  =================================
top Digital_DUT(
.clk(clk),
.reset_n(reset_n),
.wbs_we_i(wbs_we_i),
.wishbone_buffer_data_in(wishbone_buffer_data_in),
.wishbone_rw_addr(wishbone_rw_addr),
.wishbone_databus_out(wishbone_databus_out),
.IMC_out(IMC_out),
.SA_out(SA_out),
.SRAM_Din(SRAM_Din),
.PRE_SRAM(PRE_SRAM),
.WWL(WWL),
.WE(WE),
.PRE_VLSA(PRE_VLSA), 
.PRE_CLSA(PRE_CLSA), 
.PRE_A(PRE_A),
.RWL(RWL), 
.RWLB(RWLB),
.SAEN(SAEN), 
.en(EN_VCLP),	
.WWLD(WWLD),
.MAC_starting(MAC_starting),
.OB_demux(OB_demux),
.controller_opcode(controller_opcode),
.controller_ext_state(controller_ext_state),
.controller_int_state(controller_int_state),
.full_IB(full_IB),
.full_WB(full_WB), 
.full_SA(full_SA), 
.full_OB(full_OB),
.empty_IB(empty_IB), 
.empty_WB(empty_WB), 
.empty_SA(empty_SA), 
.empty_OB(empty_OB)
);

//===========================================================================
//============================ SRAM Array Analog part instantiation =========

Integrated_bitcell_with_dummy_cells  Analog_DUT (
.WWL(WWL),
.WWLD(WWLD),
.RWL(RWL),
.RWLB(RWLB),
.Din(SRAM_Din),
.WE(WE), 
.PRE_SRAM(PRE_SRAM),
.PRE_VLSA(PRE_VLSA), 
.PRE_CLSA(PRE_CLSA),
.PRE_A(PRE_A), 
.SAEN(SAEN),
.VCLP(VCLP),
.EN(EN),
.Iref0(Iref0), 
.Iref1(Iref1), 
.Iref2(Iref2),
.Iref3(Iref3),
.Iout0(Iout0),					// Deepak -30/12/22 - added for MPW8
.Iout1(Iout1),					// Deepak -30/12/22 - added for MPW8
.Iout2(Iout2),					// Deepak -30/12/22 - added for MPW8
.Iout3(Iout3),					// Deepak -30/12/22 - added for MPW8
.VSS(VSS),
.VDD(VDD),
.OUT(IMC_out[15:0]),				// Deepak -30/12/22 - edited for MPW8(CLSA output)
.SA_OUT(SA_out)
);

//===========================================================================
endmodule
