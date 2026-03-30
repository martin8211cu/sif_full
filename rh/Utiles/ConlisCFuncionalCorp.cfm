<cfif isdefined("Url.CFcodigo") and not isdefined("Form.CFcodigo")>
	<cfparam name="Form.CFcodigo" default="#Url.CFcodigo#">
</cfif>
<cfif isdefined("Url.CFdescripcion") and not isdefined("Form.CFdescripcion")>
	<cfparam name="Form.CFdescripcion" default="#Url.CFdescripcion#">
</cfif>

<!--- Centro Funcional a excluir --->
<cfif isdefined("Url.excluir") and url.excluir neq -1 >
	<cfparam name="Form.excluir" default="#Url.excluir#">
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


<!--- ========================================================================================== --->
<!--- recupera la empresa corporativa --->
<cfset vEcodigoCorp = 0 >
<cfquery name="rsCorporativa" datasource="asp">
	select coalesce(e.Ereferencia, 0) as Ecorporativa
	from CuentaEmpresarial c
		join Empresa e
		on e.Ecodigo = c.Ecorporativa
	where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfif rsCorporativa.recordcount gt 0 and len(trim(rsCorporativa.Ecorporativa))>
	<cfset vEcodigoCorp = rsCorporativa.Ecorporativa >
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
		select CFidresp as padre from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigoCorp#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#current#">
		  and CFcorporativo = 1
	</cfquery>
	<cfset current = siguiente.padre>
</cfloop>
<cfif dummy ge 100> <cfthrow message="fue horrible"> </cfif>
<cfset QueryString_ARBOL=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"ARBOL_POS=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfquery name="ARBOL" datasource="#session.dsn#" >
	select c.CFid as pk, c.CFcodigo as codigo, c.CFdescripcion as descripcion, c.CFnivel as nivel,  
		(select count(1) from CFuncional c2
			where c2.CFidresp = c.CFid
			  and c2.Ecodigo = c.Ecodigo) AS  hijos
	from CFuncional c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigoCorp#">
	  and c.CFcorporativo = 1
	  and (c.CFidresp is null
						<cfif Len(path)>
							or c.CFidresp in (<cfqueryparam cfsqltype="cf_sql_integer" value="#path#" list="yes">)
						</cfif>
				)	
	<cfif isdefined("Form.excluir") and Len(Trim(Form.excluir)) NEQ 0>
		and c.CFid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.excluir#" >
	</cfif>
	order by c.CFpath
</cfquery>
<!--- /ARBOL --->

<!--- Fin Consulta sobre las Empresas Coorporativas --->

<cfoutput>
<html>
<head>
<title><cf_translate key="LB_ListaDeCentrosFuncionales">Lista de Centros Funcionales</cf_translate></title>
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
				<cfoutput>
				var descAnt = window.opener.document.#Url.form#.#Url.desc#.value;
				window.opener.document.#Url.form#.#Url.id#.value   = id;
				window.opener.document.#Url.form#.#Url.name#.value = name;
				window.opener.document.#Url.form#.#Url.desc#.value = desc;
				if (window.opener.func#trim(Url.name)#) {window.opener.func#trim(Url.name)#();}
				</cfoutput>
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
			location.href="ConlisCFuncionalCorp.cfm?ARBOL_POS="+arbol_pos+"#JSStringFormat(QueryString_ARBOL)#";
		}
	</script>
</head>
<body>

<div class="subTitulo">
	<cfparam name="url.titulo" default="">
	<cfif Len(url.titulo) is 0>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_SeleccioneUnCentroFuncional"
			Default="Seleccione un Centro Funcional"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_SeleccioneUnCentroFuncional"/>
		<cfset url.titulo=LB_SeleccioneUnCentroFuncional>
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
							<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
							<strong><cf_translate key="LB_CentrosFuncionalesEmpresariales">Centros Funcionales Empresariales</cf_translate></strong>
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
									<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
								<cfelseif ARBOL.hijos>
									<img src="/cfmx/rh/js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle">
								<cfelse>
									<img src="/cfmx/rh/js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
								</cfif>
								#HTMLEditFormat(Trim(ARBOL.codigo))# - #HTMLEditFormat(Trim(ARBOL.descripcion))#
							</td>
						</tr>
					</cfloop>
				</table>

			</td>
			<!---
			<td><strong>&nbsp;</strong></td>
			
			<td valign="top">
				<table cellpadding="1" cellspacing="0" border="0" width="100%">
					<tr valign="middle" >
						<td nowrap colspan="2" <cfif Len(url.ARBOL_POS) is 0> class='ar1' <cfelse> class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" onClick="eclk('')" </cfif>>
							<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
							<strong>Centros Funcionales Coorporativos</strong>
						</td>
					</tr>
					
					<cfloop query="rsCFCoorporativo">
						<tr valign="middle" onMouseOver="eovr(this)" onMouseOut="eout(this)" class='ar2'
							onDblClick="Asignar(#rsCFCoorporativo.pk#,'#JSStringFormat(Trim(rsCFCoorporativo.codigo))#','#JSStringFormat(rsCFCoorporativo.descripcion)#')" 
						>
							<td nowrap>
								#RepeatString('&nbsp;', 2+2)#
								<img src="/cfmx/rh/js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
								#HTMLEditFormat(Trim(rsCFCoorporativo.codigo))# - #HTMLEditFormat(Trim(rsCFCoorporativo.descripcion))#
							</td>
						</tr>
					</cfloop>
				</table>
			</td>
			--->
		</tr>

	</table>
</div>

<div style="margin-top:4px;border-top:1px solid black;font-size:10px"><cf_translate key="LB_HagaClicParaAbrirUnCentroFuncionalDobleClicParaSeleccionar">Haga clic para abrir un centro funcional, doble clic para seleccionar</cf_translate></div>

</body></html></cfoutput>
<!---
<form style="margin:0;" name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="CFcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.CFcodigo")>#Form.CFcodigo#</cfif>" onfocus="javascript:this.select();" >
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="CFdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CFdescripcion")>#Form.CFdescripcion#</cfif>" onfocus="javascript:this.select();">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="CFuncional"/>
	<cfinvokeargument name="columnas" value="convert(varchar, CFid) as CFid, rtrim(CFcodigo) as CFcodigo, CFdescripcion"/>
	<cfinvokeargument name="desplegar" value="CFcodigo, CFdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# "/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisCFuncional.cfm"/>
	<cfinvokeargument name="formName" value="listaCFuncional"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CFid,CFcodigo,CFdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>--->

