/*******************************************************************************
* Copyright (c) 2021 Alan Tong Sing Teik.
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*******************************************************************************/

/** 3 process FSM template */

parameter STATE_BIT_COUNT = 4;
input	reg fsm_input;
output	reg out1;

parameter IDLE	= 1 << 0;
parameter S1	= 1 << 1;
parameter S2	= 1 << 2;

reg [STATE_BIT_COUNT - 1 : 0] state_next;
reg [STATE_BIT_COUNT - 1 : 0] state_current;

/** next state comb logic */
always @ (*)
begin
     case(state_current)
        IDLE:
		begin
            if(idle_to_s1_begin)
			begin
                state_next = S1;
            end
            else
			begin
                state_next = state_current;
            end
        end
  
        S1:
		begin
            if(s1_to_s2_begin)
			begin
                state_next = S2;
            end
            else
			begin
                state_next = state_current;
            end
        end
  
        S2:
		begin
            if(s2_to_idle_begin)
			begin
                state_next = IDLE;
            end
            else
			begin
                state_next = state_current;
            end
        end
  
        default:
		begin
            state_next = IDLE;
        end
  
     endcase
end

/** current state memory */
always @ (posedge clk or negedge nrst)
begin
     if(nrst == 0)
	 begin
        state_current <= IDLE;
     end
     else begin
        state_current <= state_next;
     end
end

/** output comb logic */  
assign idle_to_s1_begin	= state_current == IDLE		&& x_input;
assign s1_to_s2_begin	= state_current == S1		&& x_input;
assign s2_to_idle_begin	= state_current == S2		&& x_input;

/** output sequential logic */ 
always @ (posedge clk or negedge nrst)
begin
     if(nrst == 0)
	 begin
        out1 <= 1'b0   
     end
     else 
	 begin
		case (state_current)
			S1:			out1 <= 1'b1;
			S2:			out1 <= 1'b1;
			default:	out1 <= 1'b0;
		endcase
	end
end