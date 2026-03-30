<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("form.btnAceptar")>
			<!--- Areas --->
			<cfloop collection="#Form#" item="i">
				<cfif FindNoCase("Peso_", i) NEQ 0>
					<cfset linea = Mid(i, 6, Len(i))>
					<cfif Len(Trim(Evaluate('Form.RHCAOid_'&linea)))>
						<!--- Update --->
						<cfquery name="UpdCalificacionesAreas" datasource="#session.DSN#">
							update RHCalificaAreaConcursante 
								set RHCAONota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.peso_'&linea),',','','all')#" scale="2">
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and RHCAOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHCAOid_'&linea)#">
						</cfquery>
					<cfelse>
						<!--- Insert --->
						<cfquery name="InsCalificacionesAreas" datasource="#session.DSN#">
							insert INTO RHCalificaAreaConcursante (RHCPid, Ecodigo, RHCconcurso, RHDAlinea, BMUsucodigo, RHCAONota)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHDAlinea_'&linea)#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.peso_'&linea),',','','all')#" scale="2">
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
			
			<!--- PRUEBAS --->
			<cfloop collection="#Form#" item="e">
				<cfif FindNoCase("Pesa_", e) NEQ 0>
					<cfset linea2 = Mid(e, 6, Len(e))>
					<cfif Len(Trim(Evaluate('Form.RHCPCid_'&linea2)))>
						<!--- Update --->
						<cfquery name="UpdCalificacionesPruebas" datasource="#session.DSN#">
							update RHCalificaPrueConcursante 
							set RHCPCNota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.pesa_'&trim(linea2))#" scale="2">
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and RHCPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHCPCid_'&trim(linea2))#">
						</cfquery>
					<cfelse>
						<!--- Insert --->
						<cfquery name="InsCalificacionesPruebas" datasource="#session.DSN#">
							insert into RHCalificaPrueConcursante (RHCPid, RHCconcurso, Ecodigo, RHPcodigopr, RHCPCNota, BMUsucodigo)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">,  
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('Form.Idcompa_'&trim(linea2))#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.pesa_'&trim(linea2))#" scale="2">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
			
		</cfif>
	</cfif>

</cftransaction>

<cfquery name="rsConsulta" datasource="#session.DSN#">
	select e.id, e.descripcion, e.Tipo,
		   round(sum(b.RHCPCNota* a.Peso) / 100.00,2) as Peso_Obtenido_pruebas, 
		   sum(a.Peso) as Suma_Peso_Pruebas_Concurso
	from RHCalificaPrueConcursante b
	
		inner join RHPruebasConcurso a
			on a.RHCconcurso = b.RHCconcurso
			and a.Ecodigo = b.Ecodigo
			and a.RHPcodigopr = b.RHPcodigopr

		inner join RHPruebasCompetencia c	
			on c.Ecodigo = a.Ecodigo
			and c.RHPcodigopr = a.RHPcodigopr

		inner join RHCompetenciasConcurso d
			on d.RHCconcurso = b.RHCconcurso
			and d.Idcompetencia = c.id
			and d.tipocompetencia = c.RHPCtipo

		inner join RHCompetencias e
			on e.Ecodigo = a.Ecodigo
		    and e.id = d.Idcompetencia
			and e.Tipo = d.tipocompetencia

		inner join RHPruebas f
			on f.Ecodigo = a.Ecodigo
			and f.RHPcodigopr = a.RHPcodigopr

	where b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	and b.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	group by e.id, e.descripcion, e.Tipo
</cfquery>

<cfif isdefined("rsConsulta") and rsConsulta.RecordCount GT 0>
	<cfset nota = 0>
	<cfloop query="rsConsulta">
		<cfif rsConsulta.Suma_Peso_Pruebas_Concurso NEQ 0>
			<cfset nota = (rsConsulta.Peso_Obtenido_pruebas / rsConsulta.Suma_Peso_Pruebas_Concurso) * 100>
		<cfelse>
			<cfset nota = 0>
		</cfif>
		
		<!--- Averiguar si el registro existe --->
		<cfquery name="rsRHCalificaCompPrueOfer" datasource="#Session.DSN#">
			select RHCCOid
			from RHCalificaCompPrueOfer
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
			and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			and Idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.id#">
			and tipocompetencia = <cfqueryparam cfsqltype="cf_sql_char" value="#rsConsulta.Tipo#">
		</cfquery>
		
		<!--- Modo ALTA --->
		<cfif rsRHCalificaCompPrueOfer.recordCount EQ 0>
			<cfquery datasource="#session.DSN#">
				insert into RHCalificaCompPrueOfer (Ecodigo, RHCPid, RHCconcurso, Idcompetencia, tipocompetencia, RHCCONota, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">,  
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.id#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsConsulta.Tipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#DecimalFormat(nota)#" scale="2">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery> 

		<!--- Modo CAMBIO --->
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update RHCalificaCompPrueOfer
					set RHCCONota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DecimalFormat(nota)#" scale="2">
				where RHCCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHCalificaCompPrueOfer.RHCCOid#">
			</cfquery>
		</cfif>
		
	</cfloop>
</cfif>  


<!--- CALCULO DE LA NOTA FINAL DEL CONCURSANTE --->
<cfquery name="sumCompetencias" datasource="#Session.DSN#">
	select coalesce(sum(((a.RHCCONota * b.RHCPpeso) / 100.0)),0) as SumNotaObt, coalesce(sum(b.RHCPpeso),0) as SumPeso
	from RHCalificaCompPrueOfer a
	
		inner join RHCompetenciasConcurso b
			on b.Ecodigo = a.Ecodigo
			and b.RHCconcurso = a.RHCconcurso
			and b.Idcompetencia = a.Idcompetencia
			and b.tipocompetencia = a.tipocompetencia
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	and a.RHCPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCPid#">
</cfquery>


<cfquery name="rsAreas" datasource="#Session.DSN#">
	select c.RHEAid, c.RHEApeso as Peso, sum(a.RHCAONota) / count(a.RHCAONota) as NotaObt
	from RHCalificaAreaConcursante a
	
		inner join RHDAreasEvaluacion b
			on b.RHDAlinea = a.RHDAlinea
			and b.Ecodigo = a.Ecodigo
	
		inner join RHEAreasEvaluacion c
			on c.RHEAid = b.RHEAid
			and c.Ecodigo = b.Ecodigo
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	and a.RHCPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCPid#">
	group by c.RHEAid, c.RHEApeso
</cfquery>

<cfquery name="sumAreas" dbtype="query">
	select sum(((NotaObt * Peso) / 100.0)) as SumNotaObt, sum(Peso) as SumPeso
	from rsAreas
</cfquery>

<!--- Actualización de la Nota Final del Concursante --->
<cfset sumObtenido = 0>
<cfif sumCompetencias.recordCount>
	<cfset sumObtenido = sumObtenido + sumCompetencias.SumNotaObt>
</cfif>
<cfif sumAreas.recordCount>
	<cfset sumObtenido = sumObtenido + sumAreas.SumNotaObt>
</cfif>

<cfset sumPeso = 0>
<cfif sumCompetencias.recordCount>
	<cfset sumPeso = sumPeso + sumCompetencias.SumPeso>
</cfif>
<cfif sumAreas.recordCount>
	<cfset sumPeso = sumPeso + sumAreas.SumPeso>
</cfif>
<cfif sumPeso EQ 0>
	<cfset sumPeso = 1>
</cfif>

<cfset NotaFinal = (sumObtenido / sumPeso) * 100>

<cfquery datasource="#session.DSN#">
	update RHConcursantes
	set RHCPpromedio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NotaFinal#" scale="2">,
		RHCevaluado = 1
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	and RHCPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCPid#">
</cfquery>
