
<html>
<head>
<title>Lista de Conceptos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>
	
<cfquery name="conlis" datasource="#Session.DSN#">

	SELECT Cid, Cdescripcion, Ccodigo
	FROM Conceptos 
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  AND Ctipo = 'G'			
	<cfif isdefined("Form.Filtrar") and (Form.Ccodigo NEQ "")>
	  and upper(Ccodigo) like '%#Ucase(Form.Ccodigo)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.Cdescripcion NEQ "")>
	  and upper(Cdescripcion) like '%#Ucase(Form.Cdescripcion)#%'
	</cfif>	  
	order by Ccodigo, Cdescripcion

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
function Asignar(valor1, valor2) {
	window.opener.document.<cfoutput>#url.form#</cfoutput>.CcuentaD.value=""; 
	window.opener.document.<cfoutput>#url.form#</cfoutput>.CdescripcionD.disabled = false;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.CdescripcionD.value="";
	window.opener.document.<cfoutput>#url.form#</cfoutput>.CdescripcionD.disabled = true;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.CformatoD.value=""; 

	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
	<cfif isDefined("Url.depto") and Len(Trim(Url.depto)) GT 0>	
		window.opener.TraerCuentaConcepto(valor1,<cfoutput>#Url.depto#</cfoutput>);
	</cfif>
	window.close();
	limpiarA();
	window.opener.document.<cfoutput>#url.form#</cfoutput>.DDcantidad.select();
}

function limpiarA()
{   
	window.opener.document.<cfoutput>#url.form#</cfoutput>.Aid.value = "";
	window.opener.document.<cfoutput>#url.form#</cfoutput>.DDtipo.value = "S";	
	window.opener.document.<cfoutput>#url.form#</cfoutput>.DDdescripcion.value = window.opener.document.<cfoutput>#url.form#</cfoutput>.descripcion.value;	
	window.opener.document.<cfoutput>#url.form#</cfoutput>.Almacen.style.visibility = "hidden";
	window.opener.document.getElementById("AlmacenLabel").style.visibility = "hidden";		
	/*window.opener.document.<cfoutput>#url.form#</cfoutput>.Dcodigo.style.visibility = "hidden";
	window.opener.document.getElementById("DcodigoLabel").style.visibility = "hidden";				*/	
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
    <tr> 
      <td width="44%" nowrap  class="tituloListas"><div align="left">Codigo</div></td>
      <td width="23%" nowrap  class="tituloListas"><div align="left">Descripcion</div></td>
      <td width="33%" nowrap class="tituloListas"><div align="right"> 
          <input type="submit" name="Filtrar" value="Filtrar">
      </div></td>
    </tr>
    <tr> 
      <td nowrap><input name="Ccodigo" type="text" size="40" maxlength="100"></td>
      <td colspan="2" nowrap><input name="Cdescripcion" type="text" size="40" maxlength="60"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td nowrap <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="Ccodigo#conlis.CurrentRow#" value="#conlis.Ccodigo#"> 
        <a href="javascript:Asignar(#conlis.Cid#, '#JSStringFormat(conlis.Cdescripcion)#');">#conlis.Ccodigo#</a></td>
        <td colspan="2" nowrap <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar(#conlis.Cid#, '#JSStringFormat(conlis.Cdescripcion)#');">#conlis.Cdescripcion#</a></td>
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
          </cfoutput> </table> <div align="center"> </div></td>
    </tr>
  </table>
<p>&nbsp;</p></form>
</body>
</html>

