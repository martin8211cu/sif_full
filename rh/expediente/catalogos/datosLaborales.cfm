<cfinvoke key="LB_Fecha_de_Aplicacion" Default="Fecha de Aplicaci&oacute;n"  returnvariable="vAplicacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Accion" Default="Acci&oacute;n" returnvariable="vAccion" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>	
<cfinvoke key="LB_Comportamiento" Default="Comportamiento" returnvariable="vComportamiento" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Vigencia" Default="Vigencia" returnvariable="vVigencia" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_Finalizacion" Default="Finalizaci&oacute;n" returnvariable="vFinalizacion" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_Plaza" Default="Plaza" returnvariable="vPlaza" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Salario"	Default="Salario" returnvariable="vSalario" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke Key="LB_Anotacion" Default="Anotación" returnvariable="LB_Anotacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Antiguedad" Default="Antigüedad" returnvariable="LB_Antiguedad" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Recargo" Default="Recargo" returnvariable="LB_Recargo" component="sif.Componentes.Translate" method="Translate"/>

<cfif isdefined("Url.ViewMode") and not isdefined("Form.ViewMode")>
	<cfparam name="Form.ViewMode" default="#Url.ViewMode#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.DLlinea") and not isdefined("Form.DLlinea")>
	<cfset Form.DLlinea = Url.DLlinea>
</cfif>
<cfif isdefined("Url.fAplicacion1") and not isdefined("Form.fAplicacion1")>
	<cfset Form.fAplicacion1 = Url.fAplicacion1>
</cfif>
<cfif isdefined("Url.fAplicacion2") and not isdefined("Form.fAplicacion2")>
	<cfset Form.fAplicacion2 = Url.fAplicacion2>
</cfif>
<cfif isdefined("Url.fVigencia1") and not isdefined("Form.fVigencia1")>
	<cfset Form.fVigencia1 = Url.fVigencia1>
</cfif>
<cfif isdefined("Url.fVigencia2") and not isdefined("Form.fVigencia2")>
	<cfset Form.fVigencia2 = Url.fVigencia2>
</cfif>
<cfif isdefined("Url.selAccion") and not isdefined("Form.selAccion")>
	<cfset Form.selAccion = Url.selAccion>
</cfif>
<cfif isdefined("Url.selComportamiento") and not isdefined("Form.selComportamiento")>
	<cfset Form.selComportamiento = Url.selComportamiento>
</cfif>

<cfset navegacion = "">
<cfset MoreCols = "">
<cfset ViewMode = "5">
<cfset filtro = "">
<cfif isdefined("Form.o") and Len(Trim(Form.o)) NEQ 0>
	<cfset MoreCols = MoreCols & ", '#Form.o#' as o">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "o=" & Form.o>
</cfif>
<cfif isdefined("Form.sel") and Len(Trim(Form.sel)) NEQ 0>
	<cfset MoreCols = MoreCols & ", '#Form.sel#' as sel">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif>
<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.ViewMode") and Len(Trim(Form.ViewMode)) NEQ 0>
	<cfset MoreCols = MoreCols & ", '#Form.ViewMode#' as ViewMode">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ViewMode=" & Form.ViewMode>
	<cfset ViewMode = Form.ViewMode>
</cfif>
<cfif isdefined("Form.fAplicacion1") and Len(Trim(Form.fAplicacion1)) NEQ 0
	  and isdefined("Form.fAplicacion2") and Len(Trim(Form.fAplicacion2)) NEQ 0>
	<cfset filtro = filtro & " and convert(datetime, convert(varchar, a.DLfechaaplic, 103), 103) between convert(datetime, '#Form.fAplicacion1#', 103) and convert(datetime, '#Form.fAplicacion2#', 103) ">
<cfelseif isdefined("Form.fAplicacion1") and Len(Trim(Form.fAplicacion1)) NEQ 0>
	<cfset filtro = filtro & " and convert(datetime, convert(varchar, a.DLfechaaplic, 103), 103) >= convert(datetime, '#Form.fAplicacion1#', 103) ">
<cfelseif isdefined("Form.fAplicacion2") and Len(Trim(Form.fAplicacion2)) NEQ 0>
	<cfset filtro = filtro & " and convert(datetime, convert(varchar, a.DLfechaaplic, 103), 103) <= convert(datetime, '#Form.fAplicacion2#', 103) ">
</cfif>
<cfif isdefined("Form.fAplicacion1") and Len(Trim(Form.fAplicacion1)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fAplicacion1=" & Form.fAplicacion1>
</cfif>
<cfif isdefined("Form.fAplicacion2") and Len(Trim(Form.fAplicacion2)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fAplicacion2=" & Form.fAplicacion2>
</cfif>
<cfif isdefined("Form.fVigencia1") and Len(Trim(Form.fVigencia1)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fVigencia1=" & Form.fVigencia1>
	<cfset filtro = filtro & " and convert(datetime, convert(varchar, a.DLfvigencia, 103), 103) >= convert(datetime, '#Form.fVigencia1#', 103) ">
</cfif>
<cfif isdefined("Form.fVigencia2") and Len(Trim(Form.fVigencia2)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fVigencia2=" & Form.fVigencia2>
	<cfset filtro = filtro & " and convert(datetime, convert(varchar, a.DLffin, 103), 103) >= convert(datetime, '#Form.fVigencia2#', 103) ">
</cfif>
<cfif isdefined("Form.selAccion") and Len(Trim(Form.selAccion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "selAccion=" & Form.selAccion>
	<cfset filtro = filtro & " and b.RHTid = #Form.selAccion#">
</cfif>
<cfif isdefined("Form.selComportamiento") and Len(Trim(Form.selComportamiento)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "selComportamiento=" & Form.selComportamiento>
	<cfset filtro = filtro & " and b.RHTcomportam = #Form.selComportamiento#">
</cfif>
				
<cfsavecontent variable="listaAcciones">
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="cantRegistros">
		<cfinvokeargument name="tabla" value="DLaboralesEmpleado a, RHTipoAccion b, RHPlazas c"/>
		<cfinvokeargument name="columnas" value="  a.DLlinea, 
												   a.DLconsecutivo, 
												   a.DEid, 
												   a.RHTid, 
												   a.Dcodigo, 
												   a.Ocodigo, 
												   a.RHPid, 
												   a.RHPcodigo, 
												   a.Tcodigo, 
												   a.DLfvigencia as Vigencia,
												   a.DLffin as Finalizacion,
												   a.DLsalario, 
												   a.DLobs, 
												   a.DLfechaaplic as FechaAplicacion,
												   {fn concat ({fn concat(b.RHTcodigo, ' - ' )},  b.RHTdesc)} as Accion,
												   case b.RHTcomportam 
														when 1 then 'Nombramiento' 
														when 2 then 'Cese'
														when 3 then 'Vacaciones'
														when 4 then 'Permiso'
														when 5 then 'Incapacidad'
														when 6 then 'Cambio'
														when 7 then 'Anulación'
														when 8 then 'Aumento'
														when 9 then 'Cambio de Empresa'
                                                        when 10 then '#LB_Anotacion#'
														when 11 then '#LB_Antiguedad#'
                                                        when 12 then '#LB_Recargo#'
														else ''
												   end as Comportamiento,
												   c.RHPdescripcion
												   #MoreCols#"/>
		<cfinvokeargument name="desplegar" value="FechaAplicacion, Accion, Comportamiento, Vigencia, Finalizacion, RHPdescripcion, DLsalario"/>
		<cfinvokeargument name="etiquetas" value="#vAplicacion#, #vAccion#, #vComportamiento#, #vVigencia#, #vFinalizacion#, #vPlaza#, #vSalario#"/>
		<cfinvokeargument name="formatos" value="D,V,V,D,D,V,M"/>
		<cfinvokeargument name="filtro" value="a.DEid = #Form.DEid#
												and a.RHTid = b.RHTid
												and a.RHPid = c.RHPid
												#filtro#
												order by a.DLfechaaplic desc, a.DLfvigencia, a.DLffin, a.DLconsecutivo"/>
		<cfinvokeargument name="align" value="center, left, left, center, center, left, right"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
		<cfinvokeargument name="MaxRows" value="#ViewMode#"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="debug" value="N"/>
	</cfinvoke>
</cfsavecontent>

<cfquery name="rsTipoAccion" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char" args="RHTid">  as RHTid,
		   {fn concat ({fn concat(RHTcodigo, ' - ' )},RHTdesc)}
		   as Descripcion
	from RHTipoAccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Descripcion
</cfquery>


  <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr> 
	  <td>
		<cfinclude template="/rh/portlets/pEmpleado.cfm"></td>
	</tr>
	<tr> 
	  <td align="center"> 
		  <cfif isdefined("Url.DLlinea") or isdefined("Form.DLlinea")>
		  	<table border="0" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cfinclude template="../consultas/frame-detalleAcciones.cfm">
					</td>
				</tr>
			</table>
		  <cfelse>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr> 
					<td nowrap class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;"><cf_translate key="LB_Datos_laborales_del_empleado">Datos laborales del empleado</cf_translate></td>
				  </tr>
				  <tr> 
					<td>&nbsp;</td>
				  </tr>
				  <tr> 
					<td>
						<cfoutput>
						<form name="filtroLaborales" action="#GetFileFromPath(GetTemplatePath())#" method="post" style="margin: 0">
							<input type="hidden" name="o" value="<cfif isdefined('Form.o')><cfoutput>#Form.o#</cfoutput></cfif>">
							<input type="hidden" name="sel" value="<cfif isdefined('Form.sel')><cfoutput>#Form.sel#</cfoutput></cfif>">
							<input type="hidden" name="DEid" value="<cfif isdefined('Form.DEid')><cfoutput>#Form.DEid#</cfoutput></cfif>">
							<input type="hidden" name="ViewMode" value="<cfif isdefined('Form.ViewMode')><cfoutput>#Form.ViewMode#</cfoutput></cfif>">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
							  <tr>
								<td colspan="4" align="center" style="font-weight: bold; border-bottom: 1px solid black;" ><cfoutput>#vAplicacion#</cfoutput></td>
								<td style="font-weight: bold; border-bottom: 1px solid black;" ><cfoutput>#vAccion#</cfoutput></td>
								<td style="font-weight: bold; border-bottom: 1px solid black;" ><cfoutput>#vComportamiento#</cfoutput></td>
								<td colspan="4" align="center" style="font-weight: bold; border-bottom: 1px solid black;"><cf_translate key="LB_Fecha_de_Vigencia">Fecha de Vigencia</cf_translate></td>
							  </tr>
							  <tr>
								<td align="right" style="padding-top: 5px;" nowrap="nowrap"><cf_translate key="LB_Desde">Desde</cf_translate>:</td>
								<td style="padding-left: 5px; padding-top: 5px;">
									<cfif isdefined("Form.fAplicacion1")>
										<cfset aplicacion1 = Form.fAplicacion1>
									<cfelse>
										<cfset aplicacion1 = "">
									</cfif>
									<cf_sifcalendario name="fAplicacion1" value="#aplicacion1#" form="filtroLaborales">
								</td>
								<td align="right" style="padding-top: 5px;" nowrap="nowrap"><cf_translate key="LB_Hasta">Hasta</cf_translate>:</td>
								<td style="padding-left: 5px; padding-top: 5px;">
									<cfif isdefined("Form.fAplicacion2")>
										<cfset aplicacion2 = Form.fAplicacion2>
									<cfelse>
										<cfset aplicacion2 = "">
									</cfif>
									<cf_sifcalendario name="fAplicacion2" value="#aplicacion2#" form="filtroLaborales">
								</td>
								<td style="padding-top: 5px;">
                                	<cf_rhtipoaccion hidectls="tdFfinetq,tdFfintxt,trEmpresa,trIncapacidad,trIncapacidadFolio" combo="false" tabindex="1" size="20" form="filtroLaborales">
									<!--- <select name="RHTid">
										<option value="">(<cf_translate key="LB_Todas" xmlfile="/rh/generales.xml">Todas</cf_translate>)</option>
										<cfloop query="rsTipoAccion">
											<option value="#rsTipoAccion.RHTid#" <cfif isdefined("Form.RHTid") and Form.RHTid EQ rsTipoAccion.RHTid>selected</cfif>>#rsTipoAccion.Descripcion#</option>
										</cfloop>
									</select> --->
								</td>
								<td style="padding-top: 5px;">
									<select name="selComportamiento">
										<option value="">(<cf_translate key="LB_Todas" xmlfile="/rh/generales.xml">Todas</cf_translate>)</option>
										<option value="1" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "1">selected</cfif>><cf_translate key="LB_Nombramiento">Nombramiento</cf_translate></option>
										<option value="2" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "2">selected</cfif>><cf_translate key="LB_Cese">Cese</cf_translate></option>
										<option value="3" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "3">selected</cfif>><cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></option>
										<option value="4" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "4">selected</cfif>><cf_translate key="LB_Permiso">Permiso</cf_translate></option>
										<option value="5" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "5">selected</cfif>><cf_translate key="LB_Incapacidad">Incapacidad</cf_translate></option>
										<option value="6" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "6">selected</cfif>><cf_translate key="LB_Cambio">Cambio</cf_translate></option>
										<option value="7" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "7">selected</cfif>><cf_translate key="LB_Anulacion">Anulación</cf_translate></option>
										<option value="9" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "9">selected</cfif>><cf_translate key="LB_Cambio_de_Empresa">Cambio de Empresa</cf_translate></option>
										<option value="10" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "10">selected</cfif>><cf_translate key="LB_Anotacion">Anotaci&oacute;n</cf_translate></option>
										<option value="11" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "11">selected</cfif>><cf_translate key="LB_Antiguedad">Antigüedad</cf_translate></option>
										<option value="12" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "12">selected</cfif>><cf_translate key="LB_Recargo">Recargo</cf_translate></option>
									</select>
								</td>
								<td align="right" style="padding-top: 5px;" nowrap="nowrap"><cf_translate key="LB_Desde" xmlfile="/rh/generales.xml">Desde</cf_translate>:</td>
								<td style="padding-left: 5px; padding-top: 5px;">
									<cfif isdefined("Form.fVigencia1")>
										<cfset vigencia1 = Form.fVigencia1>
									<cfelse>
										<cfset vigencia1 = "">
									</cfif>
									<cf_sifcalendario name="fVigencia1" value="#vigencia1#" form="filtroLaborales">
								</td>
								<td align="right" style="padding-top: 5px;" nowrap="nowrap"><cf_translate key="LB_Hasta" xmlfile="/rh/generales.xml">Hasta</cf_translate>:</td>
								<td style="padding-left: 5px; padding-top: 5px;">
									<cfif isdefined("Form.fVigencia2")>
										<cfset vigencia2 = Form.fVigencia2>
									<cfelse>
										<cfset vigencia2 = "">
									</cfif>
									<cf_sifcalendario name="fVigencia2" value="#vigencia2#" form="filtroLaborales">
								</td>
							  </tr>
							  <tr>
								<td colspan="10" align="center"><input type="submit" name="btnBuscar" value="<cfoutput>#vFiltrar#</cfoutput>"></td>
							  </tr>
							</table>
						</form>
						</cfoutput>
					</td>
				  </tr>
				  <tr> 
					<td align="right" style="padding-top: 5px; padding-bottom: 5px;">
						<form action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>" method="post" style="margin: 0">
							<input type="hidden" name="o" value="<cfif isdefined('Form.o')><cfoutput>#Form.o#</cfoutput></cfif>">
							<input type="hidden" name="sel" value="<cfif isdefined('Form.sel')><cfoutput>#Form.sel#</cfoutput></cfif>">
							<input type="hidden" name="DEid" value="<cfif isdefined('Form.DEid')><cfoutput>#Form.DEid#</cfoutput></cfif>">
							<input type="hidden" name="fAplicacion1" value="<cfif isdefined('Form.fAplicacion1')><cfoutput>#Form.fAplicacion1#</cfoutput></cfif>">
							<input type="hidden" name="fAplicacion2" value="<cfif isdefined('Form.fAplicacion2')><cfoutput>#Form.fAplicacion2#</cfoutput></cfif>">
							<input type="hidden" name="fVigencia1" value="<cfif isdefined('Form.fVigencia1')><cfoutput>#Form.fVigencia1#</cfoutput></cfif>">
							<input type="hidden" name="fVigencia2" value="<cfif isdefined('Form.fVigencia2')><cfoutput>#Form.fVigencia2#</cfoutput></cfif>">
							<input type="hidden" name="selAccion" value="<cfif isdefined('Form.selAccion')><cfoutput>#Form.selAccion#</cfoutput></cfif>">
							<input type="hidden" name="selComportamiento" value="<cfif isdefined('Form.selComportamiento')><cfoutput>#Form.selComportamiento#</cfoutput></cfif>">
							<select name="ViewMode" onChange="javascript: this.form.submit(); ">
								<option value="5" <cfif Trim(ViewMode) EQ "5">selected</cfif>><cf_translate key="LB_Ver_de_5_en_5">Ver de 5 en 5</cf_translate></option>
								<option value="0" <cfif Trim(ViewMode) EQ "0">selected</cfif>><cf_translate key="LB_Ver_Todas">Ver Todas</cf_translate></option>
							</select>
						</form>
					</td>
				  </tr>
				  <tr>
					<td>
						<cfif cantRegistros GT 0>
							<cfoutput>#listaAcciones#</cfoutput>
						<cfelse>
							<cf_translate key="MSG_No_se_encontraron_acciones_con_el_criterio_escogido_o_El_empleado_no_tiene_acciones_asociadas_actualmente">No se encontraron acciones con el criterio escogido o El empleado no tiene acciones asociadas actualmente</cf_translate>
						</cfif> 
					</td>
				  </tr>
				</table>
		  </cfif>
	  </td>
	</tr>
	<tr> 
	  <td>&nbsp;</td>
	</tr>
  </table>
