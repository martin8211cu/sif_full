<!--- 
	Creado por Gustavo Fonseca Hernández.
	Fecha: 8-6-2005.
	Motivo: Creación del tag para los beneficiarios.
 --->
 
<!--- parametros para llamado del conlis --->


<!---  
<cfdump var="#form#">
<cf_dump var="#url#">--->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>

<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>



<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo, desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		
		if (window.opener.funcLimpia#form.id#) {window.opener.funcLimpia#form.id#()}
		window.opener.document.#form.formulario#.#form.codigo#.focus();
		</cfoutput>
		window.close();
	}
}
</script>
<!--- if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()} --->

<!--- Filtro --->
<cfif isdefined("Url.TESBeneficiarioId") and not isdefined("Form.TESBeneficiarioId")>
	<cfparam name="Form.TESBeneficiarioId" default="#Url.TESBeneficiarioId#">
</cfif>
<cfif isdefined("Url.TESBeneficiario") and not isdefined("Form.TESBeneficiario")>
	<cfparam name="Form.TESBeneficiario" default="#Url.TESBeneficiario#">
</cfif>
<cfif isdefined("Url.TESBid") and not isdefined("Form.TESBid")>
	<cfparam name="Form.TESBid" default="#Url.TESBid#">
</cfif>

<cfset filtro = "">
<cfset descripcion = "Beneficiarios" >

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#" >
<cfif isdefined("Form.TESBeneficiarioId") and Len(Trim(Form.TESBeneficiarioId)) NEQ 0>
	<cfset filtro = filtro & " and upper(TESBeneficiarioId) like '%" & UCase(Form.TESBeneficiarioId) & "%'">
	<cfset navegacion = navegacion & "&TESBeneficiarioId=" & Form.TESBeneficiarioId>
</cfif>
<cfif isdefined("Form.TESBeneficiario") and Len(Trim(Form.TESBeneficiario)) NEQ 0>
 	<cfset filtro = filtro & " and upper(TESBeneficiario) like '%" & UCase(Form.TESBeneficiario) & "%'">
	<cfset navegacion = navegacion & "&TESBeneficiario=" & Form.TESBeneficiario>
</cfif>

<html>
<head>
<title>Lista de <cfoutput>#descripcion#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">

	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisBeneficiarios.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Identificaci&oacute;n:</strong></td>
				<td> 
					<input name="TESBeneficiarioId" type="text" id="codigo" size="20" maxlength="20" onClick="this.select();" value="<cfif isdefined("Form.TESBeneficiarioId")>#Form.TESBeneficiarioId#</cfif>">
				</td>
				<td align="right"><strong>Nombre:</strong></td>
				<td> 
					<input name="TESBeneficiario" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.TESBeneficiario")>#Form.TESBeneficiario#</cfif>">
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
			select TESBid, TESBeneficiarioId, TESBeneficiario
			from TESbeneficiario
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
			  		#preserveSingleQuotes(filtro)#
            and TESBactivo = 1
			order by TESBeneficiarioId
			
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="TESBeneficiarioId, TESBeneficiario"/>
			<cfinvokeargument name="etiquetas" value="Identificación, Nombre"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisBeneficiarios.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="TESBid, TESBeneficiarioId, TESBeneficiario"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>