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
<cfif isdefined("Url.prov") and not isdefined("Form.prov")>
	<cfparam name="Form.prov" default="#Url.prov#">
</cfif>
<cfif isdefined("Url.excluir") and not isdefined("Form.excluir")>
	<cfparam name="Form.excluir" default="#Url.excluir#">
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

<cfif isdefined("Url.ECid") and not isdefined("Form.ECid")>
	<cfparam name="Form.ECid" default="#Url.ECid#">
</cfif>

<cfif isdefined("Url.ECdesc") and not isdefined("Form.ECdesc")>
	<cfparam name="Form.ECdesc" default="#Url.ECdesc#">
</cfif>

<cfset navegacion = "">
<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&desc=#form.desc#&excluir=#form.excluir#" >

<cfif isdefined("Form.prov") and Len(Trim(Form.prov)) NEQ 0>
	<cfset navegacion = navegacion & "&prov=" & Form.prov>
</cfif>

<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid)) NEQ 0>
	<cfset navegacion = navegacion & "&ECid=" & Form.ECid>
</cfif>

<cfif isdefined("Form.ECdesc") and Len(Trim(Form.ECdesc)) NEQ 0>
	<cfset navegacion = navegacion & "&ECdesc=" & Form.ECdesc>
</cfif>

<html>
<head>
<title>Lista de Contratos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
<tr>
	<td>
		<cfoutput>
			<form style="margin:0;" name="filtroContratos" method="post" action="ConlisContratos.cfm" >
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="ECid" type="text" id="codigo" size="20" maxlength="9" onClick="this.select();" value="<cfif isdefined("Form.ECid")>#Form.ECid#</cfif>">
				</td>
					
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="ECdesc" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.ECdesc")>#Form.ECdesc#</cfif>">
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
					<cfif isdefined("form.prov") and len(trim(form.prov))>
						<input type="hidden" name="prov" value="#form.prov#">
					</cfif>
					<cfif isdefined("form.excluir") and len(trim(form.excluir))>
						<input type="hidden" name="excluir" value="#form.excluir#">
					</cfif>										
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsLista" datasource="#session.DSN#">
			select ECid, ECdesc
			from EContratosCM 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			
			<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid)) >
				and ECid =  <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
			</cfif>
			<cfif isdefined("Form.ECdesc") and Len(Trim(Form.ECdesc))>
				and upper(ECdesc) like '%#trim(ucase(form.ECdesc))#%'
			</cfif>
			<cfif isdefined("form.prov") and len(trim(form.prov))>
				and SNcodigo =  <cfqueryparam value="#form.prov#" cfsqltype="cf_sql_numeric">
			</cfif>
			order by  ECid, ECdesc
		</cfquery>

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="ECid, ECdesc"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripción"/>
			<cfinvokeargument name="formatos" value="V, V"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisContratos.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="ECid, ECdesc"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>
