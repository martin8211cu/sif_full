<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_GeneracionDeArchivoParaSICEREsobreSalarioEscolar" Default="Generaci&oacute;n de Archivo Salario Escolar para SICERE" returnvariable="LB_GeneracionDeArchivoParaSICEREsobreSalarioEscolar"/>	
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

	<cfquery name="rsParametros" datasource="#session.DSN#">
		select Pcodigo,Pvalor from RHParametros  
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Pcodigo in (300)
	</cfquery>
	<cfset Lvar_NUMPAT = left(rsParametros.Pvalor,12)>
    
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_GeneracionDeArchivoParaSICEREsobreSalarioEscolar#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<cfoutput>
			<table width="98%" cellpadding="3" cellspacing="0" align="center" border="0">			
				<tr><td width="22%">&nbsp;</td></tr>			
				<tr>
					<td align="center">
						<cf_sifimportar EIcodigo="SICERE" mode="out">
							<cfif isdefined("form.periodo") and len(trim(form.periodo)) and isdefined("form.mes") and len(trim(form.mes))>
								<cf_sifimportarparam name="periodo" value="#Form.periodo#">
								<cf_sifimportarparam name="mes" value="#Form.mes#">
                                <cf_sifimportarparam name="nombre_archivo" value="#Lvar_NUMPAT#">
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
                                <cf_sifimportarparam name="CIidlist" value="#form.CIidlist#">
							</cfif>
						</cf_sifimportar>
					</td>
				</tr>	
			</table>	
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
