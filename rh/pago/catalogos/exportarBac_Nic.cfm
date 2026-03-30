<cftransaction>
	<!----=================== Tabla de trabajo ===================--->
	<cf_dbtemp name="DatosExporta" returnvariable="DatosExporta" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
		<cf_dbtempcol name="Datos" 	type="char(122)"  	mandatory="no">
		<cf_dbtempcol name="Orden"	type="int" 			mandatory="no">
	</cf_dbtemp>		
	<!----=================== Consecutivo de envio de archivo ===================--->
	<cfquery name="rscheck3" datasource="#session.DSN#"><!---Consecutivo de envios del archivo de planilla--->
		select 1
		from RHParametros 
		where Pcodigo = 210 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfif rscheck3.RecordCount EQ 0 ><!---Si no existe el parametro lo crea e inicializa con valor 1 --->
		<cfquery name="rsInsertB" datasource="#session.DSN#">
			insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 210, 'Consecutivo de Archivo de Planilla', '1')
		</cfquery>
	</cfif>	
	<cfquery name="rscheck4" datasource="#session.DSN#">
		select <cf_dbfunction name="string_part" args="Pvalor,1,5"> as Archivo 
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		 and Pcodigo = 210
	</cfquery>	
	<cfset bArchivo = RepeatString('0',5-len(rscheck4.Archivo)) & mid(rscheck4.Archivo,1,5)><!----Numero de envio--->		
	<!---=================== Datos de los creditos ===================--->
	<cfquery name="rsDatos" datasource="#session.DSN#">				
		select 	<cf_dbfunction name="string_part" args="c.DEidentificacion,1,20"> as NumReferencia,
				<!---
				<cf_dbfunction name="date_format" args="b.ERNfechapago,YYYY"> as anno,
				<cf_dbfunction name="date_format" args="b.ERNfechapago,MM"> as mes,
				<cf_dbfunction name="date_format" args="b.ERNfechapago,DD"> as dia,
				---->
				convert(numeric, (floor(a.DRNliquido * 100)) )as monto,
				<!----
				coalesce(floor(a.DRNliquido * 100),0) as monto2,
				coalesce(a.DRNliquido,0) as monto3,
				----->
				<cf_dbfunction name="string_part" args="b.ERNdescripcion,1,30"> as concepto,
				<cf_dbfunction name="concat" args="c.DEnombre,' ',c.DEapellido1,' ',c.DEapellido2"> as nombre				
		from DRNomina a, ERNomina b, DatosEmpleado c
		where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> 
			and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
			and a.ERNid = b.ERNid
			and a.DEid = c.DEid	
			and a.DRNliquido > 0.00
			and convert(numeric, (floor(a.DRNliquido * 100)) ) > 0	
	</cfquery>
	<!---=================== Fecha de pago ===================--->
	<cfquery name="rsFechaPago" datasource="#session.DSN#">
		select 	<cf_dbfunction name="date_format" args="c.CPfpago,YYYY"> as anno,
				<cf_dbfunction name="date_format" args="c.CPfpago,MM"> as mes,
				<cf_dbfunction name="date_format" args="c.CPfpago,DD"> as dia
		from ERNomina b, CalendarioPagos c
		where b.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> 
			and b.RCNid = c.CPid
			and b.Ecodigo = c.Ecodigo
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
	</cfquery>	
	<!---=================== Total de montos a acreditar ===================--->
	<cfquery name="rsTotalAcreditar" datasource="#session.DSN#">
		select convert(numeric, (sum(floor(a.DRNliquido*100))) ) as total
				,coalesce(sum(a.DRNliquido*100),0) as total2
		from DRNomina a, ERNomina b, DatosEmpleado c
		where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> 
			and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
			and a.ERNid = b.ERNid
			and a.DEid = c.DEid	
			and a.DRNliquido > 0.00	
			and convert(numeric, (floor(a.DRNliquido * 100)) ) > 0	
	</cfquery>
	
	<!----<cfset vn_total = rsTotalAcreditar.total2 * 100>---->
	<cfset vn_total = LSNumberFormat(rsTotalAcreditar.total2,'9999999999999')>

	<!----=================== Insertar linea encabezado ===================--->
	<cfquery datasource="#session.DSN#">
		insert into #DatosExporta# (Datos,Orden)
		values(	{fn concat('B1153',
				{fn concat('#bArchivo#',
				{fn concat('#RepeatString(' ',25)#',
				{fn concat('#rsFechaPago.anno##rsFechaPago.mes##rsFechaPago.dia#',
				{fn concat((case when #13-len(rsTotalAcreditar.total)# > 0 then '#RepeatString(' ',13-len(rsTotalAcreditar.total))#' end) ,
				{fn concat('#Mid(rsTotalAcreditar.total,1,13)#',
				{fn concat('#RepeatString(' ',5-len(rsDatos.RecordCount))#',
				{fn concat('#rsDatos.RecordCount#',
					'#RepeatString(' ',61)#'
				)})})})})})})})}
				<!----
				{fn concat('B1153',
				{fn concat('#RepeatString(' ',43)#',
				{fn concat((case when #13-len(rsTotalAcreditar.total)# > 0 then '#RepeatString('0',13-len(rsTotalAcreditar.total))#' end) ,
				{fn concat('#Mid(rsTotalAcreditar.total,1,13)#',
					'#RepeatString(' ',66)#'
				)})})})}
				----->
				,0)				
		<!---
		values(	{fn concat('B',
				{fn concat('1153',
				{fn concat('#bArchivo#',
				{fn concat('#RepeatString(' ',20)#',
				{fn concat('00000',
				{fn concat('#rsFechaPago.anno#',
				{fn concat('#rsFechaPago.mes#',
				{fn concat('#rsFechaPago.dia#',
				{fn concat( (case when #13-len(rsTotalAcreditar.total)# > 0 then '#RepeatString('0',13-len(rsTotalAcreditar.total))#' end) ,
				{fn concat('#Mid(rsTotalAcreditar.total,1,13)#',
				{fn concat('#RepeatString('0',5-len(rsDatos.RecordCount))#',
				{fn concat('#rsDatos.RecordCount#',
						'#RepeatString(' ',61)#'
				)})})})})})})})})})})})}
				,1)	
		---->			
	</cfquery>
	<!----=================== Insertar lineas detalle ===================--->
	<cfset vn_conta = 0>
	<cfloop query="rsDatos">		
		<cfset vn_conta = vn_conta+1>
		<cfquery datasource="#session.DSN#">
			insert into #DatosExporta# (Datos,Orden)
			values(	{fn concat('T',
					{fn concat('1153',
					{fn concat('#bArchivo#',
					{fn concat('#mid(rsDatos.NumReferencia,1,20)#',
					{fn concat((case when #20-len(rsDatos.NumReferencia)# > 0 then '#RepeatString(' ',20-len(rsDatos.NumReferencia))#' end),
					{fn concat( (case when #5-len(vn_conta)# > 0 then '#RepeatString(' ',5-len(vn_conta))#' end),
					{fn concat('#mid(vn_conta,1,5)#',
					{fn concat('#rsFechaPago.anno#',
					{fn concat('#rsFechaPago.mes#',
					{fn concat('#rsFechaPago.dia#',
					{fn concat( (case when #13-len(rsDatos.monto)# > 0 then '#RepeatString(' ',13-len(rsDatos.monto))#' end),
					{fn concat('#mid(rsDatos.monto,1,13)#',
					{fn concat('#RepeatString(' ',5)#',
					{fn concat('#mid(rsDatos.concepto,1,30)#',
					{fn concat((case when #30-len(rsDatos.concepto)# > 0 then '#RepeatString(' ',30-len(rsDatos.concepto))#' end),
					{fn concat(' ',					
					{fn concat('#mid(rsDatos.nombre,1,30)#',
						(case when #30-len(trim(rsDatos.nombre))# > 0 then replicate(' ',len('#rsDatos.nombre#')) end)<!---'#RepeatString(' ',30-len(rsDatos.concepto))#' end)--->
					)})})})})})})})})})})})})})})})})}
					<!----
					{fn concat('T',
					{fn concat('1153',
					{fn concat('#bArchivo#',
					{fn concat('#mid(rsDatos.NumReferencia,1,20)#',
					{fn concat((case when #20-len(rsDatos.NumReferencia)# > 0 then '#RepeatString(' ',20-len(rsDatos.NumReferencia))#' end),
					{fn concat( (case when #5-len(vn_conta)# > 0 then '#RepeatString('0',5-len(vn_conta))#' end),
					{fn concat('#mid(vn_conta,1,5)#',
					{fn concat('#rsFechaPago.anno#',
					{fn concat('#rsFechaPago.mes#',
					{fn concat('#rsFechaPago.dia#',
					{fn concat( (case when #13-len(rsDatos.monto)# > 0 then '#RepeatString('0',13-len(rsDatos.monto))#' end),
					{fn concat('#mid(rsDatos.monto,1,13)#',
					{fn concat('#RepeatString('0',5-len(rsDatos.RecordCount))#',
					{fn concat('#rsDatos.RecordCount#',
					{fn concat('#mid(rsDatos.concepto,1,30)#',
					{fn concat((case when #30-len(rsDatos.concepto)# > 0 then '#RepeatString(' ',30-len(rsDatos.concepto))#' end),					
					{fn concat(' ',
					{fn concat('#mid(rsDatos.nombre,1,30)#',
						(case when #30-len(trim(rsDatos.nombre))# > 0 then replicate(' ',len('#rsDatos.nombre#')) end)<!---'#RepeatString(' ',30-len(rsDatos.concepto))#' end)--->
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					)}
					---->
					,#vn_conta#)
		</cfquery>
	</cfloop>	
	<cfquery name="ERR" datasource="#session.DSN#">
		select  Datos,Orden 
		from #DatosExporta#
		order by Orden 
	</cfquery>


	<cf_dbfunction name="to_number" args="Pvalor" returnvariable="LvarCampoB"> 
	<cfset LvarCampoB = "#LvarCampoB# + 1">

	<cfquery name="updateA" datasource="#Session.DSN#">
		update RHParametros
			set Pvalor = <cf_dbfunction name="to_char" args="#LvarCampoB#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Pcodigo = 210 
	</cfquery>

</cftransaction>