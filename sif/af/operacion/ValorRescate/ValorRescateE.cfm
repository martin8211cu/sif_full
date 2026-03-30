<cfquery name="ERR" datasource="#session.dsn#">
	select 	
			a.Aplaca			as PLACA_ACTIVO,
			d.AFTDtipo			as TIPO_RELACION,
			d.AFTDvalrescate	as NUEVO_VALOR,
			d.AFTDdescripcion	as NUEVA_DESCRIPCION,
			<cf_dbfunction name="to_date00" args="d.AFTDfechainidep"> as FECHA_DEPRECIOACION
	  from AFTRelacionCambioD d
	  		inner  join Activos a
				on d.Aid=a.Aid
				and d.Ecodigo=a.Ecodigo
	   where d.Ecodigo	=#session.Ecodigo#
	   and d.AFTRid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AFTRid#">
</cfquery>	
