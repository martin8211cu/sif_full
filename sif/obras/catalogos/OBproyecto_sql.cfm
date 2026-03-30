
<cfif IsDefined("form.Cambio")>

	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="OBproyecto"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo"
				type1="integer"
				value1="#form.Ecodigo#"
				field2="OBPid"
				type2="numeric"
				value2="#form.OBPid#"
		>
	
	<cfquery datasource="#session.dsn#">
		update OBproyecto
		set OBPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBPcodigo#" null="#Len(form.OBPcodigo) Is 0#">
		, PCDcatidPry = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatidPry#" null="#Len(form.PCDcatidPry) Is 0#">
		<cfif isdefined('form.OBPdescripcion') and LEN(TRIM(form.OBPdescripcion))>	
			, OBPdescripcion =	<cf_dbfunction name="sPart"	args="'#form.OBPdescripcion#';1;40"  	 datasource="#session.dsn#" delimiters=";">
		<cfelse>
			, OBPdescripcion =	null
		</cfif>
		, OBPtexto = <cfif isdefined("form.OBPtexto") and Len(Trim(form.OBPtexto))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OBPtexto#"><cfelse>null</cfif>
		, OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
		, PCEcatidObr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidObr#" null="#Len(form.PCEcatidObr) Is 0#">
		
		, CFformatoPry = <cfqueryparam cfsqltype="cf_sql_char" value="#fnCFformatoPry()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPid#">
	</cfquery>

	<cflocation url="OBproyecto.cfm?Ecodigo=#URLEncodedFormat(form.Ecodigo)#&OBPid=#URLEncodedFormat(form.OBPid)#">

<cfelseif IsDefined("form.Baja")>

	<cfquery datasource="#session.dsn#">
		delete from OBproyecto
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPid#">
	</cfquery>

	<cflocation url="OBproyecto.cfm">
<cfelseif IsDefined("form.Alta")>	

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select tp.Cmayor, p.OBPcodigo, tp.OBTPid, tp.OBTPcodigo, tp.OBTPdescripcion
		  from OBproyecto p
			inner join OBtipoProyecto tp
				 on tp.OBTPid = p.OBTPid
				and tp.Ecodigo = #session.Ecodigo#
			left join OBtipoProyecto tpActual
				 on tpActual.OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
				and tpActual.Ecodigo = #session.Ecodigo#
			 where p.OBPcodigo	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBPcodigo#" null="#Len(form.OBPcodigo) Is 0#">
			   and tp.Cmayor	= tpActual.Cmayor
	</cfquery>
	<cfif rsSQL.recordCount GT 0>
		<cfif rsSQL.OBTPid EQ form.OBTPid>
			<cf_errorCode	code = "50417"
							msg  = "El proyecto '@errorDat_1@' ya está incluido en el tipo de proyecto"
							errorDat_1="#form.OBPcodigo#"
			>
		<cfelse>
			<cf_errorCode	code = "50418"
							msg  = "El proyecto '@errorDat_1@' ya está incluido para la Cuenta Mayor '@errorDat_2@' en el tipo de proyecto '@errorDat_3@ - @errorDat_4@'"
							errorDat_1="#form.OBPcodigo#"
							errorDat_2="#rsSQL.Cmayor#"
							errorDat_3="#rsSQL.OBTPcodigo#"
							errorDat_4="#rsSQL.OBTPdescripcion#"
			>
		</cfif>
	</cfif>
	<cftransaction>
		<cfquery name="insert" datasource="#session.dsn#">
			insert into OBproyecto (
				
				Ecodigo,
				OBPcodigo,
				PCDcatidPry,
				
				OBPdescripcion,
				OBPtexto,
				OBTPid,
				PCEcatidObr,
				
				CFformatoPry,
				BMUsucodigo)
			values (
				
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#form.OBPcodigo#" 		null="#Len(form.OBPcodigo) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.PCDcatidPry#" 		null="#Len(form.PCDcatidPry) Is 0#">,
				<cfif isdefined('form.OBPdescripcion') and LEN(TRIM(form.OBPdescripcion))>	
					<cf_dbfunction name="sPart"	args="'#form.OBPdescripcion#';1;40"  	 datasource="#session.dsn#" delimiters=";">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("form.OBPtexto") and Len(Trim(form.OBPtexto))>
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#form.OBPtexto#">
				<cfelse>
					null
				</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.OBTPid#" 			null="#Len(form.OBTPid) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.PCEcatidObr#" 		null="#Len(form.PCEcatidObr) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#fnCFformatoPry()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">)
			<cf_dbidentity1  name="insert" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2  name="insert" datasource="#session.dsn#" returnvariable="LvarID">
	</cftransaction>
	
	<cflocation url="OBproyecto.cfm?Ecodigo=#URLEncodedFormat(session.Ecodigo)#&OBPid=#URLEncodedFormat(LvarID)#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OBproyecto.cfm?btnNuevo">
<cfelseif IsDefined("form.btnAgregarCAT")>
	<cfoutput>
	<cfquery datasource="#session.dsn#" name="rsOBTP">
		select PCEcatidPry, OBTPnivelProyecto, OBTPnivelObra, PCEMformato,
				ec.PCEcodigo, ec.PCEdescripcion,
				ec.PCElongitud, ec.PCEempresa, ec.PCEoficina,
				n.PCNlongitud as PCNlongitudObr
		  from OBtipoProyecto tp
			inner join PCEMascaras m
			   on m.PCEMid	= tp.PCEMid
			inner join PCECatalogo ec
			   on ec.PCEcatid = PCEcatidPry
			inner join PCNivelMascara n
			   on n.PCEMid	= tp.PCEMid
			  and n.PCNid	= tp.OBTPnivelObra
		 where tp.OBTPid = #form.OBTPid#
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from PCDCatalogo 
		 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOBTP.PCEcatidPry#">
		   and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDvalorPry#">
		 <cfif rsOBTP.PCEempresa EQ '1'>
		 	<cfset LvarEmpresa = " en la empresa">
		   and Ecodigo = #session.Ecodigo#
		 <cfelse>
		 	<cfset LvarEmpresa = "">
		 </cfif>
	</cfquery>
	<cfif rsSQL.cantidad NEQ 0>
		<script language="javascript">
			alert("El valor '#form.PCDvalorPry#' para el catalogo de Proyectos ya existe#LvarEmpresa#");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from PCECatalogo 
		 where CEcodigo = #session.CEcodigo#
		   and PCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEcodigoObr#">
	</cfquery>
	<cfif rsSQL.cantidad NEQ 0>
		<script language="javascript">
			alert("El Catalogo para Obras '#form.PCEcodigoObr#' ya existe");
			history.back();
		</script>
		<cfabort>
	</cfif>

	<cftransaction>
		<!--- Agregar Catalago Obra --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into PCECatalogo 
				(
					CEcodigo,
					PCEcodigo,
					PCEdescripcion,
					PCElongitud,
					PCEempresa,
					PCEoficina,
					PCEref,
					PCEreferenciar,
					PCEreferenciarMayor,
					PCEactivo,
					Usucodigo,
					Ulocalizacion
				)
			values (
					#session.CEcodigo#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEcodigoObr#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEdescripcionObr#">,
					#rsOBTP.PCNlongitudObr#,
					#rsOBTP.PCEempresa#,
					#rsOBTP.PCEoficina#,
					1,
					0,
					0,
					1,
					#session.Usucodigo#,
					'00'
				)
			<cf_dbidentity1 name="rsSQL" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="rsSQL" datasource="#session.dsn#" returnvariable="LvarPCEcatidObr">
	
		<!--- Agregar Valor Catalogo Proyecto referenciando Catalogo anterior --->
		<cfquery datasource="#session.dsn#">
			insert into PCDCatalogo 
				(
					PCEcatid,
					PCEcatidref,
					Ecodigo,
					PCDactivo,
					PCDvalor,
					PCDdescripcion,
					Usucodigo,
					Ulocalizacion
				)
			values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOBTP.PCEcatidPry#">,
					#LvarPCEcatidObr#,
				<cfif rsOBTP.PCEempresa EQ '1'>
					#session.Ecodigo#,
				<cfelse>
					null,
				</cfif>
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDvalorPry#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDdescripcionPry#">,
					#session.Usucodigo#,
					'00'
				)
		</cfquery>
	</cftransaction>
	
	<cflocation url="OBproyecto.cfm?btnNuevo">
	</cfoutput>
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OBproyecto.cfm">
</cfif>
<cffunction name="fnCFformatoPry" returntype="string">
	<cfquery datasource="#session.dsn#" name="rsOBTP">
		select Cmayor, OBTPnivelProyecto, OBTPnivelObra
		  from OBtipoProyecto tp
		 where tp.OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#">
	</cfquery>
	<cfset LvarCFformatoPry = rsOBTP.Cmayor>
	<cfloop index="LvarNivel" from="1" to="#rsOBTP.OBTPnivelObra-1#">
		<cfif LvarNivel EQ rsOBTP.OBTPnivelProyecto>
			<cfset LvarValue = form.OBPcodigo>
		<cfelse>
			<cfset LvarValue = form["CFformato#LvarNivel#"]>
		</cfif>
		<cfset LvarCFformatoPry = "#LvarCFformatoPry#-#LvarValue#">
	</cfloop>
	<cfreturn LvarCFformatoPry>
</cffunction>




