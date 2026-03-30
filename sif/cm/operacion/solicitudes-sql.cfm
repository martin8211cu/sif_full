<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Cualquier  problema ver los respaldos del 4/8 o 5/8 2004 --->
<cf_navegacion name="SC_INV" default="-1">

<cfif url.SC_INV NEQ -1>
	<cfset LvarCFM_lista	= "solicitudes-lista_IN.cfm">
	<cfset LvarCFM_form		= "solicitudes_IN.cfm">
<cfelse>
	<cfset LvarCFM_lista = "solicitudes-lista.cfm">
	<cfset LvarCFM_form		= "solicitudes.cfm">
</cfif>
<cfparam name="form.action" default="#LvarCFM_lista#">

<cfset Request.Error.Backs = 1>

<cfif isdefined("form.Observaciones")>
	<cfset form.Observaciones = replace(#form.Observaciones#,",","")>
</cfif>

<!--- Funcion que verifica si una Solicitud de Compras se puede modificar --->
<cffunction name="sbVerificaESestadoModificar" returntype="void">
	<cfargument name="id" type="numeric" required="yes">

	<cfquery name="rsSQL" datasource="#session.DSN#">
		select a.ESestado
		  from ESolicitudCompraCM a
		where a.ESidsolicitud = <cfqueryparam value="#id#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfif findNoCase("rechazad",form.Action)>
		<cfset LvarESestado = -10>
	<cfelse>
		<cfset LvarESestado = 0>
	</cfif>

	<cfif rsSQL.ESestado NEQ LvarESestado>
		<cf_errorCode	code = "50327"
						msg  = "La solicitud de compra no se puede modificar @errorDat_1@:@errorDat_2@ NEQ @errorDat_3@,"
						errorDat_1="#form.Action#"
						errorDat_2="#rsSQL.ESestado#"
						errorDat_3="#LvarESestado#"
		>
	</cfif>
</cffunction>

<!--- Funcion que devuelve true si el tipo de solicitud es de compra directa,
      sino devuelve false --->
<cffunction name="esTipoSolicitudCompraDirecta" returntype="boolean">
	<cfargument name="CMTScodigo" type="string" required="yes">

	<cfquery name="compraDirecta" datasource="#session.DSN#">
		select b.CMTScompradirecta
		from CMTiposSolicitud b
		where b.Ecodigo =  #session.Ecodigo#
			and b.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CMTScodigo#">
	</cfquery>

	<cfif compraDirecta.CMTScompradirecta EQ 1>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<!--- Funcion que devuelve true si la solicitud de compra actual es de compra directa,
      sino devuelve false --->
<cffunction name="esCompraDirecta" returntype="boolean">
	<cfargument name="idSolicitud" type="numeric" required="yes">

	<cfquery name="compraDirecta" datasource="#session.DSN#">
		select b.CMTScompradirecta
		from ESolicitudCompraCM	a, CMTiposSolicitud b
		where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idSolicitud#">
			and a.Ecodigo = b.Ecodigo
			and a.CMTScodigo = b.CMTScodigo
	</cfquery>

	<cfif compraDirecta.CMTScompradirecta EQ 1>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<!--- Funcion que devuelve true si el articulo indicado esta en un contrato
      vigente, sino devuelve false --->
<cffunction name="articuloEnContratos" returntype="boolean">
	<cfargument name="idArticulo" type="numeric" required="yes">

	<cfquery name="rsArticuloContratos" datasource="#session.DSN#">
		select count(1) as cantidad
		from DContratosCM a
			inner join EContratosCM b
			on b.ECid = a.ECid
			and b.ECfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			and b.ECfechafin >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
		where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idArticulo#">
	</cfquery>

	<cfif rsArticuloContratos.cantidad gt 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<!--- Funcion que devuelve true si el concepto (servicio) indicado esta en un contrato
      vigente, sino devuelve false --->
<cffunction name="conceptoEnContratos" returntype="boolean">
	<cfargument name="idConcepto" type="numeric" required="yes">

	<cfquery name="rsConceptoContratos" datasource="#session.DSN#">
		select count(1) as cantidad
		from DContratosCM a
			inner join EContratosCM b
			on b.ECid = a.ECid
			and b.ECfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			and b.ECfechafin >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
		where a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idConcepto#">
	</cfquery>

	<cfif rsConceptoContratos.cantidad gt 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<!--- Funcion que devuelve true si el activo (categoria) indicado esta en un contrato
      vigente, sino devuelve false --->
<cffunction name="CategoriaEnContratos" returntype="boolean">
	<cfargument name="idCategoria" type="numeric" required="yes">

	<cfquery name="rsCategoriaContratos" datasource="#session.DSN#">
		select count(1) as cantidad
		from DContratosCM a
			inner join EContratosCM b
			on b.ECid = a.ECid
			and b.ECfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			and b.ECfechafin >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
		where a.Ecodigo =  #session.Ecodigo#
			and a.ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idCategoria#">
	</cfquery>

	<cfif rsCategoriaContratos.cantidad gt 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<!--- Funcion que obtiene el estado (activado o no) del parametro que indica si validar
      para compras directas bienes en contratos --->
<cffunction name="obtenerParametroValidarCDC" returntype="string">
	<cfquery name="rsParametroValidarCDC" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo =  #Session.Ecodigo#
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="710">
	</cfquery>

	<cfif rsParametroValidarCDC.RecordCount gt 0>
		<cfreturn rsParametroValidarCDC.Pvalor>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>

<!--- Function getTotal --->
<cffunction name="getTotal" returntype="numeric">
	<cfargument name="id" type="numeric" required="yes">
	<cfargument name="idieps" type="numeric" required="no" default ="0">

	<cfquery name="rsPreTotales" datasource="#session.DSN#">
		select case when (b.DStipo = 'S' or b.DStipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
			    COALESCE(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2) +
			    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
			  else
			    COALESCE(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) +
			    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
			  end as  total
		from ESolicitudCompraCM a
			inner join DSolicitudCompraCM b
				on a.ESidsolicitud=b.ESidsolicitud
			inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				and b.Icodigo=c.Icodigo
			left join Impuestos d
				on a.Ecodigo=d.Ecodigo
				and b.codIEPS=d.Icodigo
			left join Conceptos e
				on e.Cid = b.Cid
			left join Articulos f
				on f.Aid= b.Aid
		where a.ESidsolicitud = <cfqueryparam value="#id#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery name="rsTotal" dbtype="query">
		select sum(total) as total
		from rsPreTotales
	</cfquery>

	<cfif rsTotal.RecordCount gt 0 and len(trim(rsTotal.total))>
		<cfreturn rsTotal.total>
	<cfelse>
		<cfreturn 0 >
	</cfif>

</cffunction>

<!--- Function recalculaMontos --->
<cffunction name="recalculaMontos">
	<cfargument name="id" type="numeric" required="yes">
	<cfquery datasource="#session.DSN#">
		update DSolicitudCompraCM
		set DStotallinest = round(DScant * DSmontoest, 2)
		where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
	</cfquery>

</cffunction>

<!--- Function validaCFcuenta --->
<cffunction name="validaCFcuenta" output="true" access="private" returntype="numeric">
	<cfargument name="numCuenta" type="numeric" required="yes">

	<cfquery name="rsCFcuenta" datasource="#session.DSN#">
		Select CFcuenta
		from CFinanciera cf
			left outer join CPVigencia cpv
				on cf.Ecodigo=cpv.Ecodigo
				and cf.CPVid = cpv.CPVid

		where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.numCuenta#">
		    and cf.Ecodigo =  #session.Ecodigo#
			and <cf_dbfunction name="now"> >= CPVdesde
			and <cf_dbfunction name="now"> <= CPVhasta
	</cfquery>

	<cfif isdefined('rsCFcuenta') and rsCFcuenta.recordCount EQ 0>
		<cf_errorCode	code = "50328" msg = "La cuenta Financiera seleccionada no esta vigente">
	</cfif>

	<cfreturn rsCFcuenta.CFcuenta>
</cffunction>

<!--- Inicia Proceso de los botones --->
<cfif not isdefined("form.btnNuevoD") and not isdefined("form.btnRegresar")>
	<!--- Caso 1: Agregar Encabezado --->
	<cfif isdefined("form.btnAgregarE")>

		<!--- Valida que no puedan meter una solicitud de tipo compra directa y pretender que haga requición --->
		<cfif isdefined("form.TRcodigo") and len(trim(form.TRcodigo)) and esTipoSolicitudCompraDirecta(CMTScodigo)>
			<cf_errorCode	code = "50329" msg = "El Tipo de Solicitud es de Compra Directa y está indicando un tipo de requisición, no puede indicar que la solicitud es una requisición y además que sea de tipo Compra Directa.">
		</cfif>

		<cftransaction>
			<cfquery name="rs" datasource="#session.DSN#">
				select max(ESnumero) as ESnumero
				from ESolicitudCompraCM
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfset consecutivo = 1>
			<cfif rs.RecordCount gt 0 and len(trim(rs.ESnumero))>
				<cfset consecutivo = rs.ESnumero + 1>
			</cfif>

			<cfquery name="insert" datasource="#session.DSN#" >
				insert into ESolicitudCompraCM( ESnumero, Ecodigo, CFid, CMTScodigo, CMSid, SNcodigo, ESfecha, EStotalest, ESobservacion, Usucodigo, ESfalta, Mcodigo, EStipocambio, CMElinea, TRcodigo,DEid,ESlugarentrega)
					values (<cfqueryparam value="#consecutivo#" 		cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#form.CFid#"       	cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#form.CMTScodigo#"  	cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#form.CMSid#"        cfsqltype="cf_sql_numeric">,
							<cfif form.CMTScompradirecta eq 1 and isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
								<cfqueryparam value="#form.SNcodigo#" cfsqltype="cf_sql_integer">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam value="#LSParseDateTime(form.ESfecha)#" cfsqltype="cf_sql_timestamp">,
							0,
							<cfqueryparam value="#form.ESobservacion#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#session.Usucodigo#"	 cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#form.EStipocambio#" cfsqltype="cf_sql_float">,
							<cfif isdefined("form.CMElinea") and len(trim(form.CMElinea))><cfqueryparam value="#form.CMElinea#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
							<cfif isdefined("form.TRcodigo") and len(trim(form.TRcodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.TRcodigo#"><cfelse>null</cfif>,
							<cfif isdefined("form.DEid") and len(trim(form.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"><cfelse>null</cfif>,
                            <cfif isdefined("form.ESlugarentrega") and len(trim(form.ESlugarentrega))><cfqueryparam value="#form.ESlugarentrega#" cfsqltype="cf_sql_varchar"><cfelse><cf_jdbcquery_param value="null" cfsqltype="cf_sql_varchar"></cfif>
                       		)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		</cftransaction>

		<cfset modo="CAMBIO">
		<cfif form.action eq "#LvarCFM_lista#">
			<cfset form.action = "#LvarCFM_form#">
		</cfif>

	<!--- Caso 2: Borrar un Encabezado de Requisicion --->
	<cfelseif isdefined("form.btnBorrarE")>
		<cfset sbVerificaESestadoModificar(form.ESidsolicitud)>
		<cftransaction>
			<cfquery name="deleted" datasource="#session.DSN#" >
				delete from DSolicitudCompraCM
				where ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
					and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="delete" datasource="#session.DSN#" >
				delete from ESolicitudCompraCM
				where ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
			</cfquery>
		<cf_cboFormaPago TESOPFPtipoId="1" TESOPFPid="#Form.ESidsolicitud#" SQL="delete">
		</cftransaction>
		<cfset modo="ALTA">

	<!--- Caso 3: Agregar Detalle de Solicitud y opcionalmente modificar el encabezado --->
	<cfelseif isdefined("form.btnAgregarD")>
		<cfset sbVerificaESestadoModificar(form.ESidsolicitud)>

		<cfset _esTipoSolicitudCompraDirecta = esTipoSolicitudCompraDirecta(CMTScodigo)>
 		<!--- Valida que no puedan meter una solicitud de tipo compra directa y pretender que haga requición --->
		<cfif isdefined("form.TRcodigo") and len(trim(form.TRcodigo)) and _esTipoSolicitudCompraDirecta>
			<cf_errorCode	code = "50330" msg = "Error de requisición 1. El Tipo de Solicitud es de Compra Directa y está indicando un tipo de requisición, no puede indicar que la solicitud es una requisición y además que sea de tipo Compra Directa.">
		</cfif>
		<!--- Valida que solo ingrese artículos, y que los artículos no estén en ningún contrato --->
		<cfif isdefined("form.TRcodigo") and len(trim(form.TRcodigo))>
			<cfif form.DStipo NEQ 'A'>
				<cf_errorCode	code = "50331" msg = "Error de requisición 2. Está indicando que el documento se trata de una requisición, y está tratando de agregar un servicio o un activo fijo. Una Requisición solo puede contener artículos.">
			<!---<cfelseif articuloEnContratos(form.Aid)>
				<cf_errorCode	code = "50332" msg = "Error de requisición 3. Está indicando que el documento se trata de una requisición. El Artículo por incluir está en un contrato. Una Requisición solo puede contener artículos, que no estén incluídos en un contrato.">--->
			<!--- - Cuando se aplica una SC, si es de requisicion no debe de validar si existe en un contrato. --->
            </cfif>
		</cfif>

		<!--- Si el parametro esta activado se procede a validar --->
		<cfif _esTipoSolicitudCompraDirecta and obtenerParametroValidarCDC() EQ 1>
			<cfif form.DStipo EQ 'A'>
				<cfif articuloEnContratos(form.Aid)>
					<cf_errorCode	code = "50333" msg = "El bien seleccionado está en un contrato vigente y el tipo de solicitud es de compra directa y por tal razón no se puede incluir la línea">
				</cfif>
			<cfelseif form.DStipo EQ 'S'>
				<cfif conceptoEnContratos(form.Cid)>
					<cf_errorCode	code = "50333" msg = "El bien seleccionado está en un contrato vigente y el tipo de solicitud es de compra directa y por tal razón no se puede incluir la línea">
				</cfif>
			<cfelseif form.DStipo EQ 'F'>
				<cfif categoriaEnContratos(form.ACcodigo)>
					<cf_errorCode	code = "50333" msg = "El bien seleccionado está en un contrato vigente y el tipo de solicitud es de compra directa y por tal razón no se puede incluir la línea">
				</cfif>
			</cfif>
		</cfif>

		<cfquery name="consecutivod" datasource="#session.DSN#">
			select max(DSconsecutivo) as linea
			from DSolicitudCompraCM
			where ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset linea = 1 >
		<cfif consecutivod.RecordCount gt 0 and len(trim(consecutivod.linea))>
			<cfset linea = consecutivod.linea + 1 >
		</cfif>

		<cftransaction>

		   <cfset fnAltaDetalle()>

				<cf_dbtimestamp datasource="#session.dsn#"
								table="ESolicitudCompraCM"
								redirect="#LvarCFM_lista#"
								timestamp="#form.ts_rversion#"
								field1="ESidsolicitud"
								type1="numeric"
								value1="#form.ESidsolicitud#">

				<cfset total = getTotal(form.ESidsolicitud) >
				<cfquery name="update" datasource="#session.DSN#">
					update ESolicitudCompraCM
					set CFid          = <cf_jdbcquery_param value="#form.CFid#"  cfsqltype="cf_sql_numeric">,
						CMTScodigo 	  = <cf_jdbcquery_param value="#form.CMTScodigo#" cfsqltype="cf_sql_varchar">,
						ESfecha       = <cf_jdbcquery_param value="#LSParseDateTime(form.ESfecha)#" cfsqltype="cf_sql_timestamp">,
						ESobservacion = <cf_jdbcquery_param value="#form.ESobservacion#" cfsqltype="cf_sql_varchar">,
						SNcodigo	  = <cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))><cf_jdbcquery_param value="#form.SNcodigo#" cfsqltype="cf_sql_integer">
                           	 			<cfelse><cf_jdbcquery_param value="null" cfsqltype="cf_sql_integer"></cfif>,
						EStotalest	  = <cf_jdbcquery_param value="#total#" cfsqltype="cf_sql_money">,
						<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo))>
						Mcodigo		  = <cf_jdbcquery_param value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">,
						</cfif>
						EStipocambio  = <cf_jdbcquery_param value="#form.TC#" cfsqltype="cf_sql_float">,
						CMElinea      = <cfif isdefined("form.CMElinea") and len(trim(form.CMElinea))><cf_jdbcquery_param value="#form.CMElinea#" cfsqltype="cf_sql_numeric"><cfelse><cf_jdbcquery_param value="null"  cfsqltype="cf_sql_numeric"></cfif>,
						TRcodigo 	  = <cfif isdefined("form.TRcodigo") and len(trim(form.TRcodigo))><cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.TRcodigo#"><cfelse><cf_jdbcquery_param value="null" cfsqltype="cf_sql_char"></cfif>,
                        ESlugarentrega= <cfif isdefined("form.ESlugarentrega") and len(trim(form.ESlugarentrega))><cf_jdbcquery_param value="#form.ESlugarentrega#" cfsqltype="cf_sql_varchar"><cfelse><cf_jdbcquery_param value="null"  cfsqltype="cf_sql_varchar"></cfif>
					where ESidsolicitud = <cf_jdbcquery_param value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
				</cfquery>
         <cf_cboFormaPago TESOPFPtipoId="1" TESOPFPid="#Form.ESidsolicitud#" SQL="update">

		</cftransaction>

		<cfset modo="CAMBIO">
		<cfif form.action eq "#LvarCFM_lista#">
			<cfset form.action = "#LvarCFM_form#">
		</cfif>

	<!--- Caso 4: Modificar Detalle de Requisicion y opcionalmente modificar el encabezado --->
	<cfelseif isdefined("Form.btnCambiarD")>
		<cfset sbVerificaESestadoModificar(form.ESidsolicitud)>

		<cfset _esTipoSolicitudCompraDirecta = esTipoSolicitudCompraDirecta(CMTScodigo)>
		<!--- Valida que no puedan meter una solicitud de tipo compra directa y pretender que haga requición --->
		<cfif isdefined("form.TRcodigo") and len(trim(form.TRcodigo)) and _esTipoSolicitudCompraDirecta>
			<cf_errorCode	code = "50329" msg = "El Tipo de Solicitud es de Compra Directa y está indicando un tipo de requisición, no puede indicar que la solicitud es una requisición y además que sea de tipo Compra Directa.">
		</cfif>
		<!--- Valida que solo ingrese artículos, y que los artículos no estén en ningún contrato --->
		<cfif isdefined("form.TRcodigo") and len(trim(form.TRcodigo))>
			<cfif form.DStipo NEQ 'A'>
				<cf_errorCode	code = "50331" msg = "Error de requisición 2. Está indicando que el documento se trata de una requisición, y está tratando de agregar un servicio o un activo fijo. Una Requisición solo puede contener artículos.">
			<!---<cfelseif articuloEnContratos(form.Aid)>
				<cf_errorCode	code = "50332" msg = "Error de requisición 3. Está indicando que el documento se trata de una requisición. El Artículo por incluir está en un contrato. Una Requisición solo puede contener artículos, que no estén incluídos en un contrato.">
			---></cfif>
		</cfif>

		<!--- Si el parametro esta activado se procede a validar --->
		<cfif _esTipoSolicitudCompraDirecta and obtenerParametroValidarCDC() EQ 1>
			<cfif form.DStipo EQ 'A'>
				<cfif articuloEnContratos(form.Aid)>
					<cf_errorCode	code = "50333" msg = "El bien seleccionado está en un contrato vigente y el tipo de solicitud es de compra directa y por tal razón no se puede incluir la línea">
				</cfif>
			<cfelseif form.DStipo EQ 'S'>
				<cfif conceptoEnContratos(form.Cid)>
					<cf_errorCode	code = "50333" msg = "El bien seleccionado está en un contrato vigente y el tipo de solicitud es de compra directa y por tal razón no se puede incluir la línea">
				</cfif>
			<cfelseif form.DStipo EQ 'F'>
				<cfif categoriaEnContratos(form.ACcodigo)>
					<cf_errorCode	code = "50333" msg = "El bien seleccionado está en un contrato vigente y el tipo de solicitud es de compra directa y por tal razón no se puede incluir la línea">
				</cfif>
			</cfif>
		</cfif>

		<cftransaction>

				<cf_dbtimestamp datasource="#session.dsn#"
								table="DSolicitudCompraCM"
								redirect="#LvarCFM_lista#"
								timestamp="#form.dtimestamp#"
								field1="ESidsolicitud"
								type1="numeric"
								value1="#form.ESidsolicitud#"
								field2="Ecodigo"
								type2="integer"
								value2="#session.Ecodigo#"
								field3="DSlinea"
								type3="numeric"
								value3="#form.DSlinea#"
								>

                          <cfset fnCambioDetalle()>

				<cf_dbtimestamp datasource="#session.dsn#"
								table="ESolicitudCompraCM"
								redirect="#LvarCFM_lista#"
								timestamp="#form.ts_rversion#"
								field1="ESidsolicitud"
								type1="numeric"
								value1="#form.ESidsolicitud#">

				<cfset total = getTotal(form.ESidsolicitud) >

				<cfquery name="update" datasource="#session.DSN#">
					update ESolicitudCompraCM
					set CFid          = <cfqueryparam value="#form.CFid#"  cfsqltype="cf_sql_numeric">,
						CMTScodigo 	  = <cfqueryparam value="#form.CMTScodigo#" cfsqltype="cf_sql_varchar">,
						ESfecha       = <cfqueryparam value="#LSParseDateTime(form.ESfecha)#" cfsqltype="cf_sql_timestamp">,
						ESobservacion = <cfqueryparam value="#form.ESobservacion#" cfsqltype="cf_sql_varchar">,
						SNcodigo	  = <cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))><cfqueryparam value="#form.SNcodigo#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
						EStotalest	  = <cf_jdbcQuery_param value="#total#" cfsqltype="cf_sql_money">,
						<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo))>
						Mcodigo		  = <cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">,
						</cfif>
						EStipocambio  = <cfqueryparam value="#form.EStipocambio#" cfsqltype="cf_sql_float">,
						CMElinea      = <cfif isdefined("form.CMElinea") and len(trim(form.CMElinea))><cfqueryparam value="#form.CMElinea#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						TRcodigo 	  = <cfif isdefined("form.TRcodigo") and len(trim(form.TRcodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.TRcodigo#"><cfelse>null</cfif>,
                        ESlugarentrega = <cfif isdefined("form.ESlugarentrega") and len(trim(form.ESlugarentrega))><cfqueryparam value="#form.ESlugarentrega#" cfsqltype="cf_sql_varchar"><cfelse><cf_jdbcquery_param value="null"  cfsqltype="cf_sql_varchar"></cfif>
					where ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
				</cfquery>
         <cf_cboFormaPago TESOPFPtipoId="1" TESOPFPid="#Form.ESidsolicitud#" SQL="update">

		</cftransaction>

		<cfset modo="CAMBIO">
		<cfif form.action eq "#LvarCFM_lista#">
			<cfset form.action = "#LvarCFM_form#">
		</cfif>


	<!--- Caso 5: Borrar detalle de Requisicion --->
	<cfelseif isdefined("Form.btnBorrarD")>
		<cfset sbVerificaESestadoModificar(form.ESidsolicitud)>

        <cfquery name="deleted" datasource="#session.DSN#">
            delete from DSolicitudCompraCM
        	<cfif form.DStipo EQ "D">
                where CPDClinea	= (  Select CPDClinea from DSolicitudCompraCM
                                      where Ecodigo		= <cfqueryparam value="#session.Ecodigo#"  cfsqltype="cf_sql_integer" >
                                        and DSlinea     = <cfqueryparam value="#form.DSlinea#"  cfsqltype="cf_sql_numeric" >
								  )
                <cfelse>
                where DSlinea 		= <cfqueryparam value="#form.DSlinea#"				cfsqltype="cf_sql_numeric" >
                </cfif>
                and Ecodigo			= <cfqueryparam value="#session.Ecodigo#"			cfsqltype="cf_sql_integer" >
                and ESidsolicitud	= <cfqueryparam value="#form.ESidsolicitud#"		cfsqltype="cf_sql_numeric" >
            </cfquery>


		<cfquery name="deleted" datasource="#session.DSN#">
			delete from DSolicitudCompraCM
			where DSlinea = <cfqueryparam value="#form.DSlinea#" cfsqltype="cf_sql_numeric" >
				and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
				and ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric" >
		</cfquery>

		<cfset total = getTotal(form.ESidsolicitud) >

				<cfquery name="update" datasource="#session.DSN#">
					update ESolicitudCompraCM
					set EStotalest	  = <cfqueryparam value="#total#" cfsqltype="cf_sql_money">
					where ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
				</cfquery>


		<!--- Recalcula el campo DSlinmontoest para todas las lineas--->
		<cfset recalculaMontos(form.ESidsolicitud) >

		<cfset modo="CAMBIO">
		<cfif form.action eq "#LvarCFM_lista#">
			<cfset form.action = "#LvarCFM_form#">
		</cfif>

	<!--- INICIO DEL APLICAR --->
	<cfelseif isdefined("form.btnAplicar")>
		<cfif isdefined("form.chk") and len(trim(form.chk))>
			<cfset form.ESidsolicitud = form.chk>
		</cfif>

        <!---►►Verifica si esta activa la Probeduria Corporativa◄◄--->
        <cfset lvarProvCorp      = false>
		<cfset lvarFiltroEcodigo = session.Ecodigo>
        <cfset params            = "">

        <cfquery name="rsEmpresaProv" datasource="#session.DSN#">
            select EPCempresaAdmin
            from DProveduriaCorporativa dpc
                inner join EProveduriaCorporativa epc
                    on epc.EPCid = dpc.EPCid
            where dpc.DPCecodigo = #session.Ecodigo#
        </cfquery>

        <cfif len(trim(rsEmpresaProv.EPCempresaAdmin))>
            <cfquery name="rsProvCorp" datasource="#session.DSN#">
                select Pvalor
                from Parametros
                where Ecodigo = #rsEmpresaProv.EPCempresaAdmin#
                and Pcodigo=5100
            </cfquery>
            <cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
                <cfset lvarFiltroEcodigo = rsEmpresaProv.EPCempresaAdmin>
                <cfset lvarProvCorp = true>
            </cfif>
        </cfif>
        <!---►►Recorre Cada una de la Solicitudes de Compra seleccionadas◄◄--->
        <cfloop list="#form.ESidsolicitud#" index="lvarESidsolicitud">

			<!---►►Recalcula el campo DSlinmontoest para todas las lineas◄◄--->
            <cfset recalculaMontos(lvarESidsolicitud) >

            <cfquery name="dataSolicitud" datasource="#session.DSN#">
                select a.EStotalest, a.Mcodigo, a.EStipocambio, a.SNcodigo, b.CMTScompradirecta, a.CFid, a.CMSid, b.CMTSconRequisicion
                from ESolicitudCompraCM	a
                	inner join CMTiposSolicitud b
                    	on a.CMTScodigo = b.CMTScodigo
                where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarESidsolicitud#">
                  and a.Ecodigo       = b.Ecodigo
            </cfquery>

            <!---►►Valida que el monto de la SC sea mayor a 0 si la SC no es de compra directa ya que esta validacion se hace antes de abrir la pantalla de completar los campos de la OC◄◄--->
            <cfif dataSolicitud.CMTScompradirecta NEQ 1 and dataSolicitud.EStotalest lte 0 and dataSolicitud.CMTSconRequisicion NEQ 1>
                <cf_errorCode	code = "50302" msg = "El monto de la solicitud debe ser mayor que cero!">
            </cfif>

            <!---►►Inicializacion de Componente de Aplicacion de Solicitudes◄◄--->
            <cfinvoke component="sif.Componentes.CM_AplicaSolicitud" method="init" returnvariable="aplica">

            <!---►►Solicitudes que no son Compra Directa◄◄--->
			<cfif dataSolicitud.CMTScompradirecta NEQ 1>
                <!---►►Se obtienen el Tipo de Solicitud◄◄--->
				<cfset tipo = aplica.obtenerTipoSolicitud( lvarESidsolicitud, session.Ecodigo ) >

                <!---►►Consulta de los Centros Funcionales presentes en la solicitud y los cuales hay que chequear el monto máximo◄◄--->
                <cfquery name="rsCentrosFuncionales" datasource="#Session.DSN#">
                    select a.CFid, b.CFdescripcion,a.CPDClinea, aa.EStotalest as total
                    from ESolicitudCompraCM aa
							inner join DSolicitudCompraCM a
								on aa.ESidsolicitud=a.ESidsolicitud
                            inner join CFuncional b
                                on a.CFid = b.CFid
                                and a.Ecodigo = b.Ecodigo
                            inner join Impuestos c
                                on a.Icodigo = c.Icodigo
                                and a.Ecodigo = c.Ecodigo
                    where a.Ecodigo =  #session.Ecodigo#
                        and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarESidsolicitud#">
                    group by a.CFid, b.CFdescripcion,a.CPDClinea, aa.EStotalest
                </cfquery>
                <cfloop query="rsCentrosFuncionales">
                    <!---►►Obtiene moneda y monto maximo del Tipo de Solicitud◄◄--->
                    <cfquery name="rsValidaMonto" datasource="#session.DSN#">
                        select Mcodigo, CMTSmontomax
                         from CMTSolicitudCF
                        where Ecodigo    = #session.Ecodigo#
                          and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo.CMTScodigo#">
                          and CFid       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCentrosFuncionales.CFid#">
                    </cfquery>

                    <!---►►Valida que el Centro Funcional este permitido para el tipo de Solicitud◄◄--->
                    <cfif rsValidaMonto.recordCount lte 0 and len(trim(rsCentrosFuncionales.CPDClinea)) eq 0>
                        <cfquery name="infoCfuncional" datasource="#session.DSN#">
                            select CFcodigo, CFdescripcion
                            from CFuncional
                            where Ecodigo= #session.Ecodigo#
                                and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCentrosFuncionales.CFid#">
                        </cfquery>
                        <cf_errorCode	code = "50303"
                                        msg  = "El centro funcional @errorDat_1@-@errorDat_2@, no esta permitido para el tipo de solicitud @errorDat_3@."
                                        errorDat_1="#trim(infoCfuncional.CFcodigo)#"
                                        errorDat_2="#infoCfuncional.CFdescripcion#"
                                        errorDat_3="#trim(tipo.CMTScodigo)#"
                        >
                        <cfabort>
                    </cfif>
                    <!---►►Validaciones para montos Limitados, Si monto es cero ==> el monto de compra es ilimitado --->
                    <cfif rsValidaMonto.CMTSmontomax gt 0>
                        <cfset errorMonto = false >

                        <!--- Caso 1: moneda de la solicitud es igual a moneda del tipo de Solicitud --->
                        <cfif dataSolicitud.Mcodigo eq rsValidaMonto.Mcodigo >
                            <cfif rsCentrosFuncionales.total gt rsValidaMonto.CMTSmontomax >
                                <cfset errorMonto = true >
                            </cfif>

                        <!--- Caso 2 monedas diferentes. Se compara en moneda local --->
                        <cfelse>
                            <cfquery name="rsMonedaLocal" datasource="#session.DSN#">
                                select Mcodigo
                                from Empresas
                                where Ecodigo= #session.Ecodigo#
                            </cfquery>

                            <!--- Calculo del monto de la solicitud en moneda local--->
                            <!--- Si es moneda local, el TC es uno --->
                            <cfset montoLocalSolicitud = rsCentrosFuncionales.total * dataSolicitud.EStipocambio >

                            <!--- Calculo del monto maximo del tipo de solicitud en moneda local--->
                            <!--- Se hace con base al tipo de cambio definido en Contabilidad  --->
                            <cfset tipoCambioMaximo = 1 >
                            <cfif rsMonedaLocal.Mcodigo neq rsValidaMonto.Mcodigo >
                                <cfquery name="rsMontoMaximoTS" datasource="#session.DSN#">
                                    select tc.Mcodigo, tc.TCcompra, tc.TCventa
                                    from Htipocambio tc
                                    where tc.Ecodigo =  #session.Ecodigo#
                                        and tc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidaMonto.Mcodigo#">
                                        and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
                                        and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
                                </cfquery>

                                <cfif rsMontoMaximoTS.recordCount gt 0 and len(trim(rsMontoMaximoTS.TCventa)) >
                                    <cfset tipoCambioMaximo = rsMontoMaximoTS.TCventa >
                                <cfelse>
                                    <cfquery name="dataMoneda" datasource="#session.DSN#">
                                        select Mnombre
                                        from Monedas
                                        where Ecodigo= #session.Ecodigo#
                                            and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidaMonto.Mcodigo#">
                                    </cfquery>
                                    <cf_errorCode	code = "50304"
                                                    msg  = "Debe definir el tipo de cambio actual para la moneda @errorDat_1@!"
                                                    errorDat_1="#dataMoneda.Mnombre#"
                                    >
                                </cfif>
                            </cfif>

                            <cfset montoLocalMaximo = rsValidaMonto.CMTSmontomax * tipoCambioMaximo>

                            <cfif montoLocalMaximo lt montoLocalSolicitud >
                                <cfset errorMonto = true >
                            </cfif>
                        </cfif>

                        <cfif errorMonto>
                            <cf_errorCode	code = "50334"
                                            msg  = "En la linea @errorDat_1@ el monto de la solicitud ha excedido el monto máximo definido en el tipo de Solicitud para el centro funcional @errorDat_2@"
                                            errorDat_1="#rsCentrosFuncionales.CurrentRow#"
                                            errorDat_2="#rsCentrosFuncionales.CFdescripcion#"
                            >
                            <cfabort>
                        </cfif>
                    </cfif>
                    <!--- monto mayor que cero --->
                </cfloop><!---fin del loop de centro funcionales--->
            </cfif><!---fin de SC que no son compra directa--->

            <!---►►Valida si la SC Puede ser Aplicada◄◄--->
            <cfif aplica.puedeAplicar(lvarESidsolicitud, session.Ecodigo) >
                <cfquery name="rsCompraDirecta" datasource="#Session.DSN#">
                    select a.CMTOcodigo, b.CMTScompradirecta
                    from ESolicitudCompraCM a
                        inner join CMTiposSolicitud b
                            on b.Ecodigo    = a.Ecodigo
                           and b.CMTScodigo = a.CMTScodigo
                    where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarESidsolicitud#">
                </cfquery>

                <!--- Actualizar los campos para la Orden de Compra en la Solicitud --->
                <cfif rsCompraDirecta.CMTScompradirecta EQ 1>
                        <cfquery name="updSolicitud" datasource="#Session.DSN#">
                            update ESolicitudCompraCM set
                                CMTOcodigo 		= <cfqueryparam cfsqltype="cf_sql_char"		value="#form.CMTOcodigo#">,
                                Rcodigo	 		= <cfqueryparam cfsqltype="cf_sql_char"		value="#form.Rcodigo#" null="#Len(Trim(Form.Rcodigo)) EQ 0#">,
                                ESOtipocambio 	= <cfqueryparam cfsqltype="cf_sql_float"	value="#form.EOtc#">,
                                ESOobs 			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.Observaciones#" null="#Len(Trim(Form.Observaciones)) EQ 0#">,
                                ESOplazoint 	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.EOplazo#">,
                                CMFPid 			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CMFPid#" >,
                                ESOporcant 		= <cfqueryparam cfsqltype="cf_sql_money" 	value="#form.EOporcanticipo#" >
                            where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#lvarESidsolicitud#">
                        </cfquery>
                </cfif>

                <cfquery name="info_tramite" datasource="#session.DSN#">
                    select
                        id_tramite,
                        b.ESnumero,
                        c.CMSnombre,
                        b.EStotalest,
                        (
                            select min(m.Msimbolo)
                            from Monedas m
                            where m.Mcodigo = b.Mcodigo
                        ) as monedaTotalEst
                    from ESolicitudCompraCM b
                        inner join CMTiposSolicitud a
                            on a.CMTScodigo = b.CMTScodigo
                            and a.Ecodigo = b.Ecodigo
                        inner join CMSolicitantes c
                            on c.CMSid = b.CMSid
                    where b.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarESidsolicitud#">
                </cfquery>
                <cfquery datasource="#session.DSN#" name="rsVerificaTramiteAnt">
                    select ProcessInstanceid
                    from ESolicitudCompraCM
                    where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarESidsolicitud#">
                </cfquery>

                <cfset tmpTramPend=1><!--- tramites pendientes 1 si 0 no --->

			<cfif isdefined("rsVerificaTramiteAnt") and len(trim(rsVerificaTramiteAnt.ProcessInstanceid)) gt 0>
                        <cfquery name="rsTramite" datasource="#session.dsn#">
                            select b.ActivityInstanceId
                            from WfxActivity b
                                join WfxProcess c
                                    on c.ProcessInstanceId = b.ProcessInstanceId
                                join WfActivity f
                                    on f.ActivityId = b.ActivityId
                            where c.State != 'COMPLETE'
                              and (
                                    b.State != 'COMPLETED'
                                or
                                    (b.State = 'COMPLETED' and f.IsFinish = 0 and not exists (select 1 from WfxTransition t where t.FromActivityInstance = b.ActivityInstanceId))
                                  )
                             and c.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaTramiteAnt.ProcessInstanceid#">
                        </cfquery>

                            <cfif isdefined("rsTramite") and len(trim(rsTramite.ActivityInstanceId)) gt 0>
                                <cfset tmpTramPend=1><!--- con tramites pendientes --->
                            <cfelse>
                                <cfset tmpTramPend=0><!--- sin tramites pendientes --->
                            </cfif>


              		<cfif IsDefined("tmpTramPend") AND tmpTramPend EQ 1><!--- realizar si tiene tramites pendientes--->

                        <cfinvoke component="sif.Componentes.Workflow.Management" method="getAllowedTransitions" returnvariable="rsTrans">
                            <cfinvokeargument name="ActivityInstanceId" value="#rsTramite.ActivityInstanceId#">
                        </cfinvoke>

                        <cfloop query="rsTrans">
                            <cfif findNoCase("ACEPTA",name) OR findNoCase("APROB",name) OR findNoCase("APRUEB",name) OR findNoCase("APLICA",name) OR findNoCase("AUTORI",name)
                                   OR findNoCase("RATIFIC",name) OR findNoCase("CONCEN",name) OR findNoCase("POSITIV",name) OR findNoCase("CONFIRM",name) OR name EQ "OK"
                                   OR findNoCase("ACCEPT",name) OR findNoCase("APPROV",name) OR findNoCase("AGREE",name) OR findNoCase("PASS",name) or TRIM(Ucase(Name)) eq 'APROBACIONJEFE'>
                                <cfinvoke component="sif.Componentes.Workflow.Management" method="doTransition">
                                    <cfinvokeargument name="fromActivityInstance" value="#rsTramite.ActivityInstanceId#">
                                    <cfinvokeargument name="TransitionId" value="#rsTrans.TransitionId#">
                                </cfinvoke>
                                <cfbreak>
                            </cfif>
                        </cfloop>
               		</cfif>
                <cfelseif Len(info_tramite.id_tramite) gt 0><!--- Inica Nuevo Tramite--->
                    <!--- VALIDA CONTROL DE PRESUPUESTO: modo consulta = true, hace rollback --->
                    <cfinvoke component="sif.Componentes.PRES_Presupuesto" method="CreaTablaIntPresupuesto" Conexion= "#session.dsn#" ContaPresupuestaria="true"/><!---======= Solicitado por Oscar Bonilla (24/05/2006)========---->
                    <cftransaction>
                        <cfset LvarNAP_OK = aplica.validaPresupuesto(lvarESidsolicitud, session.Ecodigo, true, lvarFiltroEcodigo)>
                    </cftransaction>
                    <cfif LvarNAP_OK lt 0 >
                        <script language="javascript1.2" type="text/javascript">
                            alert("Existen Cuentas de Presupuesto sin Disponible. Se va a generar un NRP en la Aprobación de la Solicitud #<cfoutput>#info_tramite.ESnumero#</cfoutput>");
                        </script>
                    </cfif>

                    <!--- Interesado: Solicitante de la SC, a quien se le puede a notificar, sobre el avance del trámite, en su rol de solicitante --->
                    <cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec" />
                    <cfset datos_sujeto = sec.getUsuarioByRef(dataSolicitud.CMSid, Session.EcodigoSDC, 'CMSolicitantes')>
                    <cfif IsDefined('datos_sujeto.Usucodigo') and Len(datos_sujeto.Usucodigo) >
                        <cfset SubjectId = datos_sujeto.Usucodigo >
                    <cfelse>
                        <cfset SubjectId = 0>
                    </cfif>

                    <!--- Iniciar trámite solamente si no ha sido iniciado --->
                    <cfset dataItems = StructNew()>
                    <cfset dataItems.ESidsolicitud = lvarESidsolicitud>
                    <cfset dataItems.Ecodigo       = session.Ecodigo>
                    <cfset dataItems.EcodigoExtra  = lvarFiltroEcodigo>
                    <cfset descripcion_tramite     = 'Aprobación de Solicitud de Compra No. ' & info_tramite.ESnumero & '<br>Solicitada por: ' & info_tramite.CMSnombre & ' Total de la solicitud: ' & info_tramite.monedaTotalEst & ' ' & numberformat(info_tramite.EStotalest,',_.__') >

                    <cfinvoke component="sif.Componentes.Workflow.Management" method="startProcess" returnvariable="processInstanceId">
                        <cfinvokeargument name="ProcessId"			value="#info_tramite.id_tramite#">
                        <cfinvokeargument name="RequesterId" 		value="#session.usucodigo#">
                        <cfinvokeargument name="SubjectId"			value="#SubjectId#">
                        <cfinvokeargument name="CForigenId"			value="#dataSolicitud.CFid#">
                        <cfinvokeargument name="Description"		value="#descripcion_tramite#">
                        <cfinvokeargument name="DataItems"			value="#dataItems#">
                        <cfinvokeargument name="ObtenerUltimaVer"   value="true">
                    </cfinvoke>

                    <cfset aplica.cambiarEstado(lvarESidsolicitud, session.Ecodigo, 10) >

                    <cfif isdefined('processInstanceId') and processInstanceId GT 0>
                        <cfquery datasource="#session.DSN#">
                            update ESolicitudCompraCM
                            set ProcessInstanceid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#processInstanceId#">
                            where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarESidsolicitud#">
                        </cfquery>
                    </cfif>
                <cfelse>
                <!--- No hay trámite --->
                    <cfinvoke component="sif.Componentes.PRES_Presupuesto" method="CreaTablaIntPresupuesto" Conexion= "#session.dsn#" ContaPresupuestaria="true"/><!---========== Solicitado por Oscar Bonilla (24/05/2006)==========---->
                    <cftransaction>

                        <cfset LvarNAP = aplica.CM_AplicaSolicitud(lvarESidsolicitud, session.Ecodigo, lvarFiltroEcodigo<!---,form.DStipo--->) ><!---RVD--->
                        <cfquery datasource="#session.DSN#">
                            update ESolicitudCompraCM set Usucodigo = #session.Usucodigo#
                            where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarESidsolicitud#">
                        </cfquery>
                    </cftransaction>

                    <cfif LvarNAP LT 0 >
                        <!--- Mandar a pantalla de error --->
                        <cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
                    <cfelse>
                        <!--- Enviar el parámetro cuando la solicitud genero ordenes de compra de por compra directa o por contrato --->
                        <cfquery name="rsOrdenes" datasource="#Session.DSN#">
                            select distinct b.EOidorden, b.EOnumero, b.SNcodigo, b.Mcodigo, b.EOestado, c.SNnombre, d.Mnombre
                            from DOrdenCM a
                                inner join EOrdenCM b
                                    on a.Ecodigo = b.Ecodigo
                                    and a.EOidorden = b.EOidorden
                                    and b.EOestado in (7,8)
                                inner join SNegocios c
                                    on b.Ecodigo = c.Ecodigo
                                    and b.SNcodigo = c.SNcodigo
                                inner join Monedas d
                                    on b.Ecodigo = d.Ecodigo
                                    and b.Mcodigo = d.Mcodigo
                            where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarESidsolicitud#">
                                and a.Ecodigo =  #session.Ecodigo#
                        </cfquery>

                        <cfif rsOrdenes.recordCount GT 0 and isdefined("LvarNAP") and LvarNAP gte 0>
                            <cfset params = "&impOrden=1">
                        </cfif>

                    </cfif>
                </cfif>
                <!--- Fin de tramite --->
            <cfelseif dataSolicitud.CMTSconRequisicion NEQ 1>
                <cf_errorCode	code = "50306" msg = "Error al aplicar la Solicitud de Compra.<br> - La Solicitud de Compra no tiene líneas de detalle.<br> - Hay líneas con montos ó cantidades en cero.">
            </cfif>
        </cfloop>
        <cfif len(trim(params)) gt 0>
            <cflocation url="#action#?Imprimir=true&ESidsolicitud=#form.ESidsolicitud##params#">
        <cfelse>
            <cflocation url="#action#">
        </cfif>
   	</cfif>
	<!--- FINAL DEL APLICAR --->
<cfelse>
	<cfif form.action eq "#LvarCFM_lista#">
		<cfset form.action = "#LvarCFM_form#">
	<cfelseif (form.action eq "solicitudesRechazadas-form.cfm" and isdefined("form.btnRegresar"))>
		<cfset form.action = "solicitudesRechazadas.cfm">
	</cfif>
</cfif>

<!---- Insertar detalles de la solicitud ---->

<cffunction name="fnAltaDetalle">
	<cfif form.DStipo EQ "D">
        <cfset form.DStipo = "S">
    <cfelseif form.DStipo EQ "A">
		<cfif isdefined("form.PlantillaDistribucion")>
   			<cfset form.CPDCid = "#form.PlantillaDistribucion#">
		<cfelse>
			<cfset form.CPDCid = 0>
		</cfif>
        	<cfset form.Cid = 0>
    <cfelse>
       <cfset form.CPDCid = "">
    </cfif>

     <cfset LvarDsMontoestXDScant = (LSParseCurrency(form.DSmontoest) * form.DScant)>
 	<cfinvoke 	component="sif.Componentes.PRES_Distribucion"
			method="GenerarDistribucion"
			returnVariable="qryDistribucion"
            CFid="#form.CFid_Detalle#"
            Cid="#form.Cid#"
            Aid = "#form.Aid#"
            CPDCid="#form.CPDCid#"
            Cantidad="#form.DScant#"
            Aplica = "0"
            Tipo = "#form.DStipo#"
            Monto="#LvarDsMontoestXDScant#"
       >


            <cfset LvarDSlinea_1 = "">

            <cfloop query="qryDistribucion">
            <!---►►Valida las Unidades◄◄--->
            <cfif NOT ISDEFINED('form.Ucodigo') OR NOT LEN(TRIM(form.Ucodigo))>
            	<cfthrow message="No se indic?el c?igo de las unidades">
            </cfif>

			<cfset pctImpIeps  = 0 >
			<cfif isdefined("form.codIEPS") and len(trim(form.codIEPS))>

				<cfquery name="rsImpieps" datasource="#session.DSN#">
					select coalesce(a.ValorCalculo,0) as Iporcentaje
					from Impuestos a
					where a.Icodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codIEPS#">
					and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>

				<cfif rsImpieps.RecordCount gt 0 and len(trim(rsImpieps.Iporcentaje)) >
					<cfset pctImpIeps = rsImpieps.Iporcentaje >
				</cfif>
			</cfif>

				<cfset valieps= (#qryDistribucion.monto# * #pctImpIeps#)/100>


           <cfquery name="insertd" datasource="#session.DSN#" >
					insert into DSolicitudCompraCM ( Ecodigo, ESidsolicitud, ESnumero, DSconsecutivo, DStipo, Aid, Alm_Aid, Cid, ACcodigo, ACid, DSdescripcion, DSobservacion, DSdescalterna,  Icodigo,
                    								 DScant, DSmontoest, DStotallinest, Ucodigo, DSfechareq, CFid, DSespecificacuenta, CFidespecifica, DSformatocuenta,FPAEid,CFComplemento,BMUsucodigo,
													 CPDCid,codIEPS,DSMontoIeps)
						values (<cf_jdbcquery_param value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
								<cf_jdbcquery_param value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">,
								<cf_jdbcquery_param value="#form.ESnumero#" cfsqltype="cf_sql_integer">,
								<cf_jdbcquery_param value="#linea#" cfsqltype="cf_sql_integer">,
								<cf_jdbcquery_param value="#form.DStipo#" cfsqltype="cf_sql_char">,
								<cfif len(trim(form.Aid)) ><cf_jdbcquery_param value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
								<cfif isdefined("form.Alm_Aid") and form.DStipo eq 'A' ><cf_jdbcquery_param value="#form.Alm_Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
								<cfif len(trim(form.Cid)) and (form.DStipo eq 'S' or form.DStipo eq 'P')><cf_jdbcquery_param value="#form.Cid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
								<cfif isdefined("form.ACcodigo") and form.DStipo eq 'F'><cf_jdbcquery_param value="#form.ACcodigo#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
								<cfif isdefined("form.ACid") and form.DStipo eq 'F'><cf_jdbcquery_param value="#form.ACid#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
								<cf_jdbcquery_param value="#form.DSdescripcion#" cfsqltype="cf_sql_varchar">,
								<cfif len(trim(form.DSobservacion1)) ><cf_jdbcquery_param value="#Mid(form.DSobservacion1,1,255)#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
								<cfif len(trim(form.DSdescalterna1)) ><cf_jdbcquery_param value="#Mid(form.DSdescalterna1, 1, 1024)#" cfsqltype="cf_sql_longvarchar"><cfelse>null</cfif>,
								<cfif len(trim(form.Icodigo))><cf_jdbcquery_param value="#form.Icodigo#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,

								<cf_jdbcquery_param value="#qryDistribucion.cantidad#" cfsqltype="cf_sql_float">,
								#LvarOBJ_PrecioU.enCF(form.DSmontoest)#,
								round(#qryDistribucion.monto#,2),
								<cf_jdbcquery_param value="#trim(form.Ucodigo)#" cfsqltype="cf_sql_varchar">,
								<cfif len(trim(form.DSfechareq))>
                                     <cf_jdbcquery_param value="#LSParseDateTime(form.DSfechareq)#" cfsqltype= "cf_sql_timestamp">
                                <cfelse> null </cfif>,
                                <cfif len(trim(qryDistribucion.CFid))>
                                    <cf_jdbcquery_param value="#qryDistribucion.CFid#" cfsqltype="cf_sql_numeric">
                                <cfelse>
                                  <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
                                </cfif>,
								<cfif isdefined("form.DSespecificacuenta")>1<cfelse>0</cfif>,
								<cfif isdefined("form.DSespecificacuenta") and isdefined("form.CFcuenta") and len(trim(form.CFcuenta))><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#validaCFcuenta(form.CFcuenta)#"><cfelse>null</cfif>,
								<cfif isdefined("form.DSespecificacuenta") and isdefined("form.CFormato") and len(trim(form.CFormato))><cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.CFormato#"><cfelse>null</cfif>,
								<cfif isdefined("form.ActividadId") and  len(trim(form.ActividadId))><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ActividadId#"><cfelse>null</cfif>,
								<cfif isdefined("form.Actividad")  and len(trim(form.Actividad))><cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.Actividad#"><cfelse>null</cfif>,
								#session.Usucodigo#
								<!---JMRV. Inicio de Cambio. 30/04/2014 --->
								<cfif isdefined("form.DStipo") and form.DStipo eq "A" and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden neq 0 and isdefined("form.PlantillaDistribucion") and form.PlantillaDistribucion eq -1>
									<cfthrow message="No ha seleccionado una distribucion.">
								<cfelseif isdefined("form.DStipo") and form.DStipo neq "A" and isdefined("form.CPDCid") and form.CPDCid EQ "">
				                    ,<CF_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">
				                <cfelseif isdefined("form.DStipo") and form.DStipo eq 'A' and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden neq 0>
									,<cf_jdbcquery_param value="#form.PlantillaDistribucion#"  cfsqltype="cf_sql_numeric">
								<cfelseif isdefined("form.DStipo") and form.DStipo eq 'A' and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden eq 0>
                    				,<CF_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">
				                <cfelse>
				                	,#form.CPDCid#
                				</cfif>,
								<!---JMRV. Fin de Cambio. 30/04/2014 --->
								<cfif isdefined("form.codIEPS") and len(trim(form.codIEPS))><cf_jdbcquery_param value="#form.codIEPS#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
								,<cf_jdbcquery_param value="#valieps#" cfsqltype="cf_sql_money">

                               )
                <cf_dbidentity1 datasource="#session.DSN#" name="insertd" returnvariable="LvarDSlinea">
            </cfquery>
            	<cf_dbidentity2 datasource="#session.DSN#" name="insertd" returnvariable="LvarDSlinea">
            <cfif form.CPDCid NEQ "">
            <cfif LvarDSlinea_1 EQ "">
            	<cfset LvarDSlinea_1 = LvarDSlinea>
            </cfif>
           			<cfquery datasource="#session.DSN#">
                      update DSolicitudCompraCM
                         set CPDClinea	= #LvarDSlinea_1#
                       where DSlinea	= #LvarDSlinea#
                    </cfquery>
            </cfif>

            <cfset linea = linea + 1>
            </cfloop>
            </cffunction>

    <cffunction name="fnCambioDetalle">
			<cfif form.DStipo EQ "D">

            <cfquery datasource="#session.DSN#" name="rsMinDSlinea">
                    Select CPDClinea from DSolicitudCompraCM
                     where Ecodigo		= <cfqueryparam value="#session.Ecodigo#"  cfsqltype="cf_sql_integer" >
                        and DSlinea     = <cfqueryparam value="#form.DSlinea#"  cfsqltype="cf_sql_numeric" >
            </cfquery>
            <cfquery datasource="#session.DSN#">
                    delete from DSolicitudCompraCM
                     where Ecodigo		= <cfqueryparam value="#session.Ecodigo#"  cfsqltype="cf_sql_integer" >
                       and ESidsolicitud	= <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric" >
                       and CPDClinea	= (  Select CPDClinea from DSolicitudCompraCM
                                         where Ecodigo		= <cfqueryparam value="#session.Ecodigo#"  cfsqltype="cf_sql_integer" >
                                            and DSlinea     = <cfqueryparam value="#form.DSlinea#"  cfsqltype="cf_sql_numeric" >)
                </cfquery>
            <cfquery name="consecutivod" datasource="#session.DSN#">
            select max(DSconsecutivo) as linea
                from DSolicitudCompraCM
                where ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
            </cfquery>
            <cfset linea = 1 >
            <cfif consecutivod.RecordCount gt 0 and len(trim(consecutivod.linea))>
                <cfset linea = consecutivod.linea + 1 >
            </cfif>
            <cfset fnAltaDetalle()>
            <cfelse>
				<!---►►Valida las Unidades◄◄--->
				<cfif NOT ISDEFINED('form.Ucodigo') OR NOT LEN(TRIM(form.Ucodigo))>
					<cfthrow message="No se indicó el código de las unidades">
				</cfif>

			<cfset pctImpIeps  = 0 >
			<cfif isdefined("form.codIEPS") and len(trim(form.codIEPS))>
				<cfquery name="rsImpieps" datasource="#session.DSN#">
					select coalesce(ValorCalculo,0) as Iporcentaje
					from Impuestos
					where Icodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codIEPS#">
					and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfif rsImpieps.RecordCount gt 0 and len(trim(rsImpieps.Iporcentaje)) >
					<cfset pctImpIeps = rsImpieps.Iporcentaje >
				</cfif>
			</cfif>

			<cfset valieps2 = NumberFormat( (#form.DSmontoest# * #form.DScant# * #pctImpIeps#)/100 ,'9,99')>

               <cfquery name="updated" datasource="#session.DSN#">
					update DSolicitudCompraCM
					set Aid           = <cfif form.DStipo eq 'A' and len(trim(form.Aid)) ><cf_jdbcquery_param value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						Alm_Aid       = <cfif form.DStipo eq 'A' and isdefined("form.Alm_Aid")><cf_jdbcquery_param value="#form.Alm_Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						Cid           = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Cid#" null="#NOT ListFind('S,P',form.DStipo) OR NOT LEN(TRIM(form.Cid))#">,
						ACcodigo      = <cfif form.DStipo eq 'F' and isdefined("form.ACcodigo") ><cf_jdbcquery_param value="#form.ACcodigo#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
						ACid          = <cfif form.DStipo eq 'F' and isdefined("form.ACid") ><cf_jdbcquery_param value="#form.ACid#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
						DSdescripcion = <cf_jdbcquery_param value="#form.DSdescripcion#" cfsqltype="cf_sql_varchar">,
						DSobservacion = <cfif len(trim(form.DSobservacion1)) ><cf_jdbcquery_param value="#Mid(form.DSobservacion1,1,255)#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
						Icodigo	 	  =	<cfif len(trim(form.Icodigo))><cf_jdbcquery_param value="#form.Icodigo#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,

                        DScant        = <cf_jdbcquery_param value="#form.DScant#" cfsqltype="cf_sql_float">,
						DSmontoest	  = #LvarOBJ_PrecioU.enCF(form.DSmontoest)#,
						DStotallinest = round(#(form.DSmontoest * form.DScant) + valieps2#,2),
						Ucodigo       = <cf_jdbcquery_param value="#trim(form.Ucodigo)#" cfsqltype="cf_sql_varchar">,
						DSdescalterna =	<cfif len(trim(form.DSdescalterna1)) ><cf_jdbcquery_param value="#Mid(form.DSdescalterna1,1,1024)#" cfsqltype="cf_sql_longvarchar"><cfelse>null</cfif>,
						DSfechareq    = <cfif len(trim(form.DSfechareq))><cf_jdbcquery_param value="#LSParseDateTime(form.DSfechareq)#" cfsqltype="cf_sql_timestamp"><cfelse>null</cfif>,
						CFid  		  =	<cfif len(trim(form.CFid_Detalle))><cf_jdbcquery_param value="#form.CFid_Detalle#" 	cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						DSespecificacuenta = <cfif isdefined("form.DSespecificacuenta")>1<cfelse>0</cfif>,
						CFidespecifica     = <cfif isdefined("form.DSespecificacuenta") and isdefined("form.CFcuenta") and len(trim(form.CFcuenta))><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#validaCFcuenta(form.CFcuenta)#"><cfelse>null</cfif>,
						DSformatocuenta    = <cfif isdefined("form.DSespecificacuenta") and isdefined("form.CFormato") and len(trim(form.CFormato))><cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.CFormato#"><cfelse>null</cfif>
						,FPAEid            = <cfif isdefined("form.ActividadId") and len(rtrim(form.ActividadId)) gt 0><cf_jdbcquery_param value="#form.ActividadId#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
						,CFComplemento     = <cfif isdefined("form.Actividad")   and len(rtrim(form.Actividad))   gt 0><cf_jdbcquery_param value="#form.Actividad#"   cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
						<cfif isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden neq 0>
						<!---JMRV. Inicio del Cambio. 30/04/2014 --->
						,CPDCid 		   = <cfif isdefined("form.DStipo") and form.DStipo eq "A" and isdefined("form.PlantillaDistribucion") and form.PlantillaDistribucion eq -1>
												<cfthrow message="No ha seleccionado una distribucion.">
											<cfelseif isdefined("form.CPDCid") and form.CPDCid EQ "" and isdefined("form.DStipo") and form.DStipo neq 'A'>
				                    			<CF_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">
				                    		<cfelseif isdefined("form.DStipo") and form.DStipo eq 'A' and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden neq 0>
												<cf_jdbcquery_param value="#form.PlantillaDistribucion#"  cfsqltype="cf_sql_numeric">
											<cfelseif isdefined("form.DStipo") and form.DStipo eq 'A' and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden eq 0>
                    							<CF_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">
				                			<cfelse>
				                				#form.CPDCid#
				                			</cfif>
						<!---JMRV. Fin del Cambio. 30/04/2014 --->
						</cfif>
						,DSMontoIeps        = <cf_jdbcquery_param value="#valieps2#" cfsqltype="cf_sql_money">
					where DSlinea       = <cf_jdbcquery_param value="#form.DSlinea#"       cfsqltype="cf_sql_numeric">
					  and Ecodigo       = <cf_jdbcquery_param value="#session.Ecodigo#"    cfsqltype="cf_sql_integer">
					  and ESidsolicitud = <cf_jdbcquery_param value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
				</cfquery>
            </cfif>
     </cffunction>

<cfoutput>
	<form action="#form.action#" method="post" name="sql">
		<cfif not isdefined("form.btnRegresar")>
			<input name="ESidsolicitud" type="hidden" value="<cfif isdefined("form.ESidsolicitud") and len(trim(form.ESidsolicitud))>#form.ESidsolicitud#<cfelseif isdefined("form.btnAgregarE")>#insert.identity#</cfif>">
			<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
		</cfif>
	</form>
</cfoutput>

<html>
<head></head>
<body>
	<script language="JavaScript1.2" type="text/javascript">
		document.forms[0].submit();
	</script>
</body>
</html>
