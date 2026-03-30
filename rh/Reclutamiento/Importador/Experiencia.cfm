<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<!--- Check1. verifica el tipo de identificación --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El c&oacute;digo de identificaci&oacute;n&nbsp;(<b>',a.NTIcodigo, '</b>)&nbsp;no existe en el cat&aacute;logo'" >, 1	
	from #table_name# a
	where not exists (	select 1 from NTipoIdentificacion b
					where ltrim(rtrim(b.NTIcodigo ))		  = ltrim(rtrim(a.NTIcodigo))
					and b.Ecodigo = #Session.Ecodigo#
					)	
</cfquery>
<!--- Check2. verfica que el oferente no exista en el catalogo --->

<cfquery name="rsCheck3" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select distinct
	<cf_dbfunction name="concat" args="'El Oferente no existe el catálogo. Tipo Iden.&nbsp;(<b>',a.NTIcodigo,'</b>)&nbsp; Identificaci&oacute;n &nbsp;(<b>',a.RHOidentificacion,'</b>)'" >, 2
	from #table_name# a
	where not exists (	select 1 from DatosOferentes b
					where  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ltrim(rtrim(b.NTIcodigo))	      = ltrim(rtrim(a.NTIcodigo)) 
					and ltrim(rtrim(b.RHOidentificacion)) = ltrim(rtrim(a.RHOidentificacion))
					)	
</cfquery>
<!--- Check3. verfica la situacion Actualmente  --->
<cf_dbfunction name="to_char" args="a.Actualmente" returnvariable="Actualmente">
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El campo actualmente no es v&aacute;lido&nbsp;:(<b>'|#Actualmente#|'</b>) para el oferente &nbsp;(<b>'|a.RHOidentificacion|'</b>)'"  delimiters ="|">,3	
	from #table_name# a
	where a.Actualmente not in (0,1)
</cfquery>
<!--- Check4. verfica la situacion Actualmente  --->
<cf_dbfunction name="to_char" args="a.RHEEmotivo" returnvariable="RHEEmotivo">
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El campo Motivo no es v&aacute;lido&nbsp;:(<b>'|#RHEEmotivo#|'</b>) para el oferente &nbsp;(<b>'|a.RHOidentificacion|'</b>)'"  delimiters ="|">,4
	from #table_name# a
	where a.RHEEmotivo not in (0,10,20,30,40,50) 
</cfquery>

<cfquery name="ERR" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum,Mensaje
</cfquery>
<cfif (ERR.recordcount) EQ 0>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHExperienciaEmpleado (RHOid, Ecodigo, RHEEnombreemp, RHEEtelemp,
			RHEEAnnosLab,RHEEpuestodes, RHEEfechaini, RHEEfecharetiro, 
			Actualmente, RHEEfunclogros, BMUsucodigo, BMfecha, RHEEmotivo)
			select 
			a.RHOid,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			b.RHEEnombreemp,
			b.RHEEtelemp,
			b.RHEEAnnosLab,
			b.RHEEpuestodes,
			b.FechaIngreso,
			b.FechaRetiro,
			coalesce(b.Actualmente,0),
			coalesce(b.RHEEfunclogros,''),
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			coalesce(b.RHEEmotivo,0)
			from DatosOferentes a , #table_name# b
			where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and b.NTIcodigo	        = a.NTIcodigo 
			and b.RHOidentificacion = a.RHOidentificacion
		</cfquery>	
		
	<cfquery name="insertados" datasource="#Session.DSN#">
		select c.RHEEid, b.RHEEpuestodes
		from DatosOferentes a , #table_name# b , RHExperienciaEmpleado c
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.NTIcodigo	        = a.NTIcodigo 
		and b.RHOidentificacion = a.RHOidentificacion
		and a.RHOid = c.RHOid 
	</cfquery>	
		
	<cfset llave = -1>
	<cfset llaveExp = -1>
	<cfset RHEEpuestodes = "">
	<cfloop query="insertados">
		<cfset llave = insertados.RHEEid>
		<cfset RHEEpuestodes = insertados.RHEEpuestodes>
		<cfquery name="insRHOPuesto" datasource="#Session.DSN#">
			select RHOPid from RHOPuesto
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
			and RHOPDescripcion = rtrim(ltrim('#RHEEpuestodes#'))
		</cfquery>
		
		<cfif insRHOPuesto.recordCount eq 0  >
			<cfquery name="insRHOPuesto" datasource="#Session.DSN#">			
				insert INTO RHOPuesto (CEcodigo, RHOPDescripcion,BMfechaalta, BMUsucodigo)
				values 
				(	 #session.CEcodigo# , 
					 rtrim(ltrim('#RHEEpuestodes#')), 
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
					 #session.Usucodigo#) 
				<cf_dbidentity1 verificar_transaccion="false">	 
			</cfquery>
			<cf_dbidentity2 verificar_transaccion="false" name="insRHOPuesto"> 
	
			<cfset llaveExp = insRHOPuesto.identity>
		<cfelse>
			<cfset llaveExp = insRHOPuesto.RHOPid>
		</cfif>
		<cfquery name="ABC_datosOferente" datasource="#Session.DSN#">
			update RHExperienciaEmpleado set RHOPid = #llaveExp#
			where RHEEid = #llave#
		</cfquery>
	</cfloop>
</cfif>
