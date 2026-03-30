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
				

	<!--- Expediente --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="FechaAplicacion"
		Default="Aplicacion"
		Idioma="#session.Idioma#"
		returnvariable="vAplicacion"/>

	<!--- Datos Personales --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Acciones"
		Default="Acciones"
		Idioma="#session.Idioma#"
		returnvariable="vAccion"/>

	<!--- Datos Familiares --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Comportamiento"
		Default="Comportamiento"
		Idioma="#session.Idioma#"
		returnvariable="vComportamiento"/>

	<!--- Datos Laborales --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Vigencia"
		Default="Vigencia"
		Idioma="#session.Idioma#"
		returnvariable="vVigencia"/>

	<!--- Cargas --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="HastaExp"
		Default="Finalizacion"
		Idioma="#session.Idioma#"
		returnvariable="vHasta"/>

	<!--- Deducciones --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Plaza"
		Default="Plaza"
		Idioma="#session.Idioma#"
		returnvariable="vPlaza"/>

	<!--- Anotaciones --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Salarios"
		Default="Salario"
		Idioma="#session.Idioma#"
		returnvariable="vSalario"/>
<!--- --->

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Nombramiento"
Default="Nombramiento"
returnvariable="LB_Nombramiento"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Cese"
Default="Cese"
returnvariable="LB_Cese"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Vacaciones"
Default="Vacaciones"
returnvariable="LB_Vacaciones"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Permiso"
Default="Permiso"
returnvariable="LB_Permiso"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Incapacidad"
Default="Incapacidad"
returnvariable="LB_Incapacidad"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Cambio"
Default="Cambio"
returnvariable="LB_Cambio"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Anulacion"
Default="Anulación"
returnvariable="LB_Anulacion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Aumento"
Default="Aumento"
returnvariable="LB_Aumento"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CambioDeEmpresa"
Default="Cambio de Empresa"
returnvariable="LB_CambioDeEmpresa"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Anotacion"
Default="Anotación"
returnvariable="LB_Anotacion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Antiguedad"
Default="Antigüedad"
returnvariable="LB_Antiguedad"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Recargo"
Default="Recargo"
returnvariable="LB_Recargo"/>


<cf_dbfunction name="to_char" args="a.DLlinea" returnvariable="LVDLlinea">
<cf_dbfunction name="to_char" args="a.DEid" returnvariable="LVDEid">
<cf_dbfunction name="to_char" args="a.RHTid" returnvariable="LVRHTid">
<cf_dbfunction name="to_char" args="a.RHPid" returnvariable="LVRHPid">
<cf_dbfunction name="to_char_integer" args="a.DLsalario" returnvariable="LVDLsalario">
<cf_dbfunction name="date_format" args="a.DLfvigencia,DD/MM/YYYY" returnvariable="LVDLfvigencia">
<cf_dbfunction name="date_format" args="a.DLffin,DD/MM/YYYY" returnvariable="LVDLffin">
<cf_dbfunction name="date_format" args="a.DLfechaaplic,DD/MM/YYYY" returnvariable="LVDLfechaaplic">

<!--- '#rsEmpleado.DEidentificacion#' as DEidentificacion,
'#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#' as NombreCompleto, --->


<cfsavecontent variable="listaAcciones">
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="cantRegistros">
		<cfinvokeargument name="tabla" value="DLaboralesEmpleado a, RHTipoAccion b, RHPlazas c"/>
		<cfinvokeargument name="columnas" value="  #LVDLlinea#  as DLlinea, 
												   a.DLconsecutivo, 
												   #LVDEid# as DEid, 
												   #LVRHTid# as RHTid, 
												   a.Dcodigo, 
												   a.Ocodigo, 
												   #LVRHPid# as RHPid, 
												   a.RHPcodigo, 
												   a.Tcodigo, 
												   case when a.DLfvigencia is not null then #LVDLfvigencia# else '' end as Vigencia,
												   case when a.DLffin is not null then #LVDLffin# else 'Indefinido' end as Finalizacion,
												   #LVDLsalario# as DLsalario, 
												   a.DLobs, 
												   #LVDLfechaaplic# as FechaAplicacion,
												   {fn concat(b.RHTcodigo ,{fn concat(' - ',b.RHTdesc)})} as Accion,
												   case b.RHTcomportam 
														when 1 then '#LB_Nombramiento#' 
														when 2 then '#LB_Cese#'
														when 3 then '#LB_Vacaciones#'
														when 4 then '#LB_Permiso#'
														when 5 then '#LB_Incapacidad#'
														when 6 then '#LB_Cambio#'
														when 7 then '#LB_Anulacion#'
														when 8 then '#LB_Aumento#'
														when 9 then '#LB_CambioDeEmpresa#'
														when 10 then '#LB_Anotacion#'
														when 11 then '#LB_Antiguedad#'
                                                        when 12 then '#LB_Recargo#'
														else ''
												   end as Comportamiento,
												   c.RHPdescripcion,
												   b.RHTespecial
												   #MoreCols#"/>
		<cfinvokeargument name="desplegar" value="FechaAplicacion, Accion, Comportamiento, Vigencia, Finalizacion, RHPdescripcion, DLsalario"/>
		<cfinvokeargument name="etiquetas" value="#vAplicacion#, #vAccion#, #vComportamiento#, #vVigencia#, #vHasta#, #vPlaza#, #vSalario#"/>
		<cfinvokeargument name="formatos" value="V,V,V,V,V,V,M"/>
		<cfinvokeargument name="filtro" value="a.DEid = #rsEmpleado.DEid#
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
		 <cfinvokeargument name="PageIndex" value="2"/>
		
	</cfinvoke>
</cfsavecontent>
<cf_dbfunction name="to_char" args="RHTid" returnvariable="LVRHTid">

<cfquery name="rsTipoAccion" datasource="#Session.DSN#">
	select #LVRHTid# as RHTid,
		  {fn concat(RHTcodigo ,{fn concat(' - ',RHTdesc)})} as Descripcion
	from RHTipoAccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Descripcion
</cfquery>

<table width="95%" border="0" cellspacing="3" cellpadding="0" align="center">
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
				<td colspan="4" width="49%" align="left" style="font-weight: bold; border-bottom: 1px solid gray;" ><cf_translate key="FechaAplicacion">Fecha de Aplicaci&oacute;n</cf_translate></td>
				<td width="1%">&nbsp;</td>
				<td colspan="4" width="49%" align="left" style="font-weight: bold; border-bottom: 1px solid gray;"><cf_translate key="FechaVigencia">Fecha de Vigencia</cf_translate></td>
			  </tr>

			  <tr>
				<td align="right" style="padding-top: 5px;" nowrap="nowrap"><cf_translate key="DesdeExp">Desde</cf_translate>:</td>
				<td style="padding-left: 5px; padding-top: 5px;">
					<cfif isdefined("Form.fAplicacion1")>
						<cfset aplicacion1 = Form.fAplicacion1>
					<cfelse>
						<cfset aplicacion1 = "">
					</cfif>
					<cf_sifcalendario name="fAplicacion1" value="#aplicacion1#" form="filtroLaborales">
				</td>
				<td align="right" style="padding-top: 5px;" nowrap="nowrap"><cf_translate key="HastaExp">Hasta</cf_translate>:</td>
				<td style="padding-left: 5px; padding-top: 5px;">
					<cfif isdefined("Form.fAplicacion2")>
						<cfset aplicacion2 = Form.fAplicacion2>
					<cfelse>
						<cfset aplicacion2 = "">
					</cfif>
					<cf_sifcalendario name="fAplicacion2" value="#aplicacion2#" form="filtroLaborales">
				</td>
				<td width="1%">&nbsp;</td>
				<td align="right" style="padding-top: 5px;" nowrap="nowrap"><cf_translate key="FEcIniExp">Desde</cf_translate>:</td>
				<td style="padding-left: 5px; padding-top: 5px;">
					<cfif isdefined("Form.fVigencia1")>
						<cfset vigencia1 = Form.fVigencia1>
					<cfelse>
						<cfset vigencia1 = "">
					</cfif>
					<cf_sifcalendario name="fVigencia1" value="#vigencia1#" form="filtroLaborales">
				</td>
				<td align="right" style="padding-top: 5px;" nowrap="nowrap"><cf_translate key="HastaExp">Hasta</cf_translate>:</td>
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
				<td valign="middle" nowrap="nowrap"   ><cf_translate key="Acciones">Acci&oacute;n</cf_translate>:&nbsp;</td>
				<td style="padding-top: 5px;" colspan="3" valign="middle" >
					<select name="selAccion" style="width:175px;">
						<option value=""><cf_translate key="LB_Todas">(Todas)</cf_translate></option>
						<cfloop query="rsTipoAccion">
							<option value="#rsTipoAccion.RHTid#" <cfif isdefined("Form.selAccion") and Form.selAccion EQ rsTipoAccion.RHTid>selected</cfif>>#rsTipoAccion.Descripcion#</option>
						</cfloop>
					</select>
				</td>
				<td width="1%">&nbsp;</td>
				<td  nowrap="nowrap"  ><cf_translate key="Comportamiento">Comportamiento</cf_translate>:&nbsp;</td>
				<td style="padding-top: 5px;" colspan="3">
					<select name="selComportamiento">
						<option value=""><cf_translate key="LB_Todas">(Todas)</cf_translate></option>
						<option value="1" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "1">selected</cfif>><cf_translate  key="LB_Nombramiento">Nombramiento</cf_translate></option>
						<option value="2" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "2">selected</cfif>><cf_translate  key="LB_Cese">Cese</cf_translate></option>
						<option value="3" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "3">selected</cfif>><cf_translate  key="LB_Vacaciones">Vacaciones</cf_translate></option>
						<option value="4" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "4">selected</cfif>><cf_translate  key="LB_Permiso">Permiso</cf_translate></option>
						<option value="5" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "5">selected</cfif>><cf_translate  key="LB_Incapacidad">Incapacidad</cf_translate></option>
						<option value="6" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "6">selected</cfif>><cf_translate  key="LB_Cambio">Cambio</cf_translate></option>
						<option value="7" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "7">selected</cfif>><cf_translate  key="LB_Anulacion">Anulación</cf_translate></option>
						
						<option value="10" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "10">selected</cfif>><cf_translate  key="LB_Anotacion">Anotación</cf_translate></option>
						<option value="11" <cfif isdefined("Form.selComportamiento") and Form.selComportamiento EQ "11">selected</cfif>><cf_translate  key="LB_Antiguedad">Antigüedad</cf_translate></option>
						
					</select>
				</td>

			  </tr>
			  
			  
			  <tr>
				  <cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Filtrar"
					Default="Filtrar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Filtrar"/>
				<td colspan="10" align="center"><input type="submit" class="btnFiltrar" name="btnBuscar" value="#BTN_Filtrar#"></td>
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
				<option value="5" <cfif Trim(ViewMode) EQ "5">selected</cfif>><cf_translate key="LB_VerDe5en5">Ver de 5 en 5</cf_translate></option>
				<option value="0" <cfif Trim(ViewMode) EQ "0">selected</cfif>><cf_translate key="LB_VerTodos">Ver Todas</cf_translate></option>
			</select>
		</form>
	</td>
  </tr>
  <tr>
	<td>
		<cfif cantRegistros GT 0>
			<cfoutput>#listaAcciones#</cfoutput>
		<cfelse>
			<cf_translate key="NoSeEncontraronAccionesConElCriterioEscogidoOElEmpleadoNoTieneAccionesAsociadasActualmente" >No se encontraron acciones con el criterio escogido o El empleado no tiene acciones asociadas actualmente</cf_translate>
		</cfif> 
	</td>
  </tr>
</table>

<!---
<cfquery name="rsLaboral" datasource="#Session.DSN#">
	select convert(varchar, a.DLlinea) as DLlinea, 
		   a.DLconsecutivo, 
		   convert(varchar, a.DEid) as DEid, 
		   convert(varchar, a.RHTid) as RHTid, 
		   convert(varchar, a.Ecodigo) as Ecodigo, 
		   convert(varchar, a.Dcodigo) as Dcodigo, 
		   convert(varchar, a.Ocodigo) as Ocodigo, 
		   convert(varchar, a.RHPid) as RHPid, 
		   rtrim(a.RHPcodigo) as RHPcodigo, 
		   rtrim(a.Tcodigo) as Tcodigo, 
		   convert(varchar, a.DLfvigencia, 103) as Vigencia,
		   convert(varchar, a.DLffin, 103) as Finalizacion,
		   a.DLsalario, 
		   a.DLobs, 
		   convert(varchar, a.DLfechaaplic, 103) as FechaAplicacion,
		   rtrim(b.RHTcodigo) as RHTcodigo,
		   b.RHTdesc,
		   case b.RHTcomportam 
		        when 1 then 'Nombramiento' 
				when 2 then 'Cese'
				when 3 then 'Vacaciones'
				when 4 then 'Permiso'
				when 5 then 'Incapacidad'
				when 6 then 'Cambio'
				when 7 then 'Anulación'
				else ''
		   end as Comportamiento,
		   c.RHPdescripcion
	from DLaboralesEmpleado a, RHTipoAccion b, RHPlazas c
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	and a.RHTid = b.RHTid
	and a.Ecodigo = b.Ecodigo
	and a.RHPid = c.RHPid
	order by a.DLfechaaplic, a.DLfvigencia, a.DLffin, a.DLconsecutivo
</cfquery>
<cfif rsLaboral.recordCount GT 0>
 	<cfoutput>
		<script type="text/javascript" language="JavaScript">
			function showDetalleAccion(accion) {
				document.listaAcciones.DLlinea.value = accion;
				document.listaAcciones.submit();
			}
		</script>
		<form name="listaAcciones" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0">
			<input type="hidden" name="DLlinea" value="">
		<cfif isdefined("Form.o")>
			<input type="hidden" name="o" value="#Form.o#">
		</cfif>
		<cfif isdefined("Form.sel")>
			<input type="hidden" name="sel" value="#Form.sel#">
		</cfif>
		<cfif isdefined("Form.DEid")>
			<input type="hidden" name="DEid" value="#Form.DEid#">
		</cfif>
		<input type="hidden" name="Regresar" value="#GetFileFromPath(GetTemplatePath())#">
		<table width="100%" cellpadding="2" cellspacing="0">
		<tr> 
		  <td class="listTitle" align="center" nowrap>Aplicaci&oacute;n</td>
		  <td class="listTitle" nowrap>Acci&oacute;n</td>
		  <td class="listTitle" align="center" nowrap>Vigencia</td>
		  <td class="listTitle" align="center" nowrap>Finalizacion</td>
		  <td class="listTitle" nowrap>Plaza</td>
		  <td class="listTitle" align="right" nowrap>Salario</td>
		</tr>
		<cfloop query="rsLaboral">
			<cfif (currentRow Mod 2) eq 1>
				<cfset color = "Non">
			<cfelse>
				<cfset color = "Par">
			</cfif>
			<tr onClick="javascript: showDetalleAccion('#DLlinea#');" style="cursor: pointer;" onMouseOver="javascript: style.color = 'red'" onMouseOut="javascript: style.color = 'black'">
			  <td class="listLeftContent#color#" align="center" nowrap><cfif FechaAplicacion NEQ "">#FechaAplicacion#<cfelse>&nbsp;</cfif></td>
			  <td class="listCenterContent#color#" nowrap>#RHTcodigo# - #RHTdesc#</td>
			  <td class="listCenterContent#color#" align="center" nowrap><cfif Vigencia NEQ "">#Vigencia#<cfelse>&nbsp;</cfif></td>
			  <td class="listCenterContent#color#" align="center" nowrap><cfif Finalizacion NEQ "">#Finalizacion#<cfelse>INDEFINIDO</cfif></td>
			  <td class="listCenterContent#color# nowrap">#RHPdescripcion#</td>
			  <td class="listRightContent#color#" align="right" nowrap>#LSCurrencyFormat(DLsalario, 'none')#</td>
			</tr>
		</cfloop>
		</table>
		</form>
	</cfoutput>
<cfelse> 
	El empleado no tiene acciones asociadas actualmente
</cfif>
--->