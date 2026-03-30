<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Tramites Personales 
</cf_templatearea>

<cf_templatearea name="body">
<cf_templatecss>



<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de Identificaci&oacute;n'>
	<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr>
		<td valign="top">
			<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
		</td>
	</tr>
	<tr> 
		<td valign="top" width="50%">
			<form style="margin: 0%" name="filtro" method="post">
				<cfoutput>
				<table  border="0" width="100%" class="areaFiltro" >
					<tr> 
						<td>C&oacute;digo:</td>
						<td>Descripci&oacute;n:</td>
						<td></td>
					</tr>
					<tr> 
						<td><input type="text" name="fcodigo_tipoident" style="text-transform:uppercase;"  maxlength="10" size="10" value="<cfif isdefined("form.fcodigo_tipoident")>#fcodigo_tipoident#</cfif>"></td>
						<td><input type="text" name="fnombre_tipoident"  maxlength="30" size="30" value="<cfif isdefined("form.fnombre_tipoident")>#fnombre_tipoident#</cfif>"></td>
						<td align="right">
						<input type="button" name="btnNuevo" value="Nuevo" onClick="javascript: nuevo();">
						<input type="submit" name="btnFiltrar" value="Filtrar">
						<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript: limpiar();"> </td>
					</tr>
				</table>
				</cfoutput>
			</form>
			<cfset comdicion =" where ">	
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select codigo_tipoident, nombre_tipoident,id_tipoident 
				from TPTipoIdent  
				<cfif isdefined("form.fcodigo_tipoident") and len(trim(form.fcodigo_tipoident))>
					  #comdicion# upper (codigo_tipoident) like upper('%#trim(form.fcodigo_tipoident)#%')
					  <cfset comdicion =" and ">	
				</cfif>
				<cfif isdefined("form.fnombre_tipoident") and len(trim(form.fnombre_tipoident))>
					#comdicion# upper(nombre_tipoident) like upper('%#trim(form.fnombre_tipoident)#%')
					<cfset comdicion =" and ">
				</cfif>
				order by codigo_tipoident
			</cfquery>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="codigo_tipoident, nombre_tipoident"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="form_method" value="get"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="tipo-identificacion-tabs.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_tipoident"/>
			</cfinvoke>
		</td>
	  </tr>
	<tr> 
		<td>&nbsp;</td>
		
	</tr> 
	</table>
<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>
<script language="javascript" type="text/javascript">
function limpiar(){
	document.filtro.fcodigo_tipoident.value = ' ';
	document.filtro.fnombre_tipoident.value = ' ';
}
function nuevo(){
	location.href='tipo-identificacion-tabs.cfm';
}
</script>
