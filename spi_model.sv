/*******************************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________

--Module Name:
--Project Name:
--Chinese Description:
	
--English Description:
	
--Version:VERA.1.0.0
--Data modified:2015/7/10 11:15:38
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
--Data created:
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module spi_model #(
parameter	PHASE	= 0,	
parameter	ACTIVE	= 0,
parameter	Freq	= 16
)(
	output		cs_n		,
	output		mosi		,
	input		miso		,
	output		sck 		
);

int			bit_cnt;
int			byte_cnt;
logic[7:0]	read_data  [$];
logic[7:0]	write_data [$] = {8'h00,8'h01,8'h02,8'h03,8'h04,8'h01,8'h02,8'h03,8'h04};

spi_core #(
	.PHASE			(PHASE	),
	.ACTIVE			(ACTIVE	),
	.Freq			(Freq	)
)spi_core_inst(
	.cs_n			(cs_n	),	
	.mosi			(mosi	),
	.miso			(miso	),
	.sck 			(sck 	)
);

task write (input logic [7:0]	D [$] = write_data);
	write_data	= D;
	spi_core_inst.Burst_Write(write_data);
endtask: write

task read (int length );
	spi_core_inst.Burst_Read(length); 
endtask: read

task cmd (input logic [7:0]	D [$] = write_data,int len = 8);
	write_data	= D;
	spi_core_inst.Burst_CMD(write_data,len);
endtask: cmd

task hold_cmd (input logic [7:0]	D [$] = write_data,int len = 8);
	write_data	= D;
	spi_core_inst.Pulse_CMD(write_data,len);
endtask: hold_cmd


//initial begin
//	spi_core_inst.Burst_Write(write_data);
////	spi_core_inst.Burst_Read(3);
//end

assign	bit_cnt		= spi_core_inst.bit_cnt;
assign	byte_cnt	= spi_core_inst.byte_cnt;
assign	read_data	= spi_core_inst.comp_rd_seq; 


endmodule





			
	
	
	
	
