<cfif isdefined('url.NumeroCot') and not isdefined('form.NumeroCot')>
	<cfset Form.NumeroCot = Url.NumeroCot>
</cfif>
<cfif isdefined('url.ruta') and not isdefined('form.ruta')>
	<cfset Form.ruta = Url.ruta>
</cfif>

<cfif isdefined('form.ruta') and isdefined('form.NumeroCot')>
	<cfinclude template="#form.ruta#">
</cfif>

<script language="javascript" type="text/javascript">
	window.print();
</script>