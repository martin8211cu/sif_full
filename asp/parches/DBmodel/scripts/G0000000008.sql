/*
SCRIPT DE BASE DE DATOS ASP PARA:
	SCHEMA:  SISTEMAS
	MODELO:  SIF Sistemas.pdm
	VERSION: 1 - Version 100: Actualizar hasta 27/01/2011

	         PARCHE:  BASE CERO: SIF Sistemas

GENERAR UNICAMENTE EN:
	SERVER:  http://localhost:8099
	DSN:     minisiftrd
	FECHA:   16/02/2011 19:31:30
*/

/* INI_SCRIPT */

/* ======================================================================================== */
/* CHG_TABLE CFinanciera: Cuentas Financieras o de Ultim */
/* ======================================================================================== */
/* DEL_CHECK OP=(OBSOLETO): chk=(Ccuenta IS NOT NULL AND CFmovimiento='S' OR CFmovimiento<>'S') */
ALTER TABLE CFinanciera DROP CONSTRAINT CFinanciera_CK
go
/* ADD_CHECK: chk=(Ccuenta is not null and CFmovimiento = 'S' or CFmovimiento <> 'S') */
ALTER TABLE CFinanciera ADD CONSTRAINT CFinanciera_CK CHECK (Ccuenta is not null and CFmovimiento = 'S' or CFmovimiento <> 'S')
go
/* ======================================================================================== */
/* CHG_TABLE WfActivity: Actividad */
/* ======================================================================================== */
/* DEL_CHECK OP=(OBSOLETO): chk=(IsStart=(0) OR IsFinish=(0)) */
ALTER TABLE WfActivity DROP CONSTRAINT WfActivity_CK
go
/* ADD_CHECK: chk=(IsStart = 0 or IsFinish = 0) */
ALTER TABLE WfActivity ADD CONSTRAINT WfActivity_CK CHECK (IsStart = 0 or IsFinish = 0)
go
/* END_SCRIPT */
