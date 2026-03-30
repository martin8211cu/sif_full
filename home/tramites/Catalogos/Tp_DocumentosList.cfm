
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Documentos
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Documentos">

		<cfif isdefined("url.id_documento") and not isdefined("form.id_documento")>
			<cfset form.id_documento = url.id_documento >
		</cfif>

		<cfquery name="rstipos" datasource="#session.tramites.dsn#">
			SELECT id_tipodoc ,codigo_tipodoc ,nombre_tipodoc
			FROM TPTipoDocumento
		</cfquery>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
			<tr><td>
			<form style="margin: 0%" name="filtro" method="post">
				<cfoutput>
				<table  border="0" width="100%" class="areaFiltro" >
					<tr> 
						<td>C&oacute;digo:&nbsp;
						  	<input type="text" name="fcodigo_documento"  maxlength="10" size="10" value="<cfif isdefined("form.fcodigo_documento")>#fcodigo_documento#</cfif>"></td>
						<td>Descripci&oacute;n:&nbsp;
							<input type="text" name="fnombre_documento"  maxlength="30" size="30" value="<cfif isdefined("form.fnombre_documento")>#fnombre_documento#</cfif>"></td>
						<td>Tipo:&nbsp;
							<select name="fid_tipodoc">
								<option value="-1">Todas</option>
								<cfloop query="rstipos">
									<option value="#rstipos.id_tipodoc#" <cfif isdefined('form.fid_tipodoc') and form.fid_tipodoc eq rstipos.id_tipodoc>selected</cfif>>#rstipos.codigo_tipodoc#-#rstipos.nombre_tipodoc#</option>
								</cfloop>
							</select></td>
						<td align="right" width="1%">
					    	<input type="submit" name="btnFiltrar" value="Filtrar">
						</td>
						<td width="1%">	
							<input type="button" name="btnLimpiar" value="Limpiar" onClick="javasript: limpiar();">
						</td>
					    <td width="1%"><input type="button" name="btnNuevo" value="Nuevo" onClick="javascript:location.href='Tp_Documentos.cfm'"></td>
					    <td width="1%"><input type="button" name="btnImprimir" value="Imprimir" onClick="javascript:location.href='../Consultas/documentos.cfm'"></td>
					</tr>
				</table>
				</cfoutput>
			</form>
			</td></tr>
			<tr><td>
				<cfset comdicion =" and ">	
				<cfquery name="rsLista" datasource="#session.tramites.dsn#">
					select id_documento, a.id_tipodoc, nombre_tipodoc, codigo_documento, nombre_documento ,'1' as tab 
					from TPDocumento  a , TPTipoDocumento b 
					where a.id_tipodoc = b.id_tipodoc
					  and a.es_tipoident = 0
					<cfif isdefined("form.fcodigo_documento") and len(trim(form.fcodigo_documento))>
						  #comdicion# upper (codigo_documento) like upper('%#trim(form.fcodigo_documento)#%')
						  <cfset comdicion =" and ">	
					</cfif>
					<cfif isdefined("form.fnombre_documento") and len(trim(form.fnombre_documento))>
						#comdicion# upper(nombre_documento) like upper('%#trim(form.fnombre_documento)#%')
						<cfset comdicion =" and ">
					</cfif>
					<cfif isdefined("form.fid_tipodoc") and len(trim(form.fid_tipodoc)) and form.fid_tipodoc neq '-1'>
						#comdicion#  a.id_tipodoc= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fid_tipodoc#">
						<cfset comdicion =" and ">
					</cfif>
					order by nombre_tipodoc, codigo_documento
				</cfquery>
				<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="codigo_documento,nombre_documento"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="Tp_Documentos.cfm"/>
					<cfinvokeargument name="cortes" value="nombre_tipodoc"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="id_documento,tab" />
				</cfinvoke>
			</td></tr>
			<tr>
				<td align="center">
					<input type="button" name="btnNuevo" value="Nuevo Documento" onClick="javasript: nuevo();">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
</cf_templatearea>
</cf_template>
<script language="javascript" type="text/javascript">
function limpiar(){
	document.filtro.fcodigo_documento.value = ' ';
	document.filtro.fnombre_documento.value = ' ';
	document.filtro.fid_tipodoc.value = ' ';
	
}

function nuevo(){
	document.filtro.action = "Tp_Documentos.cfm";
	document.filtro.submit()
}
</script>
