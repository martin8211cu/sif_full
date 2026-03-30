<cfset action = "RelacionPuestos.cfm">
<cfset modo = "CAMBIO">
<cfset modoDet = "ALTA">

<cfif not isdefined("Form.btnNuevo") and not isdefined("Form.btnNuevoD")>
<cftransaction>
	<!---<cftry>--->
		<cfif isdefined("Form.btnAgregar")>
			<cfquery name="ABC_Puestos" datasource="#Session.DSN#">
				insert INTO HYERelacionValoracion (
					Ecodigo, 
					HYERVdescripcion, 
					HYERVfecha, 
					Usucodigo, 
					HYERVfechaalta, 
					HYERVestado, 
					HYERVusucodigo, 
					HYERVfechaaprueba)
				values(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.HYERVdescripcion#">,
<!---				convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.HYERVfecha#">, 103), --->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.HYERVfecha)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!---getDate(),--->
					0,
					null,
					null
				)
<!---				select @@identity as HYERVid--->
					<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_Puestos">
<!---		<cfset Form.HYERVid = ABC_Puestos.HYERVid>--->
			<cfset Form.HYERVid = ABC_Puestos.identity>		
			<cfset modo = "CAMBIO">
			<cfset modoDet = "ALTA">

		<cfelseif isdefined("Form.btnAgregarD")>
			<cfquery name="ABC_Puestos" datasource="#Session.DSN#">
				insert INTO HYDRelacionValoracion 
					(HYERVid, 
					 RHPcodigo, 
					 Ecodigo, 
					 HYLAcodigo, 
					 HYMgrado, 
					 HYIcodigo, 
					 HYHEcodigo, 
					 HYHGcodigo, 
					 HYIHgrado, 
					 HYCPgrado, 
					 HYMRcodigo, 
					 ptsHabilidad, 
					 porcSP, 
					 ptsSP, 
					 ptsResp, 
					 ptsTotal,
					 HYERVjustificacion,
					 HYHEvalor,
					 HYHGvalor,
					 HYCPvalor,
					 HYLAvalor,
					 HYMvalor,
					 HYIvalor)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYLAcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.HYMgrado#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYIcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYHEcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYHGcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.HYIHgrado#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.HYCPgrado#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYMRcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.HYTHpuntos#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.HYTSPporcentaje#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.HYTApts#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.HYTRvalor#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PtsTotales#">,
					<cfif isdefined("form.HYERVjustificacion")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.HYERVjustificacion#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYHEvalor#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYHGvalor#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYCPvalor#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYLAvalor#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYMvalor#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HYIvalor#">
				)
				
<!---				select @@identity as HYDRVlinea--->
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_Puestos">
			<cfset Form.HYDRVlinea = ABC_Puestos.identity>	<!--- ver si funciona--->
			<cfset modo = "CAMBIO">
			<cfset modoDet = "ALTA">


		<cfelseif isdefined("Form.btnEliminar")>
			<cfquery name="ABC_Puestos" datasource="#Session.DSN#">
				delete from HYDRelacionValoracion
				where HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			
				delete from HYERelacionValoracion
				where HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfset modo = "ALTA">
			<cfset modoDet = "ALTA">
			<cfset action = "RelacionPuestos-lista.cfm">

		<cfelseif isdefined("Form.btnEliminarD")>
			<cfquery name="ABC_Puestos" datasource="#Session.DSN#">
				delete from HYDRelacionValoracion
				where HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and HYDRVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYDRVlinea#">
			</cfquery>
			<cfset modo = "CAMBIO">
			<cfset modoDet = "ALTA">

		<cfelseif isdefined("Form.btnCambiarD")>
				<cf_dbtimestamp
					 datasource="#session.dsn#"
					 table="HYDRelacionValoracion"
					 redirect="RelacionPuestos.cfm"
					 timestamp="#form.ts_rversion#"
					 field1="HYERVid" type1 = "numeric" value1="#form.HYERVid#" 
					 field2="HYDRVlinea" type2="numeric" value2="#Form.HYDRVlinea#">
			<cfquery name="ABC_Puestos" datasource="#Session.DSN#">
				update HYDRelacionValoracion set 
					HYLAcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYLAcodigo#">, 
					HYMgrado 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.HYMgrado#">, 
					HYIcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYIcodigo#">, 
					HYHEcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYHEcodigo#">, 
					HYHGcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYHGcodigo#">, 
					HYIHgrado 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.HYIHgrado#">, 
					HYCPgrado 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.HYCPgrado#">, 
					HYMRcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYMRcodigo#">, 
					ptsHabilidad 	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.HYTHpuntos#">, 
					porcSP 			= <cfqueryparam cfsqltype="cf_sql_float" 	value="#Form.HYTSPporcentaje#">, 
					ptsSP 			= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.HYTApts#">, 
					ptsResp 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.HYTRvalor#">, 
					ptsTotal		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.PtsTotales#">,
					HYHEvalor 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYHEvalor#">,
					HYHGvalor 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYHGvalor#">,
					HYCPvalor 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYCPvalor#">,
					HYLAvalor 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYLAvalor#">,
					HYMvalor 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYMvalor#">,
					HYIvalor 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.HYMvalor#">
					<cfif isdefined("form.HYERVjustificacion")>
						,HYERVjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.HYERVjustificacion#">
					</cfif>
				where HYERVid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">
					and HYDRVlinea 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYDRVlinea#">
			</cfquery>
			<cfset modo = "CAMBIO">
			<cfset modoDet = "ALTA">

		<cfelseif isdefined("btnAplicar") and isdefined("Form.HYERVid") and Len(Trim(Form.HYERVid)) NEQ 0>
			<cfquery name="ABC_Puestos" datasource="#Session.DSN#">
				update RHPuestos
				set
					HYLAcodigo = a.HYLAcodigo,
					HYMgrado = a.HYMgrado,
					HYIcodigo = a.HYIcodigo,
					HYHEcodigo = a.HYHEcodigo,
					HYHGcodigo = a.HYHGcodigo,
					HYIHgrado = a.HYIHgrado,
					HYCPgrado = a.HYCPgrado,
					HYMRcodigo = a.HYMRcodigo,
					ptsHabilidad = a.ptsHabilidad,
					porcSP = a.porcSP, 
					ptsSP = a.ptsSP,
					ptsResp = a.ptsResp, 
					ptsTotal = a.ptsTotal,
					HYHEvalor = a.HYHEvalor,
					HYHGvalor = a.HYHGvalor,
					HYCPvalor = a.HYCPvalor,
					HYLAvalor = a.HYLAvalor,
					HYMvalor = a.HYMvalor,
					HYIvalor = a.HYMvalor,
					HYERVjustificacion = a.HYERVjustificacion
				from HYDRelacionValoracion a
				where RHPuestos.RHPcodigo = a.RHPcodigo
				and RHPuestos.Ecodigo = a.Ecodigo
				and a.HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">
			</cfquery>
			
			<cfquery name="ABC_Puestos" datasource="#Session.DSN#">				
				update HYERelacionValoracion
				set HYERVestado = 1
				where HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">
			</cfquery>
			<cfset modo = "ALTA">
			<cfset modoDet = "ALTA">
			<cfset action = "RelacionPuestos-lista.cfm">

		</cfif>
	<!---<cfcatch type="any">
		<cftransaction action="rollback">
		<cfset Regresar = "/cfmx/rh/nomina/operacion/RelacionPuestos.cfm?HYERVid=" & Form.HYERVid>
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>--->
</cftransaction>
</cfif>

<cfoutput>
	<form action="#action#" method="post" name="sql">
		<cfif modo EQ "CAMBIO" and isdefined("Form.HYERVid") and Len(Trim(Form.HYERVid)) NEQ 0>
			<input name="HYERVid" type="hidden" value="#Form.HYERVid#">
		</cfif>
		<cfif modoDet EQ "CAMBIO" and isdefined("Form.HYDRVlinea") and Len(Trim(Form.HYDRVlinea)) NEQ 0>
			<input name="HYDRVlinea" type="hidden" value="#Form.HYDRVlinea#">
		</cfif>
		<cfif action EQ "RelacionPuestos.cfm">
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
