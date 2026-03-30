<!---   <cf_dump var="#form#"> ---> 
		<!--- <cf_dump var="#Arreglo_RHCPCid#"> --->
<cftransaction>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("form.ALTA")>
		<cfset linea="">
		<cfset linea2="">
		<cfset Arreglo_RHCPCid = arraynew(1)>
		<cfset contador1 = 0>
		<!--- Areas --->
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("Peso_", i) NEQ 0>
				<cfset linea = Mid(i, 6, Len(i))>
				<cfquery name="rsConsultaCA" datasource="#session.DSN#">
					select 1
					from RHCalificaAreaConcursante
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
					  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
					  and RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHDAlinea_'&linea)#">
				</cfquery>
				<cfif rsConsultaCA.recordCount GT 0>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg= La Calificacion para el area ya existe. Verifique." 
					addtoken="no">
				<cfabort> 
				</cfif>
				<cfquery name="InsCalificacionesAreas" datasource="#session.DSN#">
					insert INTO RHCalificaAreaConcursante 
					(RHCPid, Ecodigo, RHCconcurso, RHDAlinea, BMUsucodigo, RHCAONota)
					values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHDAlinea_'&linea)#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.peso_'&linea)#">
						   )
				</cfquery>
			</cfif>
		</cfloop>
		<!--- PRUEBAS --->
		<cfloop collection="#Form#" item="e">
			<cfif FindNoCase("Pesa_", e) NEQ 0>
				<cfset linea2 = Mid(e, 6, Len(e))>
				<cfset contador1 = contador1 + 1>
				<cfquery name="InsCalificacionesPruebas" datasource="#session.DSN#">
					insert  INTO RHCalificaPrueConcursante 
					(RHCPid, RHCconcurso, Ecodigo, RHPcodigopr, RHCPCNota, BMUsucodigo)
					values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">,  
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('Form.Idcompa_'&lcase(trim(linea2)))#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.pesa_'&lcase(trim(linea2)))#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						   )
				</cfquery>
			</cfif>
		</cfloop>
		<cfset modo = "CAMBIO">
		
	<cfelseif isdefined("Form.CAMBIO")>
		<cfset linea="">
		<cfset linea2="">
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("Peso_", i) NEQ 0>
				<cfset linea = Mid(i, 6, Len(i))>
				<cfquery name="UpdCalificacionesAreas" datasource="#session.DSN#">
					update RHCalificaAreaConcursante 
					set RHCAONota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.peso_'&linea)#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHCAOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHCAOid_'&linea)#">
				</cfquery>
			</cfif>
		</cfloop>

		<cfloop collection="#Form#" item="e">
			<cfif FindNoCase("Pesa_", e) NEQ 0>
				<cfset linea2 = Mid(e, 6, Len(e))>
				<cfquery name="InsCalificacionesPruebas" datasource="#session.DSN#">
					update RHCalificaPrueConcursante 
					set RHCPCNota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.pesa_'&lcase(trim(linea2)))#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHCPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHCPCid_'&lcase(trim(linea2)))#">
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
</cfif>
</cftransaction>
<cfset modo = "CAMBIO">

<form action="capturanotas.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input type="hidden" name="RHCconcurso"  value="<cfif isdefined("Form.RHCconcurso")>#Form.RHCconcurso#</cfif>">
		<input type="hidden" name="RHCPid" value="<cfif isDefined("Form.RHCPid") and len(trim(#Form.RHCPid#)) NEQ 0>#Form.RHCPid#</cfif>">
	 	<input type="hidden" name="NOMBRE" value="<cfif isDefined("form.NOMBRE")>#form.NOMBRE#</cfif>">
	 	<input type="hidden" name="IDENTIFICACION" value="<cfif isDefined("form.IDENTIFICACION")>#form.IDENTIFICACION#</cfif>">
		<input type="hidden" name="Ecodigo" value="<cfif isDefined("Form.Ecodigo")>#Form.Ecodigo#</cfif>">
	</cfoutput>
</form>

<cfquery name="rsConsulta" datasource="#session.DSN#">
	select  e.id, e.descripcion,
		round(sum(b.RHCPCNota* a.Peso) / 100.00,2) as Peso_Obtenido_pruebas, e.Tipo,
		sum(a.Peso) as Suma_Peso_Pruebas_Concurso
	from RHPruebasConcurso a
		inner join RHCalificaPrueConcursante b
			on  a.RHPcodigopr = b.RHPcodigopr

		inner join RHPruebasCompetencia c	
			on a.RHPcodigopr = c.RHPcodigopr
			and a.Ecodigo = c.Ecodigo
			and a.RHPcodigopr = c.RHPcodigopr
			and c.id = e.id
			and c.RHPCtipo = e.Tipo

		inner join RHCompetenciasConcurso d
			on a.RHCconcurso = d.RHCconcurso
			and c.id = d.Idcompetencia
			and c.RHPCtipo = d.tipocompetencia

		inner join RHCompetencias e
			on a.Ecodigo = e.Ecodigo

		inner join RHPruebas f
			on a.Ecodigo = f.Ecodigo
			and a.RHPcodigopr = f.RHPcodigopr

	where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		and b.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	group by e.id, e.descripcion, e.Tipo
</cfquery>

<cfif isdefined("rsConsulta") and rsConsulta.RecordCount GT 0>
	<cfset codigo = "">
	<cfset codigo2 = "">
	<cfset Peso_Obtenido_pruebas = "">
	<cfset suma_pesos = "">
	<cfset contador = 0>
	<cfset arreglo_Peso_Obtenido = arraynew(1)>
	<cfset arreglo_suma_pesos = arraynew(1)>
	<cfset arreglo_NOTA = arraynew(1)>
	 <!--- <cfquery name="rsConsultaCCPO" datasource="#session.DSN#">
		select 1
		from RHCalificaCompPrueOfer
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	</cfquery>
	<cfif rsConsultaCCPO.recordCount GT 0>
	<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg= La Calificacion para las competencias del oferente ya existe. Verifique." 
		addtoken="no">
	<cfabort>  
	
	</cfif> --->

	<cfloop query="rsConsulta">
		<cfset Peso_Obtenido_pruebas = rsConsulta.Peso_Obtenido_pruebas>
		<cfset Suma_Peso_Pruebas_Concurso = rsConsulta.Suma_Peso_Pruebas_Concurso>
		<cfset contador = contador + 1>
		<cfset arreglo_Peso_Obtenido[contador] = rsConsulta.Peso_Obtenido_pruebas>
		<cfset arreglo_Suma_Peso_Pruebas_Concurso[contador] = rsConsulta.Suma_Peso_Pruebas_Concurso>
		<cfif arreglo_Suma_Peso_Pruebas_Concurso[contador] NEQ 0>
		   <cfset arreglo_NOTA[contador] = (arreglo_Peso_Obtenido[contador] / arreglo_Suma_Peso_Pruebas_Concurso[contador]) * 100>
	    <cfelse>
		   <cfset arreglo_NOTA[contador] = 0>
		</cfif>

		
		<cfif isdefined("Form.ALTA")>
			<cfquery datasource="#session.DSN#">
				insert into RHCalificaCompPrueOfer
					(Ecodigo, RHCPid, RHCconcurso, Idcompetencia, tipocompetencia, RHCCONota, BMUsucodigo)
				values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">,  
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.id#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsConsulta.Tipo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#DecimalFormat(evaluate(arreglo_NOTA[contador]))#" scale="2">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
			</cfquery> 
		

		<cfelseif isdefined("Form.CAMBIO")>
		<cfquery datasource="#session.DSN#">
				update RHCalificaCompPrueOfer
					set RHCCONota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DecimalFormat(evaluate(arreglo_NOTA[contador]))#" scale="2">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
					and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			</cfquery> 
		</cfif>
	</cfloop>
	
		 <!--- <cfdump var="#form#">
	    <cfdump var="#arreglo_NOTA#">
		<cfdump var="#arreglo_Peso_Obtenido#">
		<cf_dump var="#arreglo_Suma_Peso_Pruebas_Concurso#">  --->
</cfif>  


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>