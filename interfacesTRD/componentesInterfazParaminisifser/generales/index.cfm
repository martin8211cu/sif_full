<!--- form.botonsel define la accion por realizar --->
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
		saca información del sistema externo y la incluye en PMIINT_IE10/PMIINT_ID10,
		elimina antes los datos existentes
	--->
	<cfinclude template="extrae.cfm">
	<cflocation url="index.cfm?botonsel=btnLista">
<cfelseif form.botonsel EQ "btnLista">
	<!---
		lista.cfm (normal)
		Lista los registros existentes en PMIINT_IE10/PMIINT_ID10
	--->
	<cfset modo_errores = "0">
	<cfinclude template="lista.cfm">
<cfelseif form.botonsel EQ "btnImprimir">
	<!---
		imprimir.cfm
		Lista los registros existentes en PMIINT_IE10/PMIINT_ID10
		en formato para impresión
	--->
	<cfinclude template="imprimir.cfm">
<cfelseif form.botonsel EQ "btnErrores">
	<!---
		lista.cfm (errores)
		Lista los registros con error existentes en PMIINT_IE10/PMIINT_ID10
	--->
	<cfset modo_errores = "1">
	<cfinclude template="lista.cfm">
<cfelseif form.botonsel EQ "btnAplicar">
	<!---
		aplicar.cfm
		Copia los registros de PMIINT_IE10/PMIINT_ID10 a IE10/ID10
		Después de esto pasa a terminado.cfm
	--->
	<cfinclude template="aplicar.cfm">
<cfelseif form.botonsel EQ "btnTerminado">
	<!---
		terminado.cfm
		Muestra una leyenda que indica el estado del proceso (Terminado)
	--->
	<cfinclude template="terminado.cfm">
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
