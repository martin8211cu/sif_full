<cfif isdefined("Form.AGid") and Len(Trim(Form.AGid))>
	<cfquery name="rsPquien" datasource="#Session.DSN#">
		select Pquien
		from ISBagente
		where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
	</cfquery>
	<cfset Form.Pquien = rsPquien.Pquien>
</cfif>

<cfinclude template="agente-params.cfm">

<cfif isdefined("form.paso")>
	<cfif isdefined("url.Activar")>							<!---Activacion desde el menu de pasos,significa que se hiso clic en el link "Activar" que se encuentra en venta-contrato-menu"--->
		<cfinclude template="/saci/vendedor/venta/venta-contrato-apply5.cfm">
		
	<cfelseif form.paso EQ "1">
		<cfif isdefined('form.cuentaActiva') and form.cuentaActiva EQ 0>
			<cfinclude template="/saci/vendedor/venta/venta-contrato-apply1.cfm">
		</cfif>
	<cfelseif form.paso EQ "2">
		<cfif isdefined('form.cuentaActiva') and form.cuentaActiva EQ 0>
			<cfinclude template="/saci/vendedor/venta/venta-contrato-apply2.cfm">
		</cfif>
	<cfelseif form.paso EQ "3">
		<cfif isdefined('form.cuentaActiva') and form.cuentaActiva EQ 0>
			<cfinclude template="/saci/vendedor/venta/venta-contrato-apply3.cfm">
		</cfif>
	<cfelseif form.paso EQ "4">
		<cfinclude template="/saci/vendedor/venta/venta-contrato-apply4.cfm">

	<cfelseif form.paso EQ "5">
		<cfinclude template="/saci/vendedor/venta/venta-contrato-apply5.cfm">

	</cfif>
	
	<cfif isdefined("form.Activar")>
		<cfset Form.paso = "1">
		<cfset Form.CTid = "">
	</cfif>
	<cfif (isdefined("Form.GuardarContinuar")) or (isdefined("form.submitMenu") and form.submitMenu EQ 1)>
		<cfset Form.paso = "" & (Form.paso+1)>
	</cfif>
</cfif>

<cfinclude template="agente-redirect.cfm">
