<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Agendas por Servicios
</cf_templatearea>

<cf_templatearea name="body">
<cf_templatecss>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Instituciones'>
	<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr>
		<td colspan="2" valign="top">
			<cfinclude template="/home/menu/pNavegacion.cfm">
		</td>
	</tr>
	<tr> 
		<td valign="top" width="100%">
			<form style="margin: 0%" name="filtro" method="post">
				<cfoutput>
				<table  border="0" width="100%" class="areaFiltro" >
					<tr> 
						<td width="1%" align="right"><strong>C&oacute;digo&nbsp;</strong></td>
						<td><input type="text" name="fcodigo_inst"  maxlength="10" size="10" value="<cfif isdefined("form.fcodigo_inst")>#fcodigo_inst#</cfif>"></td>
						<td width="1%" align="right"><strong>Descripci&oacute;n&nbsp;</strong></td>
						<td><input type="text" name="fnombre_inst"  maxlength="30" size="30" value="<cfif isdefined("form.fnombre_inst")>#fnombre_inst#</cfif>"></td>
						<td colspan="2" align="right">
							<input type="submit" name="btnFiltrar" value="Filtrar">
							<input type="button" name="btnLimpiar" value="Limpiar" onClick="javasript: limpiar();"> 
						</td>
					</tr>
				</table>
				</cfoutput>
			</form>
			<cfset comdicion =" where ">	
			<cfquery name="rsListaInst" datasource="#session.tramites.dsn#">
				select id_inst,codigo_inst,nombre_inst  
				from TPInstitucion  
				<cfif isdefined("form.fcodigo_inst") and len(trim(form.fcodigo_inst))>
					  #comdicion# upper (codigo_inst) like upper('%#trim(form.fcodigo_inst)#%')
					  <cfset comdicion =" and ">	
				</cfif>
				<cfif isdefined("form.fnombre_inst") and len(trim(form.fnombre_inst))>
					#comdicion# upper(nombre_inst) like upper('%#trim(form.fnombre_inst)#%')
					<cfset comdicion =" and ">
				</cfif>
				order by codigo_inst
			</cfquery>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsListaInst#"/>
				<cfinvokeargument name="desplegar" value="codigo_inst,nombre_inst"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="listaServSuc.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_inst"/>
			</cfinvoke>
		</td>
	</tr>
	</table>
	<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>
<script language="javascript" type="text/javascript">
function limpiar(){
	document.filtro.fcodigo_inst.value = ' ';
	document.filtro.fnombre_inst.value = ' ';
}
</script>
