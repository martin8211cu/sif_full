<cftransaction>
	<cfquery datasource="#session.dsn#" name="rsForm">
		select
			GEAtipo,TESBid,GEAfechaPagar,Mcodigo,GEAtotalOri,
			GEAnumero,CFid,CFcuenta,GEAdescripcion,GEAdesde,GEAhasta,GEAmanual
			from GEanticipo a	
				 where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and a.GEAid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
				   and a.GEAtipo	= 6
	</cfquery>

	<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="EnviarAprobarSolicitud" returnVariable="rsAnti">
		<cfinvokeargument name="GEAtipo" 			value="#rsForm.GEAtipo#">
		<cfinvokeargument name="TESBid" 			value="#rsForm.TESBid#"> 
		<cfinvokeargument name="GEAfechaPagar" 		value="#rsForm.GEAfechaPagar#"> 
		<cfinvokeargument name="Mcodigo" 			value="#rsForm.Mcodigo#"> 			
		<cfinvokeargument name="GEAtotalOri" 		value="#rsForm.GEAtotalOri#"> 		
		<cfinvokeargument name="CFid" 				value="#rsForm.CFid#"> 
		<cfinvokeargument name="CFcuenta"  			value="#rsForm.CFcuenta#"> 			
		<cfinvokeargument name="GEAdescripcion" 	value="#rsForm.GEAdescripcion#"> 
		<cfinvokeargument name="GEAdesde"  			value="#LSDateFormat(rsForm.GEAdesde,'dd/mm/yyyy')#"> 
		<cfinvokeargument name="GEAhasta"  			value="#LSDateFormat(rsForm.GEAhasta,'dd/mm/yyyy')#"> 
		<cfinvokeargument name="GEAmanual"  		value="#rsForm.GEAmanual#">
		<cfinvokeargument name="GEAnumero"  		value="#form.GEAnumero#">
		<cfinvokeargument name="ConTransaccion" 	value="false"> 
		<cfinvokeargument name="GEAid"  			value="#form.GEAid#"> 
	</cfinvoke>
	
	<cfquery datasource="#session.dsn#" name="rsUpdate">
		Update  GEanticipo 
		set GEAestado=<cfqueryparam cfsqltype="cf_sql_numeric" value="1">,
		TESSPid=#rsAnti#
		where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
	</cfquery>
</cftransaction>