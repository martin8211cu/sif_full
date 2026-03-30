<cfinclude template="../../tpid.cfm">

<!--- Guardar el estado del tramite: 6 = cerrado --->
<cfquery datasource="sdc">
	update TramitePasaporte
	set Avance     = '6', FechaFin = getdate()
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and TPID = #TPID#
</cfquery>

<cflocation url="../index.cfm" >