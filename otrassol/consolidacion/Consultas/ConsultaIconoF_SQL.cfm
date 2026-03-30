<cfsetting enablecfoutputonly="yes">
<cfinclude template="../../../sif/cg/consultas/Funciones.cfm">
<cfsetting requesttimeout="3600"> 
<cfparam name="url.formato" default="HTML">

<cfif isdefined("form.MES")>
	<cfset url.MES = form.MES>
</cfif>
<cfif isdefined("form.PERIODO")>
	<cfset url.PERIODO = form.PERIODO>
</cfif>
<cfif isdefined("form.formato")>
	<cfset url.formato = form.formato>
</cfif>

<cfset LvarIrA = 'ConsultaIconoF.cfm'>
<cfset LvarFile = 'ConsultaIconoF'>
<cfset Request.LvarTitle = 'Icono F Consolidado'>

<cfset gpoElimina="#get_val(1330).Pvalor#">

<cfquery name="rsGE" datasource="#session.DSN#">
    select a.GEid as Ecodigo, a.GEnombre as Edescripcion
    from AnexoGEmpresa a
    where a.CEcodigo = #gpoElimina#
</cfquery>
<cfif url.formato is 'Excel'>
	<cfset maxrows=999999999>
<cfelse><!--- HTML --->
	<cfset maxrows=15001>
</cfif>
<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="#maxrows#">
    select
        Sociedad as Sociedad,
        Soc_Asoc as Soc_Asoc,
        Ejercicio_periodo as Ejercicio_periodo,
        Cuenta_consolidacion as Cuenta_consolidacion,
        Referencia_I as Referencia_I,
        Referencia_II as Referencia_II,
        Descripcion as Descripcion,
        Monto as Monto, 
        Moneda as Moneda, 
        Monto_Debe as Monto_Debe, 
        Monto_Haber as Monto_Haber, 
        Moneda_Contabilizacion as Moneda_Contabilizacion
    from Cons_IconoF
    where Periodo = #url.PERIODO# and Mes = #url.mes# and 
    Cuenta_consolidacion not in(select Ccuenta from Cons_CtaConEliminaIconoF)
    order by Periodo,Mes,Ecodigo,Linea
</cfquery>
<cfif url.formato is 'Excel'><!--- csv --->
	<cfinclude template="ConsultaIconoF-csv.cfm">
<cfelse><!--- html --->
	<cfinclude template="ConsultaIconoF-html.cfm">
</cfif>
