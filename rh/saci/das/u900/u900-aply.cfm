<cfif IsDefined("form.Bloquear")>
	<cfif form.Bloquear EQ 'Bloquear'>	
		<cfquery name="rsExiste" datasource="#session.DSN#">
			Select 1
			from ISBmedio 
			where MDref=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MDref)#">
				and MDbloqueado = 1
		</cfquery>	
		<cfif isdefined('rsExiste') and rsExiste.recordCount GT 0>
			<cfthrow message="Error, el teléfono digitado ya se encuentra bloqueado">
		<cfelse>
			<cfinvoke component="saci.comp.u900"
				method="CambioEstado" >
				<cfinvokeargument name="MDref" value="#form.MDref#">
				<cfinvokeargument name="MDbloqueado" value="1">
				<cfinvokeargument name="MBmotivo" value="#form.MBmotivo900#">		
				<cfinvokeargument name="BTobs" value="#form.BTobs#">						
			</cfinvoke> 
		</cfif>
	</cfif>
<cfelseif isdefined('form.BOTON') and form.BOTON EQ 'btnDesbloquear'>	
	<cfif isDefined("form.CHK") and form.CHK NEQ ''>
		<cftransaction>
			<cfset arreglo = listtoarray(form.CHK,",")>
			<cfset contObs = "">
			<cfif isdefined('form.BTobs') and form.BTobs NEQ ''>
				<cfset contObs = form.BTobs>
			</cfif>
			<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
				<cfinvoke component="saci.comp.u900"
					method="CambioEstado" >
					<cfinvokeargument name="MDref" value="#arreglo[i]#">
					<cfinvokeargument name="MDbloqueado" value="0">
					<cfinvokeargument name="BTobs" value="#contObs#">
				</cfinvoke> 
			</cfloop>
		</cftransaction>
	</cfif>
<cfelseif isdefined('form.Alta')>
	<cfset contObs = "">
	<cfif isdefined('form.BTobs') and form.BTobs NEQ ''>
		<cfset contObs = form.BTobs>
	</cfif>
	<cfinvoke component="saci.comp.u900"
		method="Alta" >
		<cfinvokeargument name="MDref" value="#form.MDref#">
		<cfinvokeargument name="MDbloqueado" value="0">		
		<cfinvokeargument name="EMid" value="#form.EMid#">		
		<cfinvokeargument name="MDlimite" value="#form.MDlimite#">
		<cfinvokeargument name="MBmotivo" value="-1">		
		<cfinvokeargument name="verifExiste" value="true">		
		<cfinvokeargument name="BTobs" value="#contObs#">
	</cfinvoke>	
<cfelseif isdefined('form.Baja')>
	<cfinvoke component="saci.comp.u900"
		method="Baja" >
		<cfinvokeargument name="MDref" value="#form.MDref#">
	</cfinvoke>		
<cfelseif isdefined('form.Cambio')>
	<cfset contObs = "">
	<cfif isdefined('form.BTobs') and form.BTobs NEQ ''>
		<cfset contObs = form.BTobs>
	</cfif>
	<cfinvoke component="saci.comp.u900"
		method="Cambio" >
		<cfinvokeargument name="MDref" value="#form.MDref#">
		<cfinvokeargument name="MDlimite" value="#form.MDlimite#">
		<cfinvokeargument name="EMid" value="#form.EMid#">		
		<cfinvokeargument name="BTobs" value="#contObs#">
	</cfinvoke> 
<cfelseif isdefined('form.BloquearMasivo')>	
	<cfif IsDefined('form.archImportar') and form.archImportar NEQ ''>
		<cffile action="upload" filefield="archImportar" destination="# GetTempDirectory() #" nameconflict="overwrite">
		<cffile action="read" file="#GetTempDirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="contenido">
		<cffile action="delete" file="#GetTempDirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#">

		<cfset contObs = "">
		<cfif isdefined('form.BTobs') and form.BTobs NEQ ''>
			<cfset contObs = form.BTobs>
		</cfif>		
		<cftransaction>
			<cfloop list="#contenido#" delimiters="#Chr(13)##Chr(10)#" index="telefono">
				<cfif telefono NEQ ''>
					<cfinvoke component="saci.comp.u900"
						method="CambioEstado" >
						<cfinvokeargument name="MDref" value="#telefono#">
						<cfinvokeargument name="MDbloqueado" value="1">
						<cfinvokeargument name="BTobs" value="#contObs#">
					</cfinvoke> 			
				</cfif>				 
			</cfloop>
		</cftransaction>
	</cfif>	
</cfif>

<cfinclude template="u900-redirect.cfm">