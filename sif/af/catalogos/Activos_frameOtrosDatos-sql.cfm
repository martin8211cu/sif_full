<cfparam name="param" default="Aid=#form.Aid#&tab=#form.tab#">
<cfparam name="valor" default="0">

<cfif isdefined('ALTA')>

	<cfset Tipificacion = StructNew()>
	<cfset temp = StructInsert(Tipificacion, "AF", "")> 
	<cfset temp = StructInsert(Tipificacion, "AF_CATEGOR", "#form.AF_CATEGOR#")> 
	<cfset temp = StructInsert(Tipificacion, "AF_CLASIFI", "#form.AF_CLASIFI#")> 
	
	<cfinvoke component="sif.Componentes.DatosVariables" method="GETVALOR" returnvariable="CamposForm">
		<cfinvokeargument name="DVTcodigoValor" value="AF">
		<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
		<cfinvokeargument name="DVVidTablaVal"  value="#form.Aid#">
	</cfinvoke>
	
	<cfloop query="CamposForm">
		
		<cfif isdefined('form.#CamposForm.DVTcodigoValor#_#CamposForm.DVid#')>
			<cfset valor = #Evaluate('form.'&CamposForm.DVTcodigoValor&'_'&CamposForm.DVid)#>
		</cfif>
		<cfinvoke component="sif.Componentes.DatosVariables" method="SETVALOR">
			<cfinvokeargument name="DVTcodigoValor" value="AF">
			<cfinvokeargument name="DVid" 		    value="#CamposForm.DVid#">
			<cfinvokeargument name="DVVidTablaVal"  value="#form.Aid#">
			<cfinvokeargument name="DVVvalor" 	  	value="#valor#">
		</cfinvoke>
	</cfloop>
</cfif>
<cflocation url="Activos.cfm?#param#">