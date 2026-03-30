<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Tr&aacute;mites
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tr&aacute;mites">

		<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
			<cfset form.id_tramite = url.id_tramite >
		</cfif>

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
			<tr><td>
			<form style="margin: 0%" name="filtro" method="post">
				<cfoutput>
				<table  border="0" width="100%" class="areaFiltro" >
					<tr> 
						<td>C&oacute;digo:&nbsp;
						  	<input type="text" name="fcodigo_tramite"  maxlength="10" size="10" value="<cfif isdefined("form.fcodigo_tramite")>#fcodigo_tramite#</cfif>"></td>
						<td>Descripci&oacute;n:&nbsp;
							<input type="text" name="fnombre_tramite"  maxlength="30" size="30" value="<cfif isdefined("form.fnombre_tramite")>#fnombre_tramite#</cfif>"></td>
						<td align="right">
                          <input type="button" name="btnListar" value="Imprimir" onClick="javascript: listado();">					    	
                          <input type="submit" name="btnFiltrar" value="Filtrar">
							<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript: limpiar();">
					  <input type="button" name="btnNuevo" value="Nuevo Trámite" onClick="javasript: nuevo();">					  </td>
					</tr>
				</table>
				</cfoutput>
			</form>
			</td></tr>
			<tr><td>
				<cfset comdicion =" where ">	
				<cfquery name="rsLista" datasource="#session.tramites.dsn#">
					select id_tramite, codigo_tramite, nombre_tramite ,'1' as tab
					from TPTramite
					<cfif isdefined("form.fcodigo_tramite") and len(trim(form.fcodigo_tramite))>
						  #comdicion# upper (codigo_tramite) like upper('%#trim(form.fcodigo_tramite)#%')
						  <cfset comdicion =" and ">	
					</cfif>
					<cfif isdefined("form.fnombre_tramite") and len(trim(form.fnombre_tramite))>
						#comdicion# upper(nombre_tramite) like upper('%#trim(form.fnombre_tramite)#%')
						<cfset comdicion =" and ">
					</cfif>					
					order by 2, 3
				</cfquery>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="codigo_tramite, nombre_tramite"/>
					<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
					<cfinvokeargument name="formatos" value="V,V"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="tramites.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="id_tramite,tab"/>
				</cfinvoke>
			</td></tr>
		</table>
	<cf_web_portlet_end>
</cf_templatearea>
</cf_template>
<script language="javascript" type="text/javascript">
function limpiar(){
	document.filtro.fcodigo_tramite.value = ' ';
	document.filtro.fnombre_tramite.value = ' ';
}
function nuevo(){
	document.filtro.action = "tramites.cfm";
	document.filtro.submit()
}
function listado(){
	location.href='../Consultas/tramites.cfr';
}
</script>
