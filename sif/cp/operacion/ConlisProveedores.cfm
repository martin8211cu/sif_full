<html>
<head>
<title>Lista de Proveedores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>

<script language="JavaScript" type="text/javascript">
function rtrim(tira){

			if (tira.name){
					VALOR=tira.value}
			 else{
			 		VALOR=tira}

			var CARACTER=""
			var HILERA=VALOR
			INICIO = VALOR.lastIndexOf(" ")
			
			if(INICIO>-1){
			
						 for(var i=VALOR.length; i>0; i--){  
						 
									 CARACTER= VALOR.substring(i,i-1)
									 if(CARACTER==" ")
												HILERA = VALOR.substring(0,i-1)
									 else
												i=-200
						  }
			   }
			  return HILERA
}
</script>
</head>

<cfquery name="conlis" datasource="#Session.DSN#">	
	select SNcodigo, SNnombre, SNidentificacion
	from SNegocios where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	<cfif isdefined("Form.Filtrar") and (Form.SNidentificacion NEQ "")>
  	  and upper(SNidentificacion) like '%#Ucase(Form.SNidentificacion)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.SNnombre NEQ "")>
	  and upper(SNnombre) like '%#Ucase(Form.SNnombre)#%'
	</cfif>	  
	  and SNtiposocio in ('A','P')
	order by SNnombre, SNidentificacion 
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
	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
	if (rtrim(window.opener.document.<cfoutput>#url.form#.#url.sug#</cfoutput>.value) == '' || 
	    window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value == window.opener.document.<cfoutput>#url.form#.#url.sug#</cfoutput>.value)
		window.opener.document.<cfoutput>#url.form#.#url.sug#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
	window.close();
}
</script>

<body>
<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
    <tr> 
      <td width="44%"  class="tituloListas"><div align="left">Proveedor</div></td>
      <td width="28%" class="tituloListas"><div align="left">Nombre</div></td>
      <td width="1%" class="tituloListas"><div align="right"> 
          <input type="submit" name="Filtrar" value="Filtrar">
          </div></td>
    </tr>
    <tr> 
      <td><input name="SNidentificacion" type="text" size="40" maxlength="100"></td>
      <td colspan="2"><input name="SNnombre" type="text" size="40" maxlength="60"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="SNidentificacion#conlis.CurrentRow#" value="#conlis.SNidentificacion#"> 
          <a href="javascript:Asignar(#conlis.SNcodigo#, '#JSStringFormat(conlis.SNnombre)#');">#conlis.SNidentificacion#</a></td>
        <td colspan="2" <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar(#conlis.SNcodigo#, '#JSStringFormat(conlis.SNnombre)#');">#conlis.SNnombre#</a></td>
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

