<html>
<head>
<title>Lista de Componentes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cfquery name="conlis" datasource="asp">
	select SCuri
	from SComponentes
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(url.SScodigo)#" >
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(url.SMcodigo)#" >
	  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(url.SPcodigo)#" >
	  and SCtipo='P'

	<cfif isdefined("form.Filtrar") and len(trim(form.SCuri)) gt 0>
		and upper(SCuri) like '%#Ucase(form.SCuri)#%'
  	</cfif>
  	order by SCuri
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
	function Asignar(valor1) {
		window.opener.document.form1.SPhomeuri.value=valor1;
		window.close();
	}
</script>

<body>

<cf_templatecss>
<form action="" method="post" name="conlis">
	<table width="53%" border="0" cellspacing="0">
		<tr>
			<td bgcolor="#336699" class="subTitulo"><font color="#FFFFFF">P&aacute;gina Inicial</font></td>
			<td bgcolor="#336699" width="1%" class="subTitulo"><input type="submit" name="Filtrar" value="Filtrar"></td>
		</tr>

		<tr><td><input name="SCuri" type="text" size="80" maxlength="255"></td></tr>
		
		<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
			<tr><td nowrap class="<cfif conlis.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"><a href="javascript:Asignar('#conlis.SCuri#');">#conlis.SCuri#</a></td></tr>
		</cfoutput> 

		<tr><td colspan="2">&nbsp;</td></tr>
		
		<tr> 
			<td colspan="2">
				<table border="0" width="50%" align="center">
					<cfoutput> 
					<tr> 
						<td width="23%" align="center"><cfif PageNum_conlis GT 1><a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../imagenes/First.gif" border=0></a></cfif></td>
						<td width="31%" align="center"> <cfif PageNum_conlis GT 1><a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../imagenes/Previous.gif" border=0></a></cfif></td>
						<td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis><a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../imagenes/Next.gif" border=0></a></cfif></td>
						<td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis><a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../imagenes/Last.gif" border=0></a></cfif></td>
					</tr>
					</cfoutput>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
</html>