<cfif isdefined ('form.AgregaDet')>
	<cfquery name="rsUp" datasource="#session.dsn#">
		update RHEmpleadoCurso set
		RHECjust='#form.just#'
		where RHCid=#form.RHCid#
		and DEid=#form.DEid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
		<script language="JavaScript1.2">
				window.close();
			</script>
</cfif>
<!--- Se asignan los valores que vienen por URL a FORM --->
<cfif isdefined("url.btnEliminar") and not isdefined("Form.btnEliminar")>
	<cfset Form.btnEliminar = url.btnEliminar>
</cfif>
<cfif isdefined("url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = url.DEid>
</cfif>
<cfif isdefined("url.RHCid") and not isdefined("Form.RHCid")>
	<cfset Form.RHCid = url.RHCid>
</cfif>
<cfif isdefined("url.RHCcodigo") and not isdefined("Form.RHCcodigo")>
	<cfset Form.RHCcodigo = url.RHCcodigo>
</cfif>
<cfif isdefined("url.RHCnombre") and not isdefined("Form.RHCnombre")>
	<cfset Form.RHCnombre = url.RHCnombre>
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("Form.Mcodigo")>
	<cfset Form.Mcodigo = url.Mcodigo>
</cfif>

<cfif isdefined("Form.btnAgregar")>		
	<cfloop list="#form.DEid#" index="i">
		<cfquery name="insert" datasource="#Session.DSN#">
			update RHEmpleadoCurso
				set RHEMnotamin = <cfif isdefined("form.RHEnotamin") and len(trim(form.RHEnotamin))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEnotamin#"><cfelse>0</cfif>,
					RHEMnota = <cfif isdefined("form.RHEMnota_#i#") and len(trim(form["RHEMnota_#i#"]))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHEMnota_#i#']#"><cfelse>null</cfif>
					<!---RHEMestado = <cfif isdefined("form.RHEMnota_#i#") and len(trim(form["RHEMnota_#i#"]))>
									<cfif form["RHEMnota_#i#"] GTE form.RHEnotamin>
										10
									<cfelseif form["RHEMnota_#i#"] LTE form.RHEnotamin>
									 	20
									<cfelse>
										0
									</cfif>
								<cfelse>
									0
								</cfif>			--->					
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">			
		</cfquery>
	</cfloop>
	<cfset modo="ALTA">	
	
<cfelseif isdefined("form.btnEliminar")>
	<cfquery name="updateStatus" datasource="#Session.DSN#">
		update RHEmpleadoCurso
			set RHEStatusCurso = 0
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">			
	</cfquery>
	<cfset modo="CAMBIO">
	
</cfif>

<cfoutput>
<form action="calificaciones.cfm" method="post" name="sql">
    <input name="RHCid" type="hidden" value="#form.RHCid#">
    <input name="Mcodigo" type="hidden" value="#form.Mcodigo#">
	<cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo))>
		<input name="RHCcodigo" type="hidden" value="#form.RHCcodigo#">
	</cfif>
	<cfif isdefined("form.RHCnombre") and len(trim(form.RHCnombre))>
		<input name="RHCnombre" type="hidden" value="#form.RHCnombre#">
	</cfif>
	<!--- <cfif isdefined("form.RHCid") and len(trim(form.RHCid))>#form.RHCid#</cfif> --->
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>


<cfif isdefined("Form.btnFinalizar")>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">	
<cftransaction>	
	<cfloop list="#form.DEid#" index="i">
		<cfquery name="insert" datasource="#Session.DSN#">
			update RHEmpleadoCurso
				set RHEMnotamin = <cfif isdefined("form.RHEnotamin") and len(trim(form.RHEnotamin))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEnotamin#"><cfelse>0</cfif>,
					RHEMnota = <cfif isdefined("form.RHEMnota_#i#") and len(trim(form["RHEMnota_#i#"]))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHEMnota_#i#']#"><cfelse>null</cfif>,
					RHEMestado = <cfif isdefined("form.RHEMnota_#i#") and len(trim(form["RHEMnota_#i#"]))>
									<cfif form["RHEMnota_#i#"] GTE form.RHEnotamin>
										10
									<cfelseif form["RHEMnota_#i#"] LTE form.RHEnotamin>
									 	20
									<cfelse>
										0
									</cfif>
								<cfelse>
									0
								</cfif>								
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">			
		</cfquery>
	</cfloop>
	<!---Verifica si el curso cobra si se pierde--->
	<cfquery name="rsCurso" datasource="#session.dsn#">
		select RHECcobrar,RHCnombre,RHCfdesde,RHECtotempleado from RHCursos where 
		RHCid=#form.RHCid#
	</cfquery>

	<!---Se buscan los empleados que perdieron los cursos--->
	<cfif isdefined ('rsCurso') and rsCurso.RHECcobrar eq 1>
		<cfquery name="rsEmp" datasource="#session.dsn#">
			select * from RHEmpleadoCurso where RHEMestado=20
			and RHCid=#form.RHCid#
		</cfquery>
		
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2110" default="" returnvariable="LvarTDid"/>
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2108" default="" returnvariable="LvarCuotas"/>
		
		<cfif LvarCuotas gt 0>
			<cfset monto = rsCurso.RHECtotempleado/LvarCuotas>
		<cfelse>
			<cfset monto = rsCurso.RHECtotempleado>
		</cfif>
		
	<!---Se ingresan las deducciones--->
			<cfloop query="rsEmp">
					<cfquery name="ABC_Insdeducciones" datasource="#Session.DSN#">
						insert Into DeduccionesEmpleado ( DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, Dmetodo, Dvalor, Dfechaini, Dfechafin, 
													 Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, Usucodigo, Ulocalizacion, Dactivo, 
													 Dcontrolsaldo, Dreferencia  )
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="9999">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTDid#">,
							'Por perdida de curso'#LvarCNCT# '#rsCurso.RHCnombre#',
							1,
							<cfqueryparam cfsqltype="cf_sql_money" value="#monto#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(rsCurso.RHCfdesde)#">,
							null,
							#rsCurso.RHECtotempleado#,
							0,
							#rsCurso.RHECtotempleado#,
							0, 
							1,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
							1,
							1,
							null
						)	
				</cfquery>
			</cfloop>
	</cfif>
</cftransaction>
<cflocation url="calificaciones.cfm">
</cfif>
