<cfif isdefined("Form.btnGuardar")>
	<!--- Modo CAMBIO --->
	<cfif isdefined("Form.RHASid") and Len(Trim(Form.RHASid))>

		<cfquery name="rsUpdateASalarial" datasource="#Session.DSN#">
			update RHASalarial set
				EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
				RHASdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHASdescripcion#">,
				ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">, 
				Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">, 
				Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
				<cfif isdefined("Form.NoSalario")>
					NoSalario = 1,
				<cfelse>
					NoSalario = 0,
				</cfif>
				RHASref = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHASref)#">,
				<!--- HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">,  --->
				ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">, 
				<!--- RHASporcentaje = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASporcentaje#" scale="2">, --->
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	
	<!--- Modo ALTA --->
	<cfelse>

		<cftransaction>	
			<cfquery name="rsInsertASalarial" datasource="#Session.DSN#">
				insert into RHASalarial(Ecodigo, EEid, RHAStipo, RHASdescripcion, ETid, Eid, Mcodigo, NoSalario, RHASref, 
						ESid, <!--- RHASporcentaje, ---> BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHASdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
					<cfif isdefined("Form.NoSalario")>
						1,
					<cfelse>
						0,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHASref)#">,
<!--- 					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">,  --->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">, 
					<!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASporcentaje#" scale="2">,  --->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertASalarial">
			<cfset Form.RHASid = rsInsertASalarial.identity>
		</cftransaction>
		
	</cfif>

<!--- Modo BAJA --->	
<cfelseif isdefined("Form.btnEliminar")>
	<cftransaction>
		<cfquery name="rsDelASalarial" datasource="#Session.DSN#">
			delete from RHASalarialPuestos
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	
		<cfquery name="rsDelASalarial" datasource="#Session.DSN#">
			delete from RHASalarial
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset StructDelete(Form, "RHASid")>
	</cftransaction>

<!--- Modo RECUPERAR --->
<cfelseif isdefined("Form.RHASid_Rec") and Len(Trim(Form.RHASid_Rec))>

	<cftransaction>
		<!--- Insertar el Encabezado de Análisis Salarial --->
		<cfquery name="rsInsertASalarial" datasource="#Session.DSN#">
			insert into RHASalarial(Ecodigo, RHAStipo, RHASdescripcion, EEid, ETid, Eid, Mcodigo, NoSalario, RHASref, RHASaplicar, RHASnumper, HYERVid, ESid, RHASporcentaje, BMUsucodigo)
			select a.Ecodigo, a.RHAStipo, a.RHASdescripcion || ' (2)', a.EEid, a.ETid, a.Eid, a.Mcodigo, a.NoSalario, 
				   <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				   a.RHASaplicar, a.RHASnumper, a.HYERVid, a.ESid, a.RHASporcentaje, 
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHASalarial a
			where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid_Rec#">
			<cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertASalarial">
		<cfset Form.RHASid = rsInsertASalarial.identity>
	
		<!--- Chequea que los puestos a insertar pertenezcan a la misma encuesta del analisis donde se están insertando --->
		<cfquery name="insASalarial" datasource="#Session.DSN#">
			insert into RHASalarialPuestos (RHASid, RHPcodigo, Ecodigo, EEid, RHASPperceptil, BMUsucodigo)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">,
				   a.RHPcodigo,
				   a.Ecodigo,
				   a.EEid,
				   a.RHASPperceptil,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHASalarialPuestos a
				inner join RHEncuestaPuesto c
					on c.Ecodigo = a.Ecodigo
					and c.RHPcodigo = a.RHPcodigo
				inner join RHASalarial d
					on d.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
					and d.EEid = c.EEid
			where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid_Rec#">
		</cfquery>
	
	</cftransaction>
	
</cfif>
