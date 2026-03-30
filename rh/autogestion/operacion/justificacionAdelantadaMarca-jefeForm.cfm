
<!---
<cfdump var="#form#">
<cfdump var="#url#">  
<cfabort> --->

<cfif isdefined("url.RHJMUid") and len(trim(url.RHJMUid))>
	<cfset form.RHJMUid = url.RHJMUid >
</cfif>

<cfif isdefined("url.DEid") and len(trim(url.DEid))NEQ 0>
	<cfset form.DEid = url.DEid>
</cfif> 

<cfif isdefined("url.RHJMUfecha") and len(trim(url.RHJMUfecha))NEQ 0>
	<cfset form.RHJMUfecha = url.RHJMUfecha>
</cfif> 

<cfif isdefined("url.RHJMUjustificacion") and len(trim(url.RHJMUjustificacion))NEQ 0>
	<cfset form.RHJMUjustificacion = url.RHJMUjustificacion>
</cfif>  

<cfif isdefined("url.RHIid") and len(trim(url.RHIid))NEQ 0>
	<cfset form.RHIid = url.RHIid>
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
	<cfquery name="rsForm" datasource="#session.DSN#">
		select * from RHJustificacionMarcasUsuario 
		where  
			RHJMUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJMUid#">
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and RHJMUprocesada =0
	</cfquery>

</cfif>
			
<form name="form1" action="justificacionAdelantadaMarca-jefeSql.cfm" method="post">
	
	<table width="100%"  ><!--- border="0" cellspacing="0" cellpadding="0" --->
		
		<tr>
			<td nowrap class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
		</tr>
		<tr>
			<td nowrap>
				<cfif isdefined("rsForm") and rsForm.RecordCount NEQ 0>
					<cf_rhempleado tabindex="1" size = "13" index="1" idempleado="#rsForm.DEid#">
				<cfelse>
					<cf_rhempleado tabindex="1" size = "13" index="1">
				</cfif>			</td>
		</tr>
		<tr>
			<td nowrap class="fileLabel"><cf_translate key="LB_Fecha">Fecha</cf_translate>:</td>
		</tr>
		<tr>
			<td nowrap>
				<cfif isdefined("rsForm") and rsForm.RecordCount NEQ 0>
					<cfset RHJMUfecha = LSDateFormat(rsForm.RHJMUfecha,'dd/mm/yyyy')>
				<cfelse>
					<cfset RHJMUfecha = ''>
				</cfif>
				<cf_sifcalendario  form="form1" name="RHJMUfecha" value="#RHJMUfecha#" tabindex="1">			</td>
		</tr>
		<td nowrap class="fileLabel"><cf_translate key="LB_Situacion">Situación</cf_translate>:</td>
		<tr>
			<td nowrap>
				 <cfinvoke
					Component= "rh.Componentes.RH_inconsistencias"
					method="RHInconsistencias"
					returnvariable="rhIncons">
					<cfif isdefined("rsForm.RHJMUsituacion") and len(trim(rsForm.RHJMUsituacion))neq 0>
						<cfinvokeargument name="RHIid" value="#rsForm.RHJMUsituacion#"/>	
					</cfif>
					<cfinvokeargument name="tabindex" value="1"/>
				</cfinvoke>			</td>
		</tr>
		<tr>
		  <td nowrap class="fileLabel" valign="top"><cf_translate key="LB_Justificacion">Justificación</cf_translate>:
		    <textarea name="RHJMUjustificacion" rows="4" cols="50" tabindex="1"></textarea></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO' tabindex="1">
					<input type="hidden" name="RHJMUid" value="<cfoutput>#form.RHJMUid#</cfoutput>">
				<cfelse>
					<cf_botones modo='ALTA' tabindex="1">
				</cfif>			</td>
		</tr>
	</table>
</form>
		
<cf_qforms>
<!--- Variables de Traduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Empleado"
	Default="Empleado"
	returnvariable="MSG_Empleado"/>
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

<script language="javascript" type="text/javascript">
	
	function habilitarValidacion(){
		<cfoutput>
		objForm.DEid1.required = true;
		objForm.DEid1.description = "#MSG_Empleado#";
		
		objForm.RHJMUfecha.required = true;
		objForm.RHJMUfecha.description = "#MSG_Fecha#";
		
		objForm.RHIid.required = true;
		objForm.RHIid.description = "#MSG_Situacion#";
		
		objForm.RHJMUjustificacion.required = true;
		objForm.RHJMUjustificacion.description = "#MSG_Justificacion#";
		</cfoutput>
	}
	
	function deshabilitarValidacion(){
		
		objForm.DEid1.required = false;
		objForm.RHJMUfecha.required = false;
		objForm.RHIid.required = false;
		objForm.RHJMUjustificacion.required = false;
	}
	
	habilitarValidacion();
	
	document.form1.RHJMUjustificacion.value="";
	<cfif modo neq "ALTA" and isdefined("rsForm") and rsForm.RecordCount NEQ 0>
		document.form1.RHJMUjustificacion.value="<cfoutput>#rsForm.RHJMUjustificacion#</cfoutput>";
	</cfif>
	document.form1.DEidentificacion1.focus();
</script>
