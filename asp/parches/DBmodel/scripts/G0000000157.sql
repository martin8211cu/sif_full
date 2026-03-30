/*
SCRIPT DE BASE DE DATOS ASP PARA:
	SCHEMA:  SISTEMAS
	MODELO:  SIF Sistemas.pdm
	VERSION: 1 - Version 100: Actualizar hasta 27/01/2011

	         PARCHE:  BASE CERO: SIF Sistemas

GENERAR UNICAMENTE EN:
	SERVER:  http://mxvqapp34:8300
	DSN:     minisiftrd
	FECHA:   16/01/2012 16:07:48
*/

/* INI_SCRIPT */

/* ======================================================================================== */
/* CHG_TABLE CFinanciera: Cuentas Financieras o de Ultim */
/* ======================================================================================== */
/* DEL_CHECK OP = (OBSOLETO): chk=(Ccuenta IS NOT NULL AND CFmovimiento='S' OR CFmovimiento<>'S') */
ALTER TABLE CFinanciera DROP CONSTRAINT CFinanciera_CK
go
/* ADD_CHECK: chk=(Ccuenta is not null and CFmovimiento = 'S' or CFmovimiento <> 'S') */
ALTER TABLE CFinanciera ADD CONSTRAINT CFinanciera_CK CHECK (Ccuenta is not null and CFmovimiento = 'S' or CFmovimiento <> 'S')
go
/* ADD_KEY OP = (OK): TIP="F", SEC="3", COLS="CFpadre", REF="CFinanciera" */
CREATE INDEX CFinanciera_FI03 ON CFinanciera (CFpadre)
go

/* ======================================================================================== */
/* CHG_TABLE CPLiquidacionParametros: Liquidacion Periodo Presupuest */
/* ======================================================================================== */
/* CHG_KEY OP = (CAMBIO): TIP="P", COLS="Ecodigo,CPPid,Ctipo,CPNAPDtipoMov" */
ALTER TABLE CPLiquidacionParametros DROP CONSTRAINT CPLiquidacionParametros_PK /* PRIMARY KEY (Ecodigo,CPPid,Ctipo,CPNAPDtipoMov) */
go

/* CHG_COLUMN OP = (CAMBIO): Ctipo - Origen Operacion Compras SP Anticipo Interfaces */
ALTER TABLE CPLiquidacionParametros DROP CONSTRAINT CPLiquidacionParametros_CK03 /* CHECK ([Ctipo]='G' OR [Ctipo]='I' OR [Ctipo]='A') */
go
ALTER TABLE CPLiquidacionParametros ADD CONSTRAINT CPLiquidacionParametros_CK03 CHECK ([Ctipo]='I' OR [Ctipo]='E' OR [Ctipo]='P' OR [Ctipo]='O' OR [Ctipo]='G' OR [Ctipo]='A')
go

/* CHG_COLUMN OP = (CAMBIO): CPLtipoLiquidacion - Forma Liquidacion con o sin fondos o no liquidar */
ALTER TABLE CPLiquidacionParametros DROP CONSTRAINT CPLiquidacionParametros_CK05 /* CHECK ([CPLtipoLiquidacion]='S' OR [CPLtipoLiquidacion]='C' OR [CPLtipoLiquidacion]='N') */
go
ALTER TABLE CPLiquidacionParametros ADD CONSTRAINT CPLiquidacionParametros_CK05 CHECK ([CPLtipoLiquidacion]='S' OR [CPLtipoLiquidacion]='C' OR [CPLtipoLiquidacion]='N' OR [CPLtipoLiquidacion]='-')
go

/* CHG_KEY OP = (CAMBIO): TIP="P", SEC="0", COLS="Ecodigo,CPPid,Ctipo,CPNAPDtipoMov" */
ALTER TABLE CPLiquidacionParametros ADD CONSTRAINT CPLiquidacionParametros_PK PRIMARY KEY NONCLUSTERED (Ecodigo,CPPid,Ctipo,CPNAPDtipoMov)
go

/* ======================================================================================== */
/* CHG_TABLE CPresupuestoComprometidasNAPs: Bitacora de NAPs de Compromiso */
/* ======================================================================================== */
/* DEL_KEY OP = (OBSOLETO): TIP="P", COLS="CPPid,Ecodigo,CPNAPnum" */
ALTER TABLE CPresupuestoComprometidasNAPs DROP CONSTRAINT CPresupuestoComprometid01_PK /* PRIMARY KEY (CPPid,Ecodigo,CPNAPnum) */
go

/* ADD_KEY OP = (NUEVO): TIP="P", SEC="0", COLS="CPPid,Ecodigo,CPNAPnum" */
ALTER TABLE CPresupuestoComprometidasNAPs ADD CONSTRAINT CPresupuestoComprometid01_PK PRIMARY KEY CLUSTERED (CPPid,Ecodigo,CPNAPnum)
go

/* ======================================================================================== */
/* CHG_TABLE CPtipoMov: Movimientos de Presupuesto */
/* ======================================================================================== */
/* DEL_KEY OP = (OBSOLETO): TIP="P", COLS="CPTMtipoMov" */
ALTER TABLE CPtipoMov DROP CONSTRAINT CPtipoMov_PK /* PRIMARY KEY (CPTMtipoMov) */
go

/* ADD_KEY OP = (NUEVO): TIP="P", SEC="0", COLS="CPTMtipoMov" */
ALTER TABLE CPtipoMov ADD CONSTRAINT CPtipoMov_PK PRIMARY KEY NONCLUSTERED (CPTMtipoMov)
go

/* ======================================================================================== */
/* CHG_TABLE DDocumentos: Detalle de Documentos de CxC */
/* ======================================================================================== */
/* ADD_COLUMN OP = (NUEVO): Ocodigo - Codigo de oficina */
ALTER TABLE DDocumentos ADD Ocodigo integer NULL
go

/* ADD_COLUMN OP = (NUEVO): DcuentaT - DcuentaT */
ALTER TABLE DDocumentos ADD DcuentaT numeric(18) NULL
go

/* ADD_COLUMN OP = (NUEVO): DesTransitoria - Es transitoria */
ALTER TABLE DDocumentos ADD DesTransitoria bit NULL
go
UPDATE DDocumentos SET DesTransitoria = 0
go
ALTER TABLE DDocumentos ALTER COLUMN DesTransitoria bit NOT NULL
go

/* ======================================================================================== */
/* CHG_TABLE Documentos: Documentos de CxC */
/* ======================================================================================== */
/* ADD_COLUMN OP = (NUEVO): FCid - Id de la caja */
ALTER TABLE Documentos ADD FCid numeric(18) NULL
go

/* ADD_COLUMN OP = (NUEVO): ETnumero - Numero de la transaccion */
ALTER TABLE Documentos ADD ETnumero numeric(18) NULL
go

/* ======================================================================================== */
/* CHG_TABLE HDDocumentos: Histórico de Detalle de Docume */
/* ======================================================================================== */
/* ADD_COLUMN OP = (NUEVO): DcuentaT - Cuenta Transitoria */
ALTER TABLE HDDocumentos ADD DcuentaT numeric(18) NULL
go

/* ADD_COLUMN OP = (NUEVO): DesTransitoria - Tiene Transitoria? */
ALTER TABLE HDDocumentos ADD DesTransitoria bit DEFAULT 0 NOT NULL
go

/* ======================================================================================== */
/* CHG_TABLE HDocumentos: Histórico de Documentos Aplica */
/* ======================================================================================== */
/* ADD_COLUMN OP = (NUEVO): FCid - ID de la Caja */
ALTER TABLE HDocumentos ADD FCid numeric(18) NULL
go

/* ADD_COLUMN OP = (NUEVO): ETnumero - Numero de la Transaccion */
ALTER TABLE HDocumentos ADD ETnumero numeric(18) NULL
go

/* ADD_COLUMN OP = (NUEVO): Danulado - Documento Anulado */
ALTER TABLE HDocumentos ADD Danulado bit DEFAULT 0 NOT NULL
go

/* ======================================================================================== */
/* CHG_TABLE WfActivity: Actividad */
/* ======================================================================================== */
/* DEL_CHECK OP = (OBSOLETO): chk=(IsStart=(0) OR IsFinish=(0)) */
ALTER TABLE WfActivity DROP CONSTRAINT WfActivity_CK
go
/* ADD_CHECK: chk=(IsStart = 0 or IsFinish = 0) */
ALTER TABLE WfActivity ADD CONSTRAINT WfActivity_CK CHECK (IsStart = 0 or IsFinish = 0)
go
/* END_SCRIPT */
