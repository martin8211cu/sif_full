<!---
	Módulo      : Contabilidad General / Consultas
	Nombre      : Reporte de Bitácora de Cierres
	Descripción :
		Muestra un reporte de bitácora para los dos tipos de cierre:
		cierre contable y cierre de auxiliares, filtrado por tipo de
		cierre, período y mes.
	Hecho por   : Steve Vado Rodríguez
	Creado      : 30/11/2005
	Modificado  : 
	

	Modificado por Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
			rendimiento de la pantalla. 

 --->

<!--- Consultas --->
<!--- <cfquery datasource="#Session.DSN#" name ="rsPeriodos">
	select distinct Speriodo 
	from SaldosContables 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	order by Speriodo desc
</cfquery> --->

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select distinct Speriodo
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Speriodo desc
</cfquery>

<!--- Declaraciones --->
<cfinclude template="Funciones.cfm">
<cfset periodo=get_val(30).Pvalor>
<cfset mes=get_val(40).Pvalor>
<cfinvoke key="LB_Titulo" 			default="Consulta Bitácora de Cierres" 			returnvariable="LB_Titulo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="BitacoraCierres.xml"/>
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
<cfinvoke key="BTN_Consultar" 		default="Consultar"			returnvariable="BTN_Consultar"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Limpiar" 		default="Limpiar"			returnvariable="BTN_Limpiar"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<!--- Formulario --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

	<cf_templateheader title="#LB_Titulo#">
		<cfinclude template="../../portlets/pNavegacion.cfm">				
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Titulo#">
		<cfif not isdefined("form.btnConsultar")>	
			<form action="BitacoraCierresRep.cfm" method="post" name="form1">
				<cfoutput>				  
				<table width="100%" border="0">
					<tr>
						<td  valign="top"width="34%"> <cf_web_portlet_start border="true" titulo="#LB_Titulo#" skin="info1">
							<div align="center">
						  		<p align="justify"><cf_translate key=LB_Mensaje>
									Muestra un reporte de bitácora para los dos tipos de cierre:
									cierre contable y cierre de auxiliares, filtrado por tipo de
									cierre, período y mes.</cf_translate>
								</p>
							</div>
							<cf_web_portlet_end> 
						</td>
						<td width="5%">&nbsp;</td>
						<td width="50%">
							<table width="100%" border="0">
								<tr>
									<td width="14%" align="right"><strong><cf_translate key=LB_TipoCierre>Tipo de Cierre</cf_translate>:</strong></td>
									<td width="30%" colspan="4">
										<select name="tipo">																		
											<option value="1"><cf_translate key=LB_CierreContable>Cierre Contable</cf_translate></option>										
											<option value="2"><cf_translate key=LB_CierreAuxiliar>Cierre de Auxiliares</cf_translate></option>
											<option value="-1">(<cf_translate key=LB_Todos>Todos</cf_translate>)</option>											
										</select>										
									</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>								
								<tr>
									<td align="right"><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate>:</strong></td>
									<td width="10%">
										<select name="periodo">
											<cfloop query = "rsPeriodos">
												<option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>" <cfif periodo EQ "#rsPeriodos.Speriodo#">selected</cfif>></option>
											</cfloop>
											<option value="-1">(<cf_translate key=LB_Todos>Todos</cf_translate>)</option>
										</select>									
									</td>
									<td width="8%" align="right"><strong><cf_translate key=LB_Mes>Mes</cf_translate>:</strong></td>
									<td width="48%">
										<select name="mes" size="1">
											<option value="1" <cfif mes EQ 1>selected</cfif>>#CMB_Enero#</option>
											<option value="2" <cfif mes EQ 2>selected</cfif>>#CMB_Febrero#</option>
											<option value="3" <cfif mes EQ 3>selected</cfif>>#CMB_Marzo#</option>
											<option value="4" <cfif mes EQ 4>selected</cfif>>#CMB_Abril#</option>
											<option value="5" <cfif mes EQ 5>selected</cfif>>#CMB_Mayo#</option>
											<option value="6" <cfif mes EQ 6>selected</cfif>>#CMB_Junio#</option>
											<option value="7" <cfif mes EQ 7>selected</cfif>>#CMB_Julio#</option>
											<option value="8" <cfif mes EQ 8>selected</cfif>>#CMB_Agosto#</option>
											<option value="9" <cfif mes EQ 9>selected</cfif>>#CMB_Setiembre#</option>
											<option value="10" <cfif mes EQ 10>selected</cfif>>#CMB_Octubre#</option>
											<option value="11" <cfif mes EQ 11>selected</cfif>>#CMB_Noviembre#</option>
											<option value="12" <cfif mes EQ 12>selected</cfif>>#CMB_Diciembre#</option>
											<option value="-1">(<cf_translate key=LB_Todos>Todos</cf_translate>)</option>
										</select>									
									</td>									
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr>		
									<td colspan="4" align="center">
									  <div align="center">
										<input name="btnConsultar" type="submit" value="#BTN_Consultar#">
										<input type="reset" name="Reset" value="#BTN_Limpiar#">
									</div></td>
								</tr>
							</table>
						</td> 
					</tr>
				</table> 
				</cfoutput>
			</form> 
		</cfif> 
		<cf_web_portlet_end>
	<cf_templatefooter> 