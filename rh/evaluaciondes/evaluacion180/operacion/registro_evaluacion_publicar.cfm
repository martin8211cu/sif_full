<!--- Consultas en modo Cambio --->
<cfquery name="rsForm" datasource="#session.dsn#"><!--- RHPcodigo,  --->
	select 	REid, 
			Ecodigo, 
			TEcodigo, 
			REdescripcion, 
			REdesde, 
			REhasta, 
			REdias, 
			REevaluacionbase, 
			REaplicajefe, 
			REaplicaempleado, 
			REavisara, 
			REestado, 
			ts_rversion
	from RHRegistroEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
</cfquery>

<cfquery name="rsTablas" datasource="#session.dsn#">
	select TEcodigo, TEnombre
	from TablaEvaluacion	
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif len(trim(rsForm.TEcodigo))>
		and TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TEcodigo#">
	<cfelse>
		and TEcodigo = 0
	</cfif>
	order by TEnombre
</cfquery>	

<cfquery name="rsEvaluacion" datasource="#session.dsn#">
	select REid, REdescripcion
	from RHRegistroEvaluacion
	where REestado = 1
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  
	<cfif len(trim(rsForm.REevaluacionbase))>
		and REevaluacionbase = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.REevaluacionbase#">
	<cfelse>
		and REevaluacionbase = 0
	</cfif>
	  
	order by REdescripcion
</cfquery>	
<cfquery name="rsconceptos" datasource="#session.dsn#">
	select  coalesce(sum(a.IREpesop),0) as IREpesop ,coalesce(sum(a.IREpesojefe),0) as IREpesojefe
	from RHIndicadoresRegistroE a
	inner join RHIndicadoresAEvaluar b
		on  a.IAEid = b.IAEid
		and a.Ecodigo = b.Ecodigo	
		and b.IAEtipoconc = 'T'
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and REid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		and IREsobrecien = 0		
</cfquery>
<cfquery name="rspersonas" datasource="#session.dsn#">
select  coalesce(count(a.DEid),0) as personas
		from RHEmpleadoRegistroE a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and REid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
</cfquery>
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<cfoutput>
<form action="registro_evaluacion_publicar-sql.cfm" method="post" name="form1">

	<table width="50%" align="center"  border="0" cellspacing="3" cellpadding="0">
		<tr>
			<td rowspan="13">&nbsp;</td>
			<td colspan="3">&nbsp;</td>
			<td rowspan="7">&nbsp;</td>
		</tr>

		<tr>
			<td width="30%" valign="middle" nowrap><strong>Descripci&oacute;n:</strong>&nbsp;</td>
			<td colspan="2" valign="middle" width="50%">#rsForm.REdescripcion#</td>
		</tr>
		
		<tr>
			<td colspan="1" nowrap><strong>Vigencia:</strong>&nbsp;</td>
			<td>
				#LSDateFormat(rsForm.REdesde,'dd/mm/yyyy')#
			</td>
		</tr>
		
		<tr>
			<td width="15%" valign="middle" nowrap><strong>Permite Evaluar hasta:</td>
			<td colspan="2">
				#LSDateFormat(rsForm.REhasta,'dd/mm/yyyy')#
			</td>
		</tr>

		<tr>
			<td colspan="1" nowrap><strong>Tabla de Evaluaci&oacute;n:</strong>&nbsp;</td>
			<td colspan="2"><cfif len(trim(rsTablas.TEnombre))>#rsTablas.TEnombre#<cfelse>Ninguna</cfif></td>
		</tr>

		<tr>
			<td colspan="1" nowrap><strong>D&iacute;as a recordar:</strong>&nbsp;</td>
			<td colspan="2">
				<cfset valor = 0 >
				<cfif len(trim(rsForm.REdias))>
					<cfset valor = rsForm.REdias >
				</cfif>
				#valor#
			</td>
		</tr>

		<tr>
			<td colspan="1" nowrap><strong>Basada en:</strong>&nbsp;</td>
			<td colspan="2">
				<cfif len(trim(rsEvaluacion.REdescripcion))>#rsEvaluacion.REdescripcion#<cfelse>Ninguna</cfif>
			</td>
		</tr>
	    <!-----
		<tr>
			<td colspan="1" nowrap><strong>Avisar a:</strong>&nbsp;</td>
			<td colspan="2">
				<cfquery name="rsAdmin" datasource="#session.DSN#">
					select u.Usucodigo as REavisara, u.Usulogin, c.Pnombre, c.Papellido1, c.Papellido2
					from Usuario u
					
					inner join DatosPersonales c
					on c.datos_personales = u.datos_personales
					
					where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.REavisara#">						  
				</cfquery>
				<cfif rsadmin.recordcount gt 0>
					#rsAdmin.Pnombre# #rsAdmin.Papellido1# #rsAdmin.Papellido2#
				<cfelse>				
					No definido
				</cfif>
			</td>
		</tr>	
		----->
		<tr>
			<td colspan="1" nowrap><strong>Aplicada solo por jefe:</strong>&nbsp;</td>
			<td colspan="2">
				<cfif rsForm.REaplicajefe eq 1><img src="/cfmx/rh/imagenes/checked.gif" /><cfelse><img src="/cfmx/rh/imagenes/unchecked.gif" /></cfif>
			</td>
		</tr>
		<tr>
			<td colspan="1" nowrap><strong>Aplica a funcionario:</strong>&nbsp;</td>
			<td colspan="2">
				<cfif rsForm.REaplicaempleado eq 1><img src="/cfmx/rh/imagenes/checked.gif" /><cfelse><img src="/cfmx/rh/imagenes/unchecked.gif" /></cfif>
			</td>
		</tr>
		
		<tr>
			<td colspan="1" nowrap><strong>Personas a evaluar:</strong>&nbsp;</td>
			<td colspan="2">
				<cfif rspersonas.recordcount gt 0>#rspersonas.personas#<cfelse>0</cfif>
			</td>
		</tr>
		<cfif rsForm.REaplicaempleado eq 1>
			<tr>
				<td colspan="1" nowrap><strong> Porcentaje Conceptos (Empleado):</strong>&nbsp;</td>
				<td colspan="2">
					<cfif rsconceptos.recordcount gt 0>#rsconceptos.IREpesop#<cfelse>0</cfif>&nbsp;%
				</td>
			</tr>
		</cfif>
		<cfif rsForm.REaplicajefe eq 1>
			<tr>
				<td colspan="1" nowrap><strong> Porcentaje Conceptos (Jefe):</strong>&nbsp;</td>
				<td colspan="2">
					<cfif rsconceptos.recordcount gt 0>#rsconceptos.IREpesojefe#<cfelse>0</cfif>&nbsp;%
				</td>
			</tr>		
		</cfif>

		<tr><td colspan="4">&nbsp;</td></tr>
		
		<tr>
			<td colspan="4" align="center">
				<cfif isdefined("form.Estado") and form.Estado EQ 1>
					<cfset vs_botones='Anterior'>
				<cfelse>
					<cfset vs_botones='Publicar,Anterior'>
				</cfif>
				<cf_botones values="#vs_botones#" names="#vs_botones#" nbspbefore="4" nbspafter="4" tabindex="3">
				<input type="hidden" name="REid" value="#rsForm.REid#">
				<input type="hidden" name="cantidadpersonas" value="<cfif rspersonas.recordcount gt 0>#rspersonas.personas#<cfelse>0</cfif>">
				<input type="hidden" name="porcentajeE" value="<cfif rsconceptos.recordcount gt 0>#rsconceptos.IREpesop#<cfelse>0</cfif>">
				<input type="hidden" name="porcentajeJ" value="<cfif rsconceptos.recordcount gt 0>#rsconceptos.IREpesojefe#<cfelse>0</cfif>">
				<input type="hidden" name="REestado" value="#rsForm.REestado#">
				<input type="hidden" name="SEL" value="7">
				<input type="hidden" name="Estado" value="<cfif isdefined("form.Estado") and form.Estado EQ 1>#form.Estado#<cfelse>0</cfif>">
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	function funcPublicar(){
		cantidadpersonas = new Number(document.form1.cantidadpersonas.value)
		porcentajeE = new Number(document.form1.porcentajeE.value)
		porcentajeJ = new Number(document.form1.porcentajeJ.value)
		if(cantidadpersonas == 0){
			alert('Debe seleccionar al menos un empleado para evaluar');
			document.form1.SEL.value = 5;
			document.form1.action = "registro_evaluacion.cfm";
			document.form1.submit();
			return false;
		}
		
		<cfif rsForm.REaplicaempleado eq 1>
			if(porcentajeE > 100){
				alert('El porcentaje de conceptos supera el 100%, actualmente tiene un ' + porcentajeE+' %');
				document.form1.SEL.value = 3;
				document.form1.action = "registro_evaluacion.cfm";
				document.form1.submit();
				return false;
			}	
			else if(porcentajeE < 100){ 
				alert('El porcentaje de conceptos debe sumar el 100%, actualmente tiene un ' + porcentajeE+' %');
				document.form1.SEL.value = 3;
				document.form1.action = "registro_evaluacion.cfm";
				document.form1.submit();
				return false;
			}
		</cfif>
		<cfif rsForm.REaplicajefe eq 1>
			if(porcentajeJ > 100){
				alert('El porcentaje de conceptos (Empleado) supera el 100%, actualmente tiene un ' + porcentajeJ+' %');
				document.form1.SEL.value = 3;
				document.form1.action = "registro_evaluacion.cfm";
				document.form1.submit();
				return false;
			}	
			else if(porcentajeJ < 100){ 
				alert('El porcentaje de conceptos (Jefe) debe sumar el 100%, actualmente tiene un ' + porcentajeJ+' %');
				document.form1.SEL.value = 3;
				document.form1.action = "registro_evaluacion.cfm";
				document.form1.submit();
				return false;
			}
		</cfif>
		
		return true;	
	}
</script>
