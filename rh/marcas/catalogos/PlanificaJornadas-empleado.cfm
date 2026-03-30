<!-- Establecimiento del modo -->
<cfif isdefined("Form.RHPJid")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<!--- Verificacion de si el usuario actual tiene derechos para planificar jornadas --->
<cfquery name="rsPermisoPlanificar" datasource="#Session.DSN#">
	select 1
	from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHUsuariosMarcas um
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Ecodigo = lt.Ecodigo
	and a.DEid = lt.DEid
	and getDate() between lt.LTdesde and lt.LThasta
	and lt.Ecodigo = r.Ecodigo
	and lt.RHPid = r.RHPid
	and r.Ecodigo = um.Ecodigo
	and r.CFid = um.CFid
	and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and um.RHUMpjornadas = 1
</cfquery>

<cfif rsPermisoPlanificar.recordCount GT 0>
	<cfparam name="Url.fRHJdescripcion" default="">
	<cfparam name="Url.fRHPJfinicio" default="">
	
	<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
		<cfset Form.DEid = Url.DEid>
	</cfif>
	<cfif isdefined("Url.fRHJdescripcion") and not isdefined("Form.fRHJdescripcion")>
		<cfset Form.fRHJdescripcion = Url.fRHJdescripcion>
	</cfif>
	<cfif isdefined("Url.fRHPJfinicio") and not isdefined("Form.fRHPJfinicio")>
		<cfset Form.fRHPJfinicio = Url.fRHPJfinicio>
	</cfif>
	
	<cfset filtro = "">
	<cfset navegacion = "">
	<cfif isdefined("Form.DEid") and len(trim(Form.DEid)) gt 0 >
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
	</cfif>
	<cfif isdefined("Form.fRHJdescripcion") and len(trim(Form.fRHJdescripcion)) gt 0 >
		<cfset filtro = filtro & " and upper(b.RHJdescripcion) like '%#Ucase(Form.fRHJdescripcion)#%'">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHJdescripcion=" & Form.fRHJdescripcion>
	</cfif>
	<cfif isdefined("Form.fRHPJfinicio") and len(trim(Form.fRHPJfinicio)) gt 0 >
		<cfset filtro = filtro & " and convert(datetime, '#Form.fRHPJfinicio#', 103) between a.RHPJfinicio and a.RHPJffinal">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHPJfinicio=" & Form.fRHPJfinicio>
	</cfif>
	
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, 
			   a.NTIcodigo, 
			   a.DEidentificacion, 
			   a.DEnombre, 
			   a.DEapellido1, 
			   a.DEapellido2, 
			   n.NTIdescripcion,
			   j.RHJdescripcion as Jornada
		from DatosEmpleado a, NTipoIdentificacion n, LineaTiempo lt, RHJornadas j
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.NTIcodigo = n.NTIcodigo
		and a.DEid = lt.DEid
		and a.Ecodigo = lt.Ecodigo
		and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta
		and lt.RHJid = j.RHJid
		and a.Ecodigo = j.Ecodigo
	</cfquery>
	
	<cfquery name="rsJornadas" datasource="#Session.DSN#">
		select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
		from RHJornadas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<!--- Consultas --->
	<cfif modo NEQ "ALTA">
		<!--- Form --->
		<cfquery name="rsForm" datasource="#session.DSN#">
			select RHPJid, DEid, RHJid, RHPJfinicio, RHPJffinal, RHPJusuario, RHPJfregistro, ts_rversion
			from RHPlanificador
			where RHPJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPJid#">
		</cfquery>
	</cfif>
	
	<!--- Javascript --->
	<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
	<script language="JavaScript" type="text/javascript">
		<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	
		function validar(f) {
			return true;
		}
	
		function limpiar() {
			document.filtro.fRHJdescripcion.value = "";
			document.filtro.fRHPJfinicio.value   = "";
			document.filtro.fRHPJffinal.value   = "";
		}
		//-->
	</script>
	<!---=================== TRADUCCION =======================----->
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
		Key="BTN_Limpiar"
		Default="Limpiar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Limpiar"/>
	
	<cfoutput>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">
				<cfinclude template="PlanificaJornadas-empheader.cfm">
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td valign="top" width="60%">
				<form style="margin: 0" name="filtro" method="post" action="PlanificaJornadas.cfm">
					<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
						<input type="hidden" name="DEid" value="<cfoutput>#Form.DEid#</cfoutput>">
					</cfif>
					<table border="0" width="100%" class="areaFiltro">
					  <tr>
						<td nowrap>#LB_Jornada#</td> 
						<td nowrap><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
					  </tr>
					  <tr>
						<td nowrap>
							<input type="text" name="fRHJdescripcion" value="<cfif isdefined("form.fRHJdescripcion") and len(trim(form.fRHJdescripcion)) gt 0 ><cfoutput>#form.fRHJdescripcion#</cfoutput></cfif>" size="30" maxlength="50" onFocus="javascript:this.select();" >
						</td> 
						<td nowrap>
							<cfif isdefined("Form.fRHPJfinicio")>
								<cfset ffinicio = LSDateFormat(Form.fRHPJfinicio, 'dd/mm/yyyy')>
							<cfelse>
								<cfset ffinicio = "">
							</cfif>
							<cf_sifcalendario form="filtro" name="fRHPJfinicio" value="#ffinicio#">
						</td>
						<td nowrap>
							<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
							<input type="button" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript:limpiar();">
						</td>
					  </tr>
					</table>
				  </form>
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="RHPlanificador a, RHJornadas b"/>
					<cfinvokeargument name="columnas" value="a.RHPJid, a.DEid, a.RHJid, a.RHPJfinicio, a.RHPJffinal,{fn concat(b.RHJcodigo,{fn concat(' - ',b.RHJdescripcion)})} as jornada,
															 '#Form.fRHJdescripcion#' as fRHJdescripcion, 
															 '#Form.fRHPJfinicio#' as fRHPJfinicio
															"/>
					<cfinvokeargument name="desplegar" value="jornada, RHPJfinicio, RHPJffinal"/>
					<cfinvokeargument name="etiquetas" value="#LB_Jornada#, #LB_Fecha_Inicio#, #LB_Fecha_Vence#"/>
					<cfinvokeargument name="formatos" value="V, D, D"/>
					<cfinvokeargument name="filtro" value=" a.DEid = #Form.DEid#
															and a.RHJid = b.RHJid
															#filtro#
															order by RHPJffinal desc, RHPJfinicio desc "/>
					<cfinvokeargument name="align" value="left, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="PlanificaJornadas.cfm"/>
					<cfinvokeargument name="keys" value="RHPJid"/>
					<cfinvokeargument name="maxRows" value="15"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="PageIndex" value="3"/>
				</cfinvoke>
			</td>
			<td width="40%" valign="top" align="left">
				<form name="form1" method="post" action="PlanificaJornadas-SQL.cfm" onSubmit="return validar(this);">
					<input type="hidden" name="m" value="3">
				  <cfoutput> 
					<cfif modo EQ "CAMBIO">
						<input type="hidden" name="RHPJid" value="#rsForm.RHPJid#">
					</cfif>
					<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
						<input type="hidden" name="DEid" value="#Form.DEid#">
					</cfif>
					<table width="100%" border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					  </tr>
					  <tr>
						<td align="right" nowrap class="fileLabel">#LB_Jornada#:</td>
						<td nowrap>
							<select name="RHJid">
							<cfloop query="rsJornadas">
								<option value="#RHJid#" <cfif modo EQ 'CAMBIO' and rsJornadas.RHJid EQ rsForm.RHJid> selected</cfif>>#Descripcion#</option>
							</cfloop>
							</select>
						</td>
					  </tr>
					  <tr>
						<td align="right" nowrap class="fileLabel">#LB_Fecha_Inicio#:</td>
						<td nowrap>
							<cfif modo EQ "CAMBIO">
								<cfset finicio = LSDateFormat(rsForm.RHPJfinicio, 'dd/mm/yyyy')>
							<cfelse>
								<cfset finicio = "">
							</cfif>
							<cf_sifcalendario form="form1" name="RHPJfinicio" value="#finicio#">
						</td>
					  </tr>
					  <tr>
						<td align="right" nowrap class="fileLabel">#LB_Fecha_Vence#:</td>
						<td nowrap>
							<cfif modo EQ "CAMBIO">
								<cfset ffinal = LSDateFormat(rsForm.RHPJffinal, 'dd/mm/yyyy')>
							<cfelse>
								<cfset ffinal = "">
							</cfif>
							<cf_sifcalendario form="form1" name="RHPJffinal" value="#ffinal#">
						</td>
					  </tr>
					  <tr>
						<td nowrap>&nbsp;</td>
						<td valign="top" nowrap>&nbsp;</td>
					  </tr>
					  <tr>
						<td colspan="2" align="center" nowrap>
							<cfinclude template="/rh/portlets/pBotones.cfm">
						</td>
					  </tr>
					  <cfset ts = "">
					  <cfif modo neq "ALTA">
						<cfinvoke 
							component="sif.Componentes.DButils"
							method="toTimeStamp"
							returnvariable="ts">
						  <cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
						</cfinvoke>
					  </cfif>
					  <tr>
						<td colspan="2" nowrap>
							<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">&nbsp;
						</td>
					  </tr>
					</table>
				  </cfoutput>
				</form>
			</td>
		</tr>
	</table>
	</cfoutput>
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
	</script>

<cfelse>
	<div align="center"><strong><cf_translate key="LB_Usted_no_esta_autorizado_para_ingresar_a_esta_pantalla">Usted no est&aacute; autorizado para ingresar a esta pantalla</cf_translate></strong></div>
</cfif>