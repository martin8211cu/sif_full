<!--- 
	SQL	Encabezado Registro de Nomina
	Recibe de la pantalla los siguientes valores:
		-Tcodigo, CBcc, Mcodigo, ERNfdeposito, ERNfinicio, ERNffin, ERNdescripcion
	Asigna valores a los siguientes campos:
		-ERNid, Ecodigo, ERNfcarga, ERNestado, Usucodigo, Ulocalizacion, ERNsistema

	SQL Detalle Registro de Nomina
	Recibe de la pantalla los siguientes valores:
		-NTIcodigo, DRIdentificacion, CBcc, Mcodigo, DRNnombre, DRNapellido1, DRNapellido2, DRNtipopago, DRNperiodo, 
		DRNnumdias, DRNotrasdeduc, DRNliquido, DRNpuesto, DRNocupacion, DRNotrospatrono, DRNinclexcl ,DRNfinclexcl
	Asigna valores a los siguientes campos:
		-DRNlinea, ERNid, DRNsalbruto, DRNsaladicional, DRNreintegro, DRNrenta, DRNobrero, DRNpatrono
--->
<cfif isDefined("Form.DNuevo")>
	<cfset modo = "CAMBIO">
	<cfset dmodo = "ALTA">
</cfif>
<cfif not isDefined("Form.Nuevo") and not isDefined("Form.DNuevo")>
	<cftry>
		<cfset modo = "ALTA">
		<cfset dmodo = "ALTA">
		<cfquery name="rsOperRNomina" datasource="#Session.DSN#">
			set nocount on
			<cfif Form.Accion eq "Alta">
				
				insert into ERNomina 
				(
					--ERNid, Identity
					Ecodigo, ERNfcarga, ERNestado, Usucodigo, Ulocalizacion, ERNsistema, ERNcapturado,
					Tcodigo, CBcc, Mcodigo, ERNfdeposito, ERNfinicio, ERNffin, ERNdescripcion
				)				
				values
				(
					--ERNid,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					getdate(), 
					1,--captura manual 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
					0,--No es generado por el sistema de Nomina
					1,--Capturado Manual
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CBcc#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNfdeposito,'YYYYMMDD')#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNfinicio,'YYYYMMDD')#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNffin,'YYYYMMDD')#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ERNdescripcion#">
				)
				
				select convert(varchar,@@identity) as ERNid
				<cfset modo = "CAMBIO">
				
			<cfelseif Form.Accion eq "Cambio">
				
				update ERNomina
				set Tcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">, 
					CBcc=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CBcc#">, 
					Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
					ERNfdeposito=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNfdeposito,'YYYYMMDD')#">, 
					ERNfinicio=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNfinicio,'YYYYMMDD')#">, 
					ERNffin=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNffin,'YYYYMMDD')#">, 
					ERNdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ERNdescripcion#">
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
				and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				
				<cfset modo = "CAMBIO">
				
			<cfelseif Form.Accion eq "Baja">

				delete from DRNomina
				where ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
				
				delete from ERNomina
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
				
			<cfelseif Form.Accion eq "AltaDetalle">
						
				<cfif Form.ModificarE eq "true">

					update ERNomina
					set Tcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">, 
						CBcc=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CBcc#">, 
						Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
						ERNfdeposito=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNfdeposito,'YYYYMMDD')#">, 
						ERNfinicio=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNfinicio,'YYYYMMDD')#">, 
						ERNffin=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNffin,'YYYYMMDD')#">, 
						ERNdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ERNdescripcion#">
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
					and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				</cfif>

				insert into DRNomina
				(
					--DRNlinea,	
					ERNid, DRNsalbruto, DRNsaladicional, DRNreintegro, DRNrenta, DRNobrero, DRNpatrono,
					NTIcodigo, DRIdentificacion, CBcc, Mcodigo, DRNnombre, DRNapellido1, DRNapellido2, DRNtipopago, DRNperiodo, 
					DRNnumdias, DRNotrasdeduc, DRNliquido, DRNpuesto, DRNocupacion, DRNotrospatrono
					<cfif isDefined("Form.DRNinclexcl") and Form.DRNinclexcl neq "">
						,DRNinclexcl ,DRNfinclexcl
					</cfif>
				)
				values
				(
					--DRNlinea, Identity
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">,0.00,0.00,0.00,0.00,0.00,0.00,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DRIdentificacion#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRNCBcc#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRNMcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DRNnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DRNapellido1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DRNapellido2#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRNtipopago#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.DRNperiodo,'YYYYMMDD')#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DRNnumdias#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DRNotrasdeduc#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DRNliquido#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRNpuesto#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRNocupacion#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DRNotrospatrono#">
					<cfif isDefined("Form.DRNinclexcl") and Form.DRNinclexcl neq "">
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DRNinclexcl#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.DRNfinclexcl,'YYYYMMDD')#">
					</cfif>
				)
				
				<cfset modo = "CAMBIO">
				
			<cfelseif Form.Accion eq "CambioDetalle">

				<cfif Form.ModificarE eq "true">

					update ERNomina
					set Tcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">, 
						CBcc=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CBcc#">, 
						Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
						ERNfdeposito=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNfdeposito,'YYYYMMDD')#">, 
						ERNfinicio=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNfinicio,'YYYYMMDD')#">, 
						ERNffin=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ERNffin,'YYYYMMDD')#">, 
						ERNdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ERNdescripcion#">
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
					and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				</cfif>

				update DRNomina
					set NTIcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">,
					DRIdentificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DRIdentificacion#">,
					CBcc=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRNCBcc#">, 
					Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRNMcodigo#">, 
					DRNnombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DRNnombre#">,
					DRNapellido1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DRNapellido1#">,
					DRNapellido2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DRNapellido2#">,
					DRNtipopago=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRNtipopago#">,
					DRNperiodo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.DRNperiodo,'YYYYMMDD')#">, 
					DRNnumdias=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DRNnumdias#">, 
					DRNotrasdeduc=<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DRNotrasdeduc#">,
					DRNliquido=<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DRNliquido#">,
					DRNpuesto=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRNpuesto#">,
					DRNocupacion=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRNocupacion#">,
					DRNotrospatrono=<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DRNotrospatrono#">
					<cfif isDefined("Form.DRNinclexcl") and Form.DRNinclexcl neq "">
						,DRNinclexcl=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DRNinclexcl#">
						,DRNfinclexcl=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.DRNfinclexcl,'YYYYMMDD')#">
					</cfif>
				where ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
				and DRNlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRNlinea#">
				and ts_rversion = convert(varbinary,#lcase(Form.DRNtimestamp)#)

				<cfset modo = "CAMBIO">
			
			<cfelseif Form.Accion eq "BajaDetalle">

				delete from DRNomina
				where ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
				and DRNlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRNlinea#">
				
				<cfset modo = "CAMBIO">
				
			<cfelseif Form.Accion eq "Listo">

				update ERNomina
				set ERNestado = 2--listo para verificar
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
				and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/cfmx/sif/errorPages/BDerror.cfm">
	</cfcatch>
	</cftry>
</cfif>
<form action="<cfif modo neq "ALTA">RNomina.cfm<cfelse>listaRNomina.cfm</cfif>" method="post" name="SQLform">
<cfif not isDefined("Form.Nuevo") and Form.Accion neq "Baja">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isDefined("modo")>#modo#</cfif>">
		<input name="dmodo" type="hidden" value="<cfif isDefined("dmodo")>#dmodo#</cfif>">
		<input name="ERNid" type="hidden" value="<cfif isDefined("rsOperRNomina.ERNid")>#rsOperRNomina.ERNid#<cfelseif isDefined("Form.ERNid")>#Form.ERNid#</cfif>">
	</cfoutput>
</cfif>
</form>

<!---
<form action="RNomina.cfm" method="post" name="SQLform">
		<input name="modo" type="hidden" value="CAMBIO">
		<input name="dmodo" type="hidden" value="CAMBIO">
		<input name="ERNid" type="hidden" value="35">
		<input name="DRNlinea" type="hidden" value="130">
</form>
--->
<html>
<head>
<title>Registro de N&oacute;mina</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<script language="JavaScript" type="text/javascript">document.SQLform.submit();</script>
</body>
</html>