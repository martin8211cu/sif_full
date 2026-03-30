<cfif isdefined("url.Borrar")><!---BORRAR INCIDENCIA---->
	<cfif isdefined("url.IDEliminar") and len(trim(url.IDEliminar))>
		<cfquery datasource="#session.DSN#">
			delete TMP_Incidentes
			where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDEliminar#">				
		</cfquery>
	</cfif>
<cfelse><!----APLICAR INCIDENCIA--->
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
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
				from TMP_Incidentes c	
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
											   rsDatosConcepto.Ivalor
											   , '' 
											   ,rsDatosConcepto.CIsprango
											   ,rsDatosConcepto.CIspcantidad
											   )>
				<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
                
                
<!--- ljimenez dumpear volores importados
	            <br>Importe><cfdump var="#values.get('importe').toString()#"></br>
                <br>Resultado<cfdump var="#values.get('resultado').toString()#"></br>
                <br>Cantidad<cf_dump var="#values.get('cantidad').toString()#"></br>
--->				
                
				<cfif Not IsDefined("values") or not isdefined("presets_text")>												
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_NoEsPosibleRealizarElCalculo"
						Default="No es posible realizar el clculo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
					<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
				</cfif>
				<!----------------- Fin de calculadora ------------------->		
				<!--- Actualiza Incidencias --->	

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
				<cfquery name="rsIncidencias" datasource="#session.DSN#">
					insert into Incidencias ( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, RCNid, Icpespecial, IfechaRebajo, Imonto, Iestado, NAP)
					values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosConcepto.DEid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosConcepto.CIid#">,
							<cfif len(trim(rsDatosConcepto.CFid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosConcepto.CFid#">,
							<cfelse>	
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosConcepto.Ifecha#">,
							<!---<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatosConcepto.Ivalor#">,--->
                            <cfqueryparam cfsqltype="cf_sql_money" value="#values.get('cantidad').toString()#">,
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
							<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">
							<cfif aprobarIncidenciasCalc>
								, 0, null
							<cfelse>
								, 1, 400
							</cfif>	)
				</cfquery>	
				<cfquery datasource="#session.DSN#">
					delete TMP_Incidentes
					where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Id#">				
				</cfquery>
			</cfif>
		</cfloop>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DebeSeleccionarAlmenosUnaIncidencia"
			Default="Debe seleccionar al menos una incidencia"
			returnvariable="LB_DebeSeleccionarAlmenosUnaIncidencia"/>
		<cfoutput><cf_throw message="#LB_DebeSeleccionarAlmenosUnaIncidencia#" errorCode="1155"></cfoutput>
	</cfif>
</cfif>
<cflocation url="listadoImportadosIncidenciasCalculo.cfm">