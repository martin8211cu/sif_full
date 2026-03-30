 <cfif form.PAcodigo EQ "" OR isdefined("form.btnLista") and form.btnLista NEQ "">
	<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
		<cfinclude template="paquete_form.cfm">
		<cfexit> 
	</cfif>
<cfelse>
	<cfparam name="form.modo" default="CAMBIO">
	<cfinclude template="paquete_form.cfm">
	<cfexit> 
</cfif>

<cfinvoke component="aspAdmin.Componentes.pListasASP" 
		  method="pLista" 
		  returnvariable="pListaTiposIdentif">
	<cfinvokeargument name="tabla" value="Paquete"/>
	<cfinvokeargument name="columnas" value="
		convert(varchar,PAcodigo) as PAcodigo
		, PAcod
		, PAdescripcion
		, null as btnLista"/>
	<cfinvokeargument name="desplegar" value="PAcod, PAdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Paquete, Nombre"/>
	<cfinvokeargument name="formatos"  value=""/>
	<cfinvokeargument name="filtro" value=""/>
	<cfinvokeargument name="align" value="left,left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="keys" value="PAcodigo"/>
	<cfinvokeargument name="irA" value="paquete.cfm"/>
	<cfinvokeargument name="botones" value="Nuevo"/>
	<cfinvokeargument name="formName" value="form_listaPaquetes"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
</cfinvoke>				