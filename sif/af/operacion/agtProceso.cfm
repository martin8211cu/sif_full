<!--- Procesa parámetos requeridos --->
<cfif isdefined("url.o")><cfset o = url.o></cfif>
<cfif isdefined("form.o")><cfset o = form.o></cfif>
<cfparam name="o" default="n">
<cfset o = Ucase(o)>
<cfswitch expression="#o#">
	<cfcase value="D"><!---DEPRECIACION--->
		<cflocation url="agtProceso_DEPRECIACION.cfm">
	</cfcase>
	<cfcase value="RV"><!---REVALUACION--->
		<cflocation url="agtProceso_REVALUACION.cfm">
	</cfcase>
	<cfcase value="RT"><!---RETIRO--->
		<cflocation url="agtProceso_RETIRO.cfm">
	</cfcase>
	<cfcase value="M"><!---MEJORA--->
		<cflocation url="agtProceso_MEJORA.cfm">
	</cfcase>
	<cfcase value="TR"><!---TRASLADO--->
		<cflocation url="agtProceso_TRASLADO.cfm">
	</cfcase>
	<cfcase value="CC"><!---CAMBIO DE CATEGORIA CLASE--->
		<cflocation url="agtProceso_CAMCATCLAS.cfm">
	</cfcase>
	<cfdefaultcase>
		<cflocation url="../MenuAF.cfm">
	</cfdefaultcase>
</cfswitch>