<cfset filtro    = "where 1=1 ">

<cfif isdefined('form.Filtro_TEVcodigo') and len(trim(form.Filtro_TEVcodigo))>
	<cfset filtro = filtro & " and upper(TEVcodigo) like '%#ucase(form.Filtro_TEVcodigo)#%'">
</cfif>

<cfif isdefined('form.Filtro_TEVDescripcion') and len(trim(form.Filtro_TEVDescripcion))>
	<cfset filtro = filtro & " and upper(TEVDescripcion) like '%#ucase(form.Filtro_TEVDescripcion)#%'">
</cfif>	

<cfquery name="ListaTE" datasource="#session.dsn#">
	select TEVid , TEVcodigo, TEVDescripcion 
	from TipoEvento
	#preservesinglequotes(filtro)#
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
		<cfinvokeargument name="query" 				value="#ListaTE#"/>
		<cfinvokeargument name="desplegar" 			value="TEVcodigo, TEVDescripcion"/>
		<cfinvokeargument name="etiquetas" 			value="Codigo,Descripcion"/>
		<cfinvokeargument name="formatos" 			value="S,S"/>
		<cfinvokeargument name="align" 				value="left,left"/>
		<cfinvokeargument name="formName" 			value="TipoEvent"/>
		<cfinvokeargument name="checkboxes" 		value="N"/>
		<cfinvokeargument name="keys" 				value="TEVid"/>
		<cfinvokeargument name="ira" 					value="TiposEventos.cfm"/>
		<cfinvokeargument name="MaxRows" 			value="10"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="PageIndex" 			value="1"/>
		<cfinvokeargument name="mostrar_filtro" 	value="true"/>
		<cfinvokeargument name="botones" 			value="Nuevo"/>
		
</cfinvoke>