
<!--- <cfquery name="rs" datasource="#session.Fondos.dsn#">
	set nocount on	
	execute sp_Alta_CGM001 
	  @CGM1IM =  '#url.CGM1IM#'
	, @CGM1CD =  '#url.StringNivel#'
	, @CGE5COD = '#url.CGE5COD#'
	, @auxiliar=1,
	  @hacer_select=1
	set nocount off	
</cfquery> --->

<cfhttp url="http://127.0.0.1:8300/cfmx/sif/fondos/webservV5/ValidaCuenta.cfm?ORIGEN=2&CGM1CD=#url.StringNivel#&CGM1IM=#url.CGM1IM#&CGE5COD=#url.CGE5COD#&dsn=#session.dsn#&Ecodigo=#session.Ecodigo#" 
result = "result_name" >

<cfif  IsNumeric(result_name.Filecontent)>
<cfelse>
	<script language="JavaScript">
	   var  mensaje = "<cfoutput># JSStringFormat( rtrim(ltrim(result_name.Filecontent)))#</cfoutput>";
	  alert(mensaje)
	   window.parent.document.form1.CG13ID_<cfoutput>#trim(url.nivel)#</cfoutput>.value='';
		if (window.parent.document.form1.errorFlag.value == '1')
		{
		   window.parent.document.form1.errorFlag.value = '3'; // ES ERROR
		   if (window.parent.finalizar())
			   window.parent.form1.submit();
		}
	</script>
	<cfabort>
</cfif>


<script language="JavaScript">
	window.parent.document.form1.CGM1ID.value = '<cfoutput>#trim(result_name.Filecontent)#</cfoutput>';
	window.parent.document.form1.CGM1CD.value = '<cfoutput>#trim(url.StringNivel)#</cfoutput>';
	window.parent.document.form1.error.value='';
    if (window.parent.document.form1.errorFlag.value == '1')
	{
		window.parent.document.form1.errorFlag.value = '2';  // ES CORRECTO
	    if (window.parent.finalizar())
			window.parent.form1.submit();
	}
	//window.parent.document.form1.CG13ID_<cfoutput>#trim(url.nivel)#</cfoutput>.blur();
</script>
