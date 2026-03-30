<cfif isdefined("url.CtaMayor") and url.CtaMayor neq "">
	
	<cfquery name="rsValidarCuenta" datasource="#session.Fondos.dsn#">
	select count(1) as total 
	from PRP050 
	where pcuentam = '#url.CtaMayor#'
	  and pobjgto = 'XXX'
	</cfquery>
	
	<cfif rsValidarCuenta.total gt 0>
			
		<script language="JavaScript1.2" type="text/javascript">			
		parent.document.form1.HDValidaCta.value = "1";
		</script>
	
	<cfelse>
		<script language="JavaScript1.2" type="text/javascript">			
		parent.document.form1.HDValidaCta.value = "0";
		</script>
	</cfif>

<cfelse>
	<script language="JavaScript1.2" type="text/javascript">			
	parent.document.form1.HDValidaCta.value = "0";
	</script>
</cfif>
