    <!--- 
	Creado por Gustavo Fonseca H.
	Fecha: 16-4-2005.
	Motivo: Requerimiento de importación de notas.
	--->

<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<!--- *****Áreas***** ---> 
<cfif isdefined("form.chk")>
	<cfset ListaAgregadosE = "">
	<cfloop index="LvarAreas" list="#Form.chk#" delimiters=",">
		<cfset LvarCAC = #ListToArray(LvarAreas, "|")#><!--- LvarCAC = CalificaAreaConcursante --->
		<cfset LvarPos1RHDAlinea= LvarCAC[1]>
		<cfset LvarPos2RHCAONota = LvarCAC[2]>
		<cfset LvarPos3RHEAid = LvarCAC[3]>
		<!--- RHDAlinea: <cfdump var="#LvarPos1RHDAlinea#">,
		RHCAONota: <cfdump var="#LvarPos2RHCAONota#">, --->		

		<!--- ¿existe la area en ese concurso? --->
		<cfquery name="rsValida1" datasource="#session.DSN#">
			select RHEAid 
			from RHAreasEvalConcurso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				and RHEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos3RHEAid#">
		</cfquery>
		<!--- ¿existe la evaluacion para esa area en ese concurso? --->
		<!--- <cfquery name="rsValida2" datasource="#session.DSN#">
			select a.RHDAlinea 
			from RHDAreasEvaluacion a
				inner join RHAreasEvalConcurso b
					on b.RHEAid = a.RHEAid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				and a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos3RHEAid#">
		</cfquery> --->
		
		<!--- Si hay una RHDAlinea en esta tabla quiere decir que ya fue calificado y que no hay que hacer el insert. --->
		<cfquery name="rsExitenNotas" datasource="#session.DSN#">
			select count(1) as rs
			from RHCalificaAreaConcursante
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1RHDAlinea#">
				and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
		</cfquery>
		
		<!--- Si esxite el area para el concurso pero no ha sido calidicada. --->
		<cfif rsValida1.recordcount EQ 1 and rsExitenNotas.rs EQ 0><!--- and  rsValida1.recordcount EQ 1 --->
			<cfif Not ListContains(ListaAgregadosE, LvarPos1RHDAlinea, ',')>
				<cftransaction>
					<cfquery name="rsInsert" datasource="#Session.DSN#">
						insert into RHCalificaAreaConcursante (Ecodigo, RHCPid, RHCconcurso, RHDAlinea, RHCAONota, BMUsucodigo) 
						values (	
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1RHDAlinea#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2RHCAONota#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
								)
					</cfquery> 
				</cftransaction> 
				<cfset ListaAgregadosE = ListaAgregadosE & Iif(Len(Trim(ListaAgregadosE)), DE(","), DE("")) & LvarPos1RHDAlinea>
			</cfif>

		<!--- Si el area para exite el concurso y ya fue evaluada (Se hace Update) --->
		<cfelseif rsValida1.recordcount EQ 1 and rsExitenNotas.rs EQ 1>
			<cfif Not ListContains(ListaAgregadosE, LvarPos1RHDAlinea, ',')>
				<cftransaction>
					<cfquery name="rsInsert" datasource="#Session.DSN#">
						update RHCalificaAreaConcursante 
						set RHCAONota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2RHCAONota#">
						where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
							and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
							and RHDAlinea =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1RHDAlinea#">
					</cfquery> 
				</cftransaction> 
				<cfset ListaAgregadosE = ListaAgregadosE & Iif(Len(Trim(ListaAgregadosE)), DE(","), DE("")) & LvarPos1RHDAlinea>
			</cfif>
			

		<!--- Si no existe esa área para ese concurso la inserta en el concurso con todos los valores del área y se le inserta la calificación al concursante --->
		<cfelseif rsValida1.recordcount EQ 0>
			<cftransaction>
				<cfquery name="rsInsert" datasource="#session.DSN#">
					insert into RHAreasEvalConcurso (RHCconcurso, RHEAid, Ecodigo, RHAECpeso, Usucodigo, BMUsucodigo)
						select <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">, RHEAid, Ecodigo, RHEApeso, Usucodigo, BMUsucodigo
						from RHEAreasEvaluacion 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and RHEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos3RHEAid#">
				</cfquery>
			</cftransaction>
			<cfif Not ListContains(ListaAgregadosE, LvarPos1RHDAlinea, ',')>
				<cftransaction>
					<cfquery name="rsInsert" datasource="#Session.DSN#">
						insert into RHCalificaAreaConcursante (Ecodigo, RHCPid, RHCconcurso, RHDAlinea, RHCAONota, BMUsucodigo) 
						values (	
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1RHDAlinea#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2RHCAONota#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
								)
					</cfquery> 
				</cftransaction> 
				<cfset ListaAgregadosE = ListaAgregadosE & Iif(Len(Trim(ListaAgregadosE)), DE(","), DE("")) & LvarPos1RHDAlinea>
			</cfif>
		</cfif>
	</cfloop>	
</cfif>
 
 
<!---  <cf_dump var="#form#"> --->
<!--- *****Pruebas***** --->
<cfif isdefined("form.chk_Pruebas")>
	<cfset ListaAgregadosD = "">
	<cfloop index="LvarPruebas" list="#Form.chk_Pruebas#" delimiters=",">
		<cfset LvarCPC = #ListToArray(LvarPruebas, "|")#> <!--- LvarCPC = CalificaPruebasConcursante--->
		<cfset LvarPos1RHPcodigopr = LvarCPC[1]>
		<cfset LvarPos2RHCPCNota = LvarCPC[2]>
		<cfset LvarPos3RHCconcurso = LvarCPC[3]>
		<!--- RHPcodigopr: <cfdump var="#LvarPos1RHPcodigopr#">,
		RHCPCNota: <cfdump var="#LvarPos2RHCPCNota#">, --->
		
		<!--- ¿Existen las pruebas para ese concurso? --->
		<cfquery name="rsValida3" datasource="#session.DSN#">
			select RHPcodigopr 
			from RHPruebasConcurso 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarPos1RHPcodigopr#">
		</cfquery>
		<!--- Si hay una RHPcodigopr en esta tabla quiere decir que ya fue calificado y que no hay que hacer el insert. --->
		<cfquery name="rsExitenNotasPrue" datasource="#session.DSN#">
			select count(1) as rs
			from RHCalificaPrueConcursante
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarPos1RHPcodigopr#">
				and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
		</cfquery>
		
		<cfif rsValida3.recordcount GT 0 and rsExitenNotasPrue.rs EQ 0>
			<cfif Not ListContains(ListaAgregadosD, LvarPos1RHPcodigopr, ',')>
				 <cftransaction>
					<cfquery name="rsInsert" datasource="#Session.DSN#">
						insert into RHCalificaPrueConcursante (Ecodigo, RHCPid, RHCconcurso, RHPcodigopr, RHCPCNota, BMUsucodigo) 
						values (	
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#LvarPos1RHPcodigopr#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2RHCPCNota#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
								)
					</cfquery> 
				</cftransaction>
				<cfset ListaAgregadosD = ListaAgregadosD & Iif(Len(Trim(ListaAgregadosD)), DE(","), DE("")) & LvarPos1RHPcodigopr>
			</cfif>
		<!--- Si existe esa prueba para ese concurso y ya fue calificada (Se hace Update) --->
		<cfelseif rsValida3.recordcount GT 0 and rsExitenNotasPrue.rs EQ 1>
			<cfif Not ListContains(ListaAgregadosD, LvarPos1RHPcodigopr, ',')>
				 <cftransaction>
					<cfquery name="rsUpdate" datasource="#session.DSN#">
						update RHCalificaPrueConcursante
							set RHCPCNota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2RHCPCNota#">
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarPos1RHPcodigopr#">
							and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
							and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
					</cfquery>
				</cftransaction>
				<cfset ListaAgregadosD = ListaAgregadosD & Iif(Len(Trim(ListaAgregadosD)), DE(","), DE("")) & LvarPos1RHPcodigopr>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
	

<script language="JavaScript" type="text/javascript">
	if (window.opener.funcRefrescar) {window.opener.funcRefrescar()}
	window.close();
</script>	
	
