<html>
<head>
<title>Lista de Artículos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<cfquery name="conlis" datasource="#Session.DSN#">
	SELECT 	a.Aid, 
			a.Adescripcion, a.Acodigo, 
			b.IACcodigo, 
			c.IACdescripcion, 
			c.IACinventario, 
			d.Ccuenta, 
			d.Cformato, d.Cdescripcion  
	FROM Articulos a, Existencias b, IAContables c, CContables d   
	WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	  and a.Aid = b.Aid 
	  and b.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Alm#"> 
	  and a.Ecodigo = b.Ecodigo 
	  and b.IACcodigo = c.IACcodigo 	  
	  and c.Ecodigo = d.Ecodigo
	  and c.IACinventario = d.Ccuenta
	<cfif isdefined("Form.Filtrar") and (Form.Acodigo NEQ "")>
	  and upper(a.Acodigo) like '%#Ucase(Form.Acodigo)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.Adescripcion NEQ "")>
	  and upper(a.Adescripcion) like '%#Ucase(Form.Adescripcion)#%'
	</cfif>	  	
	order by a.Acodigo,a.Adescripcion 
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
function Asignar(valor1, valor2, valor3, valor4, valor5) {
	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.CcuentaD.value=valor3;

	window.opener.document.<cfoutput>#url.form#</cfoutput>.Cmayor_CformatoD.value=valor4.substring(0,4);
	if (valor4.length > 4) {
		window.opener.document.<cfoutput>#url.form#</cfoutput>.CformatoD.value=valor4.substring(5,valor4.length);
	}
	else {
		window.opener.document.<cfoutput>#url.form#</cfoutput>.CformatoD.value="";
	}

	window.opener.document.<cfoutput>#url.form#</cfoutput>.CdescripcionD.value=valor5;	
	window.close();
	limpiarC();
	window.opener.document.<cfoutput>#url.form#</cfoutput>.DDcantidad.select();

}

function limpiarC()
{           
	window.opener.document.<cfoutput>#url.form#</cfoutput>.Cid.value = "";              
	window.opener.document.<cfoutput>#url.form#</cfoutput>.DDtipo.value = "A";
	window.opener.document.<cfoutput>#url.form#</cfoutput>.DDdescripcion.value = window.opener.document.<cfoutput>#url.form#</cfoutput>.descripcion.value;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.Almacen.style.visibility = "visible";
	window.opener.document.getElementById("AlmacenLabel").style.visibility = "visible";	
	window.opener.document.<cfoutput>#url.form#</cfoutput>.Dcodigo.style.visibility = "visible";		
	window.opener.document.getElementById("DcodigoLabel").style.visibility = "visible";			
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
    <tr> 
      <td width="44%" nowrap class="tituloListas"><div align="left">Código</div></td>
      <td width="28%" nowrap class="tituloListas"><div align="left">Descripción</div></td>
      <td width="1%"  nowrap class="tituloListas"><div align="right"><input type="submit" name="Filtrar" value="Filtrar"></div></td>
    </tr>
    <tr> 
      <td nowrap><input name="Acodigo" type="text" size="40" maxlength="100"></td>
      <td colspan="2" nowrap><input name="Adescripcion" type="text" size="40" maxlength="60"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td nowrap <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="Acodigo#conlis.CurrentRow#" value="#conlis.Acodigo#"> 
        <a href="javascript:Asignar(#conlis.Aid#, '#JSStringFormat(conlis.Adescripcion)#', '#conlis.IACinventario#', '#JSStringFormat(conlis.Cformato)#', '#JSStringFormat(conlis.Cdescripcion)#');">#conlis.Acodigo#</a></td>
        <td colspan="2" nowrap <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar(#conlis.Aid#, '#JSStringFormat(conlis.Adescripcion)#', '#conlis.IACinventario#', '#JSStringFormat(conlis.Cformato)#', '#JSStringFormat(conlis.Cdescripcion)#');">#conlis.Adescripcion#</a></td>
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

