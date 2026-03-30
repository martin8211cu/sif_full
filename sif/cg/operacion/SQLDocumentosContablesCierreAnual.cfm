<!--- 
	Creado por: Gustavo Fonseca Hernández.
		Motivo: Nuevo proceso de Cierre Anual.
		Fecha: 3-1-2007.
 --->
<cfset sufix = 'CierreAnual'>
<cfif isdefined("form.btnAsientoLiquida")>
	<cfinclude template="AsientoLiquidacionCierreAnual.cfm">
<cfelseif isdefined("form.btnAsientoLimpia")>
	<cfinclude template="AsientoLimpiezaCierreAnual.cfm">
<cfelse>
	<cfinclude template="SQLDocumentosContables.cfm">
</cfif>




