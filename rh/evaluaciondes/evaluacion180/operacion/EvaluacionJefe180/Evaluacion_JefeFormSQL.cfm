<cfif isdefined('form.BTNAplicar') or isdefined('form.BTNAplicar2')>
	<cftransaction>
		<!---Averiguar el DEid del usuario logueado---->
		<cfquery name="rsDEid" datasource="#session.DSN#">
			select llave as DEid
			from UsuarioReferencia
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and STabla = 'DatosEmpleado'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">	
		</cfquery>			
		<cfquery name="rsEvaluados" datasource="#session.DSN#">
			select a.DEid  
			from RHRegistroEvaluadoresE  a
			inner join RHEmpleadoRegistroE b
				on a.REid = b.REid
				and a.DEid = b.DEid
				and b.DEidjefe = <cfqueryparam cfsqltype="cf_sql_numeric" value=" #rsDEid.DEid#">
			where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
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
				where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
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
					and a.REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
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
						and a.REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
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
						and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluados.DEid#">
				</cfquery>	
		</cfloop>
		<!---queda pendiente el cambio de estado---->		
	</cftransaction>
	<!--- SE REDIRECCIONA DE ESTA MANERA PORQUE SE ESTA TRABAJANDO SOBRE UN IFRAME --->
	<script>
		 window.parent.location.href = "EvaluacionJefe-lista.cfm";
	</script>
<cfelse>
	<cfquery name="RSEvaluaciones" datasource="#session.DSN#">
		select CDEid,d.IAEtipoconc
		from RHRegistroEvaluadoresE a 
		inner join RHConceptosDelEvaluador b
			on   a.REid = b.REid
			and  a.REEid = b.REEid
			inner join RHIndicadoresRegistroE c
			on b.IREid = c.IREid
			inner join RHIndicadoresAEvaluar d
			on c.IAEid = d.IAEid
		where  a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfloop query="RSEvaluaciones">
		<cfif isdefined("form.RES_#RSEvaluaciones.CDEid#") and len(trim(form["RES_#RSEvaluaciones.CDEid#"]))>
			<cfif RSEvaluaciones.IAEtipoconc eq 'T'> 
				<cfquery name="TRaePeso" datasource="#session.DSN#">
					select DEid,coalesce(c.IREpesop,0) as IREpesop,coalesce(c.IREpesojefe,0) as IREpesojefe  from 
						RHConceptosDelEvaluador  a
						inner join RHRegistroEvaluadoresE b
						on a.REEid = b.REEid
						inner join RHIndicadoresRegistroE c
						on a.REid = c.REid
						and a.IREid  = c.IREid 
					where CDEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSEvaluaciones.CDEid#">
				</cfquery>
				<cfset Peso = 0>
				<!--- VERIFICA SI ELEMPLEADO A EVALUAR ES JEFE Y DE ESTA MANERA ASIGNA EL PESO --->
				<cfquery name="rsEsJefe" datasource="#session.DSN#">
					select EREjefeEvaluador
					from RHEmpleadoRegistroE
					where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TRaePeso.DEid#"> 
				</cfquery>
				<cfset vb_esjefe = rsEsJefe.EREjefeEvaluador>
				<cfif vb_esjefe>
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
							and c.TEVvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form['RES_#RSEvaluaciones.CDEid#'])#"> 
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.CDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSEvaluaciones.CDEid#">
				</cfquery>
				<cfif rsValor.RecordCount gt 0 >
					<cfset nota  = rsValor.Nota>
				<cfelse>
					<cfset nota = 0>
				</cfif>
			<cfelse>
				<cfset nota = 0>
			</cfif>
			<cfquery datasource="#session.DSN#">
				update RHConceptosDelEvaluador
					set CDERespuestaj  = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form['RES_#RSEvaluaciones.CDEid#']#">,
					CDENotaj = <cfqueryparam cfsqltype="cf_sql_integer" value="#nota#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSEvaluaciones.CDEid#">
			</cfquery>
		</cfif>
	</cfloop>
	<cfset param ="">
	<cfif isdefined("form.CursorPreguntas") and len(trim(form.CursorPreguntas)) gt 0>
		<cfif isdefined("form.botonSelx") and ((form.botonSelx EQ "btnSiguiente") or (form.botonSelx EQ "btnAnterior"))>
				<cfset CURSORPREGUNTAS = form.CURSORPREGUNTAS >
		<cfelse>
				<cfset CURSORPREGUNTAS = (form.CURSORPREGUNTAS - form.MOSTRANDO) + 1>
		</cfif>
		<cfset param = param & "&CURSORPREGUNTAS=#CURSORPREGUNTAS#">
	</cfif>
	<cfif isdefined("form.PERSONAS") and len(trim(form.PERSONAS))>
		<cfset param = param & "&PERSONAS=#form.PERSONAS#">
	</cfif>
	<cfif isdefined('form.RHPcodigo')>
		<cfset param = param & "&RHPcodigo=#form.RHPcodigo#">
	</cfif>
	<cflocation url="Evaluacion_JefeForm.cfm?REid=#form.REid#&paso=#form.paso##param#">

</cfif>