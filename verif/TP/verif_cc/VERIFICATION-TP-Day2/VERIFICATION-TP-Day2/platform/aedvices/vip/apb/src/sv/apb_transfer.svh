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
// $Id: apb_transfer.svh 1540 2018-05-15 09:46:09Z adrien $
// $Author: adrien $
// $LastChangedDate: 2018-05-15 11:46:09 +0200 (mar., 15 mai 2018) $
// $Revision: 1540 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_transfer definition
 */



/// \addtogroup packages
/// @{
/// \addtogroup aed_apb_pkg
/// @{
/// \addtogroup Classes
/// @{

/// Main APB transfer sequence item
class apb_transfer extends uvm_sequence_item;

  //----------------------
  /// Fields declaration
  rand int unsigned       delay;       ///< intertransfer delay prior to send the current transfer
  rand apb_address_t      address;     ///< address of the transfer
  rand apb_data_t         data;        ///< data transmitted
  rand apb_direction_t    direction;   ///< READ or WRITE. Random by default.
  rand bit                slverror;    ///< Transfer Error
  rand int unsigned       waitstates;  ///< Cycle where Slave extend the transfer
  rand shortint unsigned  sel;         ///< Select the APB line to be used. Constrained by cfg.psel_width.\b additionally constrained by address map.

  // AMBA 4 APB v2.0 fields - IHI0024C
  rand apb_prot_t         prot;        ///< Protection Mode
  rand bit[3:0]           strobe;      ///< Write Strobe
  rand bit                full_access; ///< Force Write Strobe to be 'b1111

  `pragma protect begin
  protected apb_config cfg; ///< pointer to the agent configuration for configuration based constraints
  `pragma protect end

  /// Default Global Constraints
  `aed_apb_transfer_default_soft_constraints

  `pragma protect begin

  `uvm_object_utils_begin(apb_transfer)
    `uvm_field_enum(apb_direction_t, direction   ,  UVM_ALL_ON)
    `uvm_field_int(                  address     ,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(                  waitstates  ,  UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE)
    `uvm_field_int(                  data        ,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(                  slverror    ,  UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(                  delay       ,  UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE)
    `uvm_field_int(                  sel         ,  UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(                  strobe      ,  UVM_ALL_ON + UVM_DEC)
  `uvm_object_utils_end

  // Protected Methods

  /// Methods
  extern function new(string name="");
  extern virtual function void set_cfg(apb_config cfg=null);
  extern function void pre_randomize();

  `pragma protect end

endclass



/// @}
/// @}
/// @}
