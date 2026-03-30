
<cfset filtro    = "where 1=1">


<cfif isdefined('form.filtro_Odescripcion') and len(trim(form.filtro_Odescripcion))>
	<cfset filtro = filtro & " and upper(Odescripcion) like '%#ucase(form.filtro_Odescripcion)#%'">
</cfif>
<cfif isdefined('form.filtro_DRPeriodo')and len(trim(form.filtro_DRPeriodo))>
	<cfset filtro = filtro & " and DRPeriodo=#form.filtro_DRPeriodo#">
</cfif>

<cfif isdefined('form.filtro_mes') and len(trim(form.filtro_mes)) and #form.filtro_mes# neq -1>
	<cfset filtro = filtro & " and DRMes=#form.filtro_mes#">
</cfif>	

<cfif isdefined('form.filtro_estado') and len(trim(form.filtro_estado)) and #form.filtro_estado# neq -1>
	<cfset filtro = filtro & " and DREstado=#form.filtro_estado#">
</cfif>	

<cfif isdefined('form.filtros_DRTotal')and len(trim(form.filtros_DRTotal))>
	<cfset filtro = filtro & " and DRTotal=#form.filtros_DRTotal#">
</cfif>


	<cfquery name="rsMes" datasource="#session.DSN#">
		select  -1 as value, 'Todos' as description from dual
		union all
		select  1 as value, 'Enero' as description from dual
		union all
		select  2 as value, 'Febrero' as description from dual
		union all
		select  3 as value, 'Marzo' as description from dual
		union all
		select  4 as value, 'Abril' as description from dual
		union all
		select  5 as value, 'Mayo' as description from dual
		union all
		select  6 as value, 'Junio' as description from dual
		union all
		select  7 as value, 'Julio' as description from dual
		union all
		select  8 as value, 'Agosto' as description from dual
		union all
		select  9 as value, 'Septiembre' as description from dual
		union all
		select  10 as value, 'Octubre' as description from dual
		union all
		select  11 as value, 'Noviembre' as description from dual
		union all
		select 12 as value, 'Diciembre' as description from dual
		order by 1
	</cfquery>

	<cfquery name="rsEstados" datasource="#session.DSN#">
		select  -1 as value, 'Todos' as description from dual
		union all
		select  1 as value, 'Generado' as description from dual
		union all
		select 2 as value, 'Aplicado' as description from dual
		order by 1
	</cfquery>

<cfquery name="ListaTE" datasource="#session.dsn#">
	select 
		a.DRid, 
		a.Ecodigo,
		case a.DREstado when 1 then 'Generado' when 2 then 'Aplicado' end as estado, 
		case a.DRMes when 1 then 'Enero' when 2 then 'Febrero' 
		when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio'
		when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'
		end as mes, 
		a.DRTotal, 
		a.DRPeriodo, 
		o.Odescripcion
		from EDRetenciones a
			inner join Oficinas o
				on a.Ocodigo = o.Ocodigo
				and o.Ecodigo=#session.Ecodigo# 
		#preservesinglequotes(filtro)# 
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
		<cfinvokeargument name="query" 				value="#ListaTE#"/>
		<cfinvokeargument name="desplegar" 			value="Odescripcion, DRPeriodo,mes,DRTotal,estado"/>
		<cfinvokeargument name="etiquetas" 			value="Oficina,Periodo,Mes,Total Renta,Estado"/>
		<cfinvokeargument name="formatos" 			value="V,V,V,M,S"/>
		<cfinvokeargument name="align" 				value="left,left,left,right,left"/>
		<cfinvokeargument name="formName" 			value="PagoRent"/>
		<cfinvokeargument name="checkboxes" 		value="N"/>
		<cfinvokeargument name="keys" 				value="DRid"/>
		<cfinvokeargument name="ira" 					value="DPagoRenta.cfm"/>
		<cfinvokeargument name="filtrar_por" value="Odescripcion, DRPeriodo, mes, DRTotal, estado"/>					
		<cfinvokeargument name="MaxRows" 			value="10"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="PageIndex" 			value="1"/>
		<cfinvokeargument name="mostrar_filtro" 	value="true"/>
		<cfinvokeargument name="rsestado" value="#rsEstados#"/>
		<cfinvokeargument name="rsmes" value="#rsMes#"/>
		<cfinvokeargument name="botones" 			value="Nuevo"/>
</cfinvoke>