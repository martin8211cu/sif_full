<cfif (isdefined("Form.chk"))>
	<cfset datos = ListToArray(Form.chk)>
	<cfloop from="1" to="#ArrayLen(datos)#" index="idx">
		<cfquery name="GenerarIncidencias" datasource="#Session.DSN#">
			insert Incidencias(DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion)	
			select b.DEid, b.CIid, b.CFid, b.Ifecha, b.Ivalor, b.Ifechasis,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, b.Ulocalizacion
			from IncidenciasMarcas b
			where b.RetenerPago = 0
				and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
		</cfquery>

		<cfquery name="GenerarIncidenciasHistorico" datasource="#Session.DSN#">
			insert HIncidenciasMarcas(DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis,
									  Usucodigo, Ulocalizacion, BMUsucodigo, Iespecial, 
									  RCNid, RetenerPago, JustificacionNoPago, RHCMid, RHPMid, RHDMid)							
			select 
				b.DEid, b.CIid, b.CFid, b.Ifecha, b.Ivalor, b.Ifechasis,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, b.Ulocalizacion,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, b.Iespecial,
				b.RCNid, b.RetenerPago, b.JustificacionNoPago, b.RHCMid, b.RHPMid, b.RHDMid
			from IncidenciasMarcas b
				where b.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
		</cfquery>		

 		<cfquery name="EliminarRegIncidenciasMarcas" datasource="#Session.DSN#">
			delete from IncidenciasMarcas
			where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
		</cfquery>
	</cfloop>
</cfif>	

<form action="AutPagoHora.cfm" method="post" name="sql">
	<cfoutput>
		<input name="inc_generada" type="hidden" value="1"> 	
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>

