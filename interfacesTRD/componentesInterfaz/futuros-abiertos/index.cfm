<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->
<cfif isdefined("url.CodICTS") and len(url.CodICTS) and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>	


<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from futurosabiertosPMI a
	where a.sessionid = #session.monitoreo.sessionid#
    and a.mensajeerror is not null  
</cfquery>
<cfset NumeroErrores = rsVerifica.recordcount>
<cfset BErrores = "Errores (#NumeroErrores#)">

<!--- form.botonsel define la accion por realizar --->
<cfset titulo = 'Futuros Abiertos'>
<cfif IsDefined('url.botonsel') and Len(url.botonsel) NEQ 0>
	<cfset form.botonsel = url.botonsel>
</cfif>
<cfparam name="form.botonsel" default="btnRegresar">

<cfif form.botonsel EQ "btnRegresar">
	<!---
		param.cfm
		muestra la pantalla de parámetros
	--->
	<cfinclude template="param.cfm">
<cfelseif form.botonsel EQ "Generar">
	<!---
		extrae.cfm, 
		<directorio>/extrae.cfm, 
		saca información del sistema externo y la incluye en sif_interfaces..futurosabiertosPMI ,
		elimina antes los datos existentes
	--->
	<cfinclude template="extrae.cfm">
	<cflocation url="index.cfm?botonsel=btnLista&CodICTS=#varCodICTS#">
<cfelseif form.botonsel EQ "btnLista">
	<!---
		lista.cfm (normal)
		Lista los registros existentes en  sif_interfaces..futurosabiertosPMI 
	--->
	<cfset modo_errores = "0">
	<cfinclude template="lista.cfm">
<cfelseif form.botonsel EQ "btnImprimir">
	<!---
		imprimir.cfm
		Lista los registros existentes en sif_interfaces..futurosabiertosPMI
		en formato para impresión
	--->
	<cfinclude template="imprimir.cfm">
<cfelseif form.botonsel EQ "btn#BErrores#">
	<!---
		lista.cfm (errores)
		Lista los registros con error existentes en sif_interfaces..futurosabiertosPMI
	--->
	<cfset modo_errores = "1">
	<cfinclude template="errores.cfm">
<cfelseif form.botonsel EQ "btnAplicar">
	<!---
		aplicar.cfm
		Copia los registros de sif_interfaces..futurosabiertosPMI a Importacion de polizas
		Después de esto pasa a terminado.cfm
	--->
	<cfinclude template="aplicar.cfm">
<cfelseif form.botonsel EQ "btnTerminado">
	<!---
		terminado.cfm
		Muestra una leyenda que indica el estado del proceso (Terminado)
	--->
	<cfinclude template="../generales/terminado.cfm">
<cfelseif form.botonsel EQ "btnGuardarFactor">
	<!---
		guardarfactor.cfm
		Guarda los factores modificados (swaps nofact)
	--->
	<cfinclude template="guardarfactor.cfm">
<cfelse>
	<!--- default --->
	<cfinclude template="lista.cfm">
</cfif>
