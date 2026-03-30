<cfif isdefined("url.RHPMid") and len(trim(url.RHPMid)) NEQ 0>
	<cfset form.RHPMid = url.RHPMid>
</cfif>
<cfif isdefined("url.RHJMUfecha") and len(trim(url.RHJMUfecha)) NEQ 0>
	<cfset form.RHJMUfecha = url.RHJMUfecha>
</cfif>
<cfif isdefined("url.RHIid") and len(trim(url.RHIid)) NEQ 0>
	<cfset form.RHIid = url.RHIid>
</cfif>
<cfif isdefined("url.RHJMUjustificacion") and len(trim(url.RHJMUjustificacion)) NEQ 0>
	<cfset form.RHJMUjustificacion = url.RHJMUjustificacion>
</cfif>
<cfif isdefined("url.campo1") and len(trim(url.campo1)) NEQ 0>
	<cfset form.campo1 = url.campo1>
</cfif>
<cfif isdefined("url.campo11") and len(trim(url.campo11)) NEQ 0>
	<cfset form.campo11 = url.campo11>
</cfif>
<cfif isdefined("url.campo12") and len(trim(url.campo12)) NEQ 0>
	<cfset form.campo12 = url.campo12>
</cfif>

<cfif isdefined("url.campo2") and len(trim(url.campo2)) NEQ 0>
	<cfset form.campo2 = url.campo2>
</cfif>
<cfif isdefined("url.campo21") and len(trim(url.campo21)) NEQ 0>
	<cfset form.campo21 = url.campo21>
</cfif>
<cfif isdefined("url.campo22") and len(trim(url.campo22)) NEQ 0>
	<cfset form.campo22 = url.campo22>
</cfif>

<cfif isdefined("url.campo3") and len(trim(url.campo3)) NEQ 0>
	<cfset form.campo3 = url.campo3>
</cfif>

<cfif isdefined("url.campo4") and len(trim(url.campo4)) NEQ 0>
	<cfset form.campo4 = url.campo4>
</cfif>

<!-----=================== TRADUCCION =====================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Regresar"
	Default="Regresar"
	returnvariable="BTN_Regresar"/>		
	
<cfoutput>
<!--- valida q la fecha este dentro del lote --->
<cfif 1 EQ 2 and (isdefined("form.FMin")and LSDateFormat(form.RHJMUfecha,'yyyy-mm-dd') LT  form.FMin) or (isdefined("form.FMax")and LSDateFormat(form.RHJMUfecha,'yyyy-mm-dd') GT  form.FMax)>  
	<center>
		<table width="100%" height="100%">
			<tr  valign="bottom">
				<td>
					<strong><center>
						<label style="color:##990000; size:7;"><cf_translate key="MSG_ErrorLaFechaNoEsValidaEstaFueraDelRangoDelLote">Error: La fecha no es válida, está fuera del rango de fechas del lote.</cf_translate></label></center></strong>
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong><center><input name="Regresar" type="button"  value="#BTN_Regresar#" onClick="Javascript: javascript:history.back();"></center></strong>
				</td>
			</tr>
		</table>
	</center>
<cfelse>
	<!--- ====================================PROCESO DE REVISAR INCONSISTENCIAS ================================================= --->		 
	<!--- recoge las marcas por lote,fecha,tipo de inconsistencia--->
	<cfquery name="rsMarcaInconsistencia" datasource="#session.DSN#">
		select  a.RHIid,a.RHItipoinconsistencia,b.RHCMid, b.RHCMfcapturada,b.RHCMhoraentrada,b.RHCMhorasalida,b.RHCMhorasadicautor,b.RHCMhorasrebajar,b.RHCMdialibre
		from RHInconsistencias a
			inner join RHControlMarcas b
				on b.RHCMid = a.RHCMid		
		where b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPMid#"><!--- id del lote --->
			and b.RHCMinconsistencia=1
			and b.RHCMfregistro = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHJMUfecha)#"> 
			and a.RHItipoinconsistencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#">
			and a.RHIjustificada = 0
	</cfquery>
	
	<cfif rsMarcaInconsistencia.RecordCount GTE 1>
		<cftransaction>
		<cfloop query="rsMarcaInconsistencia">		
			<cfif Form.campo12 eq 'PM' and Form.campo1 neq 12>
				<cfset Form.campo1 = Form.campo1 + 12 >
			</cfif>
			<cfif Form.campo12 eq 'AM' and form.campo1 eq 12>
				<cfset form.campo1 = 0 >
			</cfif>		
			<cfset vHEntrada = CreateDateTime(year(form.RHJMUfecha),month(form.RHJMUfecha), day(form.RHJMUfecha), Form.campo1, Form.campo11, 0)>
			
			<cfif Form.campo22 eq 'PM' and Form.campo2 neq 12>
				<cfset Form.campo2 = Form.campo2 + 12 >
			</cfif>
			<cfif Form.campo22 eq 'AM' and form.campo2 eq 12>
				<cfset form.campo2 = 0 >
			</cfif>
			<cfset vHSalida = CreateDateTime(year(form.RHJMUfecha),month(form.RHJMUfecha), day(form.RHJMUfecha), Form.campo2, Form.campo21, 0)>
			<cfif datecompare(vHEntrada, vHSalida) EQ 1>
				<cfset vHSalida = dateadd('d', 1, vHSalida ) >
			</cfif>
			
			<cfif form.RHIid EQ 0 and rsMarcaInconsistencia.RHCMhoraentrada EQ ''><!--- caso en q se requiere la hora de entrada--->
				<cfquery datasource="#session.DSN#">
					update RHControlMarcas
					set RHCMhoraentradac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHEntrada#"> <!---@hentrada--->
					where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
				</cfquery>
			</cfif>
			<cfif form.RHIid EQ 1 and rsMarcaInconsistencia.RHCMhorasalida EQ ''><!--- caso en q se requiere la hora de salida--->	
				<cfquery datasource="#session.DSN#">
					update RHControlMarcas
					set RHCMhorasalidac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHSalida#">	<!---@hsalida--->  
					where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
				</cfquery>
			</cfif>
			<cfif form.RHIid EQ 4 or form.RHIid EQ 7 or form.RHIid EQ 2><!--- caso en q se requiere horas a agregar --->
				<cfquery datasource="#session.DSN#">
					update RHControlMarcas
						set RHCMhorasadicautor = <cfif isdefined("Form.campo3") and Len(Trim(Form.campo3))>
												<cfqueryparam cfsqltype="cf_sql_float" value="#Form.campo3#"> +
												</cfif>
												(select case w.RHCMhorasadicautor
														when null then 0
														else w.RHCMhorasadicautor end 
												from RHControlMarcas w
												where w.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">)
											 
					where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
				</cfquery>
			</cfif>
			<cfif form.RHIid EQ 5 or form.RHIid EQ 6><!--- caso en q se requiere horas a descontar --->
				<cfquery datasource="#session.DSN#">
					update RHControlMarcas
							set RHCMhorasrebajar = <cfif isdefined("Form.campo4") and Len(Trim(Form.campo4))>
														<cfqueryparam cfsqltype="cf_sql_float" value="#Form.campo4#"> +
													</cfif>
													(select case w.RHCMhorasrebajar
															when null then 0
															else w.RHCMhorasrebajar end 
													from RHControlMarcas w
													where w.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">)
					where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
				</cfquery>
			</cfif>
			<!---
			<cfquery name="rsUpMarca" datasource="#session.DSN#">
				declare @hentrada varchar(100), @hsalida varchar(100)
				select @hentrada = convert(varchar, convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHJMUfecha#">, 103), 106) || ' #Form.campo1#:#Form.campo11##Form.campo12#',
					   @hsalida = convert(varchar, convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHJMUfecha#">, 103), 106) || ' #Form.campo2#:#Form.campo21##Form.campo22#'
				if convert(datetime, @hentrada) > convert(datetime, @hsalida) select @hsalida = dateadd(dd, 1, @hsalida)
				
				 <cfif form.RHIid EQ 0 and rsMarcaInconsistencia.RHCMhoraentrada EQ ''><!--- caso en q se requiere la hora de entrada--->
					update RHControlMarcas
					set RHCMhoraentradac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHEntrada#"> <!---@hentrada--->
					where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
				</cfif>	
				<cfif form.RHIid EQ 1 and rsMarcaInconsistencia.RHCMhorasalida EQ ''><!--- caso en q se requiere la hora de salida--->
					update RHControlMarcas
					set RHCMhorasalidac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHSalida#">	<!---@hsalida--->  
					where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
				 
				</cfif>	
				 <!--- (select isnull(RHCMhorasadicautor,0)
														from RHControlMarcas w
														where w.RHCMid = RHCMid) --->
				
				<cfif form.RHIid EQ 4 or form.RHIid EQ 7 or form.RHIid EQ 2><!--- caso en q se requiere horas a agregar --->
					 <!--- <cfif rsMarcaInconsistencia.RHCMhorasadicautor EQ 0> --->
						update RHControlMarcas
						set RHCMhorasadicautor = <cfif isdefined("Form.campo3") and Len(Trim(Form.campo3))>
													<cfqueryparam cfsqltype="cf_sql_float" value="#Form.campo3#"> +
													</cfif>
													(select case w.RHCMhorasadicautor
															when null then 0
															else w.RHCMhorasadicautor end 
													from RHControlMarcas w
													where w.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">)
												 
						where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
					 <!--- </cfif> --->
				 </cfif>	
				
				 <cfif form.RHIid EQ 5 or form.RHIid EQ 6><!--- caso en q se requiere horas a descontar --->
					 <!--- <cfif rsMarcaInconsistencia.RHCMhorasrebajar EQ 0> --->
						update RHControlMarcas
						set RHCMhorasrebajar = <cfif isdefined("Form.campo4") and Len(Trim(Form.campo4))>
													<cfqueryparam cfsqltype="cf_sql_float" value="#Form.campo4#"> +
													</cfif>
													(select case w.RHCMhorasrebajar
															when null then 0
															else w.RHCMhorasrebajar end 
													from RHControlMarcas w
													where w.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">)
												 
						
						where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
					<!--- </cfif> --->
				 </cfif>
				
				<!--- <cfif form.RHIid EQ 3 and rsMarcaInconsistencia.RHCMdialibre EQ 0>
					update RHControlMarcas
					set RHCMdialibre = 1
					where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
				</cfif> --->			 					
			</cfquery>
			---->
			
			<cfquery name="rsUpInconsistencia" datasource="#session.DSN#">
				update RHInconsistencias
				set RHIjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHJMUjustificacion#">,
					 RHIjustificada = 1
				where RHIid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHIid#">
				and RHItipoinconsistencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIid#">
			</cfquery>
			
			<!--- revisa si posee Inconsistencias --->
			<cfquery name="rsUpMar" datasource="#session.DSN#">
				select RHCMid from RHInconsistencias 
				where RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#">
				and RHIjustificada = 0
			</cfquery>
			
			<!--- quita la incons de la marca --->
			<cfif rsUpMar.RecordCount EQ 0>
				<cfquery name="rsUpMar" datasource="#session.DSN#">
					update RHControlMarcas
					set RHCMinconsistencia = 0
					where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcaInconsistencia.RHCMid#"> 
				</cfquery>
			</cfif>
			<!---  --->
		</cfloop>	
	</cftransaction>
	
	<!--- ==============================PROCESO DE GENERACION DE INCIDENCIAS=========================================== --->
	 <cfset RHPMid_U = form.RHPMid>
	
	<cfquery name="rsEmplLote" datasource="#session.DSN#"> <!--- Recoge los empleados en el lote --->
		select distinct(DEid)
		from RHControlMarcas
		where RHPMid = <cfqueryparam value="#RHPMid_U#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfloop query="rsEmplLote">	
		
		<cfset DEid_U = rsEmplLote.DEid>
		
		<!--- Verificacion de si el usuario actual tiene derechos para generar incidencias --->
		<cfquery name="rsPermisoGenIncidencia" datasource="#Session.DSN#">
			select 1
			from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHProcesamientoMarcas b, RHUsuariosMarcas um
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid_U#">
			and a.Ecodigo = lt.Ecodigo
			and a.DEid = lt.DEid
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
			and lt.Ecodigo = r.Ecodigo
			and lt.RHPid = r.RHPid
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPMid_U#">
			and b.Ecodigo = r.Ecodigo
			and b.CFid = r.CFid
			and b.Ecodigo = um.Ecodigo
			and b.CFid = um.CFid
			and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			and um.RHUMgincidencias = 1
		</cfquery>
		
		<!--- Verificacion de si el usuario actual tiene derechos para generar marcas --->
		<cfquery name="rsPermisoGenMarca" datasource="#Session.DSN#">
			select 1
			from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHProcesamientoMarcas b, RHUsuariosMarcas um
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid_U#">
			and a.Ecodigo = lt.Ecodigo
			and a.DEid = lt.DEid
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
			and lt.Ecodigo = r.Ecodigo
			and lt.RHPid = r.RHPid
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPMid_U#">
			and b.Ecodigo = r.Ecodigo
			and b.CFid = r.CFid
			and b.Ecodigo = um.Ecodigo
			and b.CFid = um.CFid
			and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			and um.RHUMtmarcas = 1
		</cfquery> 
		
		<cfif rsPermisoGenMarca.recordCount GT 0 or rsPermisoGenIncidencia.recordCount GT 0> 
			<cfquery name="rsMarcEmplLote" datasource="#session.DSN#"> <!--- recoge marcas por empleado por lote --->
				select *
				from RHControlMarcas
				where RHPMid = <cfqueryparam value="#RHPMid_U#" cfsqltype="cf_sql_numeric">
				and DEid = <cfqueryparam value="#DEid_U#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
			<cfloop query="rsMarcEmplLote">
			
				 <cfset RHCMid_U = rsMarcEmplLote.RHCMid>
				
				 <cfquery name="rsInfo" datasource="#Session.DSN#">
					select 	a.RHCMid, a.RHPMid, a.RHASid, a.DEid, a.RHCMfregistro, a.RHCMfcapturada, a.RHCMtiempoefect, a.RHJid, 
							a.RHCMhoraentrada, a.RHCMhorasalida, a.RHCMhoraentradac, a.RHCMhorasalidac, a.RHCMusuario, 
							a.RHCMjustificacion, a.RHCMusuarioautor, isnull(a.RHCMhorasadicautor, 0.00) as RHCMhorasadicautor, isnull(a.RHCMhorasrebajar, 0.00) as RHCMhorasrebajar, a.RHCMdialibre, 
							a.RHCMinconsistencia, a.BMUsucodigo, a.BMfecha, a.BMfmod, a.ts_rversion,
							case when datepart(hh, a.RHCMhoraentradac) > 12 then datepart(hh, a.RHCMhoraentradac) - 12 when datepart(hh, a.RHCMhoraentradac) = 0 then 12 else datepart(hh, a.RHCMhoraentradac) end as hentrada,
							datepart(mi, a.RHCMhoraentradac) as mentrada,
							case when datepart(hh, a.RHCMhoraentradac) < 12 then 'AM' else 'PM' end as tentrada,
							case when datepart(hh, a.RHCMhorasalidac) > 12 then datepart(hh, a.RHCMhorasalidac) - 12 when datepart(hh, a.RHCMhorasalidac) = 0 then 12 else datepart(hh, a.RHCMhorasalidac) end as hsalida,
							datepart(mi, a.RHCMhorasalidac) as msalida,
							case when datepart(hh, a.RHCMhorasalidac) < 12 then 'AM' else 'PM' end as tsalida,
							b.RHJdescripcion,
							case when c.RHASid is not null then 
									{fn concat(rtrim(c.RHAScodigo),{fn concat(' - ',c.RHASdescripcion)})} 
								else
									''
							end as AccionSeguir					  
					
					from RHControlMarcas a
						inner join RHJornadas b
							on  a.RHJid = b.RHJid
							and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						left outer join RHAccionesSeguir c
							on a.RHASid = c.RHASid
							and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPMid_U#">
						and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHCMid_U#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid_U#">						
				</cfquery> 
				
				<cftransaction>
					<!--- <cftry> --->
						<!--- Averiguar Jornada del Empleado --->
						
						<cfquery name="rsJornada1" datasource="#Session.DSN#">
							select RHJid
							from RHPlanificador
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid_U#">
							and  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInfo.RHCMfcapturada#"> between RHPJfinicio and RHPJffinal
							<!--- and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInfo.RHCMfcapturada#">, 103) between RHPJfinicio and RHPJffinal --->
							
						</cfquery>
						<cfif rsJornada1.recordCount GT 0>
							<cfset jornada = rsJornada1.RHJid>
						<cfelse>
							<cfquery name="rsJornada2" datasource="#Session.DSN#">
								select RHJid
								from LineaTiempo
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid_U#">
								and <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInfo.RHCMfcapturada#"> between LTdesde and LThasta
								<!--- and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInfo.RHCMfcapturada#">, 103) between LTdesde and LThasta --->
							</cfquery>
							<cfset jornada = rsJornada2.RHJid>
						</cfif>
						
						<cfquery name="ABC_ControlMarca" datasource="#Session.DSN#">
							
							update RHControlMarcas set 
								RHCMfcapturada = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInfo.RHCMfcapturada#">, 
								RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#jornada#">,
								RHCMusuarioautor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								RHCMusuario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								
								<cfif isdefined("rsInfo.RHCMhoraentradac") and len(trim(rsInfo.RHCMhoraentradac)) NEQ 0>
									RHCMhoraentradac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsInfo.RHCMhoraentradac#">,
								</cfif>
								
								<cfif isdefined("rsInfo.RHCMhorasalidac")and len(trim(rsInfo.RHCMhorasalidac)) NEQ 0>
								RHCMhorasalidac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsInfo.RHCMhorasalidac#">,
								</cfif>
								
								<cfif (isdefined("rsInfo.RHCMhoraentradac")and len(trim(rsInfo.RHCMhoraentradac)) NEQ 0) and (isdefined("rsInfo.RHCMhorasalidac")and len(trim(rsInfo.RHCMhorasalidac)) NEQ 0)>
								RHCMtiempoefect = datediff(mi, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsInfo.RHCMhoraentradac#">,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsInfo.RHCMhorasalidac#">),
								</cfif>
								
								<cfif isdefined("rsInfo.RHCMjustificacion")and len(trim(rsInfo.RHCMjustificacion)) NEQ 0>
								RHCMjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInfo.RHCMjustificacion#">,
								</cfif>
								
								<cfif isdefined("rsInfo.RHCMhorasadicautor") and Len(Trim(rsInfo.RHCMhorasadicautor))>
									RHCMhorasadicautor = <cfqueryparam cfsqltype="cf_sql_float" value="#rsInfo.RHCMhorasadicautor#">,
								<cfelse>
									RHCMhorasadicautor = null,
								</cfif>
								<cfif isdefined("rsInfo.RHCMhorasrebajar") and Len(Trim(rsInfo.RHCMhorasrebajar))>
									RHCMhorasrebajar = <cfqueryparam cfsqltype="cf_sql_float" value="#rsInfo.RHCMhorasrebajar#">,
								<cfelse>
									RHCMhorasrebajar = null,
								</cfif>
								
								<cfif isdefined("rsInfo.RHCMdialibre")>
									RHCMdialibre = <cfqueryparam  cfsqltype="cf_sql_bit" value="#rsInfo.RHCMdialibre#">
								<cfelse>
									RHCMdialibre = 0
								</cfif>,
								
								<cfif isdefined("rsInfo.RHCMinconsistencia")>
									RHCMinconsistencia = <cfqueryparam  cfsqltype="cf_sql_bit" value="#rsInfo.RHCMinconsistencia#">
								<cfelse>
									RHCMinconsistencia = 0
								</cfif>,
								
								<cfif isdefined("rsInfo.RHASid") and Len(Trim(rsInfo.RHASid))>
									RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInfo.RHASid#">,
								<cfelse>
									RHASid = null,
								</cfif>
								
								BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								BMfmod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							where RHPMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPMid_U#">
							  and RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHCMid_U#">
							  and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid_U#">
					</cfquery> 	
					
				</cftransaction>
				
			</cfloop>
			
		<cfelse>
			<!--- El usuario no posee permisos --->
		</cfif>
	</cfloop> 
	<!--- ==============================FIN DE PROCESO DE GENERACION DE INCIDENCIAS=========================================== --->
		
		<script language="JavaScript1.2" type="text/javascript">
		window.opener.location.reload();
		window.close();
		</script>
		
	<cfelse><!--- Nno hay inconsistencias de ese tipo --->
		<center><table width="100%" height="100%">
			<tr  valign="bottom">
				<td>
					<strong><center><label style="color:##990000; size:7;">
					<cf_translate key="LB_NoExistenInconsistenciasDeEseTipoEnNingunaMarcaDelLote">No existen inconsistencias de ese tipo en ninguna marca del lote.</cf_translate></label></center></strong>
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong><center>
					<input name="Regresar" type="button"  value="#BTN_Regresar#" onClick="Javascript: javascript:history.back();"></center></strong>
				</td>
			</tr>
		</table>
	</center>
	</cfif>
</cfif> 
</cfoutput>	