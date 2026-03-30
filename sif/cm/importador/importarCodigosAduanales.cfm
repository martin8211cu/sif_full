<!---
	Importador Códigos Aduanales
	Este archivo asume la existencia de la tabla temporal #table_name# "Datos de Entrada"
 --->

<!--- Verifica que todas las líneas tengan un código aduanal,
	  y un país e impuesto válidos si se van a agregar detalles a un código aduanal --->
<cfquery name="rsVerificaciones" datasource="#session.dsn#">
	select 1 as totalLineasError
	from #table_name# a
	where (not exists(
					select 1
					from Impuestos b
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.IcodigoPais = ltrim(rtrim(b.Icodigo))
					)
			and a.IcodigoPais is not null
			)
		or (not exists(
					select 1
					from Pais p
					where p.Ppais = a.Ppaisori
					)
			and a.Ppaisori is not null
			)
		or (a.Ppaisori is not null and a.IcodigoPais is null)
		or (a.Ppaisori is null and a.IcodigoPais is not null)
		or CAcodigo is null
</cfquery>

<cfif rsVerificaciones.RecordCount eq 0>

	<!--- Obtiene el listado de códigos aduanales con los detalles --->
	<cfquery name="rsCodigosAduanales" datasource="#session.dsn#">
		select *
		from #table_name#
	</cfquery>

	<cftransaction>
		<cfoutput query="rsCodigosAduanales" group="CAcodigo">
		
			<cfif len(trim(rsCodigosAduanales.CAcodigo)) gt 20>
				<cfset CAcodigoImportar = Mid(trim(rsCodigosAduanales.CAcodigo), 1, 20)>
			<cfelse>
				<cfset CAcodigoImportar = trim(rsCodigosAduanales.CAcodigo)>
			</cfif>
			
			<cfif len(trim(rsCodigosAduanales.CAdescripcion)) gt 120>
				<cfset CAdescripcionImportar = Mid(trim(rsCodigosAduanales.CAdescripcion), 1, 120)>
			<cfelse>
				<cfset CAdescripcionImportar = trim(rsCodigosAduanales.CAdescripcion)>
			</cfif>
		
			<!--- Verifica si el código aduanal ya existe --->
			<cfquery name="rsExisteCA" datasource="#session.dsn#">
				select CAid
				from CodigoAduanal
				where CAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CAcodigoImportar#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

			<!--- Si ya existe, modifica la descripción y el impuesto --->
			<cfif rsExisteCA.RecordCount gt 0>
				<cfif len(trim(rsCodigosAduanales.Icodigo)) gt 0 or len(trim(CAdescripcionImportar)) gt 0>
					<cfquery name="rsActualizaEncabezadoCA" datasource="#session.dsn#">
						update CodigoAduanal
						set <cfif len(trim(rsCodigosAduanales.Icodigo)) gt 0>
							Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigosAduanales.Icodigo#">
							</cfif>
							<cfif len(trim(rsCodigosAduanales.Icodigo)) gt 0 and len(trim(CAdescripcionImportar)) gt 0>
							,
							</cfif>
							<cfif len(trim(CAdescripcionImportar)) gt 0>
							CAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CAdescripcionImportar#">
							</cfif>
						where CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteCA.CAid#">
					</cfquery>
				</cfif>
				
				<cfset CAidModificado = rsExisteCA.Caid>
				
			<!--- Si no existe, lo agrega --->
			<cfelse>
			
				<!--- Verifica que el código del impuesto exista y la descripción no esté vacía --->
				<cfquery name="rsExisteImpuesto" datasource="#session.dsn#">
					select 1
					from Impuestos b
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and b.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigosAduanales.Icodigo#">
				</cfquery>
				
				<cfif rsExisteImpuesto.RecordCount eq 0 or len(trim(CAdescripcionImportar)) eq 0>
					<cf_errorCode	code = "50278" msg = "Para agregar un nuevo código aduanal, el impuesto debe ser válido y la descripción del código no puede estar vacía">
				</cfif>
				
				<!--- Inserta el encabezado del código aduanal --->		
				<cfquery name="rsInsertaEncabezadoCA" datasource="#session.dsn#">
					insert into CodigoAduanal
						(Ecodigo, Icodigo, CAcodigo, CAdescripcion, Usucodigo,
						 fechaalta, porcCIF, porcFOB, porcSegLoc, porcFletLoc,
						 porcAgeAdu, BMUsucodigo)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigosAduanales.Icodigo#">,					
							<cfqueryparam cfsqltype="cf_sql_char" value="#CAcodigoImportar#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CAdescripcionImportar#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
							0.00, 0.00, 0.00, 0.00, 0.00,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
					<cf_dbidentity1 datasource="#session.dsn#" verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 datasource="#session.dsn#" name="rsInsertaEncabezadoCA" verificar_transaccion="false">
				
				<cfset CAidModificado = rsInsertaEncabezadoCA.identity>
				
			</cfif>

			<!--- Inserta los detalles (países) del código aduanal --->
			<cfoutput>
				<cfif len(trim(rsCodigosAduanales.Ppaisori)) gt 0>
					
					<!--- Verifica si el país fue insertado previamente --->
					<cfquery name="rsExisteDetalleCA" datasource="#session.dsn#">
						select 1
						from ImpuestosCodigoAduanal
						where CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CAidModificado#">
							and Ppaisori = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigosAduanales.Ppaisori#">
					</cfquery>
					
					<!--- Si ya fue insertado, actualiza el impuesto asociado a ese país --->					
					<cfif rsExisteDetalleCA.RecordCount gt 0>
						<cfquery name="rsActualizaDetalleCA" datasource="#session.dsn#">
							update ImpuestosCodigoAduanal
							set Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigosAduanales.IcodigoPais#">
							where CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CAidModificado#">
								and Ppaisori = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigosAduanales.Ppaisori#">
						</cfquery>
					<!--- Si no existe, lo inserta --->
					<cfelse>						
						<cfquery name="rsInsertaDetalleCA" datasource="#session.dsn#">
							insert into ImpuestosCodigoAduanal
								(CAid, Ppaisori, Ecodigo, Icodigo, Usucodigo,
								 fechaalta, porcCIF, porcFOB, porcSegLoc, porcFletLoc,
								 porcAgeAdu, BMUsucodigo)
							values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#CAidModificado#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigosAduanales.Ppaisori#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigosAduanales.IcodigoPais#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
									0.00, 0.00, 0.00, 0.00, 0.00,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
						</cfquery>
					</cfif>					
				</cfif>
			</cfoutput>
		</cfoutput>
	</cftransaction>

<cfelse>
	<!--- Muestra los datos que presentaron un error --->
	<cf_errorCode	code = "50279" msg = "Se encontraron datos inválidos en el archivo. Verifique que los códigos de los impuestos y de los países (en caso de que se vaya a agregar detalles) sean válidos y que el campo de código aduanal tenga datos">
</cfif>


