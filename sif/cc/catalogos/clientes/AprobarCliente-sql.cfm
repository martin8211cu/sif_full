
<cfset params = ''>
<cfif isdefined('form.Pagina')>
	<cfset params = params & 'Pagina=#form.Pagina#'>
</cfif>
<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
	<cfset params = params & '&Filtro_CDIdentificacion=#form.Filtro_CDIdentificacion#'>
</cfif>
<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
	<cfset params = params & '&Filtro_CDnombre=#form.Filtro_CDnombre#'>
</cfif>
<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
	<cfset params = params & '&Filtro_rotulo=#form.Filtro_rotulo#'>
</cfif>		

<cffunction name="socio" returntype="query">
	<cfargument name="cdid" type="numeric" required="yes">
	<cfquery name="rs" datasource="#session.DSN#">
		select SNcodigo 
		from SNegocios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cdid#">
	</cfquery>
	
	<cfreturn rs >
</cffunction>

<cffunction name="update_socio" >
	<cfargument name="cdid" type="numeric" required="yes">
	<cfargument name="ecodigo" type="numeric" required="yes">
	<cfargument name="activo" type="numeric" required="yes">

	<cfquery name="rs" datasource="#session.DSN#">
		update SNegocios
		set SNinactivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cdid#" >
	</cfquery>

</cffunction>

<cfif isdefined("statA")>
	<cftransaction>
		<cfset rsSocio = socio(form.CDid) >
		<cfif rsSocio.RecordCount lte 0 >
			<!--- Calcula codigo de Socio --->
			<cfquery name="rsconsecutivo" datasource="#session.DSN#">
				select  coalesce(max(SNcodigo),0) as SNcodigo
				from SNegocios 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				and SNcodigo <> 9999
			</cfquery>
			<cfset consecutivo = 1 >
			<cfif rsconsecutivo.RecordCount gt 0>
				<cfset consecutivo = rsconsecutivo.SNcodigo + 1 >
			</cfif>
			
			<!--- recupera datos del cliente --->
			<cfquery name="data" datasource="#session.DSN#">
				select cd.CDidentificacion ,cd.CDnombre ,cd.CDapellido1 ,cd.CDapellido2,
					   coalesce(cd.CDdireccion1 ,cd.CDdireccion2) as direccion,
					   cd.CDoficina,cd.CDfax,cd.CDemail
				from ClienteDetallista cd
				where cd.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				  and cd.CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		
			</cfquery>
			
			<!--- Nombre del Cliente --->
			<cfset nombre = trim(data.CDnombre) & " " & trim(data.CDapellido1) & " " & trim(data.CDapellido2) >
		
			<!--- Numero de cliente(xxx-yyyy), por ahora toma el CDid para el xxx y el codigo de socio generado para el yyyy --->
			<cfset LvarSNcodigo = rsconsecutivo.SNcodigo>
			<cfset LvarSNnumero = numberFormat(1000000 + LvarSNcodigo,"0000000")>
			<cfset LvarSNnumeroF = "#mid(LvarSNnumero,1,3)#-#mid(LvarSNnumero,4,4)#">
			<cfquery name="rsSNcod" datasource="#session.dsn#">
				select count (1) as cantidad from SNegocios where SNnumero='#LvarSNnumeroF#'
			</cfquery>
			<cfif rsSNcod.cantidad gt 0>
				<cfloop query="rsSNcod">
					<cfset LvarSNnumero=LvarSNnumero+1>
					<cfquery name="rsSNcod" datasource="#session.dsn#">
						select count (1) as cantidad from SNegocios where SNnumero='#LvarSNnumeroF#'
					</cfquery>
				</cfloop>
			</cfif>
<cfset LvarSNnumeroF = "#mid(LvarSNnumero,1,3)#-#mid(LvarSNnumero,4,4)#">
<!---			<cfset SNnumero = RepeatString('0',3-len(form.CDid)) & form.CDid & '-'& RepeatString('0', 4-len(trim(consecutivo))) & consecutivo >
--->		
<!---Busqueda del ESNid--->
<cfquery name="rsEstado" datasource="#session.dsn#">
	select count(1) from EstadoSNegocios where Ecodigo=#session.Ecodigo# and ESNdescripcion='Activo'
</cfquery>
<cfif rsEstado.recordcount gt 0>
	<cfquery name="rsCheck" datasource="#session.dsn#">
		select  ESNid
		from EstadoSNegocios
		where Ecodigo = #session.Ecodigo#
		and ESNdescripcion='Activo'
	</cfquery>	
	<cfset LvarESNid = rsCheck.ESNid>
<cfelse>
	<cfquery datasource="#session.dsn#">
		insert into EstadoSNegocios 
		(Ecodigo, 
		 ESNcodigo, 
		 ESNdescripcion, 
		 ESNfacturacion)
		values (
		 #session.Ecodigo#, 
		 '01', 
		 'Activo', 
		 0)
	</cfquery>
	<cfquery name="rsCheck" datasource="#session.dsn#">
		select  ESNid
		from EstadoSNegocios
		where Ecodigo = #session.Ecodigo#
		and ESNdescripcion='Activo'
	</cfquery>	
	<cfset LvarESNid = rsCheck.ESNid>
</cfif>
	
	<cfset LvarESNid = rsCheck.ESNid>
			<!--- crea socio de negocios --->
			<cfquery name="insert" datasource="#session.DSN#">
				insert into SNegocios ( Ecodigo, SNcodigo, SNidentificacion, SNtiposocio, SNnombre, SNdireccion, SNtelefono, 
								   SNFax, SNemail, SNFecha, SNtipo, SNvencompras, SNvenventas, SNinactivo, SNnumero, CDid,Mcodigo,ESNid)
				values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#data.CDidentificacion#">,
							'C', 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre#">, 
							<cfif len(trim(data.direccion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#data.direccion#"><cfelse>null</cfif>, 
							<cfif len(trim(data.CDoficina))><cfqueryparam cfsqltype="cf_sql_varchar" value="#data.CDoficina#"><cfelse>null</cfif>, 
							<cfif len(trim(data.CDfax))><cfqueryparam cfsqltype="cf_sql_varchar" value="#data.CDfax#"><cfelse>null</cfif>, 
							<cfif len(trim(data.CDemail))><cfqueryparam cfsqltype="cf_sql_varchar" value="#data.CDemail#"><cfelse>null</cfif>, 
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							'J', 
							null,
							null,
							0,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarSNnumeroF#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDid#">,
							1,
							#LvarESNid#
							 )
			</cfquery>
		<cfelseif len(trim(rsSocio.SNcodigo)) >
			<!--- modifica estado del Socio de Negocio --->
			<cfset update_socio(Form.CDid, session.Ecodigo, 0) >
		</cfif>
	
		<!--- modifica estado del cliente --->
		<cfquery name="update" datasource="#session.DSN#">
			update ClienteDetallista
			set CDactivo = 'A'
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
			  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		
		</cfquery>
	</cftransaction>
<cfelseif isdefined("statI")>
	<!--- modifica estado del Socio de Negocio --->
	<cfset update_socio(Form.CDid, session.Ecodigo, 1) >

	<!--- modifica estado del cliente --->
	<cfquery name="update" datasource="#session.DSN#">
		update ClienteDetallista
		set CDactivo = 'I'
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
		  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		
	</cfquery>
<cfelseif isdefined("statR")>
	<!--- modifica estado del Socio de Negocio --->
	<cfset update_socio(Form.CDid, session.Ecodigo, 1) >

	<!--- modifica estado del cliente --->
	<cfquery name="update" datasource="#session.DSN#">
		update ClienteDetallista
		set CDactivo = 'R'
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
		  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		
	</cfquery>
<cfelseif isdefined("statP")>
	<!--- modifica estado del Socio de Negocio --->
	<cfset update_socio(Form.CDid, session.Ecodigo, 1) >

	<!--- modifica estado del cliente --->
	<cfquery name="update" datasource="#session.DSN#">
		update ClienteDetallista
		set CDactivo = 'P'
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
		  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		
	</cfquery>
</cfif>

<cflocation url="AprobarCliente.cfm?CDid=#form.CDid#&#params#">


