<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_templateheader title="Reporte de Deducciones NO Aplicadas">
	<cf_templatecss>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Deducciones NO Aplicadas'>
		<cfoutput>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="../../portlets/pNavegacion.cfm">
					</td>
				</tr>
				<tr>
					<td>
						<form name="form1" method="get" action="InclusionDeduccionesReport.cfm?generar=1">
							<center>
								<table>
									<tr>
										<td align="right"><strong>Fecha de inicio</strong></td>
										<td align="left"> <cf_sifcalendario form="form1" name="finicio" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#"> </td>
									</tr>
									
									<tr>
										<td align="right"><strong>Fecha final</strong></td>
										<td align="left"> <cf_sifcalendario form="form1" name="ffinal" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#"> </td>
									</tr>
									
									<tr>
										<td align="right"><strong>Tipo Deducción<strong></strong></strong></td>
										<td align="left"><cf_rhtipodeduccion  size="30" validate="1" financiada="1" tabindex="1"></td>
									</tr>
									
									<tr>
										<td align="right"><strong>Usuario</strong></td>
										<td align="left">
										<cfquery name="rsUsuario" datasource="#session.DSN#">
											  select distinct a.BMUsucodigo, c.Pnombre #_Cat# ' ' #_Cat# c.Papellido1 #_Cat# ' ' #_Cat# c.Papellido2 as nombre 
											  from RHInclusionDeducciones a 
													
													inner join Usuario b 
													on b.Usucodigo= a.BMUsucodigo 
													
													inner join DatosPersonales c on c.datos_personales = b.datos_personales 
											  where a.Ecodigo =  <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
										</cfquery>
										
										<select name="usuario">
										  <option value=""></option>
										  <cfloop query="rsUsuario">
											<option value="#rsUsuario.BMUsucodigo#">#rsUsuario.nombre#</option>
										  </cfloop>
										</select>
									  </td>
									</tr>
									
									<tr>
										<td colspan="2" align="center">
										<input name="generar" type="submit" value="Generar Reporte">
										</td>
									</tr>
								</table>
							</center>
						</form>
					</td>
				</tr>
			</table>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>


<cfif isdefined("url.generar")>
	 
	<!--- VERIFICA QUE LAS FECHA INICIAL SEA MENOR QUE LA FECHA FINAL, Y SI NO LAS INVIERTE--->
	
	<cfif isdefined("url.finicio") and len(trim(url.finicio)) and isdefined("url.ffinal") and len(trim(url.ffinal))>
		<cfset url.finicio = LSParseDateTime(url.finicio) >
		<cfset url.ffinal = LSParseDateTime(url.ffinal) >
		<cfif finicio gt ffinal >
			<cfset tmp = url.finicio >
			<cfset url.finicio = url.ffinal >
			<cfset url.ffinal = tmp >
		</cfif>
	</cfif>
		
	<cfquery name="rsUser" datasource="#session.DSN#">
		select distinct b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2  as nombre 
		from Usuario a 	   
	
		inner join DatosPersonales b
		on b.datos_personales = a.datos_personales 
	
		where a.Usucodigo=<cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
		
				
	<!--- QUERY DEL REPORTE --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 
			a.RHIDid,
			a.TDid,
			a.RHIDdesc,
			a.RHIDreferencia,
			a.RHIDmonto,
			a.BMfechaalta,
			a.RHIDfechadesde,
			a.RHIDfechadoc,
			b.DEidentificacion,
			b.DEnombre #_Cat#' '#_Cat# b.DEapellido1 #_Cat#' '#_Cat# b.DEapellido2 as nombre,
			<cfif isdefined("url.finicio") and len(trim(url.finicio))NEQ 0>
				 <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#url.finicio#"> as finicial,
			</cfif> 
			<cfif isdefined("url.ffinal") and len(trim(url.ffinal))NEQ 0>
				<cfqueryparam  cfsqltype="cf_sql_timestamp" value="#url.ffinal#"> as ffinal,
			</cfif> 
			<cfqueryparam  cfsqltype="cf_sql_char" value="#rsUser.nombre#"> as usuario
		
		from RHInclusionDeducciones a
	
		left outer join DatosEmpleado b
		on 	b.DEid = a.DEid	
		
		<cfif (isdefined("url.finicio") and len(trim(#url.finicio#))NEQ 0)or 
				(isdefined("url.ffinal")and len(trim(#url.ffinal#))NEQ 0) or 
				(isdefined("url.TDid")and len(trim(#url.TDid#))NEQ 0)or 
				(isdefined("url.usuario")and len(trim(#url.usuario#))NEQ 0)>
			where
		</cfif>
		
		<!--- Tipo Deduccion --->
		<cfif isdefined("url.TDid") and len(trim(#url.TDid#))NEQ 0>
			a.TDid =	<cfqueryparam  cfsqltype="cf_sql_numeric" value="#url.TDid#">
			<cfset primero = 1>
		</cfif>
		
		<!--- Usuario --->
		<cfif isdefined("url.usuario") and len(trim(#url.usuario#))NEQ 0>
			<cfif isdefined("primero")>
				and
			<cfelse>
				<cfset primero = 1>
			</cfif>
			a.BMUsucodigo =	<cfqueryparam  cfsqltype="cf_sql_numeric" value="#url.usuario#">
		</cfif>
		
		
		<cfif (isdefined("url.finicio") and len(trim(#url.finicio#))NEQ 0) and (isdefined("url.ffinal") and len(trim(#url.ffinal#))NEQ 0)>
			<cfif isdefined("primero")>
				and
			<cfelse>
				<cfset primero = 1>
			</cfif>
			a.BMfechaalta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#url.finicio#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s',-1,DateAdd('d',1,url.ffinal))#">
		</cfif>
			
		order  by  BMfechaalta
	</cfquery>
	
	<!--- LLAMADA AL REPORTE --->
	<cfset formato = "flashpaper">
	<cfreport format="#formato#" template= "../consultas/InclusionDeduccionesReport.cfr" query="rsReporte"></cfreport>
</cfif>