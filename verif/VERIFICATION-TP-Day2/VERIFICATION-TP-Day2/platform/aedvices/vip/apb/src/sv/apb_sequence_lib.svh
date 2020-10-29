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
// $Id: apb_sequence_lib.svh 1553 2018-05-15 21:29:07Z francois $
// $Author: francois $
// $LastChangedDate: 2018-05-15 23:29:07 +0200 (mar., 15 mai 2018) $
// $Revision: 1553 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 Default Sequence Library
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{

/// \addtogroup seqlib Sequence Library
/// @{


//--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
/// \brief APB Single Transfer sequence
/// \details this sequence can be used as an intermediate sequence between a single apb transfer item and upper level (virtual) sequences
class apb_single_transfer_seq extends apb_sequence;

  rand int unsigned         delay;     ///< intertransfer delay prior to send the current transfer
  rand bit [31:0]           address;   ///< address of the transfer
  rand bit [31:0]           data;      ///< data transmitted
  rand apb_direction_t      direction; ///< READ or WRITE. Random by default.
  rand bit                  slverror;  ///< Transfer Error
  rand int unsigned         waitstates;///< Cycle where Slave extend the transfer
  rand shortint unsigned    sel;        ///< Select the APB line to be used. Constrained by cfg.psel_width.\b additionally constrained by address map.
  // AMBA 4 APB v2.0 fields - IHI0024C
  rand apb_prot_t         prot;        ///< Protection Mode
  rand bit [3:0]          strobe;      ///< Write Strobe
  rand bit                full_access; ///< Force Write Strobe to be 'b1111

  `aed_apb_transfer_default_soft_constraints

  /// Sequence Body
  virtual task body();
    `uvm_do_with(req, {
         direction   == local::direction;
         waitstates  == local::waitstates;
         address     == local::address;
         data        == local::data;
         delay       == local::delay;
         sel         == local::sel;
         prot        == local::prot;
         strobe      == local::strobe;
     })
     data = req.data; // DATA capture for WRITE
     waitstates = req.waitstates;
     slverror = req.slverror;
  endtask

  `pragma protect begin
  /// constructor
  function new(string name="adb_apb_single_transfer");
    super.new(name);
  endfunction

  `uvm_object_utils(apb_single_transfer_seq)
  `pragma protect end
endclass


//--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
/// \brief APB Random sequence
/// \details this sequence can be used as an intermediate sequence between a single apb transfer item and upper level (virtual) sequences
class apb_random_seq extends apb_sequence;
  rand bit end_of_test_control;
  rand int unsigned count;

  constraint count_c {
    soft count inside { [100:500] } ;
  }
  constraint end_of_test_control_c {
    soft end_of_test_control == 1;
  }

  /// Sequence Body
  task body();
    `uvm_info(get_name(),"Starting ...",UVM_NONE)

      if ( end_of_test_control )
      starting_phase.raise_objection(this);

    repeat (count)
      `uvm_do(req)

    if ( end_of_test_control )
        starting_phase.drop_objection(this);

  endtask


  `uvm_object_utils_begin(apb_random_seq)
    `uvm_field_int(count , UVM_DEFAULT | UVM_DEC )
  `uvm_object_utils_end
endclass

//--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
/// \brief APB Increment Transfers sequence
/// \details Generate Consecutive Writes or Consecutive Reads
class apb_incrementing_address_seq extends apb_sequence;
  rand apb_direction_t      direction;       ///< READ or WRITE. Random by default.
  rand apb_address_t        start_address;   ///< First Address
  rand int unsigned count;

  constraint count_c {
    soft count inside { [10:50] } ;
  }

  /// Sequence Body
  virtual task body();
    for(int ii=0;ii<count;ii++) begin
      `uvm_do_with(req, {
          direction    == local::direction;
          address      == ((local::start_address& 'hfffffffc) + ii*4) ;
          })
    end
  endtask

  `uvm_object_utils_begin(apb_incrementing_address_seq)
    `uvm_field_int (                  count        , UVM_DEFAULT | UVM_DEC)
    `uvm_field_enum(apb_direction_t , direction    , UVM_DEFAULT)
    `uvm_field_int (                  start_address, UVM_DEFAULT | UVM_HEX)
  `uvm_object_utils_end
endclass

//--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
/// \brief APB Concurrent Read/Write Incremental Transfers
class apb_concurrent_increment_read_write_seq extends apb_sequence;
  apb_incrementing_address_seq incr_read_seq;
  apb_incrementing_address_seq incr_write_seq;

  /// Sequence Body
  virtual task body();
    fork
      `uvm_do_with( incr_read_seq , { direction==READ; } )
      `uvm_do_with( incr_write_seq , { direction==WRITE; } )
    join
  endtask

  `uvm_object_utils_begin(apb_concurrent_increment_read_write_seq)
  `uvm_object_utils_end
endclass

//--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
/// \brief APB Concurrent Read/Write Incremental Transfers
class apb_with_size_seq extends apb_sequence;
  typedef enum {BYTE =1 ,HWORD = 2,WORD = 4} width_t;
  //----------------------
  /// Fields declaration
  rand int unsigned       delay;        ///< intertransfer delay prior to send the current transfer
  rand apb_address_t      address;      ///< address of the transfer
  rand apb_address_t      alligned_addr;///< Computed aligned address
  rand apb_data_t         data;         ///< data transmitted
  rand apb_data_t         data_alligned;///< data alligned transmitted
  rand apb_direction_t    direction;    ///< READ or WRITE. Random by default.
  rand bit                slverror;     ///< Transfer Error
  rand int unsigned       waitstates;   ///< Cycle where Slave extend the transfer
  rand shortint unsigned  sel;          ///< Select the APB line to be used. Constrained by cfg.psel_width.\b additionally constrained by address map.
  // AMBA 4 APB v2.0 fields - IHI0024C
  rand apb_prot_t         prot;         ///< Protection Mode
  rand bit[3:0]           strobe;       ///< Write Strobe
  rand bit                full_access;  ///< Force Write Strobe to be 'b1111
  rand width_t            width;        ///< width of the transfer inside { BYTE, HWORD , WORD}

  constraint alligned_address_c {alligned_addr == address - (address%4) ;}
  constraint strobe_c           {strobe        == (width << (address%4) );}
  constraint data_c             {data_alligned == (data <<  8*(address%4) );}
  constraint full_access_c      {soft full_access  == 0 ;}
  `aed_apb_transfer_default_soft_constraints

  /// Sequence Body
  virtual task body();
      `uvm_do_with( req , { req.direction   == local::direction;
                            req.delay       == local::delay;
                            req.address     == local::alligned_addr;
                            req.data        == local::data_alligned;
                            req.slverror    == local::slverror;
                            req.waitstates  == local::waitstates;
                            req.sel         == local::sel;
                            req.prot        == local::prot;
                            req.strobe      == local::strobe;
                            req.full_access == local::full_access;} )
  endtask

  `uvm_object_utils_begin(apb_with_size_seq)
  `uvm_object_utils_end
endclass

class apb_byte_seq extends apb_with_size_seq;

  constraint width_c {width == BYTE ;}

  `uvm_object_utils(apb_byte_seq)
endclass

class apb_half_word_seq extends apb_with_size_seq;

  constraint width_c {width == HWORD ;}
  `uvm_object_utils(apb_half_word_seq)

endclass

class apb_word_seq extends apb_with_size_seq;
  constraint width_c {width == WORD ;}
  `uvm_object_utils(apb_word_seq)
endclass


//--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
/// \brief APB Random Slave Sequence
class apb_slave_resp_seq extends apb_slave_sequence;
  rand int unsigned     delay; ///< intertransfer delay prior to send the current transfer
  rand bit [31:0]       address;    ///< address of the transfer
  rand bit [31:0]       data;    ///< data transmitted
  rand apb_direction_t  direction;   ///< READ or WRITE. Random by default.
  rand bit              slverror;       ///< Transfer Error
  rand int unsigned     waitstates;     ///< Cycle where Slave extend the transfer
  rand shortint unsigned  sel;        ///< Select the APB line to be used. Constrained by cfg.psel_width.\b additionally constrained by address map.
  // AMBA 4 APB v2.0 fields - IHI0024C
  rand apb_prot_t         prot;        ///< Protection Mode
  rand bit [3:0]          strobe;      ///< Write Strobe
  rand bit                full_access; ///< Force Write Strobe to be 'b1111

  `aed_apb_transfer_default_soft_constraints

  /// Sequence Body
  virtual task body();
    `uvm_info(get_name(),"Starting ...",UVM_FULL)

      `uvm_do_with(req, {
          direction    == local::direction;
          waitstates   == local::waitstates;
          address      == local::address;
          data         == local::data;
          delay        == local::delay;
          slverror     == local::slverror;
          prot         == local::prot;
          strobe       == local::strobe;
        })
      data = req.data; // DATA capture for WRITE
    direction = req.direction;
    address = req.address;
  endtask

  `pragma protect begin
  /// constructor
  function new(string name="apb_slave_resp_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(apb_slave_resp_seq)

  `pragma protect end
endclass

//--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
/// Automatic Response Sequence
class apb_slave_auto_resp_seq extends apb_slave_sequence;
  apb_transfer resp;

  /// Sequence Body
  task body();
    forever begin
      `uvm_do(resp)
    end
  endtask
  `uvm_object_utils(apb_slave_auto_resp_seq)
endclass


//--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
/// Automatic Response Sequence
class apb_slave_default_reactive_seq extends apb_slave_sequence;
  apb_transfer resp;

  /// Sequence Body
  task body();
    forever begin
      p_sequencer.address_phase_transfer_fifo.get(req);
      `uvm_do_with(resp,
        {
          resp.direction == req.direction;
          if ( req.direction == WRITE ) {
            resp.data      == req.data;
            resp.address   == req.address;
          }
        }
      )
    end
  endtask

  `uvm_object_utils(apb_slave_default_reactive_seq)
endclass





/// @}
/// @}
/// @}

