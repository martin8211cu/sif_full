<!--- 
	Creado por Gustavo Fonseca Hernández.
	Fecha: 26-7-2005.
	Motivo: Creación del Mantenimiento de Instrucciones de Pago de Beneficiarios.
 --->


<!--- <cfdump var="#url#">
<cf_dump var="#form#"> --->

<cfset params = ''>
<cfif isdefined('form.fTESbeneficiario') and LEN(TRIM(form.fTESbeneficiario))>
	<cfset params = params & '&fTESbeneficiario=#form.fTESbeneficiario#'>
</cfif>
<cfif isdefined('form.fTESbeneficiarioID') and LEN(TRIM(form.fTESbeneficiarioID))>
	<cfset params = params & '&fTESbeneficiarioID=#form.fTESbeneficiarioID#'>
</cfif>
<cfif isdefined('form.Pagina')>
	<cfset params = params & '&Pagina=#form.Pagina#'>
</cfif>


<cfif IsDefined("form.Cambio")>
	<!--- Si se usa CAMBIO en TESordenPago se actualiza a estado = 2 (Inactivo) y se  inserta uno nuevo --->
<!--- 	<cfif isdefined("form.SNid") and form.SNid gt 0 and not isdefined("form.SNidP")>
		<cfset form.SNidP = form.SNid>
	</cfif> --->
	
	<!--- Si vine el chk (Default)entra. --->
	<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
		<!--- Busca si ya hay registros en default --->
		<cfquery name="rsBuscaDefault" datasource="#session.DSN#">
			select TESTPid, TESid, TESBid
			from  TEStransferenciaP
			where TESTPestado = 1 <!--- el Default --->
			and TESTPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
			and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
			and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
		</cfquery>
		<!--- Si hay registros con default los actualiza a 0 (Activo) --->
		<cfif rsBuscaDefault.recordcount gt 0>
			<cfloop query="rsBuscaDefault">
				<cfquery name="rsUpdateEstado" datasource="#session.DSN#">
					update TEStransferenciaP
						set TESTPestado = 0 <!--- Activo --->
					where TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaDefault.TESTPid#">
						and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaDefault.TESid#">
						and	TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaDefault.TESBid#">
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>
	
	<cfquery name="rsTESordenPagoCambio" datasource="#session.DSN#">
		select count(1) as resultado
		  from TESordenPago
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
		   and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
		   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		   and TESOPestado in (12,13)
	</cfquery>
		
	<cfif rsTESordenPagoCambio.resultado GT 0>
		
		<cf_dbtimestamp
		datasource="#session.DSN#"
		table="TEStransferenciaP"
		redirect="Beneficiarios_form.cfm"
		timestamp="#form.ts_rversion#"
		field1="TESid" type1="numeric" value1="#session.tesoreria.TESid#"
		field2="TESTPid" type2="numeric" value2="#Form.TESTPid#">
	
		<cftransaction>
			<cfquery datasource="#session.dsn#">
				update TEStransferenciaP
				set TESTPestado = 2
				where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
				  and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
			</cfquery>
	
			<cfquery name="rsinsertCambio" datasource="#session.dsn#">
				insert into TEStransferenciaP 
				(TESid,
				 SNidP, 
				 TESBid,
				 TESTPcuenta, 
				 Miso4217, 
				 TESTPcodigoTipo, 
				 TESTPcodigo, 
				 TESTPbanco, 
				 TESTPdireccion, 
				 TESTPciudad, 
				 Ppais, 
				 TESTPtelefono, 
				 TESTPinstruccion, 
				 TESTPestado, 
				 UsucodigoAlta, 
				 TESTPfechaAlta
				)
				
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">,
						null,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESTPcuentab)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Miso4217)#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESTPcodigoTipo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPbanco#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPdireccion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPciudad#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPtelefono#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPinstruccion#">,
						<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.chkTESTPestado#">,
						<cfelse>
							0,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
					<cf_dbidentity1 datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.dsn#" name="rsinsertCambio">
			<cfset LvarTESTPid = rsinsertCambio.identity>
			<cfquery datasource="#session.DSN#">
				update TESordenPago
				   set TESTPid = #LvarTESTPid#
				 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
				   and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
				   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
				   and TESOPestado in (10,11)
			</cfquery>
		</cftransaction>
		
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select TESTPid
			from TEStransferenciaP a
			where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.tesoreria.TESid#">
			  and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
			  and TESTPestado < 2
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.TESTPid EQ rsinsertCambio.identity>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.Pagina2 = Ceiling(row / form.MaxRows2)>

	<cfelse>
	<!--- Si no se usa en TESordenPago actualiza normal (Preguntarle a OzKaR) --->
		<cf_dbtimestamp
		datasource="#session.DSN#"
		table="TEStransferenciaP"
		redirect="Beneficiarios_form.cfm"
		timestamp="#form.ts_rversion#"
		field1="TESid" type1="numeric" value1="#session.tesoreria.TESid#"
		field2="TESTPid" type2="numeric" value2="#Form.TESTPid#">

		<cfquery datasource="#session.dsn#">
			update TEStransferenciaP
			set 
				TESTPcuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPcuentab#">,
				Miso4217 = 	<cfqueryparam cfsqltype="cf_sql_char" value="#form.Miso4217#">,
				TESTPcodigoTipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESTPcodigoTipo#">,
				TESTPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPcodigo#">,
				TESTPbanco = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPbanco#">,
				TESTPdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPdireccion#">,
				TESTPciudad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPciudad#">,
				Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
				TESTPtelefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPtelefono#">,
				<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
					TESTPestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.chkTESTPestado#">,
				<cfelse>
					TESTPestado = 0,
				</cfif>
				TESTPinstruccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPinstruccion#">
			where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
			  and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		</cfquery>
	
	</cfif>
	<cfif isdefined('form.Pagina2')>
		<cfset params = params & '&Pagina2=#form.Pagina2#'>
	</cfif>
	<cfif isdefined("LvarTESTPid") and len(trim(LvarTESTPid))>
		<cflocation url="Beneficiarios_form.cfm?TESBid=#URLEncodedFormat(form.TESBid)#&TESTPid=#URLEncodedFormat(LvarTESTPid)##params#">		
	<cfelse>
		<cflocation url="Beneficiarios_form.cfm?TESBid=#URLEncodedFormat(form.TESBid)#&TESTPid=#URLEncodedFormat(form.TESTPid)##params#">
	</cfif>


<cfelseif IsDefined("form.Baja")>
	<!--- Si se utiliza en TESordenPago se actualiza estado = 2 (Inactivo) --->	
	<cfquery name="rsTESordenPagoBaja" datasource="#session.DSN#">
		select count(1) as resultado
		  from TESordenPago
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
		   and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
		   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		   and TESOPestado in (12,13)
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update TESordenPago
		   set TESTPid = null
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
		   and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
		   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		   and TESOPestado in (10,11)
	</cfquery>

	<cfif rsTESordenPagoBaja.resultado gt 0>
		<cf_dbtimestamp
		datasource="#session.DSN#"
		table="TEStransferenciaP"
		redirect="Beneficiarios_form.cfm"
		timestamp="#form.ts_rversion#"
		field1="TESid" type1="numeric" value1="#session.tesoreria.TESid#"
		field2="TESTPid" type2="numeric" value2="#Form.TESTPid#">

		<cfquery datasource="#session.dsn#">
			update TEStransferenciaP
			   set TESTPestado = 2, <!--- Borrado --->
				   UsucodigoBaja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				   TESTPfechaBaja = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
			   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			delete from TEStransferenciaP
			 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
			   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric"value="#form.TESTPid#">
		</cfquery>
	</cfif>
	<cfquery name="rsPagina" datasource="#session.DSN#">
		select *
		from TEStransferenciaP a
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.tesoreria.TESid#">
		  and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
		  and TESTPestado < 2
	</cfquery>
	<cfif  Ceiling(rsPagina.RecordCount/form.MaxRows2) lt form.Pagina2 and form.Pagina2 GT 1>
		<cfset form.Pagina2  = rsPagina.RecordCount/form.MaxRows2>
	</cfif>
	
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="Beneficiarios_form.cfm?TESBid=#URLEncodedFormat(form.TESBid)##params#">
	
<cfelseif IsDefined("form.Alta")>
	<!--- Si vine el chk (Default)entra. --->
	<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
		<!--- Busca si ya hay registros en default --->
		<cfquery name="rsBuscaDefault" datasource="#session.DSN#">
			select TESTPid, TESid, TESBid
			from  TEStransferenciaP
			where TESTPestado = 1 <!--- el Default --->
			and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
			and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
		</cfquery>
		<!--- Si hay registros con default los actualiza a 0 (Activo) --->
		<cfif rsBuscaDefault.recordcount gt 0>
			<cfloop query="rsBuscaDefault">
				<cfquery name="rsUpdateEstado" datasource="#session.DSN#">
					update TEStransferenciaP
						set TESTPestado = 0 <!--- Activo --->
					where TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaDefault.TESTPid#">
						and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaDefault.TESid#">
						and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaDefault.TESBid#">
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>

	<cftransaction>
		<cfquery datasource="#session.dsn#" name="rsInsertAlta">
			insert into TEStransferenciaP 
			(TESid,
			 SNidP, 
			 TESBid,
			 TESTPcuenta, 
			 Miso4217, 
			 TESTPcodigoTipo, 
			 TESTPcodigo, 
			 TESTPbanco, 
			 TESTPdireccion, 
			 TESTPciudad, 
			 Ppais, 
			 TESTPtelefono, 
			 TESTPinstruccion, 
			 TESTPestado, 
			 UsucodigoAlta, 
			 TESTPfechaAlta
			)
			
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">,
					null,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESTPcuentab)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Miso4217)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESTPcodigoTipo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPbanco#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPdireccion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPciudad#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPtelefono#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPinstruccion#">,
	
					<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.chkTESTPestado#">,
					<cfelse>
						0,
					</cfif>
	
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
				<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="rsInsertAlta">
		<cfset LvarTESTPid = rsInsertAlta.identity>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select TESTPid
			from TEStransferenciaP a
			where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.tesoreria.TESid#">
			  and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
			  and TESTPestado < 2
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.TESTPid EQ rsInsertAlta.identity>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.Pagina2 = Ceiling(row / form.MaxRows2)>
	</cftransaction>
<cfelse>
	<!--- ??? --->
</cfif>
<cfif isdefined('form.Pagina2')>
	<cfset params = params & '&Pagina2=#form.Pagina2#'>
</cfif>
<cfif isdefined("LvarTESTPid") and len(trim(LvarTESTPid))>
	<cflocation addtoken="no" url="Beneficiarios_form.cfm?TESBid=#URLEncodedFormat(form.TESBid)#&TESTPid=#URLEncodedFormat(LvarTESTPid)##params#">
<cfelse>
	<cflocation addtoken="no" url="Beneficiarios_form.cfm?TESBid=#URLEncodedFormat(form.TESBid)##params#">
</cfif>