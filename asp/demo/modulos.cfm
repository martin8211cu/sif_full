<cfquery datasource="asp">
	insert INTO ModulosCuentaE(CEcodigo, SScodigo, SMcodigo)
	select #cuenta.identity#, a.SScodigo, b.SMcodigo
	from SSistemas a, SModulos b
	where a.SScodigo = b.SScodigo
	and a.SScodigo in ('SIF','RH', 'OTROS', 'UTIL')
	and not exists (
		select 1
		from ModulosCuentaE c
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta.identity#">
		and c.SScodigo = b.SScodigo
		and c.SMcodigo = b.SMcodigo
	)
</cfquery>