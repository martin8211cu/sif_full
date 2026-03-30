<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 08 de marzo del 2006
	Motivo: Se agregó un focus, cuado asigna los datos a los campos para q no se perdiera en la navegacion.

 --->

<!--- Modificado por: 	Rodolfo Jimenez Jara 	--->
<!--- Fecha: 		  	12/05/2005 		   		--->
<!--- Obs: 		  		se agregó 	a rsLista 
						and SNinactivo = 0 		--->

<!--- 

	Modificado por: Ana Villavicencio
	Fecha: 22 de setiembre del 2005	
	Motivo: el campo SNumero del filtro solo aceptaba 10 digitos, se puso en 20.
	
 --->

	<!--- codigo --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Codigo"
		Default="C&oacute;digo"
		xmlfile="/rh/generales.xml"		
		returnvariable="vCodigo"/>		

	<!--- descripcion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Descripcion"
		Default="Descripci&oacute;n"
		xmlfile="/rh/generales.xml"		
		returnvariable="vDescripcion"/>		

	<!--- Filtrar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Filtrar"
		Default="Filtrar"
		xmlfile="/rh/generales.xml"		
		returnvariable="vFiltrar"/>		


<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.GSNid") and Url.GSNid gt 0 and not isdefined("Form.GSNid")>
	<cfparam name="Form.GSNid" default="#Url.GSNid#">
</cfif>
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.tipo") and not isdefined("Form.tipo")>
	<cfparam name="Form.tipo" default="#Url.tipo#">
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
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()}
		window.opener.document.#form.formulario#.#form.codigo#.focus();
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.SNnumero") and not isdefined("Form.SNnumero")>
	<cfparam name="Form.SNnumero" default="#Url.SNnumero#">
</cfif>
<cfif isdefined("Url.SNnombre") and not isdefined("Form.SNnombre")>
	<cfparam name="Form.SNnombre" default="#Url.SNnombre#">
</cfif>

<cfset filtro = "">
<cfset descripcion = "Socios de Negocios" >
<cfif isdefined("form.tipo") and len(trim(form.tipo))>
	<cfif form.tipo neq 'A'>
		<cfset filtro = filtro & " and SNtiposocio in ('A', '#form.tipo#') ">
	<cfelse>
		<cfset filtro = filtro & " and SNtiposocio = 'A'">
	</cfif>

	<cfif form.tipo eq 'P'>
		<cfset descripcion = "Proveedores" >
	<cfelse>
		<cfset descripcion = "Clientes" >
	</cfif>
</cfif> 

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#&tipo=#form.tipo#" >
<cfif isdefined("Form.SNnumero") and Len(Trim(Form.SNnumero)) NEQ 0>
	<cfset filtro = filtro & " and upper(SNnumero) like '%" & UCase(Form.SNnumero) & "%'">
	<cfset navegacion = navegacion & "&SNnumero=" & Form.SNnumero>
</cfif>
<cfif isdefined("Form.SNnombre") and Len(Trim(Form.SNnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(SNnombre) like '%" & UCase(Form.SNnombre) & "%'">
	<cfset navegacion = navegacion & "&SNnombre=" & Form.SNnombre>
</cfif>
<cfif isdefined("Form.GSNid") and Len(Trim(Form.GSNid)) NEQ 0>
 	<cfset filtro = filtro & " and GSNid =" & Form.GSNid>
	<cfset navegacion = navegacion & "&GSNid=" & Form.GSNid>
</cfif>

<html>
<head>
<title>Lista de <cfoutput>#descripcion#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<!---<tr><td><table width="100%"><tr><td class="tituloMantenimiento" align="center"><font size="2">Conceptos de Servicio</font></td></tr></table></td></tr>--->
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisSociosNegocios2.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>#vCodigo#</strong></td>
				<td> 
					<input name="SNnumero" type="text" id="codigo" size="20" maxlength="15" onClick="this.select();" value="<cfif isdefined("Form.SNnumero")>#Form.SNnumero#</cfif>">
				</td>
				<td align="right"><strong>#vDescripcion#</strong></td>
				<td> 
					<input name="SNnombre" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.SNnombre")>#Form.SNnombre#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#vFiltrar#">
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
					<input type="hidden" name="tipo" value="<cfif isdefined("form.tipo") and len(trim(form.tipo))>#form.tipo#</cfif>">
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsLista" datasource="#session.DSN#">
			select SNcodigo,SNnumero,SNnombre
			from SNegocios
			where Ecodigo=#session.Ecodigo# 
			  and SNinactivo = 0
				<cfif isdefined("filtro") and len(trim(filtro))>
					#preservesinglequotes(filtro)#
				</cfif>
			order by SNnumero
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="SNnumero, SNnombre"/>
			<cfinvokeargument name="etiquetas" value="#vCodigo#, #vDescripcion#"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisSociosNegocios2.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="SNcodigo, SNnumero, SNnombre"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>