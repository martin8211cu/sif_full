
<!--- <cf_dump var=#form#>  --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

	 <!---<cfdump var=#CurrentPage#> --->
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ExportacionDeAsientos"
	Default="Exportaci&oacute;n  del Asiento Contable"	
	returnvariable="LB_ExportacionDeAsientos"/>	

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
		
	<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ERROR_El_asiento_Contable_de_la_Nomina_no_esta_Balanceado"
			Default="El asiento Contable de la Nómina no está Balanceado:"
			returnvariable="MSG_AsientoNoBalanceado"/>	
			
	<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Debitos"
			Default="Débitos= "
			returnvariable="MSG_Debitos"/>
		
	<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Creditos"
			Default="Créditos= "
			returnvariable="MSG_Creditos"/>		
			
	<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Exportacion"
					Default="Exportaci&oacute;n"	
					returnvariable="LB_Exportacion"/>	
		
							
		<cfquery name="rsBalance" datasource="#session.DSN#" >		
		select 
			round(sum (tabla.MontoDebito),2) as MontoDebito,
			round(sum (tabla.MontoCredito),2) as MontoCredito
		from 
			(Select 	
			 case when tipo='D' then 
					  coalesce  (Sum(montores),0)
					else 0 end as MontoDebito,		
			case when tipo='C' then 
					  coalesce ( Sum(montores),0) 
			else  0 end  as MontoCredito				
			from   
			RCuentasTipo a, 
			HRCalculoNomina b  
			Where a.RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">  
			and a.RCNid=b.RCNid           
			group by  tipo) tabla				
			</cfquery>
			
			<cfset LvarTC = 1.00>
			
				<cfset LvarDebitos 	= rsBalance.MontoDebito>
				<cfset LvarCreditos = rsBalance.MontoCredito>
							
				<script type="text/javascript">
					<cfif LvarDebitos NEQ LvarCreditos>
					alert('<cfoutput>#MSG_AsientoNoBalanceado# #MSG_Debitos# #NumberFormat(LvarDebitos,',9.99')#, #MSG_Creditos# #NumberFormat(LvarCreditos,',9.99')# </cfoutput>');
				    </cfif>				
				</script>	
				
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start titulo="<cfoutput>#LB_ExportacionDeAsientos#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
																							
				<cfquery name="rsParametros" datasource="#Session.DSN#">
				select Pvalor
				from RHParametros
				where Pcodigo=2050
				</cfquery>
							
				<cfif len(trim(rsParametros.Pvalor)) GT 0> 
				<cfset EIcodigo = '#rsParametros.Pvalor#'>	
										
				<cfquery name="rs" datasource="sifcontrol">
				  select EIcodigo, EIid
				  from EImportador
				  where EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EIcodigo#">
				</cfquery>													
					<cfset EIid= rs.EIid>

				<cfquery name="rsBanco"datasource="#Session.DSN#">

					select Bid,* from bancos
					where Bdescripcion =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#EIcodigo#">
					
				</cfquery>

					<cfset Bid= #rsBanco.Bid#>


				<cfelse> 
				    <cfthrow message="#MSG_Exportador_No_Definido#"> 
				</cfif>  

			
				
	         <table>
				<tr>
					<td valign="top" width="50%">
						<table width="100%">
							<tr>
								<td>						
									<cf_web_portlet_start border="true" titulo="#LB_Exportacion#" skin="info1">
										<table width="100%">
											<tr><td><p>
											<cf_translate key="LB_EnEsteProcesoGeneraraInformacionConta">
												En este proceso, se generará la información de los Asientos.  
												Seleccione el tipo de generación que desea, y presione la opción <strong>Generar</strong> 
												para obtener el archivo.
											</cf_translate>
											</p></td></tr>
										</table>
									<cf_web_portlet_end>
								</td>
							</tr>
				</table>

				<td width="50%">								
			<!---    <form name="form1" action="" method="get">  --->							
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="right">
						  <tr>
							<td colspan="2" align="center">
								<cf_sifimportar EIcodigo="#EIcodigo#" EIid="#EIid#" mode="out" ExtraccAsientos="true">
									<!--- EcodigoASP --->
									<cf_sifimportarparam name="EcodigoASP" value="#session.EcodigoSDC#">
									
									<!--- ERNid --->																			
									<cf_sifimportarparam name="ERNid" value="#form.CPid#"> 
									<cf_sifimportarparam name="Bid" value="#Bid#">
									<!--- <cf_sifimportarparam name="ERNid" value="#form.CPid#"> 
									<cf_sifimportarparam name="Bid" value="8">
									<cf_dump var="#form#"> --->
								<!---	<cf_dump var="#form.Bid#"> --->

									<cfset url.ERNid = form.CPid>
								<!---	<cf_dump var="#form.CPid#">
									<cfset url.ERNid = form.CPid>  --->
																									
									<cfif isdefined("form.parametros") and len(trim(form.parametros)) >
										<cfset parametros = '' >
										<cfloop list="#form.parametros#" index="i" delimiters=",">
											<cfif isdefined("form.#i#") >
												<cfset valor = form[#i#] >
												<cf_sifimportarparam name="#i#" value="#valor#">
											</cfif>
										</cfloop>
									</cfif>																	
								  </cf_sifimportar>
							</td>
						  </tr>
					</table>	
				</td>			
			  <!---    </form>	--->																	
		<cf_web_portlet_end>
	<cf_templatefooter>	

