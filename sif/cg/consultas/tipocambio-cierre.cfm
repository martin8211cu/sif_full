<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Tipo de Cambio de Cierre Contable" 
returnvariable="LB_Titulo" xmlfile = "tipocambio-cierre.xml"/>
<cfinvoke key="BTN_Consultar" 			default="Consultar" 			returnvariable="BTN_Consultar" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>


	<cf_templateheader title="#LB_Titulo#">


		<cfparam name="form.Consultar" default="">

		<cfquery name="periodos" datasource="#session.DSN#">
			select distinct tce.Periodo
			from TipoCambioEmpresa tce
			
			where tce.Ecodigo = #session.Ecodigo#
			order by tce.Periodo desc
		</cfquery>	

		<cfquery name="periodo_actual" datasource="#session.DSN#">
			select p.Pvalor
			from Parametros p
			where p.Ecodigo = #session.Ecodigo#
			  and p.Pcodigo = 30
		</cfquery>	
		<cfparam name="form.periodo" default="#periodo_actual.Pvalor#">

		<cfquery name="mes_actual" datasource="#session.DSN#">
			select p.Pvalor
			from Parametros p
			where p.Ecodigo = #session.Ecodigo#
			  and p.Pcodigo = 40
		</cfquery>
		<cfparam name="form.mes" default="#mes_actual.Pvalor#">

		<cfquery name="monedas" datasource="#session.DSN#">
			select distinct tce.Mcodigo, m.Mnombre
			from TipoCambioEmpresa tce
			
			inner join Monedas m
			on m.Mcodigo=tce.Mcodigo
			and m.Ecodigo=tce.Ecodigo
			
			where tce.Ecodigo = #session.Ecodigo#
			order by m.Mnombre
		</cfquery>	
		 <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<table width="100%" cellpadding="0" border="0" cellspacing="0">
			<tr>
				<td>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>	
						<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" >
							<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
						</table>
						<br />
						<cfoutput>
						<form method="post" action="" name="form1" style="margin:0;" onsubmit="return sinbotones()">
						<table width="99%" align="center" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
							<tr>
								<td width="1%"><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate>:&nbsp;</strong></td>
								<td>
									<select name="periodo">
										<option value="">-<cf_translate key=LB_Selecciona>seleccionar</cf_translate>-</option>
										<cfloop query="periodos">
											<option value="#periodos.Periodo#" <cfif isdefined("form.Periodo") and form.Periodo eq periodos.Periodo>selected</cfif> >#periodos.Periodo#</option>
										</cfloop>
									</select>
								</td>
								<td width="1%"><strong><cf_translate key=LB_Mes>Mes</cf_translate>:&nbsp;</strong></td>
								<td>
									<select name="mes">
										<option value="">-<cf_translate key=LB_Selecciona>seleccionar</cf_translate>-</option>
										<option value="1" <cfif form.mes eq 1>selected</cfif> >#CMB_Enero#</option>
										<option value="2" <cfif form.mes eq 2>selected</cfif> >#CMB_Febrero#</option>
										<option value="3" <cfif form.mes eq 3>selected</cfif> >#CMB_Marzo#</option>
										<option value="4" <cfif form.mes eq 4>selected</cfif> >#CMB_Abril#</option>
										<option value="5" <cfif form.mes eq 5>selected</cfif> >#CMB_Mayo#</option>
										<option value="6" <cfif form.mes eq 6>selected</cfif> >#CMB_Junio#</option>
										<option value="7" <cfif form.mes eq 7>selected</cfif> >#CMB_Julio#</option>
										<option value="8" <cfif form.mes eq 8>selected</cfif> >#CMB_Agosto#</option>
										<option value="9" <cfif form.mes eq 9>selected</cfif> >#CMB_Setiembre#</option>
										<option value="10" <cfif form.mes eq 10>selected</cfif> >#CMB_Octubre#</option>
										<option value="11" <cfif form.mes eq 11>selected</cfif> >#CMB_Noviembre#</option>
										<option value="12" <cfif form.mes eq 12>selected</cfif> >#CMB_Diciembre#</option>
									</select>
									
								</td>
								<td width="1%"><strong><cf_translate key=LB_Moneda>Moneda</cf_translate>:&nbsp;</strong></td>
								<td>
									<select name="Mcodigo">
										<option value="">-<cf_translate key=LB_Selecciona>seleccionar</cf_translate>-</option>
										<cfloop query="monedas">
											<option value="#monedas.Mcodigo#" <cfif isdefined("form.Mcodigo") and form.Mcodigo eq monedas.Mcodigo>selected</cfif> >#monedas.Mnombre#</option>
										</cfloop>
									</select>
								</td>
								
								<td align="center">
									<input type="submit" name="Consultar" value="#BTN_Consultar#">
								</td>
								
							</tr>
						</table>
						</form>
						</cfoutput>	
						<br />
						
						<cfif isdefined("form.Consultar")>
							<cfset params = "&periodo=#form.periodo#&mes=#form.mes#">
							<cfif isdefined("form.Mcodigo")>
								<cfset params = params & "&Mcodigo=#form.Mcodigo#">
							</cfif>

							<cf_rhimprime datos="/sif/cg/consultas/tipocambio-cierre-form.cfm" paramsuri="#params#">
							<cfinclude template="tipocambio-cierre-form.cfm">
						</cfif>
					<cf_web_portlet_end>
				</td>
			</tr>
		</table>
	<cf_templatefooter>