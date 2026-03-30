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
<cfif isdefined("Url.excluir") and not isdefined("Form.excluir")>
	<cfparam name="Form.excluir" default="#Url.excluir#">
</cfif>
<cfif  not isdefined("Form.excluir")>
	<cfparam name="Form.excluir" default="">
</cfif>

<cfif isdefined("Url.otrosdatos") and not isdefined("Form.otrosdatos")>
	<cfparam name="Form.otrosdatos" default="#Url.otrosdatos#">
</cfif>
<cfif  not isdefined("Form.otrosdatos")>
	<cfparam name="Form.otrosdatos" default="">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}
  

function Asignar(id, codigo,desc,moneda,costo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		<cfif isdefined("form.otrosdatos") and len(trim(form.otrosdatos)) and form.otrosdatos eq 'SI'> 
			window.opener.document.#form.formulario#.MontoR.value = trim(moneda) + ' ' + costo;
			//window.opener.document.#form.formulario#.moneda.value = trim(moneda);
			//window.opener.document.#form.formulario#.costo_requisito.value = costo;
		</cfif>
		if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.codigo_requisito") and not isdefined("Form.codigo_requisito")>
	<cfparam name="Form.codigo_requisito" default="#Url.codigo_requisito#">
</cfif>
<cfif isdefined("Url.nombre_requisito") and not isdefined("Form.nombre_requisito")>
	<cfparam name="Form.nombre_requisito" default="#Url.nombre_requisito#">
</cfif>

<cfset filtro = "">

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#&excluir=#form.excluir#&otrosdatos=#form.otrosdatos#" >
<cfif isdefined("Form.codigo_requisito") and Len(Trim(Form.codigo_requisito)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.codigo_requisito) like '%" & UCase(Form.codigo_requisito) & "%'">
	<cfset navegacion = navegacion & "&codigo_requisito=" & Form.codigo_requisito>
</cfif>
<cfif isdefined("Form.nombre_requisito") and Len(Trim(Form.nombre_requisito)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.nombre_requisito) like '%" & UCase(Form.nombre_requisito) & "%'">
	<cfset navegacion = navegacion & "&nombre_requisito=" & Form.nombre_requisito>
</cfif>
<cfif isdefined("Form.excluir") and Len(Trim(Form.excluir)) NEQ 0>
 	<cfset filtro = filtro & " and a.id_requisito not in (#form.excluir#) ">
	<cfset navegacion = navegacion & "&excluir=" & Form.excluir>
</cfif>

<html>
<head>
<title>Lista de Requisitos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="conlisTPRequisitos.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="codigo_requisito" type="text" id="codigo_requisito" size="10" maxlength="10" onClick="this.select();" value="<cfif isdefined("Form.codigo_requisito")>#Form.codigo_requisito#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="nombre_requisito" type="text" id="nombre_requisito" size="30" maxlength="30" onClick="this.select();" value="<cfif isdefined("Form.nombre_requisito")>#Form.nombre_requisito#</cfif>">
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
		<cfquery name="rsLista" datasource="#session.tramites.dsn#">
			select a.id_requisito, a.codigo_requisito, a.nombre_requisito,a.costo_requisito,a.moneda,coalesce(nombre_inst,'Sin Institución' )  as nombre_inst
						from TPRequisito a 
			left outer join TPInstitucion b
				on a.id_inst  = b.id_inst 
			where 1=1
			<cfif isdefined("filtro") and len(trim(filtro))>
				#preservesinglequotes(filtro)#
			</cfif>
			order by 6,2, 3
		</cfquery>

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="codigo_requisito, nombre_requisito,moneda,costo_requisito"/>
			<cfinvokeargument name="etiquetas" value="Código, Descripción,Moneda,Costo"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left, left, right"/>
			<cfinvokeargument name="ajustar" value="V,V,V,V"/>
			<cfinvokeargument name="irA" value="conlisTPRequisitos.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="id_requisito, codigo_requisito, nombre_requisito,moneda,costo_requisito"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="cortes" value="nombre_inst"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>