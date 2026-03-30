<cfsetting enablecfoutputonly="yes">
<!--- url.o = ordenamiento ---> 
<cfparam name="url.o" default="1">
<cfif url.o neq 1 and url.o neq 2 and url.o neq 3 and url.o neq 4>
	<cfset url.o = 1>
</cfif>
<!--- url.s = sistema --->
<cfparam name="url.s" default="">
<!--- url.m = modulo  --->
<cfparam name="url.m" default="">
<!--- url.p = proceso  --->
<cfparam name="url.p" default="">
<!--- url.e = empresa --->
<cfparam name="url.e" default="">

<!--- filtros Cedula, Nombre, Estado --->
<cfparam name="url.fC" default="">
<cfparam name="url.fN" default="">
<cfparam name="url.fA" default="">
<cfparam name="url.fE" default="">

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
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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

<cfquery datasource="#session.dsn#" name="ARBOL">
	select c.CFid as pk, c.CFcodigo as codigo, c.CFdescripcion as descripcion, c.CFnivel as nivel,  
		(select count(1) from CFuncional c2
			where c2.CFidresp = c.CFid
			  and c2.Ecodigo = c.Ecodigo) AS  hijos,
		{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as jefe_actual, c.CFpath
	from CFuncional c
	left join RHPlazas p
		on p.RHPid = c.RHPid
	left join LineaTiempo lt
		on lt.RHPid = p.RHPid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between lt.LTdesde and lt.LThasta
	left join DatosEmpleado de
		on de.DEid = lt.DEid
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and (c.CFidresp is null
	  	<cfif Len(path)>
			or c.CFidresp in (<cfqueryparam cfsqltype="cf_sql_integer" value="#path#" list="yes">)
		</cfif>
	  )
	order by c.CFpath
</cfquery>
<!--- /ARBOL --->

<!---<cfquery datasource="#session.dsn#" name="lista">
	select  distinct
		CFid, CFcodigo, CFdescripcion
	from CFuncional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and not exists (select 1
		from WfActivityParticipant wfap, WfParticipant wfp
		where wfap.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityId#">
		  and wfap.ParticipantId = wfp.ParticipantId
		  and wfp.CFid = CFuncional.CFid)
	<cfif len(url.fC)>
	  and lower(CFcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(Trim(url.fC))#%">
	</cfif>
	<cfif len(url.fN)>
	  and (lower(CFdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(Trim(url.fN))#%">)
	</cfif>

	<cfif url.o is 1>
		order by upper(CFcodigo), upper(CFdescripcion)
	<cfelseif url.o is 2>
		order by upper(CFdescripcion), upper(CFcodigo)
	<cfelseif url.o is 3>
		order by upper(CFdescripcion), upper(CFcodigo)
	<cfelseif url.o is 4>
		order by upper(CFcodigo), upper(CFdescripcion)
	<cfelse>
		order by upper(CFcodigo), upper(CFdescripcion)
	</cfif>
</cfquery>--->

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())><!---
<cfparam name="PageNum_lista" default="1">
<cfset MaxRows_lista=10>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(lista.RecordCount,1))>
<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,lista.RecordCount)>
<cfset TotalPages_lista=Ceiling(lista.RecordCount/MaxRows_lista)>
<cfset QueryString_lista=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>--->
<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<link href="../../css/web_portlet.css" rel="stylesheet" type="text/css">
<title><cf_translate key="LB_SeleccioneUnUsuario">Seleccione un usuario</cf_translate></title>
<style type="text/css">
<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
.ar1 {background-color:##D4DBF2;cursor:pointer;}
.ar2 {background-color:##ffffff;cursor:pointer;}
</style>
<script type="text/javascript" language="javascript">
<!--
<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
function eovr(row){<!--- event: MouseOver --->
	row.style.backgroundColor='##e4e8f3';
}
function eout(row){<!--- event: MouseOut --->
	row.style.backgroundColor='##ffffff';
}
function eclk(arbol_pos){<!--- event: Click --->
	location.href="conlis_part_cf.cfm?ARBOL_POS="+arbol_pos+"#JSStringFormat(QueryString_ARBOL)#";
}
//-->
</script>
</head>

<body>
<cfinclude template="conlis_part_tab.cfm">


<div class="subTitulo">
<cf_translate key="LB_SubTitulo">Seleccione un Centro Funcional</cf_translate> </div>

<div style="width:620px;height:390px;overflow:auto;margin-top:4px">
	<table cellpadding="1" cellspacing="0" border="0" width="100%">
	<tr valign="middle"
			<cfif Len(url.ARBOL_POS) is 0>
			class='ar1'
			<cfelse>
			class='ar2'
			onMouseOver="eovr(this)"
			onMouseOut="eout(this)"
			onClick="eclk('')"
			</cfif> ><td nowrap colspan="2">
		<img src="../../js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
			<cf_translate key="LB_MostrarTodo">Mostrar Todo</cf_translate>
	</td></tr>
	<!--- bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
<cfloop query="ARBOL">
<tr valign="middle"	<cfif ARBOL.pk is url.ARBOL_POS> class='ar1'
onclick="regresar('ORGUNIT','#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#','','',#ARBOL.pk#,'')"
<cfelse>class='ar2' onMouseOver="eovr(this)"
onMouseOut="eout(this)" <cfif ARBOL.hijos>onClick="eclk('#ARBOL.pk#')"<cfelse>onclick="regresar('ORGUNIT','#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#','','',#ARBOL.pk#,'')"</cfif>
</cfif>
ondblclick="regresar('ORGUNIT','#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#','','',#ARBOL.pk#,'')"
 ><td nowrap>
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
<td>#HTMLEditFormat(Trim(ARBOL.jefe_actual))#</td>
</tr>
</cfloop>
	</table>
</div>
<div style="font-weight:bold "><cf_translate key="LB_HagaClicParaAbrirUnCentroFuncionalDobleClicParaSeleccionar">Haga clic para abrir un centro funcional, doble clic para seleccionar</cf_translate></div><!---
<hr>

<form action="#CurrentPage#" method="get" name="form1"><input type="hidden" name="ActivityId" value="#HTMLEditFormat(url.ActivityId)#">
<table border="0" cellpadding="0" cellspacing="0" width="90%" align="center">
  <tr class="tituloListas">
    <td>&nbsp;</td>
    <td><a href="#CurrentPage#?o=1&amp;ActivityId=#url.ActivityId#">C&oacute;digo</a> <cfif url.o is 1>&darr;</cfif></td>
    <td>&nbsp;</td>
    <td><a href="#CurrentPage#?o=2&amp;ActivityId=#url.ActivityId#">Nombre</a> <cfif url.o is 2>&darr;</cfif></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="fC" type="text" id="fC" value="#HTMLEditFormat(url.fC)#" onFocus="this.select()"></td>
    <td>&nbsp;</td>
    <td><input name="fN" type="text" id="fN" value="#HTMLEditFormat(url.fN)#" onFocus="this.select()"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <cfloop query="lista" startRow="#StartRow_lista#" endRow="#StartRow_lista+MaxRows_lista-1#">
    <tr onclick="regresar('ORGUNIT','#JSStringFormat(Trim(CFcodigo))#','#JSStringFormat(CFdescripcion)#','','',#CFid#,'')"
		style="cursor:pointer"
		class="<cfif lista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"
		onMouseOver="listmov(this)"
		onMouseOut="listmout(this)" >
      <td>&nbsp;</td>
      <td>#Trim(CFcodigo)#</td>
      <td>&nbsp;</td>
      <td>#CFdescripcion#</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </cfloop>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4">&nbsp;
      <table border="0" width="50%" align="center">
          <tr>
            <td width="23%" align="center"><cfif PageNum_lista GT 1>
                <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#"><img src="../../imagenes/First.gif" width="18" height="13" border=0></a>
              </cfif>
            </td>
            <td width="31%" align="center"><cfif PageNum_lista GT 1>
                <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#"><img src="../../imagenes/Previous.gif" width="14" height="13" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center"><cfif PageNum_lista LT TotalPages_lista>
                <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#"><img src="../../imagenes/Next.gif" width="14" height="13" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center"><cfif PageNum_lista LT TotalPages_lista>
                <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#"><img src="../../imagenes/Last.gif" width="18" height="13" border=0></a>
              </cfif>
            </td>
          </tr>
      </table></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4">&nbsp; Mostrando usuarios #StartRow_lista# a #EndRow_lista# de #lista.RecordCount# </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" value="Buscar"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table> 
</form>
--->
</body>
</html>
</cfoutput>


