<cftransaction>
<cfquery datasource="#session.dsn#" name="rsForm">
		select
		GELtipo,TESBid,GELfecha,Mcodigo,CFid,GELdescripcion,GELtipoCambio,GELnumero
		,GELreembolso
		from GEliquidacion a	
		where a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		and a.GELtipo	= 7
</cfquery>

<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="EnviarAprobarLiquidacion" returnVariable="rs">
	<cfinvokeargument name="TESBid" 			 	value="#rsForm.TESBid#">
	<cfinvokeargument name="GELfecha" 	 	value="#rsForm.GELfecha#">
	<cfinvokeargument name="Mcodigo" 				value="#rsForm.Mcodigo#"> 	
	<cfinvokeargument name="CFid" 					value="#rsForm.CFid#">
	<cfinvokeargument name="GELreembolso" 	value="#rsForm.GELreembolso#">
	<cfinvokeargument name="GELtipo" value="#rsForm.GELtipo#">  
	<cfinvokeargument name="GELdescripcion" 	    value="#rsForm.GELdescripcion#"> 
	<cfinvokeargument name="GELtipoCambio"	value="#rsForm.GELtipoCambio#">
	<cfinvokeargument name="GELnumero"	value="#rsForm.GELnumero#">
	<cfinvokeargument name="GELid"  	 	value="#form.GELid#"> 
</cfinvoke>

<cfquery datasource="#session.dsn#" name="rsUpdate">
		Update  GEliquidacion 
		set GELestado=<cfqueryparam cfsqltype="cf_sql_numeric" value="2">,
		TESSPid=#rs#
		where GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">		
</cfquery>

</cftransaction>