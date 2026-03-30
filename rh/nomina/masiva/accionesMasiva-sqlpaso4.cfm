<cfif isdefined("Form.DAMAlta")>
	<cfif isdefined("Form.RHAid") and Len(Trim(Form.RHAid)) >
		<cfif Form.opcion EQ 1>
			<!--- Inserciones para los Centros Funcionales --->
			<!--- Inserta  el Centro Funcional sin Dependencias --->
			<cfquery name="rsCentroFuncional" datasource="#Session.DSN#">
				select RHAid, CFid, Ecodigo, BMUsucodigo 
				from RHDepenAccionM 
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
			</cfquery>
			
			<cfif rsCentroFuncional.recordcount EQ 0 >
				<cfquery name="insertCentroFuncional" datasource="#Session.DSN#">
					insert into RHDepenAccionM (RHAid, CFid, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					)				
				</cfquery>
			</cfif>

			<cfif isdefined("Form.CFdependencias") >
				<!--- Selecciona el Path del Centro Funcional --->
				<cfquery name="selectPathCF" datasource="#Session.DSN#">
					select CFpath
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
				</cfquery>
				<!--- Inserta las Dependencias del Centro Funcional --->
				<cfquery name="insertCentroFuncionalDep" datasource="#Session.DSN#">
					insert into RHDepenAccionM (RHAid, CFid, Ecodigo, BMUsucodigo)
					select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">,
							CFid, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(selectPathCF.CFpath)#/%">
					and not exists (
						select 1
						from RHDepenAccionM x
						where x.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
						and x.CFid = CFuncional.CFid
					)
				</cfquery>
			</cfif>
			
		<cfelseif Form.opcion EQ 2>
			<!--- Inserta Oficina/Departamento --->
			<cfquery name="rsOficinaDepto" datasource="#Session.DSN#">
				select RHAid, Dcodigo, Ocodigo, Ecodigo, BMUsucodigo
				from RHDepenAccionM
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
					and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
					and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
			</cfquery>

			<cfif rsOficinaDepto.recordcount EQ 0 >
				<cfquery name="insertOficinaDepto" datasource="#Session.DSN#">
					insert into RHDepenAccionM (RHAid, Dcodigo, Ocodigo, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					)				
				</cfquery>
			</cfif>
						
		<cfelseif Form.opcion EQ 3>
			<!--- Inserta Tipo de Puesto --->
			<cfquery name="rsPuesto" datasource="#Session.DSN#">
				select RHAid, RHPcodigo, Ecodigo, BMUsucodigo
				from RHDepenAccionM
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
					and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
			</cfquery>

			<cfif rsPuesto.recordcount EQ 0 >
				<cfquery name="insertPuesto" datasource="#Session.DSN#">
					insert into RHDepenAccionM (RHAid, RHPcodigo, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					)				
				</cfquery>
			</cfif>
			
		<cfelseif Form.opcion EQ 4>
			<!--- Inserta Empleados --->
			<cfquery name="rsEmpleados" datasource="#Session.DSN#">
				select RHAid, DEid, Ecodigo, BMUsucodigo
				from RHDepenAccionM
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>
		
			<cfif rsEmpleados.recordcount EQ 0 >
				<cfquery name="insertEmpleados" datasource="#Session.DSN#">
					insert into RHDepenAccionM (RHAid, DEid, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					)				
				</cfquery>
			</cfif>
		<cfelse>
			<!--- Inserta los tipos de puestos --->
			
			<cfquery name="rsTipoPuesto" datasource="#Session.DSN#">
				select RHAid, RHTPid, Ecodigo, BMUsucodigo
				from RHDepenAccionM
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTPid#">
			</cfquery>
		
			<cfif rsTipoPuesto.recordcount EQ 0 >
				<cfquery name="insertEmpleados" datasource="#Session.DSN#">
					insert into RHDepenAccionM (RHAid, RHTPid, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTPid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
							
							
					)				
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	
<cfelseif isdefined("Form.DAMAccion") and Form.DAMAccion EQ "BAJA">
	<cfif isdefined("Form.RHDAMid") and Len(Trim(Form.RHDAMid)) >
		<cfquery name="delDependencia" datasource="#Session.DSN#">
			delete RHDepenAccionM
			where RHDAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAMid#">
		</cfquery>
	</cfif>	


<!------ GENERACION DE EMPLEADOS ------->	
<cfelseif isdefined("Form.btnGenerar")>
	<cfif isdefined ('form.RHAid') and len(trim(form.RHAid)) gt 0>
		<cfquery  name="rsData" datasource="#session.dsn#">
			select RHAfdesde from RHAccionesMasiva where RHAid = #form.RHAid#
		</cfquery>
		<cfset LvarFecha=#rsData.RHAfdesde#>
	<cfelse>
		<cfset LvarFecha=#now()#>
	</cfif>
	
	<cfif isdefined('form.RHAnua') and form.RHAnua gt 0>	
		<cfquery name="inEmpleados" datasource="#session.dsn#">
			insert into RHDepenAccionM (RHAid, DEid, Ecodigo, BMUsucodigo,Fcorte)
				select #form.RHAid#,
						e.DEid,
						#session.Ecodigo#,
						#session.Usucodigo#,
						#now()#	
						
				from EAnualidad e
					inner join DatosEmpleado d
					on d.DEid=e.DEid
					and d.Ecodigo=#session.Ecodigo#
					inner join LineaTiempo c
					on  d.Ecodigo = c.Ecodigo
					and d.DEid = c.DEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between c.LTdesde and c.LThasta	
				where 
				e.Ecodigo=#session.Ecodigo#
				and EAacum >= 345
				and EAacum <= 360
				and e.DAtipoConcepto=2
				 and d.DEid not in (select DEid from RHDepenAccionM where RHAid=#form.RHAid#
                            and DEid in (select DEid from EAnualidad e where e.Ecodigo=1 and EAacum >= 345 and EAacum <= 360 and e.DAtipoConcepto= 2 ))
					
		</cfquery>

	</cfif>
	<cfsetting requesttimeout="84600">
	<cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="generarEmpleados" returnvariable="LvarResult">
		<cfinvokeargument name="RHAid" value="#Form.RHAid#"/>
	</cfinvoke>
								
	<cfset Form.paso = 5>

</cfif>
