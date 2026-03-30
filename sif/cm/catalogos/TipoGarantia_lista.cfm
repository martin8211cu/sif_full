<cfset filtro    = "where Ecodigo = #Session.Ecodigo# ">
<cfif isdefined('form.Filtro_TGcodigo') and len(trim(form.Filtro_TGcodigo))>
	<cfset filtro = filtro & " and upper(TGcodigo) like '%#ucase(form.Filtro_TGcodigo)#%'">
</cfif>
<cfif isdefined('form.Filtro_TGdescripcion') and len(trim(form.Filtro_TGdescripcion))>
	<cfset filtro = filtro & " and upper(TGdescripcion) like '%#ucase(form.Filtro_TGdescripcion)#%'">
</cfif>	
<cfif isdefined('form.Filtro_TGtipo') and form.Filtro_TGtipo NEQ -1>
	<cfset filtro = filtro & " and TGtipo = #form.Filtro_TGtipo#">
</cfif>	
<cfif isdefined('form.Filtros_TGporcentaje') and form.Filtros_TGporcentaje NEQ -1>
	<cfset filtro = filtro & " and TGporcentaje = #form.Filtros_TGporcentaje#">
</cfif>	

<cfquery name="rsTGtipo" datasource="#session.DSN#">
	select '-1' as value, '-- Todos -- ' as description from dual
	union all
	select '1' as value, 'Participación' as description from dual
	union all
	select '2' as value, 'Cumplimiento' as description from dual
	order by 1
</cfquery>


<cfquery name="Lista" datasource="#session.dsn#">
	select TGid , TGcodigo, TGdescripcion, TGporcentaje,
    case when  TGtipo = 1  then 'Participación' 
	     when  TGtipo  = 2 then 'Cumplimiento' 
		 else '' end as TGtipo					
	from TiposGarantia
	#preservesinglequotes(filtro)#
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
		<cfinvokeargument name="query" 				value="#Lista#"/>
		<cfinvokeargument name="desplegar" 			value="TGcodigo, TGdescripcion, TGtipo,TGporcentaje"/>
		<cfinvokeargument name="etiquetas" 			value="Codigo,Descripcion,Tipo,Porcentaje"/>
		<cfinvokeargument name="formatos" 			value="S,S,S,U"/>
		<cfinvokeargument name="align" 				value="left,left,left,left"/>
		<cfinvokeargument name="formName" 			value="ValoreVariables"/>
		<cfinvokeargument name="checkboxes" 		value="N"/>
		<cfinvokeargument name="keys" 				value="TGid"/>
		<cfinvokeargument name="ira" 					value="TipoGarantia.cfm"/>
		<cfinvokeargument name="MaxRows" 			value="10"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="PageIndex" 			value="1"/>
		<cfinvokeargument name="mostrar_filtro" 	value="true"/>
		<cfinvokeargument name="rsTGtipo" 	   	 value="#rsTGtipo#"/>
</cfinvoke>
