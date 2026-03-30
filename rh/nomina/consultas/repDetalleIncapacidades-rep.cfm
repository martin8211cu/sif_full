<!---<cf_dump var = "#form#">--->
<!--- Navegacion de la lista --->
<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = Url.DEid>
</cfif>
<cfif isdefined("url.RHTcomportam1") and not isdefined("form.RHTcomportam1")>
	<cfset form.RHTcomportam1 = Url.RHTcomportam1>
</cfif>
	<cfparam name="form.RHTcomportam1" default="0">

<cfif isdefined("url.fechaI") and not isdefined("form.fechaI")>
	<cfset form.fechaI = Url.fechaI>
</cfif>
<cfif isdefined("url.fechaF") and not isdefined("form.fechaF")>
	<cfset form.fechaF = Url.fechaF>
</cfif>

<cfif isdefined("url.DEidentificacion") and not isdefined("form.DEidentificacion")>
	<cfset form.DEidentificacion = Url.DEidentificacion>
</cfif>

<cfif isdefined ('url.CaridList') and not isdefined("form.CaridList")>
	<cfset form.CaridList = Url.CaridList>
</cfif>

<!--- Variables para traduccion --->

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
	Default="Anulaci&oacute;n"
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
					Key="LB_IncapacidadPorEmpleado"
					Default="Reporte de Incapacidades"
					returnvariable="LB_IncapacidadPorEmpleado"/>

<!--------------------------------->	
    <cf_htmlreportsheaders
                title="#LB_IncapacidadPorEmpleado#" 
                download="true"
                method="post"
                filename="IncapacidadEmpl#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
                back="true"
                ira="repDetalleIncapacidades.cfm"
                >			
<!--- Consulta principal --->
<cfquery name="rsIncapEmpleado" datasource="#session.DSN#">
	select
		{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(',',{fn concat(' ',de.DEnombre)})})})})} as Nombre_Empleado,
		substring({fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(',',{fn concat(' ',de.DEnombre)})})})})},1,45) as nombrecorto,
		de.DEidentificacion,
		a.DLlinea, 
		a.DEid, 
		a.RHTid as TipoAccion,
		e.Tcodigo as CodigoTipoNomina,
		e.Tdescripcion as DescripcionTipoNomina,
		b.RHTcodigo as CodigoAccion,
		b.RHTdesc as Accion,
        a.RHfolio as Folio,
        a.RHItiporiesgo as TipoRiesgo,
        a.RHIconsecuencia as Consecuencia,
        a.RHIcontrolincapacidad as ControlIncapacidad,
		coalesce(ltrim(rtrim(c.RHPcodigoext)),ltrim(rtrim(c.RHPcodigo))) as CodigoPuesto,
		c.RHPdescpuesto, 
		d.RHPcodigo as CodigoPlaza,
		d.RHPdescripcion as DescripcionPlaza,
		a.DLfvigencia as Fdesde,
		a.DLffin as Fhasta,
		a.DLfechaaplic as Faplica,
		a.DLobs as Observaciones
	from DatosEmpleado de, DLaboralesEmpleado a, RHTipoAccion b, RHPuestos c, RHPlazas d, TiposNomina e
	where a.Ecodigo =   <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">   
		<cfif isdefined("Form.DEid") and Form.DEid gt 0>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		<cfelse>
			and a.DEid = a.DEid
		</cfif>		
			and b.RHTcomportam = 5
			and b.RHTcomportam = b.RHTcomportam
		and a.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaI)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaF)#"><!---@fdesde and @fhasta--->
		and a.DEid = de.DEid
		and a.RHTid = b.RHTid
		and a.Ecodigo = b.Ecodigo
		and a.Ecodigo = c.Ecodigo
		and a.RHPcodigo = c.RHPcodigo
		and a.RHPid = d.RHPid
		and a.Tcodigo = e.Tcodigo
		and a.Ecodigo = e.Ecodigo
	order by de.DEidentificacion, Nombre_Empleado, a.DLfvigencia, b.RHTcodigo, b.RHTcomportam
</cfquery>
<!---<cf_dump var="#rstipo_accion_empleado#">--->

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>



<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function Lista() {
		history.back();
	}
	//-->
</SCRIPT>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td>
		<cfif rsIncapEmpleado.recordCount eq 0>
			<td align="center"><h2><strong><cf_translate key="LB_NoExistenRegistrosParaEstaBusqueda">No existen registros para esta busqueda</cf_translate>.</strong></h2></td>
		<cfelse>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">				
			<tr>
				<td colspan="8">
					<table width="100%" cellpadding="0" cellspacing="0" align="center">
						<tr><td>
							<cfinvoke key="LB_IncapacidadPorEmpleado" default="Reporte de Incapacidades" returnvariable="LB_IncapacidadPorEmpleado" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Desde" default="Desde" returnvariable="LB_Desde" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Hasta" default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Comportamiento" default="Comportamiento" returnvariable="LB_Comportamiento" component="sif.Componentes.Translate"  method="Translate"/>
							<cf_EncReporte
								Titulo="#LB_IncapacidadPorEmpleado#"
								Color="##E3EDEF"
								filtro1="#LB_Desde#: #Form.fechaI#  #LB_Hasta#:#Form.fechaF#"
								>
						</td></tr>
					</table>
				</td>
			</tr>			
				  <tr>
				  	 <td align="center">
						<table width="100%" cellpadding="3" cellspacing="0" border="1">
							<tr class="tituloListas">
								<td align="left"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
								<td align="left"><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
								<!---<td align="center" nowrap><cf_translate key="LB_TipoAccion">Tipo Acci&oacute;n</cf_translate></td>--->
								<td align="left"><cf_translate key="LB_Accion">Acci&oacute;n</cf_translate></td>
                                <td align="left"><cf_translate key="LB_Folio">Folio</cf_translate></td>
                                <td align="left" nowrap><cf_translate key="LB_TipoRiesgo">Tipo Riesgo</cf_translate></td>
                                <td align="left" nowrap><cf_translate key="LB_Consecuencia">Consecuencia</cf_translate></td>
                                <td align="left" nowrap><cf_translate key="LB_ControlIncapacidad">Control Incapacidad</cf_translate></td>
								<td align="left" nowrap><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate></td>
								<td align="left" nowrap><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate></td>
                                <td align="left" nowrap><cf_translate key="LB_Dias">Dias</cf_translate></td>
								<td align="left" nowrap><cf_translate key="LB_FechaAplica">Fecha Aplicaci&oacute;n</cf_translate></td>
							</tr>
                            <cfloop query="rsIncapEmpleado">
                            <cfoutput>
                            	<cfquery name="rsTipoRiesgo" datasource="sifcontrol">
                                	select RHIdescripcion from RHItiporiesgo
									where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsIncapEmpleado.TipoRiesgo#">  
                                </cfquery>
                                
                                <cfquery name="rsConsecuencia" datasource="sifcontrol">
                                	select RHIdescripcion from RHIconsecuencia
									where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsIncapEmpleado.Consecuencia#">  
                                </cfquery>
                                
                                <cfquery name="rsControlIncapacidad" datasource="sifcontrol">
                                	select RHIdescripcion from RHIcontrolincapacidad
									where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsIncapEmpleado.ControlIncapacidad#">  
                                </cfquery>

                            <tr class="tituloListas">
								<td align="left" nowrap>#rsIncapEmpleado.DEidentificacion#</td>
								<td align="left" nowrap>#rsIncapEmpleado.Nombre_Empleado#</td>
								<!---<td align="center" nowrap><cf_translate key="LB_TipoAccion">Tipo Acci&oacute;n</cf_translate></td>--->
								<td align="left" nowrap>#rsIncapEmpleado.Accion#</td>
                                <td align="left" nowrap>#rsIncapEmpleado.Folio#</td>
                                <td align="left" nowrap>#rsTipoRiesgo.RHIdescripcion#</td>
                                <td align="left" nowrap>#rsConsecuencia.RHIdescripcion#</td>
                                <td align="left" nowrap>#rsControlIncapacidad.RHIdescripcion#</td>
								<td align="left" nowrap>#LSDateFormat(rsIncapEmpleado.Fdesde,'dd/mm/yyyy')#</td>
								<td align="left" nowrap>#LSDateFormat(rsIncapEmpleado.Fhasta,'dd/mm/yyyy')#</td>
                                <td align="left" nowrap>#(DateDiff('d',rsIncapEmpleado.Fdesde,rsIncapEmpleado.Fhasta))+1#</td>
								<td align="left" nowrap>#LSDateFormat(rsIncapEmpleado.Faplica,'dd/mm/yyyy')#</td>
							</tr>
                            </cfoutput>
                            </cfloop>	
						</table>
					</td>
				</tr>
			</table>
		</cfif>
	  </td>
	</tr>
</table>


<cfoutput>
<script language="javascript1.2" type="text/javascript">
	function Invocar(empleado, linea) {
		document.location.href='/cfmx/rh/expediente/consultas/TipoAccionEmpleado-detalleAccion.cfm?DLlinea=' + linea + '&DEid=' + empleado;
	}
</script>
</cfoutput>