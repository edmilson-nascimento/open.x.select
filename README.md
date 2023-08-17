# Open cursor VS Select
 ~com toda certeza minha criativade se foi de vez, porque eu gastei um bom tempo colocar um titulo e no final... é isso~

 Houve um comentario que gerou esse programa e o comentario foi
 Dessa forma é mais rapido do que o select direto e evita `dump` por causa da grande quantidade de dados que temos.

 ```abap
     OPEN CURSOR WITH HOLD @s_cursor FOR

    SELECT bukrs, belnr, gjahr, buzei
      FROM <table>
     WHERE <field> eq @<field> .

    DO.

      FETCH NEXT CURSOR s_cursor APPENDING TABLE <internal_table> PACKAGE SIZE 1000.

      IF sy-subrc IS NOT INITIAL.
        EXIT.
      ENDIF.

    ENDDO.

    CLOSE CURSOR s_cursor.
 ```

 ~hoje mesmo me chamaram de cabeça dura~ Mas eu aprendi a questionar, pois a tecnilogia é uma ciência exata e eu posso provar ou não o que esta certo atravez de provas, testes, conceitos matematicos e metricas de processamento. Como é bom ser NERD.

