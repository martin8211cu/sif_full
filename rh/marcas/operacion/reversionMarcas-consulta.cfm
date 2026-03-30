<cfquery name="rsLista" datasource="#session.dsn#" maxrows="50">
	select distinct a.DEid, a.CAMid, 
		b.DEidentificacion as Identificacion,
		{fn concat(b.DEapellido1, {fn concat(' ', {fn concat(b.DEapellido2, {fn concat(' ', {fn concat(b.DEnombre,'')})})})})} as NombreCompleto,
		a.CAMfdesde as Fecha,
		CAMgeneradoporferiado  as Feriado,
		CAMpermiso as Permiso
	from RHCMCalculoAcumMarcas a
		inner join DatosEmpleado b
		on b.DEid = a.DEid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.CAMestado = 'A'
		and not exists (
			select 1 from RCalculoNomina x, IncidenciasCalculo y
			where x.Ecodigo = a.Ecodigo
			and x.RCestado <> 0
		 	and y.RCNid = x.RCNid
			and (y.Iid = a.CAMhniid
			or y.Iid = a.CAMhriid
			or y.Iid = a.CAMheaiid
			or y.Iid = a.CAMhebiid
			or y.Iid = a.CAMferiid)
		)
		and exists (
			select 1 
			from Incidencias v
			where (v.Iid = a.CAMhniid
			or v.Iid = a.CAMhriid
			or v.Iid = a.CAMheaiid
			or v.Iid = a.CAMhebiid
			or v.Iid = a.CAMferiid)
		)
		<cfif isdefined("form.FDEid") and len(trim(form.FDEid))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FDEid#">
		</cfif>
		<cfif isdefined("form.Filtro_Fecha") and len(trim(form.Filtro_Fecha)) and not isdefined('form.Filtro_FechasMayores')>
			and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.Filtro_Fecha)#"> 
		<cfelseif isdefined("form.Filtro_Fecha") and len(trim(form.Filtro_Fecha)) and isdefined('form.Filtro_FechasMayores')>
			and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.Filtro_Fecha)#"> 
		</cfif>
		<cfif isdefined('form.Filtro_Identificacion') and LEN(TRIM(form.Filtro_Identificacion))>
			and upper(rtrim( <cf_dbfunction name="to_char" args="b.DEidentificacion"> )) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.Filtro_Identificacion))#%">
		</cfif>
		<cfif isdefined('form.Filtro_NombreCompleto') and LEN(TRIM(form.Filtro_NombreCompleto))>
		 	and upper(rtrim( <cf_dbfunction name="to_char" args="{fn concat(b.DEapellido1, {fn concat(' ', {fn concat(b.DEapellido2, {fn concat(' ', b.DEnombre)})})})}">)) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.Filtro_NombreCompleto))#%">
		</cfif>
		<cfif isdefined('form.Filtro_ImgPermiso') and form.Filtro_ImgPermiso NEQ -1>
			and a.CAMgeneradoporferiado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Filtro_ImgFeriado#">
		</cfif>
		<cfif isdefined('form.Filtro_ImgPermiso') and form.Filtro_ImgPermiso NEQ -1>
			and a.CAMpermiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Filtro_ImgPermiso#">
		</cfif>
	order by b.DEidentificacion, a.CAMfdesde
</cfquery>
