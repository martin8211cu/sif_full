 exists (
	select * from DirectorEscuela de 
	 where de.EScodigo = e.EScodigo
	   and de.DIpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ppersona#">
		 )
