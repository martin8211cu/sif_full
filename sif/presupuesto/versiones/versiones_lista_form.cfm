<cfif isdefined("url.FCVtipo") and len(url.FCVtipo) and not isdefined("form.FCVtipo")><cfset form.FCVtipo = url.FCVtipo></cfif>
<cfif isdefined("url.FCPPid") and len(url.FCPPid) and not isdefined("form.FCPPid")><cfset form.FCPPid = url.FCPPid></cfif>
<cfinclude template="qry_lista.cfm">
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
 	<cfinvokeargument name="query" value="#qry_lista#">
	<cfinvokeargument name="cortes" value="Vtipo,PDescripcion">
	<cfinvokeargument name="desplegar" value="CVdescripcion, Vestado, Mensaje"/>
	<cfinvokeargument name="etiquetas" value="Descripci&oacute;n,Estado, "/>
	<cfinvokeargument name="formatos" value="S, S, S"/>
	<cfinvokeargument name="align" value="left, left, center"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="/cfmx/sif/presupuesto/versiones/versionesComun.cfm"/>
	<cfinvokeargument name="keys" value="CVid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="maxrows" value="10"/>
<cfif session.versiones.formular EQ "V">
	<cfinvokeargument name="botones" value="Nuevo"/>
</cfif>
	<cfinvokeargument name="width" value="70%"/>
</cfinvoke>	
