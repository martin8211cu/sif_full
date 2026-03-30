<!---Averiguar el DEid del usuario logueado---->
<cfquery name="rsDEid" datasource="#session.DSN#">
	select llave as DEid
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		and STabla = 'DatosEmpleado'
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">	
</cfquery>
<cfif isdefined("form.BTNAplicar")>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cftransaction>
		<cfloop list="#form.chk#" index="i">
			<cfquery name="rsEvaluados" datasource="#session.DSN#">
				select a.DEid  
				from RHRegistroEvaluadoresE  a
				inner join RHEmpleadoRegistroE b
					on a.REid = b.REid
					and a.DEid = b.DEid
					and b.DEidjefe = <cfqueryparam cfsqltype="cf_sql_numeric" value=" #rsDEid.DEid#">
				where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			<!---Calculo de la nota final   --->
			<!---Paso 1 NO notas que contempladas sobre el 100%   --->
			<cfset vn_notafinal = 0>
			<cfloop query="rsEvaluados">
				<cfset vn_notafinal = 0>
				<!--- VERIFICA SI ELEMPLEADO A EVALUAR ES JEFE Y DE ESTA MANERA ASIGNA EL PESO --->
				<cfquery name="rsEsJefe" datasource="#session.DSN#">
					select EREjefeEvaluador
					from RHEmpleadoRegistroE
					where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluados.DEid#"> 
				</cfquery>
				<cfset vb_esjefe = rsEsJefe.EREjefeEvaluador>
				<cfquery name="rsNoCien" datasource="#session.DSN#">	
					select 	
					<cfif vb_esjefe>
						coalesce(sum(c.CDENotaj)/sum(d.IREpesojefe),0) as nota
					<cfelse>
						coalesce(sum(c.CDENotaj)/sum(d.IREpesop),0) as nota
					</cfif>
					
					from RHRegistroEvaluacion a
						inner join RHRegistroEvaluadoresE b
							on a.REid = b.REid 
							and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluados.DEid#">
					
						inner join RHConceptosDelEvaluador c
							on b.REEid =c.REEid
					
							inner join RHIndicadoresRegistroE d
								on c.IREid = d.IREid
								and d.IREsobrecien = 0
														
							inner join RHIndicadoresAEvaluar e
								on d.IAEid = e.IAEid
								and e.IAEtipoconc = 'T'
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
						and a.REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				</cfquery>
				<cfif rsNoCien.RecordCount NEQ 0>
						<cfset vn_notafinal = vn_notafinal + rsNoCien.nota>
				</cfif>
				<!---Paso 2 notas que contempladas sobre el 100%   --->
				<cfquery name="rsCien" datasource="#session.DSN#">	
						select 	coalesce(sum(coalesce(f.TEVequivalente,0)),0)  as nota		
						from RHRegistroEvaluacion a
							inner join RHRegistroEvaluadoresE b
								on a.REid = b.REid 
								and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluados.DEid#">
						
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
										and <cf_dbfunction name="to_char" args="c.CDERespuestaj"> = <cf_dbfunction name="to_char" args="f.TEVvalor">
								
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
							and a.REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					</cfquery>
					<cfif rsCien.RecordCount NEQ 0>
						<cfset vn_notafinal = vn_notafinal + rsCien.nota>
					</cfif>	
					<!---Actualiza la nota final---->
					<cfquery datasource="#session.DSN#">
						update RHRegistroEvaluadoresE
							set REENotaj = <cfqueryparam cfsqltype="cf_sql_integer" value="#vn_notafinal#">,
								REEfinalj  = 1
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
							and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluados.DEid#">
					</cfquery>	
			</cfloop>
			<!---queda pendiente el cambio de estado---->		
		</cfloop>
		</cftransaction>
	</cfif>
</cfif>
<cflocation url="EvaluacionJefe-lista.cfm">