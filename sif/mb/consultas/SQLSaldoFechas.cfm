<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 25 de mayo del 2005
	Motivo:	Se elimino una barra de menú q estaba de mas
----------->

<cfset LvarTitulo = "Reporte de Movimientos por Rango de Fechas">
<cfset LvarMenu = "../MenuMB.cfm"> 
<cfset LvarformSaldoFechas = "formSaldoFechas.cfm">
<cfset LbelTituloHeader= "Bancos"> 
<cfif isdefined("LvarSQLSaldoFechasTCE")>
    <cfset LvarformSaldoFechas = "../../tce/consultas/formSaldoFechasTCE.cfm">
    <cfif isdefined("form.RangoP") and len(trim(form.RangoP))>
		<cfset LvarTitulo = "Reporte de Movimientos de TCE por Periodo - Mes">
    <cfelse>
    	<cfset LvarTitulo = "Reporte de Movimientos por Rango de Fechas TCE">    
    </cfif>
    <cfset LvarMenu = "../../tce/MenuTCE.cfm"> 
	<cfset LbelTituloHeader= "Tarjetas de Cr&eacute;dito Empresarial"> 
</cfif>


<cf_templateheader title="#LbelTituloHeader#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="4">
				<cfinclude  template="../../portlets/pNavegacionMB.cfm">
			</td>
		</tr>
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarTitulo#'>


				<!--- Cuando veo el detalle del reporte y cambio de empresa,
                      me devuelve a la pantalla de filtro --->
    
    
                <cfset paramsuri='&imprime=1'>
                <cfif isdefined("form.btnConsultar")>
                    <cfset paramsuri = paramsuri & '&btnConsultar=#form.btnConsultar#'>
                </cfif>
                <cfif isdefined("form.btnDownload")>
                    <cfset paramsuri = paramsuri & '&btnConsultar=Consultar'>
                    <cfset form.btnConsultar = 'Consultar'>
                </cfif>
                <cfif isdefined("form.tipo")>
                    <cfset paramsuri = paramsuri & '&tipo=#form.tipo#'>
                </cfif>
                <cfif isdefined("form.fechai")>
                    <cfset paramsuri = paramsuri & '&fechai=#form.fechai#'>
                </cfif>
                <cfif isdefined("form.fechaf")>
                    <cfset paramsuri = paramsuri & '&fechaf=#form.fechaf#'>
                </cfif>
                <cfif isdefined("form.CBid")>
                    <cfset paramsuri = paramsuri & '&CBid=#form.CBid#'>
                </cfif>
                
    
                <cfif not isdefined("form.btnConsultar")>
                    <cfif not isdefined("url.tipo")>
                        <cflocation addtoken="no" url="#LvarMenu#" ><!--- Menu de bancos o TCE --->
                    <cfelse>
                        <cfset form.fechai = LSDateFormat(Now(),'DD/MM/YYYY') >	
                        <cfset form.fechaf = LSDateFormat(Now(),'DD/MM/YYYY') >	
                        <cfset form.tipo = 1 > <!--- 0 - Reporte de rango de fechas, 1 -  Reporte a la fecha de hoy--->						
                    </cfif>
                <cfelse>
                    <cfif isdefined("form.fechai") and form.fechai eq "" >
                        <cfset form.fechai = LSDateFormat(Now(),'DD/MM/YYYY') >	
                    </cfif>	
    
                    <cfif isdefined("form.fechaf") and form.fechaf eq "" >
                        <cfset form.fechaf = LSDateFormat(Now(),'DD/MM/YYYY') >	
                    </cfif>	
                    
                    <cfset form.tipo = 0 > <!--- 0 - Reporte de rango de fechas, 1 -  Reporte a la fecha de hoy--->
                </cfif>
			
				<cfinclude template="#LvarformSaldoFechas#"><!--- En Bancos  »»formSaldoFechas.cfm «« o en TCE »»formSaldoFechasTCE.cfm ««--->
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>