<cfquery name="ERR" datasource="#session.dsn#">
	select 
	d.ACcodigodesc 	as Codigo, 
	d.ACdescripcion as Descripcion, 
	d.ACvutil 		as VidaUtil, 
	d.ACcatvutil 	as AsignarVidaUtil,
	d.ACmascara 	as Mascara, 
	d.cuentac 		as ComplementoparaInversión,
	d.ACmetododep 	as Metodo
	  from ACategoria d
	  where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  <cfif isdefined ('url.ACcodigo')>
	   and ACcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACcodigo#">
	  </cfif>
</cfquery>