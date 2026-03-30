<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MG_El_empleado_seleccionado_no_tiene_un_usuario_correspondiente"
	Default="El empleado seleccionado no tiene un usuario correspondiente."
	returnvariable="MG_El_empleado_seleccionado_no_tiene_un_usuario_correspondiente"/> 


	<cfif isdefined("url.DEid")>
		<cfset form.DEid = url.DEid >
	</cfif>
	
	<cfquery name="evaluador" datasource="#session.DSN#" maxrows="1">
		select 	g.RHEEdescripcion,
				a.DEid, 
				a.RHLEnotajefe, 
				a.RHLEnotaauto,	
				a.RHLEpromotros,	
				{fn concat({fn concat({fn concat({fn concat(f.DEnombre , ' ' )}, f.DEapellido1 )}, ' ' )}, f.DEapellido2 )} as evaluador
		from RHListaEvalDes a
		
		inner join RHEvaluadoresDes b
		on a.RHEEid=b.RHEEid
		and a.DEid=b.DEid
		<cfif url.tipo eq 2>
			and b.DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
		
		inner join DatosEmpleado f
		on b.DEideval=f.DEid
		
		inner join RHEEvaluacionDes g
		on a.Ecodigo=g.Ecodigo
		and a.RHEEid=g.RHEEid
		
		<cfif url.tipo eq 1>
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			  and a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
		<cfelse>
			where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
			  and a.DEid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
	</cfquery>
	
	
	<cfquery name="data" datasource="#session.DSN#">
		select 	g.RHEEdescripcion,
				a.DEid, 
				coalesce(a.RHLEnotajefe,0) as RHLEnotajefe,  
				coalesce(a.RHLEnotaauto,0) as RHLEnotaauto,	
				coalesce(a.RHLEpromotros,0) as RHLEpromotros,	
				{fn concat({fn concat({fn concat({fn concat(e.DEnombre , ' ' )}, e.DEapellido1 )}, ' ' )}, e.DEapellido2 )} as nombre,
				{fn concat({fn concat({fn concat({fn concat(f.DEnombre , ' ' )}, f.DEapellido1 )}, ' ' )}, f.DEapellido2 )} as evaluador,
				
				<cfif url.tipo eq 1>
					{fn concat({fn concat({fn concat({fn concat(f.DEnombre , ' ' )}, f.DEapellido1 )}, ' ' )}, f.DEapellido2 )} as  corte,
				<cfelse>
					{fn concat({fn concat({fn concat({fn concat(e.DEnombre , ' ' )}, e.DEapellido1 )}, ' ' )}, e.DEapellido2 )} as corte, 
				</cfif>
				d.RHHcodigo, 
				d.RHHdescripcion,
				<!---c.RHDEnota,--->
				coalesce(c.RHDEporcentaje, 0) as RHDEnota,
				case b.RHEDtipo when 'A' then 1 when 'J' then 2 when 'C' then 3 when 'S' then 3 end as relacion
		from RHListaEvalDes a
		
		inner join RHEvaluadoresDes b
		on a.RHEEid=b.RHEEid
		and a.DEid=b.DEid
		<cfif url.tipo eq 2>
			and b.DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
		
		inner join RHDEvaluacionDes c
		on a.RHEEid=c.RHEEid
		and a.DEid=c.DEid
		and b.RHEEid=c.RHEEid
		and b.DEideval=c.DEideval
		
		inner join RHHabilidades d
		on d.RHHid=c.RHHid
		
		inner join DatosEmpleado e
		on a.DEid=e.DEid
		
		inner join DatosEmpleado f
		on b.DEideval=f.DEid
		
		inner join RHEEvaluacionDes g
		on a.Ecodigo=g.Ecodigo
		and a.RHEEid=g.RHEEid
		
		<cfif url.tipo eq 1>
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			  and a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
		<cfelse>
			where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
			  and a.DEid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
			order by relacion,a.DEid,corte			
	</cfquery>
	<table width="99%" align="center" cellpadding="2" cellspacing="0">
		<cfoutput>
		<tr><td align="center" class="tituloListas"> <strong>#session.Enombre#</strong></td></tr>
		<tr><td align="center"><cfif url.tipo eq 1 ><strong>Detalle de Evaluaci&oacute;n del Desempe&ntilde;o 360</strong><cfelse><strong>Detalle de Evaluaci&oacute;nes Realizadas</strong></cfif></td></tr>
		<tr><td align="center" ><font size="2"><strong>#evaluador.RHEEdescripcion#</strong></font></td></tr>
		<tr><td align="center" ><font size="2"><strong>Evaluador: #evaluador.evaluador#</strong></font></td></tr>
		<tr><td>&nbsp;</td></tr>
		</cfoutput>
		
		<cfif data.recordcount gt 0 >
			<cfoutput>
			<cfif url.tipo eq 1 >
				<cfset consulta = true > 
				<tr><td><table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid gray;"><tr><td>&nbsp;</td></tr><tr><td>
					<!--- INFO EMPLEADO--->
						<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
							<cfparam name="Form.DEid" default="#Url.DEid#">
						</cfif>
						
						<!--- Se utiliza cuando el que consulta es el empleado --->
							<cfif isdefined("Form.DEid")>
								<cfquery name="rsReferencia" datasource="asp">
									select Usucodigo
									from UsuarioReferencia
									where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEid#">
<!--- and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">--->
<!--- 20140502 LZ. Se comenta, porque el Usucodigo es Corporativo --->
									and STabla = 'DatosEmpleado'
								</cfquery>
								<cfif rsReferencia.RecordCount GT 0>
									<cfquery datasource="#Session.DSN#" name="rsEmpleado">
										select a.DEid,
											   a.Ecodigo,
											   a.Bid,
											   a.NTIcodigo, 
											   a.DEidentificacion, 
											   a.DEnombre, 
											   a.DEapellido1, 
											   a.DEapellido2, 
											   case a.DEsexo when 'M' then 'Masculino' when 'F' then 'Femenino' else 'N/D' end as Sexo,
											   a.CBTcodigo, 
											   a.DEcuenta, 
											   a.CBcc, 
											   a.DEdireccion, 
											   case a.DEcivil 
													when 0 then 'Soltero(a)' 
													when 1 then 'Casado(a)' 
													when 2 then 'Divorciado(a)' 
													when 3 then 'Viudo(a)' 
													when 4 then 'Unión Libre' 
													when 5 then 'Separado(a)' 
													else '' 
											   end as EstadoCivil, 
											   a.DEfechanac as FechaNacimiento, 
											   a.DEcantdep, 
											   a.DEobs1, 
											   a.DEobs2, 
											   a.DEobs3, 
											   a.DEdato1, 
											   a.DEdato2, 
											   a.DEdato3, 
											   a.DEdato4, 
											   a.DEdato5, 
											   a.DEinfo1, 
											   a.DEinfo2, 
											   a.DEinfo3, 
											   #rsReferencia.Usucodigo# as Usucodigo, 
											   a.Ulocalizacion, 
											   a.DEsistema, 
											   a.ts_rversion,
											   b.NTIdescripcion,
											   c.Mnombre,
											   coalesce(d.Bdescripcion, 'Ninguno') as Bdescripcion
										from DatosEmpleado a
										
										inner join NTipoIdentificacion b
										on a.NTIcodigo = b.NTIcodigo
										and b.Ecodigo = #Session.Ecodigo#				
						
										inner join Monedas c
										on a.Mcodigo = c.Mcodigo
										
										left outer join Bancos d
										on a.Ecodigo = d.Ecodigo
										  and a.Bid = d.Bid
						
										where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
									</cfquery>
								<cfelse>
									<cf_throw message="#MG_El_empleado_seleccionado_no_tiene_un_usuario_correspondiente#" errorcode="10040">
								</cfif>
							</cfif>
							
							<cfquery datasource="#Session.DSN#" name="otrosdatos">
								select coalesce(ltrim(rtrim(p.RHPcodigoext)),ltrim(rtrim(p.RHPcodigo))) as RHPcodigo, p.RHPdescpuesto, pl.CFid, cf.CFcodigo, cf.CFdescripcion
								from LineaTiempo lt
								
								inner join RHPuestos p
								on lt.Ecodigo=p.Ecodigo
								and lt.RHPcodigo=p.RHPcodigo
							
								inner join RHPlazas pl
								on lt.Ecodigo=pl.Ecodigo
								and lt.RHPid=pl.RHPid	
							
								inner join CFuncional cf
								on pl.Ecodigo=cf.Ecodigo
								and pl.CFid=cf.CFid
								
								where lt.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
								and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
							</cfquery>		
						<cfoutput>
						<table width="100%" border="0" cellpadding="3" cellspacing="0">
						  <tr>
							<td width="10%" rowspan="9" align="center" valign="top" style="padding-left: 10px; padding-right: 10px; padding-top: 10px;" nowrap><cfinclude template="/rh/expediente/consultas/frame-foto.cfm"></td> 
							<td class="fileLabel" width="15%" nowrap><cf_translate key="NombreExp">Nombre Completo</cf_translate>: </td>
							<td colspan="3"><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
							<td width="18%" align="right"></td>
						  </tr>
						  <tr>
							<td class="fileLabel" nowrap><cf_translate key="CedulaExp">#rsEmpleado.NTIdescripcion#</cf_translate>:</td>
							<td width="30%">#rsEmpleado.DEidentificacion#</td>
						
							<td class="fileLabel" nowrap width="11%"><cf_translate key="Puesto">Puesto</cf_translate>:</td>
							<td colspan="2">#trim(otrosdatos.RHPcodigo)# - #otrosdatos.RHPdescpuesto#</td>
						  </tr>
						  <tr>
							<td class="fileLabel" nowrap><cf_translate key="SexExp">Sexo</cf_translate>:</td>
							<td>#rsEmpleado.Sexo#</td>
							<td class="fileLabel" nowrap width="11%"><cf_translate key="CFuncional">Centro Funcional</cf_translate>:</td>
							<td colspan="2">#trim(otrosdatos.CFcodigo)# - #otrosdatos.CFdescripcion#</td>
						  </tr>
						  <tr>
							<td class="fileLabel" nowrap><cf_translate key="EstadoCivilExp">Estado Civil</cf_translate>:</td>
							<td>#rsEmpleado.EstadoCivil#</td>
							<td class="fileLabel" nowrap width="11%"></td>
						  </tr>
						  <tr>
							<td class="fileLabel" nowrap><cf_translate key="FecNacExp">Fecha de Nacimiento</cf_translate>:</td>
							<td><cf_locale name="date" value="#rsEmpleado.FechaNacimiento#"/></td>
						  </tr>
						  <tr>
							<td class="fileLabel" nowrap><cf_translate key="Direccion">Dirección</cf_translate>:</td>
							<td>#rsEmpleado.DEdireccion#</td>
						  </tr>
						<!---
						  <tr>
							<td class="fileLabel" nowrap><cf_translate key="NDependietesExp">No. de Dependientes</cf_translate>:</td>
							<td>#rsEmpleado.DEcantdep#</td>
						  </tr>
						  <tr>
							<td class="fileLabel" nowrap><cf_translate key="BancoExp">Banco</cf_translate>:</td>
							<td>#rsEmpleado.Bdescripcion#</td>
						  </tr>
						  <tr>
							<td class="fileLabel" nowrap><cf_translate key="CuentaCExp">Cuenta Cliente</cf_translate>:</td>
							<td>#rsEmpleado.CBcc# (#rsEmpleado.Mnombre#)</td>
						  </tr>
						--->  
						</table>
						</cfoutput>
						<script language="javascript" type="text/javascript">
							function Expediente(llave){
								location.href="../../expediente/consultas/expediente-globalcons.cfm?DEID="+ llave;
								
							}
						</script>

					
					<!--- INFO EMPLEADO --->
					
				</td></tr><tr><td>&nbsp;</td></tr></table></td></tr>
				<tr><td>&nbsp;</td></tr>
			</cfif>
			</cfoutput>
			<tr>
				<td>
					<table width="100%" cellpadding="2" cellspacing="">
						<cfoutput query="data" group="corte">
							<cfset i = 1 >
							<tr bgcolor="##CCCCCC">
								<cfif url.tipo eq 1>
									<td style="padding:5px;" ><strong>Evaluador:&nbsp;</strong> #data.evaluador#</td>
									<td style="padding:5px;" ><strong>Relaci&oacute;n:&nbsp;</strong> <cfif data.relacion eq 1>Autoevaluacion<cfelseif data.relacion eq 2>Jefe<cfelse>Otro(compa&ntilde;ero, subordinado)</cfif></td>
									<td style="padding:5px;" ><strong>Nota promedio:&nbsp;</strong><cfif data.relacion eq 1>#LSNumberFormat(data.RHLEnotaauto,',9.00')#<cfelseif data.relacion eq 2>#LSNumberFormat(data.RHLEnotajefe,',9.00')#<cfelse>#LSNumberFormat(data.RHLEpromotros,',9.00')#</cfif></td>
								<cfelse>
									<td style="padding:5px;" ><strong>Colaborador:&nbsp;</strong> #data.nombre#</td>
									<td style="padding:5px;" ><strong>Relaci&oacute;n:&nbsp;</strong> <cfif data.relacion eq 1>Autoevaluacion<cfelseif data.relacion eq 2>Jefe<cfelse>Otro(compa&ntilde;ero, subordinado)</cfif></td>
									<td style="padding:5px;" ><strong>Nota promedio:&nbsp;</strong><cfif data.relacion eq 1>#LSNumberFormat(data.RHLEnotaauto,',9.00')#<cfelseif data.relacion eq 2>#LSNumberFormat(data.RHLEnotajefe,',9.00')#<cfelse>#LSNumberFormat(data.RHLEpromotros,',9.00')#</cfif></td>
								</cfif>
							</tr>
							<tr>
								<td class="tituloListas" ><strong>Competencia</strong></td>
								<td class="tituloListas" align="right"><strong>Calificaci&oacute;n</strong></td>
								<td class="tituloListas" >&nbsp;</td>
							</tr>
							<cfoutput>
								<tr class="<cfif i mod 2>listaPar<cfelse>listaNon</cfif>">
									<td style="padding:2px;" >#data.RHHdescripcion#</td>
									<td style="padding:2px;" align="right" >#LSNumberFormat(data.RHDEnota,',9.00')#</td>
									<td>&nbsp;</td>
								</tr>
								<cfset i = i + 1 >
							</cfoutput>
							<tr><td>&nbsp;</td></tr>
						</cfoutput>
					</table>
				</td>
			</tr>
			<tr><td colspan="3" align="center">------ Fin del reporte ------</td></tr>
		<cfelse>
			<tr><td align="center"><font size="2">El evaluador no ha registrado calificaciones para las personas asociadas a esta Evaluaci&oacute;n del Desempe&ntilde;o.</font></td></tr>
			<tr><td>&nbsp;</td></tr>
		</cfif>	
		
	</table>
