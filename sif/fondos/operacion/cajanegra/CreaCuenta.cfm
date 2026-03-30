<cftry>
<cfquery name="rs" datasource="#session.Fondos.dsn#">
	set nocount on	
	execute sp_Alta_CGM001 
	  @CGM1IM =  '#url.CGM1IM#'
	, @CGM1CD =  '#url.StringNivel#'
	, @CGE5COD = '#url.CGE5COD#'
	, @auxiliar=1,
	  @hacer_select=1
	set nocount off	
</cfquery>

<cfcatch type="any">
	<script language="JavaScript">
	   var  mensaje = "<cfoutput>#rtrim(ltrim(cfcatch.Detail))#</cfoutput>";
	   mensaje = mensaje.substring(40,300);
	   window.parent.document.form1.error.value="Se presentaron los siguientes errores:\n- "+mensaje;
	   window.parent.document.form1.CG13ID_<cfoutput>#trim(url.nivel)#</cfoutput>.value='';
		if (window.parent.document.form1.errorFlag.value == '1')
		{
		   window.parent.document.form1.errorFlag.value = '3'; // ES ERROR
		   if (window.parent.finalizar())
			   window.parent.form1.submit();
		}
	</script>
	<cfabort>
</cfcatch> 
</cftry>

<script language="JavaScript">
	window.parent.document.form1.CGM1ID.value = '<cfoutput>#trim(rs.new_id)#</cfoutput>';
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

