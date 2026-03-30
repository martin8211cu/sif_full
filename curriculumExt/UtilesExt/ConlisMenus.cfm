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
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.excluir") and not isdefined("Form.excluir")>
	<cfparam name="Form.excluir" default="#Url.excluir#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.codigo#.value = codigo;
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->

<cfif isdefined("Url.id_root") and not isdefined("Form.id_root")>
	<cfparam name="Form.id_root" default="#Url.id_root#">
</cfif>

<cfif isdefined("Url.nombre_menu") and not isdefined("Form.nombre_menu")>
	<cfparam name="Form.nombre_menu" default="#Url.nombre_menu#">
</cfif>

<!---<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#" >--->

<cfset navegacion = "">
<cfif isdefined("Form.id_root") and Len(Trim(Form.id_root)) NEQ 0>
	<cfset navegacion = navegacion & "&id_root=" & Form.id_root>
</cfif>

<cfif isdefined("Form.nombre_menu") and Len(Trim(Form.nombre_menu)) NEQ 0>
	<cfset navegacion = navegacion & "&nombre_menu=" & Form.nombre_menu>
</cfif>

<html>
<head>
<title>Menus</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
<tr>
	<td>
		<cfoutput>
			<form style="margin:0;" name="filtroMenus" method="post" action="ConlisMenus.cfm" >
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
				<td align="right"><strong>Posición</strong></td>
				<td> 
					<input name="id_root" type="text" id="codigo" size="20" maxlength="9" onClick="this.select();" value="<cfif isdefined("Form.id_root")>#Form.id_root#</cfif>">
				</td>
					
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="nombre_menu" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.nombre_menu")>#Form.nombre_menu#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.id") and len(trim(form.id))>
						<input type="hidden" name="id" value="#form.id#">
					</cfif>
					<cfif isdefined("form.codigo") and len(trim(form.codigo))>
						<input type="hidden" name="codigo" value="#form.codigo#">
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
		<cfquery name="rsLista" datasource="asp">
		select id_root, id_menu, nombre_menu, orden_menu, case when ocultar_menu=1 then 'X' else ' ' end as ocultar_x
		from SMenu
		where 1=1
		<!---and id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">--->
			
			<cfif isdefined("Form.id_root") and Len(Trim(Form.id_root)) >
				and id_root = form.id_root
			</cfif>
			<cfif isdefined("Form.nombre_menu") and Len(Trim(Form.nombre_menu))>
				and upper(nombre_menu) like '%#trim(ucase(form.nombre_menu))#%'
			</cfif>
											
			order by id_root, nombre_menu
		</cfquery>

		<cfinvoke 
		 component="pListasEXT"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="id_root, nombre_menu"/>
			<cfinvokeargument name="etiquetas" value="Posici&oacute;n, Men&uacute;"/>
			<cfinvokeargument name="formatos" value="V, V"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisMenus.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="id_menu, id_root, nombre_menu"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>
