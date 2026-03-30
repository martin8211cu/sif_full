<!--- Asignación el valor a la variable modo --->
<cfset modo="ALTA">
<cfif isdefined("Form.DEid") and len(trim("Form.DEid")) NEQ 0 and Form.DEid gt 0 >
    <cfset modo="CAMBIO">
</cfif>

<!--- Consultas --->
<cfset v_fecha = '' >
<cfset v_egreso = '' >
<cfset vACAid = 0 >
<cfif modo neq "ALTA">
	<cfquery name="rsDatos" datasource="#Session.DSN#">
		select 
			a.ACAid,				
			a.DEid,				
			a.ACAestado,
			coalesce(( select max(ACLTAfdesde) from ACLineaTiempoAsociado where ACAid = a.ACAid ), a.ACAfechaIngreso) as ACAfechaIngreso,
			( select max(ACLTAfhasta) from ACLineaTiempoAsociado where ACAid = a.ACAid ) as egreso,
			a.ACAfechaEgreso,		
			a.ACAobservaciones
		from ACAsociados a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
	<cfset v_fecha = LSDateFormat(rsDatos.ACAfechaIngreso, 'dd/mm/yyyy') >
	<cfif len(trim(rsDatos.egreso))>
		<cfif year(rsDatos.egreso) neq 6100 >
			<cfset v_egreso = LSDateFormat(rsDatos.egreso, 'dd/mm/yyyy') >	
		</cfif>
	</cfif>
	<cfif len(trim(rsDatos.ACAid))>
		<cfset vACAid = rsDatos.ACAid >	
	</cfif>	
	<cfif len(trim(rsDatos.DEid))>
		<cfset vDEid = rsDatos.DEid >	
	</cfif>	
	
	<cfquery name="rs_vigente" datasource="#session.DSN#">
		select ACLTAid as id
		from ACLineaTiempoAsociado
		where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vACAid#">
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between ACLTAfdesde and ACLTAfhasta
	</cfquery>
</cfif>
<!--- VERIFICAR QUE EL EMPLEADO ESTE ACTIVO --->
<cfquery name="rsEmpleadoActivo" datasource="#session.DSN#">
	select 1
	from LineaTiempo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  and <cf_dbfunction name="to_date" args="'#LSDateFormat(now(), "dd/mm/yyyy")#'"> between LTdesde and LThasta
</cfquery>
<cfinclude template="/rh/expediente/catalogos/asociados-etiquetas.cfm">	
	
<!--- Pintado de la Pantalla --->	
<cfoutput>
<form name="form1" method="post" action="asociados-sql.cfm" style="margin:0; ">
	<table cellpadding="2" cellspacing="0" border="0">
		<tr>
			<td colspan="2" class="#Session.preferences.Skin#_thcenter" style="padding-left: 5px;">#LB_DatoAsociado#</td>	
		</tr>		

		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
					<!--- Línea No. 2 --->
					<tr>
						<td nowrap="nowrap" colspan="3">&nbsp;</td>
					</tr>

					<tr>
						<td nowrap="nowrap" align="left" colspan="2">
							<strong>#LB_estado#:&nbsp;</strong>
							<!---<input name="ACAestado" type="checkbox" <cfif modo NEQ "ALTA" and rsDatos.ACAestado EQ 1>checked</cfif> >--->
							<cfif modo NEQ "ALTA" and rsDatos.ACAestado EQ 1>Activo<cfelse>Inactivo</cfif>
							
						</td>
						<!---<td nowrap="nowrap"><strong>#LB_Activo#</strong></td>--->
					</tr>

					<!--- Línea No. 3 --->
					<cfif isdefined("rsDatos") and (rsDatos.ACAestado EQ 0 or rsDatos.recordcount eq 0) >
						<tr>
							<td nowrap="nowrap" align="left" width="12%" ><strong>#LB_FechaIngreso#:</strong>&nbsp;</td>	
							<td width="88%" >
								<cf_sifcalendario name="ACAfechaIngreso" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
						  </td>
						</tr>
					<cfelse>
						<tr>
							<td nowrap="nowrap" align="left" colspan="2"><strong>#LB_FechaIngreso2#:</strong>&nbsp;#LSDateFormat(rsDatos.ACAfechaIngreso,'DD/MM/YYYY')#</td>	
						</tr>
					</cfif>

					<cfif isdefined("rsDatos") and rsDatos.ACAestado EQ 1 >
						<tr>
							<td align="left" width="12%" nowrap="nowrap"><strong>#LB_FechaEgreso#:</strong>&nbsp;</td>	
							<td align="left">
								<cf_sifcalendario name="ACAfechaIngreso" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
							</td>
						</tr>
						<tr>
							<td align="left" nowrap="nowrap" colspan="2"><strong>* #LB_LaFechaIndicadaDeEgresoSeTomaraComoFechaHastaParaDeduccionesYCargasAsignadasEnElModuloDeAhorroYCreditoEnElMomentoDeInactivar#</strong>&nbsp;</td>	
						</tr>
					</cfif>

					<!--- Línea No. 6 --->
					<tr>
						<td nowrap="nowrap" align="left" colspan="2"><strong>#LB_Observaciones#:</strong>&nbsp;</td>		
					</tr>
					<!--- Línea No. 7 --->
					<tr>
						<td colspan="2" align="left">
							<cfif modo eq "ALTA"><cfset miHTML = ""><cfelse><cfset miHTML = rsDatos.ACAobservaciones></cfif>
							<cfif not rsEmpleadoActivo.RecordCount><cfset miHTML = MSG_ElempleadoseencuentraCesado></cfif>
							<cf_sifeditorhtml name="ACAobservaciones" indice="1" value="#miHTML#" height="150" width="550">
					  </td>
					</tr>
					<!--- Línea No. 8 --->
					<tr>
						<td nowrap="nowrap" colspan="2">&nbsp;</td>
					</tr>
					<!--- Línea No. 9 --->
					<tr>
						<td nowrap="nowrap" colspan="2" align="center">
							<cfif isdefined("rsDatos") and rsDatos.ACAestado EQ 1 >
								<input name="Baja" type="submit" value="#BTN_Actualizar2#" tabindex="1" class="btnNormal" onclick="javascript: return inactivar();">
							<cfelseif rsEmpleadoActivo.RecordCount>
								<input name="Alta" type="submit" value="#BTN_Actualizar#" tabindex="1" class="btnNormal" onclick="javascript: return activar();">
							</cfif>
						</td>
					</tr>
					<!--- Línea No. 10 --->
					<tr>
						<td nowrap="nowrap" colspan="2">&nbsp;</td>
					</tr>
					<input type="hidden" name="ACAid" value="<cfif modo neq "ALTA">#vACAid#</cfif>">
					<input type="hidden" name="DEid" value="#Form.DEid#">			
				</table>
			</td>
			
			<td valign="top">
				<cfif isdefined("rsDatos")>
					<table cellpadding="2" >
						<tr>
							<td colspan="2" bgcolor="##CCCCCC"><strong>#LB_historia#</strong></td>
						</tr>
						<tr><td>
						
						<cfquery name="rsLista" datasource="#session.DSN#">
							select ACLTAfdesde as desde, 
							case when <cf_dbfunction name="date_part" args="YY,ACLTAfhasta"> = 6100 then '-' else <cf_dbfunction name="date_format" args="ACLTAfhasta,dd/mm/yyyy"> end as hasta 
							from ACLineaTiempoAsociado
							where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vACAid#">
							order by ACLTAfdesde
						</cfquery>
	
							<cfinvoke 
								component="rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaCar">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="desde,hasta"/>
									<cfinvokeargument name="etiquetas" value="#lb_Ingreso#, #lb_Egreso#"/>
									<cfinvokeargument name="formatos" value="D, S"/>
									<cfinvokeargument name="incluyeform" value="false"/>	
									<cfinvokeargument name="align" value="left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>				
									<cfinvokeargument name="showlink" value="false"/>			
							</cfinvoke>		
						</td></tr>
					</table>
				</cfif>
			
			</td>
		</tr>				
	</table>
</form>

</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function inactivar(){
		var fecha_max = '<cfoutput>#v_fecha#</cfoutput>';
		if (fecha_max != '' ){
			var fecha_arreglo_max = fecha_max.split('/');
			var fecha_inactivar = document.form1.ACAfechaIngreso.value;
			var fecha_arreglo_inactivar= fecha_inactivar.split('/');
			
			var obj_fecha_max = new Date(fecha_arreglo_max[2], fecha_arreglo_max[1]-1, fecha_arreglo_max[0]);
			var obj_fecha_inactivar = new Date(fecha_arreglo_inactivar[2], fecha_arreglo_inactivar[1]-1, fecha_arreglo_inactivar[0] );		
			
			if ( obj_fecha_inactivar < obj_fecha_max ){
				alert('<cfoutput>#LB_error1#</cfoutput>')
				return false;
			}
		}

		return confirm('<cfoutput>#LB_msginactivar#</cfoutput>')
	}

	function activar(){
		var fecha_egreso = '<cfoutput>#v_egreso#</cfoutput>';
		if (fecha_egreso != '' ){
			var fecha_arreglo_egreso = fecha_egreso.split('/');
			var fecha_activar = document.form1.ACAfechaIngreso.value;

			
			var fecha_arreglo_activar= fecha_activar.split('/');
			
			var obj_fecha_egreso = new Date(fecha_arreglo_egreso[2], fecha_arreglo_egreso[1]-1, fecha_arreglo_egreso[0]);
			var obj_fecha_activar = new Date(fecha_arreglo_activar[2], fecha_arreglo_activar[1]-1, fecha_arreglo_activar[0]);
			
			if ( obj_fecha_activar < obj_fecha_egreso ){
				alert('<cfoutput>#LB_error2#</cfoutput>')
				return false;
			}
		}

		return true;
	}

</script>



