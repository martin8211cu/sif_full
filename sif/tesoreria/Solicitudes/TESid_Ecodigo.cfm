<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbInicializaCatalogos">

<cfquery name="rsTES" datasource="#session.dsn#">
	Select e.TESid, t.EcodigoAdm
	  from TESempresas e
	  	inner join Tesoreria t
			on t.TESid = e.TESid
	 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif rsTES.recordCount EQ 0>
	<cfset Request.Error.Backs = 1>
	<cf_errorCode	code = "50798" msg = "ESTA EMPRESA NO HA SIDO INCLUIDA EN NINGUNA TESORERÍA">
</cfif>
<cfset session.Tesoreria.TESid = rsTES.TESid>
<cfset session.Tesoreria.EcodigoAdm = rsTES.EcodigoAdm>

