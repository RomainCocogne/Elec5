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
// $Id: apb_types.svh 1686 2018-05-29 07:12:26Z adrien $
// $Author: adrien $
// $LastChangedDate: 2018-05-29 09:12:26 +0200 (mar., 29 mai 2018) $
// $Revision: 1686 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 APB VIP Type Definitions
 */


/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{

/// \addtogroup Types
/// @{

/// \brief APB Protocol Revision used by the agent
typedef enum {
  IHI0024B,  ///< [IHI0024B] "ARM IHI 0024B" AMBA™ 3 APB Protocol, v1.0, Issue B, 17 August 2004
  IHI0024C   ///< [IHI0024C] "ARM IHI 0024B" AMBA™ 3 APB Protocol, v2.0, Issue C, 13 April 2010
} apb_protocol_rev_t;

/// \brief Agent kind ( MASTER or SLAVE )
typedef enum {
  MONITOR ,    ///< A monitor agent is a  passive agent and does not provide any driver nor sequencer
  MASTER ,     ///< A master agent drives requests and waits for the responses.
  SLAVE        ///< A slave agent receives requests and sends the responses.
  } apb_agent_kind_t;

// APB transfer direction READ or WRITE
typedef enum {
  READ = 0,  ///< Defines a read transaction
  WRITE = 1  ///< Defines a write transaction
  }                  apb_direction_t;

/// APB transfer protection mode
typedef enum {
  normal_secure_data               = 'b000 , ///< Normal, Secure, Data Access. See [IHI0024C] - 3.5 Protection Unit
  privileged_secure_data           = 'b001 , ///< Privileged, Secure, Data Access. See [IHI0024C] - 3.5 Protection Unit
  normal_nonsecure_data            = 'b010 , ///< Normal, Non-Secure, Data Access. See [IHI0024C] - 3.5 Protection Unit
  privileged_nonsecure_data        = 'b011 , ///< Privileged, Non-Secure, Data Access. See [IHI0024C] - 3.5 Protection Unit
  normal_secure_instruction        = 'b100 , ///< Normal, Secure, Instruction Access. See [IHI0024C] - 3.5 Protection Unit
  privileged_secure_instruction    = 'b101 , ///< Privileged, Secure, Instruction Access. See [IHI0024C] - 3.5 Protection Unit
  normal_nonsecure_instruction     = 'b110 , ///< Normal, Non-Secure, Instruction Access. See [IHI0024C] - 3.5 Protection Unit
  privileged_nonsecure_instruction = 'b111   ///< Privileged, Non-Secure, Instruction Access. See [IHI0024C] - 3.5 Protection Unit
  } apb_prot_t;


/// APB Address type
typedef bit [`MAX_ADDR_WIDTH-1:0] apb_address_t;

/// APB Data type
typedef bit [31:0] apb_data_t;

typedef enum { BYTE=1, HWORD=3 , WORD=7} apb_data_width_t;

/// @}
/// @}
/// @}