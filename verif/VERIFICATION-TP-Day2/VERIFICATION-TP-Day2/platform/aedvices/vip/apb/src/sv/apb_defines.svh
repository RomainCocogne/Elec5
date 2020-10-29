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
// $Id: apb_defines.svh 1781 2018-08-07 07:37:17Z dung $
// $Author: dung $
// $LastChangedDate: 2018-08-07 09:37:17 +0200 (mar., 07 août 2018) $
// $Revision: 1781 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 APB VIP Defines and Macros
 */


/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{

/// \addtogroup Macros
/// @{

`ifndef aed_apb_define_header
`define aed_apb_define_header


/// \brief Maximum address width used by the interfaces and VIP agents.
/// \details Defines the address vector width. default=32.
`ifndef MAX_ADDR_WIDTH
    `define MAX_ADDR_WIDTH 32
`endif

/// \brief Maximum width supported on PSEL. This defines the default PSEL vector width.
/// \details Maximum width supported on PSEL. \n
/// This defines the default PSEL vector width. \n
/// It can be defined by the user prior to load the VIP
`ifndef MAX_PSEL_WIDTH
  `define MAX_PSEL_WIDTH 8
`endif


/// \brief constrains the default transmit delay
`define aed_apb_transfer_default_soft_constraints \
  constraint c_default_delay {\
    if ( cfg != null ) {\
      \
      soft delay >= cfg.min_intertransfer;\
      soft delay <= cfg.max_intertransfer;\
      \
      sel < cfg.psel_width;\
      \
      if (direction == READ) {\
        soft waitstates >= cfg.read_min_waitstates;\
        soft waitstates <= cfg.read_max_waitstates;\
      }\
      \
      if (direction == WRITE) {\
        soft waitstates >= cfg.write_min_waitstates;\
        soft waitstates <= cfg.write_max_waitstates;\
      }\
      \
      if ( cfg.apb_revision == IHI0024B) {\
        prot   == 0; \
        strobe == 'b1111; \
      }\
      \
      soft slverror dist {\
        0 := (100-cfg.default_slverror_weight),\
        1 := (cfg.default_slverror_weight)\
      };\
      \
    } else {\
      soft delay      inside { [0:20] };\
      soft waitstates inside { [0:20] };\
    }\
  }


`endif //  aed_apb_define_header
/// @}
/// @}
/// @}
