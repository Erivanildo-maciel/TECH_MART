
MODULE pbo_9000 OUTPUT. "Tela de Cadastro de clientes
  SET PF-STATUS 'STATUS9000'.
  SET TITLEBAR 'TITLE9000'.
ENDMODULE.

MODULE pai_9000 INPUT. "Tela de Cadastro de clientes
  CASE sy-ucomm.
    WHEN '&F03'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
      IF sy-tcode = 'ZTM_CLIENTES_01'.
        PERFORM salvar_dados.
      ELSEIF sy-tcode = 'ZTM_CLIENTES_02'.
        PERFORM atualizar_dados.
      ENDIF.
    WHEN '&F15' OR '&F12'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

MODULE pbo_9001 OUTPUT. "Tela de Atualização de Cadastro
  SET PF-STATUS 'STATUS9001'.
  SET TITLEBAR 'TITLE9001'.
ENDMODULE.

MODULE pai_9001 INPUT. "Tela de Atualização de Cadastro
  CASE sy-ucomm.
    WHEN '&F03'.
      LEAVE TO SCREEN 0.
    WHEN 'EXEC' OR ''.
      PERFORM buscar_dados_cliente.
    WHEN '&F15' OR '&F12'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

MODULE pbo_9002 OUTPUT. "Tela de Visualização de Dados de Clientes
  SET PF-STATUS 'STATUS9002'.
  SET TITLEBAR 'TITLE9002'.
ENDMODULE.

MODULE pai_9002 INPUT. "Tela de Visualização de Dados de Clientes

  CASE sy-ucomm.
    WHEN 'EXEC'.
      PERFORM visualisar_dados_cliente.
    WHEN '&F03'.
      LEAVE TO SCREEN 0.
    WHEN '&F15' OR '&F12'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
