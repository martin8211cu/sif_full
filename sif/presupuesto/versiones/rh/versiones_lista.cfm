<cfset session.versiones.formular = "RH">
<cfif isdefined("url.FCVtipo") and len(url.FCVtipo) and not isdefined("form.FCVtipo")><cfset form.FCVtipo = url.FCVtipo></cfif>
<cfif isdefined("url.FCPPid") and len(url.FCPPid) and not isdefined("form.FCPPid")><cfset form.FCPPid = url.FCPPid></cfif>
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr><td>&nbsp;</td></tr>
<tr>
  <td>
		<cfinclude template="/sif/presupuesto/versiones/versiones_lista_filtro.cfm">
		<cfinclude template="/sif/presupuesto/versiones/qry_lista.cfm">
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
			<cfinvokeargument name="query" value="#qry_lista#">
			<cfinvokeargument name="cortes" value="Vtipo,PDescripcion">
			<cfinvokeargument name="desplegar" value="CVdescripcion, Vestado, Mensaje"/>
			<cfinvokeargument name="etiquetas" value="Descripci&oacute;n,Escenario, "/>
			<cfinvokeargument name="formatos" value="S, S, S"/>
			<cfinvokeargument name="align" value="left, left, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value=""/>
			<cfinvokeargument name="keys" value="CVid"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="maxrows" value="10"/>
		<cfif session.versiones.formular EQ "V">
			<cfinvokeargument name="botones" value="Nuevo"/>
		</cfif>
			<cfinvokeargument name="width" value="70%"/>
		</cfinvoke>	
	</td>
</tr>
</table>
<cfset session.versiones.formular = "V">
