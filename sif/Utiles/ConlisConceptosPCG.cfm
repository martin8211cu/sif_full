<!--- Parámetros para el llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.cuentac") and not isdefined("Form.cuentac")>
	<cfparam name="Form.cuentac" default="#Url.cuentac#">
</cfif>
<cfif isdefined("Url.tipo") and not isdefined("Form.tipo")>
	<cfparam name="Form.tipo" default="#Url.tipo#">
</cfif>
<cfif isdefined("Url.verClasificacion") and not isdefined("Form.verClasificacion")>
	<cfparam name="Form.verClasificacion" default="#Url.verClasificacion#">
</cfif>
<cfif isdefined("Url.FPEPid") and not isdefined("Form.FPEPid")>
	<cfparam name="Form.FPEPid" default="#Url.FPEPid#">
<cfelse>
	<cfparam name="Form.FPEPid" default="-1">
</cfif>
<cfif isdefined("Url.FuncJSalCerrar") and not isdefined("Form.FuncJSalCerrar")>
	<cfparam name="Form.FuncJSalCerrar" default="#Url.FuncJSalCerrar#">
</cfif>
<!--- ARBOL --->
<cfif isdefined("Form.ARBOL_POS") and not isdefined("Url.ARBOL_POS")>
	<cfparam name="Url.ARBOL_POS" default="#Form.ARBOL_POS#">
<cfelse>
	<cfparam name="Url.ARBOL_POS" default="">
</cfif>
<cfif REFindNoCase('^[0-9]+$', url.ARBOL_POS) Is 0>
	<cfset url.ARBOL_POS = ''>
</cfif>
<cfset path = ''>
<cfset current = url.ARBOL_POS>
<cfloop from="1" to="100" index="dummy">
	<cfif Len(current) is 0><cfbreak></cfif>
	<cfset path = ListAppend(path,current)>
	<cfquery datasource="#session.dsn#" name="siguiente">
		select CCidpadre as padre from CConceptos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#current#">
	</cfquery>
	<cfset current = siguiente.padre>
</cfloop>
<cfif dummy ge 100> <cf_errorCode	code = "50156" msg = "Excede la cantidad de niveles."> </cfif>
<cfset QueryString_ARBOL=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"ARBOL_POS=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfquery datasource="#session.dsn#" name="ARBOL">
	select c.CCid, c.CCcodigo, c.CCdescripcion, c.CCnivel as nivel,  
		(select count(1) from CConceptos c2
			where c2.CCidpadre = c.CCid
			  and c2.Ecodigo = c.Ecodigo) AS  hijos
	from CConceptos c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and (c.CCidpadre is null
	  	<cfif Len(path)>
			or c.CCidpadre in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#path#" list="yes">)
		</cfif>
	  )
	order by c.CCpath
</cfquery>
<!--- /ARBOL --->

<!--- Parámetros del filtro del conlis --->
<cfif isdefined("Url.Ccodigo") and not isdefined("Form.Ccodigo")>
	<cfparam name="Form.Ccodigo" default="#Url.Ccodigo#">
</cfif>
<cfif isdefined("Url.Cdescripcion") and not isdefined("Form.Cdescripcion")>
	<cfparam name="Form.Cdescripcion" default="#Url.Cdescripcion#">
</cfif>
<cfif isdefined("Url.filtroextra") and len(trim(Url.filtroextra)) and not isdefined("Form.filtroextra")>
	<cfparam name="Form.filtroextra" default="#Url.filtroextra#">
</cfif>

<!--- Filtros para el query y variable de navegación --->

<cfset filtro = "">
<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&name=#form.name#&desc=#form.desc#&tipo=#form.tipo#">

<cfif isdefined("Form.tipo") and len(trim(Form.tipo))>
	<cfset filtro = filtro & " and Ctipo = '#Form.tipo#' ">
</cfif>
<cfif isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(Ccodigo) like '%" & UCase(Form.Ccodigo) & "%'">
	<cfset navegacion = navegacion & "&Ccodigo=" & Form.Ccodigo>
</cfif>
<cfif isdefined("Form.Cdescripcion") and Len(Trim(Form.Cdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Cdescripcion) like '%" & UCase(Form.Cdescripcion) & "%'">
	<cfset navegacion = navegacion & "&Cdescripcion=" & Form.Cdescripcion>
</cfif>
<cfif isdefined("Form.filtroextra") and Len(trim(Form.filtroextra))>
	<cfset filtro = filtro & Form.filtroextra >
	<cfset navegacion = navegacion & "&filtroextra=" & Form.filtroextra>
<cfelse>
	<cfif Len(Url.ARBOL_POS)>
		<cfset filtro = filtro & ' and CCid = #Url.ARBOL_POS#'>
		<cfset navegacion = navegacion & "&ARBOL_POS=" & Url.ARBOL_POS>
	</cfif>
</cfif>
<cfif isdefined("Form.verClasificacion") and len(trim(Form.verClasificacion)) gt 0>
	<cfset navegacion = navegacion & "&verClasificacion=#Form.verClasificacion#">
</cfif>
<cfif isdefined("form.FPEPid") and len(trim("Form.FPEPid"))>
	<cfset navegacion = navegacion & "&FPEPid=#Form.FPEPid#">
</cfif>
<cfif isdefined("form.FuncJSalCerrar") and len(trim("Form.FuncJSalCerrar"))>
	<cfset navegacion = navegacion & "&FuncJSalCerrar=#Form.FuncJSalCerrar#">
</cfif>

<!--- Parámetros que se van a pasar por url al hacer click sobre una clasificación --->
<cfset paramClasificacion = "&">
<cfif isdefined("Form.formulario") and not isdefined("Url.formulario")>
	<cfset paramClasificacion = paramClasificacion & "formulario=" & Form.formulario & "&">
</cfif>
<cfif isdefined("Form.id") and not isdefined("Url.id")>
	<cfset paramClasificacion = paramClasificacion & "id=" & Form.id & "&">
</cfif>
<cfif isdefined("Form.name") and not isdefined("Url.name")>
	<cfset paramClasificacion = paramClasificacion & "name=" & Form.name & "&">
</cfif>
<cfif isdefined("Form.desc") and not isdefined("Url.desc")>
	<cfset paramClasificacion = paramClasificacion & "desc=" & Form.desc & "&">
</cfif>
<cfif isdefined("Form.cuentac") and not isdefined("Url.cuentac")>
	<cfset paramClasificacion = paramClasificacion & "cuentac=" & Form.cuentac & "&">
</cfif>
<cfif isdefined("Form.tipo") and not isdefined("Url.tipo")>
	<cfset paramClasificacion = paramClasificacion & "tipo=" & Form.tipo & "&">
</cfif>
<cfif isdefined("Form.verClasificacion") and not isdefined("Url.verClasificacion")>
	<cfset paramClasificacion = paramClasificacion & "verClasificacion=" & Form.verClasificacion & "&">
</cfif>
<cfif isdefined("Form.Ccodigo") and not isdefined("Url.Ccodigo")>
	<cfset paramClasificacion = paramClasificacion & "Ccodigo=" & Form.Ccodigo & "&">	
</cfif>
<cfif isdefined("Form.Cdescripcion") and not isdefined("Url.Cdescripcion")>
	<cfset paramClasificacion = paramClasificacion & "Cdescripcion=" & Form.Cdescripcion & "&">
</cfif>
<cfif isdefined("Form.filtroextra") and not isdefined("Url.filtroextra")>
	<cfset paramClasificacion = paramClasificacion & "filtroextra=" & Form.filtroextra>
</cfif>
<cfif isdefined("Url.FPEPid") and not isdefined("Form.FPEPid")>
	<cfset paramClasificacion = paramClasificacion & "FPEPid=" & Form.FPEPid>
</cfif>
<cfif isdefined("Url.FuncJSalCerrar") and not isdefined("Form.FuncJSalCerrar")>
	<cfset paramClasificacion = paramClasificacion & "FuncJSalCerrar=" & Form.FuncJSalCerrar>
</cfif>
<html>
<head>
<title>Lista de Conceptos de Servicio</title>
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

function Asignar(id, codigo,desc,unidad,cuentac) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.name#.value = trim(codigo);
		window.opener.document.#form.formulario#.Ucodigo_#form.name#.value = trim(unidad);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		<cfif isdefined('form.cuentac')>
		window.opener.document.#form.formulario#.#form.cuentac#.value = cuentac;
		</cfif>
		if (window.opener.func#form.name#) {window.opener.func#form.name#()}
		//window.opener.document.#form.formulario#.#form.name#.focus();
		<cfif isdefined('form.FuncJSalCerrar') and len(trim(form.FuncJSalCerrar))>
			window.opener.#form.FuncJSalCerrar#;
		</cfif>
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
function eclk(arbol_pos){
	location.href="ConlisConceptosPCG.cfm?ARBOL_POS="+arbol_pos+"<cfoutput>#JSStringFormat(QueryString_ARBOL)#</cfoutput>"+"<cfoutput>#paramClasificacion#</cfoutput>";
}
</script>

</head>
<body>

<cfoutput>

<table border="0" cellpadding="0" cellspacing="0">
<tr>
<cfif isdefined("form.verClasificacion") and form.verClasificacion EQ 1>
	<td valign="top"> 
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
			<img src="../js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
				Mostrar Todo
		</td></tr>
		<!--- bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
	<cfloop query="ARBOL">
	<tr valign="middle"	<cfif ARBOL.CCid is url.ARBOL_POS> class='ar1'
	<cfelse>class='ar2' onMouseOver="eovr(this)"
	onMouseOut="eout(this)" onClick="eclk('#ARBOL.CCid#')"
	</cfif> ><td nowrap>
	<cfif len(trim(ARBOL.nivel))>
	#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
	<cfif ARBOL.hijos and ListFind(path,ARBOL.CCid)>
	<img src="../js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
	<cfelseif ARBOL.hijos>
	<img src="../js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle">
	<cfelse>
	<img src="../js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
	</cfif>
	#HTMLEditFormat(Trim(ARBOL.CCcodigo))# - #HTMLEditFormat(Trim(ARBOL.CCdescripcion))#
	</cfif>
	</td>
	</tr>
	</cfloop>
		</table>
	</div>
</td></cfif>
<td valign="top" width="20">
</td><td valign="top" <cfif isdefined("form.verClasificacion") and form.verClasificacion NEQ 1>colsapan="2"</cfif>>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisConceptosPCG.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="Ccodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.Ccodigo")>#Form.Ccodigo#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="Cdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.Cdescripcion")>#Form.Cdescripcion#</cfif>">
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
					<input type="hidden" name="verClasificacion" value="<cfif isdefined("form.verClasificacion") and len(trim(form.verClasificacion)) gt 0>#form.verClasificacion#</cfif>">
					<input type="hidden" name="tipo" value="<cfif isdefined("form.tipo") and len(trim(form.tipo))>#form.tipo#</cfif>">
					<input type="hidden" name="filtroextra" value="<cfif isdefined("form.filtroextra") and len(trim(form.filtroextra))>#form.filtroextra#</cfif>">
					<input type="hidden" name="ARBOL_POS" value="<cfif isdefined("url.ARBOL_POS")>#url.ARBOL_POS#</cfif>">
					<cfif isdefined("form.cuentac") and len(trim(form.cuentac))>
						<input type="hidden" name="cuentac" value="#form.cuentac#">
					</cfif>
					<cfif isdefined("form.FPEPid") and len(trim(form.FPEPid))>
						<input type="hidden" name="FPEPid" value="#form.FPEPid#">
					</cfif>
					<cfif isdefined("form.FuncJSalCerrar") and len(trim(form.FuncJSalCerrar))>
						<input type="hidden" name="FuncJSalCerrar" value="#form.FuncJSalCerrar#">
					</cfif>
					
				</td>
			</tr>
		</table>
		</form>
		<cfquery datasource="#session.dsn#" name="rsClasificaciones">
			select Pla.FPCCid , Cat.FPCCcodigo
				from FPDPlantilla Pla
					inner join FPCatConcepto Cat
						on Cat.FPCCid = Pla.FPCCid
			where Pla.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPEPid#">
		</cfquery>
		<cfset PCG_ConceptoGastoIngreso = createobject("component","sif.Componentes.PCG_ConceptoGastoIngreso")>
				<cfset filtroFPCCid ="">
		<cfloop query="rsClasificaciones">
				<cfset filtroFPCCid &= PCG_ConceptoGastoIngreso.fnListaClasificaciones(rsClasificaciones.FPCCcodigo)>
			<cfif rsClasificaciones.currentRow NEQ rsClasificaciones.recordcount>
				<cfset filtroFPCCid &= ','>
			</cfif>
		</cfloop>
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="Conceptos c 
													inner join CConceptos cc
														on cc.CCid=c.CCid
													inner join CConceptos b
														inner join FPCatConcepto fpcc
															on fpcc.FPCCTablaC = b.CCid and fpcc.FPCCid in (#filtroFPCCid#)
														on c.CCid=b.CCid
													"/>
			<cfinvokeargument name="columnas" value="c.Cid,c.Ccodigo,c.Cdescripcion,c.Ucodigo,cc.cuentac"/>
			<cfinvokeargument name="desplegar" value="Ccodigo, Cdescripcion"/>
			<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="c.Ecodigo=#session.Ecodigo# #filtro#"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisConceptosPCG.cfm"/>
			<cfinvokeargument name="formName" value="listaArticulos"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Cid, Ccodigo, Cdescripcion,Ucodigo,cuentac"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="usaAJAX" value="true"/>
		</cfinvoke>

</td></tr>
</table>
		</cfoutput>
</body>
</html>


