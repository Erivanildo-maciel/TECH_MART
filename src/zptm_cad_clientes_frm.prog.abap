*&---------------------------------------------------------------------*
*& Form SALVAR_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM salvar_dados.

  DATA: vl_cadastrado_em TYPE zttm_clientes-cadastradp_em,
        vl_data          TYPE dats,
        vl_hora          TYPE t,
        lv_prx_id        TYPE i.

  CALL FUNCTION 'NUMBER_GET_NEXT' "Gerador de Numeração seuqncial de ID
    EXPORTING
      nr_range_nr             = '00'
      object                  = 'ZIN_ID'
    IMPORTING
      number                  = lv_prx_id
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.

  IF sy-subrc = 0.
    MESSAGE |O número gerado foi: { lv_prx_id }| TYPE 'S'.
  ELSE.
    MESSAGE |Erro em gerar o Número: ( { lv_prx_id } )| TYPE 'E' DISPLAY LIKE 'S'.
  ENDIF.

  vl_data = sy-datum. "Hora de criação pelo sistema
  vl_hora = sy-uzeit. "Data de Criação pelo sistema

  CONCATENATE vl_data vl_hora INTO vl_cadastrado_em SEPARATED BY '-'. "Hora e data de criação do cadastro salva no mesmo campo

  gt_clientes-cadastradp_em = vl_cadastrado_em.
  gt_clientes-id = lv_prx_id. "Número gerado pela função de intervalo de numeração
  gt_clientes-cadastrado_por = sy-uname. "Usuário que Efetuou o cadastro

  INSERT zttm_clientes FROM gt_clientes. "Alimentando a tabela do banco de dados com a tabela de cadastro

  IF sy-subrc = 0.

    MESSAGE |Cliente { lv_prx_id }, cadastrado com sucesso!| TYPE 'S'.

  ELSE.

    MESSAGE 'Erro no cadastro do cliente' TYPE 'E'.

  ENDIF.

ENDFORM.

FORM buscar_dados_cliente." Buscar os dados para tualização de cadastro

  SELECT SINGLE * "Consulta para saber se o ID a ser Aletrado exite.
    FROM zttm_clientes
    INTO gt_clientes
   WHERE id = gt_up_clientes.

  IF sy-subrc = 0. "Se o ID existir, atualizamos o cadastro apartir da tela da transação de cadastro
    CALL SCREEN 9000.
  ENDIF.

ENDFORM.

FORM atualizar_dados .

  DATA: vl_atualizado_em TYPE zttm_clientes-cadastradp_em,
        vl_data          TYPE dats,
        vl_hora          TYPE t.

  vl_data = sy-datum.
  vl_hora = sy-uzeit.

  CONCATENATE vl_data vl_hora INTO vl_atualizado_em SEPARATED BY '-'.

  gt_clientes-atualizado_em = vl_atualizado_em.
  gt_clientes-atualizado_por = sy-uname.

  UPDATE zttm_clientes
  SET nome           = @gt_clientes-nome,
      telefone       = @gt_clientes-telefone,
      email          = @gt_clientes-email,
      endereco       = @gt_clientes-endereco,
      limite         = @gt_clientes-limite,
      status         = @gt_clientes-status,
      atualizado_em  = @gt_clientes-atualizado_em,
      atualizado_por = @gt_clientes-atualizado_por
  WHERE id = @gt_up_clientes.

  IF sy-subrc = 0.

    MESSAGE 'Cadastrado atualizado com sucesso!' TYPE 'S'.

  ELSE.

    MESSAGE 'Erro na atualização do cadastro' TYPE 'E'.

  ENDIF.

ENDFORM.

FORM visualisar_dados_cliente.

  SELECT id
         nome
         telefone
         email
         endereco
         limite
         status
    FROM zttm_clientes
    INTO TABLE it_clientes
   WHERE id EQ gt_clientes-id.

  CALL METHOD cl_salv_table=>factory

    IMPORTING
      r_salv_table = ir_alv
    CHANGING
      t_table      = it_clientes.

  PERFORM catalogo_campos.

  ir_alv->display( ).

ENDFORM.

FORM catalogo_campos.

  DATA: o_columns TYPE REF TO cl_salv_columns,
        o_column  TYPE REF TO cl_salv_column.

  o_columns = ir_alv->get_columns( ).
  o_columns->set_optimize( 'X' ).

  o_column = o_columns->get_column( 'ID' ). " 01 ID do Cliente
  o_column->set_short_text(  'Id' ).
  o_column->set_medium_text( 'Id' ).
  o_column->set_long_text(   'Id' ).
  o_column->set_output_length( 10 ).

  o_column = o_columns->get_column( 'NOME' ). " 02 Nome
  o_column->set_short_text(  'Nome' ).
  o_column->set_medium_text( 'Nome' ).
  o_column->set_long_text(   'Nome' ).
  o_column->set_output_length( 60 ).

  o_column = o_columns->get_column( 'TELEFONE' ). "03 Telefone
  o_column->set_short_text(  'Cont.' ).
  o_column->set_medium_text( 'Contato' ).
  o_column->set_long_text(   'Contato do Cliente' ).
  o_column->set_output_length( 12 ).

  o_column = o_columns->get_column( 'EMAIL' ). "04 Email
  o_column->set_short_text(  'Email' ).
  o_column->set_medium_text( 'Email' ).
  o_column->set_long_text(   'Email' ).
  o_column->set_output_length( 70 ).

  o_column = o_columns->get_column( 'ENDERECO' ). "05 Endereço
  o_column->set_short_text(  'End' ).
  o_column->set_medium_text( 'Endereço' ).
  o_column->set_long_text(   'Endereço do Cliente' ).
  o_column->set_output_length( 100 ).

  o_column = o_columns->get_column( 'LIMITE' ). "06 Limite de Crédito
  o_column->set_short_text(  'Limite' ).
  o_column->set_medium_text( 'Limite' ).
  o_column->set_long_text(   'Limite' ).
  o_column->set_output_length( 12 ).

  o_column = o_columns->get_column( 'STATUS' ). "07 Status Ativo ou Bloqueado
  o_column->set_short_text(  'Status' ).
  o_column->set_medium_text( 'Status' ).
  o_column->set_long_text(   'Status' ).
  o_column->set_output_length( 30 ).

ENDFORM.
