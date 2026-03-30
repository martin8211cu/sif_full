<cfparam name="form.recargo" default="false">
<cfquery name="rsComponentes" datasource="#Session.DSN#">
	select a.CSid, a.CSdescripcion, a.CSusatabla, a.CSsalariobase,
		   <cfif LvarNegociado EQ 1>
		   'Monto Fijo' as Comportamiento,
		   <cfelse>
		   case a.CSusatabla when 0 then 'Monto Fijo' when 1 then 'Usa Tabla' when 2 then 'Usa Método de Cálculo' else '' end as Comportamiento,
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
				from RHAcciones x, RHMetodosCalculo b
				where coalesce(x.EcodigoRef, x.Ecodigo) = a.Ecodigo
				and x.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
				and b.Ecodigo = a.Ecodigo
				and b.CSid = a.CSid
				and b.RHMCestadometodo = 1
				and x.DLfvigencia between b.RHMCfecharige and b.RHMCfechahasta
			)
		)
	) 
	<!--- Para excluir a los componentes que ya fueron agregados en la tabla --->
	and not exists (
		select 1
		from RHDAcciones f
		where f.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
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
			from RHDAcciones h
			where h.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			and h.CSid = g.CSid
		)
	)
	<!---Para determinar y excluir o presentar componentes de recargo de funciones--->
	<cfif isdefined("Form.recargo") and Form.recargo>
		and a.CSid in (
			select distinct x.CSid
			from RHPlazasComponentes x
			where x.Ecodigo = #session.Ecodigo#
			)
	<cfelse>
		and a.CSid not in (
			select distinct x.CSid
			from RHPlazasComponentes x
			where x.Ecodigo = #session.Ecodigo#
			)
	</cfif>	
	order by a.CScodigo, a.CSdescripcion, a.CSid
</cfquery>


