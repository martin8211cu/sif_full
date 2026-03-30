<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.tc_tipo") and not isdefined("Form.tc_tipo")>
	<cfparam name="Form.nombre_tc_tipo" default="#Url.nombre_tc_tipo#">
</cfif>

<cfif isdefined("Url.nombre_tipo_tarjeta") and not isdefined("Form.nombre_tipo_tarjeta")>
	<cfparam name="Form.nombre_tipo_tarjeta" default="#Url.nombre_tipo_tarjeta#">
</cfif>

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&desc=#form.desc#" >

<cfif isdefined("Form.tc_tipo") and Len(Trim(Form.tc_tipo)) NEQ 0>
	<cfset navegacion = navegacion & "&tc_tipo=" & Form.tc_tipo>
</cfif>

<cfif isdefined("Form.nombre_tipo_tarjeta") and Len(Trim(Form.nombre_tipo_tarjeta)) NEQ 0>
	<cfset navegacion = navegacion & "&nombre_tipo_tarjeta=" & Form.nombre_tipo_tarjeta>
</cfif>

<html>
<head>
<title>Lista de Tipos de Tarjetas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<!---<tr><td><table width="100%"><tr><td class="tituloMantenimiento" align="center"><font size="2">Conceptos de Servicio</font></td></tr></table></td></tr>--->
	<tr><td>
		<cfoutput>
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="tc_tipo" type="text" id="id" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.tc_tipo")>#Form.tc_tipo#</cfif>">
				</td>
				<td> 
					<input name="nombre_tipo_tarjeta" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.nombre_tipo_tarjeta")>#Form.nombre_tipo_tarjeta#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.id") and len(trim(form.id))>
						<input type="hidden" name="id" value="#form.id#">
					</cfif>
					<cfif isdefined("form.desc") and len(trim(form.desc))>
						<input type="hidden" name="desc" value="#form.desc#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsLista" datasource="aspsecure">
		select tc_tipo, nombre_tipo_tarjeta 
		 from TipoTarjeta 
		 where 1=1
        
		 <cfif isdefined("Form.tc_tipo") and Len(Trim(Form.tc_tipo)) >
          and  upper(tc_tipo) like '%#trim(ucase(form.tc_tipo))#%'
          </cfif>
          <cfif isdefined("Form.nombre_tipo_tarjeta") and Len(Trim(Form.nombre_tipo_tarjeta))>
        and upper(nombre_tipo_tarjeta) like '%#trim(ucase(form.nombre_tipo_tarjeta))#%'
          </cfif>
     	 order by tc_tipo, nombre_tipo_tarjeta
			
			<!---select tc_tipo, nombre_tipo_tarjeta
			from aspsecure..TipoTarjeta--->
		</cfquery>

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="tc_tipo, nombre_tipo_tarjeta"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Nombre"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisTiposTarjetas.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="tc_tipo,nombre_tipo_tarjeta"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>