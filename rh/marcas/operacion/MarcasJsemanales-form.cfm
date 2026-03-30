<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfset Form.sel = Url.sel>
</cfif>
<cfif isdefined("Url.RHPMid") and not isdefined("Form.RHPMid")>
	<cfset Form.RHPMid = Url.RHPMid>
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>
<cfif isdefined("Url.fDEnombre") and not isdefined("Form.fDEnombre")>
	<cfset Form.fDEnombre = Url.fDEnombre>
</cfif>
<cfif isdefined("Url.fDEidentificacion") and not isdefined("Form.fDEidentificacion")>
	<cfset Form.fDEidentificacion = Url.fDEidentificacion>
</cfif>
<cfif isdefined("Url.chkInconsistencias") and not isdefined("Form.chkInconsistencias")>
	<cfset Form.chkInconsistencias = Url.chkInconsistencias>
</cfif>

<cfset navegacion = "sel=1">
<cfset filtro = "">

<cfif isdefined("Form.RHPMid") and Len(Trim(Form.RHPMid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPMid=" & Form.RHPMid>
</cfif>
<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.fDEnombre") and Len(Trim(Form.fDEnombre)) NEQ 0>
	<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({ fn concat(a.DEapellido1, ' ') },a.DEapellido2)}, ' ')},a.DEnombre) }) like '%" & UCase(Form.fDEnombre) & "%'">
								<!----and upper((a.DEapellido1 + ' ' + a.DEapellido2 + ', ' + a.DEnombre)) like '%" & UCase(Form.fDEnombre) & "%'">--->
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fDEnombre=" & Form.fDEnombre>
</cfif>
<cfif isdefined("Form.fDEidentificacion") and Len(Trim(Form.fDEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DEidentificacion)  like '%" & UCase(Form.fDEidentificacion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fDEidentificacion=" & Form.fDEidentificacion>
</cfif>
<cfif isdefined("Form.chkInconsistencias") and Len(Trim(Form.chkInconsistencias)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "chkInconsistencias=" & Form.chkInconsistencias>
</cfif>

<!--- <cfdump var="#form#">
<cfabort>  --->
<!----==================== TRADUCCION =======================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"	
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"	
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cantidad_de_Marcas"
	Default="Cantidad de Marcas"	
	returnvariable="LB_Cantidad_de_Marcas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cantidad_de_Inconsistencias"
	Default="Cantidad de Inconsistencias"	
	returnvariable="LB_Cantidad_de_Inconsistencias"/>

<cfif isdefined("Form.RHPMid") and Len(Trim(Form.RHPMid))>

	<script language="javascript" type="text/javascript">
		function showEmployeeList(t) {
			var a = document.getElementById("trEmpleados");
			var b = document.getElementById("letiqueta1");
			var c = document.getElementById("letiqueta2");
			var d = document.getElementById("trMantenimiento");
			if (t) {
				if (a) a.style.display = '';
				if (b) b.style.display = 'none';
				if (c) c.style.display = '';
				if (d) d.style.display = 'none';
			} else {
				if (a) a.style.display = 'none';
				if (b) b.style.display = '';
				if (c) c.style.display = 'none';
				if (d) d.style.display = '';
			}
		}
	</script>

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <cfif isdefined("Form.DEid")>
	  <tr>
		<td valign="middle" align="right">  
		  <label id="letiqueta1"><a href="javascript: showEmployeeList(true);"><cf_translate key="LB_Seleccione_un_empleado">Seleccione un empleado:</cf_translate> <img src="/cfmx/rh/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"></a></label>
		  <label id="letiqueta2"><a href="javascript: showEmployeeList(false);"><cf_translate key="LB_Datos_del_empleado">Datos del empleado:</cf_translate> <img src="/cfmx/rh/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"></a> </label>
		</td>
	  </tr>
	  </cfif>
	  <tr id="trEmpleados" style="display: none; ">
		<td valign="top">
		  	<form name="filtroListaEmp" method="post" action="MarcasJsemanales.cfm" style="margin: 0; ">
				<cfif isdefined("Form.RHPMid") and Len(Trim(Form.RHPMid))>
				  <input type="hidden" name="RHPMid" value="<cfoutput>#Form.RHPMid#</cfoutput>">
				</cfif>
				  <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
					<tr> 
					  <cfoutput>
					  <td nowrap class="fileLabel">#LB_Identificacion#</td>
					  <td nowrap class="fileLabel"><cf_translate key="LB_Nombre_del_empleado">Nombre del empleado</cf_translate></td>
					  <td nowrap class="fileLabel">&nbsp;</td>
					  <td rowspan="2" align="center" nowrap>
						<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
					  </td>
					  </cfoutput>
					</tr>
					<tr> 
					  <td nowrap>
						<input name="fDEidentificacion" type="text" id="fDEidentificacion" size="30" maxlength="60" value="<cfif isdefined('form.fDEidentificacion')><cfoutput>#form.fDEidentificacion#</cfoutput></cfif>">
					  </td>
					  <td nowrap>
						<input name="fDEnombre" type="text" id="fDEnombre" size="60" maxlength="260" value="<cfif isdefined('form.fDEnombre')><cfoutput>#form.fDEnombre#</cfoutput></cfif>">
					  </td>
					  <td nowrap>
					  	<input type="checkbox" name="chkInconsistencias" value="1" <cfif isdefined("Form.chkInconsistencias")> checked</cfif>>
						<cf_translate key="LB_Mostrar_Empleados_con_Inconsistencias">Mostrar Empleados con Inconsistencias</cf_translate>
					  </td>
					</tr>
				  </table>
            </form>
			<cfif isdefined("Form.chkInconsistencias")>
				<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
				  <tr>
					<td align="center">
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaEmpl">
							<cfinvokeargument name="tabla" value="RHProcesamientoMarcas b, RHControlMarcas rm, DatosEmpleado a, RHUsuariosMarcas um"/>
							<cfinvokeargument name="columnas" value="a.DEid, a.DEidentificacion, 
																	{fn concat({fn concat({fn concat({ fn concat(a.DEapellido1, ' ') },a.DEapellido2)}, ' ')}, a.DEnombre) } as nombreEmpl,
																	count(1) as CantMarcas, 
																	sum(case rm.RHCMinconsistencia when 1 then 1 else 0 end) as CantInconsistencias,
																	'#Form.RHPMid#' as RHPMid"/>
							<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl, cantMarcas, cantInconsistencias"/>
							<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Empleado#, #LB_Cantidad_de_Marcas#, #LB_Cantidad_de_Inconsistencias#"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="formName" value="listaEmpleados"/>	
							<cfinvokeargument name="filtro" value=" b.Ecodigo = #Session.Ecodigo# 
																	and b.RHPMid = #Form.RHPMid#
																	and b.RHPMid = rm.RHPMid
																	and b.Ecodigo = a.Ecodigo
																	and rm.DEid = a.DEid
																	and b.Ecodigo = um.Ecodigo
																	and b.CFid = um.CFid
																	and um.Usucodigo = #Session.Usucodigo#
																	and (um.RHUMtmarcas = 1 or um.RHUMgincidencias = 1)
																	and exists (
																		select 1
																		from RHControlMarcas c
																		where c.RHPMid = b.RHPMid
																		and c.DEid = a.DEid
																		and c.RHCMinconsistencia <> 0
																	)
																	#filtro# 
																	group by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre"/>
							<cfinvokeargument name="align" value="left, left, right, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="MarcasJsemanales.cfm"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="keys" value="DEid"/>
							<cfinvokeargument name="PageIndex" value="2"/>
						</cfinvoke>
					</td>
				  </tr>
				</table>
			<cfelse>
				<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
				  <tr>
					<td align="center">
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaEmpl">
							<cfinvokeargument name="tabla" value="RHProcesamientoMarcas b, RHControlMarcas rm, DatosEmpleado a, RHUsuariosMarcas um"/>
							<cfinvokeargument name="columnas" value="a.DEid, a.DEidentificacion,  
																	{fn concat({fn concat({fn concat({ fn concat(a.DEapellido1, ' ') },a.DEapellido2)}, ' ')},a.DEnombre) }  as nombreEmpl,
																	count(1) as CantMarcas, 
																	sum(case rm.RHCMinconsistencia when 1 then 1 else 0 end) as CantInconsistencias,
																	'#Form.RHPMid#' as RHPMid"/>
							<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl, cantMarcas, cantInconsistencias"/>
							<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Empleado#, #LB_Cantidad_de_Marcas#, #LB_Cantidad_de_Inconsistencias#"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="formName" value="listaEmpleados"/>	
							<cfinvokeargument name="filtro" value=" b.Ecodigo = #Session.Ecodigo# 
																	and b.RHPMid = #Form.RHPMid#
																	and b.RHPMid = rm.RHPMid
																	and b.Ecodigo = a.Ecodigo
																	and rm.DEid = a.DEid
																	and b.Ecodigo = um.Ecodigo
																	and b.CFid = um.CFid
																	and um.Usucodigo = #Session.Usucodigo#
																	and (um.RHUMtmarcas = 1 or um.RHUMgincidencias = 1)
																	#filtro# 
																	group by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre"/>
							<cfinvokeargument name="align" value="left, left, right, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="MarcasJsemanales.cfm"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="keys" value="DEid"/>
						</cfinvoke>
					</td>
				  </tr>
				</table>
			</cfif>
		</td>
	  </tr>
	  <cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
	  <tr id="trMantenimiento" style="display: none; ">
		<td valign="top">
			<cfif isdefined("Form.showDetail") and Form.showDetail EQ 1>
				<cfinclude template="MarcasJsemanalesDetalle-form.cfm">
			<cfelse>
				<cfinclude template="MarcasJsemanalesControl-form.cfm">
			</cfif>
		</td>
	  </tr>
	  </cfif>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	</table>
	<script language="javascript" type="text/javascript">
		<cfif isdefined("Form.sel") or (not isdefined("Form.DEid"))>
			showEmployeeList(true);
		<cfelse>
			showEmployeeList(false);
		</cfif>
	</script>

<cfelse>
	<div align="center"><strong><cf_translate key="LB_UstedNoEstaAutorizadoParaIngresarAEstaPantalla">Usted no est&aacute; autorizado para ingresar a esta pantalla</cf_translate></strong></div>
</cfif>
