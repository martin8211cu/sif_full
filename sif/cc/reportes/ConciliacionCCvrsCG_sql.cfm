<cfif isdefined("url.formatos") and not isdefined("form.formatos")>
	<cfset form.formatos = url.formatos>
</cfif>

<cfif isdefined("url.anio") and not isdefined("form.anio")>
	<cfset form.anio = url.anio>
</cfif>

<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfset form.mes = url.mes>
</cfif>

<cfparam name="form.anio" default="2007" type="integer">
<cfparam name="form.mes" default="1" type="integer">

<!---  
	1. Se deben solicitar las cuentas que se van a utilizar en el proceso de conciliacion
	2. Se asumen TODAS las oficinas
	3. El saldo contable es tomado de las cuentas contables solicitadas
	4. El saldo del auxiliar es tomado de la tabla SNSaldosIniciales
	5. NO se deben considerar aplicaciones realizadas a documentos en el auxiliar, 
		pues afectan las cuentas tanto al débito como al crédito.
		Se presentan en la contabilidad.

Esto se hace en el parche.
Tabla de Cuentas a considerar en el reporte (Cuentas Contables)
create table CuentasConciliacion
	(
	Ecodigo   int,       --- Empresa
	Ccuenta   numeric,   --- Cuenta
	Mcodigo   char(2),   --- Módulo
	constraint PK_CuentasConciliacionprimary key (Ecodigo, Ccuenta)
	)


Esto se hace en el parche.
Insertar las cuentas de los documentos del histórico como cuentas para la referencia inicial
<cfquery datasource="#session.DSN#">
	insert into CuentasConciliacion(Ecodigo, Ccuenta, Mcodigo)
	select distinct Ecodigo, Ccuenta, 'CC'
	from HDocumentos
	where Ccuenta is not null
</cfquery> 
--->


<!--- 
	Origenes de Contabilidad:

	PV				**** Punto de Venta
	CCAP			**** Cuentas por Cobrar.  Aplicación
	CCFC			**** Cuentas por Cobrar.  Facturas y Notas de Credito
	CCRE			**** Cuentas por Cobrar.  Recibos o Pagos


Otros:
	[null]
	CGDC
	CPAP
	CPFC
	INRQ
	MBMV
	TEOP


Columnas:
	Saldo Anterior de Auxiliar
	Debitos Auxiliar
	Creditos Auxiliar
	Pagos Auxiliar
	Saldo Anterior de Contabilidad
	Debitos Aplicados   Auxiliar CxC
	Debitos Aplicados   Punto Venta
	Debitos Aplicados   por Aplicacion desde CxC
	Creditos Aplicados 	Auxiliar CxC
	Creditos Aplicados  Punto Venta
	Creditos Aplicados  por Aplicacion desde CxC
	Creditos Aplicados  Pagos

	Debitos  no Aplicados CG
	Creditos no Aplicados CG
 --->

<cf_dbtemp name="fechas" returnvariable="fechas" datasource="#session.dsn#">
	<cf_dbtempcol name="Fecha"  type="datetime"	mandatory="no">
</cf_dbtemp>


<cf_dbtemp name="MovCxC01" returnvariable="movimientos" datasource="#session.dsn#">
	<cf_dbtempcol name="Ecodigo"  			type="integer"		mandatory="no">
	<cf_dbtempcol name="Fecha"  			type="datetime"		mandatory="no">
	<cf_dbtempcol name="Anio"	  			type="integer"		mandatory="no">
	<cf_dbtempcol name="Mes"  				type="integer"		mandatory="no">
	
	<cf_dbtempcol name="SaldoAnteriorAux"	type="money"		mandatory="no">
	<cf_dbtempcol name="DebitosAux"  		type="money"		mandatory="no">
	<cf_dbtempcol name="CreditosAux"  		type="money"		mandatory="no">
	<cf_dbtempcol name="PagosAux"  			type="money"		mandatory="no">
	
	<cf_dbtempcol name="SaldoAnteriorCG"  	type="money"		mandatory="no">

	<cf_dbtempcol name="DebitosApCxC"  		type="money"		mandatory="no">
	<cf_dbtempcol name="DebitosApPos"  		type="money"		mandatory="no">
	<cf_dbtempcol name="DebitosApApCxC"  	type="money"		mandatory="no">
	
	<cf_dbtempcol name="CreditosApCxC"  	type="money"		mandatory="no">
	<cf_dbtempcol name="CreditosApPos"  	type="money"		mandatory="no">
	<cf_dbtempcol name="CreditosApApCxC"  	type="money"		mandatory="no">
	
	<cf_dbtempcol name="DebitosApPagos"  	type="money"		mandatory="no">
	<cf_dbtempcol name="CreditosApPagos"  	type="money"		mandatory="no">
	<cf_dbtempcol name="DebitosApOtros"  	type="money"		mandatory="no">
	<cf_dbtempcol name="CreditosApOtros"  	type="money"		mandatory="no">
	<cf_dbtempcol name="DebitosNaCG"  		type="money"		mandatory="no">
	<cf_dbtempcol name="CreditosNaCG"  		type="money"		mandatory="no">
	<cf_dbtempcol name="SaldoNuevoAux"  	type="money"		mandatory="no">
	<cf_dbtempcol name="SaldoNuevoCG"  		type="money"		mandatory="no">
</cf_dbtemp>


<cf_dbtemp name="CuentasConc" returnvariable="cuentas" datasource="#session.dsn#">
	<cf_dbtempcol name="Ccuenta"  			type="numeric"		mandatory="no">
	<cf_dbtempcol name="Periodo"  			type="integer"		mandatory="no">
	<cf_dbtempcol name="Mes"	  			type="integer"		mandatory="no">
	<cf_dbtempcol name="Ecodigo"  			type="integer"		mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="SociosConc" returnvariable="socios" datasource="#session.dsn#">
	<cf_dbtempcol name="SNid"  				type="numeric"		mandatory="no">
	<cf_dbtempcol name="SNcodigo"  			type="integer"		mandatory="no">
	<cf_dbtempcol name="id_direccion" 		type="numeric"		mandatory="no">
	<cf_dbtempcol name="Periodo"	  		type="integer"		mandatory="no">
	<cf_dbtempcol name="Mes"	  			type="integer"		mandatory="no">
	<cf_dbtempcol name="Ecodigo"  			type="integer"		mandatory="no">
</cf_dbtemp>


<cfset salidaparcial = 0>

<!--- 
	Insertar en una tabla temporal TODAS las cuentas contables que deben considerarse.
	Se hace en una temporal para que use los indices correctos, porque con constantes no le agrada
 --->

<cfquery datasource="#session.DSN#">
	insert into #cuentas# (Ccuenta, Periodo, Mes, Ecodigo)
	select Ccuenta, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anio#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">, Ecodigo
	from CCCuentasConciliacionUsr
	where Usucodigo = #session.Usucodigo#
	  and Ecodigo = #session.Ecodigo#
</cfquery>

<!--- 
	Insertar en una tabla temporal TODAS los socios que deben considerarse.
	Se hace en una temporal para que use los indices correctos, porque con constantes no le agrada
 --->

<cfquery datasource="#session.DSN#">
	insert into #socios# (SNid, SNcodigo, id_direccion, Periodo, Mes, Ecodigo)
	select 
		snd.SNid, 
		s.SNcodigo, 
		snd.id_direccion, 
		#form.anio#, 
		#form.mes#, 
		cl.Ecodigo
	from CCClasificConciliacionUsr cl
		inner join SNClasificacionSND cs
			inner join SNDirecciones snd
			on  snd.SNid         = cs.SNid
			and snd.id_direccion = cs.id_direccion
		on cs.SNCDid = cl.SNCDid

		inner join SNegocios s
		on s.SNid = snd.SNid
		<!--- and s.Ecodigo = cl.Ecodigo --->

	where cl.Usucodigo = #session.Usucodigo#
	  and cl.Ecodigo   = #session.Ecodigo#
	  and s.Ecodigo    = #session.Ecodigo#
</cfquery>


<!---  
	Insertar TODAS las cuentas y Oficinas que se procesaron con documentos en ese mes
	Las oficinas y las cuentas están en la tabla BMovimientos
 --->
<cfset fechai = CreateDate(#form.anio#,#form.mes#,1)>

<cfset Lvarfecha = fechai>
<cfquery datasource="#session.DSN#">
	insert into #movimientos# (
		Ecodigo,
		Fecha,
		Anio,
		Mes,
		SaldoAnteriorAux, 
	
		DebitosAux 		, 
		CreditosAux 	,
		PagosAux		,
	
		SaldoAnteriorCG,
	
		DebitosApCxC 	,
		DebitosApPos	,
		DebitosApApCxC	,
		DebitosApOtros	,
		DebitosApPagos  ,
		
		CreditosApCxC	,
		CreditosApPos	,
		CreditosApApCxC	,
		CreditosApPagos	,
		CreditosApOtros	,
	
		DebitosNaCG 	,
		CreditosNaCG	,
	
		SaldoNuevoAux   ,
		SaldoNuevoCG
	
		)
	select 
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		<cf_dbfunction name="dateadd" args="-1, #fechai#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.anio#">,	
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">,	
		0.00,
	
		0.00,			
		0.00,
		0.00,
	
		0.00,			
	
		0.00,			
		0.00,			
		0.00,
		0.00,
		0.00,
	
		0.00,			
		0.00,			
		0.00,
		0.00,			
		0.00,
	
		0.00,			
		0.00,
	
		0.00,
		0.00
	from dual
</cfquery>


<!---  Actualizar el saldo inicial de Auxiliar  --->
<cfquery datasource="#session.DSN#">
update #movimientos#
set SaldoNuevoAux = 
	coalesce((
		select sum(si.SIsaldoinicial)
		from  #socios# s
			inner join SNSaldosIniciales si
			on  si.SNid         = s.SNid
			and si.id_direccion = s.id_direccion
			and si.Speriodo     = s.Periodo
			and si.Smes         = s.Mes
			
		where s.Ecodigo  = #session.Ecodigo#
		  and s.Periodo = #form.anio#
		  and s.Mes     = #form.mes#
	) , 0.00)
</cfquery>

<cfquery datasource="#session.DSN#">
update #movimientos#
set SaldoNuevoCG = 
	coalesce((
		select sum(SLinicial)
		from #cuentas# cc
			inner join SaldosContables s
				 on s.Ccuenta  = cc.Ccuenta
				and s.Speriodo = cc.Periodo
				and s.Smes     = cc.Mes
	) , 0.00)
</cfquery>

<cfquery datasource="#session.DSN#">
	update #movimientos#
	set SaldoAnteriorAux = SaldoNuevoAux, 
	SaldoAnteriorCG = SaldoNuevoCG
</cfquery>


<!--- Insertar un registro por cada día del mes en que se genera el reporte  --->
<cfset Lvarfecha = createdate(#form.anio#, form.mes,1)>

<cfloop condition="datepart('m', Lvarfecha) eq form.mes">
	<cfquery datasource="#session.DSN#">
		insert into #fechas# (Fecha) 
		values(
		#Lvarfecha#
		)
	</cfquery>
	<cfset Lvarfecha = dateadd('d', 1, Lvarfecha)>
</cfloop>

<cfquery datasource="#session.DSN#">
	insert into #movimientos# (
		Ecodigo,
		Fecha,
		Anio,
		Mes,
	
		SaldoAnteriorAux, 
	
		DebitosAux 		, 
		CreditosAux 	,
		PagosAux		,
	
		SaldoAnteriorCG,
	
		DebitosApCxC 	,
		DebitosApPos	,
		DebitosApApCxC	,
		DebitosApOtros	,
		DebitosApPagos  ,
		
		CreditosApCxC	,
		CreditosApPos	,
		CreditosApApCxC	,
		CreditosApPagos	,
		CreditosApOtros	,
	
		DebitosNaCG 	,
		CreditosNaCG	,
	
		SaldoNuevoAux   , 
		SaldoNuevoCG
		)
	select 
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		Fecha,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.anio#">,	
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">,
	
		0.00,
	
		0.00,			
		0.00,
		0.00,
	
		0.00,			
	
		0.00,			
		0.00,			
		0.00,
		0.00,
		0.00,
	
		0.00,			
		0.00,			
		0.00,
		0.00,			
		0.00, 
	
		0.00,			
		0.00,
	
		0.00,
		0.00
	from #fechas#
</cfquery>

<!---  Actualizar los Debitos Aplicados en el Auxiliar  --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set DebitosAux = coalesce((
		select sum(doc.Dtotal) 
              from HDocumentos doc
                  inner join CCTransacciones t 
                   on t.Ecodigo     = doc.Ecodigo 
                  and t.CCTcodigo   = doc.CCTcodigo 
                  and t.CCTtipo     = 'D'
			 inner join #Socios# st  
			   on doc.SNcodigo          = st.SNcodigo 
			  and doc.Ecodigo           = st.Ecodigo 
			  and doc.id_direccionFact  = st.id_direccion 
		where doc.Dfecha = #movimientos#.Fecha 
		  ) , 0.00) 
	where Fecha >= #fechai#
</cfquery>

<cfquery datasource="#session.DSN#">
	update #movimientos#
	set DebitosAux = DebitosAux + coalesce((
		select sum(bm.Dtotal)
		from #socios# st
			inner join BMovimientos bm

				inner join CCTransacciones t
				on t.CCTcodigo = bm.CCTRcodigo
				and t.Ecodigo = bm.Ecodigo
				and t.CCTtipo = 'D'
				and t.CCTpago = 0
				and t.CCTcodigo in ('PC', 'PT')
	
				inner join CCTransacciones t2
				on t2.CCTcodigo = bm.CCTcodigo
				and t2.Ecodigo = bm.Ecodigo
				and t2.CCTtipo = 'C'
	
			on bm.Ecodigo = st.Ecodigo
			and bm.SNcodigo = st.SNcodigo
			and bm.CCTcodigo <> bm.CCTRcodigo		<!--- Solo para transacciones hechas sobre documentos.  Elimino construcción de doctos--->

			inner join HDocumentos hd
			on hd.CCTcodigo = bm.CCTcodigo
			and hd.Ddocumento = bm.Ddocumento
			and hd.Ecodigo = bm.Ecodigo
			and hd.SNcodigo = bm.SNcodigo
			and hd.id_direccionFact = st.id_direccion
		where bm.Dfecha = #movimientos#.Fecha
		) , 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- Actualizar los Creditos Aplicados en el Auxiliar. No incluir los generados por pagos que generaron créditos --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set CreditosAux = coalesce((
		select sum(doc.Dtotal)
		from #socios# st
			inner join HDocumentos doc

				inner join CCTransacciones t
					on t.Ecodigo   = doc.Ecodigo
				   and t.CCTcodigo = doc.CCTcodigo
				   and t.CCTtipo   = 'C'

				inner join BMovimientos bm
				on bm.Ecodigo		 = doc.Ecodigo
				and bm.CCTcodigo     = doc.CCTcodigo
				and bm.Ddocumento    = doc.Ddocumento
				and bm.Dfecha		 = doc.Dfecha
				and bm.CCTRcodigo	 = doc.CCTcodigo
				and bm.DRdocumento   = doc.Ddocumento
				
			 on doc.SNcodigo         = st.SNcodigo
			and doc.Ecodigo          = st.Ecodigo
			and doc.id_direccionFact = st.id_direccion
		 where doc.Dfecha            = #movimientos#.Fecha
		) , 0.00)
	where Fecha >= #fechai#
</cfquery>

<!---
	Actualizar los Pagos Aplicados en el Auxiliar 
	1.  Pagos efectuados a documentos de Debito 
--->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set PagosAux = coalesce((
		select sum(bm.Dtotalloc)
		from BMovimientos bm
			inner join CCTransacciones t
				on t.Ecodigo   = bm.Ecodigo
			   and t.CCTcodigo = bm.CCTcodigo
			   and t.CCTtipo   = 'C'
			   and t.CCTpago   = 1
			inner join CCTransacciones t2
				on t2.Ecodigo  = bm.Ecodigo
			   and t2.CCTcodigo = bm.CCTRcodigo
			   and t2.CCTtipo   = 'D'

			inner join HDocumentos doc
				inner join #socios# s
				on s.SNcodigo      = doc.SNcodigo
				and s.id_direccion = doc.id_direccionFact
			on  doc.CCTcodigo  = bm.CCTRcodigo
			and doc.Ddocumento = bm.DRdocumento
			and doc.Ecodigo    = bm.Ecodigo
			and doc.SNcodigo   = bm.SNcodigo

		where bm.Ecodigo    = #session.Ecodigo#
		  and bm.BMperiodo  = #form.anio#
		  and bm.BMmes      = #form.mes#
		  and (bm.CCTcodigo  <> bm.CCTRcodigo or bm.Ddocumento <> bm.DRdocumento)
		  and bm.Dfecha     = #movimientos#.Fecha 
		) , 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- 
	Actualizar los Pagos Aplicados en el Auxiliar 
	2.  Pagos efectuados que Generaron documentos de Credito 
 --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set PagosAux = PagosAux + coalesce((
		select sum(bm.Dtotalloc)
		from BMovimientos bm
			inner join CCTransacciones t
			on t.Ecodigo   = bm.Ecodigo
		   and t.CCTcodigo = bm.CCTcodigo
		   and t.CCTtipo   = 'C'

			inner join CCTransacciones t2
			on t2.Ecodigo  = bm.Ecodigo
			and t2.CCTcodigo = bm.CCTRcodigo
			and t2.CCTtipo   = 'C'
			and t2.CCTpago   = 1

			inner join HDocumentos doc
					inner join #socios# s
					on s.SNcodigo      = doc.SNcodigo
					and s.Ecodigo      = doc.Ecodigo
					and s.id_direccion = doc.id_direccionFact
			on doc.Ecodigo     = bm.Ecodigo
			and doc.CCTcodigo  = bm.CCTcodigo
			and doc.Ddocumento = bm.Ddocumento

		where bm.Ecodigo    = #session.Ecodigo#
		  and bm.BMperiodo  = #form.anio#
		  and bm.BMmes      = #form.mes#
		  and (bm.CCTcodigo  <> bm.CCTRcodigo or bm.Ddocumento <> bm.DRdocumento)
		  and bm.Dfecha     = #movimientos#.Fecha 
		) , 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- 
	   ----------------------------------------------
	   Cálculo de Movimientos de Contabilidad General 
	   ----------------------------------------------
 --->
 
<!--- Débitos Aplicados desde el Auxiliar CxC:  DebitosApCxC --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set DebitosApCxC= coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo = #session.Ecodigo#
		  and ec.Efecha     = #movimientos#.Fecha
		  and dc.Dmovimiento = 'D'
		  and ec.Oorigen    = 'CCFC'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- Créditos Aplicados desde el Auxiliar CxC:  CreditosApCxC --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set CreditosApCxC= coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo = #session.Ecodigo#
		  and ec.Efecha     = #movimientos#.Fecha
		  and dc.Dmovimiento = 'C'
		  and ec.Oorigen    = 'CCFC'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>


<!--- Debitos Aplicados   desde el Auxiliar POS:  DebitosApPos --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set DebitosApPos= coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo = #session.Ecodigo#
		  and ec.Efecha     = #movimientos#.Fecha
		  and dc.Dmovimiento = 'D'
		  and ec.Oorigen    = 'PV'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- Creditos Aplicados   desde el Auxiliar POS:  CreditosApPos --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set CreditosApPos = coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo     = #session.Ecodigo#
		  and ec.Efecha      = #movimientos#.Fecha
		  and dc.Dmovimiento = 'C'
		  and ec.Oorigen    = 'PV'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- Debitos Aplicaciones   Auxiliar CxC:  DebitosApApCxC --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set DebitosApApCxC = coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo     = #session.Ecodigo#
		  and ec.Efecha      = #movimientos#.Fecha
		  and dc.Dmovimiento = 'D'
		  and ec.Oorigen     = 'CCAP'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- Creditos Aplicaciones   Auxiliar CxC:  CreditosApApCxC --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set CreditosApApCxC = coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo     = #session.Ecodigo#
		  and ec.Efecha      = #movimientos#.Fecha
		  and dc.Dmovimiento = 'C'
		  and ec.Oorigen    = 'CCAP'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- Debitos Otros Asientos en CG:  DebitosApOtros --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set DebitosApOtros = coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo     = #session.Ecodigo#
		  and ec.Efecha      = #movimientos#.Fecha
		  and dc.Dmovimiento = 'D'
		  and ec.Oorigen    not in ('CCAP', 'PV', 'CCFC', 'CCRE')
		), 0.00)
	where Fecha >= #fechai#
</cfquery>


<!--- Creditos Otros Asientos en CG: CreditosApOtros --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set CreditosApOtros = coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo     = #session.Ecodigo#
		  and ec.Efecha      = #movimientos#.Fecha
		  and dc.Dmovimiento = 'C'
		  and ec.Oorigen    not in ('CCAP', 'PV', 'CCFC', 'CCRE')
		), 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- Debitos No Aplicados CG --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set DebitosNaCG = coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join DContables dc
					inner join EContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo     = #session.Ecodigo#
		  and ec.Efecha      = #movimientos#.Fecha
		  and dc.Dmovimiento = 'D'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- Creditos No Aplicados CG --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set DebitosNaCG = coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join DContables dc
					inner join EContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo     = #session.Ecodigo#
		  and ec.Efecha      = #movimientos#.Fecha
		  and dc.Dmovimiento = 'C'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>

<!--- Debitos Aplicados   desde el Auxiliar CxC por Pagos:  DebitosApPagos --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set DebitosApPagos= coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo     = #session.Ecodigo#
		  and ec.Efecha      = #movimientos#.Fecha
		  and dc.Dmovimiento = 'D'
		  and ec.Oorigen    = 'CCRE'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>


<!--- Creditos Aplicados   desde el Auxiliar CxC por Pagos:  CreditosApPagos --->
<cfquery datasource="#session.DSN#">
	update #movimientos#
	set CreditosApPagos= coalesce((
		select sum(Dlocal)
		from #cuentas# cc
			inner join HDContables dc
					inner join HEContables ec
						on ec.IDcontable = dc.IDcontable
				 on dc.Ccuenta = cc.Ccuenta
				and dc.Eperiodo = cc.Periodo
				and dc.Emes     = cc.Mes
		where cc.Ecodigo     = #session.Ecodigo#
		  and ec.Efecha      = #movimientos#.Fecha
		  and dc.Dmovimiento = 'C'
		  and ec.Oorigen    = 'CCRE'
		), 0.00)
	where Fecha >= #fechai#
</cfquery>

<!---
	---------------------------------------------------------
	Actualizar los saldos anteriores de la tabla temporal 
	---------------------------------------------------------
 --->

<cfset LvarFecha = fechai>
<cfset LvarFechaAnterior = dateadd('d', -1, LvarFecha)>

<cfloop condition="datepart('m', LvarFecha) eq form.mes">
	<cfquery datasource="#session.DSN#">
		update #movimientos#
			set 
				SaldoAnteriorCG = 
					coalesce((
						select sum(SaldoNuevoCG)
						from #movimientos# b
						where b.Fecha   = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaAnterior#">
					), 0.00),
				SaldoAnteriorAux = 
					coalesce((
						select sum(SaldoNuevoAux)
						from #movimientos# b
						where b.Fecha   = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaAnterior#">
					), 0.00)
		where Fecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Lvarfecha#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #movimientos#
			set
				SaldoNuevoCG = 
					SaldoAnteriorCG 
						+ DebitosApCxC 	+ DebitosApPos	+ 	DebitosApApCxC	+ DebitosApOtros  + DebitosApPagos
						- CreditosApCxC	- CreditosApPos	- 	CreditosApApCxC	- CreditosApOtros - CreditosApPagos	
						+ DebitosNaCG 	- CreditosNaCG	
				,
				SaldoNuevoAux = 
					SaldoAnteriorAux + DebitosAux - CreditosAux - PagosAux
		where Fecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Lvarfecha#">
	</cfquery>
	<cfset LvarFechaAnterior = LvarFecha>
	<cfset Lvarfecha = dateadd('d', 1, LvarFecha)>
</cfloop>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		Fecha as Fecha_Reporte,
		m.SaldoAnteriorAux as Saldo_Auxiliar_Anterior,
		m.DebitosAux       as Debitos_Auxiliar,
		m.CreditosAux      as Creditos_Auxiliar,
		m.PagosAux		   as Pagos_Auxiliar,
	
		m.SaldoNuevoAux    as Saldo_Auxiliar,

		(m.SaldoNuevoAux - m.SaldoAnteriorAux) as Movimiento_Auxiliar,
	
		m.SaldoAnteriorCG  as Saldo_Contabilidad_Anterior,
	
		m.DebitosApCxC     as Debitos_CxC,
		m.CreditosApCxC	   as Creditos_CxC,
	
		m.DebitosApPagos   as Debitos_Pagos_CxC,
		m.CreditosApPagos  as Creditos_Pagos_CxC,
	
		m.DebitosApPos	   as Debitos_POS,
		m.CreditosApPos    as Creditos_POS,
	
		m.DebitosApApCxC   as Debitos_Aplicaciones,
		m.CreditosApApCxC  as Creditos_Aplicaciones,
	
		m.DebitosApOtros   as Debitos_Otros,
		m.CreditosApOtros  as Creditos_Otros,
	
		m.DebitosNaCG      as Debitos_NoAplicados,
		m.CreditosNaCG     as Creditos_NoAplicados,
	
		m.SaldoNuevoCG     as Saldo_Contabilidad,
	
		(m.SaldoNuevoCG - m.SaldoAnteriorCG) as Movimiento_Contable,
	
		m.SaldoNuevoAux - m.SaldoNuevoCG as Diferencia,
		(m.SaldoNuevoAux - m.SaldoAnteriorAux) - (m.SaldoNuevoCG - m.SaldoAnteriorCG) as Diferencia_Dia
	
	from #movimientos# m
	order by m.Fecha
</cfquery>

<cfif form.formatos EQ 1>
	<!--- Cuentas seleccionadas para calcular los datos contables 	--->
	<cfquery name="rsCuentasContables" datasource="#session.DSN#">
		select 
			substring(c.Cformato, 1, 30) as Cuenta, 
			c.Cdescripcion as Nombre,
			coalesce(sum(s.SLinicial) , 0.00) as SaldoInicial,
			coalesce(sum(s.DLdebitos) , 0.00) as Debitos,
			coalesce(sum(s.CLcreditos), 0.00) as Creditos,
			coalesce(sum(s.SLinicial + s.DLdebitos - s.CLcreditos), 0.00) as SaldoFinal
		from #cuentas# cc
			inner join CContables c
				on c.Ccuenta = cc.Ccuenta
			left outer join SaldosContables s
				on s.Ccuenta = c.Ccuenta
				and s.Speriodo = #form.anio#
				and s.Smes     = #form.mes#
				
		group by substring(c.Cformato, 1, 30), c.Cdescripcion
		order by 1
	</cfquery>
</cfif>

<cfif form.formatos EQ 2>
	<cf_QueryToFile query="#rsReporte#" filename="ConciliacionCCvrsCG.xls" jdbc="false">
</cfif>

<cfif form.formatos EQ 1>
	<cf_htmlReportsHeaders 
		title="Consolidado Contable" 
		filename="ConsolidadoContable.xls"
		irA="ConciliacionCCvrsCG_form.cfm?anio=#form.anio#&mes=#form.mes#&formatos=1">
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<style type="text/css">
	.niv1 { font-size: 18px; font-family:Verdana, Arial, Helvetica, sans-serif; }
	.niv2 { font-size: 16px; font-family:Verdana, Arial, Helvetica, sans-serif; }
	.niv4 { font-size: 9px; font-family:Verdana, Arial, Helvetica, sans-serif; }
	</style>
	
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 0>
	  <table width="100%" cellpadding="2" cellspacing="0" border="0">

		<tr style="font-weight:bold">
			<td colspan="8" class="niv4" align="left">Fecha:&nbsp;<cfoutput>#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="8" class="niv4" align="right">Usuario:&nbsp;<cfoutput>#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr style="font-weight:bold">
			<td colspan="16" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td colspan="16" align="center" class="niv2">Reporte Consolidado Contable</td>
		</tr>
		<tr>
			<td colspan="16">&nbsp;</td>
		</tr>  
		<tr style="font-weight:bold">
		  <td nowrap="nowrap" class="niv4">&nbsp;</td>
		  <td colspan="5" align="center" nowrap="nowrap" bordercolor="#333333" bgcolor="#E1E1E1"  style="border:thin">AUXILIAR</td>
		  <td colspan="9" align="center" nowrap="nowrap" bordercolor="#333333" bgcolor="#CCCCCC" style="border:thin">CONTABILIDAD</td>
		  <td nowrap="nowrap" class="niv4" colspan="1">&nbsp;</td>
		</tr>
		<tr style="font-weight:bold; width:1%">
		  <td nowrap="nowrap" class="niv4">Fecha</td>
		  <!--- <td nowrap="nowrap" align="right" class="niv4">Anterior</td> --->
		  <td align="right" nowrap="nowrap" bgcolor="#CCFFCC" class="niv4">D&eacute;bitos </td>
		  <td align="right" nowrap="nowrap" bgcolor="#CCFFCC" class="niv4">Cr&eacute;ditos</td>
		  <td align="right" nowrap="nowrap" bgcolor="#CCFFCC" class="niv4">Pagos</td>
		  <td align="right" nowrap="nowrap" bgcolor="#CCFFCC" class="niv4">Saldo</td>
		  <td align="right" nowrap="nowrap" bgcolor="#CCFFCC" class="niv4">Movimiento</td>
		  
		  <!--- <td nowrap="nowrap" align="right" class="niv4">Anterior</td> --->
		  <td nowrap="nowrap" align="right" class="niv4">D&eacute;bitos</td>
		  <td nowrap="nowrap" align="right" class="niv4">Cr&eacute;ditos</td>
		  <td nowrap="nowrap" align="right" class="niv4">Pagos</td>
		  <td nowrap="nowrap" align="right" class="niv4">D&eacute;bitos <br>POS</td>
		  <td nowrap="nowrap" align="right" class="niv4">Cr&eacute;ditos <br>POS</td>
		  <td nowrap="nowrap" align="right" class="niv4">Aplicaciones</td>
		  <td nowrap="nowrap" align="right" class="niv4">Otros<br>Movimiento</td>
		  <!--- <td nowrap="nowrap" align="right" class="niv4">No Aplicados</td> --->
		  <td nowrap="nowrap" align="right" class="niv4">Saldo</td>
		  <td nowrap="nowrap" align="right" class="niv4">Movimiento</td>
		  <cfif isdefined("form.LvarTipoDiferencia")>
			<td nowrap="nowrap" align="right" class="niv4">Dif. Acum</td>
		  <cfelse>
		    <td nowrap="nowrap" align="right" class="niv4">Dif. Día</td>
		  </cfif> 
		  
		</tr>
		<cfset CurrentRow = 1>
		<cfset LvarMovimientosNoAplicados = false>
		<cfoutput query="rsReporte">
			<cfset LvarListaNon = (CurrentRow MOD 2)>
			<cfset LvarDifDia = rsReporte.Diferencia_Dia>
			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
			  <td class="niv4">#dateformat(Fecha_Reporte, 'dd/mm')#</td>
			  <!--- <td align="right" class="niv4">#NumberFormat(Saldo_Auxiliar_Anterior,'_,_.__')#</td> --->
			  <cfif CurrentRow EQ 1>
				  <td align="right" bgcolor="##CCFFCC" class="niv4">&nbsp;</td>
				  <td align="right" bgcolor="##CCFFCC" class="niv4">&nbsp;</td>
				  <td align="right" bgcolor="##CCFFCC" class="niv4">&nbsp;</td>
			  <cfelse>
				  <td align="right" nowrap="nowrap"  bgcolor="##CCFFCC" class="niv4">#NumberFormat(Debitos_Auxiliar,'_,_.__')#</td>
				  <td align="right" nowrap="nowrap"  bgcolor="##CCFFCC" class="niv4">#NumberFormat(Creditos_Auxiliar,'_,_.__')#</td>
				  <td align="right" nowrap="nowrap"  bgcolor="##CCFFCC" class="niv4">#NumberFormat(Pagos_Auxiliar,'_,_.__')#</td>
			  </cfif>
			  <td align="right" nowrap="nowrap" bgcolor="##CCFFCC" class="niv4">#NumberFormat(Saldo_Auxiliar,'_,_.__')#</td>
			  <td align="right" nowrap="nowrap" bgcolor="##CCFFCC" class="niv4">#NumberFormat(Movimiento_Auxiliar,'_,_.__')#</td>
			  <!--- <td align="right" class="niv4">#NumberFormat(Saldo_Contabilidad_Anterior,'_,_.__')#</td> --->
			  <cfif CurrentRow EQ 1>
				  <td align="right" class="niv4">&nbsp;</td>
				  <td align="right" class="niv4">&nbsp;</td>
				  <td align="right" class="niv4">&nbsp;</td>
				  <td align="right" class="niv4">&nbsp;</td>
				  <td align="right" class="niv4">&nbsp;</td>
				  <td align="right" class="niv4">&nbsp;</td>
				  <td align="right" class="niv4">&nbsp;</td>
			  <cfelse>
				  <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(Debitos_CxC,'_,_.__')#</td>
				  <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(Creditos_CxC,'_,_.__')#</td>
				  <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(Creditos_Pagos_CxC - Debitos_Pagos_CxC,'_,_.__')#</td>
				  <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(Debitos_POS,'_,_.__')#</td>
				  <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(Creditos_POS,'_,_.__')#</td>
				  <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(rsReporte.Debitos_Aplicaciones - rsReporte.Creditos_Aplicaciones,'_,_.__')#</td>
				  <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(rsReporte.Debitos_Otros - rsReporte.Creditos_Otros,'_,_.__')#</td>
			  </cfif>
			  <!--- <td align="right" class="niv4">#NumberFormat(rsReporte.Debitos_NoAplicados - rsReporte.Creditos_NoAplicados,'_,_.__')#</td> --->
			  <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(Saldo_Contabilidad,'_,_.__')#</td>
			  <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(Movimiento_Contable,'_,_.__')#</td>
			  <cfif isdefined("form.LvarTipoDiferencia")>
			  	<td align="right" nowrap="nowrap" class="niv4">#NumberFormat(Diferencia,'_,_.__')#</td>
			  <cfelse>
			    <td align="right" nowrap="nowrap" class="niv4">#NumberFormat(LvarDifDia,'_,_.__')#</td>
			  </cfif>
			</tr>
			<cfset CurrentRow = CurrentRow + 1>
			<cfif Debitos_NoAplicados NEQ 0 or Creditos_NoAplicados NEQ 0>
				<cfset LvarMovimientosNoAplicados = true>
			</cfif>
		</cfoutput>
		<cfif LvarMovimientosNoAplicados>
			<tr>
				<td colspan="16" align="center" class="niv1">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="16" align="center" class="niv1">Existen Movimientos SIN APLICAR en el modulo Contable!</td>
			</tr>
			<tr>
				<td colspan="16" align="center" class="niv1">&nbsp;</td>
			</tr>
		</cfif>
		<tr>
			<td colspan="16" align="center" class="niv4">------------------------------------------- Fin del Reporte -------------------------------------------			</td>
		</tr>
		<tr>
			<td colspan="16">&nbsp;</td>
		</tr>
		<tr style="font-weight:bold">
			<td colspan="3" nowrap="nowrap" bgcolor="#E1E1E1" class="niv4">Cuenta</td>
			<td colspan="5" nowrap="nowrap" bgcolor="#E1E1E1" class="niv4">Descripcion</td>
			<td colspan="2" align="right" nowrap="nowrap" bgcolor="#E1E1E1" class="niv4">Inicial</td>
			<td colspan="2" align="right" nowrap="nowrap" bgcolor="#E1E1E1" class="niv4">Debitos</td>
			<td colspan="2" align="right" nowrap="nowrap" bgcolor="#E1E1E1" class="niv4">Creditos</td>
			<td colspan="2" align="right" nowrap="nowrap" bgcolor="#E1E1E1" class="niv4">Final</td>
		</tr>
		<cfoutput query="rsCuentasContables">
			<tr>
				<td colspan="3" class="niv4">#rsCuentasContables.Cuenta#</td>
				<td colspan="5" class="niv4">#left(rsCuentasContables.Nombre,35)#</td>
				<td colspan="2" align="right" class="niv4">#numberformat(rsCuentasContables.SaldoInicial,",9.00")#</td>
				<td colspan="2" align="right" class="niv4">#numberformat(rsCuentasContables.Debitos,",9.00")#</td>
				<td colspan="2" align="right" class="niv4">#numberformat(rsCuentasContables.Creditos,",9.00")#</td>
				<td colspan="2" align="right" class="niv4">#numberformat(rsCuentasContables.SaldoFinal,",9.00")#</td>
			</tr>
		</cfoutput>
		</table>
	<cfelse>
		<div align="center"> ------------------------------------------- No se encontraron registros -------------------------------------------</div>
	</cfif>

</cfif>
