/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// Copyright (c) 2016 - AEDVICES Consulting
// 39 Montee du Chatenay - 38690 Oyeu - France
// www.aedvices.com/vip
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Usage of this code is subject to license agreement.
// For any querry contact AEDVICES Consulting: contact@aedvices.com
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: apb_if.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 APB generic interface
 */

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "apb_defines.svh"


/// \brief APB Interface Signals
/** \details
 * Provide a generic interface for the APB Verification IP.\n
 * PCLK and PRESETn needs to be provided by the DUT or the testbench.
 */
interface apb_if #(PSEL_WIDTH=`MAX_PSEL_WIDTH,MAX_ADDR_WIDTH=`MAX_ADDR_WIDTH) (
  input PCLK,
  input PRESETn
  );

  //------------------------------------
  /// <HR>
  /// ## Control flags: ##
  //------------------------------------
  bit                has_checks      = 1;  /// <b>bit has_checks      </b>\n when 1, protocol checkers are enabled. Overridden by agent config during build phase.
  bit                slave_shared_bus = 0; /// <b>is_slave_shared_bus</b>\n For slaves only. Indicates if PADDR, PENABLE, PWRITE, PWDATA signals are shared with another agent. \n This disable a few checkers at the interface level. \n default=0.
  shortint unsigned  psel_width = `MAX_PSEL_WIDTH;

  // fine grained assertion activation
  bit assert_synchronous_reset       = has_checks;  /// <b>bit assert_synchronous_reset       </b>\n check that reset is deasserted synchronously to PCLK
  bit assert_idle_when_reset_enable  = has_checks;  /// <b>bit assert_idle_when_reset_enable  </b>\n check that PENABLE and PSEL are set to 0 during reset
  bit assert_idle_after_reset_enable = has_checks;  /// <b>bit assert_idle_after_reset_enable </b>\n check that PENABLE and PSEL are set to 0 after reset
  bit assert_setup_duration          = has_checks;  /// <b>bit assert_setup_duration          </b>\n check that SETUP phase lasts for 1 cycle only
  bit assert_access_stable_pwdata    = has_checks;  /// <b>bit assert_access_stable_pwdata    </b>\n check that PWDATA is stable during ACCESS phases
  bit assert_access_stable_values    = has_checks;  /// <b>bit assert_access_stable_values    </b>\n check that PSEL, PADDR, PWRITE, PWDATA are stable during ACCESS phases
  bit assert_state_transitions       = has_checks;  /// <b>bit assert_state_transitions       </b>\n check bus phase transitions according to IHI0024B/C 3.1 state diagram
  bit assert_write_strobe            = has_checks;  /// <b>bit assert_write_strobe            </b>\n check stobe is not set during reads.

  string agent_name; ///< Agent Name

  `pragma protect begin
  static int    curr_nr = 0;         // number of instances of this interface
  int           id      = curr_nr++; // interface ID for debug
  bit [`MAX_PSEL_WIDTH-1:0] psel_mask;
  initial
    agent_name      = $psprintf("APB_INTERFACE_%-0d",id);

  initial
  begin
    // PSEL WIDTH should be set during UVM build phase, therefore we should get it just after time 0
    #1;
    assert(psel_width > 0) else `uvm_fatal(agent_name,"psel_width should be set to a positive non-null integer value");
    psel_mask = ~ ( -1 << psel_width );
  end

  `pragma protect end

  //------------------------------------
  /// <HR>
  /// # Interface Signals: #
  //------------------------------------
  // AMBA 3 APB v1.0 signals - IHI0024B
  // MASTER
  logic [MAX_ADDR_WIDTH-1:0] PADDR;               /// <b>logic [MAX_ADDR_WIDTH-1:0] PADDR;   </b>\n  APB Address.\n driven by Master
  logic [PSEL_WIDTH-1:0]     PSEL;                /// <b>logic [PSEL_WIDTH-1:0]     PSEL;    </b>\n  APB PSEL, vector size [PSEL_WIDTH-1:0]\n driven by Master
  logic                      PENABLE;             /// <b>logic                      PENABLE; </b>\n  APB ENABLE  \n driven by Master
  logic                      PWRITE;              /// <b>logic                      PWRITE;  </b>\n  APB WRITE / not READ\n driven by Master
  logic [31:0]               PWDATA;              /// <b>logic           [31:0]     PWDATA;  </b>\n  APB WRITE DATA\n driven by Master
  // SLAVE
  logic                      PREADY;              /// <b>logic                      PREADY;  </b>\n  APB READY\n driven by Slave
  logic [31:0]               PRDATA;              /// <b>logic           [31:0]     PRDATA;  </b>\n  APB READ DATA\n driven by Slave
  logic                      PSLVERR;             /// <b>logic                      PSLVERR; </b>\n  APB Slave Error\n driven by Slave
  // AMBA 3 APB v2.0 signals - IHI0024C
  logic [3:0]                PSTRB;              /// <b>logic [3:0]                PSTRB;   </b>\n   APB Write Strobes.\n driven by Master
  logic [2:0]                PPROT;              /// <b>logic [3:0]                PSTRB;   </b>\n   APB Protection type.\n driven by Master


  //------------------------------------
  // ASSERTIONS
  //------------------------------------
  `pragma protect begin
  wire [`MAX_PSEL_WIDTH-1:0] actual_psel = PSEL &  psel_mask;
  // [Note]
  // There is no strict requirements from APB specification about this condition.
  // However, most AMBA protocol assumes that the reset signal can be asserted asynchronously and that deassertion must be synchronous with a rising edge of CLK.
  // This assertion ensures that deassertion is performed synchronously, but may be waived/disabled depending on architecture consideration.
  // See [AXI_SPEC]-A3.1.2 - Reset
  // The AXI protocol uses a single active LOW reset signal, ARESETn. The reset signal can be asserted asynchronously, but deassertion must be synchronous with a rising edge of ACLK.
  event clock_rise;
  always @(posedge PCLK) -> clock_rise;
  always @(posedge PRESETn)
    AED_VIP_APB_ASSERT_SYNCHRONOUS_RESET:
    if ( assert_synchronous_reset && has_checks && ! clock_rise.triggered )
    `uvm_error("AED_VIP_APB_ASSERT_SYNCHRONOUS_RESET",{ $psprintf("apb_if %s : PRESETn must be deasserted on rising edge of PCLK\n" ,agent_name) ,
                                                        "Note: this is not a strict requirements from APB, but is for other AMBA protocols.\n",
                                                        "Disable 'using assert_synchronous_reset conf' configuration field if required" })

  // [IHI0024B/C]-3.1 IDLE: This is the default state of the APB.
  // Note: Although not formally stated, it is assumed that APB is IDLE when PRESETn is asserted
  AED_VIP_APB_ASSERT_IDLE_WHEN_RESET:
    assert property ( @(posedge PCLK)
        disable iff(!assert_idle_when_reset_enable || !has_checks)
        PRESETn == 0 |-> actual_psel == 0 && PENABLE == 0)
        else
        `uvm_error("AED_VIP_APB_ASSERT_IDLE_WHEN_RESET",{ $psprintf("apb_if %s : Interface not set to IDLE while PRESETn is active. \n",agent_name) ,
                                                          "See [IHI0024B/C]-3.1 IDLE: This is the default state of the APB.\n" ,
                                                          $psprintf("Actual values: PSEL=%d , PENABLE=%d",actual_psel, PENABLE) } )

  // [IHI0024B/C]-3.1 IDLE: This is the default state of the APB.
  AED_VIP_APB_ASSERT_IDLE_AFTER_RESET:
    assert property ( @(posedge PCLK)
        disable iff(!assert_idle_after_reset_enable || !has_checks)
        PRESETn == 0 |=> actual_psel == 0 && PENABLE == 0)
    else
      `uvm_error("AED_VIP_APB_ASSERT_IDLE_AFTER_RESET",{ $psprintf("apb_if %s : Interface not set to IDLE after PRESETn active. \n",agent_name) ,
                                                         "See [IHI0024B/C]-3.1 IDLE: This is the default state of the APB.\n" ,
                                                         $psprintf("Actual values: PSEL=%d , PENABLE=%d",actual_psel, PENABLE) } )

  // [IHI0024B/C]-3.1 SETUP The bus only remains in the SETUP state for one clock cycle
  AED_VIP_APB_ASSERT_SETUP_DURATION:
    assert property ( @(posedge PCLK)
        disable iff(!assert_setup_duration || !has_checks || PRESETn == 0)
        (actual_psel != 0) && (PENABLE == 0) |=> $stable(PSEL) && PENABLE == 1)
    else
      `uvm_error("AED_VIP_APB_ASSERT_SETUP_DURATION", { $psprintf("apb_if %s : A SETUP phase is detected and not followed by the ACCESS phase\n",agent_name) ,
                                                        "See [IHI0024B/C]-3.1 SETUP [...] The bus only remains in the SETUP state for one clock cycle\n",
                                                         $psprintf("Actual   values: PSEL=%d , PENABLE=%d",actual_psel, PENABLE) } )

  // [IHI0024B/C]-3.1 ACCESS The address, write, select, and write data signals must remain stable during the transition from the SETUP to ACCESS state.
  AED_VIP_APB_ASSERT_ACCESS_STABLE_VALUES:
  assert property ( @(posedge PCLK)
    disable iff(!assert_access_stable_values || !has_checks || PRESETn ==0)
    access_s or access_wait_s |-> $stable(PADDR) && $stable(PWRITE) && $stable(PSEL) && (PWRITE == 0 || $stable(PWDATA)))
  else
    `uvm_error("AED_VIP_APB_ASSERT_ACCESS_STABLE_VALUES", { $psprintf("apb_if %s : Signal (PADDR,PWRITE,PSEL,PWDATA) values changed during ACCESS phase\n",agent_name) ,
      "See [IHI0024B/C]-3.1 ACCESS The address, write, select, and write data signals must remain stable during the transition from the SETUP to ACCESS state." })

  AED_VIP_APB_ASSERT_ACCESS_STABLE_PWDATA:
    assert property ( @(posedge PCLK)
      disable iff(!assert_access_stable_pwdata || !has_checks || PRESETn ==0)
      access_s or access_wait_s |-> $stable(PWDATA))
    else
    `uvm_error("AED_VIP_APB_ASSERT_ACCESS_STABLE_PWDATA", { $psprintf("apb_if %s : Signal PWRITE values changed during ACCESS phase\n",agent_name) ,
        "See [IHI0024B/C]-3.1 ACCESS The address, write, select, and write data signals must remain stable during the transition from the SETUP to ACCESS state." })

  // [IHI0024B/C] - 2.1 Write strobes must not be active during a read transfer.
  AED_VIP_APB_ASSERT_WRITE_STROBE:
    assert property ( @ (posedge PCLK)
        disable iff(!assert_write_strobe || !has_checks || PRESETn ==0)
        PENABLE == 1 && PWRITE == 0 |-> PSTRB == 0)
    else
      `uvm_error("AED_VIP_APB_ASSERT_WRITE_STROBE", { $psprintf("apb_if %s : Signal PSTRB must not be active during a read transfer\n",agent_name),
         "See [IHI0024C] - 2.1 "})




  // APB State Diagram
  sequence reset_s;       PRESETn == 0; endsequence
  sequence idle_s;        PRESETn == 1 && actual_psel == 0 && (PENABLE == 0 || slave_shared_bus); endsequence
  sequence setup_s;       PRESETn == 1 && $onehot(PSEL) && PENABLE == 0; endsequence
  sequence access_wait_s; PRESETn == 1 && $onehot(PSEL) && $stable(PSEL) && PENABLE == 1 && PREADY == 0; endsequence
  sequence access_s;      PRESETn == 1 && $onehot(PSEL) && $stable(PSEL) && PENABLE == 1 && PREADY == 1; endsequence

  AED_VIP_APB_RESET_TO_IDLE:
  assert property( @(posedge PCLK)
    disable iff(!has_checks || !assert_state_transitions)
    reset_s |=> reset_s or idle_s)
  else
    `uvm_error("AED_VIP_APB_RESET_TO_IDLE", { $psprintf("apb_if %s : Wrong transition from RESET state\n", agent_name),
                                               $psprintf("Actual values: PSEL=%d , PENABLE=%d",actual_psel, PENABLE) } )

  AED_VIP_APB_IDLE_TO_SETUP:
  assert property( @(posedge PCLK)
    disable iff(!has_checks || !assert_state_transitions)
    idle_s |=> idle_s or setup_s or reset_s)
  else
  `uvm_error("AED_VIP_APB_IDLE_TO_SETUP", { $psprintf("apb_if %s : Wrong transition from IDLE state\n", agent_name),
      $psprintf("Actual values: PSEL=%d , PENABLE=%d",actual_psel, PENABLE) } )


  AED_VIP_APB_SETUP_TO_ACCESS:
  assert property( @(posedge PCLK)
    disable iff(!has_checks || !assert_state_transitions)
    setup_s |=> access_wait_s or access_s or reset_s)
  else
  `uvm_error("AED_VIP_APB_SETUP_TO_ACCESS", { $psprintf("apb_if %s : Wrong transition from SETUP state\n", agent_name),
      $psprintf("Actual values: PSEL=%d , PENABLE=%d",actual_psel, PENABLE) } )

  AED_VIP_APB_ACCESS_WAIT_TO_ACCESS:
  assert property( @(posedge PCLK)
    disable iff(!has_checks || !assert_state_transitions)
    access_wait_s |=> access_wait_s or access_s or reset_s)
  else
  `uvm_error("AED_VIP_APB_ACCESS_WAIT_TO_ACCESS", { $psprintf("apb_if %s : Wrong transition from ACESS state with PREADY == 0\n", agent_name),
      $psprintf("Actual values: PSEL=%d , PENABLE=%d",actual_psel, PENABLE) } )

  AED_VIP_APB_ACCESS_TO_IDLE_OR_SETUP:
  assert property( @(posedge PCLK)
    disable iff(!has_checks || !assert_state_transitions)
    access_s |=> idle_s or setup_s or reset_s)
  else
  `uvm_error("AED_VIP_APB_ACCESS_TO_IDLE_OR_SETUP", { $psprintf("apb_if %s : Wrong transition from ACESS state\n", agent_name),
      $psprintf("Actual values: PSEL=%d , PENABLE=%d",actual_psel, PENABLE) } )

  `pragma protect end
endinterface // apb_if

