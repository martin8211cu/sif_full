<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_GeneracionDeArchivoParaFondoGarantiaAhorro" Default="Generaci&oacute;n de Archivo para el Fondo de Ahorro Garantía y Ahorro" returnvariable="LB_GeneracionDeArchivoParaFondoGarantiaAhorro"/>	
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>
<cf_templateheader>
	<cf_web_portlet_start>
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<cfoutput>
			<table width="98%" cellpadding="3" cellspacing="0" align="center" border="0">			
				<tr><td width="22%">&nbsp;</td></tr>			
				<tr>
					<td align="center">
						<cf_sifimportar EIcodigo="FGAM" mode="out">
							<cfif isdefined("form.TipoNomina")>
								<cf_sifimportarparam name="historico" value="1"><!----Nominas historicas--->
							<cfelse>
								<cf_sifimportarparam name="historico" value="0"><!---Nominas sin aplicar--->
							</cfif>
							<cfif isdefined("form.periodo") and len(trim(form.periodo)) and isdefined("form.mes") and len(trim(form.mes))>
								<cf_sifimportarparam name="periodo" value="#Form.periodo#">
								<cf_sifimportarparam name="mes" value="#Form.mes#">
							<cfelse>
								<cf_sifimportarparam name="periodo" value="-1">
								<cf_sifimportarparam name="mes" value="-1">								
							</cfif>							
							<cfif isdefined("form.CPid1") and len(trim(form.CPid1)) >
								<cf_sifimportarparam name="calendariopago" value="#Form.CPid1#">
							<cfelseif isdefined("form.CPid2") and len(trim(form.CPid2))>
								<cf_sifimportarparam name="calendariopago" value="#Form.CPid2#">
							<cfelse>
								<cf_sifimportarparam name="calendariopago" value="-1">
							</cfif>
						</cf_sifimportar>
					</td>
				</tr>	
			</table>	
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
