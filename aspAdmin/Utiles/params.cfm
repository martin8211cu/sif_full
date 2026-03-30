<!---
	ModoDespliegue: se utiliza para diferenciar cómo debe desplegarse las consultas
	0: Modo Personal
	1: Modo Empresa
--->
<cfif not isdefined("Session.Params")>
	<cfset Session.Params = StructNew()>
	<cfset Session.Params.ModoDespliegue = 0>
</cfif>
