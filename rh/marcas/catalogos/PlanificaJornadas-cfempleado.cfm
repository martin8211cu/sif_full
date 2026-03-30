<cfset modo = "ALTA">

<cfquery name="rsJornadas" datasource="#Session.DSN#">
	select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsCentro" datasource="#Session.DSN#">
	select CFdescripcion 
	from CFuncional 
	where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#"> 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
</cfquery>

<!--- Javascript --->
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<!--Cargar datos recibidos de la navegacion---->
<cfif isdefined("url.f_identificacion") and not isdefined("form.f_identificacion") >
	<cfset form.f_identificacion = url.f_identificacion >
</cfif>
<cfif isdefined("url.f_nombre") and not isdefined("form.f_nombre") >
	<cfset form.f_nombre = url.f_nombre >
</cfif>
<!---Cargar la navegacion--->
<cfset navegacion = "">
<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
	<cfset navegacion = navegacion & "&f_identificacion=#form.f_identificacion#">
</cfif>
<cfif isdefined("form.f_nombre") and len(trim(form.f_nombre)) >
	<cfset navegacion = navegacion & "&f_nombre=#form.f_nombre#">
</cfif>
			
<!----=================== TRADUCCION ======================--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jornada"
	Default="Jornada"	
	returnvariable="LB_Jornada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_Inicio"
	Default="Fecha Inicio"	
	returnvariable="LB_Fecha_Inicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_Vence"
	Default="Fecha Vence"	
	returnvariable="LB_Fecha_Vence"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"	
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre_del_empleado"
	Default="Nombre del empleado"	
	returnvariable="LB_Nombre_del_empleado"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jornada_Ordinaria"
	Default="Jornada Ordinaria"	
	returnvariable="LB_Jornada_Ordinaria"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Regresar"
	Default="Regresar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Regresar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Debe_seleccionar_un_empleado_al_menos"
	Default="Debe seleccionar un empleado al menos"	
	returnvariable="LB_Debe_seleccionar_un_empleado_al_menos"/>		
	

<form name="form1" method="post" action="PlanificaJornadas-SQL.cfm" onSubmit="return validar(this);">
<input type="hidden" name="m" value="2">
<cfoutput>
<cfif isdefined("Form.CFid")>
	<input name="CFid" type="hidden" value="#Form.CFid#">
</cfif>
</cfoutput>
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td colspan="2"><strong  style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate>: &nbsp; <cfoutput>#rsCentro.CFdescripcion#</cfoutput></strong></td>
	</tr>
	<tr>
		<td colspan="2" class="tituloListas" style=" border-bottom: 1px solid black;"><cf_translate key="LB_Seleccione_los_empleados_a_los_cuales_desea_agregar_un_cambio_de_jornada_por_un_periodo_de_tiempo">Seleccione los empleados a los cuales desea agregar un cambio de jornada por un periodo de tiempo</cf_translate></strong></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td valign="top" width="60%">
			<table width="100%" cellpadding="0" cellspacing="0">
				<cfoutput>
				<tr>
					<td width="7%">&nbsp;</td>
					<td width="22%" ><strong>#LB_Identificacion#&nbsp;</strong></td>
					<td width="50%" ><strong><cf_translate key="LB_Nombre">Nombre</cf_translate>&nbsp;</strong></td>
					<td width="21%" rowspan="2">
						<input type="button" name="btn_filtrar" value="#BTN_Filtrar#" onClick="javascript: funcFiltrar();">
					</td>
				</tr>
				</cfoutput>
				<tr>
					<td>&nbsp;</td>
					<cfoutput>
					<td><input type="text" name="f_identificacion" value="<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion))>#form.f_identificacion#</cfif>" size="15"></td>
					<td><input type="text" name="f_nombre" value="<cfif isdefined("form.f_nombre") and len(trim(form.f_nombre))>#form.f_nombre#</cfif>" size="35"></td>
					</cfoutput>
				</tr>
				<tr>
					<td valign="top" colspan="4">
						<cfset vs_filtro = ''>
						<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion))>
							<cfset vs_filtro = vs_filtro & " and upper(de.DEidentificacion) like '%" & UCase(form.f_identificacion) & "%'">							
						</cfif>
						<cfif isdefined("form.f_nombre") and len(trim(form.f_nombre))>
							<cfset vs_filtro = vs_filtro & " and upper({fn concat({fn concat({fn concat({ fn concat(de.DEnombre, ' ') },de.DEapellido1)}, ' ')},de.DEapellido2)}) like '%" & UCase(form.f_nombre) & "%'">							
						</cfif>		
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="RHUsuariosMarcas um, CFuncional cf, RHPlazas p, LineaTiempo lt, DatosEmpleado de, RHJornadas j"/>
							<cfinvokeargument name="columnas" value="de.DEid, de.DEidentificacion, 
																	rtrim({fn concat({fn concat({fn concat({ fn concat(de.DEapellido1, ' ') },de.DEapellido2)}, ' ,')},de.DEnombre ) }) as NombreCompleto,																	
																	j.RHJdescripcion as Jornada"/>
							<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto, Jornada"/>
							<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre_del_empleado#, #LB_Jornada_Ordinaria#"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="filtro" value=" um.Usucodigo = #Session.Usucodigo#
																	and um.RHUMpjornadas = 1
																	and um.CFid = #Form.CFid#
																	and um.CFid = cf.CFid
																	and cf.Ecodigo = p.Ecodigo
																	and cf.CFid = p.CFid
																	and p.Ecodigo = lt.Ecodigo
																	and p.RHPid = lt.RHPid
																	and #Now()# between lt.LTdesde and lt.LThasta
																	and lt.DEid = de.DEid
																	and lt.Ecodigo = de.Ecodigo
																	and lt.Ecodigo = j.Ecodigo
																	and lt.RHJid = j.RHJid
																	#vs_filtro#
																	order by de.DEidentificacion, de.DEapellido1, de.DEapellido2, de.DEnombre
																	"/>
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="S"/>
							<cfinvokeargument name="irA" value="PlanificaJornadas.cfm"/>
							<cfinvokeargument name="formName" value="form1"/>
							<cfinvokeargument name="keys" value="DEid"/>
							<cfinvokeargument name="maxRows" value="20"/>
							<cfinvokeargument name="incluyeForm" value="false"/>
							<!---<cfinvokeargument name="navegacion" value="CFid=#Form.CFid#"/>---->
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="PageIndex" value="2"/>
							<cfinvokeargument name="showEmptyListMsg" value="yes"/>
						</cfinvoke>
					</td>
				</tr>
			</table>
		</td>
		<td width="40%" valign="top" align="left">
			  <cfoutput> 
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td align="right" nowrap class="fileLabel">#LB_Jornada#:</td>
					<td nowrap>
						<select name="RHJid">
						<cfloop query="rsJornadas">
							<option value="#RHJid#">#Descripcion#</option>
						</cfloop>
						</select>
					</td>
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">#LB_Fecha_Inicio#:</td>
					<td nowrap>
						<cf_sifcalendario form="form1" name="RHPJfinicio">
					</td>
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">#LB_Fecha_Vence#:</td>
					<td nowrap>
						<cf_sifcalendario form="form1" name="RHPJffinal">
					</td>
				  </tr>
				  <tr>
					<td nowrap>&nbsp;</td>
					<td valign="top" nowrap>&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="2" align="center" nowrap>
						<cfinclude template="/rh/portlets/pBotones.cfm">&nbsp;
						<input type="button" name="btn_regresa" value="#BTN_Regresar#" onClick="javascript: funcRegresar();">
					</td>
				  </tr>
				</table>
			  </cfoutput>
		</td>
	</tr>
	<tr>
	  <td colspan="2" valign="top">&nbsp;</td>
    </tr>
</table>
</form>

<script language="JavaScript1.2" type="text/javascript">

	function habilitarValidacion() {
		objForm.RHJid.required = true;
		objForm.RHPJfinicio.required = true;
		objForm.RHPJffinal.required = true;
	}
	
	function deshabilitarValidacion() {
		objForm.RHJid.required = false;
		objForm.RHPJfinicio.required = false;
		objForm.RHPJffinal.required = false;
	}

	function validar(f) {
		<cfoutput>
		if (f.obj.chk.value) {
			if (!f.obj.chk.checked) {				
				alert('#LB_Debe_seleccionar_un_empleado_al_menos#');
				return false;
			}
		} else {
			for (var i=0; i<f.obj.chk.length; i++) {
				if (f.obj.chk[i].checked) {
					return true;
				}
			}
			alert('#LB_Debe_seleccionar_un_empleado_al_menos#');
			return false;
		}
		</cfoutput>
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfoutput>
		objForm.RHJid.required = true;
		objForm.RHJid.description = "#LB_Jornada#";
		objForm.RHPJfinicio.required = true;
		objForm.RHPJfinicio.description = "#LB_Fecha_Inicio#";
		objForm.RHPJffinal.required = true;
		objForm.RHPJffinal.description = "#LB_Fecha_Vence#";
	</cfoutput>
	
	function funcFiltrar(){
		document.form1.action = 'PlanificaJornadas.cfm?opcion=VE&CFid='+<cfoutput>#form.CFid#</cfoutput>; 
		document.form1.submit();
	}
	
	function funcRegresar(){
		<cfset form.CFid = ''>;
		document.form1.action = 'PlanificaJornadas.cfm?CFid=&DEid=&opcion=VF'; 
		document.form1.submit();	
	}
</script>

