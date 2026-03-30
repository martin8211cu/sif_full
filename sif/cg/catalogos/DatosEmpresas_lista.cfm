<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select 	
		Ecodigo as Ecodigos, 
		Edescripcion 
	from Empresas
	where cliente_empresarial = #session.CEcodigo#
	order by Edescripcion
</cfquery>
<cfset navegacion = ''>
<cfinvoke 
	 component="sif.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsEmpresas#"/>
		<!--- <cfinvokeargument name="desplegar" value="DCIconsecutivo, Ddescripcion, CFformato, Odescripcion, Mnombre, Debitos, Creditos, IMGborrar"/> --->
		<cfinvokeargument name="desplegar" value="Edescripcion"/>
		<cfinvokeargument name="etiquetas" value="Empresas"/>
		<cfinvokeargument name="formatos" value=" S"/>
		<cfinvokeargument name="align" value="left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="Incluyeform" value="true">
		<cfinvokeargument name="formname" value="form1">
		<cfinvokeargument name="keys" value="Ecodigos">
		<cfinvokeargument name="irA" value="DatosEmpresas.cfm"/>
		<cfinvokeargument name="navegacion" value="#navegacion#">
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="MaxRows" value="20">
</cfinvoke>
