  
<cfquery name="rsEscuela" datasource="#session.DSN#">
	Select 
		  convert(varchar,EScodigo) as EScodigo
		, convert(varchar,f.Fcodigo) as Fcodigo
		, '#session.parametros.Facultad#: ' + convert(varchar(20),Fnombre) + ', #session.parametros.Escuela#: ' + convert(varchar(20),ESnombre) as ESnombre
		, (EScodificacion + '~' + convert(varchar,EScodigo)) as EScodif_cod
		, Fnombre  as ESfacultad
		, ESnombre as ESescuela
		, (ESprefijo + '~' + convert(varchar,EScodigo)) as EScodPref_cod		
	from Facultad f, Escuela e
	where f.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 and f.Fcodigo = e.Fcodigo
	order by ESnombre
</cfquery>
