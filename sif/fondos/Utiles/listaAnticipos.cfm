<!---************************ --->
<!---** TOTALES DE RELACION ** --->
<!---************************ --->
<cfset DIGITADO = "0.00">
<cfset GASTOS = "0.00">
<cfset ANTICIPOS = "0.00">
<cfset DIFERENCIA = "0.00">
<cfquery name="rsDigitado" datasource="#session.Fondos.dsn#">
	select convert(varchar(20),isnull(sum(CJX20MNT),0),1) CJX20MNT
	from CJX019, CJX020
	where CJX019.CJX19REL = CJX020.CJX19REL
	and CJ01ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
	and CJX19EST ='P'
</cfquery>
<cfset DIGITADO = "#rsDigitado.CJX20MNT#">

<cfquery name="rsGastos" datasource="#session.Fondos.dsn#">
	select convert(varchar(20),isnull(sum(CJX20MNT),0),1) CJX20MNT
	from CJX020
	where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX19REL#">
</cfquery>
<cfset GASTOS = "#rsGastos.CJX20MNT#">

<cfquery name="rsAnticipos" datasource="#session.Fondos.dsn#">
	select convert(varchar(20),isnull(sum(CJX23MON * (case when CJX23TTR = 'D' then -1 else 1 end)),0),1) CJX23MON
	from CJX023
	where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX19REL#">
</cfquery>
<cfset ANTICIPOS = "#rsAnticipos.CJX23MON#">

<cfset DIFERENCIA = #LSCurrencyFormat(replace(rsGastos.CJX20MNT,",","","All") - replace(rsAnticipos.CJX23MON,",","","All"),"None")#>

<cfif isdefined("url.mododet") and len(trim(url.mododet)) gt 0  and  not isdefined("form.mododet")>
	<cfset  form.mododet = url.mododet >
</cfif>

<cfquery name="rs" datasource="#session.Fondos.dsn#">
	SELECT CJX5IDE,CJX5DES, SALDO = CJX5MON-isnull(CJX5MSP,0.00)-CJX5MAP,1
	from CJX005 a
	WHERE CJ01ID  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
    AND CJX5EST='P'  
    AND (CJX5MON - (isnull(CJX5MSP,0.00) +CJX5MAP) ) > 0
    AND  not exists  (SELECT 1
			        	FROM  CJX023  b
						WHERE CJX23TIP ='V' 
				    	and CJX19REL =  <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CJX19REL#" > 
				    	and a.CJX5IDE = b.CJX5IDE)	
	order by CJX5IDE
</cfquery>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_rs" default="1">
<cfset MaxRows_rs=25>
<cfset StartRow_rs=Min((PageNum_rs-1)*MaxRows_rs+1,Max(rs.RecordCount,1))>
<cfset EndRow_rs=Min(StartRow_rs+MaxRows_rs-1,rs.RecordCount)>
<cfset TotalPages_rs=Ceiling(rs.RecordCount/MaxRows_rs)>
<cfset QueryString_rs=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rs,"PageNum_rs=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rs=ListDeleteAt(QueryString_rs,tempPos,"&")>
</cfif>
<div id='TOTALES' style=" display: ">
<table cellpadding="0" cellspacing="0">
<!---********************************************************* --->
<tr>
  <td   align="left" ><p><strong>Gastos:</strong></p></td>
  <td >
	<INPUT  tabindex="-1" 
		ONFOCUS="this.blur();" 
		NAME="GASTOS" 
		VALUE="<cfoutput>#GASTOS#</cfoutput>" 
		size="15"  
		style="border: medium none; text-align:left; size:auto;"
		tabindex="2"
	>						  
  </td>	  
  <td width="21%" ><p><strong>Anticipos:</strong></p></td>
  <td width="29%" >
  <INPUT  tabindex="-1" 
		ONFOCUS="this.blur();" 
		NAME="ANTICIPOS" 
		VALUE="<cfoutput>#ANTICIPOS#</cfoutput>" 
		size="15"  
		style="border: medium none; text-align:left; size:auto;"
	>
	</td>
</tr>
<!---********************************************************* --->
<tr>
  <td width="21%" ><p><strong>Diferencia:</strong></p></td>
  <td width="29%" >
	<INPUT  tabindex="-1" 
		ONFOCUS="this.blur();" 
		NAME="DIFERENCIA" 
		VALUE="<cfoutput>#DIFERENCIA#</cfoutput>" 
		size="15"  
		style="border: medium none; text-align:left; size:auto;"
	>							  
  </td>
  <td width="21%" ><p><strong>Digitado:</strong></p></td>
  <td width="29%" >
	<INPUT  tabindex="-1" 
		ONFOCUS="this.blur();" 
		NAME="DIGITADO" 
		VALUE="<cfoutput>#DIGITADO#</cfoutput>" 
		size="15"  
		style="border: medium none; text-align:left; size:auto;"
	>					  
  </td>
</tr>
<!---********************************************************* --->
<tr>
  <TD>&nbsp </TD>
</tr>
<!---********************************************************* --->
<!--- <tr>
  <td colspan="4"><hr></td>
</tr> --->
</table>
<!---********************************************************* --->

<div id='LSTANT' style=" display:none ">
<table cellpadding="0" cellspacing="0">

<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
<tr>
<td colspan="4"  align="center" class="tituloListas"><strong> Anticipos sin aplicar</strong></td>
</tr>
<tr>
	<td width="1%" class="tituloListas">&nbsp;</td>
	<td class="tituloListas">Anticipo</td>
	<td class="tituloListas">Descripción</td>
	<td class="tituloListas">Monto</td>
</tr>
<cfoutput query="rs" startRow="#StartRow_rs#" maxRows="#MaxRows_rs#" >
	<tr onClick="javascript:editar(#rs.CJX5IDE#,#rs.SALDO#);" 
		class="<cfif rs.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" 
		onmouseover="style.backgroundColor='##E4E8F3';" 
		onMouseOut="style.backgroundColor='<cfif rs.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
	 >
		<td><cfif isdefined("form.CJX5IDE") and form.CJX5IDE eq rs.CJX5IDE><img border="0" src="../../imagenes/addressGo.gif"><cfelse>&nbsp;</cfif></td>
		<td>#rs.CJX5IDE#</td>
		<td>#rs.CJX5DES#</td>
		<td align="right">#LsCurrencyFormat(Evaluate('#Trim(rs.SALDO)#'),"none")#</td>
	</tr>
</cfoutput>
		<tr> 
			<td colspan="3">
				<table border="0" width="50%" align="center">
					<cfoutput> 
					<tr> 
						<td width="23%" align="center"><cfif PageNum_rs GT 1><a href="#CurrentPage#?PageNum_rs=1#QueryString_rs#"><img src="../../imagenes/First.gif" border=0></a></cfif></td>
						<td width="31%" align="center"> <cfif PageNum_rs GT 1><a href="#CurrentPage#?PageNum_rs=#Max(DecrementValue(PageNum_rs),1)##QueryString_rs#"><img src="../../imagenes/Previous.gif" border=0></a></cfif></td>
						<td width="23%" align="center"> <cfif PageNum_rs LT TotalPages_rs><a href="#CurrentPage#?PageNum_rs=#Min(IncrementValue(PageNum_rs),TotalPages_rs)##QueryString_rs#"><img src="../../imagenes/Next.gif" border=0></a></cfif></td>
						<td width="23%" align="center"> <cfif PageNum_rs LT TotalPages_rs><a href="#CurrentPage#?PageNum_rs=#TotalPages_rs##QueryString_rs#"><img src="../../imagenes/Last.gif" border=0></a></cfif></td>
					</tr>
					</cfoutput>
				</table>
			</td>
		</tr>
</table>
</div>
<script type="text/javascript" language="javascript1.2">
	function editar(CJX5IDE,SALDO){
		document.form1.CJX5IDE.value = CJX5IDE;
		document.form1.MONTVALE.value = SALDO;
		document.form1.CJX23MON.value = SALDO;
	}

</script>

