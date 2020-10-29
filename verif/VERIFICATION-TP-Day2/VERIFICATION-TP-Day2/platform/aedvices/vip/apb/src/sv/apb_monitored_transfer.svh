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
// $Id: apb_monitored_transfer.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_monitored_transfer definition
 */

/// \addtogroup packages
/// @{
/// \addtogroup aed_apb_pkg
/// @{
/// \addtogroup Classes
/// @{


/// The monitored transfer inherits from the transfer and is used in monitors to keep a clear separation between what is generated/driven from what is monitored.
class apb_monitored_transfer extends apb_transfer;

  `pragma protect begin
  local bit has_coverage = 1;
  `pragma protect end

  // Default APB Coverage Group
  covergroup apb_cg;

    coverpoint direction;
    coverpoint slverror;
    coverpoint waitstates {
      bins waitstates[]  = { [0:10] };
      bins others = default;
    }

    /// \todo get better implementation without degrading simulation performance
    address0  : coverpoint address[0 ];
    address1  : coverpoint address[1 ];
    address2  : coverpoint address[2 ];
    address3  : coverpoint address[3 ];
    address4  : coverpoint address[4 ];
    address5  : coverpoint address[5 ];
    address6  : coverpoint address[6 ];
    address7  : coverpoint address[7 ];
    address8  : coverpoint address[8 ];
    address9  : coverpoint address[9 ];
    address10 : coverpoint address[10];
    address11 : coverpoint address[11];
    address12 : coverpoint address[12];
    address13 : coverpoint address[13];
    address14 : coverpoint address[14];
    address15 : coverpoint address[15];
    address16 : coverpoint address[16];
    address17 : coverpoint address[17];
    address18 : coverpoint address[18];
    address19 : coverpoint address[19];
    address20 : coverpoint address[20];
    address21 : coverpoint address[21];
    address22 : coverpoint address[22];
    address23 : coverpoint address[23];
    address24 : coverpoint address[24];
    address25 : coverpoint address[25];
    address26 : coverpoint address[26];
    address27 : coverpoint address[27];
    address28 : coverpoint address[28];
    address29 : coverpoint address[29];
    address30 : coverpoint address[30];
    address31 : coverpoint address[31];

    wdata0  : coverpoint data[0 ] iff (direction == WRITE);
    wdata1  : coverpoint data[1 ] iff (direction == WRITE);
    wdata2  : coverpoint data[2 ] iff (direction == WRITE);
    wdata3  : coverpoint data[3 ] iff (direction == WRITE);
    wdata4  : coverpoint data[4 ] iff (direction == WRITE);
    wdata5  : coverpoint data[5 ] iff (direction == WRITE);
    wdata6  : coverpoint data[6 ] iff (direction == WRITE);
    wdata7  : coverpoint data[7 ] iff (direction == WRITE);
    wdata8  : coverpoint data[8 ] iff (direction == WRITE);
    wdata9  : coverpoint data[9 ] iff (direction == WRITE);
    wdata10 : coverpoint data[10] iff (direction == WRITE);
    wdata11 : coverpoint data[11] iff (direction == WRITE);
    wdata12 : coverpoint data[12] iff (direction == WRITE);
    wdata13 : coverpoint data[13] iff (direction == WRITE);
    wdata14 : coverpoint data[14] iff (direction == WRITE);
    wdata15 : coverpoint data[15] iff (direction == WRITE);
    wdata16 : coverpoint data[16] iff (direction == WRITE);
    wdata17 : coverpoint data[17] iff (direction == WRITE);
    wdata18 : coverpoint data[18] iff (direction == WRITE);
    wdata19 : coverpoint data[19] iff (direction == WRITE);
    wdata20 : coverpoint data[20] iff (direction == WRITE);
    wdata21 : coverpoint data[21] iff (direction == WRITE);
    wdata22 : coverpoint data[22] iff (direction == WRITE);
    wdata23 : coverpoint data[23] iff (direction == WRITE);
    wdata24 : coverpoint data[24] iff (direction == WRITE);
    wdata25 : coverpoint data[25] iff (direction == WRITE);
    wdata26 : coverpoint data[26] iff (direction == WRITE);
    wdata27 : coverpoint data[27] iff (direction == WRITE);
    wdata28 : coverpoint data[28] iff (direction == WRITE);
    wdata29 : coverpoint data[29] iff (direction == WRITE);
    wdata30 : coverpoint data[30] iff (direction == WRITE);
    wdata31 : coverpoint data[31] iff (direction == WRITE);

    rdata0  : coverpoint data[0 ] iff (direction == READ);
    rdata1  : coverpoint data[1 ] iff (direction == READ);
    rdata2  : coverpoint data[2 ] iff (direction == READ);
    rdata3  : coverpoint data[3 ] iff (direction == READ);
    rdata4  : coverpoint data[4 ] iff (direction == READ);
    rdata5  : coverpoint data[5 ] iff (direction == READ);
    rdata6  : coverpoint data[6 ] iff (direction == READ);
    rdata7  : coverpoint data[7 ] iff (direction == READ);
    rdata8  : coverpoint data[8 ] iff (direction == READ);
    rdata9  : coverpoint data[9 ] iff (direction == READ);
    rdata10 : coverpoint data[10] iff (direction == READ);
    rdata11 : coverpoint data[11] iff (direction == READ);
    rdata12 : coverpoint data[12] iff (direction == READ);
    rdata13 : coverpoint data[13] iff (direction == READ);
    rdata14 : coverpoint data[14] iff (direction == READ);
    rdata15 : coverpoint data[15] iff (direction == READ);
    rdata16 : coverpoint data[16] iff (direction == READ);
    rdata17 : coverpoint data[17] iff (direction == READ);
    rdata18 : coverpoint data[18] iff (direction == READ);
    rdata19 : coverpoint data[19] iff (direction == READ);
    rdata20 : coverpoint data[20] iff (direction == READ);
    rdata21 : coverpoint data[21] iff (direction == READ);
    rdata22 : coverpoint data[22] iff (direction == READ);
    rdata23 : coverpoint data[23] iff (direction == READ);
    rdata24 : coverpoint data[24] iff (direction == READ);
    rdata25 : coverpoint data[25] iff (direction == READ);
    rdata26 : coverpoint data[26] iff (direction == READ);
    rdata27 : coverpoint data[27] iff (direction == READ);
    rdata28 : coverpoint data[28] iff (direction == READ);
    rdata29 : coverpoint data[29] iff (direction == READ);
    rdata30 : coverpoint data[30] iff (direction == READ);
    rdata31 : coverpoint data[31] iff (direction == READ);

    cross_dir_slverror   : cross direction,slverror;
    cross_dir_waitstates : cross direction,waitstates;
  endgroup


  `pragma protect begin

  /// constructor
  function new(string name="",bit has_coverage=1);
    super.new(name);
    this.has_coverage = has_coverage;
    if ( has_coverage )
      apb_cg = new();
  endfunction


  // Sample all coverages
  function void sample();
    if ( this.has_coverage )
      apb_cg.sample();
  endfunction



  `uvm_object_utils_begin(apb_monitored_transfer)
  `uvm_object_utils_end

  `pragma protect end

endclass



/// @}
/// @}
/// @}
