<!---<cfdump var="#form#">
<cfdump var="#url.Acodalterno#"><br>

<cfif isdefined("form.btnFiltrar")>
	<cfif isdefined("url.Acodalterno")>
		<cfset structDelete(url, "Acodalterno")>
	</cfif>
</cfif>
--->
<cfif isdefined("Url.Acodigo") and not isdefined("Form.Acodigo")>
	<cfparam name="Form.Acodigo" default="#Url.Acodigo#">
</cfif>
<cfif isdefined("Url.Acodalterno") and not isdefined("Form.Acodalterno")>
	<cfparam name="Form.Acodalterno" default="#Url.Acodalterno#">
</cfif>
<cfif isdefined("Url.Adescripcion") and not isdefined("Form.Adescripcion")>
	<cfparam name="Form.Adescripcion" default="#Url.Adescripcion#">
</cfif>

<cfif isdefined("Url.Acodigo") and isdefined("Form.Acodigo") and url.Acodigo neq form.Acodigo>
	<cfset Url.Acodigo = form.Acodigo>
	<cfset url.PAGENUM_LISTA = 1>
</cfif>

<cfif isdefined("Url.Acodalterno") and isdefined("Form.Acodalterno") and url.Acodalterno neq form.Acodalterno>
	<cfset Url.Acodalterno = form.Acodalterno>
	<cfset url.PAGENUM_LISTA = 1>
</cfif>

<cfif isdefined("Url.Adescripcion") and isdefined("Form.Adescripcion") and url.Adescripcion neq form.Adescripcion >
	<cfset Url.Adescripcion = form.Adescripcion>
	<cfset url.PAGENUM_LISTA = 1>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.Acodigo") and Len(Trim(Form.Acodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.Acodigo) like '%" & #UCase(Form.Acodigo)# & "%'">
	<cfset navegacion = "&Acodigo=" & Form.Acodigo>
</cfif>
<cfif isdefined("Form.Acodalterno") and Len(Trim(Form.Acodalterno)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.Acodalterno) like '%" & #UCase(Form.Acodalterno)# & "%'">
	<cfset navegacion = "&Acodalterno=" & Form.Acodalterno>
</cfif>
<cfif isdefined("Form.Adescripcion") and Len(Trim(Form.Adescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.Adescripcion) like '%" & #UCase(Form.Adescripcion)# & "%'">
	<cfset navegacion = navegacion & "&Adescripcion=" & Form.Adescripcion>
</cfif>

<!--- ARBOL --->
<cfparam name="url.ARBOL_POS" default="">
<cfif REFindNoCase('^[0-9]+$', url.ARBOL_POS) Is 0>
	<cfset url.ARBOL_POS = ''>
</cfif>
<cfset path = ''>
<cfset current = url.ARBOL_POS>
<cfloop from="1" to="100" index="dummy">
	<cfif Len(current) is 0><cfbreak></cfif>
	<cfset path = ListAppend(path,current)>
	<cfquery datasource="#session.dsn#" name="siguiente">
		select Ccodigopadre as padre from Clasificaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#current#">
	</cfquery>
	<cfset current = siguiente.padre>
</cfloop>
<cfif dummy ge 100> <cfthrow message="fue horrible"> </cfif>
<cfset QueryString_ARBOL=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"ARBOL_POS=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfquery datasource="#session.dsn#" name="ARBOL">
	select c.Ccodigo, c.Ccodigoclas, c.Cdescripcion, c.Cnivel as nivel,  
		(select count(1) from Clasificaciones c2
			where c2.Ccodigopadre = c.Ccodigo
			  and c2.Ecodigo = c.Ecodigo) AS  hijos
	from Clasificaciones c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and (c.Ccodigopadre is null
	  	<cfif Len(path)>
			or c.Ccodigopadre in (<cfqueryparam cfsqltype="cf_sql_integer" value="#path#" list="yes">)
		</cfif>
	  )
	order by c.Cpath
</cfquery>
<!--- /ARBOL --->

<html>
<head>
<title>Lista de Art&iacute;culos</title>
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

function Asignar(id, codigo, desc, ucodigo, cuenta, mayor, formato, cuentadesc, icodigo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.name#.value = trim(codigo);
		window.opener.TraeArticulos#url.name#(trim(codigo));
		window.opener.document.#Url.form#.#Url.name#.blur();
		</cfoutput>
		window.close();
	}
}
<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
function eovr(row){<!--- event: MouseOver --->
	row.style.backgroundColor='#e4e8f3';
}
function eout(row){<!--- event: MouseOut --->
	row.style.backgroundColor='#ffffff';
}
function eclk(arbol_pos){<!--- event: Click --->
	location.href="ConlisArticulos.cfm?ARBOL_POS="+arbol_pos+"<cfoutput>#JSStringFormat(QueryString_ARBOL)#</cfoutput>";
}
</script>
</head>
<body>

<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td valign="top"> 
<div class="subTitulo">
<strong>Clasificaciones</strong></div>
<div style="width:200px;height:350px;overflow:auto;margin-top:4px">
	<table cellpadding="0" cellspacing="1" border="0" width="100%">
	<tr valign="middle"
			<cfif Len(url.ARBOL_POS) is 0>
			class='ar1'
			<cfelse>
			class='ar2'
			onMouseOver="eovr(this)"
			onMouseOut="eout(this)"
			onClick="eclk('')"
			</cfif> ><td nowrap>
		<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
			Mostrar Todo
	</td></tr>
	<!--- bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
<cfloop query="ARBOL">
<tr valign="middle"	<cfif ARBOL.Ccodigo is url.ARBOL_POS> class='ar1'
<cfelse>class='ar2' onMouseOver="eovr(this)"
onMouseOut="eout(this)" onClick="eclk('#ARBOL.Ccodigo#')"
</cfif> ><td nowrap>
<cfif len(trim(ARBOL.nivel))>
	#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
	<cfif ARBOL.hijos and ListFind(path,ARBOL.Ccodigo)>
	<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
	<cfelseif ARBOL.hijos>
	<img src="/cfmx/rh/js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle">
	<cfelse>
	<img src="/cfmx/rh/js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
	</cfif>
	#HTMLEditFormat(Trim(ARBOL.Ccodigoclas))# - #HTMLEditFormat(Trim(ARBOL.Cdescripcion))#
</cfif>
</td>
</tr>
</cfloop>
	</table>
</div>

</td><td valign="top" width="20">
</td><td valign="top">
<!---action="#GetFileFromPath(GetTemplatePath())#"--->
	<form name="filtroEmpleado" method="post" >

<!---
	<cfloop collection="#Form#" item="i">
		<input type="hidden" name="#i#" value="#StructFind(Form, i)#">
	</cfloop>
--->	
	<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
		<tr>
			<td align="right"><strong>C&oacute;digo</strong></td>
			<td> 
				<input name="Acodigo" type="text" id="name" size="10" maxlength="15" value="<cfif isdefined("Form.Acodigo")>#Form.Acodigo#</cfif>">
			</td>

			<td align="right" nowrap><strong>C&oacute;d. Alterno</strong></td>
			<td> 
				<input name="Acodalterno" type="text" id="name" size="10" maxlength="20" value="<cfif isdefined("Form.Acodalterno")>#Form.Acodalterno#</cfif>">
			</td>

			<td align="right"><strong>Descripci&oacute;n</strong></td>
			<td> 
				<input name="Adescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.Adescripcion")>#Form.Adescripcion#</cfif>">
			</td>
			<td align="center">
				<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
			</td>
		</tr>
	</table>
	</form>

<cfif isdefined("url.Almacen") and len(trim(url.Almacen)) gt 0>
	<cfquery name="rsLista"  datasource="#session.DSN#">
		select a.Aid, a.Adescripcion, a.Acodigo, a.Acodalterno, a.Ucodigo, a.Icodigo, b.Eexistencia, c.IACinventario, Cmayor, d.Ccuenta , d.Cformato, d.Cdescripcion  
		from Articulos a
		
		inner join Existencias b
		on a.Ecodigo=b.Ecodigo
		and a.Aid=b.Aid
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		inner join IAContables c
		on b.Ecodigo=c.Ecodigo
		and b.IACcodigo=c.IACcodigo
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		inner join CContables d
		on c.Ecodigo=d.Ecodigo
		and c.IACinventario=d.Ccuenta
		and d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and b.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Almacen#">
		  #preservesinglequotes(filtro)#
		<cfif isdefined("url.filtroextra") and Len(trim(url.filtroextra))>
			#preservesinglequotes(url.filtroextra)#
		<cfelse>
			<cfif Len(url.ARBOL_POS)>
				and a.Ccodigo = #url.ARBOL_POS#
			</cfif>
		</cfif>
		order by upper(a.Acodigo) 
	</cfquery>

	<cfquery name="rsAlmacen" datasource="#session.DSN#">
		select Almcodigo, Bdescripcion
		from Almacen
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Almacen#">
	</cfquery>

	<cfif rsAlmacen.RecordCount gt 0>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><strong>Almacen: #rsAlmacen.Almcodigo# - #rsAlmacen.Bdescripcion#</strong><hr size="1"></td></tr>
		</table>
	</cfif>

<cfelse>
	<cfquery name="rsLista"  datasource="#session.DSN#">
		select Aid, Adescripcion, Acodigo, a.Acodalterno, Ucodigo, '' as Eexistencia, '' as IACinventario, '' as Cmayor, '' as Ccuenta , '' as Cformato, '' as Cdescripcion, a.Icodigo  
		from Articulos a
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		#preservesinglequotes(filtro)#
		<cfif isdefined("url.filtroextra") and Len(trim(url.filtroextra))>
			#preservesinglequotes(url.filtroextra)#
		<cfelse>
			<cfif Len(url.ARBOL_POS)>
				and a.Ccodigo = #url.ARBOL_POS#
			</cfif>
		</cfif>
		order by upper(a.Acodigo) 
	</cfquery>
</cfif>
	
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsLista#"/>
		<cfinvokeargument name="desplegar" value="Acodigo, Acodalterno, Adescripcion"/>
		<cfinvokeargument name="etiquetas" value="Código, Cód. Alterno, Descripción"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="align" value="left, left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="conlisArticulos.cfm"/>
		<cfinvokeargument name="formName" value="listaArticulos"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="Aid, Acodigo, Adescripcion, Ucodigo, Ccuenta, Cmayor, Cformato, Cdescripcion, Icodigo"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="Conexion" value="#url.conexion#"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
	</cfinvoke>
</td></tr>
</table>
	
	</cfoutput>
</body>
</html>