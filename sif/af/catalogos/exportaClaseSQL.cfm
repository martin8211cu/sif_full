<cfquery name="ERR" datasource="#session.dsn#">
	select distinct
	a.ACcodigodesc as Código,
	d.ACcodigodesc as Descripcion_Codigo,
	d.ACdescripcion as Descripcion,
	d.ACvutil as Vida_Util,
	d.ACdepreciable as Depreciable,
	d.ACrevalua as Revalua,
	d.ACtipo as Tipo,
	d.ACvalorres as Valor_Recidual,
	
	((
	select min(CFformato)
	 from CFinanciera where Ccuenta = d.ACcsuperavit
	))as Superavit,
		
	((
	select min(CFformato) 
	 from CFinanciera where Ccuenta = d.ACcadq
	))as Adquisición,
		
	((
	select min(CFformato)
	 from CFinanciera where Ccuenta = d.ACcdepacum
	 ))as Depresiación_Acumulada,
		
	((
	select min(CFformato)
	 from CFinanciera where Ccuenta = d.ACcrevaluacion
	))as Revaluación,
		
	((
	select min(CFformato)
	 from CFinanciera where Ccuenta = d.ACcdepacumrev
	))as Compl_dep_acumrevaluacion,
	
	d.ACgastodep as Compl_Depreciación,
	d.ACgastorev as Compl_Revaluación,
	d.cuentac as Cuenta,
	d.ACgastoret as Compl_Gasto_Retiro,
	d.ACingresoret as Compl_Ingreso_Retiro
	<cfif isdefined ('url.ACNegarMej')>
	,d.ACNegarMej
	</cfif>
	  from AClasificacion d
	  	inner join ACategoria a
		on a.Ecodigo = d.Ecodigo
		and a.ACcodigo = d.ACcodigo
		
	  where d.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  <cfif isdefined ('url.ACcodigo')>
	   and d.ACcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACcodigo#">
	  </cfif>
</cfquery>	