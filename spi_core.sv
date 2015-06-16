/*******************************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________

--Module Name:
--Project Name:
--Chinese Description:
	
--English Description:
	
--Version:VERA.1.0.0
--Data modified:
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
--Data created:2015/6/16 10:15:15
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module spi_core #(
	parameter	PHASE	= 0,
	parameter	ACTIVE	= 0,
	parameter	Freq	= 16
)(
	output		cs_n		,
	output		mosi		,
	input		miso		,
	output		sck 		
);

wire		clock;
wire		rst_n;
event		wr_fsh;
event		rd_fsh;

clock_rst clk_c0(
	.clock		(clock),
	.rst		(rst_n)
);

defparam clk_c0.ACTIVE = 0;
initial begin:INITIAL_CLOCK
	clk_c0.run(10 , 1000/(2*Freq) ,0);		//	
end

bit		model_clk;
bit		model_cs_n	= 1;
bit		model_idata;
bit		model_odata;
int		len_cnt;
int		bit_cnt;
int		byte_cnt;

task Clk_Cs_Task (
	int			number
);
	model_cs_n	= 1;
	model_clk	= (ACTIVE == 0)? 0 : 1;
	repeat(2)			@(posedge clock);
	model_cs_n	= 0;
	repeat(number*2)begin	
		@(posedge clock);
		model_clk	= ~model_clk;
	end
	repeat(1)			@(posedge clock);
	model_cs_n	= 1;
endtask:Clk_Cs_Task

always@(negedge model_cs_n)begin
	if(PHASE == 0)begin
		len_cnt		= 1;
		byte_cnt	= 1;
		bit_cnt		= 1;
	end else begin
		len_cnt		= 'dz;
		byte_cnt	= 'dz;
		bit_cnt		= 'dz;
		@(model_clk);
		len_cnt		= 1;
		byte_cnt	= 1;
		bit_cnt		= 1;
end end

always@(model_clk)begin
	if(	(ACTIVE == 0 && model_clk == 0) ||
		(ACTIVE == 1 && model_clk == 1)   )begin
		len_cnt		<= len_cnt + 1;
		byte_cnt	<= len_cnt/8+1;
end end

always@(len_cnt)
	if(len_cnt > 0)
			bit_cnt	= (len_cnt-1)%8+1;
	else	bit_cnt = 0;

always@(posedge model_cs_n)begin
	len_cnt		= 'dz;
	byte_cnt	= 'dz;
	bit_cnt		= 'dz;
end
			
logic[7:0]		wr_seq [$];
logic[7:0]		wr_data;


function bit Wr_bit;
	Wr_bit	= wr_data[0];
	wr_data	= wr_data >> 1;
endfunction: Wr_bit

task Wr_Data_Task;
foreach (wr_seq[i])begin
	wr_data	= wr_seq[i];
	repeat(8)begin
		if(PHASE == 0 )begin
			if(ACTIVE == 0)	@(negedge model_cs_n,negedge model_clk,posedge model_cs_n);
			else 			@(negedge model_cs_n,posedge model_clk,posedge model_cs_n);
			model_odata	= Wr_bit();
		end else begin
			if(ACTIVE == 0)	@(posedge model_clk,posedge cs_n);
			else 			@(negedge model_clk,posedge cs_n);
			model_odata	= Wr_bit();
	end end
end
model_odata	= 1'bx;
endtask: Wr_Data_Task

logic[7:0]		rd_seq	[$];
logic[7:0]		rd_data;
int				rd_cnt	= 0;

function void Rd_bit;
	rd_data 	= rd_data << 1;
	rd_data[0]	= model_idata;
	rd_cnt		= rd_cnt;
endfunction: Rd_bit

function void Rd_to_Seq;
	Rd_bit();
	if(rd_cnt != 0 && (rd_cnt%8) == 0)begin
		rd_seq.push_back(rd_data);
	end
endfunction: Rd_to_Seq

task Rd_Data_Task;
	@(negedge model_cs_n);
	while(model_cs_n == 1'b0)begin
		if(PHASE == 0 )begin
			if(ACTIVE == 0)	@(posedge model_clk,posedge model_cs_n);
			else 			@(negedge model_clk,posedge model_cs_n);
			Rd_to_Seq();
		end else begin
			if(ACTIVE == 0)	@(negedge model_clk,posedge model_cs_n);
			else 			@(posedge model_clk,posedge model_cs_n);
			Rd_to_Seq();
	end end
endtask: Rd_Data_Task

task Burst_Write(input logic [7:0]	seq [$] = wr_seq);begin
	wr_seq	= seq;
	@(posedge clock);
	if(1)fork
		Clk_Cs_Task(8*wr_seq.size());
		Wr_Data_Task;
	join
	-> wr_fsh;
	$display("================MOSI===================");
	$display("-->>> write length: %d byte(8bit)",seq.size());
end
endtask: Burst_Write

task Burst_Read(
	int len);
	rd_seq	= {};
	@(posedge clock);
	if(1)fork
		Clk_Cs_Task(len*8);
		Rd_Data_Task;
	join
	-> rd_fsh;
	$display("================MISO===================");
	$display("-->>> read length: %d byte(8bit)",rd_seq.size());
endtask: Burst_Read
	


assign	cs_n			= model_cs_n;
assign	mosi			= model_odata;
assign	model_idata		= miso;
assign	sck				= model_clk;


endmodule





			
	
	
	
	
