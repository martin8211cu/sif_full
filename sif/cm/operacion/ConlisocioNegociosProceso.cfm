
<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfset index = "">
<cfif isdefined("Form.idx") and Len(Trim(Form.idx))>
	<cfset index = Form.idx>
<cfelseif isdefined("Url.idx") and Len(Trim(Url.idx)) and not isdefined("Form.index")>
	<cfset index = Url.idx>
</cfif>
<!----
<cfelseif isdefined("Url.opcion") and Len(Trim(Url.opcion)) and not isdefined("Form.opcion")>
	<cfset form.opcion = Url.opcion>
</cfif>
----->

<!----
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
---->

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo,desc) {	
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.SNcodigo<cfoutput>#index#</cfoutput>.value = id;
		window.opener.document.#form.formulario#.SNnumero<cfoutput>#index#</cfoutput>.value = trim(codigo);
		window.opener.document.#form.formulario#.SNnombre<cfoutput>#index#</cfoutput>.value = desc;		
		//Si opcion = 1 entonces hace submit si es 0 = No hace el submit		 
		if(window.opener.document.#form.formulario#.opcion.value == 1){
			var opcion = 1
		}
		else{var opcion = 0}
			window.opener.document.#form.formulario#.action = 'compraProceso.cfm?btnNuevo=btnNuevo&SNcodigo='+id+'&opcion='+opcion;	
			window.opener.document.#form.formulario#.submit();	
		//}
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

<cfset navegacion = "&formulario=#form.formulario#&index=#index#" >
<cfif isdefined("Form.SNnumero") and Len(Trim(Form.SNnumero)) NEQ 0>
	<cfset filtro = filtro & " and upper(SNnumero) like '%" & UCase(Form.SNnumero) & "%'">
	<cfset navegacion = navegacion & "&SNnumero=" & Form.SNnumero>
</cfif>
<cfif isdefined("Form.SNnombre") and Len(Trim(Form.SNnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(SNnombre) like '%" & UCase(Form.SNnombre) & "%'">
	<cfset navegacion = navegacion & "&SNnombre=" & Form.SNnombre>
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
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisocioNegociosProceso.cfm" >
		<cfif Len(Trim(index))>
			<input type="hidden" name="idx" value="#index#">
		</cfif>
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>N&uacute;mero</strong></td>
				<td> 
					<input name="SNnumero" type="text" id="codigo" size="10" maxlength="10" onClick="this.select();" value="<cfif isdefined("Form.SNnumero")>#Form.SNnumero#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="SNnombre" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.SNnombre")>#Form.SNnombre#</cfif>">
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
					<input type="hidden" name="tipo" value="<cfif isdefined("form.tipo") and len(trim(form.tipo))>#form.tipo#</cfif>">
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsLista" datasource="#session.DSN#">			
			select distinct a.SNcodigo, a.SNnumero, a.SNnombre
			from SNegocios a
				inner join CMProveedoresProceso b
					on a.SNcodigo = b.SNcodigo
					and a.Ecodigo = b.Ecodigo
					and b.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
			where a.Ecodigo=#session.Ecodigo# 
				<cfif isdefined("filtro") and len(trim(filtro))>
					#preservesinglequotes(filtro)#
				</cfif>
			order by SNnumero
		</cfquery>

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="SNnumero, SNnombre"/>
			<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisocioNegociosProceso.cfm"/>
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