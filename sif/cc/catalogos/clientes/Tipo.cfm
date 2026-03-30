<cf_templateheader title="Administraci&oacute;n del Sistema">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Catálogo de Categorías para Clientes'>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3" valign="top">
			<cfinclude template="../../../portlets/pNavegacionCC.cfm">
		</td>
	  </tr>
		
		<cfif isdefined("Url.CDTdescripcion") and not isdefined("form.CDTdescripcion")>
			<cfset form.CDTdescripcion = Url.CDTdescripcion>
		</cfif>
		<cfset ffiltro = "">
		<cfset navegacion = "">
	  <tr valign="top"> 
		<td valign="top" width="50%"> 
		<cfinclude template="filtroTipo.cfm">
		
		<cfif isdefined("form.fCDTdescripcion") and len(trim(form.fCDTdescripcion)) NEQ 0>
			<cfset ffiltro = ffiltro & " and upper(CDTdescripcion) like '%" & Ucase(trim(form.fCDTdescripcion)) & "%'">
			<cfset navegacion = navegacion & "&CDTdescripcion=#form.fCDTdescripcion#">
		</cfif>
		
		<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="ClienteDetallistaTipo a"/>
			<cfinvokeargument name="columnas" value="CDTid, CDTdescripcion"/>
			 <cfinvokeargument name="desplegar" value="CDTdescripcion"/>
			 <cfinvokeargument name="etiquetas" value="Categor&iacute;a"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="CEcodigo=#session.CEcodigo# #ffiltro# order by  CDTdescripcion"/>
			<cfinvokeargument name="align" value=" left "/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="Tipo.cfm"/>
			<cfinvokeargument name="keys" value="CDTid"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="MaxRows" value="30"/>
		  </cfinvoke> </td>
		<td valign="top" width="5%">&nbsp;</td>
		<td width="50%" valign="top" ><cfinclude template="formTipo.cfm"></td>
	  </tr>
	  <tr> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	</table>
	<cf_web_portlet_end>

	<cf_templatefooter>