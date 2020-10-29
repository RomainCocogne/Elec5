/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_driver.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/// \file
/// Generic UART VIP

`pragma protect begin
/// constructor
function uart_driver::new(string name="driver",uvm_component parent=null);
  super.new(name,parent);
  if ( ! $cast(p_agent,parent))
    `uvm_fatal(get_name(),"Unable to cast parent to p_agent. The parent of uart_driver should be a uart_agent.")
  clock_sem = new(1);

endfunction


//--------------------------------------------------------------------
/// UVM Run Phase
/// Main Driver Run Loop
task uart_driver::run_phase(uvm_phase phase);
  `uvm_info("DEBUG",$psprintf("phase %s launched",phase.get_name()),UVM_HIGH)
  fork
    get_and_drive();
  join_any
endtask // run_phase


//-----------------------------------------------------------------------------
/// Get Sequence Item from the sequencer and drive it.
task uart_driver::get_and_drive();

  vif.internal_clock <= 0;
  vif.sig            <= 1; /// \todo default line value configuration

  forever begin
    `uvm_info("DEBUG",$psprintf("Getting Uart Frame Items"),UVM_FULL)
    seq_item_port.get_next_item(req);
    drive_frame(req);
    seq_item_port.item_done();

  end // forever
endtask

//-----------------------------------------------------------------------------
/// Drive a single frame
task uart_driver::drive_frame(uart_frame frame);
  real clock_half_period;
  time clock_half_period_tt;
  time prev_time, curr_time;

  /// \todo: get it from the config
  clock_half_period = ((1000000000/100) / 2) / p_agent.cfg.min_baud_rate;
  clock_half_period_tt = (clock_half_period*100ps);

  start_internal_clock(/*uart.freq*/);

  // Delay if exists
  repeat (frame.delay)
    @(posedge vif.internal_clock);

  // Frame Part (Start + Payload + Parity + Stop)
  if (!frame.start_bit_error) begin
    drive_bit(0); //Start Bit
  end else begin
    @(posedge vif.internal_clock);
    vif.sig      <= 0;
    randcase
      50 : #(clock_half_period*90ps); // To verify with clock freq tolerance
      50 : #(clock_half_period*95ps);
   endcase
    vif.sig      <= 1;
  end

  for (int ii=0;ii<p_agent.cfg.size;ii++) //Payload
    drive_bit(frame.data[ii]);

  if (p_agent.cfg.parity != NONE) begin //Parity bit if exists
    drive_bit(compute_parity(p_agent.cfg.parity, frame.data, p_agent.cfg.size, frame.parity_bit_error)); // Parity bit is computed if exists
    frame.parity_bit = compute_parity(p_agent.cfg.parity, frame.data, p_agent.cfg.size, frame.parity_bit_error);
  end

  if (!frame.stop_bit_error) begin
    for (int jj=0;jj<p_agent.cfg.stop_format;jj++) //Stop Bit
      drive_bit(1);
  end else begin
    repeat (p_agent.cfg.stop_format) begin
      randcase
        (100/p_agent.cfg.stop_format) : drive_bit(0); //for 1 stop bit (100), 2 stop bits (50)
        50 : drive_bit(1);
      endcase
    end
  end

  @(negedge vif.internal_clock); // to realign clock, ready for next trans
  stop_internal_clock();

  clock_sem.get(1); //Wait for the end of transaction, last half period
  `uvm_info("UART_DRIVER", $sformatf("Transfer sent :\n%s", frame.sprint()), UVM_MEDIUM)  //print UART transaction
  clock_sem.put(1); //release semaphore

endtask

//-----------------------------------------------------------------------------
/// Drive 1 bit value over the Spacewire
task uart_driver::drive_bit(bit val);
  @(posedge vif.internal_clock);

  vif.sig      <= val;

endtask



//-----------------------------------------------------------------------------
/// \brief Start Uart Tx Clock
/// \details get a semaphore first so that no conflicts are possible.
task uart_driver::start_internal_clock();
  `uvm_info("DEBUG","Requesting Internal Clock",UVM_FULL)
  clock_sem.get(1);
  `uvm_info("DEBUG","Got Clock Semaphore",UVM_FULL)
  fork
    gen_internal_clock();
  join_none
endtask


//-----------------------------------------------------------------------------
/// \brief Stop the spacewire Tx clock, normally called at the end of a transmission.
task uart_driver::stop_internal_clock();
  `uvm_info("DEBUG","Stoping Clock",UVM_FULL)
  internal_clock_running <= 0;
endtask

//-----------------------------------------------------------------------------
/// \brief Clock generation
task uart_driver::gen_internal_clock();
  real clock_half_period;
  time clock_half_period_tt;
  time prev_time, curr_time;

  /// \todo: get it from the config
  clock_half_period = ((1_000_000_000_000.0/100) / 2) / p_agent.cfg.min_baud_rate;
  clock_half_period_tt = (clock_half_period*100ps);

  assert ( clock_half_period_tt != 0 ) else `uvm_fatal("F_UART_CLOCK_GEN","Unable to get clock period time. Check that Timescale > 100ps");

  `uvm_info("DEBUG",$psprintf("Clock Process started (half period = %t)",clock_half_period_tt),UVM_FULL)
  internal_clock_running = 1;
  vif.internal_clock <= 0;

  prev_time = $time;

  while ( internal_clock_running ) begin
    vif.internal_clock <= ~vif.internal_clock;
    #clock_half_period_tt;
  end
  `uvm_info("DEBUG","Clock Stopped",UVM_FULL)
  clock_sem.put(1);

endtask

//-----------------------------------------------------------------------------
/// from a given word, compute the parity bit value
function bit uart_driver::compute_parity(uart_parity_t parity, bit[`UART_DATA_MAX_WIDTH-1:0] data, int size, bit error);
  bit result = 0;
  for (int ii=0;ii<size;ii++)
    result += data[ii];
  if (error == 0)
    return (!(parity == result)); //Correct Parity
  else
    return ((parity == result));  //Error rinjection on Parity Bit

endfunction

`pragma protect end