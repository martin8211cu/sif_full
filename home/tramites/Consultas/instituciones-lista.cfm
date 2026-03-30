<cfif isdefined("Url.fcodigo_inst") and Len(Trim(Url.fcodigo_inst))>
	<cfparam name="Form.fcodigo_inst" default="#Url.fcodigo_inst#">
</cfif>
<cfif isdefined("Url.fnombre_inst") and Len(Trim(Url.fnombre_inst))>
	<cfparam name="Form.fnombre_inst" default="#Url.fnombre_inst#">
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.fcodigo_inst") and Len(Trim(Form.fcodigo_inst))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fcodigo_inst=" & Form.fcodigo_inst>
</cfif>
<cfif isdefined("Form.fnombre_inst") and Len(Trim(Form.fnombre_inst))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fnombre_inst=" & Form.fnombre_inst>
</cfif>

<script language="javascript" type="text/javascript">
	function limpiar() {
		document.filtro.fcodigo_inst.value = '';
		document.filtro.fnombre_inst.value = '';
	}
</script>

<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="0">
		<tr> 
			<td valign="top" width="100%">
				<form name="filtro" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0%">
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
				</form>
				<cfquery name="rsLista" datasource="#session.tramites.dsn#">
					select a.id_inst, a.codigo_inst, a.nombre_inst  
					from TPInstitucion a
					where 1 = 1
					<cfif isdefined("form.fcodigo_inst") and len(trim(form.fcodigo_inst))>
						and upper (a.codigo_inst) like <cfqueryparam cfsqltype="cf_sql_char" value="%#trim(Ucase(form.fcodigo_inst))#%">
					</cfif>
					<cfif isdefined("form.fnombre_inst") and len(trim(form.fnombre_inst))>
						and upper (a.nombre_inst) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(Ucase(form.fnombre_inst))#%">
					</cfif>
					order by a.codigo_inst
				</cfquery>
				
				<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="codigo_inst,nombre_inst"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="id_inst"/>
					<cfinvokeargument name="maxRows" value="20"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
</cfoutput>
