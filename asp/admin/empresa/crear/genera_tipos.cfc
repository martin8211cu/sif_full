<cfcomponent output="no">
<!--- generacubo con insert al final.sql --->
<cffunction name="copiar" output="false" returntype="void">
	<cfargument name="dsori" type="string" hint="datasource origen">
	<cfargument name="dsdst" type="string" hint="datasource destino">
	<cfargument name="Eori" type="numeric" hint="Ereferencia(Ecodigo int) origen">
	<cfargument name="Edst" type="numeric" hint="Ereferencia(Ecodigo int) destino">
	<cfargument name="CEdst" type="numeric" hint="CEcodigo destino">

<cfquery datasource="#dsdst#">
/* Inserta transacciones de Banco */
insert BTransacciones (Ecodigo, BTcodigo, BTdescripcion, BTtipo) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CH', 'Cheque', 'C')
insert BTransacciones (Ecodigo, BTcodigo, BTdescripcion, BTtipo) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'TR', 'Transferencia', 'C')
insert BTransacciones (Ecodigo, BTcodigo, BTdescripcion, BTtipo) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'DP', 'Depósito', 'D')
insert BTransacciones (Ecodigo, BTcodigo, BTdescripcion, BTtipo) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'ND', 'Nota Débito', 'D')
insert BTransacciones (Ecodigo, BTcodigo, BTdescripcion, BTtipo) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'NC', 'Nota Crédito', 'C')
insert BTransacciones (Ecodigo, BTcodigo, BTdescripcion, BTtipo) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AD', 'Ajustes Débito', 'D')
insert BTransacciones (Ecodigo, BTcodigo, BTdescripcion, BTtipo) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AC', 'Ajustes Crédito', 'C')

</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta transacciones de CxP */
insert CPTransacciones 
(Ecodigo, CPTcodigo, CPTdescripcion,    CPTtipo, CPTvencim, CPTpago, BTid, CPTcktr, BMUsucodigo, CPTafectacostoventas, CPTnoflujoefe, FMT01COD, cuentac, CPTcodigoext, CPTestimacion, CPTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'FA',      'Factura Crédito', 'C',     0,         0,       null, null,    null,        0,                    0,             null,     null,    null,         0,             null

insert CPTransacciones 
(Ecodigo, CPTcodigo, CPTdescripcion,    CPTtipo, CPTvencim, CPTpago, BTid, CPTcktr, BMUsucodigo, CPTafectacostoventas, CPTnoflujoefe, FMT01COD, cuentac, CPTcodigoext, CPTestimacion, CPTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'ND',      'Nota Débito',     'C',     0,         0,       null, null,    null,        0,                    0,             null,     null,    null,         0,             null

insert CPTransacciones 
(Ecodigo, CPTcodigo, CPTdescripcion,    CPTtipo, CPTvencim, CPTpago, BTid, CPTcktr, BMUsucodigo, CPTafectacostoventas, CPTnoflujoefe, FMT01COD, cuentac, CPTcodigoext, CPTestimacion, CPTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'NC',      'Nota Crédito',    'D',     0,         0,       null, null,    null,        0,                    0,             null,     null,    null,         0,             null

insert CPTransacciones 
(Ecodigo, CPTcodigo, CPTdescripcion,    CPTtipo, CPTvencim, CPTpago, BTid, CPTcktr, BMUsucodigo, CPTafectacostoventas, CPTnoflujoefe, FMT01COD, cuentac, CPTcodigoext, CPTestimacion, CPTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'AD',      'Ajuste Débito',   'C',     0,         0,       null, null,    null,        0,                    0,             null,     null,    null,         0,             null

insert CPTransacciones 
(Ecodigo, CPTcodigo, CPTdescripcion,    CPTtipo, CPTvencim, CPTpago, BTid, CPTcktr, BMUsucodigo, CPTafectacostoventas, CPTnoflujoefe, FMT01COD, cuentac, CPTcodigoext, CPTestimacion, CPTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'AC',      'Ajuste Crédito',  'D',     0,         0,       null, null,    null,        0,                    0,             null,     null,    null,         0,             null

insert CPTransacciones 
(Ecodigo, CPTcodigo, CPTdescripcion,          CPTtipo, CPTvencim, CPTpago, BTid,
 CPTcktr, BMUsucodigo, CPTafectacostoventas, CPTnoflujoefe, FMT01COD, cuentac, CPTcodigoext, CPTestimacion, CPTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'TP',      'Pago x Transferencia',  'D',     null,      1,       (select min(BTid) from BTransacciones where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and BTcodigo = 'TR'),
 'T',     null,       0,                     0,             null,     null,    null,         0,             null

insert CPTransacciones 
(Ecodigo, CPTcodigo, CPTdescripcion,          CPTtipo, CPTvencim, CPTpago, BTid,
 CPTcktr, BMUsucodigo, CPTafectacostoventas, CPTnoflujoefe, FMT01COD, cuentac, CPTcodigoext, CPTestimacion, CPTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'CP',      'Pago x Cheque',         'D',     null,      1,       (select min(BTid) from BTransacciones where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and BTcodigo = 'CH'),
 'C',     null,       0,                     0,             null,     null,    null,         0,             null

insert CPTransacciones
(Ecodigo, CPTcodigo, CPTdescripcion,    CPTtipo, CPTvencim, CPTpago, BTid, CPTcktr, BMUsucodigo, CPTafectacostoventas, CPTnoflujoefe, FMT01COD, cuentac, CPTcodigoext, CPTestimacion, CPTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'AN',      'Anticipo',        'D',     0,         0,       null, null,    null,        0,                    0,             null,     null,    null,         0,             null


</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta transacciones de CxC */
insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,     CCTtipo, CCTvencim, CCTpago, BTid, CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'FC',       'Factura Crédito', 'D',     0,         0,       null, null,    null,        0,             0,                    null,     null,         null,    0,            1,                0,             null

insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,     CCTtipo, CCTvencim, CCTpago, BTid, CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'FX',       'Factura Contado', 'D',     -1,        0,       null, null,    null,        0,             0,                    null,     null,         null,    0,            1,                0,             null

insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,     CCTtipo, CCTvencim, CCTpago, BTid, CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'ND',       'Nota Débito',     'D',     0,         0,       null, null,    null,        0,             0,                    null,     null,         null,    0,            4,                0,             null

insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,     CCTtipo, CCTvencim, CCTpago, BTid, CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'NC',       'Nota Crédito',    'C',     0,         0,       null, null,    null,        0,             0,                    null,     null,         null,    0,            5,                0,             null

insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,     CCTtipo, CCTvencim, CCTpago, BTid, CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'AD',       'Ajuste Débito',   'D',     0,         0,       null, null,    null,        0,             0,                    null,     null,         null,    0,            6,                0,             null

insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,     CCTtipo, CCTvencim, CCTpago, BTid, CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'AC',       'Ajuste Crédito',  'C',     0,         0,       null, null,    null,        0,             0,                    null,     null,         null,    0,            7,                0,             null

insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,           CCTtipo, CCTvencim, CCTpago, BTid,
 CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'RE',       'Pago x Transferencia',  'C',     0,         1,       (select min(BTid) from BTransacciones where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and BTcodigo = 'TR'),
 'T',     null,        0,             0,                    null,     null,         null,    0,            2,                0,             null

insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,           CCTtipo, CCTvencim, CCTpago, BTid,
 CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'RC',       'Pago x Cheque',         'C',     0,         1,       (select min(BTid) from BTransacciones where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and BTcodigo = 'CH'),
 'C',     null,        0,             0,                    null,     null,         null,    0,            2,                0,             null

insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,      CCTtipo, CCTvencim, CCTpago, BTid, CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'NT',       'Neteo CxC - CxP',  'C',     0,         0,       null, null,    null,        0,             0,                    null,     null,         null,    1,            5,                0,             null

insert CCTransacciones
(Ecodigo, CCTcodigo, CCTdescripcion,       CCTtipo, CCTvencim, CCTpago, BTid, CCTcktr, BMUsucodigo, CCTnoflujoefe, CCTafectacostoventas, FMT01COD, CCTcodigoext, cuentac, CCTtranneteo, CCTcolrpttranapl, CCTestimacion, CCTCodigoRef)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'IM',       'ND Interés moratorio', 'D',     0,         0,       null, null,    null,        0,             0,                    null,     null,         null,    0,            4,                0,             null
</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta Estado de Socio General */
insert EstadoSNegocios 
(Ecodigo, ESNcodigo, ESNdescripcion, ESNfacturacion)
values(
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     '0',         'Estado general', 1)
</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta Oficina General */
insert Oficinas 
(Ecodigo, Ocodigo, Oficodigo, Odescripcion)
values
( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,    0,       '000',     'Oficina Central')
</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta Conceptos Contables */
insert ConceptoContableE 
(Ecodigo, Cconcepto, Cdescripcion, Ctiponumeracion)
values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 0, 'Contabilidad', 0)

insert ConceptoContableE 
(Ecodigo, Cconcepto, Cdescripcion, Ctiponumeracion)
values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 1, 'Ingresos', 0)

insert ConceptoContableE 
(Ecodigo, Cconcepto, Cdescripcion, Ctiponumeracion)
values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 2, 'Egresos', 0)

insert ConceptoContableE 
(Ecodigo, Cconcepto, Cdescripcion, Ctiponumeracion)
values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 3, 'Bancos', 0)

insert ConceptoContableE 
(Ecodigo, Cconcepto, Cdescripcion, Ctiponumeracion)
values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 4, 'Tesorería', 0)

insert ConceptoContableE 
(Ecodigo, Cconcepto, Cdescripcion, Ctiponumeracion)
values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 5, 'Nómina', 0)

</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta Empleado General */
insert DatosEmpleado 
(Ecodigo, DEidentificacion, DEnombre, DEapellido1, DEapellido2, NTIcodigo, CBcc,          Mcodigo, DEcivil, DEfechanac, DEsexo)
values
(<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     '001',           'Empleado', 'General',  '.',         'C',       'CC212154984', 0,       0,       '20060101',   'M')
</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta Departamento General */
insert Departamentos 
(Ecodigo, Dcodigo, Deptocodigo, Ddescripcion)
values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 0, '0', 'Departamento General')
</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta CF General */
insert CFuncional 
(Ecodigo, CFcodigo, Dcodigo, Ocodigo, CFdescripcion, CFpath, CFnivel, CFcorporativo)
values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'RAIZ', 0, 0, 'Centro Funcional Raiz', 'RAIZ',  0,       0)
</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta origenes contables */
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AFAQ', 0, 'Adquisición de Activos Fijos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AFCC', 0, 'Cambio de Categoria Clase de Activos Fijos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AFDP', 0, 'Depreciación de Activos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AFMJ', 0, 'Mejoras de Activos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AFRE', 0, 'Revaluacion de Activos Fijos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AFRT', 1, 'Retiro de Activos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AFTA', 0, 'Transferencia de Responsables de Activos Fijos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'AFTR', 0, 'Traslado de Activos Fijos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CCAP', 1, 'Aplic. Documentos Favor CxC', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CCAR', 1, 'estimacion', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CCCM', 1, 'Cierre Mensual de CxC', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CCFC', 1, 'Documentos de CxC', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CCIM', 1, 'Interés Moratorio CxC', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CCND', 1, 'Neteo de Documentos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CCRC', 1, 'Reclasificación de Cuentas de CxC', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CCRE', 1, 'Pagos de CxC', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CCRH', 1, 'CCRH asientos de diario', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CGCM', 0, 'Cierre de Mes de Contabilidad', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CGDC', 1, 'Documentos de Contabilidad General', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CGDS', 0, 'Distribucion de Saldos Contables', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CGRC', 0, 'Contabilidad General Revaluación de Cuentas', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CPAP', 2, 'Aplic. Documentos Favor CxP', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CPCM', 2, 'Cierre Mensual de CxP', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CPFC', 2, 'Documentos de CxP', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'CPRE', 2, 'Pagos de CxP', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'ESBA', 3, 'Estimacion de Movimiento Bancario', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'FAFC', 1, 'Documentos de Facturación', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'INAJ', 0, 'Ajustes de Inventarios', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'INIA', 0, 'Movimientos InterAlmacén', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'INPR', 0, 'Produccion (Transformacion Producto)', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'INRP', 0, 'Recepcion de Productos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'INRQ', 0, 'Inventarios: Requisiciones', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'MBCM', 3, 'Cierre de Mes de Bancos', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'MBMV', 3, 'Movimientos Bancarios', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'MBTR', 3, 'Transferencias Bancarias', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'RHPN', 5, 'RH Pago de Nómina', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'TEAP', 4, 'Tesorería Anulación Orden de Pago', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'TEOP', 4, 'Tesorería Emisión Orden de Pago', 0, NULL ) 
INSERT INTO dbo.ConceptoContable ( Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, BMUsucodigo ) 
		 VALUES ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 'TETI', 4, 'Transferencias Intercompañía desde Tesoreria', 0, NULL ) 
</cfquery>
<cfquery datasource="#dsdst#">

/* Inserta Impuesto (empresa Agencia de Viajes de CR */
insert Impuestos 
(Ecodigo, Icodigo, Idescripcion,          Iporcentaje, Ccuenta,
Icompuesto, Icreditofiscal, Usucodigo, Ifecha)
select
 <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     '00',    'Exento de impuestos', 0.0,         (select min(Ccuenta) from CContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Cformato = '2000-01-0004'),
0,          0,              1, '19000101'
</cfquery>
</cffunction>
</cfcomponent>