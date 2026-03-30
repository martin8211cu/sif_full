<cfif not isdefined("Form.Nuevo")>

	<cftransaction>
		<cftry>
			<cfif isdefined("Form.Alta")>
				<cfquery name="ABC_Horario" datasource="#Session.DSN#">
					if not exists( select * from Horario
						where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
						and HOdia = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.HOdia#">
						and HOinicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HOinicio1#.#Form.HOinicio2#" scale="2">
					)
					insert Horario(Ccodigo, HOdia, HOinicio, AUcodigo, HOfinal)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.HOdia#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HOinicio1#.#Form.HOinicio2#" scale="2">,
						<cfif Form.AUcodigo EQ 0>null<cfelse><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AUcodigo#"></cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HOfinal1#.#Form.HOfinal2#" scale="2">
					)
				</cfquery>
			
			<cfelseif isdefined("Form.Cambio")>
				<cfquery name="ABC_Horario" datasource="#Session.DSN#">
					update Horario
					   set HOfinal=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HOfinal1#.#Form.HOfinal2#" scale="2">,
					       AUcodigo=<cfif Form.AUcodigo EQ 0>null<cfelse><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AUcodigo#"></cfif>
					where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
					and HOdia = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.HOdia#">
					and HOinicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HOinicio#" scale="2">
				</cfquery>
			
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="ABC_Horario" datasource="#Session.DSN#">
					delete Horario
					where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
					and HOdia = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.HOdia#">
					and HOinicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HOinicio#" scale="2">
				</cfquery>
			
			</cfif>
		
		<cfcatch type="any">
			<cftransaction action="rollback">
			<cfinclude template="../../errorpages/BDerror.cfm">
			<cfabort>
			
		</cfcatch>
		</cftry>
	
	</cftransaction>
</cfif>

<cfoutput>
<form action="<cfif session.MoG EQ "G">CursoGeneracion.cfm<cfelse>CursoMantenimiento.cfm</cfif>" method="post">
	<cfif isdefined("form.CILtipoCicloDuracion")>
		<input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">	
		<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="#form.CILtipoCicloDuracion#">	
		<input type="hidden" name="PLcodigo" id="PLcodigo" value="#Form.PLcodigo#">	
		<cfif form.CILtipoCicloDuracion EQ "E">
		<input type="hidden" name="PEcodigo" id="PEcodigo" value="#Form.PEcodigo#">	
		</cfif>
		<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">	
		<input type="hidden" name="CARcodigo" id="CARcodigo" value="#Form.CARcodigo#">	
		<input type="hidden" name="GAcodigo" id="GAcodigo" value="#Form.GAcodigo#">
		<input type="hidden" name="PEScodigo" id="PEScodigo" value="#Form.PEScodigo#">	
		<input type="hidden" name="txtMnombreFiltro" id="txtMnombreFiltro" value="#Form.txtMnombreFiltro#">	
		<input type="hidden" name="Scodigo" id="Scodigo" value="#Form.Scodigo#">
		<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
	</cfif>
	<input type="hidden" name="Ccodigo" id="Ccodigo" value="#form.Ccodigo#">
	<input type="hidden" name="btnCursos" value="1">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
