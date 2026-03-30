<cfif isdefined('url.Cambiar')>
	<cfset form.Cambiar = url.Cambiar>	
</cfif>

<cfif isdefined('url.AG')>
	<cfset form.AG = url.AG>	
</cfif>

<cfif isdefined('url.Habilitado')>
	<cfset form.Habilitado = url.Habilitado>	
</cfif>

<cfif isdefined('url.tipo')>
	<cfset form.tipo = url.tipo>	

</cfif>

<cfparam name="MBmotivo" default="">
<cfparam name="form.BLobs" default="">

<cfif isdefined('url.MBmotivo')>
	<cfset MBmotivo = url.MBmotivo>	
</cfif>


<cfif isdefined('form.MBmotivo')>
	<cfset MBmotivo = form.MBmotivo>	
</cfif>

<cfif isdefined('url.BLobs')>
	<cfset form.BLobs = url.BLobs>	
</cfif>


<cfif isdefined("form.Cambiar") and Form.Cambiar EQ 1>
	<cfif isdefined('form.Habilitado')>
		<cfif form.Habilitado EQ 0>	<!--- Inhabilitar agente --->
 			<cfinvoke component="saci.comp.ISBagente"
				method="inhabilitarAgente" 
				AGid="#form.AG#"
				Habilitado="#form.Habilitado#"
				MBmotivo = "#Trim(MBmotivo)#"
				BLobs = "#form.BLobs#"
			/>
		<cfelseif form.Habilitado EQ 1><!--- Habilitar agente --->
			<cfinvoke component="saci.comp.ISBagente"
				method="habilitarAgente" 
				AGid="#form.AG#"
				Habilitado="#form.Habilitado#"				
			/>			
		</cfif>
	</cfif>
</cfif>

<cfif isdefined('form.tipo') and form.tipo eq 'Externo'>
	<cflocation url="agente.cfm">
<cfelse>
	<cflocation url="agente_interno.cfm">
</cfif>
