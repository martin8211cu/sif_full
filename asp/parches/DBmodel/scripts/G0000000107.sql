/*
SCRIPT DE BASE DE DATOS ASP PARA:
	SCHEMA:  SISTEMAS
	MODELO:  SIF Sistemas.pdm
	VERSION: 391 - DBM 439: Agregar las fechas CMPfechaAprob, CMPfech

	         PARCHE:  Parche023_608_SIF_Reportes_Estadisticos_Detallados

GENERAR UNICAMENTE EN:
	SERVER:  http://www.aphcenter.com
	DSN:     minisif
	FECHA:   28/02/2012 09:54:00
*/

/* INI_SCRIPT */

/* ================================================================= */
/*    ELIMINA FKs QUE YA NO SE UTILIZAN O CON CAMPOS MODIFICADOS     */
/* ================================================================= */
/* CHG_TABLE ETransacciones */
/* DEL_FK OP = (OBSOLETO): TIP="F", COLS="Ecodigo,Icodigo", REF="Impuestos" */
ALTER TABLE ETransacciones DROP CONSTRAINT ETransacciones_FK08 /* REFERENCES Impuestos (Ecodigo,Icodigo) */
go

/* ======================================================================================== */
/* CHG_TABLE CMProcesoCompra: CM Proceso de Compra */
/* ======================================================================================== */
/* ADD_COLUMN OP = (NUEVO): CMPfechaAprob - Fecha Aprobacion Cotización */
ALTER TABLE CMProcesoCompra ADD CMPfechaAprob datetime NULL
go

/* ADD_COLUMN OP = (NUEVO): CMPfechaEnvAprob - Fecha Envio Aprobación Solicitante */
ALTER TABLE CMProcesoCompra ADD CMPfechaEnvAprob datetime NULL
go

/* ======================================================================================== */
/* CHG_TABLE ETransacciones: Encabezado de Transacciones de */
/* ======================================================================================== */
/* DEL_KEY OP = (OBSOLETO): TIP="F", COLS="Ecodigo,Icodigo", REF="Impuestos" */
DROP INDEX ETransacciones.ETransacciones_FI08 /* REFERENCES INDEX (Ecodigo,Icodigo) */
go

/* DEL_COLUMN OP = (OBSOLETO): Icodigo - Codigo de Impuesto */
ALTER TABLE ETransacciones DROP COLUMN Icodigo
go
/* ADD_COLUMN OP = (NUEVO): ETnotaCredito - Generar Nota de Credito */
ALTER TABLE ETransacciones ADD ETnotaCredito bit DEFAULT 0 NOT NULL
go

/* END_SCRIPT */
