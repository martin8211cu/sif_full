<cfif isdefined("Form.btnGuardar")>
	<!--- Averiguar que campos se modifican en la acción masiva --->
	<cfquery name="rsTipoAMasiva" datasource="#Session.DSN#">
		select RHTAaplicaauto, RHTAcempresa, RHTActiponomina, RHTAcregimenv, RHTAcoficina, RHTAcdepto, RHTAcplaza, RHTAcpuesto, RHTAccomp, RHTAcsalariofijo, RHTAccatpaso, RHTAcjornada, RHTAidliquida, RHTAevaluacion, RHTAnotaminima, RHTAperiodos, RHTAfutilizap
		from RHTAccionMasiva
		where RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">
	</cfquery>
	
	<!--- Averiguar si viene el Puesto de Categoría Puesto --->
	<cfif isdefined('Form.RHTTid') and Len(Trim(Form.RHTTid)) NEQ 0 and isdefined('Form.RHCid') and Len(Trim(Form.RHCid)) NEQ 0 and isdefined('Form.RHMPPid') and Len(Trim(Form.RHMPPid)) NEQ 0>
		<cfquery name="rsCatPaso" datasource="#Session.DSN#">
			select RHCPlinea
			from RHCategoriasPuesto
			where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
			and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCid#">
			and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif Len(Trim(rsCatPaso.RHCPlinea))>
			<cfset Form.RHCPlinea = rsCatPaso.RHCPlinea>
		</cfif>
	</cfif>

	<!--- CAMBIO --->
	<cfif isdefined("Form.RHAid") and Len(Trim(Form.RHAid))>
		<cfquery name="rsUpdate" datasource="#Session.DSN#">
			update RHAccionesMasiva set
				RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">, 
				RHAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHAcodigo#">, 
				RHAdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHAdescripcion#">, 
				RHAfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHAfdesde)#">, 
				<cfif isdefined("Form.RHAfhasta") and Len(Trim(Form.RHAfhasta))>
					RHAfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHAfhasta)#">, 
				<cfelse>
					RHAfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">, 
				</cfif>
				<cfif rsTipoAMasiva.RHTAccatpaso EQ 1 and isdefined("Form.RHCPlinea") and Len(Trim(Form.RHCPlinea))>
					RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPlinea#">, 
				<cfelse>
					RHCPlinea = null,
				</cfif>
				<cfif rsTipoAMasiva.RHTActiponomina EQ 1 and isdefined("Form.Tcodigo") and Len(Trim(Form.Tcodigo))>
					Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">, 
				<cfelse>
					Tcodigo = null,
				</cfif>
				<cfif rsTipoAMasiva.RHTAcregimenv EQ 1 and isdefined("Form.RVid") and Len(Trim(Form.RVid))>
					RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">, 
				<cfelse>
					RVid = null,
				</cfif>
				<cfif rsTipoAMasiva.RHTAcoficina EQ 1 and isdefined("Form.Ocodigo") and Len(Trim(Form.Ocodigo))>
					Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">, 
				<cfelse>
					Ocodigo = null,
				</cfif>
				<cfif rsTipoAMasiva.RHTAcdepto EQ 1 and isdefined("Form.Dcodigo") and Len(Trim(Form.Dcodigo))>
					Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
				<cfelse>
					Dcodigo = null,
				</cfif>
				<cfif rsTipoAMasiva.RHTAcpuesto EQ 1 and isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo))>
					RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">, 
				<cfelse>
					RHPcodigo = null,
				</cfif>
				<cfif rsTipoAMasiva.RHTAcsalariofijo EQ 1 and isdefined("Form.RHAporcsal") and Len(Trim(Form.RHAporcsal))>
					RHAporcsal = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHAporcsal#">, 
				<cfelse>
					RHAporcsal = null,
				</cfif>
				<cfif rsTipoAMasiva.RHTAcpuesto EQ 1 and isdefined("Form.RHAporc") and Len(Trim(Form.RHAporc))>
					RHAporc = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHAporc#">, 
				<cfelse>
					RHAporc = null,
				</cfif>
				<cfif rsTipoAMasiva.RHTAcjornada EQ 1 and isdefined("Form.RHJid") and Len(Trim(Form.RHJid))>
					RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">, 
				<cfelse>
					RHJid = null,
				</cfif>
				<cfif isdefined("Form.RHAidliquida") and Len(Trim(Form.RHAidliquida))>
					RHAidliquida = 1,
				<cfelse>
					RHAidliquida = 0,
				</cfif>
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>
		<cfset Form.paso = 2>
	
	<!--- ALTA --->
	<cfelse>
		<cftransaction>
			<cfquery name="rsInsert" datasource="#Session.DSN#">
				insert into RHAccionesMasiva(RHTAid, RHAcodigo, RHAdescripcion, Ecodigo, RHAfdesde, RHAfhasta, RHCPlinea, Tcodigo, RVid, Ocodigo, Dcodigo, RHPcodigo, RHAporcsal, RHAporc, RHJid, RHAidliquida, RHAAnoreconocidos, RHAAperiodom, RHAAnumerop, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHAcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHAdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHAfdesde)#">, 
					<cfif isdefined("Form.RHAfhasta") and Len(Trim(Form.RHAfhasta))>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHAfhasta)#">, 
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">, 
					</cfif>
					<cfif rsTipoAMasiva.RHTAccatpaso EQ 1 and isdefined("Form.RHCPlinea") and Len(Trim(Form.RHCPlinea))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPlinea#">, 
					<cfelse>
						null,
					</cfif>
					<cfif rsTipoAMasiva.RHTActiponomina EQ 1 and isdefined("Form.Tcodigo") and Len(Trim(Form.Tcodigo))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">, 
					<cfelse>
						null,
					</cfif>
					<cfif rsTipoAMasiva.RHTAcregimenv EQ 1 and isdefined("Form.RVid") and Len(Trim(Form.RVid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">, 
					<cfelse>
						null,
					</cfif>
					<cfif rsTipoAMasiva.RHTAcoficina EQ 1 and isdefined("Form.Ocodigo") and Len(Trim(Form.Ocodigo))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">, 
					<cfelse>
						null,
					</cfif>
					<cfif rsTipoAMasiva.RHTAcdepto EQ 1 and isdefined("Form.Dcodigo") and Len(Trim(Form.Dcodigo))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
					<cfelse>
						null,
					</cfif>
					<cfif rsTipoAMasiva.RHTAcpuesto EQ 1 and isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">, 
					<cfelse>
						null,
					</cfif>
					<cfif rsTipoAMasiva.RHTAcsalariofijo EQ 1 and isdefined("Form.RHAporcsal") and Len(Trim(Form.RHAporcsal))>
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHAporcsal#">, 
					<cfelse>
						null,
					</cfif>
					<cfif rsTipoAMasiva.RHTAcpuesto EQ 1 and isdefined("Form.RHAporc") and Len(Trim(Form.RHAporc))>
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHAporc#">, 
					<cfelse>
						null,
					</cfif>
					<cfif rsTipoAMasiva.RHTAcjornada EQ 1 and isdefined("Form.RHJid") and Len(Trim(Form.RHJid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">, 
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("Form.RHAidliquida") and Len(Trim(Form.RHAidliquida))>
						1, 
					<cfelse>
						0,
					</cfif>
					0, 
					null, 
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="rsInsert" datasource="#Session.DSN#">
			<cfset Form.RHAid = rsInsert.identity>
			<cfset Form.paso = 2>
		</cftransaction>
	</cfif>
	

<!--- Modo Baja --->	
<cfelseif isdefined("Form.btnEliminar")>
	<cftransaction>
		<cfquery name="Anua" datasource="#session.dsn#">
			select RHTAanualidad 
			from RHAccionesMasiva a
				inner join RHTAccionMasiva b
				on b.RHTAid=a.RHTAid
			where RHAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>
		
		<cfif Anua.RHTAanualidad eq 1>
		<cfquery name="reversaAnua" datasource="#session.dsn#">
			select DEid from EAnualidad
			where EAacum < 345
			and DEid in (select DEid from RHEmpleadosAccionMasiva where RHAid=#Form.RHAid#)
			and DAtipoConcepto= 2
		</cfquery>
		<cfloop query="reversaAnua">
			<cfquery name="rsUpA" datasource="#session.dsn#">
				update EAnualidad 
							   set EAacum= (EAacum+360)
						where DEid =#reversaAnua.DEid#
						and DAtipoConcepto=2
			</cfquery>	
		</cfloop>
		<cfquery name="rsDel" datasource="#session.dsn#">
			delete from DAnualidad where RHAid=#Form.RHAid#
		</cfquery>
		</cfif>
		<!--- delete RHDAcciones
			from RHDAcciones a, RHAcciones b
			where b.RHAlinea = a.RHAlinea
			and b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#"> --->
		<cfquery name="rsDel" datasource="#Session.DSN#">
			delete RHDAcciones
			where  exists (select 1
					from RHAcciones b
					where b.RHAlinea = RHDAcciones.RHAlinea
					and b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
					)
		</cfquery>

		<cfquery name="rsDel" datasource="#Session.DSN#">
			<!--- delete RHConceptosAccion
			from RHConceptosAccion a, RHAcciones b
			where b.RHAlinea = a.RHAlinea
			and b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
			 --->
			delete RHConceptosAccion
			where exists(select 1
						from RHAcciones b
						where b.RHAlinea = RHConceptosAccion.RHAlinea
						and b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
						)
		</cfquery>
	
		<cfquery name="rsDel" datasource="#Session.DSN#">
			delete RHAcciones
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>
	
		<cfquery name="rsDel" datasource="#Session.DSN#">
			delete RHEmpleadosAccionMasiva
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>
	
		<cfquery name="rsDel" datasource="#Session.DSN#">
			delete RHDepenAccionM
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>

		<cfquery name="rsDel" datasource="#Session.DSN#">
			delete RHPeriodosAccionesM
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>

		<cfquery name="rsDel" datasource="#Session.DSN#">
			delete RHComponentesAccionM
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>

		<cfquery name="rsDel" datasource="#Session.DSN#">
			delete RHAccionesMasiva
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>
	</cftransaction>
</cfif>
