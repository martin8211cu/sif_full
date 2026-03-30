<cfparam name="form.DVobligatorio" default="0">
<cfparam name="Param" 			   default="">

<cfif isdefined('ALTA')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="ALTA" returnvariable="DVid">
		<cfinvokeargument name="DVcodigo" 		value="#form.DVcodigo#">
		<cfinvokeargument name="DVdescripcion"  value="#form.DVdescripcion#">
		<cfinvokeargument name="DVetiqueta" 	value="#form.DVetiqueta#">
		<cfinvokeargument name="DVencabezado" 	value="#form.DVencabezado#">
		<cfinvokeargument name="DVexplicacion" 	value="#form.DVexplicacion#">
		<cfinvokeargument name="DVtipoDato"	 	value="#form.DVtipoDato#">
		<cfinvokeargument name="DVlongitud" 	value="#form.DVlongitud#">
		<cfinvokeargument name="DVdecimales" 	value="#form.DVdecimales#">
		<cfinvokeargument name="DVmascara" 		value="#form.DVmascara#">
		<cfinvokeargument name="DVobligatorio" 	value="#form.DVobligatorio#">
	</cfinvoke>
	<cfset Param = "DVid=#DVid#">
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="CAMBIO">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
		<cfinvokeargument name="DVcodigo" 		value="#form.DVcodigo#">
		<cfinvokeargument name="DVdescripcion"  value="#form.DVdescripcion#">
		<cfinvokeargument name="DVetiqueta" 	value="#form.DVetiqueta#">
		<cfinvokeargument name="DVencabezado" 	value="#form.DVencabezado#">
		<cfinvokeargument name="DVexplicacion" 	value="#form.DVexplicacion#">
		<cfinvokeargument name="DVtipoDato"	 	value="#form.DVtipoDato#">
		<cfinvokeargument name="DVlongitud" 	value="#form.DVlongitud#">
		<cfinvokeargument name="DVdecimales" 	value="#form.DVdecimales#">
		<cfinvokeargument name="DVmascara" 		value="#form.DVmascara#">
		<cfinvokeargument name="DVobligatorio" 	value="#form.DVobligatorio#">
	</cfinvoke>
	<cfset Param = "DVid=#form.DVid#">
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="BAJA">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
	</cfinvoke>
<cfelseif isdefined('ALTADET')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="ALTALISTA">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
		<cfinvokeargument name="DVLcodigo" 		value="#form.DVLcodigo#">
		<cfinvokeargument name="DVLdescripcion" value="#form.DVLdescripcion#">
	</cfinvoke>
	<cfset Param = "DVid=#form.DVid#">
<cfelseif isdefined('BAJADET')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="BAJALISTA">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
		<cfinvokeargument name="DVLcodigo" 		value="#form.DVLcodigo#">
		<cfinvokeargument name="DVLdescripcion" value="#form.DVLdescripcion#">
	</cfinvoke>
	<cfset Param = "DVid=#form.DVid#">
<cfelseif isdefined('CAMBIODET')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="CAMBIOLISTA">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
		<cfinvokeargument name="DVLcodigo" 		value="#form.DVLcodigo#">
		<cfinvokeargument name="DVLdescripcion" value="#form.DVLdescripcion#">
	</cfinvoke>
	<cfset Param = "DVid=#form.DVid#">
</cfif>
<cflocation url="DatosVariables.cfm?#Param#">