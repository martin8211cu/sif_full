<!--- <cfdump var="#form#" label="form">
<cfdump var="#url#" label="url"> --->

<cfif not len(trim(URL.ARBOL_POS)) and isdefined("url.x") and len(trim(url.x))>
	<cfset URL.ARBOL_POS = url.x >
</cfif>

<form name="filtro" method="get">
	<input type="text" name="x" >
	<input type="submit" name="Filtrar" value="Filtrar">

	<cfoutput>

<!--- *** Ultimo cambio --->
		<input type="hidden" name="ARBOL_POS" value="<cfif isdefined("Url.ARBOL_POS") and not isdefined("url.x")>#Url.ARBOL_POS#</cfif>">
<!--- *** Ultimo cambio --->

	<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
		<input type="hidden" name="formulario" value="#Url.formulario#">
	</cfif>
	<cfif isdefined("Url.id") and not isdefined("Form.id")>
		<input type="hidden" name="id" value="#Url.id#">
	</cfif>
	<cfif isdefined("Url.name") and not isdefined("Form.name")>
		<input type="hidden" name="name" value="#Url.name#">
	</cfif>
	<cfif isdefined("Url.nivel") and not isdefined("Form.nivel")>
		<input type="hidden" name="nivel" value="#Url.nivel#">
	</cfif>
	<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
		<input type="hidden" name="desc" value="#Url.desc#">
	</cfif>
	</cfoutput>

</form> 

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
	<cfif not len(trim(siguiente.padre))>
		<cfset raiz = current >
	</cfif>
	<cfset current = siguiente.padre>
</cfloop>

<cfif dummy ge 100> <cf_errorCode	code = "50156" msg = "Excede la cantidad de niveles."> </cfif>
<cfset QueryString_ARBOL=Iif(CGI.QUERY_STRING NEQ "", DE("&"&CGI.QUERY_STRING), DE(""))>

<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"ARBOL_POS=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"formulario=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"id=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"name=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"nivel=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"desc=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<!--- trae nivel maximo de clasificaciones de articulos --->
<cfquery name="rsNivel" datasource="#session.DSN#">
	select coalesce(Pvalor, '1') as nivel
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=530
</cfquery>

<!--- Query principal, trae los datos de Clasificaciones --->
<!---
<cfquery datasource="#session.dsn#" name="ARBOL">
	select c.Ccodigo, c.Ccodigoclas, c.Cdescripcion, c.Cnivel as nivel, Cpath  ,
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
--->

<cfquery datasource="#session.dsn#" name="ARBOL">
	select c.Ccodigo, c.Ccodigoclas, c.Cdescripcion, c.Cnivel as nivel, Cpath  ,
		(select count(1) from Clasificaciones c2
			where c2.Ccodigopadre = c.Ccodigo
			  and c2.Ecodigo = c.Ecodigo) AS  hijos
	from Clasificaciones c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  <cfif Len(path)>
	  	and ( c.Ccodigopadre in (<cfqueryparam cfsqltype="cf_sql_integer" value="#path#" list="yes">)
			or 	c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#raiz#" list="yes"> )
	  <cfelse>
		  and c.Ccodigopadre is null
	  </cfif>
	order by c.Cpath
</cfquery>
<!--- /ARBOL --->

<html>
<head>
<title>Lista de Clasificaciones de Art&iacute;culos</title>
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

function Asignar(id, codigo,desc, nivel) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#url.formulario#.#url.id#.value = id;
		window.opener.document.#url.formulario#.#url.name#.value = trim(codigo);
		window.opener.document.#url.formulario#.#url.desc#.value = desc;
		window.opener.document.#url.formulario#.#url.nivel#.value = nivel;
		if (window.opener.func#url.name#) {window.opener.func#url.name#()}
		</cfoutput>
		window.close();
	}
}
<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
function eovr(row){
	row.style.backgroundColor='#e4e8f3';
}
function eout(row){
	row.style.backgroundColor='#ffffff';
}
function eclk(arbol_pos, codigoclas, descripcion, nivel){
	var parametrosNivel = <cfoutput>#rsNivel.nivel#</cfoutput>;

	if ( (parseInt(parametrosNivel)-1) == parseInt(nivel) ){
		Asignar(arbol_pos, codigoclas, descripcion, nivel)
	}
	else{
		document.filtro.ARBOL_POS.value = arbol_pos;
		document.filtro.submit();
		//location.href="ConlisClasificacionArticulo.cfm?ARBOL_POS="+arbol_pos+"<cfoutput>#JSStringFormat(QueryString_ARBOL)#&formulario=#url.formulario#&id=#url.id#&name=#url.name#&nivel=#url.nivel#&desc=#url.desc#</cfoutput>";
	}
}
</script>

</head>
<body>

<div class="subTitulo">Seleccione una Clasificaci&oacute;n de Art&iacute;culos</div>
<cfif ARBOL.recordCount>
	<cfoutput>
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr><td valign="top"> 
	<div style="width:630px;height:330px;overflow:auto;margin-top:4px">
		<table cellpadding="0" cellspacing="1" border="0" width="100%">
			<tr valign="middle"	<cfif Len(url.ARBOL_POS) is 0>class='ar1'<cfelse>class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" onClick="eclk('')" </cfif> >
		
				<td nowrap>
					<img src="/cfmx/sif/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
					Mostrar Todo
				</td>
			</tr>
			<!--- inicio - bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
			<cfloop query="ARBOL">
				<tr valign="middle"	<cfif ARBOL.Ccodigo is url.ARBOL_POS>class='ar1'<cfelse>class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" onClick="eclk('#ARBOL.Ccodigo#','#JSStringFormat(ARBOL.Ccodigoclas)#','#JSStringFormat(ARBOL.Cdescripcion)#', '#ARBOL.nivel#')" </cfif> >
					<td nowrap>
						<cfif len(trim(ARBOL.nivel))>
							#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
							<cfif ARBOL.hijos and ListFind(path,ARBOL.Ccodigo)>
								<img src="/cfmx/sif/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
							<cfelseif ARBOL.hijos>
								<img src="/cfmx/sif/js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle">
							<cfelse>
								<img src="/cfmx/sif/js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
							</cfif>
							#HTMLEditFormat(Trim(ARBOL.Ccodigoclas))# - #HTMLEditFormat(Trim(ARBOL.Cdescripcion))#
						</cfif>
					</td>
				</tr>
			</cfloop>
			<!--- fin - bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
		</table>
	</div>
	
	</table>
<div style="margin-top:4px;border-top:1px solid black;font-size:10px">Haga clic para abrir una clasificaci&oacute;n de art&iacute;culos. Solo puede seleccionar las clasificaciones cuyo nivel sea igual al definido en parametros del sistema.</div>	
	</cfoutput>
<cfelse>
<br>
<div style="margin-top:4px;font-size:10px">No se encontaron datos.</div>
<br>
</cfif>



</body>
</html>

