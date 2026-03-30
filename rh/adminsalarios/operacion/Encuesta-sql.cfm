<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="insertEnc" datasource="sifpublica">
				insert Encuesta 
					(EEid, Edescripcion, Efechaanterior, Efecha, BMUsucodigo, BMfechaalta)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">, 
					<cfif isdefined('form.Efechaanterior') and len(trim(form.Efechaanterior))>
						<cfqueryparam value="#LSParseDateTime(form.Efechaanterior)#" cfsqltype="cf_sql_timestamp">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam value="#LSParseDateTime(form.Efecha)#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertEnc">
		</cftransaction>

		<cfif isdefined('form.MONEDAIDLIST') and form.MONEDAIDLIST NEQ ''>
			<cfloop list="#form.MONEDAIDLIST#" index = "index_moneda">
				<cfquery name="EncSalInsert" datasource="sifpublica">
					insert into EncuestaSalarios(EEid,ETid,Eid,EPid,EScantobs,ESp25,ESp50,ESp75,
												 ESpromedioanterior,ESpromedio,ESvariacion,BMUsucodigo,BMfechaalta,Moneda)
						Select 
							ep.EEid,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#"> as ETid,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertEnc.identity#"> as Eid,
							ep.EPid,
							0,0,0,0,0,0,0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#index_moneda#">
						from EncuestaPuesto ep
							inner join EncuestaEmpresa ee
								on ee.EEid=ep.EEid
						where ep.EEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
				</cfquery>
			</cfloop>
		</cfif>

		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="sifpublica"
						table="Encuesta"
						redirect="datosEncuestas-proceso.cfm"
						timestamp="#form.ts_rversion#"
						field1="Eid" 
						type1="numeric" 
						value1="#form.Eid#">	
						
		<cfquery datasource="sifpublica">
			update Encuesta set 
				EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
				Edescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">,
				<cfif isdefined('form.Efechaanterior') and len(trim(form.Efechaanterior))>
					Efechaanterior = <cfqueryparam value="#LSParseDateTime(form.Efechaanterior)#" cfsqltype="cf_sql_timestamp">,
				<cfelse>
					Efechaanterior = null,
				</cfif>				
				Efecha = <cfqueryparam value="#LSParseDateTime(form.Efecha)#" cfsqltype="cf_sql_timestamp">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
		</cfquery>
		
		<cfquery datasource="sifpublica">
			update EncuestaSalarios set
				EEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">,
				ETid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
		</cfquery>

		<cfset modo="CAMBIO">		
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="Area" datasource="sifpublica">
			delete from EncuestaSalarios
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
		</cfquery>
		
		<cfquery name="Area" datasource="sifpublica">
			delete from Encuesta
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
		</cfquery>
				
		<cfset modo="BAJA">			
	<cfelseif isdefined("Form.CambioInfoEnc")>
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("Obs_", i) NEQ 0>
				<cfset linea = Mid(i, 5, Len(i))>
				<cfquery name="EncDatosInsert" datasource="sifpublica">
					Update EncuestaSalarios
					Set EScantobs = <cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(Evaluate('Form.Obs_'&linea),',','','All')#">,
						ESp25 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESp25_'&linea),',','','All')#">,
						ESp50 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESp50_'&linea),',','','All')#">,
						ESp75 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESp75_'&linea),',','','All')#">,
						ESpromedioanterior = <cfqueryparam cfsqltype="cf_sql_numeric" 
															value="#Replace(Evaluate('Form.ESpromedioanterior_'&linea),',','','All')#">,
						ESpromedio = <cfqueryparam cfsqltype="cf_sql_numeric" 
													value="#Replace(Evaluate('Form.ESpromedio_'&linea),',','','All')#">,
						ESvariacion = <cfqueryparam cfsqltype="cf_sql_float" 
													value="#Replace(Evaluate('Form.ESvariacion_'&linea),',','','All')#">,
						BMfechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where ESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.ESid_'&linea)#">
				</cfquery>
			</cfif>
		</cfloop>

		<cfset modo="CAMBIO">	
	</cfif>
</cfif>

<form action="datosEncuestas-proceso.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
			
		<cfif isdefined("Form.Eid") and isDefined("Form.Cambio")>
			<input name="Eid" type="hidden" value="#Form.Eid#">
			<input name="Paso" type="hidden" value="1">	
		<cfelseif  isDefined("Form.Nuevo")>
			<input name="Paso" type="hidden" value="1">		
		<cfelseif  isdefined("Form.Eid") and isDefined("Form.CambioInfoEnc")>
			<input name="Eid" type="hidden" value="#Form.Eid#">
			
			<cfif isdefined('form.Mcodigo_F') or isdefined('form.EAid_F')>
				<input name="Ver" type="hidden" value="Ver Datos">
				
				<cfif isdefined('form.Mcodigo_F') and form.Mcodigo_F NEQ ''>
					<input name="Mcodigo_F" type="hidden" value="#form.Mcodigo_F#">	
				</cfif>
				<cfif isdefined('form.EAid_F') and form.EAid_F NEQ ''>
					<input name="EAid_F" type="hidden" value="#form.EAid_F#">
				</cfif>						
			</cfif>
			
			<input name="Paso" type="hidden" value="2">	
		<cfelseif  isDefined("Form.Alta")>			
			<input name="Paso" type="hidden" value="1">	
			<input name="Eid" type="hidden" value="#insertEnc.identity#">
		<cfelse>	
			<input name="Paso" type="hidden" value="0">	
		</cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	</cfoutput>
</form>

<html>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>