<cfif isdefined("form.paso")>
	<cfif form.paso EQ "1">
		<cfinclude  template="/saci/vendedor/venta/venta-contrato-apply1.cfm">

	<cfelseif form.paso EQ "2">
		<cfinclude  template="/saci/vendedor/venta/venta-contrato-apply2.cfm">

	<cfelseif form.paso EQ "3">
		<cfinclude  template="/saci/vendedor/venta/venta-contrato-apply3.cfm">

	<cfelseif form.paso EQ "4">
		<cfinclude  template="/saci/vendedor/venta/venta-contrato-apply4.cfm">

	</cfif>
	
</cfif>
