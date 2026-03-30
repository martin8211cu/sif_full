<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBmotivoBloqueo"
		method="Cambio" >
		<cfinvokeargument name="MBmotivo" value="#form.MBmotivo#">
		<cfinvokeargument name="MBdescripcion" value="#form.MBdescripcion#">
		<cfinvokeargument name="Habilitado" value="#form.Habilitado#">
		<cfif isdefined('form.MBconCompromiso') and form.MBconCompromiso NEQ ''>
			<cfinvokeargument name="MBconCompromiso" value="#form.MBconCompromiso#">
		</cfif>
		<cfif isdefined('form.MBsinCompromiso') and form.MBsinCompromiso NEQ ''>
			<cfinvokeargument name="MBsinCompromiso" value="#form.MBsinCompromiso#">
		</cfif>		
		<cfif isdefined('form.MBautogestion') and form.MBautogestion NEQ ''>
			<cfinvokeargument name="MBautogestion" value="#form.MBautogestion#">
		</cfif>
		<cfif isdefined('form.MBdesbloqueable') and form.MBdesbloqueable NEQ ''>
			<cfinvokeargument name="MBdesbloqueable" value="#form.MBdesbloqueable#">
		</cfif>		
		<cfif isdefined('form.MBbloqueable') and form.MBbloqueable NEQ ''>
			<cfinvokeargument name="MBagente" value="#form.MBbloqueable#">
		</cfif>
		<cfif isdefined('form.MBagente') and form.MBagente NEQ ''>
			<cfinvokeargument name="MBagente" value="#form.MBagente#">
		</cfif>		
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>

	<cfif isdefined("form.delParam") and form.delParam eq "Y">
		<cfquery datasource="#session.dsn#" name="delParam">
			update ISBparametros 
				set Pvalor = null
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Pcodigo in (221,225)
			  and Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MBmotivo#">
		 </cfquery>
	</cfif>
	
	<cfinvoke component="saci.comp.ISBmotivoBloqueo"
		method="Baja" >
		<cfinvokeargument name="MBmotivo" value="#form.MBmotivo#">
	</cfinvoke>
	
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBmotivoBloqueo"
		method="Alta"  >
		<cfinvokeargument name="MBmotivo" value="#Trim(form.MBmotivo)#">
		<cfinvokeargument name="MBdescripcion" value="#form.MBdescripcion#">
		<cfinvokeargument name="Habilitado" value="#form.Habilitado#">
		<cfif isdefined('form.MBconCompromiso') and form.MBconCompromiso NEQ ''>
			<cfinvokeargument name="MBconCompromiso" value="#form.MBconCompromiso#">
		</cfif>
		<cfif isdefined('form.MBsinCompromiso') and form.MBsinCompromiso NEQ ''>
			<cfinvokeargument name="MBsinCompromiso" value="#form.MBsinCompromiso#">
		</cfif>		
		<cfif isdefined('form.MBautogestion') and form.MBautogestion NEQ ''>
			<cfinvokeargument name="MBautogestion" value="#form.MBautogestion#">
		</cfif>			
		<cfif isdefined('form.MBdesbloqueable') and form.MBdesbloqueable NEQ ''>
			<cfinvokeargument name="MBdesbloqueable" value="#form.MBdesbloqueable#">
		</cfif>				
		<cfif isdefined('form.MBbloqueable') and form.MBbloqueable NEQ ''>
			<cfinvokeargument name="MBbloqueable" value="#form.MBbloqueable#">
		</cfif>
		<cfif isdefined('form.MBagente') and form.MBagente NEQ ''>
			<cfinvokeargument name="MBagente" value="#form.MBagente#">
		</cfif>			
	</cfinvoke>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBmotivoBloqueo-redirect.cfm">



