<!--- OPARRALES 2018-08-20
	- Se complementa proceso para realizar archivo de dispersion BANORTE
 --->

<cfparam name="url.ERNid" type="numeric">
<cfparam name="url.Bid" type="numeric">

<cf_dbtemp name="Encabezado" returnvariable="EBananorte" datasource="#session.dsn#">
	<cf_dbtempcol name="Prioridad" 		   type="numeric"  mandatory="no"> <!--- Prioridad--->
	<cf_dbtempcol name="TipoRegistro" 		   type="char(1)" mandatory="no"> <!--- Encabezado H, Detalle A--->
	<cf_dbtempcol name="ClaveServicio"  	   type="char(2)" mandatory="no"> <!--- NE para Nomina --->
	<cf_dbtempcol name="Emisora"  	   		   type="char(5)" mandatory="no"> <!--- CodigoCliente en CuentaBancaria --->
	<cf_dbtempcol name="Fecha"  	   		   type="char(8)" mandatory="no"> <!--- FechaHastaNomina --->
	<cf_dbtempcol name="Consecutivo"  	   	   type="char(2)" mandatory="no"> <!--- Número Nómina en el Día --->
	<cf_dbtempcol name="TotalRegistros"	   	   type="numeric" mandatory="no"> <!--- Cantidad Pagos Realizados --->
	<cf_dbtempcol name="TotalPagos"  	   	   type="varchar(255)" mandatory="no"> <!--- TotalPagosRealizados --->
<!--- CAMPOS ADICIONALES QUE NO SON DE NOMINA--->
	<cf_dbtempcol name="AltasEnviadas" 	   	   type="char(6)" mandatory="no"> 	<!---Llenar Ceros --->
	<cf_dbtempcol name="ImporteAltas" 	   	   type="char(15)" mandatory="no"> 	<!---Llenar Ceros --->
	<cf_dbtempcol name="BajasEnviadas" 	   	   type="char(6)" mandatory="no"> 	<!---Llenar Ceros --->
	<cf_dbtempcol name="ImporteBajas" 	   	   type="char(15)" mandatory="no"> 	<!---Llenar Ceros --->
	<cf_dbtempcol name="TotalCuentas" 	   	   type="char(6)" mandatory="no"> 	<!---Llenar Ceros --->
	<cf_dbtempcol name="Accion" 	   	   	   type="char(1)" mandatory="no">	<!---Llenar Ceros --->
	<cf_dbtempkey cols="TipoRegistro">
</cf_dbtemp>


<cf_dbtemp name="Detalle" returnvariable="DBananorte" datasource="#session.dsn#">
	<cf_dbtempcol name="Prioridad" 		   	type="numeric"  mandatory="no"> 	<!--- Prioridad--->
	<cf_dbtempcol name="TipoRegistro" 		type="char(1)"  mandatory="no" > 	<!--- Encabezado H, Detalle A--->
	<cf_dbtempcol name="Fecha"		 	 	type="char(8)"  mandatory="no"> 	<!--- FechaHastaNomina --->
	<cf_dbtempcol name="NumeroEmpleado"	 	type="char(10)" mandatory="no"> 	<!--- Número Empleado(DEidentificacion) en la Empresa --->
	<cf_dbtempcol name="ReferenciaServicio"	type="char(40)" mandatory="no"> 	<!--- Espacios en Blanco --->
	<cf_dbtempcol name="ReferenciaLeyenda"	type="char(40)" mandatory="no"> 	<!--- Espacios en Blanco --->
	<cf_dbtempcol name="Importe"	   		type="varchar(255)" mandatory="no"> 		<!--- SalarioLiquidoPagado --->
	<cf_dbtempcol name="BancoReceptor"	   	type="char(3)"  mandatory="no"> 	<!--- BancoReceptor --->
	<cf_dbtempcol name="TipoCuenta"	   	   	type="char(2)"  mandatory="no">  	<!--- 01 Queque, 03 Debito, 40 Clave --->
	<cf_dbtempcol name="NumeroCuenta"  	   	type="varchar(500)"  mandatory="no">  	<!--- Numero Cuenta Empleado --->
<!--- CAMPOS ADICIONALES QUE NO SON DE NOMINA--->
	<cf_dbtempcol name="TipoMovimiento"		type="char(1)" mandatory="no">
	<cf_dbtempcol name="Accion"		   		type="char(1)" mandatory="no">
	<cf_dbtempcol name="IVA"		   	   	type="char(8)" mandatory="no" >
</cf_dbtemp>

<cf_dbtemp name="Reporte" returnvariable="RepBananorte" datasource="#session.dsn#">
		<cf_dbtempcol name="Prioridad" 		type="numeric"  mandatory="no"> 		<!--- Prioridad--->
		<cf_dbtempcol name="Hilera" 		type="varchar(255)"  mandatory="no" > 	<!---Texto Reporte Bancos--->
</cf_dbtemp>

<cf_dbfunction name="OP_concat" returnvariable="CAT" >

<!--- EXTRAE NUMERO CUENTA ASIGNADA POR EL BANCO DE CUENTAS BANCARIAS --->
<cfquery name="ClaveServicio" datasource="#session.dsn#">
		select BcodigoOtro
		from   Bancos
		where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Bid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
</cfquery>

<!---<cfdump var="#ClaveServicio#"> --->

<cfif len(ClaveServicio.BcodigoOtro) EQ 0>
		<cfthrow message = "El Código de Cliente (Clave de Servicio) del Banco no ha sido definido, Ingrese al Catálogo de Bancos, e indique dicho código en el campo Codigo Cliente">
		<cfabort>
</cfif>

<cfset ClaveServicio = Mid(rtrim(ClaveServicio.BcodigoOtro),1,5)>
<cfif Len(ClaveServicio) LT 4>
 	<cfset ClaveServicio = repeatstring('0', 5-len(ClaveServicio)) & ClaveServicio>
</cfif>

<!---  CONSECUTIVO DEL ARCHIVO --->
<cfquery name="rsConsecutivo" datasource="#session.DSN#">
	select Pvalor as NumArch
	from RHParametros
	where Pcodigo = 210
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!---	<cfdump var="#Consecutivo#"> --->
<cfset Consecutivo = rsConsecutivo.NumArch>
<cfif Trim(Consecutivo) eq '' or Consecutivo LT 0 >
	<cfquery name="rsInsertB" datasource="#session.DSN#">
		insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
		values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 210, 'Consecutivo de Archivo de Planilla', '1')
	</cfquery>
	<cfset Consecutivo = 1>
</cfif>
<cfset Consecutivo += 1>

<!--- obtiene el Ernid  ya que el parametro del conlist devuelve RCnid  --->
<cfquery name="GetErnid" datasource="#session.dsn#">
	select  b.Ernid,* from  <cfif (isDefined("url.historico") and url.historico eq 0) or (isDefined("url.estado") and url.estado eq 'p')>ERNomina b <cfelse>HERNomina b </cfif>
	where ERNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfquery>
<cfset ERNid = #GetErnid.Ernid#>

<!---  CANTIDAD DE REGISTROS VERIFICA SI LA NOMINA ESTA EN PROCESO Y SI NO LA BUSCA EN HISTORICOS--->
<cfquery name="rsNumReg" datasource="#session.dsn#">
	select count(1) as NumRegistros
	FROM DRNomina a
	INNER JOIN ERNomina b
		ON a.ERNid=b.ERNid
	INNER JOIN DatosEmpleado c
		ON a.DEid=c.DEid
		and c.DETipoPago = 0
	<!--- left JOIN IncidenciasCalculo ic
		ON ic.RCNid = b.RCNid
		and c.DEid = ic.DEid
	left outer JOIN CIncidentes i
		ON ic.CIid = i.CIid
		AND i.CIExcluyePagoLiquido = 1 --->
	WHERE
		b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	AND a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">
	and c.Bid is not null <!--- Tienen Banco Asignado --->
	and a.DRNestado=1  <!--- Marcados como para Pagar --->
	and DRNliquido > 0
</cfquery>

<!--- variable anterior de Ernid por uRL and a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> --->
<cfif rsNumReg.NumRegistros EQ 0>
	<cfquery name="rsNumReg" datasource="#session.dsn#">
		select count(1) as NumRegistros
		FROM HDRNomina a
		INNER JOIN HERNomina b
			ON a.ERNid=b.ERNid
		INNER JOIN DatosEmpleado c
			ON a.DEid=c.DEid
			and c.DETipoPago = 0
		<!---
		left outer JOIN HIncidenciasCalculo ic
			ON ic.RCNid = b.RCNid
			and c.DEid = ic.DEid
		inner JOIN CIncidentes i
			ON ic.CIid = i.CIid
			AND i.CIExcluyePagoLiquido = 1
		--->
		WHERE
			b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		AND a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">
		and c.Bid is not null <!--- Tienen Banco Asignado --->
		and a.HDRNestado=1  <!--- Marcados como para Pagar --->
		and HDRNliquido > 0
	</cfquery>
</cfif>

<!---<cf_dump var="#rsNumReg#"> --->
<cfset NumReg = Mid(rtrim(rsNumReg.NumRegistros),1,5)>
<cfif Len(NumReg) LT 6>
	 <cfset NumReg = repeatstring('0', 6-len(NumReg)) & NumReg>
</cfif>

<!---   TOTAL DE SALARIO PAGADOS EN NOMINA  --->
<cfset TipoNomina='P'>
<cfquery name="TotalSalarios" datasource="#session.dsn#">
	SELECT Round((sum(coalesce(DRNliquido,0)) -
						coalesce((select
							sum(coalesce(ic.ICmontores,0)) ICmontores
						from ERNomina e
						inner join IncidenciasCalculo ic
							on e.RCNid = ic.RCNid
							and e.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">
						inner join DatosEmpleado de
							on de.DEid = ic.DEid
							and de.DETipoPago = 0
						inner join CIncidentes ci
							on ci.CIid = ic.CIid
						where ci.CIExcluyePagoLiquido = 1),0))
	,2) AS TotalSalarios
	FROM DRNomina a
	INNER JOIN ERNomina b
		ON a.ERNid=b.ERNid
	INNER JOIN DatosEmpleado c
		ON a.DEid=c.DEid
		and c.DETipoPago = 0
	WHERE
		b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	AND a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">
	and c.Bid is not null <!--- Tienen Banco Asignado --->
	and a.DRNestado=1  <!--- Marcados como para Pagar --->
	and DRNliquido > 0
</cfquery>
<cfif TotalSalarios.TotalSalarios LT 0>
	<cfquery name="TotalSalarios" datasource="#session.dsn#">
		SELECT
			Round((sum(coalesce(HDRNliquido,0)) -
						coalesce((select
							sum(coalesce(ic.ICmontores,0)) ICmontores
						from HERNomina e
						inner join HIncidenciasCalculo ic
							on e.RCNid = ic.RCNid
							and e.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">
						inner join DatosEmpleado de
							on de.DEid = ic.DEid
							and de.DETipoPago = 0
						inner join CIncidentes ci
							on ci.CIid = ic.CIid
						where ci.CIExcluyePagoLiquido = 1),0))
			,2) AS TotalSalarios
		FROM HDRNomina a
		INNER JOIN HERNomina b
			ON a.ERNid=b.ERNid
		INNER JOIN DatosEmpleado c
			ON a.DEid=c.DEid
			and c.DETipoPago = 0
		WHERE
			b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		AND a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">
		and c.Bid is not null <!--- Tienen Banco Asignado --->
		and a.HDRNestado=1  <!--- Marcados como para Pagar --->
		and HDRNliquido > 0
	</cfquery>
	<cfset TipoNomina='H'>
</cfif>


<cfset TotalSalarios = Replace(LSNumberFormat(TotalSalarios.TotalSalarios,'9.00'),'.','')>
<cfif Len(TotalSalarios) LT 15>
	 <cfset TotalSalarios = repeatstring('0', 15-len(TotalSalarios)) & TotalSalarios>
</cfif>

<cfset AltasEnviadas=repeatstring('0',6)>
<cfset ImporteAltas=repeatstring('0',15)>
<cfset BajasEnviadas=repeatstring('0',6)>
<cfset ImporteBajas=repeatstring('0',15)>
<cfset TotalCuentas=repeatstring('0',6)>
<cfset Accion=repeatstring('0',1)>

<cfquery name="rsInsertEnc" datasource="#session.DSN#">
	Insert into #EBananorte#(Prioridad,
							   TipoRegistro,
							   ClaveServicio,
							   Emisora,
							   Fecha,
							   Consecutivo,
							   TotalRegistros,
							   TotalPagos,
							   AltasEnviadas,
							   ImporteAltas,
							   BajasEnviadas,
							   ImporteBajas,
							   TotalCuentas,
							   Accion)

	<cfif TipoNomina EQ'P'>
		Select	1,
			   'H',
			   'NE',
			   '#ClaveServicio#',
			   		rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,ERNfdeposito)|YYYY" delimiters="|">)+
			   		rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,ERNfdeposito)|MM" delimiters="|">)+
			   		rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,ERNfdeposito)|DD" delimiters="|">),
			   '#Consecutivo#',
			   '#NumReg#',
			   '#TotalSalarios#',
			   '#AltasEnviadas#',
			   '#ImporteAltas#',
			   '#BajasEnviadas#',
			   '#ImporteBajas#',
			   '#TotalCuentas#',
			   '#Accion#'
		from ERNomina a
	<cfelse>
		Select 1,
			   'H',
			   'NE',
			   '#ClaveServicio#',
			   		rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,HERNfdeposito)|YYYY" delimiters="|">)+
			   		rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,HERNfdeposito)|MM" delimiters="|">)+
			   		rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,HERNfdeposito)|DD" delimiters="|">),
			   '#Consecutivo#',
			   '#NumReg#',
			   '#TotalSalarios#',
			   '#AltasEnviadas#',
			   '#ImporteAltas#',
			   '#BajasEnviadas#',
			   '#ImporteBajas#',
			   '#TotalCuentas#',
			   '#Accion#'
		from	HERNomina a
	</cfif>
		Where   a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">
</cfquery>

<cf_dbfunction name="string_part" args="rtrim(Consecutivo)|1|2" 	returnvariable="LvarConse"  delimiters="|">
<cf_dbfunction name="length"      args="#LvarConse#"  		returnvariable="LvarConseL" delimiters="|" >
<cf_dbfunction name="sRepeat"     args="'0'|2-coalesce(#LvarConseL#,0)" 	returnvariable="LvarConseS" delimiters="|">

<cf_dbfunction name="string_part" args="rtrim(TotalRegistros)|1|6" 	returnvariable="LvarTotalRegistros"  delimiters="|">
<cf_dbfunction name="length"      args="#LvarTotalRegistros#"  		returnvariable="LvarTotalRegistrosL" delimiters="|" >
<cf_dbfunction name="sRepeat"     args="'0'|6-coalesce(#LvarTotalRegistrosL#,0)" 	returnvariable="LvarTotalRegistrosS" delimiters="|">

<cf_dbfunction name="string_part" args="rtrim(TotalPagos)|1|15" 	returnvariable="LvarTotalPagos"  delimiters="|">
<cf_dbfunction name="length"      args="#LvarTotalPagos#"  		returnvariable="LvarTotalPagosL" delimiters="|" >
<cf_dbfunction name="sRepeat"     args="'0'|15-coalesce(#LvarTotalPagosL#,0)" 	returnvariable="LvarTotalPagosS" delimiters="|">

<cfquery name="InsReporte" datasource="#session.DSN#">
	Insert into #RepBananorte# (Prioridad, Hilera)
	Select Prioridad, (rtrim(TipoRegistro) #CAT#
					  rtrim(ClaveServicio) #CAT#
					  rtrim(Emisora) #CAT#
					  Fecha  #CAT#
					  rtrim(#preservesinglequotes(LvarConseS)#) #CAT#
					  rtrim(#preservesinglequotes(LvarConse)#) #CAT#
					  rtrim(#preservesinglequotes(LvarTotalRegistrosS)#) #CAT#
					  rtrim(#preservesinglequotes(LvarTotalRegistros)#) #CAT#
					  rtrim(#preservesinglequotes(LvarTotalPagosS)#) #CAT#
					  rtrim(#preservesinglequotes(LvarTotalPagos)#) #CAT#
					  AltasEnviadas #CAT#
					  ImporteAltas #CAT#
					  BajasEnviadas #CAT#
					  ImporteBajas #CAT#
					  TotalCuentas #CAT#
					  Accion #CAT#
					  <cf_dbfunction name="sRepeat"     args="' '|77" delimiters="|">)
	from #EBananorte#
</cfquery>

<cfset AltasEnviadas=repeatstring('0',6)>
<cfset ImporteAltas=repeatstring('0',15)>
<cfset BajasEnviadas=repeatstring('0',6)>
<cfset ImporteBajas=repeatstring('0',15)>
<cfset TotalCuentas=repeatstring('0',6)>
<cfset Accion=repeatstring('0',1)>

<cfquery name="rsInsertDetc" datasource="#session.DSN#">
	Insert into #DBananorte#(Prioridad,
							   TipoRegistro,
							   Fecha,
							   NumeroEmpleado,
							   ReferenciaServicio,
							   ReferenciaLeyenda,
							   Importe,
							   BancoReceptor,
							   TipoCuenta,
							   NumeroCuenta,
							   TipoMovimiento,
							   Accion,
							   IVA)
	<cfif TipoNomina EQ'P'>
		Select
			2 as Prioridad,
			'D' as TipoRegistro,
			rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,ERNfdeposito)|YYYY" delimiters="|">)+
	   		rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,ERNfdeposito)|MM" delimiters="|">)+
	   		rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,ERNfdeposito)|DD" delimiters="|">) as Fecha,
			DEidentificacion as Identificacion,
			' ' as NumeroReferencia,
			' ' as NumeroLyenda,
			Format(coalesce(DRNliquido,0)-
					coalesce((select
						coalesce(ic.ICmontores,0) ICmontores
						from HERNomina e
						inner join HIncidenciasCalculo ic
							on e.RCNid = ic.RCNid
						inner join DatosEmpleado de
							on de.DEid = ic.DEid
							and de.DEid = c.DEid
							and de.DETipoPago = 0
						inner join CIncidentes ci
						on ci.CIid = ic.CIid
						where ci.CIExcluyePagoLiquido = 1
						and e.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">)
			   		,0)
			,'N') as Importe,
			<!---'LZL' as BancoReceptor,--->
			(select left(coalesce(ban.Bcodigocli,'000'),3) from Bancos ban where ban.Bid = c.Bid) as BancoReceptor,
			'0'+c.CBTcodigo as TipoCuenta,
			rtrim(coalesce(DEcuenta,'')) CuentaBancaria,
			'0' as TipoMovimiento,
			' ' as Accion,
			'00000000' as IVA
		FROM DRNomina a
		INNER JOIN ERNomina b
			ON a.ERNid=b.ERNid
		INNER JOIN DatosEmpleado c
			ON a.DEid=c.DEid
			and c.DETipoPago = 0
		WHERE
			b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.DRNestado=1  <!--- Marcados como para Pagar --->
		and DRNliquido > 0

	<cfelse>
		Select
			2 as Prioridad,
			'D' as TipoRegistro,
			rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,HERNfdeposito)|YYYY" delimiters="|">)+
				rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,HERNfdeposito)|MM" delimiters="|">)+
				rtrim(<cf_dbfunction name="date_format" args="DateAdd(dd,0,HERNfdeposito)|DD" delimiters="|">) as Fecha,
			DEidentificacion as Identificacion,
			'' as NumeroReferencia,
			'' as NumeroLeyenda,
			Format(coalesce(HDRNliquido,0)-
					coalesce((select
							coalesce(ic.ICmontores,0) ICmontores
						from HERNomina e
						inner join HIncidenciasCalculo ic
							on e.RCNid = ic.RCNid
						inner join DatosEmpleado de
							on de.DEid = ic.DEid
							and de.DEid = c.DEid
							and de.DETipoPago = 0
						inner join CIncidentes ci
						on ci.CIid = ic.CIid
						where ci.CIExcluyePagoLiquido = 1
						and e.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">)
				   ,0)
			,'N') as Importe,
			<!---   'LZL' as BancoReceptor,--->
			(select Left(coalesce(ban.Bcodigocli,'000'),3) from Bancos ban where ban.Bid = c.Bid) as BancoReceptor,
			'0'+c.CBTcodigo as TipoCuenta,
			rtrim(DEcuenta) CuentaBancaria,
			'0' as TipoMovimiento,
			' ' as Accion,
			'00000000' as IVA
		<!--- from	HERNomina a, HDRNomina b, DatosEmpleado c --->
		FROM HDRNomina a
		INNER JOIN HERNomina b
			ON a.ERNid=b.ERNid
		INNER JOIN DatosEmpleado c
			ON a.DEid=c.DEid
			and c.DETipoPago = 0
		WHERE
			b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.HDRNestado=1  <!--- Marcados como para Pagar --->
		and HDRNliquido > 0
	</cfif>
		and a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERNid#">
		and c.Bid is not null
</cfquery>

<!--- VALIDACIONES --->
<cfquery name="rsDEcuentas" datasource="#session.dsn#">
	select NumeroEmpleado from #DBananorte#
	where NumeroCuenta = '' or NumeroCuenta is null
</cfquery>

<cfif rsDEcuentas.RecordCount gt 0>
	<cfthrow detail="Los siguientes empleados no tienen una Cuenta Bancara definida: #ValueList(rsDEcuentas.NumeroEmpleado)#">
</cfif>

<cf_dbfunction name="string_part" args="rtrim(coalesce(NumeroEmpleado,''))|1|10" 	returnvariable="LvarIdentific"  delimiters="|">
<cf_dbfunction name="length"      args="#LvarIdentific#"  		returnvariable="LvarIdentificL" delimiters="|" >
<cf_dbfunction name="sRepeat"     args="' '|10-coalesce(#LvarIdentificL#,0)" 	returnvariable="LvarIdentifiS" delimiters="|">

<cf_dbfunction name="string_part" args="rtrim(Replace(Replace(Importe,'.',''),',',''))|1|15" 	returnvariable="LvarLiquido"  delimiters="|">
<cf_dbfunction name="length"      args="#LvarLiquido#"  		returnvariable="LvarLiquidoL" delimiters="|" >
<cf_dbfunction name="sRepeat"     args="'0'|15-coalesce(#LvarLiquidoL#,0)" 	returnvariable="LvarLiquidoS" delimiters="|">

<cf_dbfunction name="string_part" args="rtrim(coalesce(BancoReceptor,''))|1|3" 	returnvariable="LvarBancoReceptor"  delimiters="|">
<cf_dbfunction name="length"      args="#LvarBancoReceptor#"  		returnvariable="LvarBancoReceptorL" delimiters="|" >
<cf_dbfunction name="sRepeat"     args="'0'|3-coalesce(#LvarBancoReceptorL#,0)" 	returnvariable="LvarBancoReceptorS" delimiters="|">

<cf_dbfunction name="string_part" args="rtrim(coalesce(case when LTrim(RTrim(TipoCuenta)) = '0' then '01' else '03' end,''))|1|2" 	returnvariable="LvarTipoCuenta"  delimiters="|">
<cf_dbfunction name="length"      args="#LvarTipoCuenta#"  		returnvariable="LvarTipoCuentaL" delimiters="|" >
<cf_dbfunction name="sRepeat"     args="'0'|2-coalesce(#LvarTipoCuentaL#,0)" 	returnvariable="LvarTipoCuentaS" delimiters="|">

<cf_dbfunction name="string_part"args="rtrim(coalesce(NumeroCuenta,'0'))|1|18" 	returnvariable="LvarNumeroCuenta"  delimiters="|">
<cf_dbfunction name="length"      args="#LvarNumeroCuenta#"  		returnvariable="LvarNumeroCuentaL" delimiters="|" >
<cf_dbfunction name="sRepeat"     args="'0'|18-coalesce(#LvarNumeroCuentaL#,'0')" 	returnvariable="LvarNumeroCuentaS" delimiters="|">

<cfquery name="InsReporte" datasource="#session.DSN#">
	Insert into #RepBananorte# (Prioridad, Hilera)
	Select Prioridad,
					  rtrim(TipoRegistro) #CAT#
					  rtrim(Fecha) #CAT#
					  rtrim(#preservesinglequotes(LvarIdentifiS)#) #CAT# '000000' #CAT# ltrim(rtrim(#preservesinglequotes(LvarIdentific)#)) #CAT#
					  <cf_dbfunction name="sRepeat"     args="' '|40" delimiters="|"> #CAT#
					  <cf_dbfunction name="sRepeat"     args="' '|40" delimiters="|">
					  #CAT#
					  rtrim(#preservesinglequotes(LvarLiquidoS)#)  #CAT# rtrim(#preservesinglequotes(LvarLiquido)#)
					  #CAT#
					  rtrim(#preservesinglequotes(LvarBancoReceptorS)#)#CAT#  rtrim(#preservesinglequotes(LvarBancoReceptor)#)
					  #CAT#
					  rtrim(#preservesinglequotes(LvarTipoCuentaS)#)  #CAT# rtrim(#preservesinglequotes(LvarTipoCuenta)#)
					   #CAT#
					  #preservesinglequotes(LvarNumeroCuentaS)# #CAT# rtrim(#preservesinglequotes(LvarNumeroCuenta)#)
					   #CAT#
					  rtrim(TipoMovimiento)
					  #CAT#
					  ' '
					  #CAT#
					  '00000000'#CAT#
					  <cf_dbfunction name="sRepeat"     args="' '|18" delimiters="|">
					  <!---
					  <cf_dbfunction name="sRepeat"     args="' '|18" delimiters="|"> --->
	from #DBananorte#
</cfquery>

<cfset NL = Chr(13)&Chr(10)>
<cfquery name="ERR" datasource="#session.DSN#">
	Select Hilera from #RepBananorte#
	Order by Prioridad
</cfquery>
<cfset Conse = Consecutivo>
<cfquery name="Act" datasource="#session.DSN#">
	update  RHParametros
	set Pvalor= '#Conse#'
	Where Pcodigo=210
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfset countLin = 1>
<cfset TextoFile = "">

<cfloop query="ERR">
	<cfif countLin gt 1>
		<cfset TextoFile &= NL>
	</cfif>
	<cfset TextoFile &= ERR.Hilera>
	<cfset countLin++>
</cfloop>
<cfset fileName = "NI"&"#ClaveServicio#"&RepeatString("0",(2-LEN(Conse)))&Conse&"CF"&".PAG">
<cfset filePath = "ram:///#fileName#">
<cffile action="write" file="#filePath#" charset="utf-8" output="#TextoFile#" addnewline="false">
<cfheader name="Content-Disposition" value="attachment; filename=#fileName#">
<cfcontent type="text/plain" file="#filePath#" deletefile="yes">

