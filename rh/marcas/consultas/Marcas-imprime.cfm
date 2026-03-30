<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cfif isDefined("Url.DEid") and not isDefined("Form.DEid")>
  <cfset Form.DEid = Url.DEid>
</cfif>

<!--- Cambiar a tabla temporal --->

<!--- Reporte del epleado realizado por el evaluador --->
  <cfquery name="rsProc" datasource="#session.DSN#">
				set nocount on
				set rowcount  10000
				select a.RHUMid
					,rtrim(c1.Pnombre || ' ' || rtrim(c1.Papellido1 || ' ' || c1.Papellido2)) as NombreUsuario
					,d.CFdescripcion as Centro
					,d.CFid  
					,rtrim(g.DEnombre || ' ' || rtrim(g.DEapellido1 || ' ' || g.DEapellido2)) as NombreEmpleado
					,convert(varchar,RHCMfcapturada, 103) as RHCMfcapturada
					,substring(convert(varchar,RHCMhoraentrada,108),1,5) as RHCMhoraentrada
					,substring(convert(varchar,RHCMhorasalida,108),1,5) as RHCMhorasalida
					,substring(convert(varchar,RHCMhoraentradac,108),1,5) as RHCMhoraentradac
					,substring(convert(varchar,RHCMhorasalidac,108),1,5) as RHCMhorasalidac
					,isnull(RHCMhorasrebajar,0) as RHCMhorasrebajar
					,cia.Enombre as Enombre
					,g.DEidentificacion as cedula
					,d.CFdescripcion
					,rhp.RHPdescripcion
					,rhpu.RHPdescpuesto 
					,RHCMhorasadicautor
					,substring(h.RHASdescripcion,1,35) as RHASdescripcion
					,e.RHPMfcierre
				from  DatosEmpleado g
					,RHControlMarcas f
					,RHProcesamientoMarcas e 
					,CFuncional d 
					,RHUsuariosMarcas a
					,Usuario b1
					,DatosPersonales c1
					,LineaTiempo lt
					,RHAccionesSeguir h 
					,Empresa cia 
					,RHPlazas rhp
					,RHPuestos rhpu
				
				where g.Ecodigo=  <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
					<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
				   		and g.DEid in ( <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.DEid#">) --, 4839,4840)
					</cfif>
					<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
				   		and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
					</cfif>
					<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) NEQ 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) NEQ 0>
				   		and f.RHCMfcapturada
						   between  <cfqueryparam cfsqltype="cf_sql_varchar"  value="#LSDateFormat(fdesde,'YYYYMMDD')#">
						and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(fhasta,'YYYYMMDD')#">
					</cfif>
					and f.DEid   = g.DEid
					and e.RHPMid = f.RHPMid
					and d.CFid   = e.CFid 	
					and d.CFid   = a.CFid 	
					and getdate() between lt.LTdesde and lt.LThasta
					and lt.DEid  = g.DEid
					and a.Usucodigo = b1.Usucodigo 
					and b1.datos_personales = c1.datos_personales 
					and h.RHASid =* f.RHASid
					and cia.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.EcodigoSDC#">
					and rhp.RHPid = lt.RHPid
					and lt.RHPcodigo = rhpu.RHPcodigo
					and rhpu.Ecodigo = g.Ecodigo
					and lt.Ecodigo = g.Ecodigo
					order by
					<cfif isdefined("form.ckCF")>
					 	3 
					</cfif>
					<cfif isdefined("form.ckSP")>
					 	<cfif isdefined("form.ckCF")>	
							,
						</cfif>
							2
					</cfif>
					<cfif isdefined("form.ckF")>
					 	<cfif isdefined("form.ckCF") or isdefined("form.ckCF")>
							,
						</cfif>
						13 
					</cfif>
					<cfif not isdefined("form.ckCF") and not isdefined("form.ckSP") and not isdefined("form.ckF")>
						13,2,3
					</cfif>
					set rowcount 0
					set nocount off
			   </cfquery>
		
		<cfif rsProc.RecordCount NEQ 0>
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
			
				<tr> 
					<td colspan="4"  valign="middle" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#rsProc.Enombre#</cfoutput></strong></td>
				</tr>
				
				<tr> 
					<td colspan="4" align="center">
						<strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
							Reporte de Marcas
						</strong>
					</td>
				</tr>

				</table>
				
				<cfset IdEmpleado = 0>
				<cfset descripcion = "">
				<cfset supervisor = "">
				
				<cfset NumLinea = 1>
				<cfset temp = 0> <!--- Controla si esta cerrado el periodo de Extras --->
				<cfoutput query="rsProc">
					<cfflush interval="512">
					<cfif descripcion NEQ rsProc.centro>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
							<tr><td colspan="8"><hr width="100%" size="0" color="##000000"></td></tr>
							<tr > 
								<td colspan="8" align="center"><font size="2"><strong>Centro Funcional: &nbsp;</strong>#rsProc.CFdescripcion#<strong></strong></font>&nbsp;</td>
							</tr>
						</table>
						<cfset descripcion = rsProc.centro>
						
					</cfif>
					<cfif supervisor NEQ rsProc.NombreUsuario>
						<cfset supervisor = rsProc.NombreUsuario>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
							
							<tr > 
								<td colspan="8" align="center"><font size="2"><strong>Supervisor: &nbsp;</strong>#rsProc.NombreUsuario#<strong></strong></font>&nbsp;</td>
							</tr>
						</table>
					</cfif>	
							
					<cfif IdEmpleado NEQ rsProc.cedula >
						<cfset IdEmpleado = rsProc.cedula>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
							<tr><td colspan="8"><hr width="100%" size="0" color="##000000"></td></tr>
							
							<tr > 
								<td colspan="8" align="center">
									<font size="2"><strong>Funcionario: &nbsp; #rsProc.cedula# - #rsProc.NombreEmpleado#</strong></font>
								</td>
							</tr>
							<tr > 
								<td colspan="8" align="center"><font size="2"><strong>Puesto: &nbsp;</strong>#rsProc.RHPdescpuesto#<strong></strong></font>
								&nbsp;</td>
							</tr>  
							<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) neq 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) neq 0 >
								<tr > 
									<td colspan="8" align="center"><font size="2"><strong>Desde: &nbsp;</strong>#form.fdesde#<strong>&nbsp; Hasta: &nbsp;</strong> #form.fhasta#</font>
									&nbsp;</td>
								</tr>  
							</cfif>
							<tr><td colspan="8"><hr width="100%" size="0" color="##000000"></td></tr>
							<tr class="listaCorte">
			
									<td width="10%">Fecha Marca:</td>
									<td width="10%">Marca Entrada:</td>
									<td width="10%">Marca Salida:</td>
									<td width="10%">Entrada Autorizada:</td>
									<td width="10%">Salida Autorizada:</td>
									<td width="10%">Horas extras Aut.</td>
									<td width="10%">Horas Rebajadas</td>
									<td width="10%">Acci&oacute;n Reportada</td>
								
							</tr>
						</table>
					</cfif>				
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
						<cfset NumLinea = NumLinea + 1>
						<tr>
							<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMfcapturada#</td>
							<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMhoraentrada#</td>
							<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMhorasalida#</td>
							<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMhoraentradac#</td>
							<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMhorasalidac#</td>
							<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center"><cfif rsProc.RHCMhorasadicautor GT 0>#LSNumberFormat(rsProc.RHCMhorasadicautor,',9.00')#<cfelse>&nbsp;</cfif></td>
							<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#LSNumberFormat(rsProc.RHCMhorasrebajar,',9.00')#</td>
							<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHASdescripcion#</td>
						</tr>
						<cfif len(trim(rsProc.RHPMfcierre)) EQ 0>
							<cfset temp = temp + 1>						
						</cfif>
						<cfset Supervisor = rsProc.NombreUsuario>
				</cfoutput> 
				<tr > 
					<td colspan="8" align="center">&nbsp;</td>
				</tr>  
				<cfif #temp# GT 0>
					<tr > 
						<td colspan="8" align="left"><strong>Este reporte es de car&aacute;cter temporal , ya que no se ha cerrado el Procesamiento de marcas.</strong></td>
					</tr>  
				</cfif>
				<tr > 
					<td colspan="8" align="center"><strong>------------------------------
						<cfif isdefined("url.DEid")>
							Fin del Reporte
						<cfelse>
							Fin de la Consulta 
						</cfif>
					--------------------------------------</strong>
					&nbsp;</td>
				</tr>  
			</table>
		<cfelse>
			
			<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >
				<tr><td><hr width="100%" size="0" color="##000000"></td></tr>
				
				<tr > 
					<td colspan="8" align="center"><font size="2"><strong>No hay registros</strong></font>
					&nbsp;</td>
				</tr>  
				 <tr><td><hr width="100%" size="0" color="##000000"></td></tr>
			</table>
			
		</cfif>			   