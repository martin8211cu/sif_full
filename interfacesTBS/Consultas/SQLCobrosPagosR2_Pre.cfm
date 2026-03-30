<cfparam name="url.formato" default="HTML">
<cfparam name="url.IncluirOficina" default="01">

<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>
<cfoutput>

<cfif not isdefined('form.Formato')>
	<cfset form.formato = 'HTML'>
</cfif>
<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action="/cfmx/interfacesTBS/ProcCobrosPagos.cfm";
		document.form1.submit();
	}

</script>
<cfif form.formato EQ "HTML">
	<form name="form1n" action="SQLCobrosPagosR2.cfm" method="post">
		<input type="hidden" name="IncluirOficina" value="#url.IncluirOficina#" />
	</form>
	<script language="javascript" type="text/javascript">
		document.form1n.submit();
	</script>
</cfif>
</cfoutput>
