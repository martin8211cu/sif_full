<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Tramites Personales - D&iacute;as Feriados
</cf_templatearea>

<cf_templatearea name="body">
<cf_templatecss>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='D&iacute;as Feriados'>
	<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr>
		<td colspan="3" valign="top">
			<cfinclude template="/home/menu/pNavegacion.cfm">
		</td>
	</tr>
	<tr> 
		<td valign="top" width="40%">
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select fecha, descripcion 
				from TPFeriados
				order by fecha
			</cfquery>

			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="fecha, descripcion"/>
				<cfinvokeargument name="etiquetas" value="Fecha, Descripci&oacute;n"/>
				<cfinvokeargument name="formatos" value="D,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="feriados.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="fecha"/>
			</cfinvoke>
		</td>
		<td valign="top">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td valign="top"><cfinclude template="feriados-form.cfm"></td>
	</tr>
	<tr> 
		<td colspan="3">&nbsp;</td>
	</tr> 
	</table>
	<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>