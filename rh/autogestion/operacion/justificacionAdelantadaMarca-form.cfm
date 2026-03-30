

<cfif isdefined("url.RHJMUfecha") and len(trim(url.RHJMUfecha))NEQ 0>
	<cfset form.RHJMUfecha = url.RHJMUfecha>
</cfif> 

<cfif isdefined("url.RHJMUjustificacion") and len(trim(url.RHJMUjustificacion))NEQ 0>
	<cfset form.RHJMUjustificacion = url.RHJMUjustificacion>
</cfif>  

<cfif isdefined("url.RHIid") and len(trim(url.RHIid))NEQ 0>
	<cfset form.RHIid = url.RHIid>
</cfif>  

<cfif isdefined("url.RHJMUid") and len(trim(url.RHJMUid))>
	<cfset form.RHJMUid = url.RHJMUid >
</cfif>

<cfif isdefined("form.RHJMUid")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset UsuDEid = sec.getUsuarioByCod (session.Usucodigo, session.EcodigoSDC, 'DatosEmpleado')>
	
	<cfif len(trim(UsuDEid.llave)) neq 0>				
		<cfquery name="rsForm" datasource="#session.DSN#">
			select * from RHJustificacionMarcasUsuario 
			where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#UsuDEid.llave#">
				and RHJMUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJMUid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and RHJMUprocesada =0
		</cfquery>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElUsuarioQueAccesoLaAplicacionNoEstaRegistradoComoEmpleadoDeLaEmpresaEnLaCualIngreso-JustificacionesAdelantadas"
			Default="El usuario que accesó la aplicación no esta registrado como empleado de la empresa en la cual ingresó."
			returnvariable="MSG_ElUsuarioQueAccesoLaAplicacionNoEstaRegistradoComoEmpleadoDeLaEmpresaEnLaCualIngreso"/>

		<cf_throw message="#MSG_ElUsuarioQueAccesoLaAplicacionNoEstaRegistradoComoEmpleadoDeLaEmpresaEnLaCualIngreso#." errorcode="5045">
	</cfif> 
</cfif>
			
<form name="form1" action="justificacionAdelantadaMarca-sql.cfm" method="post">
	
	<table width="100%">
		<tr>
			<td nowrap class="fileLabel"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
			<td nowrap>
				<cfif isdefined("rsForm") and rsForm.RecordCount NEQ 0>
					<cfset RHJMUfecha = LSDateFormat(rsForm.RHJMUfecha,'dd/mm/yyyy')>
				<cfelse>
					<cfset RHJMUfecha = ''>
				</cfif>
				<cf_sifcalendario  form="form1" name="RHJMUfecha" value="#RHJMUfecha#" tabindex="1">
			</td>
		</tr>
		<tr>
			<td nowrap class="fileLabel"><cf_translate key="LB_Situacion">Situación</cf_translate></td>
			<td nowrap>
				 <cfinvoke
					Component= "rh.Componentes.RH_inconsistencias"
					method="RHInconsistencias"
					returnvariable="rhIncons">
					<cfif isdefined("rsForm.RHJMUsituacion") and len(trim(rsForm.RHJMUsituacion))neq 0>
						<cfinvokeargument name="RHIid" value="#rsForm.RHJMUsituacion#"/>
					</cfif>
					<cfinvokeargument name="tabindex" value="1"/>	
				</cfinvoke>	
			</td>
		</tr>
		<tr>
			<td nowrap class="fileLabel" valign="top"><cf_translate key="LB_Justificacion">Justificación</cf_translate>:</td>
			<td>
				<textarea name="RHJMUjustificacion" rows="4" cols="50" tabindex="1"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO' tabindex="1">
					<input type="hidden" name="RHJMUid" value="<cfoutput>#form.RHJMUid#</cfoutput>">
				<cfelse>
					<cf_botones modo='ALTA' tabindex="1">
				</cfif>
			</td>
		</tr>
	</table>
</form>
<!--- Variables de Traduccion --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha"
	Default="Fecha"
	returnvariable="MSG_Fecha"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Situacion"
	Default="Situación"
	returnvariable="MSG_Situacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Justificacion"
	Default="Justificación"
	returnvariable="MSG_Justificacion"/>

<cf_qforms>
<script language="javascript" type="text/javascript">
	
	function habilitarValidacion(){
		<cfoutput>
		objForm.RHJMUfecha.required = true;
		objForm.RHJMUfecha.description = "#MSG_Fecha#";
		
		 objForm.RHIid.required = true;
		objForm.RHIid.description = "#MSG_Situacion#";
		
		objForm.RHJMUjustificacion.required = true;
		objForm.RHJMUjustificacion.description = "#MSG_Justificacion#";
		</cfoutput>
	}
	
	function deshabilitarValidacion(){
		objForm.RHJMUfecha.required = false; 
		objForm.RHIid.required = false; 
		objForm.RHJMUjustificacion.required = false;
	}
	
	habilitarValidacion(); 
	
	document.form1.RHJMUjustificacion.value="";
	<cfif modo neq "ALTA" and isdefined("rsForm") and rsForm.RecordCount NEQ 0>
		document.form1.RHJMUjustificacion.value="<cfoutput>#rsForm.RHJMUjustificacion#</cfoutput>";
	</cfif>
	document.form1.RHJMUfecha.focus();	
</script>


