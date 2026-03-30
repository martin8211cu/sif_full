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
				RHASaplicar = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHASaplicar#">, 
				<cfif Form.RHASaplicar EQ 1>
					RHASnumper = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHASnumper#">, 
				<cfelse>
					RHASnumper = null,
				</cfif>
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	
	<!--- Modo ALTA --->
	<cfelseif isdefined("Form.EEid") and Len(Trim(Form.EEid))
		  and isdefined("Form.ETid") and Len(Trim(Form.ETid))
		  and isdefined("Form.Eid") and Len(Trim(Form.Eid))>

		<cftransaction>
			<cfquery name="rsInsertASalarial" datasource="#Session.DSN#">
				insert into RHASalarial(Ecodigo, EEid, RHAStipo, RHASdescripcion, ETid, Eid, Mcodigo, NoSalario, RHASref, RHASaplicar, RHASnumper, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
					0,
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
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHASaplicar#">, 
					<cfif Form.RHASaplicar EQ 1>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHASnumper#">, 
					<cfelse>
						null,
					</cfif>
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
			delete from RHASalarialUbicaciones
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	
		<cfquery name="rsDelASalarial" datasource="#Session.DSN#">
			delete from RHASalarialIncidentes
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
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
		
		<!--- Insertar los conceptos de pago --->
		<cfquery name="insASalarial" datasource="#Session.DSN#">
			insert into RHASalarialIncidentes (RHASid, CIid, BMUsucodigo)
			select
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">, 
				a.CIid, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHASalarialIncidentes a
				inner join CIncidentes c
					on c.CIid = a.CIid
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and c.CItipo <> 3
			where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid_Rec#">
		</cfquery>
		
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
		
		<!--- Insertar las unidades de negocio --->
		<cfquery name="insASalarial" datasource="#Session.DSN#">
			insert into RHASalarialUbicaciones (RHASid, CFid, Ecodigo, Ocodigo, Dcodigo, RHASUdependecias, BMUsucodigo)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">,
				   a.CFid,
				   a.Ecodigo,
				   a.Ocodigo,
				   a.Dcodigo,
				   a.RHASUdependecias,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHASalarialUbicaciones a
			where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid_Rec#">
		</cfquery>
	
	</cftransaction>

</cfif>
