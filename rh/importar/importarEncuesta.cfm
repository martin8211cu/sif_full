
<cfset msg ="">
<cfif not isdefined("session.Importador.EEid") or  isdefined("session.Importador.EEid") and  len(trim(session.Importador.EEid)) eq 0>
	<cfset msg = msg & "la variable de Sessi&oacute;n  que almacena la empresa encuestadora no esta definida o tiene valor nulo <br>">
</cfif>
<cfif not isdefined("session.Importador.ETid") or  isdefined("session.Importador.ETid") and  len(trim(session.Importador.ETid)) eq 0>
	<cfset msg = msg & "la variable de Sessi&oacute;n  que almacena la organizaci&oacute;n no esta definida o tiene valor nulo <br>">
</cfif>

<cfif not isdefined("session.Importador.Eid") or  isdefined("session.Importador.Eid") and  len(trim(session.Importador.Eid)) eq 0>
	<cfset msg = msg & "la variable de Sessi&oacute;n que almacena la encuesta no esta definida o tiene valor nulo <br>">
</cfif>
<cfif  isdefined("msg") and  len(trim(msg))>
	<cfthrow message="#msg#">
	<cfabort>
</cfif>

<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>
<!--- *****************************************  --->
<!--- *** VALIDA QUE EL ARCHIVO TENGA DATOS ***  --->
<!--- *****************************************  --->
<cfquery name="CantReg" datasource="#Session.Dsn#">
	select 1
	from #table_name#
</cfquery>

<cfif CantReg.recordcount EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('El archivo de importaci&oacute;n no tiene l&iacute;neas',1)
	</cfquery>
<cfelse>	
	<!--- ****************************************  --->
	<!--- *** VALIDA QUE EL AREA SEA VALIDO    ***  --->
	<!--- ****************************************  --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select distinct <cf_dbfunction name="concat" args="'El c&oacute;digo de &aacute;rea :',x.Area,' no existe en el cat&aacute;logo de &Aacute;reas'">,3
		from #table_name# x
		where  ltrim(rtrim(x.Area)) not in (
			select ltrim(rtrim(b.EACodigo)) 
			from EmpresaArea b
			where b.EACodigo is not null )
	</cfquery>

	<!--- ****************************************  --->
	<!--- *** VALIDA QUE EL PUESTO SEA VALIDO  ***  --->
	<!--- ****************************************  --->

	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select distinct <cf_dbfunction name="concat" args="'El c&oacute;digo de puesto :',x.Puesto,' no existe en el cat&aacute;logo de puestos'">,4
		from #table_name# x
		where  ltrim(rtrim(x.Puesto)) not in (
			select ltrim(rtrim(b.EPcodigo)) 
			from EncuestaPuesto b)
	</cfquery>
	
	

	<!--- ***********************************************  --->
	<!--- *** VALIDA QUE EL PUESTO Y AREA SEA VALIDO  ***  --->-
	<!--- ***********************************************  --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select distinct <cf_dbfunction name="concat" args="'la combinaci&oacute;n  puesto y &aacute;rea (',x.Puesto,'-', x.Area,'). Ya existe en la encuesta'">,5
		from #table_name# x

		where  ltrim(rtrim(x.Puesto)) not in (	select ltrim(rtrim(b.EPcodigo)) 
												from EncuestaPuesto b, EmpresaArea c
												where b.EEid = c.EEid
												  and ltrim(rtrim(c.EACodigo)) = ltrim(rtrim(x.Area))
											 )
											 
		and ltrim(rtrim(x.Puesto)) in (select ltrim(rtrim(b.EPcodigo)) from EncuestaPuesto b)											 
	</cfquery>

</cfif>

<cfquery name="hayerrores" datasource="#session.dsn#">
	select 1
	from #ERRORES_TEMP#
	order by ErrorNum
</cfquery>
<cfif (hayerrores.recordcount) EQ 0>
	<!---
		 <cfquery name="hayerrores" datasource="#session.dsn#">
			select *
			from #table_name#
		</cfquery>
		<cf_dump var="#hayerrores#">
	--->
	<cfquery name="RSMonedas" datasource="#session.DSN#">
		select distinct Moneda 
		from  EncuestaSalarios
		where
			EEid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.EEid#">
			and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.ETid#">
			and Eid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.Eid#">
	</cfquery>
	
	<cftransaction>
		<!--- Elimina los datos que tiene actualmente para la encuesta --->
		<cfquery name="RSBorrar" datasource="#session.DSN#">
			delete EncuestaSalarios
			where
				EEid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.EEid#">
				and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.ETid#">
				and Eid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.Eid#">
		</cfquery>
		<!--- inserta los valores definidos de los puestos que vienen en el importador --->
		<cfloop query="RSMonedas">
			<cfquery name="RSInserta" datasource="#session.DSN#">
					insert into EncuestaSalarios(EEid,ETid,Eid,EPid,EScantobs,ESp25,ESp50,ESp75,
					ESpromedioanterior,ESpromedio,ESvariacion,BMUsucodigo,BMfechaalta,Moneda)
						Select 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.EEid#"> as EEid,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.ETid#"> as ETid,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.Eid#"> as Eid,
							ep.EPid,
							ee.Obs,
							ee.P25,
							ee.P50,
							ee.P75,
							ee.PAnterior,
							ee.PActual,
							ee.Variacion,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as Usucodigo,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> as FechaHoy,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#RSMonedas.Moneda#"> as Moneda
						from EncuestaPuesto ep
							inner join #table_name# ee
								on rtrim(ltrim(ee.Puesto)) = rtrim(ltrim(ep.EPcodigo))
						where ep.EEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.EEid#">	
			
			</cfquery>

			<!--- inserta los valores definidos de los puestos que no vienen en el importador pero con valor 0 --->
			<cfquery name="RSInserta" datasource="#session.DSN#">
					insert into EncuestaSalarios(EEid,ETid,Eid,EPid,EScantobs,ESp25,ESp50,ESp75,
					ESpromedioanterior,ESpromedio,ESvariacion,BMUsucodigo,BMfechaalta,Moneda)
						Select 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.EEid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.ETid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.Eid#">,
							ep.EPid,
							0,0,0,0,0,0,0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#RSMonedas.Moneda#">
						from EncuestaPuesto ep
						where ep.EEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.EEid#">	
						and EPid not  in (
							select EPid 
							from  EncuestaSalarios
							where
							EEid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.EEid#">
							and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.ETid#">
							and Eid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Importador.Eid#">
							and Moneda  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSMonedas.Moneda#">
						)
			</cfquery>
		</cfloop>
		
	</cftransaction>
<cfelse>
	<cfquery name="err" datasource="#session.dsn#">
		select Mensaje
		from #ERRORES_TEMP#
		order by ErrorNum
	</cfquery>	
</cfif>
