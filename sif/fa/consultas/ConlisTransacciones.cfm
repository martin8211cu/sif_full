<html>
<head>
<title>Lista de Transacciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

</head>

<!--- datos para conlis--->
<cfquery name="conlis" datasource="#session.DSN#">
	select convert(varchar,FCid) as FCid, convert(varchar,ETnumero) as ETnumero, 
		convert(varchar,Mcodigo) as Mcodigo, a.SNcodigo, ETobs, ETfecha, b.SNnombre
	from ETransacciones a, SNegocios b	 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  <cfif isDefined("Url.caja") and Len(Trim(Url.caja)) GT 0>
	  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">
	  </cfif>
	  and a.Ecodigo = b.Ecodigo
	  and a.SNcodigo = b.SNcodigo
	    
	  <cfif isdefined("form.Filtrar") and len(trim(form.ETnumero)) GT 0 >
	     and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETnumero#">
	  </cfif>

	  <cfif isdefined("form.Filtrar") and len(trim(form.ETobs)) GT 0 >
	     and upper(a.ETobs) like '%#Ucase(form.ETobs)#%'
	  </cfif>

	  <cfif isdefined("form.Filtrar") and len(trim(form.ETfecha)) GT 0 >
	     and a.ETfecha = convert(datetime, '#form.ETfecha#', 103)
	  </cfif>
	  
	  <cfif isdefined("form.Filtrar") and len(trim(form.SNnombre)) GT 0 >
	     and upper(b.SNnombre) like '%#Ucase(form.SNnombre)#%'
	  </cfif>

	  order by ETnumero
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
    <tr>
      <td width="7%" nowrap  class="tituloListas"><div align="left">N&uacute;mero</div></td>
      <td width="36%" nowrap  class="tituloListas"><div align="left">Descripci&oacute;n</div></td>
      <td width="13%" nowrap  class="tituloListas"><div align="left">Fecha</div></td>
      <td width="33%" nowrap  class="tituloListas"><div align="left">&nbsp;Cliente</div>
        </td>
      <td width="7%" class="tituloListas" nowrap><div align="left">&nbsp;</div></td>
    </tr>
    <tr> 
      <td nowrap><input name="ETnumero" type="text" size="10" maxlength="10" value="<cfif isdefined("form.Filtrar") and len(trim(form.ETnumero)) GT 0 ><cfoutput>#Form.ETnumero#</cfoutput></cfif>" style="text-align: left;" onblur="javascript:fm(this,0); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
      <td nowrap><input name="ETobs" type="text" size="50" maxlength="255" value="<cfif isdefined("form.Filtrar") and len(trim(form.ETobs)) GT 0 ><cfoutput>#Form.ETobs#</cfoutput></cfif>"></td>
      <cfset fecha = "">
	  <cfif isdefined("form.Filtrar") and len(trim(form.ETfecha)) GT 0 ><cfset fecha = LSDateFormat(Form.ETfecha,'DD/MM/YYYY')></cfif>
	  <td nowrap><cfoutput><cf_sifcalendario form='conlis' name='ETfecha' value='#fecha#'></cfoutput></td>
      <td nowrap><input name="SNnombre" type="text" size="50" maxlength="30" value="<cfif isdefined("form.Filtrar") and len(trim(form.SNnombre)) GT 0 ><cfoutput>#Form.SNnombre#</cfoutput></cfif>"></td>
      <td nowrap><input type="submit" name="Filtrar" value="Filtrar"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <!--- codigo --->
        <td nowrap <cfif conlis.CurrentRow MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>> 
          <div align="left"><a href="javascript:Asignar('#conlis.ETnumero#', '#JSStringFormat(conlis.ETobs)#');">#conlis.ETnumero#</a> </div></td>
        <!--- Descripcion --->
        <td nowrap <cfif conlis.CurrentRow MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>> 
          <a href="javascript:Asignar('#conlis.ETnumero#', '#JSStringFormat(conlis.ETobs)#');">#conlis.ETobs#</a> </td>
        <!--- Fecha --->
        <td nowrap <cfif conlis.CurrentRow MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>> 
          <a href="javascript:Asignar('#conlis.ETnumero#', '#JSStringFormat(conlis.ETobs)#');">#LSDateFormat(conlis.ETfecha,'DD/MM/YYYY')#</a> </td>
        <!--- usuario --->
        <td nowrap <cfif conlis.CurrentRow MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>> 
          <a href="javascript:Asignar('#conlis.ETnumero#', '#JSStringFormat(conlis.ETobs)#');">#conlis.SNnombre#</a> </td>
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
</form>

</body>
</html>