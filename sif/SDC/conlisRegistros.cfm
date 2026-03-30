<html>
<head>
<title>Registros para Monitoreo</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cfif isdefined("url.tabla") >
	<cfset form.tabla = url.tabla >
</cfif>

<!--- recupera las llaves de la tabla --->
<cfquery name="rsLlaves" datasource="sdc">
	select PBllaves 
	from PBitacora
	where PBtabla = '#form.tabla#'
</cfquery>
<cfset vLlaves = ListToArray(rsLlaves.PBllaves, ',')>

<cfset campos = "" >
<cfset order  = "" >
<cfloop index="i" from="1" to="#ArrayLen(vLlaves)#" >
	<cfif i eq 1 >
		<cfset campos = "convert(varchar, " & vLlaves[i] & ") as " & vLlaves[i] >
		<cfset order = vLlaves[i] >
	<cfelse>
		<cfset campos = campos &  ", convert(varchar, " & vLlaves[i] & ") as " & vLlaves[i]  >
		<cfset order  = order &  ", " & vLlaves[i]  >
	</cfif>
</cfloop>

<!--- crea el where del filtro --->
<cfoutput>
<cfset j = 1 >
<cfset actWhere = "" >
<cfloop index="i" from="1" to="#ArrayLen(vLlaves)#" >
	<cfset campo = "form." & trim(vLlaves[i])>
	<cfif isdefined(Evaluate("campo")) and  len(trim(Evaluate(campo))) gt 0 >
		<cfif j eq 1>
			<cfset actWhere = "where upper(convert(varchar, " & trim(vLlaves[i]) & ")) like upper('%" & Evaluate(campo) & "%')">
		<cfelse>
			<cfset actWhere = actWhere & " and upper(convert(varchar, " & trim(vLlaves[i]) & ")) like upper('%" & Evaluate(campo) & "%')">
		</cfif>
		<cfset j = j+1 >
	</cfif>
</cfloop>
</cfoutput>

<cfset sql = "select " & campos & " from " & tabla>
<cfif isdefined("form.Filtrar") and len(trim(actWhere)) gt 0 >
	<cfset sql = sql & " " & actWhere>
</cfif>
<cfset sql = sql & " order by " & order>

<cfquery name="conlis" datasource="sdc">
	#PreserveSingleQuotes(sql)#
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
function Asignar( valor1 ) {
	window.opener.document.form1.llave.value = valor1;
	window.close();
}
</script>

<body>
<form action="" method="post" name="conlis">
	<table width="100%" border="0" cellspacing="0">
    	<tr> 
			<cfoutput>
			<cfloop index="i" from="1" to="#ArrayLen(vLlaves)#">
				<td class="tituloListas">
					<div align="left">#vLlaves[i]#</div>
				</td>
			</cfloop>
			</cfoutput>

      		<td width="1%" class="tituloListas" align="right">
   				<input type="submit" name="Filtrar" value="Filtrar">
          	</td>
		</tr>

		<tr> 
			<cfloop index="i" from="1" to="#ArrayLen(vLlaves)#">	
				<td>
					<input name="<cfoutput>#trim(vLlaves[i])#</cfoutput>" type="text" size="30" maxlength="30">
				</td>
			</cfloop>
		</tr>

    	<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
			<!--- Crea los valores concatenados con | para pasarlos a la consulta --->
			<cfset valores = "">
			<cfloop index="i" from="1" to="#ArrayLen(vLlaves)#">
				<cfset valor = "conlis." & trim(vLlaves[i]) >
				<cfset tmp = Evaluate(valor) >
				<cfif i eq 1 >
					<cfset valores = trim(tmp) >
				<cfelse>	
					<cfset valores = trim(valores) & "|" & trim(tmp)  >
				</cfif>
			</cfloop>

      		<tr> 
				<cfloop index="i" from="1" to="#ArrayLen(vLlaves)#">
					<cfset valor = "conlis." & trim(vLlaves[i]) >
					<cfset tmp = Evaluate(valor) >
					<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
						<a href="javascript:Asignar('#valores#');">#tmp#</a>
					</td>
				</cfloop>	
      		</tr>
    	</cfoutput> 
    <tr> 
      <td colspan="3">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp; 
	  <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="Last.gif" border=0></a> 
                </cfif> </td>
            </tr>
          </cfoutput> </table> <div align="center"> </div></td>
    </tr>
  </table>
<p>&nbsp;</p></form>
</body>
</html>