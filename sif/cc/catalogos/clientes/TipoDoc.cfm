<cf_templateheader title="	Administración del Sistema">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Catálogo de Documentos Solicitados para Clientes'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td colspan="3" valign="top">
					<cfinclude template="../../../portlets/pNavegacionCC.cfm">
				</td>
			  </tr>
				<cfif isdefined("Url.TDdescripcion") and not isdefined("form.TDdescripcion")>
					<cfset form.TDdescripcion = Url.TDdescripcion>
				</cfif>
					<cfset ffiltro = "">
					<cfset navegacion = "">
			  <tr valign="top"> 
				<td valign="top" width="50%"> 
				<cfinclude template="filtroTipoDoc.cfm">
				<cfif isdefined("form.fTDdescripcion") and len(trim(form.fTDdescripcion)) NEQ 0>
					<cfset ffiltro = ffiltro & " and upper(TDdescripcion) like '%" & Ucase(trim(form.fTDdescripcion)) & "%'">
					<cfset navegacion = navegacion & "&TDdescripcion=#form.fTDdescripcion#">
				</cfif>
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="ClienteDetallistaTipoDoc a"/>
					<cfinvokeargument name="columnas" value="TDid, TDdescripcion"/>
					 <cfinvokeargument name="desplegar" value="TDdescripcion"/>
					 <cfinvokeargument name="etiquetas" value="Documento"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="CEcodigo=#session.CEcodigo# #ffiltro# order by  TDdescripcion"/>
					<cfinvokeargument name="align" value=" left "/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="TipoDoc.cfm"/>
					<cfinvokeargument name="keys" value="TDid"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="MaxRows" value="30"/>
				  </cfinvoke> </td>
				<td valign="top" width="5%">&nbsp;</td>
				<td width="50%" valign="top" ><cfinclude template="formTipoDoc.cfm"></td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
		</table>
	 <cf_web_portlet_end>
<cf_templatefooter>