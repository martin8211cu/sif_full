<cfif isdefined("form.btnEliminar_Todas")><!---BORRAR INCIDENCIA---->
			<cfquery datasource="#session.DSN#">
				delete from IMPIncidentes
			</cfquery>
			
<cfelseif isdefined("form.btnEliminar")><!---BORRAR INCIDENCIA---->
		<cfif isdefined("form.chk") and len(trim(form.chk)) >
			<cfloop list="#form.chk#" index="i">
					<cfquery datasource="#session.DSN#">
						delete IMPIncidentes
						where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">				
					</cfquery>
			</cfloop>
		</cfif>


<cfelseif isdefined("form.btnAplicar") or isdefined("form.btnAplicar_Todas") >	
<!----APLICAR INCIDENCIA--->
		<cfif isdefined("form.btnAplicar_Todas")><!--- en el caso que desee aplicar todas--->
				<cfquery name="todasLasIncidencias" datasource="#session.dsn#">
						select Id from IMPIncidentes
				</cfquery>
				<cfset form.chk=valueList(todasLasIncidencias.Id,',')>	
		</cfif>
		
		<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso"><!--- Permite validar el acceso según parametrizacion 2526--->
		
		<!--- Averiguar rol. -1=Ninguno, 0=Usuario, 1=Jefe, 2=Administrador, 3=Ayudante de administrador --->
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getRol" returnvariable="rol"/>	
		<!---Si el rol es de Administrador, averigua si es Admin de RH--->
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="esAdministradorRH" returnvariable="esAdminRH"/>	
			
		<cftransaction>
			<cfloop list="#form.chk#" index="Id">		
					<cfquery name="rsDatosConcepto" datasource="#Session.DSN#">
							select  b.CIrango,
									coalesce(b.CItipo,'m') as CItipo,
									b.CIdia,
									b.CImes,
									b.CIcalculo,
									c.Ifecha,
									coalesce(b.CIcantidad,12) as CIcantidad,
									c.DEid,
									coalesce(c.RHJid,1) as RHJid,
									(select Tcodigo from LineaTiempo x
									 where x.DEid = c.DEid and LThasta = (select max(y.LThasta) from LineaTiempo y where y.DEid = x.DEid))  as Tcodigo
									,c.DEid, c.CIid, c.CFid, c.Ifecha, c.Ifechasis
									,c.Usucodigo, c.Ulocalizacion, c.RCNid, c.Icpespecial, c.IfechaRebajo 	
									,coalesce(c.Ivalor,0) as Ivalor
									,coalesce(c.Imontores,0) as Imontores
									, b.CIsprango
									, coalesce(b.CIspcantidad,0) as CIspcantidad
									, Iobservacion
							from IMPIncidentes c	
								inner join CIncidentes a
									on c.CIid = a.CIid
								left outer join CIncidentesD b
									on a.CIid = b.CIid
							where c.Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Id#">				
					</cfquery>
					<cfif rsDatosConcepto.RecordCount NEQ 0>
						<!--- debe aprobar incidencias tipo calculo --->
						<cfset aprobarIncidenciasCalc = false >
						<cfquery name="rs_apruebacalc" datasource="#session.DSN#">
							select Pvalor
							from RHParametros
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and Pcodigo = 1060
						</cfquery>
						<cfif trim(rs_apruebacalc.Pvalor) eq 1 >
							<cfset aprobarIncidenciasCalc = true >
						</cfif>
						
						<!---<cf_dump var="#LSnumberFormat(rsDatosConcepto.Imontores,'9999999999.00')#">--->
						<cfquery name="rsIncidencias" datasource="#session.DSN#">
							insert into Incidencias ( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, RCNid, Icpespecial, IfechaRebajo, Imonto, 
							 NAP, usuCF, Iestadoaprobacion, Iestado,Iingresadopor
							,Iobservacion )
							values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosConcepto.DEid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosConcepto.CIid#">,
									<cfif len(trim(rsDatosConcepto.CFid))>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosConcepto.CFid#">,
									<cfelse>	
										null,
									</cfif>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosConcepto.Ifecha#">,
								   <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatosConcepto.Ivalor#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									<cfif len(trim(rsDatosConcepto.Usucodigo))>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosConcepto.Usucodigo#">,
									<cfelse>
										null,
									</cfif>
									<cfif len(trim(rsDatosConcepto.Ulocalizacion))>
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosConcepto.Ulocalizacion#">,
									<cfelse>
										null,
									</cfif>	
									<cfif len(trim(rsDatosConcepto.RCNid))>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosConcepto.RCNid#">,
									<cfelse>
										null,
									</cfif>
									<cfif len(trim(rsDatosConcepto.Icpespecial))>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosConcepto.Icpespecial#">,
									<cfelse>
										0,
									</cfif>
									<cfif len(trim(rsDatosConcepto.IfechaRebajo))>
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosConcepto.IfechaRebajo#">,
									<cfelse>
										null,
									</cfif>
									
									<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatosConcepto.Imontores#">
									
									<cfif esAdminRH or not aprobarIncidenciasCalc>
										, 400, null, null,1,#rol#		<!---NAP, usuCF, Iestadoaprobacion, Iestado,Iingresadopor--->
									<cfelseif rol EQ 2>
										, null,#session.usucodigo#,2,0,#rol#
									<cfelse>
										, null, null, null,0,#rol#
									</cfif>	
									<cfif isdefined("rsDatosConcepto.Iobservacion") and len(trim(rsDatosConcepto.Iobservacion))>
										,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosConcepto.Iobservacion#">
									<cfelse>
										,null
									</cfif>
									)
						</cfquery>
						
						<!---proceso de aprobacion de incidencias automatico, si es administrador o no requieren de aprobacion de incidencias, se auto aprueban--->
						
						<cfif esAdminRH or not aprobarIncidenciasCalc>
							
							<!---Nuevas incidencias agregadas--->
							<cfquery name="rsIids" datasource="#session.DSN#">
								select distinct a.Iid 
								from Incidencias a 
								inner join DatosEmpleado b
									on b.DEid = a.DEid
								inner join CIncidentes c
									on c.CIid = a.CIid
								left outer  join CFuncional d
									on d.CFid = a.CFid
								left outer  join RHJornadas f
									on f.RHJid = a.RHJid
								inner join IMPIncidentes e
									on e.Ifecha = a.Ifecha  
									and e.Icpespecial = a.Icpespecial
									and e.Ivalor = a.Ivalor
									and e.DEid=b.DEid 
									and e.CIid=c.CIid
							</cfquery>
							<!---<cfdump var="#rsIids#">
							<!---<cf_dumptable var="IMPIncidentes">--->
							<cfquery name="rsTemps" datasource="#session.DSN#">
								select Ifecha,Icpespecial,Ivalor,DEid,CIid
								from  IMPIncidentes 
							</cfquery>
							<cfdump var="#rsTemps#">--->
							
							<!---valida que la cantidad de Ids seleccionados sean igual al numero de incidencias agregadas--->
							<cfif rsIids.recordCount GT 0>
							
								<!---Genera el consecutivo--->
								<cfset consecutivo = 1 >
								<cfquery name="rs_consecutivo" datasource="#session.DSN#">
									select Pvalor
									from RHParametros
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									  and Pcodigo = 1020
								</cfquery>
								<cfif len(trim(rs_consecutivo.Pvalor)) and isnumeric(rs_consecutivo.Pvalor) >
									<cfset consecutivo = rs_consecutivo.Pvalor + 1 >
								</cfif>
								<!---Actualiza las nuevas incidencias con el num de documento ya que son auto aprobadas, para que sean tomadas en cuenta en la nomina--->
								<cfloop query="rsIids">
									<cfset vNAP = randrange(1, 100000) >
									<cfquery datasource="#session.DSN#">
										update Incidencias 
										set	Iusuaprobacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
											,Ifechaaprobacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
											,Inumdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">
											,NAP = <cfqueryparam cfsqltype="cf_sql_integer" value="#vNAP#">
										where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIids.Iid#">
									 </cfquery>
									 <cfset consecutivo = consecutivo + 1 >
								</cfloop>
								<!---Actualiza los parametros con el ultimo consecutivo--->
								<cfquery datasource="#session.DSN#">
									update RHParametros
									set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#consecutivo#">
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									  and Pcodigo = 1020
								</cfquery>
							
							<cfelse>
								<cftransaction action="rollback">
							</cfif>
							
						</cfif>	
						
						<cfquery datasource="#session.DSN#">
							delete IMPIncidentes
							where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Id#">				
						</cfquery>
					
					</cfif>
					
				</cfloop>
				
			</cftransaction>
	</cfif>
<cfelseif isdefined("form.btnRecalcular") or isdefined("form.btnRecalcular_Todas") ><!--- permite recalcular todos las incidencias--->
			<cfif isdefined("form.btnRecalcular_Todas")><!--- en el caso que desee aplicar todas--->
					<cfquery name="todasLasIncidencias" datasource="#session.dsn#">
							select Id from IMPIncidentes
					</cfquery>
					<cfset form.chk=valueList(todasLasIncidencias.Id,',')>	
			</cfif>
		
		<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso"><!--- Permite validar el acceso según parametrizacion 2526--->

		<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!---Para utilizar la calculadora--->
			<cfloop list="#form.chk#" index="Id">		
				
				<cfquery name="rsDatosConcepto" datasource="#Session.DSN#"><!---Obtener datos de la incidencia, requeridos por la calculadora--->
							select 	b.CIrango,
									coalesce(b.CItipo,'m') as CItipo,
									b.CIdia,
									b.CImes,
									b.CIcalculo,
									c.Ifecha,
									coalesce(b.CIcantidad,12) as CIcantidad,
									c.DEid,
									coalesce(c.RHJid,1) as RHJid,
									(select Tcodigo from LineaTiempo x
									 where x.DEid = c.DEid and LThasta = (select max(y.LThasta) from LineaTiempo y where y.DEid = x.DEid))  as Tcodigo
									,c.DEid, c.CIid, c.CFid, c.Ifecha, c.Ifechasis
									,c.Usucodigo, c.Ulocalizacion, c.RCNid, c.Icpespecial, c.IfechaRebajo 	
									,c.Ivalor
									, b.CIsprango
									, coalesce(b.CIspcantidad,0) as CIspcantidad
							from IMPIncidentes c	
								inner join CIncidentes a
									on c.CIid = a.CIid
								left outer join CIncidentesD b
									on a.CIid = b.CIid
							where c.Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Id#">				
						</cfquery>

			
				<cfif rsDatosConcepto.RecordCount NEQ 0>		
					<!------------------------------------------------->
				<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
				<cfset current_formulas = rsDatosConcepto.CIcalculo>
	
				<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
											   LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
											   rsDatosConcepto.CIcantidad,<!---CIcantidad--->																	  
											   rsDatosConcepto.CIrango, <!---CIrango--->
											   rsDatosConcepto.CItipo, <!---CItipo--->
											   rsDatosConcepto.DEid,	<!---DEid--->
											   rsDatosConcepto.RHJid, <!---RHJid--->
											   session.Ecodigo, <!---Ecodigo--->
											   0, <!---RHTid--->
											   0, <!---RHAlinea--->																		   
											   rsDatosConcepto.CIdia, <!---CIdia--->
											   rsDatosConcepto.CImes,<!---CImes--->
											   rsDatosConcepto.Tcodigo,<!---Tcodigo--->
											   FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
											   'false', <!---masivo--->
											   '',<!---tabla_temporal--->
											   0,<!---calc_diasnomina--->
											   rsDatosConcepto.Ivalor,
											   '', 
											   rsDatosConcepto.CIsprango,
											   rsDatosConcepto.CIspcantidad
											   )>
					<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
			                		
               
						<cfif Not IsDefined("values") or not isdefined("presets_text")>												
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_NoEsPosibleRealizarElCalculo"
								Default="No es posible realizar el calculo"
								XmlFile="/rh/generales.xml"
								returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
							<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
						</cfif>
						<!----------------- Fin de calculadora ------------------->		

						<cfquery name="rsIncidencias" datasource="#session.DSN#">
							update IMPIncidentes
							set Imontores=<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">
								where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Id#">			
						</cfquery>	

				</cfif>		
			
			</cfloop>	
	</cfif>	<!--- fin de check--->
	
</cfif>	<!---final--->
<cflocation url="listadoImportadosIncidenciasCalculo.cfm">
