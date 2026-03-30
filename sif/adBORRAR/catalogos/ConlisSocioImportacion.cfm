<html>
<head>
<title>Lista de Socios de Negocios</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cfquery name="conlis" datasource="#session.DSN#">
	select SNcodigo,SNidentificacion,SNnombre 
	from SNegocios 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and SNcodigo!=9999
	<cfif isdefined("form.Filtrar") and (Len(Trim(form.SNnombre)) GT 0)>
		and upper(SNnombre) like '%#Ucase(form.SNnombre)#%'
	</cfif>

	<cfif isdefined("form.Filtrar") and (Len(Trim(form.SNidentificacion)) GT 0)>
		and upper(SNidentificacion) like '%#Ucase(form.SNidentificacion)#%'
	</cfif>

	order by SNnombre
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
		window.opener.document.form1.SocioImportacion.value=valor1;
		window.opener.document.form1.NombreSocioImportacion.value=valor2;
		window.close();
	}
</script>

<body>
<form action="" method="post" name="conlis">
	<table width="97%" border="0" cellspacing="0">
		<tr> 
			<td width="50%" class="tituloListas"><div align="left">Identificaci&oacute;n</div></td>
			<td colspan="2" width="50%" class="tituloListas"><div align="left">Socio</div></td>
		</tr>
		
		<cfoutput>
		<tr> 
			<td><input name="SNidentificacion" type="text" size="50" maxlength="50" value="<cfif isdefined("form.Filtrar") and (Len(Trim(form.SNidentificacion)) GT 0)>#form.SNidentificacion#</cfif>" ></td>
			<td><input name="SNnombre" type="text" size="50" maxlength="50" value="<cfif isdefined("form.Filtrar") and (Len(Trim(form.SNnombre)) GT 0)>#form.SNnombre#</cfif>" ></td>
			<td><input type="submit" name="Filtrar" value="Filtrar"></td>
		</tr>
		</cfoutput>
		
		<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
			<tr> 
				<td class="<cfif conlis.CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" >
					<a href="javascript:Asignar('#conlis.SNcodigo#', '#JSStringFormat(conlis.SNnombre)#');">#conlis.SNidentificacion#</a>
				</td>

				<td class="<cfif conlis.CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" >
					<a href="javascript:Asignar('#conlis.SNcodigo#', '#JSStringFormat(conlis.SNnombre)#');">#conlis.SNnombre#</a>
				</td>
			</tr>
		</cfoutput> 
		
		<tr><td colspan="3">&nbsp; </td></tr>

		<tr> 
			<td colspan="3">
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
