<cfquery name="rsComponentes" datasource="#Session.DSN#">
	select a.CSid, a.CSdescripcion, a.CSusatabla, a.CSsalariobase,
		   <cfif LvarNegociado EQ 1>
		   'Monto Fijo' as Comportamiento,
		   <cfelse>
		   case a.CSusatabla 
		   when 0 then 'Monto Fijo' 
		   when 1 then 'Usa Tabla' 
		   when 2 then 'Usa Método de Cálculo'
		   when 3 then 'Usa Regla'
		   when 4 then 'Usa Método de Cálculo y Regla'
		   else '' end as Comportamiento,
		   </cfif>
		   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#"> as id,
		   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.sql#"> as sql,
		   #LvarEmpresa# as empresa,
		   #LvarNegociado# as negociado
	from ComponentesSalariales a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpresa#">
	<!--- El componente puede tener o no tener un metodo de calculo asociado y activo --->
	and (
		not exists (
			select 1
			from RHMetodosCalculo b
			where a.Ecodigo = b.Ecodigo
			and a.CSid = b.CSid
			and b.RHMCestadometodo = 1
		) 
		<!--- Si tiene un metodo de calculo activo, verifica que el método de cálculo este vigente --->
		or (
			exists (
				select 1
				from RHMetodosCalculo b
				where a.Ecodigo = b.Ecodigo
				and a.CSid = b.CSid
				and b.RHMCestadometodo = 1
			) and 

			exists (
				select 1
				from RHSolicitudPlaza x, RHMetodosCalculo b
				where a.Ecodigo = x.Ecodigo
				and x.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
				and a.Ecodigo = b.Ecodigo
				and a.CSid = b.CSid
				and b.RHMCestadometodo = 1
				and x.RHSPfdesde between b.RHMCfecharige and b.RHMCfechahasta
			)
		)
	) 
	<!--- Para excluir a los componentes que ya fueron agregados en la tabla --->
	and not exists (
		select 1
		from RHCSolicitud f
		where f.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		and f.CSid = a.CSid
	) 
	<!--- Para excluir a los componentes exclusivos una vez que se ha agregado uno a la tabla --->
	and not exists (
		select 1
		from RHComponentesAgrupados f, ComponentesSalariales g
		where f.RHCAid = a.CAid
		and f.RHCAmComponenteExclu = 1
		and f.Ecodigo = g.Ecodigo
		and f.RHCAid = g.CAid
		and exists (
			select 1
			from RHCMovPlaza h
			where h.RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			and h.CSid = g.CSid
		)
	)
	<cfif isdefined('form.filtroCompSal') and len(trim(form.filtroCompSal)) gt 0>
		and upper(a.CSdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.filtroCompSal)#%">
	</cfif>
	<cfif isdefined('form.filtroMetodoCS') and (len(trim(form.filtroMetodoCS)) gt 0 and form.filtroMetodoCS neq -1)>
		and a.CSusatabla = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.filtroMetodoCS#">
	</cfif>
	order by a.CScodigo, a.CSdescripcion, a.CSid
</cfquery>