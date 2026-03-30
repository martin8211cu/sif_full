<!--- Importa Direcciones para Socios de Negocio --->
<!--- Todo se hace para la empresa de la sessión --->

<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
</cfquery>


<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<!--- Inicio Valida que exista el Socio de Negocios. --->
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad
		from SNegocios
		where SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.SNnumero#">
		  and Ecodigo  = #session.Ecodigo#
	</cfquery>

	<cfif rsCheck.cantidad eq 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. El Socio de Negocios número (#rsImportador.SNnumero#) no existe en el sistema!')
		</cfquery>
	<cfelse>
		<!--- Busca el SNid con el SNnumero y la empresa --->
		<cfquery name="rsSNid" datasource="#session.DSN#">
			select min(SNid) as SNid
			from SNegocios
			where SNnumero = '#SNnumero#'
			  and Ecodigo = #session.Ecodigo#
		</cfquery>
	
		<!--- Valida que la dirección del socio no exista en el sistema --->
		<cfif len(trim(SNDcodigo))>
			<cfquery name="rsCheck" datasource="#session.dsn#">
				select count(1) as cantidad
				from SNDirecciones
				where SNDcodigo = '#rsImportador.SNDcodigo#'
				  and Ecodigo = #session.Ecodigo#
				  and SNid = #rsSNid.SNid#
			</cfquery>
			
			<cfif rsCheck.cantidad gt 0 >
				<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
					values ('Error. La dirección (#rsImportador.SNDcodigo#) ya existe en el sistema para el socio (#rsImportador.SNnumero#)!')
				</cfquery>
			</cfif>
			
			<!--- Valida que la dirección del socio de negocios no venga repetida en el archivo a importar --->
			<cfquery name="rsCheck" datasource="#session.DSN#">
				select count(1) as cantidad, SNDcodigo
				from #table_name# 
				where SNDcodigo = '#rsImportador.SNDcodigo#'
				and SNnumero = '#rsImportador.SNnumero#'
				group by SNDcodigo
				having count(1) > 1
			</cfquery>
		
			<cfif rsCheck.cantidad gt 0 >
				<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
					values ('Error. La dirección (#rsImportador.SNDcodigo#) del socio (#rsImportador.SNnumero#) viene repetida (#rscheck.cantidad# veces) en el archivo a importar!')
				</cfquery>
			</cfif>
		</cfif><!--- SNDcodigo --->
	</cfif>
	<!--- Fin Valida que exista el Socio de Negocios. --->
	
	
	<!--- Si viene el país, valida que el país exista en la tabla Pais --->
	<cfif len(trim(rsImportador.Ppais))>
		<cfquery name="rsCheck" datasource="#session.DSN#">
			select count(1) as cantidad
			from #table_name# a
			inner join Pais b
				on upper(b.Ppais) = upper(a.Ppais)
			where upper(a.Ppais) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(rsImportador.Ppais)#">
		</cfquery>
		<cfif rsCheck.cantidad EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. El Pais (#rsImportador.Ppais#) no existe en el sistema! (Favor pedir un listado de la tabla Pais a su DBA)')
			</cfquery>
		</cfif>
	</cfif>
</cfloop>

	
<cfquery name="rsErrores" datasource="#session.DSN#">
	select count(1) as cantidad
	from #errores#
</cfquery>


<cfif rsErrores.cantidad GT 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select Error as MSG
		from #errores#
		group by Error
	</cfquery>
	<cfreturn>

	
<cfelseif rsErrores.cantidad EQ 0>
	<cftransaction>
		<cfloop query="rsImportador">
			<!--- Busca el SNid y el SNcodigo con el SNnumero y la empresa --->
			<cfquery name="rsSNid" datasource="#session.DSN#">
				select min(SNid) as SNid, min(SNcodigo) as SNcodigo
				from SNegocios
				where SNnumero = '#SNnumero#'
				  and Ecodigo = #session.Ecodigo#
			</cfquery>

			<cfset LvarSNid = rsSNid.SNid>
			<cfset LvarSNcodigo = rsSNid.SNcodigo>
			
			<!--- Inserta la dirección en DireccionesSIF para obtener el id_direccion --->
			<cfquery datasource="#session.DSN#" name="rsNuevaDir">
				insert into DireccionesSIF(
					Ppais,
					atencion, 
					direccion1, 
					direccion2, 
					ciudad, 
					estado, 
					codPostal)
				values(
					<cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Ppais)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#atencion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#direccion1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#direccion2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ciudad#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#estado#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#codPostal#">
					
				)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsNuevaDir">
			
			<!--- Si el código de la dirección viene vacía, hay que ponerle un concecutivo --->
			<cfif len(trim(SNDcodigo)) eq 0>
				<cfquery name="rsConsecutivo" datasource="#session.DSN#">
					select coalesce(count(1),0) as cuenta
					from SNDirecciones
					where SNid = #LvarSNid#
					  and id_direccion = #rsNuevaDir.identity#
				</cfquery>
			</cfif>
			
			<!--- Si encuentra el socio de Negocios con el campo id_direccion en nulo... lo actualiza --->
			<cfquery name="rsSocio" datasource="#session.DSN#">
				select count(1) as cantidad
				from SNegocios
				where SNid = #LvarSNid#
				and id_direccion is null
			</cfquery>
			
			<cfif rsSocio.cantidad eq 1>
				<cfquery name="" datasource="#session.DSN#">
					update SNegocios
					set id_direccion =#rsNuevaDir.identity#
					where SNid = #LvarSNid#
				</cfquery>
			</cfif>
			
			<!--- Asocia la direccion al socio --->
			<cfquery datasource="#session.DSN#">
				insert into SNDirecciones
				  (
					SNid,
					id_direccion,
					Ecodigo,
					SNcodigo,
					SNDfacturacion, 
					SNDenvio, 
					SNDactivo, 
					SNDcodigo, 
					SNnombre, 
					SNcodigoext, 
					SNDtelefono, 
					SNDFax, 
					SNDemail
				  )
				values
				 (
					#LvarSNid#,
					#rsNuevaDir.identity#,
					#session.Ecodigo#,
					#LvarSNcodigo#,
					<cfif len(trim(SNDfacturacion))>
						<cfqueryparam cfsqltype="cf_sql_bit" value="#SNDfacturacion#">,
					<cfelse>
						0,
					</cfif>
					<cfif len(trim(SNDenvio))>
						<cfqueryparam cfsqltype="cf_sql_bit" value="#SNDenvio#">,
					<cfelse>
						0,
					</cfif>
					<cfif len(trim(SNDactivo))>
						<cfqueryparam cfsqltype="cf_sql_bit" value="#SNDactivo#">,
					<cfelse>
						1,
					</cfif>
					<cfif len(trim(SNDcodigo))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#SNDcodigo#">,
					<cfelse>
						#trim(SNnumero) & '-' & (rsConsecutivo.cuenta +1)#,
					</cfif>
					<cfif len(trim(SNnombre))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SNnombre#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(SNcodigoext))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SNcodigoext#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(SNDtelefono))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SNDtelefono#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(SNDFax))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SNDFax#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(SNDemail))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SNDemail#">
					<cfelse>
						null
					</cfif>
				 )
			</cfquery>	
		</cfloop>
	<cftransaction action="commit"/>
	</cftransaction>
</cfif>