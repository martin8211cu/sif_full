<cfquery datasource="#session.dsn#" name="validar_permiso">
	select coalesce(g.GAnombre, 'Sin agrupar') as GAnombre, g.GAid,
		a.AnexoId, coalesce (a.AnexoDes, 'Sin nombre') as AnexoDes
	from Anexo a
		left join AnexoGrupo g
			on g.GAid = a.GAid
		join AnexoPermisoDef pd
			on (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
			and pd.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and pd.APedit = 1
		join AnexoEm ae
			on ae.AnexoId = a.AnexoId
			and ae.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and a.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
</cfquery> 

<cfif validar_permiso.RecordCount EQ 0>
	<cf_errorCode	code = "50150" msg = "No tiene permiso de modificar este anexo.">
</cfif>

