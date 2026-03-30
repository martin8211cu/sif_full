<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 24 de mayo del 2005
	Motivo:	Modificación en el depliegue de la información del conlis, se hace agrupa por Banco y Cuenta Bancaria
----------->
<cfinclude template="../../Utiles/general.cfm">
<html>
	<head>
		<title>Lista de Estados de Cuenta</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cf_templatecss>
		<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
	</head>
<body>

<cfquery name="conlis" datasource="#session.DSN#">
	select ECid, ECdescripcion, ECdesde, EChasta, ECdebitos, ECcreditos, EChistorico, ec.CBid, 
		CBcodigo, CBdescripcion, cb.Bid, b.Bdescripcion
	from ECuentaBancaria ec inner join CuentasBancos cb
	  on ec.CBid = cb.CBid left outer join Bancos b
   	  on cb.Ecodigo = b.Ecodigo and
	     cb.Bid = b.Bid
	where cb.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">   
	  and EChistorico = 'S'
    <cfif isdefined("Form.Filtrar") and (isdefined("form.fECdesde") and Form.fECdesde NEQ "")>
	    and ec.ECdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fECdesde)#">
    </cfif>

    <cfif isdefined("Form.Filtrar") and (isdefined("form.fEChasta") and Form.fEChasta NEQ "")>
	    and ec.EChasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fEChasta)#">
    </cfif>
	
	order by Bid,CBid,ECdesde, EChasta

</cfquery>



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
	function Asignar(valor1, valor2 ) {
		window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
		window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
		window.close();
	}
</script>

<body>

<form action="" method="post" name="conlis">
	<table width="100%" border="0" cellspacing="0">
		<tr  class="tituloListas" nowrap> 
			<td><div align="left">Fecha Desde</div></td>
			<td colspan="3"><div align="left">Fecha Hasta</div></td>	  
		</tr>
		<tr> 
			<td><cf_sifcalendario form="conlis" name="fECdesde"></td>
			<td><cf_sifcalendario form="conlis" name="fEChasta"></td>
			<td ><div align="left"><font color="#FFFFFF">
			  <input type="submit" name="Filtrar" value="Filtrar"></font></div>
			</td>
			<td >&nbsp;</td>	  
		</tr>
		
		<cfset banco = 0>
		<cfset cuenta = 0>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
		<cfif banco NEQ #conlis.Bid#>
			<tr><td>&nbsp;</td></tr>
			<tr bgcolor="ACACAC">
				<td colspan="5">
					<font size="1"><strong>#conlis.Bdescripcion#</strong></font>
				</td>
			</tr>
			<cfset banco = #conlis.Bid#>
		</cfif>
		<cfif cuenta NEQ #conlis.CBid#>
			<tr bgcolor="D4D4D4">
				<td colspan="5">
					<font size="1"><strong>&nbsp;&nbsp;&nbsp;#conlis.CBdescripcion#</strong></font>
				</td>
			</tr>
			<tr bgcolor="EBEBEB">
				<td nowrap>&nbsp;&nbsp;<strong>Fecha Desde</strong></td>
				<td nowrap><strong>Fecha Hasta</strong></td>
				<td nowrap align="right"><strong>Débitos</strong></td>
				<td nowrap align="right"><strong>Créditos</strong></td>	
			</tr>
			<cfset cuenta = #conlis.CBid#>
		</cfif>
      <tr onClick="javascript:Asignar(#conlis.ECid#, '#JSStringFormat(conlis.ECdescripcion)#');" 
	  	style="cursor: pointer;"
		onMouseOver="javascript: style.color = 'red'" 
		onMouseOver="javascript: style.color = 'red'" 
		onMouseOut="javascript: style.color = 'black'"
		<cfif #conlis.CurrentRow# MOD 2> class="listaNon" <cfelse> class="listaPar" </cfif> nowrap> 
        <!--- <td nowrap>#conlis.ECdescripcion#</td> --->
        <td nowrap><input type="hidden" name="#conlis.ECid#" value="#conlis.ECid#">#LSDateFormat(conlis.ECdesde,'dd/mm/yyyy')#</td>
        <td nowrap>#LSDateFormat(conlis.EChasta,'dd/mm/yyyy')#</td>
        <td nowrap align="right">#LSCurrencyFormat(conlis.ECdebitos,'none')#</td>
        <td nowrap align="right">#LSCUrrencyFormat(conlis.ECcreditos,'none')#</td>				
      </tr>
    </cfoutput> 
    <tr> 
      <td colspan="3">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp; <table border="0" width="50%" align="center">
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

