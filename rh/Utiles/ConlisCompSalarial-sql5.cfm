<cfoutput>

<cfif isdefined("Form.CSid") and Len(Trim(Form.CSid))>
	
	<cfquery name="rsData" datasource="#session.DSN#">
		select * from ComponentesSalariales where Ecodigo = #session.Ecodigo# and CSid = #form.CSid#
	</cfquery>
	
	<script language="JavaScript" type="text/javascript">
		if (window.opener.document.form2) {
			if (window.opener.document.form2.reloadPage) <!---window.opener.document.form2.reloadPage.value = "1";
			window.opener.document.form2.submit();
			--->
			window.opener.document.form2.CSid.value = '#form.CSid#';
			window.opener.document.form2.CScodigo.value = '#rsData.CScodigo#';
			window.opener.document.form2.CSdescripcion.value = '#rsData.CSdescripcion#';
			window.close();
		}
	</script>
</cfif>

</cfoutput>