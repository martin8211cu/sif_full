<!--- Sincronizacion de Socios de Negocios a LDCOM Interfaz LD-SIF Ver. 1.0 --->
<!--- Este componente crea y actualiza la informacion de los socios de negocios de SIF en el sistema LDCOM--->


<cfcomponent extends="Interfaz_Base">
<cffunction name="Ejecuta" access="public" returntype="string" output="no">

	<!--- Obtiene las empresas a sincronizar --->
	<cfquery name="rsEmpresas" datasource="sifinterfaces">
		select EQUcodigoOrigen,EQUidSIF, EQUdescripcion
		from SIFLD_Equivalencia
		where CATcodigo like 'CADENA'
		and SIScodigo like 'LD'
		<cfif  isdefined('session.Ecodigo')>
			and   EQUidSIF = '#session.Ecodigo#'
		</cfif>
	</cfquery>
	<cfif not isdefined('session.Ecodigo')>
		<cfset varEcodigo = 1>
	<cfelse>
		<cfset varEcodigo = #session.Ecodigo#>
	</cfif>
	<cfif isdefined("rsEmpresas") and rsEmpresas.recordcount GT 0>
	<cfloop query="rsEmpresas"> <!---Abre loop empresa--->
		<cfset session.dsn = getConexion(rsEmpresas.EQUidSIF)>


		<!--- Extrae los socios de negocios --->
		<cfquery name="rsSocio" datasource="#session.dsn#">
			SELECT sn.Ecodigo,
			       sn.SNcodigo,
			       sn.SNid,
			       LTRIM(RTRIM(sn.SNidentificacion)) SNidentificacion,
			       sn.SNtipo,
			       SUBSTRING(COALESCE(LTRIM(RTRIM(sn.SNnombre)), ''), 1, 100) AS SNnombre,
			       SUBSTRING(COALESCE(LTRIM(RTRIM(sn.SNdireccion)), ''), 1, 255) AS SNdireccion,
			       sn.Ppais,
			       SUBSTRING(COALESCE(sn.SNtelefono, ''), 1, 15) AS SNtelefono,
			       SUBSTRING(COALESCE(sn.SNFax, ''), 1, 15) AS SNFax,
			       SUBSTRING(COALESCE(sn.SNemail, ''), 1, 100) AS SNemail,
			       sn.SNcodigoext,
			       sn.SNtiposocio,
			       ISNULL(sn.SNplazoentrega, 0) AS SNplazoentrega,
			       ISNULL(sn.SNplazocredito, 0) AS SNplazocredito,
			       sn.Mcodigo,
			       sn.intfazLD,
			       sn.sincIntfaz,
			       ISNULL(sn.SNmontoLimiteCC, 0) AS SNmontoLimiteCC,
			       ds.codPostal,
			       ISNULL(sn.saldoCliente, 0) AS SaldoCliente,
			       GETDATE() AS fecha,
			       ISNULL(sn.SNvencompras, 0) AS SNvencompras,
			       sn.id_direccion,
			       sn.SNidentificacion2
			FROM SNegocios sn
			INNER JOIN DireccionesSIF ds ON sn.id_direccion = ds.id_direccion
			WHERE sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
			  AND sn.SNcodigo != 9999
		</cfquery>

		<cfif isdefined("rsSocio") and rsSocio.recordcount GT 0>
        <cfloop query="rsSocio"> <!---Abre loop socio--->
		<!--- <cftry> --->
			<!--- PAIS --->

			<cfquery name="rsEquivalencia" datasource="sifinterfaces">
				select max(EQUcodigoOrigen) as EQUcodigoOrigen
				from SIFLD_Equivalencia
				where CATcodigo like 'PAIS'
				and EQUempSIF =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpresas.EQUidSIF#">
				and EQUidSIF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.Ppais#">
			</cfquery>

			<cfif isdefined("rsEquivalencia") and rsEquivalencia.recordcount GT 0 and len(rsEquivalencia.EQUcodigoOrigen) GT 0>
				<cfset LvarPais = rsEquivalencia.EQUcodigoOrigen>
			<cfelse>
				<cfthrow message="No se ha definido la equivalencia para el Pais:#rsSocio.Ppais# en la Empresa:#rsEmpresas.EQUdescripcion#">
			</cfif>

			<!--- MONEDA --->
			<cfquery name="rsEquivalencia" datasource="sifinterfaces">
				select max(EQUcodigoOrigen) as EQUcodigoOrigen
				from SIFLD_Equivalencia
				where CATcodigo like 'MONEDA'
				and EQUempSIF like  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpresas.EQUidSIF#">
				and EQUidSIF like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.Mcodigo#">
			</cfquery>
			<cfif len(rsEquivalencia.EQUcodigoOrigen)>
				<cfset LvarMoneda = rsEquivalencia.EQUcodigoOrigen>
			<cfelse>
				<cfthrow message="Error de Sincronizacion. No se ha definido la equivalencia para la Moneda:#rsSocio.Mcodigo# en la Empresa:#rsEmpresas.EQUdescripcion#">
			</cfif>

			<!--- Verifica tipo de socios para controlar si se sincroniza con tabla de Clientes o con tabla de Proveedores--->
			<cfif trim(rsSocio.SNtiposocio) EQ "P" or trim(rsSocio.SNtiposocio) EQ "A">
				<cfif rsSocio.intfazLD EQ 0 and rsSocio.sincIntfaz EQ 1>
					<cfquery datasource="ldcom" >
						insert INTRProveedor (Empresa_Id,Prov_Id ,Cadena_Id,Prov_Nombre ,Prov_Cedula ,Prov_Direccion ,Prov_Email,
                        Prov_Fax ,Prov_Telefono ,Prov_Tipo ,Prov_PlazoCredito,Estatus_proceso,Error,Proveedor_Fecha,Proveedor_Fecha_Aplicado)
						values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#1#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigoext#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.EQUcodigoOrigen#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNnombre#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNidentificacion#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNdireccion#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNemail#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNfax#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNtelefono#">,
                        2,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNvencompras#">,
                        0,' ',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSocio.fecha#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSocio.fecha#">)
					</cfquery>

                 </cfif>
                 <cfif rsSocio.intfazLD EQ 2 and rsSocio.sincIntfaz EQ 1>
                 	<cfquery datasource="ldcom">
                    	insert INTRProveedor (Empresa_Id,Prov_Id ,Cadena_Id,Prov_Nombre ,Prov_Cedula ,Prov_Direccion ,Prov_Email,
                        Prov_Fax ,Prov_Telefono ,Prov_Tipo ,Prov_PlazoCredito,Estatus_proceso,Error,Proveedor_Fecha,Proveedor_Fecha_Aplicado)
						values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#1#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigoext#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.EQUcodigoOrigen#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNnombre#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNidentificacion#">,
                        <cfif #LEN(rsSocio.SNdireccion)# GT 0>
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNdireccion#" >,
                        <cfelse>
                        	' ',
                        </cfif>
                        <cfif #LEN(rsSocio.SNemail)# GT 0>
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNemail#" >,
                        <cfelse>
                        	' ',
                        </cfif>
                        <cfif #LEN(rsSocio.SNfax)# GT 0>
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNfax#" >,
                        <cfelse>
                        	' ',
                        </cfif>
                        <cfif #LEN(rsSocio.SNtelefono)# GT 0>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNtelefono#" >,
                        <cfelse>
                        	' ',
                        </cfif>
                        -1,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNvencompras#" >,
                        0,' ',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSocio.fecha#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSocio.fecha#">)
                    </cfquery>
                 </cfif>
                 <cfquery name="updSinc" datasource="#session.dsn#">
                    	update SNegocios
                        set intfazLD=1
                        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.Ecodigo#">
                        and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigo#">
                 </cfquery>
			</cfif>

			<cfif (trim(rsSocio.SNtiposocio) EQ "C" or trim(rsSocio.SNtiposocio) EQ "A") and rsSocio.sincIntfaz EQ 1>
				<cfset intfaz = rsSocio.intfazLD>
                <cfset saldoSN =  rsSocio.SaldoCliente>
				<cfset limite = rsSocio.SNmontoLimiteCC>
                <cfquery name="getSaldoCliente" datasource="#session.dsn#">
                	select
	   					coalesce(SUM(round(d.Dsaldo * case when t.CCTtipo = 'D' then 1.00 else -1.00 end, 2)),0) as Saldo
		 			from Documentos d
		 			inner join CCTransacciones t on t.CCTcodigo = d.CCTcodigo and t.Ecodigo = d.Ecodigo
				    where d.Dsaldo <> 0.00
                    and d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.Ecodigo#">
                    and d.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigo#">
                </cfquery>

				<cfif trim(rsSocio.SNtiposocio) NEQ "A"> <!--- No se ejecuta cuando es tipo A para que se procese como Cliente --->
	                <cfif saldoSN NEQ getSaldoCliente.Saldo>
	                		<cfset intfaz=0>
	                        <cfset saldoSN=getSaldoCliente.Saldo>
	                </cfif>
				</cfif>

                <!--- <cfif intfaz NEQ 1 and rsSocio.SNmontoLimiteCC GT 0>  ---><!--- se agrega filtro para exportar solo los Socios Cleintes con limite de credito definido --->
				<cfif rsSocio.SNmontoLimiteCC GT 0 AND rsSocio.intfazLD NEQ 1>
					<cfquery datasource="ldcom">
						insert INTRCliente (Empresa_Id,Cliente_Id,Cadena_id,Cliente_Nombre,Cliente_Nombre_Comercial,Cliente_Cedula,Cliente_Apdo,
                        Cliente_Direccion,Cliente_Email,Cliente_Celular,Cliente_Fax,Cliente_Telefono,Cliente_Plazo,Cliente_Credito_Limite,
                        Cliente_Credito_Saldo,Estatus_Proceso,Error,Cliente_Fecha,Cliente_Fecha_Aplicado)
						values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#1#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigoext#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.EQUcodigoOrigen#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNnombre#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNnombre#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNidentificacion#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.codPostal#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNdireccion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNemail#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNfax#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNtelefono#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNtelefono#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNplazocredito#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#rsSocio.SNmontoLimiteCC#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#saldoSN#">,
                        0,' ',
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSocio.fecha#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSocio.fecha#">)
					</cfquery>
                    <cfquery name="updSinc" datasource="#session.dsn#">
                    	update SNegocios
                        set intfazLD=1,SaldoCliente=#saldoSN#
                        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.Ecodigo#">
                        and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigo#">
                    </cfquery>
                 </cfif>
			</cfif>
		<!--- <cfcatch type="any">
			<cfoutput>
				<table>
					<tr>
						<td>
							Error: #cfcatch.message#
						</td>
					</tr>
					<cfif isdefined("cfcatch.detail") AND len(cfcatch.detail) NEQ 0>
						<tr>
							<td>
								Detalles: #cfcatch.detail#
							</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.sql") AND len(cfcatch.sql) NEQ 0>
						<tr>
							<td>
								SQL: #cfcatch.sql#
							</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.queryError") AND len(cfcatch.queryError) NEQ 0>
						<tr>
							<td>
								QUERY ERROR: #cfcatch.queryError#
							</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.where") AND len(cfcatch.where) NEQ 0>
						<tr>
							<td>
								Parametros: #cfcatch.where#
							</td>
						</tr>
					</cfif>
				</table>
			</cfoutput>

			<cfif isdefined("cfcatch.Message")>
				<cfset Mensaje="#cfcatch.Message#">
			<cfelse>
				<cfset Mensaje="">
			</cfif>
			<cfif isdefined("cfcatch.Detail")>
				<cfset Detalle="#cfcatch.Detail#">
			<cfelse>
				<cfset Detalle="">
			</cfif>
			<cfif isdefined("cfcatch.sql")>
				<cfset SQL="#cfcatch.sql#">
			<cfelse>
				<cfset SQL="">
			</cfif>
			<cfif isdefined("cfcatch.where")>
				<cfset PARAM="#cfcatch.where#">
			<cfelse>
				<cfset PARAM="">
			</cfif>
			<cfif isdefined("cfcatch.StackTrace")>
				<cfset PILA="#cfcatch.StackTrace#">
			<cfelse>
				<cfset PILA="">
			</cfif>

			<cfquery datasource="sifinterfaces">
				insert into SIFLD_Errores
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila,Ecodigo)
				values
				('Sinc_Socios',
				'SNegocios',
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.Ecodigo#">)
			</cfquery>
		</cfcatch>
		</cftry> --->
		</cfloop> <!---Cierra loop socio--->
		</cfif>


	</cfloop> <!---Cierra loop empresa--->
	</cfif>
</cffunction>
</cfcomponent>