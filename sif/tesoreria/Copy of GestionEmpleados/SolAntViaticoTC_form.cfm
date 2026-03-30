<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Detalles del Anticipo Tipo de Cambio">
<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Detalles del Anticipo Tipo de Cambio">

<cfset LvarSAporEmpleadoCFM = "#url.LvarSAporEmpleadoCFM#">
<cfset GEAid="#url.GEAid#">
<cfset GECVid="">
<cfset GECVcodigo="">
<cfset GECVdescripcion="">	

<cfquery name="rsTipos" datasource="#session.dsn#">
	select  gep.Mcodigo,m.Mnombre,  get.GEADtipocambio, get.GEPVid
		from GEanticipoDet get
		inner join GEPlantillaViaticos gep
			on gep.GEPVid=get.GEPVid 
		inner join Monedas m
			on m.Mcodigo= gep.Mcodigo
		where get.GEAid=#GEAid#
		and  get.GEADtipocambio<>1
</cfquery>
<cfquery name="rsTiposMostrar" datasource="#session.dsn#">
	select distinct  m.Mnombre,  get.GEADtipocambio, get.McodigoPlantilla
    from GEanticipoDet get
    inner join Monedas m
    	on m.Mcodigo= get.McodigoPlantilla
	where get.GEAid=#GEAid#
	and  get.GEADtipocambio<>1  
</cfquery>
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select ge.GEAdesde, ge.GEAhasta, ge.GEAhoraini, ge.GEAhorafin, ge.GEAtipoviatico, ge.Mcodigo,Mnombre
			from GEanticipo ge
			inner join Monedas mon
					on mon.Mcodigo = ge.Mcodigo
					and mon.Ecodigo = ge.Ecodigo
			left outer join Htipocambio htc
					on htc.Mcodigo = mon.Mcodigo
					and <cf_dbfunction name="now"> between htc.Hfecha and htc.Hfechah  		
			where GEAid=#GEAid#
	</cfquery>
<cfoutput>

	<table width="100%" border="0" align="center">
		<tr>
		<td valign="top" width="40%" align="left" >
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cf_web_portlet_start border="true" titulo="Modificación del tipo de Cambio" skin="info1">
							<p>En esta pantalla se muestra las monedas extranjeras que se encuentran ligadas al anticipo seleccionado. 
							Dando asi la posibilidad de escojer el tipo de cambio para cada moneda para dicho anticipo. 
							A la hora de modificar este tipo de cambio afecta los montos de pago de dicho anticipo.</p>
							<p align="justify">&nbsp;</p>
						<cf_web_portlet_end>
					</td>
				</tr>
			</table>
		</td>
		<td valign="top" width="60%" align="left">				
	 <table width="100%" border="0" align="center">
		 <tr>
		 	<td><div align="left" style="font-size:16px"><strong>DATOS DEL ANTICIPO</strong></div></td>
		</tr>
		<tr>
			<td><div align="left"><strong>Moneda: #rsDatos.Mnombre#</strong></div> </td>
			
		 </tr>
	 </table>
</cfoutput>
	<cfset modo= "CAMBIO">
			<cfform action="SolAntViaticoTC_sql.cfm" method="post" name="form1" onsubmit="return validar();">
				
			<cfinput type="hidden" name="GEAid" value="#GEAid#"/>		
			<cfinput type="hidden" name="LvarSAporEmpleadoCFM" value="#LvarSAporEmpleadoCFM#">	
			<cfoutput query="rsTiposMostrar">
				<table width="100%" border="0" align="center">
					 	
						 <tr>
						 	<td align="left" width="75">
								#rsTiposMostrar.Mnombre#:
							</td>
							<td  align="left">
								<cfinput type="hidden" name="McodigoPlantilla"  value="#rsTiposMostrar.McodigoPlantilla#">
								<cf_monto name="GEADtipocambio" id="GEADtipocambio" size="9" tabindex="-1" value="#rsTiposMostrar.GEADtipocambio#" decimales="2" negativos="false">
							</td>
						</tr>	
				</table>
			</cfoutput>	
			</td>
			</tr>
			</table>
			<cfset LvarSAporEmpleadoSQL = "">

				 <cfinput type="hidden" name="BMUsucodigo" value="#session.usucodigo#" />
				 <cfinput type="hidden" name="modo" value="CAMBIO" />
			
			<table width="100%" border="0" align="center">
				<tr>
					<td valign="top" width="40%" align="left" >
					</td>
					<td valign="top" width="60%" align="left" >
						<table  border="0" align="left">
							<tr>
								<td>
									<cfinput type="hidden" name="irA" value="#LvarSAporEmpleadoCFM#?LvarSAporEmpleadoSQL=#LvarSAporEmpleadoSQL#&GEAid=#url.GEAid#" />
									<cf_botones modo="CAMBIO" include="Regresar" exclude="Nuevo,Baja">	
								</td>
							</tr>
						</table>
					</td>
				</tr>			
			</table>
		</cfform>	
<cfoutput>	
			
			  
<cf_qforms form="form1">
<script language= "javascript1.2" type="text/javascript">
		
</script>
</cfoutput>	
<cf_web_portlet_end>
<cf_templatefooter>