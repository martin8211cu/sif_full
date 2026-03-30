<cfset action = "RelacionAumento.cfm">
<cfset modo = "CAMBIO">
<cfset modoDet = "ALTA">

<cfif not isdefined("Form.btnNuevo") and not isdefined("Form.btnNuevoD")>
	<cftry>
		<cfif isdefined("Form.btnAgregar")>
			<cfquery name="chkExists" datasource="#Session.DSN#">
				select 1
				from RHEAumentos
				where RHAfdesde = convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAfdesde#">, 103)
			</cfquery>
			<cfif chkExists.recordCount GT 0>
				<cfset msg = "Este lote de aumentos salariales ya ha sido registrado.">
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#">
				<cfabort>
			</cfif>

			<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
				declare @lote int
				
				select @lote = isnull(max(RHAlote)+1, 1) from RHEAumentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			
				insert RHEAumentos (Ecodigo, RHAlote, Usucodigo, RHAfecha, RHAfdesde, RHAestado)
				select
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					@lote, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					getDate(),
					convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAfdesde#">, 103), 
					0
				
				select @@identity as RHAid
			</cfquery>
			<cfset Form.RHAid = ABC_Aumento.RHAid>
			<cfset modo = "CAMBIO">
			<cfset modoDet = "ALTA">

		<cfelseif isdefined("Form.btnAgregarD")>
			<cfquery name="chkExists1" datasource="#Session.DSN#">
				select 1
				from RHEAumentos a, DatosEmpleado b, LineaTiempo c
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and a.Ecodigo = b.Ecodigo 
				and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">
				and b.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">
				and b.DEid = c.DEid
				and a.RHAfdesde between c.LTdesde and c.LThasta
			</cfquery>
			<cfif chkExists1.recordCount EQ 0>
				<cfset msg = "El empleado no se encuentra nombrado.">
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#">
				<cfabort>
			</cfif>

			<cfquery name="chkExists2" datasource="#Session.DSN#">
				select 1
				from RHDAumentos
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">
				and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">
			</cfquery>
			<cfif chkExists2.recordCount GT 0>
				<cfset msg = "El aumento salarial ya está registrado para el empleado seleccionado.">
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#">
				<cfabort>
			</cfif>

			<!--- Obtener el tipo de acción por defecto para generar una acción de aumento salarial --->
			<cfquery name="rsAccionAumento" datasource="#Session.DSN#">
				select Pvalor from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Pcodigo = 220
			</cfquery>
			<cfif rsAccionAumento.recordCount EQ 0>
				<cfset msg = "Falta definir el parámetro tipo de acción por defecto para registrar una acción de aumento salarial.">
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#">
				<cfabort>
			</cfif>

			<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
				declare @RHAlinea numeric
				
				-- Insertar Accion de Aumento Salarial
				insert RHAcciones (Ecodigo, DEid, RHTid, Tcodigo, RVid, RHJid, Dcodigo, Ocodigo, RHPid, RHPcodigo, DLfvigencia, DLsalario, DLobs, RHAporc, RHAporcsal, Usucodigo, Ulocalizacion)
				select 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionAumento.Pvalor#">, 
					lt.Tcodigo, 
					lt.RVid,
					lt.RHJid,
					lt.Dcodigo,
					lt.Ocodigo,
					lt.RHPid,
					lt.RHPcodigo,
					ra.RHAfdesde,
					lt.LTsalario,
					'Acción generada al registrar un aumento salarial',
					lt.LTporcplaza,
					lt.LTporcsal,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="-1">,
					<cfqueryparam cfsqltype="cf_sql_char" value="00">
				from RHEAumentos ra, LineaTiempo lt
				where ra.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and ra.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ra.Ecodigo = lt.Ecodigo
				and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and ra.RHAfdesde between lt.LTdesde and lt.LThasta
				select @RHAlinea = @@identity
				
				-- Insertar componentes salariales actualizados de la linea de tiempo
				insert RHDAcciones(RHAlinea, CSid, RHDAtabla, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion)
				select @RHAlinea, 
					   a.CSid, a.DLTtabla, a.DLTunidades, a.DLTmonto, a.DLTmonto, 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="-1">,
					   <cfqueryparam cfsqltype="cf_sql_char" value="00">
				from RHEAumentos ra, LineaTiempo lt, DLineaTiempo a
				where ra.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and ra.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ra.Ecodigo = lt.Ecodigo
				and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and ra.RHAfdesde between lt.LTdesde and lt.LThasta
				and a.LTid = lt.LTid
				and not exists (
				select 1
				from RHDAcciones b
				where b.RHAlinea = @RHAlinea
				and b.CSid = a.CSid
				)
				
				-- Actualizar el componente de salario base con el aumento salarial
				update RHDAcciones
				set RHDAmontobase = RHDAmontobase + <cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHDvalor#">,
				    RHDAmontores = RHDAmontores + <cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHDvalor#">
				from ComponentesSalariales c
				where RHDAcciones.RHAlinea = @RHAlinea
				and RHDAcciones.CSid = c.CSid
				and c.CSsalariobase = 1
				
				insert RHDAumentos (RHAid, NTIcodigo, DEidentificacion, RHDtipo, RHDvalor, RHAlinea)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">, 
					<cfqueryparam cfsqltype="cf_sql_bit" value="0">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHDvalor#">,
					@RHAlinea
				)
				
				select @@identity as RHDAlinea
			</cfquery>
			<cfset modo = "CAMBIO">
			<cfset modoDet = "ALTA">


		<cfelseif isdefined("Form.btnEliminar")>
			<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
				delete RHDAcciones
				from RHDAumentos a
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and RHDAcciones.RHAlinea = a.RHAlinea
			
				delete RHAcciones
				from RHDAumentos a
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and RHAcciones.RHAlinea = a.RHAlinea
				
				delete RHDAumentos
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
			
				delete RHEAumentos 
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
			</cfquery>
			<cfset modo = "ALTA">
			<cfset modoDet = "ALTA">
			<cfset action = "RelacionAumento-lista.cfm">

		<cfelseif isdefined("Form.btnEliminarD")>
			<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
				delete RHDAcciones
				from RHDAumentos a
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea#">
				and RHDAcciones.RHAlinea = a.RHAlinea
			
				delete RHAcciones
				from RHDAumentos a
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea#">
				and RHAcciones.RHAlinea = a.RHAlinea
				
				delete RHDAumentos
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea#">
			</cfquery>
			<cfset modo = "CAMBIO">
			<cfset modoDet = "ALTA">

		<cfelseif isdefined("Form.btnCambiarD")>
			<cfquery name="chkExists1" datasource="#Session.DSN#">
				select 1
				from RHEAumentos a, DatosEmpleado b, LineaTiempo c
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and a.Ecodigo = b.Ecodigo 
				and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">
				and b.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">
				and b.DEid = c.DEid
				and a.RHAfdesde between c.LTdesde and c.LThasta
			</cfquery>
			<cfif chkExists1.recordCount EQ 0>
				<cfset msg = "El empleado no se encuentra nombrado.">
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#">
				<cfabort>
			</cfif>

			<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
				update RHDAumentos
				   set RHDvalor = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHDvalor#">
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea#">
				and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
			</cfquery>
			<cfset modo = "CAMBIO">
			<cfset modoDet = "ALTA">

		</cfif>
	<cfcatch type="any">
		<cftransaction action="rollback">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>

</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<cfif modo EQ "CAMBIO" and isdefined("Form.RHAid") and Len(Trim(Form.RHAid)) NEQ 0>
		<input name="RHAid" type="hidden" value="#Form.RHAid#">
	</cfif>
	<cfif modoDet EQ "CAMBIO" and isdefined("Form.RHDAlinea") and Len(Trim(Form.RHDAlinea)) NEQ 0>
		<input name="RHDAlinea" type="hidden" value="#Form.RHDAlinea#">
	</cfif>
	<cfif isdefined("Form.btnBuscar")>
		<input name="btnBuscar" type="hidden" value="Buscar">
		<cfif isdefined("Form.DEidentificacion") and Len(Trim(Form.DEidentificacion)) NEQ 0>
			<input name="DEid" type="hidden" value="#Form.DEid#">
			<input name="NTIcodigo" type="hidden" value="#Form.NTIcodigo#">
			<input name="DEidentificacion" type="hidden" value="#Form.DEidentificacion#">
		</cfif>
	</cfif>
	<cfif action EQ "RelacionAumento.cfm">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
