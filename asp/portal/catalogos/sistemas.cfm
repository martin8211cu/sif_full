<cfif isDefined("url.SScodigo")>
	<cfset form.SScodigo = url.SScodigo></cfif>
<cfif isDefined("url.Pagina")>
	<cfset form.Pagina = url.Pagina></cfif><cf_templateheader title="Mantenimiento de Sistemas">
	<cf_web_portlet_start titulo="Mantenimiento de Sistemas">
		<cfinclude template="frame-header.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr><td colspan="2"><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
		  <tr>
		    <td valign="top" align="center">&nbsp;</td>
		    <td valign="top" align="center">&nbsp;</td>
	      </tr>
		  <tr>
			<td width="50%" valign="top" align="left">
				<cfinvoke
				 component="commons.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="SSistemas a"/>
					<cfinvokeargument name="columnas" value="SSorden, rtrim(a.SScodigo) as SScodigo, a.SSdescripcion"/>
					<cfinvokeargument name="desplegar" value="SSorden, SScodigo, SSdescripcion"/>
					<cfinvokeargument name="etiquetas" value="Orden, Código, Descripción del Sistema"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="1=1 order by SSorden, SScodigo, SSdescripcion"/>
					<cfinvokeargument name="align" value="right, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="sistemas.cfm"/>
					<cfinvokeargument name="maxRows" value="20"/>
					<cfinvokeargument name="keys" value="SScodigo"/>
					<cfinvokeargument name="conexion" value="asp"/>
					<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
				</cfinvoke>
			</td>
			<td valign="top" align="center">
				<cfinclude template="sistemas-form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
