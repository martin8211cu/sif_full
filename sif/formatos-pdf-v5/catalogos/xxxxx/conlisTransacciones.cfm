<html>
<head>
<title>
	Lista de Transacciones
</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="sif.css" rel="stylesheet" type="text/css">
</head>

<cfif isDefined("url.sncod")>
	<cfset Form.sncod = url.sncod>
</cfif>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">	
	Select 	CCTcodigo, CCTdescripcion, CCTtipo
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and CCTpago <> 1
	<cfif isdefined("Form.Filtrar") and (Form.CCTcodigo NEQ "")>
  	  and upper(CCTcodigo) like '%#Ucase(Form.CCTcodigo)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.CCTdescripcion NEQ "")>
	  and upper(CCTdescripcion) like '%#Ucase(Form.CCTdescripcion)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.CCTtipo NEQ "")>
	  and upper(CCTtipo) like '%#Ucase(Form.CCTtipo)#%'
	</cfif>
</cfquery>
<cfif Form.sncod NEQ "">
	<cfquery name="rsCuentasSocios" datasource="#Session.DSN#">
		select CCTcodigo
		from CuentasSocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.sncod#">
	</cfquery>
	<!--- Query para manejar resultados--->
	<cfset conlis = QueryNew("CCTcodigo, CCTdescripcion, CCTtipo")>
	
	<cfloop query="rsTransacciones">
		<cfquery name="rsExiste" dbtype="query">
			select 1 
			from rsCuentasSocios
			where CCTcodigo = '#rsTransacciones.CCTcodigo#'
		</cfquery>
		<cfif rsExiste.RecordCount EQ 0>
			<!--- Agrega la fila procesada --->
			<cfset fila = QueryAddRow(conlis, 1)>
			<cfset tmp  = QuerySetCell(conlis, "CCTcodigo",		#rsTransacciones.CCTcodigo#) >
			<cfset tmp  = QuerySetCell(conlis, "CCTdescripcion",#rsTransacciones.CCTdescripcion#) >
			<cfset tmp  = QuerySetCell(conlis, "CCTtipo",		#rsTransacciones.CCTtipo#) >
		</cfif>			
	</cfloop>
<cfelse>
	<cfquery name="conlis" dbtype="query">
		select * from rsTransacciones
	</cfquery>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=16>
<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>

<script language="JavaScript1.2">

function Asignar(valor1, valor2) {

	limpiar();
		
	window.opener.document.<cfoutput>#url.form#.#url.cctcod#</cfoutput>.value = valor1;
	window.opener.document.<cfoutput>#url.form#.#url.cctdesc#</cfoutput>.value = valor2;
	window.close();
	
}

function limpiar() {
	window.opener.document.<cfoutput>#url.form#.#url.cctcod#</cfoutput>.value = "";
	window.opener.document.<cfoutput>#url.form#.#url.cctdesc#</cfoutput>.value = "";
}
</script>

<body>
<form action="" method="post" name="conlis">
  <table width="100%" border="0" cellspacing="0">
    <tr>
      <td width="10%" bgcolor="#006699" class="titulo"><font color="#FFFFFF">C&oacute;digo</font></td>
      <td width="70%" bgcolor="#006699" class="titulo"><div align="left"><font color="#FFFFFF">Descripci&oacute;n</font></div></td>
	  <td width="10%" bgcolor="#006699" class="titulo"><div align="left"><font color="#FFFFFF">Tipo</font></div></td>
      <td width="10%" class="titulo"><div align="right"><font color="#FFFFFF"> 
          <input type="submit" name="Filtrar" value="Filtrar">
          </font></div></td>
    </tr>
    <tr>
      <td><input type="text" name="CCTcodigo" size="5" maxlength="2"></td>
      <td><input type="text" name="CCTdescripcion" size="80" maxlength="60"></td>
	  <td colspan="2"><input type="text" name="CCTtipo" size="5" maxlength="2"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
	  	<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
          <a href="javascript: Asignar('#JSStringFormat(conlis.CCTcodigo)#','#JSStringFormat(conlis.CCTdescripcion)#');">#conlis.CCTcodigo#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
          <a href="javascript: Asignar('#JSStringFormat(conlis.CCTcodigo)#','#JSStringFormat(conlis.CCTdescripcion)#');">#conlis.CCTdescripcion#</a></td>
        <td colspan="2" <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
          <a href="javascript: Asignar('#JSStringFormat(conlis.CCTcodigo)#','#JSStringFormat(conlis.CCTdescripcion)#');">#conlis.CCTtipo#</a></td>
      </tr>
    </cfoutput> 
    <tr> 
      <td colspan="4">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="4">&nbsp; <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../Imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../Imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../Imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../Imagenes/Last.gif" border=0></a> 
                </cfif> </td>
            </tr>
          </cfoutput> 
        </table>
        <div align="center"> </div></td>
    </tr>
  </table>
<p>&nbsp;</p></form>
</body>
</html>
