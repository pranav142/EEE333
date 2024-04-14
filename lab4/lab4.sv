module freq_div #(parameter size=8) (input clk, reset, input [size-1:0] count_max, output logic [size-1:0] count, output logic clkout);
localparam Zero = {size{1'b0}}, One={{size-1{1'b0}}, 1'b1};

always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		count <= Zero;
		clkout <= 1'b0;
	end
	else if (count < count_max) 
		count <= count + One;
	else begin
		count <= Zero;
		clkout <= ~clkout;
	end
end
endmodule

module clocktime #(parameter size=8) (input clk, enable, reset, input [size-1:0] MaxVal, output logic [size-1:0] Count, output logic clkout);
localparam Zero = {size{1'b0}}, One={{size-1{1'b0}}, 1'b1};

always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		Count <= Zero;
		clkout <= 1'b0;
	end
	else if (enable)
		if (Count<MaxVal) begin
			Count <= Count + One;
			clkout <= 1'b0;
		end
		else begin
			Count <= Zero;
			clkout <= 1'b1;
		end
end

endmodule

module timer(input CLK_2Hz, CLK_1Hz, setMin, setHour, run, reset, output logic [7:0] Seconds, Minutes, Hours);
localparam fiftynine=8'd59, twentythree=8'd23;
logic Min_in, Hr_in, Days_in, enable_sec, enable_min, enable_hour;
logic clk_sec, clk_min, clk_hr;

clocktime secclock(clk_sec, run & enable_sec, reset, fiftynine, Seconds, Min_in);
clocktime minclock(clk_min, run & enable_min, reset, fiftynine, Minutes, Hr_in);
clocktime hoursclock(clk_hr, run & enable_hour, reset, twentythree, Hours, Days_in);

always_comb begin 
	clk_sec = CLK_1Hz; clk_min = Min_in; clk_hr = Hr_in;
	enable_sec = 1'b1; enable_min = 1'b1; enable_hour = 1'b1;
	if (setMin == 1'b1) begin
		clk_sec = 1'b0; clk_hr = 1'b0;
		enable_sec=1'b0; enable_hour=1'b0; enable_min=1'b1;
		clk_min = CLK_2Hz;
	end
	else if (setHour == 1'b1) begin
		clk_min = 1'b0; clk_sec = 1'b0;
		enable_sec = 1'b0; enable_min = 1'b0; enable_hour = 1'b1;
		clk_hr = CLK_2Hz;
	end
end
endmodule

module alarm_clock(input CLK_2Hz, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, output logic [7:0] sec, min, hrs, sec_alarm, min_alarm, hrs_alarm, output logic alarm);

logic [7:0] c1;
logic set_alarm_hr, set_alarm_min, set_clock_hr, set_clock_min, alarm_run, clock_run, CLK_1Hz;

freq_div #(8) onehertz (CLK_2Hz, reset, 8'd1, c1, CLK_1Hz);
timer alarm_tim(CLK_2Hz, CLK_1Hz, set_alarm_min, set_alarm_hr, alarm_run, reset, sec_alarm, min_alarm, hrs_alarm);
timer clock_tim(CLK_2Hz, CLK_1Hz, set_clock_min, set_clock_hr, clock_run, reset, sec, min, hrs);

always_comb begin
	alarm_run = 1'b0; set_alarm_min=1'b0; set_clock_min=1'b0; set_clock_hr=1'b0; set_alarm_hr=1'b0; clock_run = run;
	if (time_set) begin
		clock_run = 1'b1;
		if (sethrs1min0 == 1'b1) begin
			set_clock_hr = 1'b1;
		end 
		else begin
			set_clock_min = 1'b1;
		end
	end
	else if (alarm_set) begin
		alarm_run = 1'b1;
		if (sethrs1min0 == 1'b1) begin
			set_alarm_hr = 1'b1;
		end
		else  begin
			set_alarm_min = 1'b1;
		end
	end
end

always_ff @ (posedge alarmreset or posedge CLK_2Hz) begin
	if (alarmreset)
		alarm <= 1'b0;
	else if (activatealarm)
		alarm <= (sec == sec_alarm) && (min == min_alarm) && (hrs == hrs_alarm) || alarm;
end

endmodule

`timescale 1ns/1ps
module alarm_clock_tb();

logic clk, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, alarm;
logic [7:0] sec, min, hrs, sec_alarm, min_alarm, hrs_alarm;
alarm_clock a1 (clk, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, sec, min, hrs, sec_alarm, min_alarm, hrs_alarm, alarm);

initial begin
clk=1'b0; reset=1'b1; time_set=1'b0; alarm_set=1'b0; sethrs1min0=1'b0; run=1'b0; activatealarm=1'b0; alarmreset=1'b1; #10;
clk=1'b1; #10;

reset=1'b0; alarmreset=1'b0; alarm_set=1'b1; sethrs1min0=1'b1;
repeat (7) begin
	clk=1'b0; #10;
	clk=1'b1; #10;
end

sethrs1min0=1'b0;
repeat (22) begin
	clk=1'b0; #10;
	clk=1'b1; #10;
end

alarm_set=1'b0; time_set=1'b1; sethrs1min0=1'b1;
repeat (7) begin
	clk=1'b0; #10;
	clk=1'b1; #10;
end

sethrs1min0=1'b0;
repeat (21) begin
	clk=1'b0; #10;
	clk=1'b1; #10;
end

$display("Finished setting time");
time_set=1'b0; sethrs1min0=1'b0;
activatealarm=1'b1;
run=1'b1;

repeat (240) begin
	clk=1'b0; #10;
	clk=1'b1; #10;
end

alarmreset=1'b1; clk=1'b0; #10;
clk=1'b1; #10;

end

endmodule

module Dec27Seg(input [7:0] Decimal, output reg [6:0] HexSeg);
	always @ (*) begin
		HexSeg = 7'd0;
		case (Decimal)
			// 0
			8'd0 : begin
				HexSeg[6] = 1'b1;
			end
			// 1
			8'd1 : begin
				HexSeg[6] = 1'b1; HexSeg[0] = 1'b1; HexSeg[3] = 1'b1; HexSeg[5] = 1'b1; HexSeg[4] = 1'b1;
			end
			// 2
			8'd2 : begin
				HexSeg[5] = 1'b1; HexSeg[2] = 1'b1;
			end
			// 3
			8'd3 : begin
				HexSeg[5] = 1'b1; HexSeg[4] = 1'b1;
			end
			// 4
			8'd4 : begin
				HexSeg[0] = 1'b1; HexSeg[4] = 1'b1; HexSeg[3] = 1'b1;
			end
			// 5
			8'd5 : begin
				HexSeg[1] = 1'b1; HexSeg[4] = 1'b1;
			end
			// 6
			8'd6 :HexSeg[1] = 1'b1;
			// 7
			8'd7 : begin
				HexSeg[5] = 1'b1; HexSeg[4] = 1'b1; HexSeg[6] = 1'b1; HexSeg[3] = 1'b1;
			end
			// 8
			8'd8 : HexSeg = 7'd0;
			// 9
			8'd9 : HexSeg[4] = 1'b1;
			default: HexSeg = 7'b1111111;
		endcase
	end
endmodule

module num_msb(input [7:0] H, output [7:0] Hh, Hl);
assign Hh = H/8'd10;
assign Hl = H%8'd10;
endmodule

module alarm_clock_pv(input CLK, SW5, SW4, SW3, SW2, SW1, SW0, KEY1, KEY0, output logic [6:0] SEC_LSD, SEC_MSD, MIN_LSD, MIN_MSD, HR_LSD, HR_MSD, output logic LED7, LED5, LED4, LED3, LED2, LED1, LED0);
logic [7:0]  sec, min, hrs, sec_alarm, min_alarm, hrs_alarm;
logic [25:0] count;
logic alarm, CLK2Hz;

logic [7:0] hr_ms, hr_ls, min_ms, min_ls, sec_ms, sec_ls, hour_, min_, sec_;

assign LED0 = SW0;
assign LED1 = SW1;
assign LED2 = SW2;
assign LED3 = SW3;
assign LED4 = SW4;
assign LED5 = SW5;
assign LED7 = alarm;

freq_div #(26) f1 (CLK, SW0, 26'd12500000, count, CLK2Hz);
alarm_clock a1 (CLK2Hz, SW0, SW2 & ~KEY1, SW1 & ~KEY1, SW3, SW5, SW4, ~KEY0, sec, min, hrs, sec_alarm, min_alarm, hrs_alarm, alarm);

Dec27Seg D1 (hr_ms, HR_MSD); 
Dec27Seg D2 (hr_ls, HR_LSD); 

Dec27Seg D3 (min_ms, MIN_MSD); 
Dec27Seg D4 (min_ls, MIN_LSD); 

Dec27Seg D5 (sec_ms, SEC_MSD); 
Dec27Seg D6 (sec_ls, SEC_LSD); 

num_msb n1(hour_, hr_ms, hr_ls);
num_msb n2(min_, min_ms, min_ls);
num_msb n3(sec_, sec_ms, sec_ls);

always_comb begin
	if (SW1) begin
		hour_ = hrs_alarm;	
		min_ = min_alarm;
		sec_ = sec_alarm;
	end
	else begin
		hour_ = hrs;
		min_ = min;
		sec_ = sec;
	end
end
endmodule