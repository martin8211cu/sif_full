<cfinclude template="venta-params.cfm">

<cfif isdefined("form.paso")>	
	
	<cfif isdefined("url.Activar")>							<!---Activacion desde el menu de pasos,significa que se hiso clic en el link "Activar" que se encuentra en venta-contrato-menu"--->
		<cfinclude template="venta-contrato-apply5.cfm">
	
	<cfelseif form.paso EQ "1">
		<cfinclude template="venta-contrato-apply1.cfm">

	<cfelseif form.paso EQ "2">
		<cfif isdefined('form.cuentaActiva') and form.cuentaActiva EQ 0>
			<cfinclude template="venta-contrato-apply2.cfm">		
		</cfif>
	<cfelseif form.paso EQ "3">
		<cfif isdefined('form.cuentaActiva') and form.cuentaActiva EQ 0>	
			<cfinclude template="venta-contrato-apply3.cfm">
		</cfif>
	<cfelseif form.paso EQ "4">
		<cfinclude template="venta-contrato-apply4.cfm">

	<cfelseif form.paso EQ "5">
		<cfinclude template="venta-contrato-apply5.cfm">	<!---Activacion desde el paso 5--->
	</cfif>

	<cfif isdefined("form.Activar")>
		<cfset Form.paso = "0">
		<cfset Form.CTid = "">
	<cfelse>
		<cfif isdefined("form.GuardarContinuar") or (isdefined('form.CTid') and form.CTid NEQ '' and isdefined("form.submitMenu") and form.submitMenu EQ 1)>
			<cfset Form.paso = "" & (Form.paso+1)>
		</cfif>
	</cfif>	
</cfif>



<cfinclude template="venta-redirect.cfm">
