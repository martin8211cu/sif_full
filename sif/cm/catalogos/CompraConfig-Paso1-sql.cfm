<!--- <cf_dump var="#form#"> --->
<cfif not isdefined("Form.Nuevo")>
	<!--- Validación del Código--->
	<cfif isdefined("Form.Alta") or isdefined("Form.AltaEsp") or ((isdefined("Form.Cambio") or isdefined("Form.CambioEsp")) and Ucase(Trim(Form.CMTScodigo)) NEQ Ucase(Trim(Form.XCMTScodigo)))>
		<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
			select count(1) cantidad
			from CMTiposSolicitud
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMTScodigo = <cfqueryparam value="#Form.CMTScodigo#"   cfsqltype="cf_sql_char">
			<cfif isdefined("Form.Cambio")>
				and CMTScodigo != <cfqueryparam value="#Form.xCMTScodigo#"   cfsqltype="cf_sql_char">
			</cfif>
		</cfquery>
		<cfif rsValidaCodigo.cantidad>
			<cf_errorCode	code = "50248" msg = "El código que está intentando asignar ya existe, Proceso Cancelado!">
		</cfif>
	</cfif>
	<cfif isdefined("Form.Alta") or isdefined("Form.AltaEsp")>
		<cfquery name="insert" datasource="#session.dsn#">
			insert into CMTiposSolicitud( 	Ecodigo, CMTScodigo, CMTSdescripcion, Mcodigo, CMTSmontomax, Usucodigo, CMTSfecha, id_tramite,
											CMTStarticulo, CMTSaInventario, CMTSconRequisicion,
											CMTSservicio, CMTSactivofijo, CMTSobras, CMTScompradirecta, Usucodigomod, fechamod, FMT01COD,CMTSempleado, CMTSaprobarsolicitante, CMTScontratos)
			values (
				<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Ucase(Trim(Form.CMTScodigo))#" cfsqltype="cf_sql_char">,
				<cfqueryparam value="#Form.CMTSdescripcion#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#Form.CMTSmontomax#" cfsqltype="cf_sql_money">,
				<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
			<cfif isdefined("form.id_tramite") and len(trim(form.id_tramite))>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">,
			<cfelse>
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
		 	</cfif>
				<cfif isdefined("Form.CMTSarticulo")>1,<cfelse>0,</cfif>
				<cfset sbParaArticulo()>
				<cfqueryparam value="#Form.CMTSaInventario#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#Form.CMTSconRequisicion#" cfsqltype="cf_sql_integer">,

				<cfif isdefined("Form.CMTSservicio")>		1,<cfelse>0,</cfif>
				<cfif isdefined("Form.CMTSactivofijo")>		1,<cfelse>0,</cfif>
				<cfif isdefined("Form.CMTSobras")>			1,<cfelse>0,</cfif>
				<cfif isdefined("Form.CMTScompradirecta")>	1,<cfelse>0,</cfif>

				<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				<cfif isdefined("Form.FMT01COD")><cfqueryparam value="#Form.FMT01COD#" cfsqltype="cf_sql_char"><cfelse>null</cfif>,
                <cfif isdefined("Form.CMTSempleado")><cfqueryparam value="#Form.CMTSempleado#" cfsqltype="cf_sql_char"><cfelse>0</cfif>,
                <cfif isdefined("Form.CMTSaprobarsolicitante")>	1<cfelse>0</cfif>,
                <cfif isdefined("Form.CMTScontratos")>	1<cfelse>0</cfif>
			)
		</cfquery>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.dsn#">
			delete from CMEspecializacionTSCF
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMTScodigo = <cfqueryparam value="#Form.xCMTScodigo#"   cfsqltype="cf_sql_char">
		</cfquery>
		<cfquery name="delete" datasource="#session.dsn#">
			delete from CMTSolicitudCF
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMTScodigo = <cfqueryparam value="#Form.xCMTScodigo#"   cfsqltype="cf_sql_char">
		</cfquery>
		<cfquery name="delete" datasource="#session.dsn#">
			delete from CMTiposSolicitud
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMTScodigo = <cfqueryparam value="#Form.xCMTScodigo#"   cfsqltype="cf_sql_char">
		</cfquery>
	<cfelseif isdefined("Form.Cambio") or isdefined("Form.CambioEsp")>
		<cfif not isdefined("Form.CMTSarticulo")>
			<cfquery name="select_before_update" datasource="#session.dsn#">
				select 1
				from CMEspecializacionTSCF a
					inner join Clasificaciones b
						on a.Ecodigo = b.Ecodigo
						and a.Ccodigo = b.Ccodigo
				where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and a.CMTScodigo = <cfqueryparam value="#Form.xCMTScodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfif select_before_update.recordcount>
				<cf_errorCode	code = "50249" msg = "El Artículo no puede ser desmarcado porque ya existen Artículos agregados a la especialización de este tipo de solicitud, Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfif not isdefined("Form.CMTSservicio")>
			<cfquery name="select_before_update" datasource="#session.dsn#">
				select 1
				from CMEspecializacionTSCF a
					inner join CConceptos b
						on a.Ecodigo = b.Ecodigo
						and a.CCid = b.CCid
				where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and a.CMTScodigo = <cfqueryparam value="#Form.xCMTScodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfif select_before_update.recordcount>
				<cf_errorCode	code = "50250" msg = "El Servicio no puede ser desmarcado porque ya existen Servicios agregados a la especialización de este tipo de solicitud, Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfif not isdefined("Form.CMTSactivofijo")>
			<cfquery name="select_before_update" datasource="#session.dsn#">
				select 1
				from CMEspecializacionTSCF a
					inner join ACategoria b
						on a.Ecodigo = b.Ecodigo
						and a.ACcodigo = b.ACcodigo
					inner join AClasificacion c
						on a.Ecodigo = c.Ecodigo
						and a.ACcodigo = c.ACcodigo
						and a.ACid = c.ACid
				where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and a.CMTScodigo = <cfqueryparam value="#Form.xCMTScodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfif select_before_update.recordcount>
				<cf_errorCode	code = "50251" msg = "El Activo Fijo no puede ser desmarcado porque ya existen Activos Fijos agregados a la especialización de este tipo de solicitud, Proceso Cancelado!">
			</cfif>
		</cfif>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="CMTiposSolicitud"
			redirect="compraConfig.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo"
			type1="integer"
			value1="#session.Ecodigo#"
			field2="CMTScodigo"
			type2="char"
			value2="#form.xCMTScodigo#"
		>

		<cfquery name="update" datasource="#session.dsn#">
			update CMTiposSolicitud set
				<cfif (Ucase(Trim(Form.CMTScodigo)) NEQ Ucase(Trim(Form.XCMTScodigo)))>
				CMTScodigo 			= <cfqueryparam value="#Ucase(Trim(Form.CMTScodigo))#" cfsqltype="cf_sql_char">,
				</cfif>
				CMTSdescripcion 	= <cfqueryparam value="#Form.CMTSdescripcion#" 	cfsqltype="cf_sql_varchar">,
				Mcodigo 			= <cfqueryparam value="#Form.Mcodigo#" 			cfsqltype="cf_sql_numeric">,
				CMTSmontomax 		= <cfqueryparam value="#Form.CMTSmontomax#" 	cfsqltype="cf_sql_numeric">,
				id_tramite 			= <cfif isdefined("form.id_tramite") and len(trim(form.id_tramite))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#"><cfelse>null</cfif>,
				CMTStarticulo 		= <cfif isdefined("Form.CMTSarticulo")>1<cfelse>0</cfif>,
				CMTSservicio 		= <cfif isdefined("Form.CMTSservicio")>1<cfelse>0</cfif>,
				CMTSactivofijo 		= <cfif isdefined("Form.CMTSactivofijo")>1<cfelse>0</cfif>,
				CMTSobras 			= <cfif isdefined("Form.CMTSobras")>1<cfelse>0</cfif>,
				CMTScompradirecta 	= <cfif isdefined("Form.CMTScompradirecta")>1<cfelse>0</cfif>,
				Usucodigomod 		= <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				fechamod 			= <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				FMT01COD 			= <cfif isdefined("Form.FMT01COD")><cfqueryparam value="#Form.FMT01COD#" cfsqltype="cf_sql_char"><cfelse>null</cfif>,
				CMTSempleado		=<cfif isdefined("Form.CMTSempleado")>1<cfelse>0</cfif>
				<cfset sbParaArticulo()>
				,CMTSaInventario	= <cfqueryparam value="#Form.CMTSaInventario#" cfsqltype="cf_sql_bit">
				,CMTSconRequisicion	= <cfqueryparam value="#Form.CMTSconRequisicion#" cfsqltype="cf_sql_integer">
                ,CMTSaprobarsolicitante = <cfif isdefined("Form.CMTSaprobarsolicitante")>1<cfelse>0</cfif>
                ,CMTScontratos 		= <cfif isdefined("Form.CMTScontratos")>1<cfelse>0</cfif>
			where Ecodigo  			= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMTScodigo = <cfqueryparam value="#Form.xCMTScodigo#" cfsqltype="cf_sql_char">
		</cfquery>
	<cfelseif isdefined("Form.AplicarMonto")>
		<cfquery name="updatealld" datasource="#session.dsn#">
			update CMTSolicitudCF
				set CMTSmontomax = <cfqueryparam value="#Form.CMTSmontomax#" cfsqltype="cf_sql_money">,
					Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">,
					Usucodigomod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					fechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CMTScodigo = <cfqueryparam value="#Form.xCMTScodigo#" cfsqltype="cf_sql_char">
		</cfquery>
	</cfif>
</cfif><!---Form.Nuevo--->
<cfif isdefined("form.Alta") or isdefined("Form.Cambio")>
	<cfset Session.Compras.Configuracion.CMTScodigo = Form.CMTScodigo>
<cfelseif isdefined("form.AltaEsp") or isdefined("Form.CambioEsp")>
	<cfset Session.Compras.Configuracion.Pantalla = Session.Compras.Configuracion.Pantalla + 1>
	<cfset Session.Compras.Configuracion.CMTScodigo = Form.CMTScodigo>
<cfelseif isdefined("form.Baja")>
	<cfset Session.Compras.Configuracion.Pantalla = Session.Compras.Configuracion.Pantalla - 1>
	<cfset Session.Compras.Configuracion.CMTScodigo = "">
<cfelseif isdefined("form.Nuevo")>
	<cfset Session.Compras.Configuracion.CMTScodigo = "">
</cfif>
<cflocation url="compraConfig.cfm">

<cffunction name="sbParaArticulo">
	<cfparam name="form.CMTSaInventario"		default="0">
	<cfparam name="form.CMTSconRequisicionCHK"	default="0">
	<cfif NOT isdefined("Form.CMTSarticulo")>
		<cfset form.CMTSaInventario		= 0>
		<cfset form.CMTSconRequisicion	= 0>
	<cfelseif form.CMTSaInventario EQ 0 AND form.CMTSconRequisicionCHK EQ 0>
		<cfset form.CMTSaInventario		= 1>
		<cfset form.CMTSconRequisicion	= 1>
	<cfelse>
		<cfif form.CMTSconRequisicionCHK EQ 0>
			<cfset form.CMTSconRequisicion = 0>
		<cfelse>
			<cfparam name="form.CMTSconRequisicion"	default="1">
		</cfif>
	</cfif>
</cffunction>


