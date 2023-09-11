*&---------------------------------------------------------------------*
*& Include          ZPTM_CAD_CLIENTES_TOP
*&---------------------------------------------------------------------*
DATA: gt_clientes    TYPE zttm_clientes,
      gt_up_clientes TYPE ztmed_id.

TYPES: BEGIN OF ty_clientes,
         id       TYPE zttm_clientes-id,
         nome     TYPE zttm_clientes-nome,
         telefone TYPE zttm_clientes-telefone,
         email    TYPE zttm_clientes-email,
         endereco TYPE zttm_clientes-endereco,
         limite   TYPE zttm_clientes-limite,
         status   TYPE zttm_clientes-status,
       END OF ty_clientes.

DATA: it_clientes TYPE TABLE OF ty_clientes,
      st_clientes TYPE ty_clientes.

data: ir_alv TYPE REF TO cl_salv_table.
