<cfinclude template="../../tpid.cfm">
<cfinclude template="../../config.cfm">

<cfset TIcodigo = int(rand() * 1000000)>
<cfset numerito = int(rand() * 1000000)>
<cfoutput>
TIcodigo: #TIcodigo#<br>
numerito: #numerito#<br>
</cfoutput>

<!--- Guardar el estado del tramite: 5 = Pago complatado --->
<cfquery datasource="sdc">
	update TramitePasaporte
	set Avance     = '5',
		Pagado     = 1<!---,
		IabaD      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#IabaDestino#">,
		CBTcodigoD = <cfqueryparam cfsqltype="cf_sql_decimal" value="#CBTCodDestino.toString()#">,
		CBcodigoD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CBcodigoDestino#">,
		TIcodigo   = <cfqueryparam cfsqltype="cf_sql_decimal" value="#TIcodigo#">
		--->
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and TPID = #TPID#
</cfquery>

<cflocation url="trpass05.cfm?TPID=#TPID#&numerito=#numerito#" >