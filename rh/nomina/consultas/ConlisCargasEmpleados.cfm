<cfif isdefined("Url.Tcodigo") and len(trim(url.Tcodigo)) NEQ 0>
	<cfset Form.Tcodigo = Url.Tcodigo>
</cfif>

<html>
<head>
<title>Lista de Cargas Obrero Patronales</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<cfquery name="conlis" datasource="#session.DSN#">
	select distinct a.ECid, 
	b.ECdescripcion, 
	a.DClinea, 
	a.DCdescripcion
	from DCargas a, ECargas b
	where a.ECid=b.ECid
	 and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 <cfif isdefined("form.DCdescripcion") and  len(trim(form.DCdescripcion)) gt 0>
		and upper(DCdescripcion) like '%#UCase(form.DCdescripcion)#%'	
	 </cfif>
	 <cfif isdefined("form.Tcodigo") and len(trim(form.Tcodigo)) NEQ 0>
	 	 and Tcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Tcodigo#">
	 </cfif>
	 
	 order by a.ECid, DCdescripcion
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=25>
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
	limpiar();
	window.opener.document.form1.ECid.value=valor1;
	window.opener.document.form1.DCdescripcion.value=valor2;
	window.close();
}

function limpiar() {
	window.opener.document.form1.ECid.value="";
	window.opener.document.form1.DCdescripcion.value="";
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="97%" border="0" cellspacing="0">
    <tr> 
      <td bgcolor="##006699" class="tituloListas" colspan="2"><div align="left"><font color="#FFFFFF"><cf_translate  key="LB_CargasObreroPatronales">Cargas Obrero Patronales</cf_translate></font></div></td>
    </tr>
    <tr> 
      <td><input name="DCdescripcion" type="text" size="50" maxlength="80">
	     <!---  <input type="hidden" value="<cfoutput>#form.DEid#</cfoutput>" name="DEid"> --->
	  </td>
	  <td align="right">
	  <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Filtrar"
		Default="Filtrar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Filtrar"/>
	  <input type="submit" name="Filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">&nbsp;</td>
    </tr>
	<tr><td>&nbsp;</td></tr>

	<cfif conlis.RecordCount gt 0>
		<cfset corte = "" >
		<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
		
			<cfif trim(corte) neq trim(conlis.ECid) >
				<tr><td colspan="2" class="tituloListas" >#conlis.ECdescripcion#</td></tr>
			</cfif>
			
		  <tr> 
			<!--- Descripcion --->
			<td colspan="2" <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
				<input type="hidden" name="DCdescripcion#conlis.CurrentRow#" value="#conlis.DCdescripcion#"> 
				<input type="hidden" name="ECid#conlis.CurrentRow#" value="#conlis.ECid#"> 
			  <a href="javascript:Asignar(#conlis.DClinea#, '#JSStringFormat(conlis.DCdescripcion)#');">#conlis.DCdescripcion#</a>
			</td>
		  </tr>
			<cfset corte = conlis.ECid >
		</cfoutput> 
	<cfelse>	
		<tr><td colspan="2" align="center"><font size="2">--- <cf_translate  key="LB_NoHayDatos">No Hay Datos</cf_translate> ---</font></td></tr>
	</cfif>

    <tr> 
      <td >&nbsp; </td>
    </tr>
    <tr> 
      <td >&nbsp; 
	  <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="/cfmx/rh/imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a> 
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