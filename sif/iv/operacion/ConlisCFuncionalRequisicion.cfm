<cfif isdefined("Url.CFcodigo") and not isdefined("Form.CFcodigo")>
	<cfparam name="Form.CFcodigo" default="#Url.CFcodigo#">
</cfif>
<cfif isdefined("Url.CFdescripcion") and not isdefined("Form.CFdescripcion")>
	<cfparam name="Form.CFdescripcion" default="#Url.CFdescripcion#">
</cfif>
<cfif isdefined("Url.EcodigoRequi") and not isdefined("Form.EcodigoRequi")>
	<cfparam name="Form.EcodigoRequi" default="#Url.EcodigoRequi#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.CFcodigo") and Len(Trim(Form.CFcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(CFcodigo) like '%" & #UCase(Form.CFcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CFcodigo=" & Form.CFcodigo>
</cfif>

<cfif isdefined("Form.CFdescripcion") and Len(Trim(Form.CFdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(CFdescripcion) like '%" & #UCase(Form.CFdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CFdescripcion=" & Form.CFdescripcion>
</cfif>

<cfif isdefined("Form.EcodigoRequi") and Len(Trim(Form.EcodigoRequi)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EcodigoRequi=" & Form.EcodigoRequi>
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
		select ( case CFnivel when 0 then null else CFidresp end ) as padre 
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoRequi#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#current#">
	</cfquery>
	<cfset current = siguiente.padre>
</cfloop>
<cfif dummy ge 100> <cf_errorCode	code = "50156" msg = "Excede la cantidad de niveles."> </cfif>
<cfset QueryString_ARBOL=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"ARBOL_POS=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>
<cfquery name="ARBOL" datasource="#session.dsn#" >
	select c.CFid as pk, 
		   c.CFcodigo as codigo, 
		   c.CFdescripcion as descripcion, 
		   c.CFnivel as nivel,  
		   ( select count(1) from CFuncional c2
			 where ( case c2.CFnivel when 0 then null else c2.CFidresp end ) = c.CFid
			   and c2.Ecodigo = c.Ecodigo) AS  hijos
	from CFuncional c
	where c.Ecodigo = #form.EcodigoRequi#
	  and (   ( case c.CFnivel when 0 then null else c.CFidresp end ) is null
						<cfif Len(path)>
							or ( case c.CFnivel when 0 then null else c.CFidresp end ) in (#path#)
						</cfif>
				)		
	order by c.CFpath
</cfquery>

<!--- /ARBOL --->
<cfoutput>
<html>
<head>
<title>Lista de Centros Funcionales</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>

	<style type="text/css">
		<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
		.ar1 {background-color:##D4DBF2;cursor:pointer;}
		.ar2 {background-color:##ffffff;cursor:pointer;}
	</style>

	<script type="text/javascript" language="javascript">
		<!--- Recibe conexion, form, name y desc --->
		function Asignar(id,name,desc) {
			if (window.opener != null) {				
				var descAnt = window.opener.document.requisicion.CFdescripcion.value;
				window.opener.document.requisicion.CFidR.value   = id;
				window.opener.document.requisicion.CFcodigoR.value = name;
				window.opener.document.requisicion.CFdescripcionR.value = desc;				
				window.close();
			}
		}
		<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
		function eovr(row){<!--- event: MouseOver --->
			row.style.backgroundColor='##e4e8f3';
		}
		function eout(row){<!--- event: MouseOut --->
			row.style.backgroundColor='##ffffff';
		}
		function eclk(arbol_pos){<!--- event: Click --->
			location.href="ConlisCFuncionalRequisicion.cfm?ARBOL_POS="+arbol_pos+"#JSStringFormat(QueryString_ARBOL)#";
		}
	</script>
</head>
<body>

<div class="subTitulo">
	<cfparam name="url.titulo" default="">
	<cfif Len(url.titulo) is 0>
		<cfset url.titulo="Seleccione un Centro Funcional">
	</cfif>
	#HTMLEditFormat(url.titulo)#
</div>

<div style="width:620px;height:390px;overflow:auto;margin-top:4px">
	<table cellpadding="1" cellspacing="0" border="0" width="100%">
		<tr>
			<td valign="top">
				<table cellpadding="1" cellspacing="0" border="0" width="100%">
					<tr valign="middle" >
						<td nowrap <cfif Len(url.ARBOL_POS) is 0> class='ar1' <cfelse> class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" onClick="eclk('')" </cfif>>
							<img src="../../js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
							<strong>Centros Funcionales Empresariales</strong>
						</td>
					</tr>
	
					<!--- bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
					<cfloop query="ARBOL">
						<tr valign="middle"	
							<cfif ARBOL.pk is url.ARBOL_POS> class='ar1'
								onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"
							<cfelse>
								class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" 
								<cfif ARBOL.hijos>
									onClick="eclk('#ARBOL.pk#')"
								<cfelse>
									onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"
								</cfif>
							</cfif>
							onDblClick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')" 
						>
							<td nowrap>
								#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
								<cfif ARBOL.hijos and ListFind(path,ARBOL.pk)>
									<img src="../../js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
								<cfelseif ARBOL.hijos>
									<img src="../../js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle">
								<cfelse>
									<img src="../../js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
								</cfif>
								#HTMLEditFormat(Trim(ARBOL.codigo))# - #HTMLEditFormat(Trim(ARBOL.descripcion))#
							</td>
						</tr>
					</cfloop>
				</table>

			</td>
		</tr>
	</table>
</div>

<div style="margin-top:4px;border-top:1px solid black;font-size:10px">Haga clic para abrir un centro funcional, doble clic para seleccionar</div>

</body></html></cfoutput>


