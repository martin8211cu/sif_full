<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Tramites Personales 
</cf_templatearea>

<cf_templatearea name="body">
<cf_templatecss>



<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de Requisitos'>
	<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr>
		<td colspan="2" valign="top">
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
						<td><input type="text" name="fcodigo_tiporeq" maxlength="10" size="10" value="<cfif isdefined("form.fcodigo_tiporeq")>#fcodigo_tiporeq#</cfif>"></td>
						<td><input type="text" name="fnombre_tiporeq"  maxlength="30" size="30" value="<cfif isdefined("form.fnombre_tiporeq")>#fnombre_tiporeq#</cfif>"></td>
						<td align="right"><input type="submit" name="btnFiltrar" value="Filtrar"></td>
						<td align="left"><input type="button" name="btnLimpiar" value="Limpiar" onClick="javasript: limpiar();"> </td>
					</tr>
				</table>
				</cfoutput>
			</form>
			<cfset comdicion =" where ">	
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select codigo_tiporeq, nombre_tiporeq,id_tiporeq 
				from TPTipoReq  
				<cfif isdefined("form.fcodigo_tiporeq") and len(trim(form.fcodigo_tiporeq))>
					  #comdicion# upper (codigo_tiporeq) like upper('%#trim(form.fcodigo_tiporeq)#%')
					  <cfset comdicion =" and ">	
				</cfif>
				<cfif isdefined("form.fnombre_tiporeq") and len(trim(form.fnombre_tiporeq))>
					#comdicion# upper(nombre_tiporeq) like upper('%#trim(form.fnombre_tiporeq)#%')
					<cfset comdicion =" and ">
				</cfif>
				order by codigo_tiporeq
			</cfquery>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="codigo_tiporeq, nombre_tiporeq"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="Tp_TpoRequisitos.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_tiporeq"/>
			</cfinvoke>
		</td>
		<td valign="top"><cfinclude template="Tp_TpoRequisitos-form.cfm"></td>
	</tr>
	<tr> 
		<td colspan="2">&nbsp;</td>
		
	</tr> 
	</table>
	<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>
<script language="javascript" type="text/javascript">
function limpiar(){
	document.filtro.fcodigo_tiporeq.value = ' ';
	document.filtro.fnombre_tiporeq.value = ' ';
}
</script>