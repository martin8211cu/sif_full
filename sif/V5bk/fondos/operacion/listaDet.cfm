<cfquery name="rs" datasource="#session.Fondos.dsn#">
	select CJX19REL,CJX20NUM,CJX21LIN,CJX21DSC , convert(varchar(20),CJX21MDU,1) CJX21MDU  from CJX021
	WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX19REL#" >	
	AND   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX20NUM#" >		
	AND  CJX21TIP <> 'I'
 </cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_rs" default="1">
<cfset MaxRows_rs=10>
<cfset StartRow_rs=Min((PageNum_rs-1)*MaxRows_rs+1,Max(rs.RecordCount,1))>
<cfset EndRow_rs=Min(StartRow_rs+MaxRows_rs-1,rs.RecordCount)>
<cfset TotalPages_rs=Ceiling(rs.RecordCount/MaxRows_rs)>
<cfset QueryString_rs=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rs,"PageNum_rs=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rs=ListDeleteAt(QueryString_rs,tempPos,"&")>
</cfif>

<form name="formlista" method="post">
	<input type="hidden" name="CJX19REL">
	<input type="hidden" name="CJX20NUM">
	<input type="hidden" name="CJX21LIN">
	<input type="hidden" name="mododet" value="ALTA" >
	<input type="hidden" name="modo" value="CAMBIO" >

<table cellpadding="0" cellspacing="0">

<link href="/cfmx/sif/V5/css/estilos.css" rel="stylesheet" type="text/css">

<tr>
	<td width="1%" class="tituloListas">&nbsp;</td>
	<td class="tituloListas">Línea</td>
	<td class="tituloListas">Descripción</td>
	<td class="tituloListas">Monto</td>
</tr>
<cfoutput query="rs" startRow="#StartRow_rs#" maxRows="#MaxRows_rs#" >
	<tr onClick="javascript:editar(#rs.CJX19REL#,#rs.CJX20NUM#,#rs.CJX21LIN#);" style="cursor:pointer;"
		class="<cfif rs.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" 
		onmouseover="style.backgroundColor='##E4E8F3';" 
		onMouseOut="style.backgroundColor='<cfif rs.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
	 >
		<td><cfif isdefined("form.CJX21LIN") and form.CJX21LIN eq rs.CJX21LIN><img border="0" src="../../../imagenes/addressGo.gif"><cfelse>&nbsp;</cfif></td>
		<td>#rs.CJX21LIN#</td>
		<td>#rs.CJX21DSC#</td>
		<td>#rs.CJX21MDU#</td>
	</tr>
</cfoutput>
		<tr> 
			<td colspan="3">
				<table border="0" width="50%" align="center">
					<cfoutput> 
					<tr> 
						<td width="23%" align="center"><cfif PageNum_rs GT 1><a href="#CurrentPage#?PageNum_rs=1#QueryString_rs#&CJX19REL=#form.CJX19REL#"><img src="../../../imagenes/First.gif" border=0></a></cfif></td>
						<td width="31%" align="center"> <cfif PageNum_rs GT 1><a href="#CurrentPage#?PageNum_rs=#Max(DecrementValue(PageNum_rs),1)##QueryString_rs#&CJX19REL=#form.CJX19REL#"><img src="../../../imagenes/Previous.gif" border=0></a></cfif></td>
						<td width="23%" align="center"> <cfif PageNum_rs LT TotalPages_rs><a href="#CurrentPage#?PageNum_rs=#Min(IncrementValue(PageNum_rs),TotalPages_rs)##QueryString_rs#&CJX19REL=#form.CJX19REL#"><img src="../../../imagenes/Next.gif" border=0></a></cfif></td>
						<td width="23%" align="center"> <cfif PageNum_rs LT TotalPages_rs><a href="#CurrentPage#?PageNum_rs=#TotalPages_rs##QueryString_rs#"><img src="../../../imagenes/Last.gif" border=0></a></cfif></td>
					</tr>
					</cfoutput>
				</table>
			</td>
		</tr>
</table>
</form>

<script type="text/javascript" language="javascript1.2">
	function editar(CJX19REL,CJX20NUM,CJX21LIN){
		document.formlista.CJX19REL.value = CJX19REL;
		document.formlista.CJX20NUM.value = CJX20NUM;
		document.formlista.CJX21LIN.value = CJX21LIN;	
		document.formlista.mododet.value = 'CAMBIO';	
		document.formlista.submit();
	}

</script>
