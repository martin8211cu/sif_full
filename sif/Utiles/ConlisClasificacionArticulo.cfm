<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.nivel") and not isdefined("Form.nivel")>
	<cfparam name="Form.nivel" default="#Url.nivel#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.conse") and not isdefined("Form.conse")>
	<cfparam name="Form.conse" default="#Url.conse#">
</cfif>

<cfif isdefined("Url.ARBOL_POS") and not isdefined("Form.ARBOL_POS")>
	<cfparam name="Form.ARBOL_POS" default="#Url.ARBOL_POS#">
<cfelseif isdefined("form.ARBOL_POS")>
	<cfset url.ARBOL_POS = form.ARBOL_POS>
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
<cfif dummy ge 100> <cf_errorCode	code = "50156" msg = "Excede la cantidad de niveles."> </cfif>
<cfset QueryString_ARBOL=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>

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

<cfif isdefined("form.conse") and form.conse eq "yes">
    <cfquery name="rsCodigoArt" datasource="#session.DSN#">
        select coalesce(Pvalor,'0') as Pvalor
        from Parametros
        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and Pcodigo=5300
    </cfquery>
</cfif>

<!--- Filtro --->
<cfif isdefined("Url.Ccodigoclas") and not isdefined("Form.Ccodigoclas")>
	<cfparam name="Form.Ccodigoclas" default="#Url.Ccodigoclas#">
</cfif>
<cfif isdefined("Url.Cdescripcion") and not isdefined("Form.Cdescripcion")>
	<cfparam name="Form.Cdescripcion" default="#Url.Cdescripcion#">
</cfif>

<cfset filtro = "">

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&name=#form.name#&nivel=#form.nivel#&desc=#form.desc#" >
<cfif isdefined("Form.ARBOL_POS") and Len(Trim(Form.ARBOL_POS)) NEQ 0>
	<cfset filtro = filtro & " and Ccodigopadre =" & UCase(Form.ARBOL_POS) >
	<cfset navegacion = navegacion & "&ARBOL_POS=" & Form.ARBOL_POS>
</cfif>

<cfif isdefined("Form.Ccodigoclas") and Len(Trim(Form.Ccodigoclas)) NEQ 0>
	<cfset filtro = filtro & " and upper(Ccodigoclas) like '%" & UCase(Form.Ccodigoclas) & "%'">
	<cfset navegacion = navegacion & "&Ccodigoclas=" & Form.Ccodigoclas>
</cfif>
<cfif isdefined("Form.Cdescripcion") and Len(Trim(Form.Cdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Cdescripcion) like '%" & UCase(Form.Cdescripcion) & "%'">
	<cfset navegacion = navegacion & "&Cdescripcion=" & Form.Cdescripcion>
</cfif>

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

function Asignar(id, codigo,desc, nivel, CAid, Cconsecutivo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.name#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		window.opener.document.#form.formulario#.#form.nivel#.value = nivel;
		window.opener.document.#form.formulario#.CAid_#form.name#.value = CAid;
		<cfif isdefined("form.conse") and form.conse eq "yes">
			DVmascara = document.filtroEmpleado.Mconse.value
			if(Cconsecutivo == ""){
				con = 1 ;
			}
			else{	
				con = parseInt(Cconsecutivo) +1 ;
			}
			Cconsecutivo = con+"";
			codigos = trim(codigo);
			vari = (DVmascara.length - (codigos.length + Cconsecutivo.length));
			for (i=0; i < vari ;i++){
				codigos = codigos+"0";
			}
			codigos=codigos+""+Cconsecutivo;
			window.opener.document.#form.formulario#.Acodigo.value = trim(codigos);
		</cfif>
		if (window.opener.func#form.name#) {window.opener.func#form.name#()}
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
	location.href="ConlisClasificacionArticulo.cfm?ARBOL_POS="+arbol_pos+"<cfoutput>#JSStringFormat(QueryString_ARBOL)#&formulario=#form.formulario#&id=#form.id#&name=#form.name#&nivel=#form.nivel#&desc=#form.desc#</cfoutput>";
}
</script>

</head>
<body>

<cfif ARBOL.recordCount>
	<cfoutput>
	<table border="0" cellpadding="0" cellspacing="0">
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
			<img src="../js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
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
		<img src="../js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
		<cfelseif ARBOL.hijos>
		<img src="../js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle">
		<cfelse>
		<img src="../js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
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
			<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisClasificacionArticulo.cfm" >
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td align="right"><strong>C&oacute;digo</strong></td>
					<td> 
						<input name="Ccodigoclas" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.Ccodigoclas")>#Form.Ccodigoclas#</cfif>">
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
						<cfif isdefined("form.nivel") and len(trim(form.nivel))>
							<input type="hidden" name="nivel" value="#form.nivel#">
						</cfif>
						<cfif isdefined("form.desc") and len(trim(form.desc))>
							<input type="hidden" name="desc" value="#form.desc#">
						</cfif>
                        <cfif isdefined("form.conse") and len(trim(form.conse)) and form.conse eq "yes">
                        	<input type="hidden" name="conse" value="yes">
							<input type="hidden" name="Mconse" value="#rsCodigoArt.Pvalor#">
						</cfif>
						<input type="hidden" name="ARBOL_POS" value="#ARBOL_POS#">
						
					</td>
				</tr>
			</table>
			</form>
			
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Clasificaciones"/>
				<cfinvokeargument name="columnas" value="Ccodigo, Ccodigoclas, Cdescripcion, Cnivel, CAid, Cconsecutivo"/>
				<cfinvokeargument name="desplegar" value="Ccodigoclas, Cdescripcion"/>
				<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# #filtro#"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="ConlisClasificacionArticulo.cfm"/>
				<cfinvokeargument name="formName" value="listaClasificacion"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="Ccodigo, Ccodigoclas, Cdescripcion, Cnivel, CAid, Cconsecutivo"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
			</cfinvoke>
	</td></tr>
	</table>
	</cfoutput>
</cfif>

</body>
</html>

