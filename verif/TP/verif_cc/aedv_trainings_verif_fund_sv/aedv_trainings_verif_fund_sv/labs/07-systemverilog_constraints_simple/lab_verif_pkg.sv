


package lab_verif_pkg;

  typedef logic [7:0]               data_t;      ///< Main Data Type
  typedef enum logic {READ, WRITE}  direction_t; ///< Direction Type
  typedef enum logic {ACC, COMPUTE} action_t;    ///< Type of transaction

  //Transaction Class
  class transactionBase ;
  
    // LAB-TODO-STEP-1: Analyse the attributes declaration: What are the differences between data and addr generation ? Why are data always X when transaction.randomized() is called ?
    // LAB-TODO-STEP-2-a - Add "rand" modifier to data attribute
    //-----------------------
    /// rand class members
    //-----------------------
    rand data_t      addr;
    rand data_t      data;
    rand direction_t dir;
    rand action_t    action;

    extern virtual function void print();
  endclass

  class adderTransaction extends transactionBase;

    // Address is in the range from 0 to 5
    constraint addr_range {
      addr inside {['h0:'h5]};
    }

    // LAB-TODO-STEP-2-b: Add constraints to specify read only area.
    constraint read_only_area {
      addr inside {'h4, 'h5} -> dir == READ;
    }

  endclass



  function void transactionBase::print();
      $display("Transaction %6s - %6s - address == 0x%02x - Data = 0x%02x \n" ,
              this.action.name , this.dir.name , this.addr , data );
  endfunction    




endpackage