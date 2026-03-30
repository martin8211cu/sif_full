<html>
<head>
<title>
	Lista de Transacciones
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cfif isDefined("url.caja")>
	<cfset Form.caja = url.caja>
</cfif>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">	
	Select 	ct.CCTcodigo, ct.CCTdescripcion, case ct.CCTtipo when 'C' then 'Crédito' when 'D' then 'Débito' end as CCTtipo
	from FAtransacciones a inner join CCTransacciones ct
		on a.CCTcodigo = ct.CCTcodigo
		and a.Ecodigo = ct.Ecodigo
	where ct.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.Filtrar") and (Form.CCTcodigo NEQ "")>
  	  and upper(CCTcodigo) like '%#Ucase(Form.CCTcodigo)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.CCTdescripcion NEQ "")>
	  and upper(ct.CCTdescripcion) like '%#Ucase(Form.CCTdescripcion)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.CCTtipo NEQ "")>
	  and upper(ct.CCTtipo) like '%#Ucase(Form.CCTtipo)#%'
	</cfif>
</cfquery>
<cfquery name="rsTransaccionCaja" datasource="#Session.DSN#">
	select *
	from TipoTransaccionCaja 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.caja#">
</cfquery>
<cfif Form.caja NEQ "">
	<!--- Query para manejar resultados--->
	<cfset conlis = QueryNew("CCTcodigo, CCTdescripcion, CCTtipo")>
	
	<cfloop query="rsTransacciones">
		<cfquery name="rsExiste" dbtype="query">
			select 1 
			from rsTransaccionCaja
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
      <td width="10%"  class="tituloListas">C&oacute;digo</td>
      <td width="70%"  class="tituloListas"><div align="left">Descripci&oacute;n</div></td>
	  <td width="10%"  class="tituloListas" colspan="2"><div align="left">Tipo</div></td>
      <td width="10%" class="tituloListas"><div align="right">
          <input type="submit" name="Filtrar" value="Filtrar">
          </div></td>
    </tr>
    <tr>
      <td><input type="text" name="CCTcodigo" size="5" maxlength="2"></td>
      <td><input type="text" name="CCTdescripcion" size="80" maxlength="60"></td>
	  <td colspan="2"><select name="CCTtipo" >
  		<option value="">T - Todos</option>
  		<option value="D">D - Débito</option>
  		<option value="C">C - Crédito</option>
		</select>
	</td>
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
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../imagenes/Last.gif" border=0></a> 
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