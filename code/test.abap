*&---------------------------------------------------------------------*
*& Report ytest
*&---------------------------------------------------------------------*
REPORT ytest.


CLASS lcl_local DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !im_gjahr TYPE bseg-gjahr .

    METHODS get_by_select .

    METHODS get_by_open .

    METHODS display_data .

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_data,
        bukrs TYPE bseg-bukrs,
        belnr TYPE bseg-belnr,
        gjahr TYPE bseg-gjahr,
        buzei TYPE bseg-buzei,
      END OF ty_data,
      tab_data TYPE STANDARD TABLE OF ty_data
              WITH DEFAULT KEY .

    DATA:
      gv_gjahr TYPE bseg-gjahr,
      gt_data  TYPE tab_data.

ENDCLASS.


CLASS lcl_local IMPLEMENTATION.

  METHOD constructor .

    IF ( im_gjahr IS NOT INITIAL ) .
      me->gv_gjahr = im_gjahr .
    ENDIF .

  ENDMETHOD .

  METHOD get_by_select .

    CLEAR me->gt_data .

    SELECT bukrs, belnr, gjahr, buzei
      FROM bseg
     WHERE gjahr GE @me->gv_gjahr
      INTO TABLE @me->gt_data .

  ENDMETHOD .

  METHOD get_by_open .

    DATA s_cursor TYPE cursor.

    OPEN CURSOR WITH HOLD @s_cursor FOR

    SELECT bukrs, belnr, gjahr, buzei
      FROM bseg
     WHERE gjahr GE @me->gv_gjahr .

    DO .

      FETCH NEXT CURSOR s_cursor 
      APPENDING TABLE me->gt_data PACKAGE SIZE 1000.

      IF sy-subrc IS NOT INITIAL.
        EXIT.
      ENDIF.

    " Neste ponto, colocar uma rotina de processamento de busca do
    " lote de 1000 que foi recuperado acima

    ENDDO .

    CLOSE CURSOR s_cursor.

  ENDMETHOD .


  METHOD display_data .

    DATA:
      salv_table TYPE REF TO cl_salv_table .

    IF ( lines( me->gt_data ) EQ 0 ) .
      RETURN .
    ENDIF .

    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = salv_table
          CHANGING
            t_table      = me->gt_data.
      CATCH cx_salv_msg.
    ENDTRY.

    salv_table->display( ) .

  ENDMETHOD .

ENDCLASS.

PARAMETERS:
  p_begin  TYPE gjahr OBLIGATORY DEFAULT '2018',
  p_select TYPE check RADIOBUTTON GROUP r1 DEFAULT 'X',
  p_open   TYPE check RADIOBUTTON GROUP r1.

START-OF-SELECTION .

  DATA(object) = NEW lcl_local( p_begin ) .

  IF ( object IS NOT BOUND ) .
    RETURN .
  ENDIF .

  CASE abap_true .
    WHEN p_select .
      object->get_by_select( ).
    WHEN p_open .
      object->get_by_open( ).
  ENDCASE .



END-OF-SELECTION .

  object->display_data( ).