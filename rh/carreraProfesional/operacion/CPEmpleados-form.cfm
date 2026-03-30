<cfif isdefined('url.RHACPlinea') and not isdefined('form.RHACPlinea')>
	<cfset form.RHACPlinea = url.RHACPlinea>
</cfif>
<cfif isdefined('form.RHACPlinea') and LEN(TRIM(form.RHACPlinea))>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfif isdefined('form.RHACPlinea') and LEN(TRIM(form.RHACPlinea))>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select a.DEid, {fn concat({fn concat({fn concat({ fn concat(b.DEnombre, ' ') },b.DEapellido1)}, ' ')},b.DEapellido2) } as NombreEmp,
			RHACPfdesde as fdesde, RHACPfhasta as fhasta,RHACPObserv as observaciones, DEidentificacion,
			(select min(d.NTIdescripcion)
						from NTipoIdentificacion d
						where d.NTIcodigo = b.NTIcodigo
					) as NTIdescripcion,
			rtrim(RHPcodigo) as RHPcodigo
			,RHACPreferencia as referencia
		from RHAccionesCarreraP a
		inner join DatosEmpleado b
			on b.DEid = a.DEid
			and b.Ecodigo = a.Ecodigo
		inner join LineaTiempo c
		 	on c.DEid = a.DEid
			and getdate() between LTdesde and LThasta
		where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
	</cfquery>
	<cfif rsDatos.RecordCount NEQ 0>
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select count(1) as registros
			from LineaTiempoCP
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">
		</cfquery>
		<cfquery name="rsAntiguedad" datasource="#session.DSN#">
			select 	EVfantig as Antiguedad
			from EVacacionesEmpleado a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">
		</cfquery>
		<cfquery name="rsPuesto" datasource="#session.DSN#">
			select  b.RHPcodigo, b.RHPdescpuesto
			from LineaTiempo a, RHPuestos b
			where a.RHPcodigo = b.RHPcodigo
				and a.Ecodigo = b.Ecodigo
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.LTdesde and a.LThasta
		</cfquery>
	</cfif>
</cfif>


<cfoutput>
	<form name="form1" method="post" action="CPEmpleados-sql.cfm">
		<input name="modo" type="hidden" value="#modo#" />
		<cfif modo NEQ 'ALTA'>
			<input name="RHACPlinea" type="hidden" value="#form.RHACPlinea#" />
			<input name="RHPcodigo" type="hidden" value="#rsDatos.RHPcodigo#" />
		</cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
			<cfif modo NEQ "ALTA">
				<tr>
					<cfif isdefined("rsVerifica") and rsVerifica.RecordCount NEQ 0 and rsVerifica.registros GT 0>
						<td align="center" nowrap class="fileLabel" colspan="6"><cf_translate key="LB_RegistroDeAjuste">Registro de Ajuste</cf_translate></td>
					<cfelseif isdefined("rsVerifica") and rsVerifica.RecordCount NEQ 0 and rsVerifica.registros EQ 0>
						<td align="center" nowrap class="fileLabel" colspan="6"><cf_translate key="LB_RegistroDeIngreso">Registro de Ingreso</cf_translate></td>
					</cfif>				
				</tr>
			</cfif>
			<cfif modo NEQ "ALTA">
				<tr>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Consecutivo">Consecutivo</cf_translate>:</td>
					<td colspan="3">#form.RHACPlinea#</td>
				</tr>
				<tr>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
					<td>
						<input type="hidden" name="DEid" value="#rsDatos.DEid#" tabindex="-1">
						#HtmlEditFormat(rsDatos.NombreEmp)#
					</td>
					<td align="right" nowrap class="fileLabel">#HtmlEditFormat(rsDatos.NTIdescripcion)#&nbsp;:</td>
					<td>#HtmlEditFormat(rsDatos.DEidentificacion)#</td>
				</tr>
				<tr>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_FechaAntiguedad">Fecha de Antiguedad</cf_translate>:</td>
					<td>#LSDateFormat(rsAntiguedad.Antiguedad,'dd/mm/yyyy')#</td>	
					<td align="right" nowrap class="fileLabel" width="1%"><cf_translate key="LB_Puesto">Puesto</cf_translate>:</td>
					<td>#rsPuesto.RHPcodigo#&nbsp;-&nbsp;#rsPuesto.RHPdescpuesto#</td>				
				</tr>
			<cfelse>
				<tr>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
					<td><cf_rhempleado size="30" tabindex="1" EmpleadosActivos="true"> </td>
				</tr>
			</cfif>			
			<tr>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_FechaDeVigencia">Fecha de Vigencia</cf_translate>:</td>
				<td nowrap>
					<cfif modo NEQ "ALTA">
						#LSDateFormat(rsDatos.fdesde, 'DD/MM/YYYY')#
						<input type="hidden" name="Fdesde" value="#LSDateFormat(rsDatos.Fdesde, 'DD/MM/YYYY')#">
					<cfelse>
						<cfset fecha = LSDateFormat(Now(), 'DD/MM/YYYY')>
						<cf_sifcalendario form="form1" value="#fecha#" name="Fdesde" tabindex="1">	
					</cfif> 
				</td>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Referencia">Referencia</cf_translate>:</td>
				<td>
					<cfif modo NEQ "ALTA"><cfset Lvar_referencia=rsDatos.referencia><cfelse><cfset Lvar_referencia=0></cfif>
					<cf_monto name="referencia" value="#Lvar_referencia#" size="10" decimales="0" tabindex="1">
				</td>
			</tr>
			<tr>
				<td align="right" nowrap class="fileLabel" valign="top"><cf_translate key="LB_Observaciones">Observaciones</cf_translate>:</td>
				<td colspan="5"><textarea name="Observaciones" cols="100" rows="3" tabindex="1"><cfif modo NEQ "ALTA">#rsDatos.Observaciones#</cfif></textarea></td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<cfif modo NEQ "ALTA">
				<tr>
					<td colspan="6">
						<table width="100%" cellpadding="2" cellspacing="2">
							<tr>
								<td width="50%" valign="top"><cfinclude template="CPEmpleados-sitActual.cfm"></td>
								<td width="50%" valign="top"><cfinclude template="CPEmpleados-sitProp.cfm"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr> 
					<td colspan="4" align="center" class="sectionTitle">
						<font color="##FF0000"><b>
							<cf_translate key="MSG_Para_terminar_de_definir_la_Situacion_Propuesta_debe_guardar_los_cambios">Para terminar de definir la Situaci&oacute;n Propuesta debe guardar los cambios</cf_translate>
						</b></font>
					</td>
				</tr>
			</cfif>		
			<tr>
				<td colspan="4">
					<cfif modo NEQ "ALTA">
						<cfset Lvar_botones = "Nuevo,Guardar,Aplicar,Rechazar,Eliminar,Lista">
					<cfelse>
						<cfset Lvar_botones = "Agregar,,Lista">
					</cfif>
					<cf_botones values="#Lvar_botones#" tabindex="1">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>
<cf_qforms form='form1'>
	<cf_qformsrequiredfield args="DEid, #LB_Empleado#">
	<cf_qformsrequiredfield args="Fdesde, #LB_FechaInicio#">
	<cf_qformsrequiredfield args="Observaciones, #LB_Observaciones#">
	<cf_qformsrequiredfield args="referencia, #LB_Referencia#">
	
	<cfif modo NEQ "">
		<cf_qformsrequiredfield args="Observaciones, #LB_Observaciones#">
	</cfif>
</cf_qforms>
<script language="javascript1.2" type="text/javascript">
	function funcLista(){
		deshabilitarValidacion();
		location.href='CPEmpleados-lista.cfm';
	}
	function funcEliminar(){
		deshabilitarValidacion();
	}
	function funcNuevo(){
		deshabilitarValidacion();
	}
	function funcAplicar(){
		if (!confirm('Desea aplicar la acción?')) return false;
	}
</script>