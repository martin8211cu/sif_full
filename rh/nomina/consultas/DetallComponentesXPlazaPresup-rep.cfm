<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RepComponentesXPlazaPresup" Default="Componentes por Plaza Presupuestada" returnvariable="LB_RepComponentesXPlazaPresup"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Plaza" Default="Plaza" returnvariable="LB_Plaza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Programa" Default="Programa" returnvariable="LB_Programa"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Jornada" Default="Jornada" returnvariable="LB_Jornada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Meses" Default="Meses" returnvariable="LB_Meses"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Categoria" Default="Categor&iacute;a" returnvariable="LB_Categoria"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_OcupadaPor" Default="Ocupada por" returnvariable="LB_OcupadaPor"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cedula" Default="C&eacute;dula" returnvariable="LB_Cedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalxPLZ" Default="Total por Plaza" returnvariable="LB_TotalxPLZ"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_UND" Default="Unidad" returnvariable="LB_UND"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalxUND" Default="Total por Unidad" returnvariable="LB_TotalxUND"/>

<!---<cf_dump var="#form#">--->
<style>
.detalle {
		font-size:12px;
		}
		
.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}		
</style>

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<!--- PLAZA INCIAL--->
<cfif isdefined('form.RHPPCODIGOD') >
	<cfquery name="rsPLZini" datasource="#session.DSN#">
	select RHPPdescripcion 
	from RHPlazaPresupuestaria
	where RHPPcodigo =<cfqueryparam  cfsqltype="cf_sql_varchar" value="#form.RHPPCODIGOD#">
	</cfquery>
</cfif>
<!--- PLAZA FINAL--->
<cfif isdefined('form.RHPPCODIGOH') >
	<cfquery name="rsPLZfinal" datasource="#session.DSN#">
	select RHPPdescripcion 
	from RHPlazaPresupuestaria
	where RHPPcodigo =<cfqueryparam  cfsqltype="cf_sql_varchar" value="#form.RHPPCODIGOH#"> 
	</cfquery>
</cfif>
		
	<cfset LvarFileName = "ComponentesPlazaPresupuestaria#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
			<cfsavecontent variable="ENCABEZADO_IMP">
			<td align="center">
			<cfoutput>		
			<cf_htmlReportsHeaders 
				title= "#LB_RepComponentesXPlazaPresup#"
				filename="#LvarFileName#"
				irA="DetallComponentesXPlazaPresup-filtro.cfm">
			</cfoutput>			
			
			<cfif rsPlazaPresup.RecordCount>		
				<table width="95%" cellpadding="1" cellspacing="0" align="center" border="0">
				
					<cfoutput>	
						<tr>							
							<td align="center" colspan="3"><strong><font size="2">
							<cf_EncReporte
								Titulo="#LB_RepComponentesXPlazaPresup# "	
								filtro1="<b>PLAZA INICIAL: #rsPLZini.RHPPdescripcion# -  PLAZA FINAL: #rsPLZfinal.RHPPdescripcion#</b>"		
								filtro2="&nbsp;"	
								filtro3="PLANILLA: #RHEdescripcion#"																	
							>
						<tr>	
						</cfoutput>								
					<cfoutput query="rsPlazaPresup">
							 <cfoutput group="unidad">
								<tr>
									<td class="detalle"><strong>#LB_Programa#: #rsPlazaPresup.Oficodigo#  </strong></td>
									<td class="detalle"><strong>#rsPlazaPresup.Odescripcion#</strong></td>
								</tr>					 
								<tr>
									<td class="detalle"><strong>#LB_UND#:&nbsp;#unidad#&nbsp;&nbsp;</strong></td>
									<td class="detalle"><strong>C.C:#rsPlazaPresup.centroCostos# </strong></td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<cfoutput group="RHPid">
								<tr class="tituloListas">
									<td class="detalle">#LB_Plaza#:&nbsp;#rsPlazaPresup.codigoPlz#</td>							
									<td class="detalle">#LB_Puesto#:&nbsp;#rsPlazaPresup.RHPcodigo#</td>		
									<td class="detalle">#rsPlazaPresup.RHPdescpuesto#</td>											
								</tr>
								<tr><td>&nbsp;</td></tr>																																										
								<tr><td class="detalle">#LB_Jornada#:&nbsp;#RHJcodigo#</td>	
								<cfset FechaDesde= DateFormat(#fdesdeplaza#, "dd/mm/yyyy")>
								<cfset FechaHasta= DateFormat(#fhastaplaza#, "dd/mm/yyyy")>
								<cfset meses = DateDiff("m", "#FechaDesde#", "#FechaHasta#")>
								<td class="detalle">#LB_Meses#:&nbsp;#meses#</td>			
																	
								<cfquery name="rsCategoria" datasource="#session.DSN#">
									select cat.RHCcodigo
									from  RHPlazas plz
										,RHCategoriasPuesto catPuesto
										,RHCategoria cat
									
									where plz.RHPid = #RHPid#
									and plz.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									
									and catPuesto.Ecodigo = plz.Ecodigo
									and catPuesto.RHCPlinea = plz.RHCPlinea
									
									and cat.Ecodigo = catPuesto.Ecodigo
									and cat.RHCid = catPuesto.RHCid
								</cfquery>
								<td class="detalle">#LB_Categoria#:&nbsp; #rsCategoria.RHCcodigo#</td></tr>													
								</tr>
									
								<tr>											
									<td class="detalle">#LB_OcupadaPor#&nbsp;:</td>	
									<td class="detalle">#LB_Cedula#:&nbsp;#DEidentificacion#&nbsp;#Nombre#</td>															
								</tr>
																																
									<cfquery name="rsComponentes" datasource="#session.DSN#" > 
										select CompSal.CScodigo 
										,CompSal.CSdescripcion 
										,CFormul.Monto
									
										from  RHCFormulacion  CFormul,
											ComponentesSalariales CompSal
										
										where CFormul.RHFid = #RHFid#
										and CFormul.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
										
										and CompSal.Ecodigo = CFormul.Ecodigo
										and CompSal.CSid = CFormul.CSid
									</cfquery>
									<cfset totalPlz = 0>
									<cfset TotalxUnidad= 0>
									<cfloop query="rsComponentes">
										<tr>													
											<td class="detalle" align="right">#CScodigo#</td>	
											<td class="detalle" align="right">#CSdescripcion#</td>
											<td class="detalle" align="right">#LSNumberFormat(Monto, '999,999,999.99')#</td>	
											<cfset totalPlz = totalPlz + Monto >							
										</tr>		
									</cfloop>	
									<cfset TotalxUnidad= TotalxUnidad + totalPlz>
									<tr>
										<td>&nbsp;</td>												
										<td class="detalle" align="right"><strong>#LB_TotalxPLZ#&nbsp;</strong></td>												
										<td class="detalle" align="right"><strong>#LSNumberFormat(totalPlz, '999,999,999.99')#</strong></td>												
									</tr>	
									</cfoutput>	<!--- Agrupado por la plaza  --->
									<tr>
										<td>&nbsp;</td>												
										<td class="detalle" align="right"><strong>#LB_TotalxUND#&nbsp;</strong></td>												
										<td class="detalle" align="right"><strong>#LSNumberFormat(TotalxUnidad, '999,999,999.99')#</strong></td>												
									</tr>	
									
								  </cfoutput>	<!--- Agrupado por el Centro Funcional  --->
						   </cfoutput>	
						   
						   <cfelse>
							<table width="792" align="center" border="0" cellspacing="0" cellpadding="2">
							<cfoutput>
								<tr><td align="center"class="titulo_empresa2"><strong>-----------#LB_NoSeEncontraronRegistros#-----------</strong></td></tr>
							</cfoutput>
							</table>				
						  </cfif>	
						   		 																	
					</cfsavecontent>
						
						<cfoutput>
							#ENCABEZADO_IMP#
						</cfoutput>
					</tr>					
					
				</table>			
			</td>
		</tr>
	</table>


