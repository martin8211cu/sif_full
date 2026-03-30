<!--- 
	Creado por: Ana Villavicencio
	Fecha: 01 de marzo del 2006
	Motivo: Nuevo catalogo de Limite de credito adicional. Dentro del catalogo de Socios de Negocios.
 --->
 
<cfinclude template="SociosModalidad.cfm">
<cfset params = 'SNcodigo=#form.SNcodigo#&tab=8&tabs=3&id_direccion=#form.id_direccion#'>
<cfif not isdefined('form.NuevoLimite')>
	<cfif isdefined('form.AltaLimite')>
		<cfquery name="rsExisteLimite" datasource="#session.DSN#">
			select count(1) as Cantidad
			from SNLimiteCredito
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fdesde)#"> <= fhasta
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fhasta)#"> >= fdesde
		</cfquery>
		<cfif rsExisteLimite.Cantidad EQ 0>
			<!--- SI EL REGISTRO A INSERTAR ESTA VIGENTE ENTONCES ACTUALIZA LOS DEMAS REGISTROS COMO NO VIGENTES --->
			<cfif isdefined('form.Vigente')>
				<cfquery name="rsUpdateVigencia" datasource="#session.DSN#">
					update SNLimiteCredito
					set Vigente = 0
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
					  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
				</cfquery>
			</cfif>
			<cftransaction>
				<cfquery name="rsInsertSNLC" datasource="#session.DSN#">
					insert into SNLimiteCredito
						(Ecodigo, 
						SNcodigo, 
						id_direccion, 
						fdesde, 
						fhasta, 
						SNLtotal, 
						SNLactual, 
						SNLadicional, 
						Vigente, 
						Motivo, 
						BMfechaalta, 
						BMUsucodigo)
					values(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fdesde)#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fhasta)#">,
							#Replace(Form.SNLtotal,',','','all')#,
							#Replace(Form.SNmontoLimiteCC,',','','all')#,
							#Replace(Form.SNLadicional,',','','all')#,
							<cfif isdefined('form.Vigente')>1<cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Motivo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertSNLC">
				<cfset form.SNLCid = rsInsertSNLC.identity>
				<cfset params = params & '&SNLCid=' & form.SNLCid>
			</cftransaction>
		<cfelse>
			<cf_errorCode	code = "50015" msg = "Ya existe un Límite de Credito Adicional con fechas dentro del Rango de vigencia seleccionado.">
			
		</cfif>
	<cfelseif isdefined('form.CambioLimite')>
		<cfquery name="rsExisteLimite" datasource="#session.DSN#">
			select count(1) as Cantidad
			from SNLimiteCredito
			where SNLCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNLCid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fdesde)#"> <= fhasta
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fhasta)#"> >= fdesde
		</cfquery>
		<cfif rsExisteLimite.Cantidad EQ 0>
			<!--- SI EL REGISTRO A INSERTAR ESTA VIGENTE ENTONCES ACTUALIZA LOS DEMAS REGISTROS COMO NO VIGENTES --->
			<cfif isdefined('form.Vigente')>
				<cfquery name="rsUpdateVigencia" datasource="#session.DSN#">
					update SNLimiteCredito
					set Vigente = 0
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
					  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
				</cfquery>
			</cfif>
			<cfquery name="rsUpdateSNLC" datasource="#session.DSN#">
				update SNLimiteCredito
				set Vigente 	 = <cfif isdefined('form.Vigente')>1<cfelse>0</cfif>,
					fdesde 	 	 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fdesde)#">,
					fhasta 		 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fhasta)#">,
					SNLtotal 	 = #Replace(Form.SNLtotal,',','','all')#,
					SNLactual 	 = #Replace(Form.SNmontoLimiteCC,',','','all')#,
					SNLadicional = #Replace(Form.SNLadicional,',','','all')#,
					Motivo 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Motivo#">
				where SNLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNLCid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
				  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
			</cfquery>
			<cfset params = params & '&SNLCid=' & form.SNLCid>
		<cfelse>
			<cf_errorCode	code = "50015" msg = "Ya existe un Límite de Credito Adicional con fechas dentro del Rango de vigencia seleccionado.">
		</cfif>
	</cfif>
</cfif>
<cfoutput>
	<!--- <cflocation url="Socios.cfm?#params#"> --->
	<cflocation url="SociosDirecciones_form.cfm?#params#">
</cfoutput>

