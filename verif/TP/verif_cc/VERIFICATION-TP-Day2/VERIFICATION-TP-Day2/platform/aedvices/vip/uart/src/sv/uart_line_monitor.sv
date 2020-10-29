/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_line_monitor.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 class uart_line_monitor implementation
 */

`pragma protect begin
/// constructor
function uart_line_monitor::new(string name="uart_line_monitor",uvm_component parent=null);
  super.new(name,parent);
  clock_r_sem = new(1);

  completed_byte        = new("Completed Byte Detection"       ,this);
//  completed_link_character_port   = new("Completed Link-Character Detection"  ,this);
  monitored_string = "";
endfunction


/// UVM Connect Phase
function void uart_line_monitor::connect_phase(uvm_phase phase);
  virtual uart_if uart_vif = p_agent.get_vif();
  if ( uart_vif == null )
    `uvm_fatal("F_NOVIF","Virtual interface not defined prior to connect_phase()");

  if ( kind == TXM )
    line_vif = uart_vif.tx;
  else
    line_vif = uart_vif.rx;

endfunction


/// UVM Reset Phase
task uart_line_monitor::reset_phase(uvm_phase phase);
//  line_value = 'bx;
//  prev_char = null;
  monitored_string = "";
endtask

/// SpaceWire run_phase
task uart_line_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_name(),"Monitor Starting...",UVM_MEDIUM)
  fork
    monitor_uart_line();
    /// \todo handle reset state from upper monitor
    /// \todo prev_char = null whenever the link goes in ErrorReset
  join_any
  disable fork;
endtask

//------------------------------------------------------------------
/// SPI Bus Monitoring
task uart_line_monitor::monitor_uart_line();
  bit reset_detected =0;
  bit item_ongoing   =0;

  line_vif.retreived_clock <= 0;

  forever begin
    reset_detected = 0;
    item_ongoing   =0;

    fork

      //---------
      // Thread 1 : wait for reset events
//      begin
//        @ ( reset_event );
//       `uvm_info(get_name(),"monitor_spi_bus() : reset dropped, stopping monitoring",UVM_FULL)
//        reset_detected = 1;
//      end

      //---------
      // Thread 2 : Run as normal if everything is normal
      begin

//	if ( ! reset_done )
//	  wait(reset_done);

        `uvm_info(get_name(),"Ready to Monitor new UART transfer",UVM_FULL)
//        monitor_is_active = 1;// Notify activity

        detect_frame();
      end
    join_any

    // if reset has been detected, we need to kill any sub threads that may be sending data
    if ( reset_detected )
      begin
        disable fork;
        `uvm_info("DEBUG","monitor_uart_line() : disable fork, monitoring stopped",UVM_FULL)
//        monitor_is_active = 0;// Notify absence of activity
      end

  end // forever
endtask


/// \brief Detect Uart Frame Line Value
/// \details Snoop the line and generate a retreived clock for bit sampling
task uart_line_monitor::detect_frame();
  string recorded_trans_name;
  uart_frame frame = new(recorded_trans_name);///< UART transaction
  if ( this.kind == TXM )
    recorded_trans_name = "tx_byte";
  else
    recorded_trans_name = "rx_byte";

  @(negedge line_vif.sig);
  void'(begin_tr(frame, recorded_trans_name, "UVM Debug","UART Received byte"));
  ->start_bit_detected_ev;
  start_retreived_clock();

  @(negedge line_vif.retreived_clock); //End of start bit sampling
    ASSERT_UART_ERROR_START:
          assert ( line_vif.sig == 0 )
          else begin
            if (line_vif.has_start_checks == 1)
               `uvm_error("ASSERT_UART_ERROR_START", "The Start bit duration is not correct")
             frame.start_bit_error = 1;
          end

  for (int ii=0;ii<p_agent.cfg.size;ii++) begin
    @(negedge line_vif.retreived_clock); //sampling stable value
    `uvm_info("UART_MONITOR", $sformatf("Sampling bits :%d", line_vif.sig), UVM_FULL)
    frame.data[ii] = line_vif.sig;
  end

  if (p_agent.cfg.parity != NONE) begin
    @(negedge line_vif.retreived_clock); //sampling stable value
    `uvm_info("UART_MONITOR", $sformatf("Parity bits :%d", line_vif.sig), UVM_FULL)  //print UART transaction
    frame.parity_bit = line_vif.sig;
    // Check Parity bit
    ASSERT_UART_ERROR_PARITY:
          assert ( frame.parity_bit == compute_parity(p_agent.cfg.parity, frame.data, p_agent.cfg.size) )
          else begin
            if (line_vif.has_parity_checks == 1)
               `uvm_error("ASSERT_UART_ERROR_PARITY","The Parity bit is not correct")
             frame.parity_bit_error = 1;
          end
  end

  for (int jj=0;jj<p_agent.cfg.stop_format;jj++) begin
    @(negedge line_vif.retreived_clock); //sampling in the middle of bit
    // Check Stop bit
    ASSERT_UART_ERROR_STOP:
          assert ( line_vif.sig == 1 )
          else begin
            if (line_vif.has_stop_checks == 1)
               `uvm_error("ASSERT_UART_ERROR_STOP", $sformatf("The Stop bit n %d is not correct", jj+1))
             frame.stop_bit_error = 1;
          end
  end

  stop_retreived_clock();

  clock_r_sem.get(1); //Wait for the end of transaction, last half period

  // Export Received Characters for external monitoring
  end_tr(frame);

  `uvm_info("UART_MONITOR", $sformatf("Frame transmission :\n%s", frame.sprint()), UVM_MEDIUM)  //print UART transaction

  // Print Char
  if (p_agent.cfg.print_tx_char && this.kind == TXM)
    `uvm_info(get_name(),$psprintf("Transmitted Char: '%s'",frame.data),UVM_NONE)
  else if (p_agent.cfg.print_rx_char && this.kind == RXM)
    `uvm_info(get_name(),$psprintf("Received Char: '%s'",frame.data),UVM_NONE)

  // Print String
  if ( (p_agent.cfg.print_tx_string) && (this.kind == TXM) && (frame.data == "\n"))
    `uvm_info(get_name(),$psprintf("Transmitted String: \"%s\"",monitored_string),UVM_NONE)
  else if ( (p_agent.cfg.print_rx_string) && (this.kind == RXM) && (frame.data == "\n"))
    `uvm_info(get_name(),$psprintf("Received String: \"%s\"",monitored_string),UVM_NONE)

  if ( frame.data == "\n" )
    monitored_string = "";
  else
    monitored_string = { monitored_string , byte'(frame.data) };

  // Send Frame to analysis port
  completed_byte.write(frame);

  clock_r_sem.put(1); //release semaphore

endtask



function bit uart_line_monitor::compute_parity(uart_parity_t parity, bit[`UART_DATA_MAX_WIDTH-1:0] data, int size);
  bit result = 0;
  for (int ii=0;ii<size;ii++)
    result += data[ii];
  return (!(parity == result));

endfunction


//-----------------------------------------------------------------------------
/// \brief Start Uart Tx Clock
/// \details get a semaphore first so that no conflicts are possible.
task uart_line_monitor::start_retreived_clock();
  `uvm_info("DEBUG","Requesting Retreived Clock",UVM_FULL)
  clock_r_sem.get(1);
  `uvm_info("DEBUG","Got Clock Semaphore",UVM_FULL)
  fork
    gen_retreived_clock();
  join_none
endtask

//-----------------------------------------------------------------------------
/// \brief Stop the spacewire Tx clock, normally called at the end of a transmission.
task uart_line_monitor::stop_retreived_clock();
  `uvm_info("DEBUG","Stoping Clock",UVM_FULL)
  retreived_clock_running <= 0;
endtask

//-----------------------------------------------------------------------------
/// \brief Clock generation
task uart_line_monitor::gen_retreived_clock();
  real clock_half_period;
  time clock_half_period_tt;
  time prev_time, curr_time;

  /// \todo: get it from the config
  clock_half_period = ((1_000_000_000_000.0/100) / 2) / p_agent.cfg.baud_rate;
  clock_half_period_tt = (clock_half_period*100ps);

  assert ( clock_half_period_tt != 0 ) else `uvm_fatal("F_SPW_CLOCK_GEN",
          $psprintf(
            "Unable to get clock period time. Check that Timescale <= 100ps (baud_rate = %-d ; period = %-f)",
            p_agent.cfg.baud_rate,
            clock_half_period
            ));

  `uvm_info("DEBUG",$psprintf("Clock Process started (half period = %t)",clock_half_period_tt),UVM_FULL)
  retreived_clock_running = 1;
  line_vif.retreived_clock <= 0;

  prev_time = $time;

  while ( retreived_clock_running ) begin
    line_vif.retreived_clock <= ~line_vif.retreived_clock;
    #clock_half_period_tt;

//    curr_time = $time;
//    assert ( curr_time > prev_time ) else `uvm_fatal("F_SPW_CLOCK_GEN",$psprintf("Unable to generate clock with half_period = %f ps. Check timescale.",clock_half_period))
//    prev_time = $time;
  end
  `uvm_info("DEBUG","Clock Stopped",UVM_FULL)
  clock_r_sem.put(1);

endtask


`pragma protect end
