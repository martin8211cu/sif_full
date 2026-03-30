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


<!--------------------------------->
<cfif not isdefined("form.irAnube")>
    <cf_htmlreportsheaders
                title="#LB_ConsultaTipoDeAccionPorEmpleado#" 
                download="true"
                method="post"
                filename="TipoAccionEmpl#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
                ira="TipoAccionEmpleado.cfm">	
<cfelse>
		
    <cf_htmlreportsheaders
                title="#LB_ConsultaTipoDeAccionPorEmpleado#" 
                download="true"
                method="post"
                filename="TipoAccionEmpl#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
                back="false"
                ira="TipoAccionEmpleado.cfm"
                >			
</cfif>
<!--- Consulta principal --->
<cfquery name="rstipo_accion_empleado" datasource="#session.DSN#">
	select
		{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(',',{fn concat(' ',de.DEnombre)})})})})} as Nombre_Empleado,
		substring({fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(',',{fn concat(' ',de.DEnombre)})})})})},1,45) as nombrecorto,
		de.DEidentificacion,
		a.DLlinea, 
		a.DEid, 
		a.RHTid as TipoAccion,
		e.Tcodigo as CodigoTipoNomina,
		e.Tdescripcion as DescripcionTipoNomina,
		case 
			when b.RHTcomportam = 1 then '#LB_Nombramiento#' 
			when b.RHTcomportam = 2 then '#LB_Cese#'  
			when b.RHTcomportam = 3 then '#LB_Vacaciones#'  
			when b.RHTcomportam = 4 then '#LB_Permiso#'  
			when b.RHTcomportam = 5 then '#LB_Incapacidad#'  
			when b.RHTcomportam = 6 then '#LB_Cambio#'  
			when b.RHTcomportam = 7 then '#LB_Anulacion#'  
			when b.RHTcomportam = 8 then '#LB_Aumento#'  
			when b.RHTcomportam = 9 then '#LB_CambioDeEmpresa#'  
		end as Comportamiento,
		b.RHTcodigo as CodigoAccion,
		b.RHTdesc as Accion,
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
		<cfif isdefined("form.RHTcomportam1") and form.RHTcomportam1 gt 0>
			and b.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHTcomportam1#">
		<cfelse>
			and b.RHTcomportam = b.RHTcomportam
		</cfif>
		<cfif isdefined ("form.CaridList")>
			and b.RHTid in( #form.CaridList#)
		</cfif>
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
	<cfif form.RHTcomportam1 eq 0>
		<cfset comporta = 'Todos'>
	<cfelse>
		<cfset comporta = ' '>
	</cfif>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td>
		<cfif rstipo_accion_empleado.recordCount eq 0>
			<td align="center"><h2><strong><cf_translate key="LB_NoExistenRegistrosParaEstaBusqueda">No existen registros para esta busqueda</cf_translate>.</strong></h2></td>
		<cfelse>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">				
			<tr>
				<td colspan="8">
					<table width="100%" cellpadding="0" cellspacing="0" align="center">
						<tr><td>
							<cfinvoke key="LB_TipoDeAccionPorEmpleado" default="Tipos de Acci&oacute;n por Empleado" returnvariable="LB_TipoDeAccionPorEmpleado" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Desde" default="Desde" returnvariable="LB_Desde" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Hasta" default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Comportamiento" default="Comportamiento" returnvariable="LB_Comportamiento" component="sif.Componentes.Translate"  method="Translate"/>
							<cfset filtro2=''>
							<cfif form.RHTcomportam1 eq 0>					
								<cfset filtro2='#LB_Comportamiento#: #comporta#'>
							<cfelse>
								<cfset filtro2='#LB_Comportamiento#: #rstipo_accion_empleado.Comportamiento#'>
							</cfif>
							<cf_EncReporte
								Titulo="#LB_TipoDeAccionPorEmpleado#"
								Color="##E3EDEF"
								filtro1="#LB_Desde#: #Form.fechaI#  #LB_Hasta#:#Form.fechaF#"	
								filtro2="#filtro2#"								
							>
						</td></tr>
					</table>
				</td>
			</tr>			
				  <tr>
				  	 <td align="center">
						<table width="75%" cellpadding="3" cellspacing="0">
							<tr class="tituloListas">
								<td align="left"><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></td>
								<td align="left"><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
								<td align="left" nowrap><cf_translate key="LB_TipoAccion">Tipo Acci&oacute;n</cf_translate></td>
								<td align="left"><cf_translate key="LB_Accion">Acci&oacute;n</cf_translate></td>
								<td align="left" nowrap><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate></td>
								<td align="left" nowrap><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate></td>
								<td align="left" nowrap><cf_translate key="LB_FechaAplica">Fecha aplica</cf_translate></td>
							</tr>
							<cfset rsResultado = QueryNew("DEid, Nombre_Empleado,TipoAccion,CodigoAccion,CodigoTipoNomina,DescripcionTipoNomina,Comportamiento,Accion,CodigoPuesto,RHPdescpuesto, CodigoPlaza,DescripcionPlaza,Fdesde,Fhasta,Faplica, Observaciones")>
							<cfset arreglo     = ArrayNew(1)>
							<cfset index = 0 >
							<cfset NumEmpleado = 0>
							<cfoutput query="rstipo_accion_empleado">
							<cfset index = index + 1 >
							<tr class="<cfif rstipo_accion_empleado.DEidentificacion NEQ NumEmpleado>listaNon<cfelse>listaPar</cfif>" 
									onClick="javascript:Invocar('#rstipo_accion_empleado.DEid#','#rstipo_accion_empleado.DLlinea#', '#rstipo_accion_empleado.Faplica#', 
											'#rstipo_accion_empleado.Fdesde#', '#rstipo_accion_empleado.Fhasta#');" 
									style="cursor: pointer;"> 
									<cfif rstipo_accion_empleado.DEidentificacion NEQ NumEmpleado>
										<td nowrap align="left" >
											<!---<input name="Ident" id="Ident" type="text" size="12" tabindex="-1" 
												style="text-align: left" value="--->#rstipo_accion_empleado.DEidentificacion#<!---" class="cajasinbordeb" 
												readonly="true">--->
										</td>
										<td nowrap align="left" >
											<!---<input name="Empleado" id="Empleado" type="text" size="40" tabindex="-1" 
											style="text-align: left" value="--->#rstipo_accion_empleado.nombrecorto# <cfif len(#rstipo_accion_empleado.Nombre_Empleado#) GT 45>...</cfif><!---" 												class="cajasinbordeb" title="#rstipo_accion_empleado.Nombre_Empleado#"   readonly="true">--->
										</td>
										<cfset NumEmpleado = rstipo_accion_empleado.DEidentificacion >
									<cfelse>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									</cfif>
								<td nowrap align="left" >#rstipo_accion_empleado.CodigoAccion#</td>
								<td nowrap  align="left">#rstipo_accion_empleado.Accion#</td>
								<td nowrap align="left" >#LsDateFormat(rstipo_accion_empleado.Fdesde,"DD/MM/YYYY")#</td>
								<td nowrap  align="left">#LSDateFormat(rstipo_accion_empleado.Fhasta,"DD/MM/YYYY")#</td>
								<td nowrap align="left" >#LSDateFormat(rstipo_accion_empleado.Faplica,"DD/MM/YYYY")#</td>									
							</tr>
								</cfoutput>
							<cfset arreglo[index] = ArrayNew(1) >
							<cfset arreglo[index][1] = rstipo_accion_empleado.TipoAccion >
							<cfset arreglo[index][5] = rstipo_accion_empleado.Accion >
							<cfset arreglo[index][10] = rstipo_accion_empleado.Fdesde >														
							<cfset arreglo[index][11] = rstipo_accion_empleado.Fhasta >
							<cfset arreglo[index][12] = rstipo_accion_empleado.Faplica >
							<cfif isdefined("Form.DEid") and Form.DEid gt 0 >
							<cfelse>
								<cfset arreglo[index][14] = rstipo_accion_empleado.DEidentificacion >
								<cfset arreglo[index][15] = rstipo_accion_empleado.nombrecorto >
							</cfif>								
						<cfif isdefined('url.imprimir')>
							<tr > 
								<td colspan="12" align="center">
									<strong>
									------------------------------
									<cf_translate key="LB_FinDelReporte">Fin del Reporte</cf_translate>
									--------------------------------------
									</strong>	&nbsp;
								</td>
							</tr>
						<cfelse>
							<tr> 
								<td colspan="12" align="center">
                                <cfif not isdefined("form.irAnube")>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Regresar"
										Default="Regresar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Regresar"/>

									<input type="button" name="Regresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1" onClick="javascript:Lista();">
                                </cfif>
								</td>
							</tr>								
						</cfif>
						</table>
					</td>
				</tr>
			</table>
		</cfif>
		<cfif isdefined("form.irAnube")>
            <cfinvoke component="sif.Componentes.Translate"
                method="Translate"
                Key="BTN_Regresar"
                Default="Regresar"
                XmlFile="/rh/generales.xml"
                returnvariable="BTN_Regresar"/>
			<div style="text-align:center">
            <input type="button" name="Regresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1" onClick="javascript:Lista();">
            </div>
            <BR /><BR /><BR />
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