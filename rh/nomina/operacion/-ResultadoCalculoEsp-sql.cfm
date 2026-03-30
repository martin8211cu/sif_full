<cfsetting requesttimeout="3600">

<!---
<cfdump var="#Form#">
<cfdump var="#Session#">
<cfabort>
--->
<cfset Acciones = ''>
<cfif isDefined("Form.chk") or isDefined("Form.butRecalcular") or isDefined("Form.butRestaurar")>
<cftry>
	<cfif isDefined("Form.butRestaurar")>
		<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
			datasource="#session.dsn#"
			Ecodigo = "#Session.Ecodigo#"
			RCNid = "#Form.RCNid#"
			Tcodigo = "#Form.Tcodigo#"
			Usucodigo = "#Session.Usucodigo#"
			Ulocalizacion = "#Session.Ulocalizacion#"
			pDEid = "#Form.DEid#" />
		<cfset Acciones = "Restaurar">
	<cfelseif isDefined("Form.chk")>
		<cfset vchk = ListToArray(Form.chk)>
		<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
			<cfset dato = ListToArray(vchk[i],'|')>
			<cfif dato[1] eq 'I'>
			<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
				delete from IncidenciasCalculo
				where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
			</cfquery>
			
			<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
				update SalarioEmpleado set SEcalculado = 0
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
			</cfquery>

				<cfset Acciones = Acciones & 'Elimna Incidencia:' & dato[2] & ', '>
			<cfelseif dato[1] eq 'C'>
				<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					delete from CargasCalculo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
					and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
				</cfquery>

				<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					update SalarioEmpleado set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
				</cfquery>
				
				<cfset Acciones = Acciones & 'Elimna Carga:' & dato[2] & ', '>
			<cfelseif dato[1] eq 'D'>
				<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					delete from DeduccionesCalculo
					where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
					and RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>
				
				<cfquery name="ABC_Resultado" datasource="#Session.DSN#">				
					update SalarioEmpleado set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
				</cfquery>
				<cfset Acciones = Acciones & 'Elimna Deduccion:' & dato[2] & ', '>
			</cfif>
		</cfloop>
			


		<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina"
			datasource="#session.dsn#"
			Ecodigo = "#Session.Ecodigo#"
			RCNid = "#Form.RCNid#"
			Usucodigo = "#Session.Usucodigo#"
			Ulocalizacion = "#Session.Ulocalizacion#" />
		<cfset Acciones = Acciones & 'Recalcular.'>
	<cfelseif isDefined("Form.butRecalcular")>
		<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina"
			datasource="#session.dsn#"
			Ecodigo = "#Session.Ecodigo#"
			RCNid = "#Form.RCNid#"
			Usucodigo = "#Session.Usucodigo#"
			Ulocalizacion = "#Session.Ulocalizacion#" />
		<cfset Acciones = Acciones & 'Recalcular.'>
	</cfif>
<cfcatch type="any">
	<cfinclude template="/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
</cfif>

<form action="ResultadoCalculoEsp.cfm" method="post" name="sql">
	<cfoutput>
		<input name="RCNid" type="hidden" value="#Form.RCNid#">
		<input name="DEid" type="hidden" value="#Form.DEid#">
		<input type="hidden" name="Tcodigo" value="#Form.Tcodigo#">
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>


<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>

<!---
<cfoutput>#Acciones#</cfoutput>
<cfdump var="#Form#">
<a href="javascript:document.forms[0].submit();">Continuar</a>
--->
</body>
</HTML>
