<cfif isdefined("Url.form") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.form#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.conexion") and not isdefined("Form.conexion")>
	<cfparam name="Form.conexion" default="#Url.conexion#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.PRJRcodigo") and Len(Trim(Form.PRJRcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(r.PRJRcodigo) like '%" & #UCase(Form.PRJRcodigo)# & "%'">
	<cfset navegacion = "&PRJRcodigo=" & Form.PRJRcodigo>
</cfif>
<cfif isdefined("Form.PRJRdescripcion") and Len(Trim(Form.PRJRdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(r.PRJRdescripcion) like '%" & #UCase(Form.PRJRdescripcion)# & "%'">
	<cfset navegacion = navegacion & "&PRJRdescripcion=" & Form.PRJRdescripcion>
</cfif>

<html>
<head>
<title>Lista de Recursos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>

<style type="text/css">
<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
.ar1 {background-color:#D4DBF2;cursor:pointer;}
.ar2 {background-color:#ffffff;cursor:pointer;}
</style>


<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function obtener_formato(mayor, formato){
	if ( formato.length > 5){
		return formato.substring(5,formato.length);
	}	
	return '';
}

function Asignar(id, codigo, desc, punit, ucodigo) {
	if (window.opener != null) {
		<cfoutput>
		//var descAnt = window.opener.document.#form.formulario#.#form.desc#.value;
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.name#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		window.opener.document.#form.formulario#.#url.cmp_unitario#.value = punit;
		window.opener.document.#form.formulario#.#url.mod_cant#.value = "1";
		window.opener.document.#form.formulario#.UcodigoProd.value = ucodigo;
		
		if (window.opener.func#trim(form.name)#) {window.opener.func#trim(form.name)#();}
		</cfoutput>
		window.close();
	}
}
</script>
</head>
<body>

<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr>
<td valign="top">

	<form name="filtroRecurso" method="post" action="ConlisRecursos.cfm">
	<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
		<tr>
			<td align="right"><strong>C&oacute;digo</strong></td>
			<td> 
				<input name="PRJRcodigo" type="text" id="name" size="10" maxlength="15" value="<cfif isdefined("Form.PRJRcodigo")>#Form.PRJRcodigo#</cfif>">
			</td>
			<td align="right"><strong>Descripci&oacute;n</strong></td>
			<td> 
				<input name="PRJRdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.PRJRdescripcion")>#Form.PRJRdescripcion#</cfif>">
			</td>
			<td align="center">
				<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				<cfif isdefined("form.formulario") and len(trim(form.formulario))>
					<input type="hidden" name="formulario" value="#form.formulario#">
				</cfif>
				<cfif isdefined("form.id") and len(trim(form.id))>
					<input type="hidden" name="id" value="#form.id#">
				</cfif>
				<cfif isdefined("form.name") and len(trim(form.name))>
					<input type="hidden" name="name" value="#form.name#">
				</cfif>
				<cfif isdefined("form.desc") and len(trim(form.desc))>
					<input type="hidden" name="desc" value="#form.desc#">
				</cfif>				
				<cfif isdefined("form.conexion") and len(trim(form.conexion))>
					<input type="hidden" name="conexion" value="#form.conexion#">
				</cfif>								
			</td>			
		</tr>
	</table>
	</form>

	<cfquery name="rsLista"  datasource="#session.DSN#">
		select r.PRJRid, r.PRJRcodigo, r.PRJRdescripcion, r.PRJtipoRecurso,
		coalesce(Acosto, (select max(PRJPIcostoUnitario) 
                  		  from PRJPproductoInsumos i
			              where i.PRJRid  = r.PRJRid
            		        and i.Ecodigo = r.Ecodigo), 0) as costo_unit
		, r.Ucodigo
		from PRJRecurso r
			 left outer join Articulos ar
    		 on ar.Aid = r.Aid
		where r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		#preservesinglequotes(filtro)#		
		order by upper(r.PRJRcodigo) 
	</cfquery>	
	
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsLista#"/>
		<cfinvokeargument name="desplegar" value="PRJRcodigo, PRJRdescripcion, PRJtipoRecurso"/>
		<cfinvokeargument name="etiquetas" value="Código, Descripción, Tipo de Recurso"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="align" value="left, left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="conlisRecursos.cfm"/>
		<cfinvokeargument name="formName" value="listaRecursos"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="PRJRid, PRJRcodigo, PRJRdescripcion, costo_unit, Ucodigo"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="Conexion" value="#form.conexion#"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
	</cfinvoke>
</td></tr>
</table>
	
	</cfoutput>
</body>
</html>