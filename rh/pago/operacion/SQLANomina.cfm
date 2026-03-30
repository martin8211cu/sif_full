<html>
<head>
<title>SQL DE AUTORIZACIÓN DE PAGO DE NÓMINA</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfparam name="form.ERNid" default="0" type="numeric">
<cfparam name="form.fecha" default="31/12/2001" type="string">
<cfparam name="form.hhp" default="4" type="numeric">
<cfparam name="form.mmp" default="4" type="numeric">
<cfparam name="form.ampmp" default="am" type="string">
<cfdump var="#Form#">

<cfif IsDefined("form.autorizar")>

	<cfset fecha = LSParseDateTime(form.fecha)>
	
	<CFIF (Session.RHParams.RHPARAM7 EQ Session.RHParams.RH_con_Banco_Virtual) or (Session.RHParams.RHPARAM7 EQ Session.RHParams.sin_RH_con_Banco_Virtual)>

		<!--- *** TODA ESTA SECCIÓN DE CÓDIGO SE ENCARGA DE PROGRAMAR EL PAGO DE ESTA NOMINA A TRAVÉS DEL BANCO VIRTUAL *** --->
	
		<!---
		<cfset ch = Fix((Day(fecha)-1) / 4)>
		<cfset bit = ((Day(fecha)-1) mod 4)>
		<cfset bitsdia=RepeatString('0',ch) & 2^(bit) & RepeatString('0',7-ch)>
		
		<cfset ch = Fix((Month(fecha)-1) / 4)>
		<cfset bit = ((Month(fecha)-1) mod 4)>
		<cfset bitsmes=RepeatString('0',ch) & 2^(bit) & RepeatString('0',2-ch)>
		
		<cfset Cplan = "0-" & LSTimeFormat(fecha,"HHmm") & "-" & bitsdia & "-ff-" & bitsmes>
		<cfset Cplandesc = "El dia " & #LSDateFormat(form.fecha)# & " a las " & #LSTimeFormat(form.fecha)#>
		--->
		
		<cfset plan_hora = IIf( form.hhp GE 0 AND form.hhp LE 11, form.hhp, 4)>
		<cfset plan_min = IIf( form.mmp GE 0 AND form.mmp LE 59, form.mmp, 0)>
		<cfif form.ampmp EQ 'pm'><cfset plan_hora = plan_hora + 12></cfif>
		
		
		<cfset Cplan = "3-" & plan_hora & plan_min & LSDateFormat(fecha,"yyyymmdd") & "05m" & "-ffffffff-ff-fff">
		<cfset Cplandesc = "El dia " & #LSDateFormat(form.fecha)# & " a las " & plan_hora & ":" & plan_min>
		
		<!---<cfoutput >Cplan: #Cplan#, Cplandesc: #Cplandesc#</cfoutput>--->
	
		<cfquery datasource="sdc" name="cron">
		select Ccodigo from Crontab
		where Ccomponente = 'Nomina/PagoNomina'
		  and Cmetodo = 'pagar'
		  and Cargumentos = '#form.ERNid#'
		</cfquery>
		<cfdump var="#form#">
		<cfdump var="#cron#">
		<cfif IsDefined("cron.Ccodigo") and Len(cron.Ccodigo) GT 0>
			<cfquery datasource="sdc">
				set nocount on
				update Crontab set
					CTcodigo = 'RH',
					COcodigo = 'PAGO',
					Cdescripcion = 'Pago de nómina No. #form.ERNid#',
					Cnombre = 'Pago de nómina No. #form.ERNid#',
					Cprogramacion = 1,
					Cmanual = 1,
					Cplan = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cplan#">,
					Cplandesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cplandesc#">,
					BMUsucodigo = #session.usucodigo#,
					BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ulocalizacion#">,
					BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
				where Ccomponente = 'Nomina/PagoNomina'
				  and Cmetodo = 'pagar'
				  and Cargumentos = '#form.ERNid#'
				  and Ccodigo = #cron.Ccodigo#
				set nocount off
			</cfquery>
		<cfelse>
			<cfquery datasource="sdc">
				set nocount on
				insert Crontab (
					CTcodigo, COcodigo, Ccomponente, Cmetodo, Cargumentos, 
					Cdescripcion, Cnombre, Cprogramacion, Cmanual,
					Cplan, Cplandesc,
					BMUsucodigo, BMUlocalizacion, BMUsulogin)
				values (
					'RH', '<cf_translate  key="LB_PAGO">PAGO</cf_translate>', 'Nomina/PagoNomina', 'pagar', '#form.ERNid#',
					'<cf_translate  key="LB_PAGODeNominaNo">Pago de nómina No.</cf_translate> #form.ERNid#', '<cf_translate  key="LB_PAGODeNominaNo">Pago de nómina No.</cf_translate> #form.ERNid#', 1, 1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cplan#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cplandesc#">,
					#session.usucodigo#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ulocalizacion#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">)
				set nocount off
			</cfquery>
		</cfif>
		
	</CFIF>

	<cfquery datasource="#session.dsn#" name="data">
		set nocount on
		update ERNomina
		set ERNestado = 4, <!--- autorizado --->
			ERNusuautoriza = #session.usucodigo#,
			ERNfautoriza = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
			ERNfechapago = <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
		where ERNid = #form.ERNid#
			and Ecodigo = #session.Ecodigo#
			and ERNestado = 3 <!--- verificado --->

		select @@rowcount as rc
		set nocount off
	</cfquery>
	<cfdump var="#data#">
	
	<CFIF (Session.RHParams.RHPARAM7 EQ Session.RHParams.RH_sin_Banco_Virtual) or (Session.RHParams.RHPARAM7 EQ Session.RHParams.sin_RH_sin_Banco_Virtual)>
		<cfquery datasource="#session.dsn#" name="data3">
			set nocount on
			update DRNomina
			set DRNestado = 1 <!--- pagado --->			
				where ERNid = #form.ERNid#
	
			select @@rowcount as rc
			set nocount off
		</cfquery>
		<cfdump var="#data3#">
	</CFIF>
	
	<cfquery datasource="#session.dsn#" name="data2">
		set nocount on
		declare @RCNid numeric
		select @RCNid = RCNid
		from ERNomina
		where ERNid = #form.ERNid#
			and Ecodigo = #session.Ecodigo#
			and ERNestado = 4 <!--- autorizado --->
		
		if @RCNid is not null
		begin
			Update CalendarioPagos
			set CPfenvio = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
				CPusuenvio = #session.usucodigo#,
				CPusulocenvio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ulocalizacion#">
			from RCalculoNomina
			where RCalculoNomina.RCNid = @RCNid
				and CalendarioPagos.Ecodigo = RCalculoNomina.Ecodigo
				and CalendarioPagos.Tcodigo = RCalculoNomina.Tcodigo
				and CalendarioPagos.CPdesde = RCalculoNomina.RCdesde
				and CalendarioPagos.CPhasta = RCalculoNomina.RChasta
		end
		select @@rowcount as rc
		set nocount off
	</cfquery>
	<cfdump var="#data2#">
	
<cfelseif IsDefined("form.anular")>
	<cfquery datasource="#session.dsn#" name="data">
		set nocount on
		update ERNomina
		set ERNestado = 5, <!--- anulado --->
			ERNfautoriza = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
			ERNfechapago = <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
		where ERNid = #form.ERNid#
		  and Ecodigo = #session.Ecodigo#
		  and ERNestado = 3 <!--- verificado --->
		select @@rowcount as rc
		set nocount off
	</cfquery>
	<cfdump var="#data#">

<cfelseif IsDefined("form.revisar")>
	<cfquery datasource="#session.dsn#" name="data">
		set nocount on
		update ERNomina
		set ERNestado = 2, <!--- listo para verificar --->
			ERNfautoriza = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
			ERNfechapago = <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
		where ERNid = #form.ERNid#
		  and Ecodigo = #session.Ecodigo#
		  and ERNestado = 3 <!--- verificado --->
		  <!---and ERNcapturado = 1 * SE ELIMINA PORQUE se va a habilitar la posibilidad de devolver las que vienen de Nómina también. * --->
		select @@rowcount as rc
		set nocount off
	</cfquery>
	<cfdump var="#data#">

</cfif>

<a href="listaANomina.cfm"><cf_translate  key="LB_Continuar">Continuar</cf_translate></a>

</body>
</html>

<cflocation url="listaANomina.cfm">