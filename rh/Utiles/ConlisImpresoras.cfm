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

<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>

<cfif isdefined("Url.FAM12DES") and not isdefined("Form.FAM12DES")>
	<cfparam name="Form.FAM09DES" default="#Url.FAM09DES#">
</cfif>

<!---<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#" >--->

<cfset navegacion = "">
<cfif isdefined("Form.FAM12CODD") and Len(Trim(Form.FAM12CODD)) NEQ 0>
	<cfset navegacion = navegacion & "&FAM12CODD=" & Form.FAM12CODD>
</cfif>

<cfif isdefined("Form.FAM12DES") and Len(Trim(Form.FAM12DES)) NEQ 0>
	<cfset navegacion = navegacion & "&FAM12DES=" & Form.FAM12DES>
</cfif>

<html>
<head>
<title>Lista de Impresoras</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
<tr>
	<td>
		<cfoutput>
			<form style="margin:0;" name="filtroImpresora" method="post" action="ConlisImpresoras.cfm" >
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="FAM12CODD" type="text" id="codigo" size="20" maxlength="9" onClick="this.select();" value="<cfif isdefined("Form.FAM12CODD")>#Form.FAM12CODD#</cfif>">
				</td>
					
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="FAM12DES" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.FAM12DES")>#Form.FAM12DES#</cfif>">
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
		<cfquery name="rsLista" datasource="#session.DSN#">
			select FAM12COD, FAM12CODD, FAM12DES
			from FAM012 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			
			<cfif isdefined("Form.FAM12CODD") and Len(Trim(Form.FAM12CODD)) >
				and upper(FAM12DES) like '%#trim(ucase(form.FAM12DES))#%'
			</cfif>
			<cfif isdefined("Form.FAM12DES") and Len(Trim(Form.FAM12DES))>
				and upper(FAM12DES) like '%#trim(ucase(form.FAM12DES))#%'
			</cfif>
			
			order by FAM12CODD, FAM12DES  
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="FAM12CODD, FAM12DES"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripción"/>
			<cfinvokeargument name="formatos" value="V, V"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisImpresoras.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="FAM12COD,FAM12CODD,FAM12DES"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>
