<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FaltanPreguntasPorResponder"
	Default="Faltan preguntas por responder"
	returnvariable="MSG_FaltanPreguntasPorResponder"/>
<cfset action = 'autoevaluacion_empleado-lista.cfm'>

<!---====================================================================================---->
<!---funcGuardaRespuestas: Función para actualizar las respuestas de la evaluacion y la  ---->
<!---y la nota correspondiente 															 ---->
<!---====================================================================================---->
<cffunction name="funcGuardaRespuestas" output="true">
	<cfargument name="CDEid" type="string" required="yes">
	<cfargument name="REid" type="numeric" required="yes">
	<cfargument name="DEid" type="numeric" required="yes"><!---LLaves de la tabla RHConceptosDelEvaluador---->
	<cfif isdefined("arguments.CDEid") and len(trim(arguments.CDEid))>
		<!---Verificar si el empleado es jefe ---->
		<cfloop list="#arguments.CDEid#" index="i">
			<!---Ver que tipo de concepto es (Abierto o Cerrado)---->
			<cfquery name="rsTipo" datasource="#session.DSN#">
				select c.IAEtipoconc, c.IAEdescripcion
				from RHConceptosDelEvaluador a
					inner join RHIndicadoresRegistroE b
						on a.IREid = b.IREid					
					inner join RHIndicadoresAEvaluar c
						on b.IAEid = c.IAEid													
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.CDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			<cfif rsTipo.IAEtipoconc EQ 'T'>
				<cfif isdefined("form.Valor#i#") and len(trim(form["Valor#i#"]))>
					<!---Obtener los valores del combo----->
					<cfquery name="TRaePeso" datasource="#session.DSN#">
						select DEid,coalesce(c.IREpesop,0) as IREpesop,coalesce(c.IREpesojefe,0) as IREpesojefe  from 
							RHConceptosDelEvaluador  a
							inner join RHRegistroEvaluadoresE b
							on a.REEid = b.REEid
							inner join RHIndicadoresRegistroE c
							on a.REid = c.REid
							and a.IREid  = c.IREid 
						where CDEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					</cfquery>
					<cfset Peso = 0>
					<!--- CONSULTA DEL EMPLEADO PARA VERIFICAR SI ES UN JEFE EVALUADOR --->
					<cfquery name="rsEsJefe" datasource="#session.DSN#">
						select EREjefeEvaluador as Jefe
						from RHEmpleadoRegistroE
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.REid#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					</cfquery>
					<cfif rsEsJefe.Jefe>
						<cfset Peso =  TRaePeso.IREpesojefe >
					<cfelse>
						<cfset Peso =  TRaePeso.IREpesop >
					</cfif>
					<cfquery name="rsValor" datasource="#session.DSN#">
						select coalesce((coalesce(TEVequivalente,0) * #Peso#),0) as Nota
						from RHConceptosDelEvaluador a
							inner join RHIndicadoresRegistroE b
								on a.IREid = b.IREid	
							inner join TablaEvaluacionValor c
								on b.TEcodigo = c.TEcodigo
								and c.TEVvalor = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form['Valor#i#']#">
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.CDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					</cfquery>												
				</cfif>
				<cfif isdefined("form.Valor#i#")>
					<!---Actualizar la respuesta, cuando es combo se guarda el valor del concepto (TablaEvaluacionValor.TEVvalor)---->				
					<cfquery datasource="#session.DSN#">
						update RHConceptosDelEvaluador							
							set 
								<cfif isdefined("form.Valor#i#") and len(trim(form["Valor#i#"]))>
									CDERespuestae = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form['Valor#i#']#">,
									CDENotae = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValor.Nota#">
								<cfelse>
									CDERespuestae = null,
									CDENotae = null
								</cfif>
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and CDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					</cfquery>				
				</cfif>
			<cfelseif rsTipo.IAEtipoconc EQ 'A'>
				<cfif isdefined("form.CDERespuestae#i#")>
					<!---Actualizar la respuesta, cuando es textarea se guarda la respuesta digitada---->				
					<cfquery datasource="#session.DSN#">
						update RHConceptosDelEvaluador
							set CDERespuestae = <cfif len(trim(form["CDERespuestae#i#"]))>
													<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form['CDERespuestae#i#']#">
												<cfelse>
													null
												</cfif>
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and CDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					</cfquery>
				</cfif>		
			</cfif>
		</cfloop>
	</cfif>
</cffunction>
<!----================ GUARDAR RESPUESTAS =====================---->
<cfif isdefined("form.btnGuardar")>
	<cfif isdefined("form.DEid") and len(trim(form.DEid)) and isdefined("form.REid") and len(trim(form.REid))>
		<cfset action = 'autoevaluacion_empleado.cfm?DEid=#form.DEid#&REid=#form.REid#'>
	</cfif>
	<cfif isdefined("form.CDEid") and len(trim(form.CDEid))>
		<cfset funRespuestas = funcGuardaRespuestas(form.CDEid,form.REid,form.DEid)>
	</cfif>	
<!----================== EVALUA/APLICA LAS RESPUESTAS (SACA LA NOTA) ========================---->
<cfelseif isdefined("form.btnAplicar")>
	<cfset vn_notafinal = 0>
	<!---Si NO viene de la lista carga en form.chk el valor de la evaluacion (REid)---->
	<cfif isdefined("form.REid") and len(trim(form.REid)) and (not isdefined("form.chk") or len(trim(form.chk)) EQ 0)>
		<cfset form.chk = form.REid>
	</cfif>
	<cfif isdefined("form.chk") and len(trim(form.chk)) and isdefined("form.DEid") and len(trim(form.DEid))>
		<cfloop list="#form.chk#" index="cont">			
			<!---Obtener las preguntas de la evaluacion del empleado--->
			<cfquery name="rsDatos" datasource="#session.DSN#">
				select 	c.CDEid
				from RHRegistroEvaluacion a
					inner join RHRegistroEvaluadoresE b
						on a.REid = b.REid 
						and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				
					inner join RHConceptosDelEvaluador c
						on b.REEid =c.REEid
				
						inner join RHIndicadoresRegistroE d
							on c.IREid = d.IREid

				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
					and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cont#">
					and a.REaplicaempleado = 1		
			</cfquery>
			<cfset form.CDEid = ValueList(rsDatos.CDEid)><!---Cargarlas en una variable separadas por coma--->
			<cfif isdefined("form.CDEid") and len(trim(form.CDEid))><!---LLamar funcion que guarda respuestas y calcula nota---->
				<cfset funRespuestas = funcGuardaRespuestas(form.CDEid,cont,form.DEid)>
			</cfif>	
			<!---Verificar que se hayan respondido las preguntas----->
			<cfquery name="rsVerifica" datasource="#session.DSN#">				
				select 	1		
				from RHRegistroEvaluacion a
					inner join RHRegistroEvaluadoresE b
						on a.REid = b.REid 
						and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				
					inner join RHConceptosDelEvaluador c
						on b.REEid =c.REEid
						and <cf_dbfunction name="to_char" args="CDERespuestae"> is null
				
						inner join RHIndicadoresRegistroE d
							on c.IREid = d.IREid
					
						inner join RHIndicadoresAEvaluar e
							on d.IAEid = e.IAEid
							and e.IAEtipoconc = 'T'
								
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cont#">					
					and a.REaplicaempleado = 1
			</cfquery>
			<cfif rsVerifica.RecordCount EQ 0>				
				<!---Obtener los datos---->
				<cfquery name="rsNoCien" datasource="#session.DSN#">	
					select 	coalesce(sum(c.CDENotae)/sum(d.IREpesop),0) as nota
					from RHRegistroEvaluacion a
						inner join RHRegistroEvaluadoresE b
							on a.REid = b.REid 
							and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					
						inner join RHConceptosDelEvaluador c
							on b.REEid =c.REEid
					
							inner join RHIndicadoresRegistroE d
								on c.IREid = d.IREid
								and d.IREsobrecien = 0
														
							inner join RHIndicadoresAEvaluar e
								on d.IAEid = e.IAEid
								and e.IAEtipoconc = 'T'
									
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
						and a.REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#cont#">
						and a.REaplicaempleado = 1
				</cfquery>	
				<cfif rsNoCien.RecordCount NEQ 0>
					<cfset vn_notafinal = vn_notafinal + rsNoCien.nota>
				</cfif>
				<cfquery name="rsCien" datasource="#session.DSN#">	
					select 	coalesce(sum(coalesce(f.TEVequivalente,0)),0)  as nota				
					from RHRegistroEvaluacion a
						inner join RHRegistroEvaluadoresE b
							on a.REid = b.REid 
							and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					
						inner join RHConceptosDelEvaluador c
							on b.REEid =c.REEid
					
							inner join RHIndicadoresRegistroE d
								on c.IREid = d.IREid
								and d.IREsobrecien = 1
						
								inner join RHIndicadoresAEvaluar e
									on d.IAEid = e.IAEid
									and e.IAEtipoconc = 'T'
									
								left outer join TablaEvaluacionValor f
									on d.TEcodigo = f.TEcodigo
									and <cf_dbfunction name="to_char" args="c.CDERespuestae"> = <cf_dbfunction name="to_char" args="f.TEVvalor">
							
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
					  and a.REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#cont#">
					  and a.REaplicaempleado = 1
				</cfquery>
				
				<cfif rsCien.RecordCount NEQ 0>
					<cfset vn_notafinal = vn_notafinal + rsCien.nota>
				</cfif>	
				<!---Actualiza la nota final---->
				<cfquery datasource="#session.DSN#">
					update RHRegistroEvaluadoresE
						set REENotae = <cfqueryparam cfsqltype="cf_sql_integer" value="#vn_notafinal#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
						and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cont#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				</cfquery>		
				<!---Actualiza el estado---->				
				<cfquery datasource="#session.DSN#">
					update RHRegistroEvaluadoresE
						set REEfinale = 1
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
						and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cont#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				</cfquery>
			<cfelse>
				<cf_throw message="#MSG_FaltanPreguntasPorResponder#" errorcode="8055">
			</cfif>
		</cfloop>		
	</cfif>
</cfif>
<cflocation url="#action#">