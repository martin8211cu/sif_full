<cfif isDefined("url.id_apariencia") and len(url.id_apariencia) neq 0 and url.id_apariencia NEQ 0>
	<cfset form.id_apariencia = url.id_apariencia></cfif><cf_templateheader title="Dominios">	
	
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Plantillas">
	<cfinclude template="/home/menu/pNavegacion.cfm">    <table border="0">
	<tr><td valign="top">
	
	<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet">
	<cfinvokeargument name="conexion" value="asp"/>
	<cfinvokeargument name="tabla" value="MSApariencia"/>
	<cfinvokeargument name="columnas" value="id_apariencia,descripcion,template"/>
	<cfinvokeargument name="desplegar" value="descripcion,template"/>
	<cfinvokeargument name="etiquetas" value="Descripcion,Plantilla"/>
	<cfinvokeargument name="formatos" value="V, V"/>
	<cfinvokeargument name="filtro" value=" 1=1 order by upper(descripcion)" />
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="Nuevo" value=""/>
	<cfinvokeargument name="irA" value=""/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys" value="id_apariencia"/>
	</cfinvoke>
	</td><td valign="top">
	<cfinclude template="apariencia-form.cfm">
	</td></tr>
	</table>
	
	<cf_web_portlet_end>
			<cf_templatefooter>
