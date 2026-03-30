<cfcomponent>
	<cffunction name="insert_DSolicitudCompraCM" access="public" output="no" returntype="numeric">
		<cfargument name="ESidsolicitud"		default="-1"		type="numeric">
		<cfargument name="Ecodigo"				default="-1"		type="numeric">
		<cfargument name="ESnumero"				default="-1"		type="numeric">
		<cfargument name="DSconsecutivo"		default="-1"		type="numeric">
		<cfargument name="DScant"				default="-1"		type="numeric">
		<cfargument name="Aid"					default="-1"		type="any">
		<cfargument name="Alm_Aid"				default="-1"		type="any">
		<cfargument name="Cid"					default="-1"		type="any">
		<cfargument name="ACcodigo"				default="-1"		type="any">
		<cfargument name="ACid"					default="-1"		type="any">
		<cfargument name="CMCid"				default="-1"		type="numeric">
		<cfargument name="Icodigo"				default="-1"		type="string">
		<cfargument name="Ucodigo"				default="-1"		type="string">
		<cfargument name="CFcuenta"				default=null		type="any">
		<cfargument name="CFid"					default="-1"		type="numeric">
		<cfargument name="DSdescripcion"		default="-1"		type="string">
		<cfargument name="DSmontoest"			default="-1"		type="numeric">
		<cfargument name="DStotallinest"		default="-1"		type="numeric">
		<cfargument name="DStipo"				default="-1"		type="string">
		<cfargument name="DSformatocuenta"		default=null		type="any">
		<cfargument name="DSespecificacuenta"	default="-1"		type="numeric">
		<cfargument name="BMUsucodigo"			default="-1"		type="numeric">
		<cfargument name="DScontratos"			default="-1"		type="numeric">
		<cfargument name="DSimpuestoCF"			default="-1"		type="numeric">
		<cfargument name="DSnoPresupuesto"		default="-1"		type="numeric">
		<cfargument name="DScantidadNAP"		default="-1"		type="numeric">
		<cfargument name="DSmontoOriNAP"		default="-1"		type="numeric">
		<cfargument name="DScontrolCantidad"	default="-1"		type="numeric">
		<cfargument name="CPDClinea"			default="-1"		type="numeric">
		<cfargument name="CPDCid"				default=null		type="any">
		<cfargument name="codIEPS"				default="-1"		type="string">
		<cfargument name="DSMontoIeps"			default="-1"		type="numeric">
		<cfargument name="afectaIVA"			default="-1"		type="numeric">
		<cfargument name="ECid"					default="-1"		type="numeric">
		<cfargument name="DClinea"				default="-1"		type="numeric">

		<cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
		</cfif>
<!--- 		<cfif LEN(TRIM(Arguments.DSfechareq))>
			<cfset Arguments.DSfechareq = LSParseDateTime(Arguments.DSfechareq)>
		</cfif> --->
		<cfquery name="consecutivo" datasource="#session.DSN#">
			select max(DSconsecutivo) as linea
			from DSolicitudCompraCM
			where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ESidsolicitud#">
		</cfquery>
		<cfset dlinea = 1 >
		<cfif consecutivo.RecordCount gt 0 and len(trim(consecutivo.linea)) >
			<cfset dlinea = consecutivo.linea + 1>
		</cfif>
		<cfquery name="insert" datasource="#session.DSN#">
			insert into DSolicitudCompraCM ( ESidsolicitud, Ecodigo, ESnumero, DSconsecutivo, DScant, Aid, Alm_Aid, Cid, ACcodigo, ACid,
						<!--- CMCid, --->
						Icodigo, Ucodigo, CFcuenta, CFid, DSdescripcion, DSmontoest, DStotallinest, DStipo, DSfechareq, DSformatocuenta,
						DSespecificacuenta, BMUsucodigo, DScontratos, DSimpuestoCF, DSnoPresupuesto, DScantidadNAP, DSmontoOriNAP,
						DScontrolCantidad, CPDClinea, CPDCid, codIEPS, DSMontoIeps, afectaIVA, ECid, DClinea)
					 values (   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Replace(Arguments.ESidsolicitud,',','','all')#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Replace(Arguments.ESnumero,',','','all')#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DSconsecutivo#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DScant#">,
								<cfif Arguments.DStipo eq "A"><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Aid,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.DStipo eq "A"><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Alm_Aid,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.DStipo eq "S" and ( len(trim(Arguments.Cid)) gt 0 and Arguments.Cid neq "-1")><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Cid,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.DStipo eq "F"><cf_jdbcquery_param cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACcodigo,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.DStipo eq "F"><cf_jdbcquery_param cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACid,',','','all')#"><cfelse>null</cfif>,
								<cf_jdbcquery_param cfsqltype="cf_sql_char"			value="#trim(Arguments.Icodigo)#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_char"			value="#trim(Arguments.Ucodigo)#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CFcuenta#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Arguments.CFid#" null="#NOT LEN(TRIM(Arguments.CFid))#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.DSdescripcion#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(Arguments.DSmontoest,',','','all')#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(Arguments.DStotallinest,',','','all')#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.DStipo#">,
								getdate(),
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.DSformatocuenta#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DSespecificacuenta#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DScontratos#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(Arguments.DSimpuestoCF,',','','all')#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DSnoPresupuesto#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DScantidadNAP#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(Arguments.DSmontoOriNAP,',','','all')#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DScontrolCantidad#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CPDClinea#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CPDCid#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.codIEPS#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(Arguments.DSMontoIeps,',','','all')#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.afectaIVA#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.ECid#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DClinea#">
							)
		</cfquery>
		<cfreturn 0>
	</cffunction>

	<cffunction name="update_DOrdenCM" access="public" output="no" returntype="void">
		<cfargument name="Ecodigo" 			    required="no" 				type="numeric">
		<cfargument name="EOidorden" 			default="-1"  				type="numeric">
		<cfargument name="DOlinea" 				default="-1"  				type="numeric">
		<cfargument name="EOnumero" 			default="-1"  				type="numeric">
		<cfargument name="ESidsolicitud"		default="-1"  				type="numeric">
		<cfargument name="DSlinea"	 			default="-1"  				type="numeric">
		<cfargument name="CMtipo" 				default=""  				type="string">
		<cfargument name="Cid" 					default="-1"  				type="string">
		<cfargument name="Aid" 					default="-1"  				type="string">
		<cfargument name="Alm_Aid" 				default="-1"				type="string">
		<cfargument name="ACcodigo"				default="-1"				type="string">
		<cfargument name="ACid"					default="-1"  				type="string">
		<cfargument name="DOdescripcion"		default=""  				type="string">
		<cfargument name="DOobservaciones"		default=""  				type="string">
		<cfargument name="DOalterna"			default=""  				type="string">
		<cfargument name="DOcantidad"			default="0"	  				type="numeric">
		<cfargument name="DOcantsurtida"		default="0"  				type="numeric">
		<cfargument name="DOpreciou"			default="0"			 		type="numeric">
		<cfargument name="DOfechaes"			default=""  				type="string">
		<cfargument name="DOgarantia"			default="0"  				type="numeric">
		<cfargument name="CFid"					default="-1"  				type="numeric">
		<cfargument name="Icodigo"				default="-1"  				type="string">
		<cfargument name="Ucodigo"				default="-1"  				type="string">
		<cfargument name="DOfechareq"			default="-1"  				type="string">
		<cfargument name="Ppais"				default="CR"  				type="string">
		<cfargument name="DOmontodesc"			default="0"					type="string">
		<cfargument name="DOporcdesc"			default="0"					type="string">
		<cfargument name="FPAEid"			    default="-1" 				type="numeric" hint="Id de la Actividad Empresarial">
		<cfargument name="CFComplemento"	    default="" 				    type="string"  hint="Complemento de la Actividad Empresarial">
		<!---JMRV. Inicio de cambio. 30/04/2014--->
		<cfargument name="PlantillaDistribucion" default="0"				type="numeric">
		<cfargument name="CheckDistribucionHidden" 	default="0"				type="numeric">
		<!---JMRV. Fin de cambio. 30/04/2014--->

		<cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
		</cfif>

		<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
		<cfset Arguments.DOpreciou = LvarOBJ_PrecioU.enCF(Arguments.DOpreciou)>
		<cfset DOtotal = Arguments.DOcantidad * Arguments.DOpreciou>

		<!--- obteniendo la orden antes del cambio --->
		<cfquery name="getOrden" datasource="#session.DSN#">
			select * from DOrdenCM
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DOlinea#">
			  and EOidorden  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
		</cfquery>

		<cfif getOrden.CTDContid NEQ ''>
			<cfquery name="rsOrdenTC" datasource="#session.dsn#">
				select Mcodigo,EOtc from EOrdenCM where EOidorden = #EOidorden#
			</cfquery>
			<cfset tcidorden = #rsOrdenTC.EOtc#>
			<cfquery name="vDetContrato" datasource="#session.dsn#">
					select CTDCmontoTotal,isnull(CTDCmontoConsumido,0) - #getOrden.DOtotal*tcidorden# + <cfqueryparam cfsqltype="cf_sql_money" 		value="#Replace(DOtotal,',','','all')#">   as CTDCmontoConsumido
					from CTDetContrato
					where CTDCont = #getOrden.CTDContid#
			</cfquery>
			<cfif  vDetContrato.CTDCmontoConsumido GT vDetContrato.CTDCmontoTotal>
				<cfthrow message="El monto consumido es mayor que el monto del Contrato">
			</cfif>
		</cfif>

		<cfquery name="update" datasource="#session.DSN#">
			update DOrdenCM set
					EOnumero        = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Replace(Arguments.EOnumero,',','','all')#">,

					CMtipo          = <cfqueryparam cfsqltype="cf_sql_char" 	value="#Arguments.CMtipo#">,
					Cid             = <cfif Arguments.CMtipo eq "S" and ( len(trim(Arguments.Cid)) gt 0 and Arguments.Cid neq "-1")><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Cid,',','','all')#"><cfelse>null</cfif>,
					Aid             = <cfif CMtipo eq "A"><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Aid,',','','all')#"><cfelse>null</cfif>,
					Alm_Aid         = <cfif CMtipo eq "A"><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Alm_Aid,',','','all')#"><cfelse>null</cfif>,
					ACcodigo        = <cfif CMtipo eq "F"><cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACcodigo,',','','all')#"><cfelse>null</cfif>,
					ACid            = <cfif CMtipo eq "F"><cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACid,',','','all')#"><cfelse>null</cfif>,
					DOdescripcion   = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.DOdescripcion#">,
					DOobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.DOobservaciones#">,
					DOalterna       = <cfif len(trim(Arguments.DOalterna)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.DOalterna#"><cfelse>null</cfif>,
					DOcantidad      = <cfqueryparam cfsqltype="cf_sql_float" 		value="#Replace(Arguments.DOcantidad,',','','all')#">,
					DOcantsurtida   = <cfqueryparam cfsqltype="cf_sql_float" 		value="#Replace(Arguments.DOcantsurtida,',','','all')#">,
					DOpreciou       = #LvarOBJ_PrecioU.enCF(Arguments.DOpreciou)#,
					DOtotal         = <cfqueryparam cfsqltype="cf_sql_money" 		value="#Replace(DOtotal,',','','all')#">,
					DOfechaes       = <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(Arguments.DOfechaes)#">,
					DOgarantia      = <cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Arguments.DOgarantia,',','','all')#">,
					CFid	        = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.CFid,',','','all')#">,
					Icodigo	        = <cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Arguments.Icodigo)#">,
					Ucodigo	        = <cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Arguments.Ucodigo)#">,
					DOfechareq      = <cfif len(trim(Arguments.DOfechareq)) ><cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(Arguments.DOfechareq)#"><cfelse>null</cfif>,
					Ppais	        = <cfqueryparam cfsqltype="cf_sql_char"	    value="#Arguments.Ppais#">,
					DOmontodesc     = <cfqueryparam cfsqltype="cf_sql_money"	    value="#Replace(Arguments.DOmontodesc,',','','all')#">,
					DOporcdesc      = <cfqueryparam cfsqltype="cf_sql_float"	    value="#Replace(Arguments.DOporcdesc,',','','all')#">,
					FPAEid	   	    = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#" 		  null="#Arguments.FPAEid EQ -1#">,
					CFComplemento   = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.CFComplemento#" null="#NOT LEN(TRIM(Arguments.CFComplemento))#">
				<cfif Arguments.DSlinea NEQ -1 and LEN(TRIM(Arguments.DSlinea))>
					,DSlinea        = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Replace(Arguments.DSlinea,',','','all')#">
				</cfif>
				<cfif Arguments.ESidsolicitud NEQ -1 AND LEN(TRIM(Arguments.ESidsolicitud))>
					,ESidsolicitud   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.ESidsolicitud,',','','all')#">
				</cfif>
				<!---JMRV. Inicio de cambio. 30/04/2014--->
				<cfif Arguments.CheckDistribucionHidden eq 1 and  Arguments.PlantillaDistribucion NEQ 0>
					,CPDCid			= <cfif Arguments.CMtipo eq "A" and Arguments.CheckDistribucionHidden eq 1><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PlantillaDistribucion#"><cfelse>0</cfif>
				</cfif>
				<!---JMRV. Fin de cambio. 30/04/2014--->
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.DOlinea,',','','all')#">
			  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.EOidorden,',','','all')#">
		</cfquery>

		<cfif getOrden.recordCount GT 0 >
			<!--- si el detalle viene de un contrato --->
			<cfif getOrden.CTDContid NEQ ''>
				<cfquery name="rsOrdenTC" datasource="#session.dsn#">
					select Mcodigo,EOtc from EOrdenCM where EOidorden = #Arguments.EOidorden#
				</cfquery>
				<cfset tcidorden = #rsOrdenTC.EOtc#>
				<cfquery name="updDetContrato" datasource="#session.dsn#">
					update CTDetContrato set CTDCmontoConsumido = round((CTDCmontoConsumido - #getOrden.DOtotal#) + #LSParseNumber(DOtotal)*tcidorden#,2)
					where CTDCont = #getOrden.CTDContid#
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="delete_DOrdenCM" access="public" output="no" returntype="void">
		<cfargument name="Ecodigo" 				default="#session.Ecodigo#" type="numeric">
		<cfargument name="EOidorden" 			default="-1"  				type="numeric">
		<cfargument name="DOlinea" 				default="-1"  				type="numeric">

		<cfquery name="getOrden" datasource="#session.DSN#">
			select * from DOrdenCM
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DOlinea#">
			  and EOidorden  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
		</cfquery>
		<cftransaction>
		<cfif getOrden.recordCount GT 0 >
			<!--- si el detalle viene de un contrato --->
			<cfif getOrden.CTDContid NEQ ''>
				<cfquery name="rsOrdenTC" datasource="#session.dsn#">
					select Mcodigo,EOtc from EOrdenCM where EOidorden = #Arguments.EOidorden#
				</cfquery>
				<cfset tcidorden = #rsOrdenTC.EOtc#>
				<cfquery name="updDetContrato" datasource="#session.dsn#">
					update CTDetContrato set CTDCmontoConsumido = round(isnull(CTDCmontoConsumido,0) - #getOrden.DOtotal*tcidorden#,2)
					where CTDCont = #getOrden.CTDContid#
				</cfquery>
			</cfif>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from DOrdenCM
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DOlinea#">
			  and EOidorden  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
		</cfquery>
		</cfif>
		</cftransaction>
	</cffunction>
</cfcomponent>
