
<cfcomponent>

	<cffunction name="GenerarDistribucion" returntype="query" output="true">

		<cfargument name="CFid">
		<cfargument name="Cid">
 		<cfargument name="Aid">
		<cfargument name="CPDCid">
  		<cfargument name="Tipo" default="0">
        <cfargument name="Aplica" default="-1" >
		<cfargument name="cantidad"		type="numeric">
		<cfargument name="monto" 		type="numeric">
        <cfargument name="Modulo"		type="string" default="" required="no">
		<cfargument name="descuento" 	type="numeric" default="0">
		<cfargument name="Presupuesto" 	type="boolean" default="false">
		<cfargument name="Ccodigo">


	 		<!--- Si no hay que distribuir se crea una distribución de un registro con los valores originales --->
		<cfif Arguments.CPDCid EQ "" or (Arguments.Tipo EQ "A" and Arguments.Aplica NEQ 1) or (Arguments.Tipo EQ "0" and Arguments.CPDCid EQ "" ) >
			<cfset rsDistribucion = queryNew("CFid,Cantidad,Monto")>
			<cfset QueryAddRow(rsDistribucion, 1)>
			<cfset QuerySetCell(rsDistribucion, "CFid",			"#Arguments.CFid#", 1)>
			<cfset QuerySetCell(rsDistribucion, "Cantidad", 	"#Arguments.cantidad#", 1)>
			<cfset QuerySetCell(rsDistribucion, "Monto",		"#Arguments.monto#", 1)>
			<cfreturn rsDistribucion>
		</cfif>

		<!--- Se Verifica que la distribución esté Activa --->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			Select	CPDCdescripcion, CPDCactivo, CPDCporcTotal
			  from CPDistribucionCostos
			 where CPDCid = #Arguments.CPDCid#
			   and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsSQL.recordcount EQ 0>
			<cfthrow message="Tipo de Distribución de Costos CPDCid=[#Arguments.CPDCid#] no existe">
		</cfif>
		<cfif rsSQL.CPDCactivo EQ 0>
			<cfthrow message="Tipo de Distribución de Costos #rsSQL.CPDCdescripcion# no está activo">
		</cfif>
		<cfif rsSQL.CPDCporcTotal NEQ 100>
			<cfthrow message="Tipo de Distribución de Costos #rsSQL.CPDCdescripcion# no llega al 100%">
		</cfif>

		<!--- Se genera la distribucion por centro funcional con los porcentajes correspondientes --->
       <cfif (Tipo NEQ "A" and Arguments.Aplica EQ 1) or (Tipo NEQ "A" and Arguments.Aplica EQ -1) or (Tipo NEQ "A" and Arguments.Aplica EQ 0)>
            <cfquery name="rsDistribucion" datasource="#session.DSN#">
                Select	d.CFid, cf.CFcodigo, row_number()over(order by d.CFid) as NumLineaDistribucion
                        , #Arguments.cantidad#*(CPDCCFporc/100)		 		as cantidad
                        , round(#Arguments.monto#*(CPDCCFporc/100),2)		as monto
                        , round(#Arguments.descuento#*(CPDCCFporc/100),2)	as descuento
                        , CPDCCFdefault as dfl
                        ,<cfqueryparam cfsqltype="cf_sql_numeric" value="0"> as IdCuenta
                        ,'' as Cuenta,'' as MSG
                  from CPDistribucionCostosCF d
                    inner join CFuncional cf on cf.CFid = d.CFid
                 where CPDCid = #Arguments.CPDCid#
            </cfquery>
        </cfif>

    <cfif Tipo EQ "A" and CPDCid NEQ "" and CPDCid NEQ 0>
		<cfquery name="rsDistribucion" datasource="#session.DSN#">
			Select	d.CFid, cf.CFcodigo, row_number()over(order by d.CFid) as NumLineaDistribucion
					, #Arguments.cantidad#		 						as cantidad
					, round(#Arguments.monto#*(CPDCCFporc/100),2)		as monto
					, round(#Arguments.descuento#*(CPDCCFporc/100),2)	as descuento
					, CPDCCFdefault as dfl
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="0"> as IdCuenta
					,'' as Cuenta,'' as MSG
			  from CPDistribucionCostosCF d
			  	inner join CFuncional cf on cf.CFid = d.CFid
			 where CPDCid = #Arguments.CPDCid#
		</cfquery>
   </cfif>
		<!--- Se obtiene la cuenta Financiera, y el CF default para ajustes --->
		<cfset LvarErrores = 0>
		<cfset LvarRowDfl = 1>
				<cfloop query="rsDistribucion">
			<cfset LvarRow = rsDistribucion.currentRow>
		<cfif Arguments.Tipo EQ "A" and Arguments.CPDCid NEQ "">
        	<cfset LvarStr = fnObtieneCtaArticulo(Arguments.Aid, rsDistribucion.CFid, Arguments.Tipo, Arguments.Presupuesto)>
        <cfelse>
			  <cfif isdefined("Arguments.Cid") and Arguments.Cid neq ''>
				<cfset LvarStr = fnObtieneCtaConcepto(Arguments.Cid, rsDistribucion.CFid, Arguments.Presupuesto,Arguments.Modulo)>
			  <cfelse>
			 	<cfset LvarStr = fnObtieneCtaConcepto(0, rsDistribucion.CFid, Arguments.Presupuesto,Arguments.Modulo,Arguments.Ccodigo)>
			  </cfif>
		</cfif>

			<cfif LvarStr.MSG EQ "OK">
				<cfset QuerySetCell(rsDistribucion, "IdCuenta", LvarStr.IdCuenta,	LvarRow)>
				<cfset QuerySetCell(rsDistribucion, "cuenta", 	LvarStr.Cuenta,		LvarRow)>
			<cfelse>
				<cfset LvarErrores = LvarErrores + 1>
				<cfset QuerySetCell(rsDistribucion, "cuenta", 	LvarStr.Cuenta,		LvarRow)>
				<cfset QuerySetCell(rsDistribucion, "MSG", 		LvarStr.MSG,		LvarRow)>
				<cfthrow message = #LvarStr.MSG#>
			</cfif>
			<cfif rsDistribucion.dfl EQ 1>
				<cfset LvarRowDfl = rsDistribucion.currentRow>
			</cfif>
		</cfloop>

		<cfif LvarErrores NEQ 0>
			<font color="##FF0000"><strong>ERRORES EN LA GENERACIÓN DE LA DISTRIBUCIÓN</strong></font>
			<cfquery name="rsDistribucion" dbtype="query">
				select CFCODIGO, cast(MONTO*100 as integer)/100.0 as MONTO, CUENTA, MSG
				  from rsDistribucion
			</cfquery>

		<cfelse>
			<!--- La diferencia entre el total distribuido y el monto original se le asigna al CF default --->
			<cfquery name="rsTotales" dbtype="query">
				select	sum(cantidad)	as cantidad,
						sum(monto) 		as monto,
						sum(descuento)	as descuento
				  from rsDistribucion
			</cfquery>
			<cfif rsTotales.cantidad NEQ arguments.cantidad OR rsTotales.monto NEQ arguments.monto OR rsTotales.descuento NEQ arguments.descuento>
				<cfif rsTotales.cantidad NEQ arguments.cantidad and Tipo NEQ "A" >
					<cfset QuerySetCell(rsDistribucion, "cantidad", 	rsDistribucion.cantidad[LvarRowDfl] 	+ (Arguments.cantidad-rsTotales.cantidad)	, LvarRowDfl)>
				</cfif>
				<cfif rsTotales.monto NEQ arguments.monto>
					<cfset QuerySetCell(rsDistribucion, "monto",		rsDistribucion.monto[LvarRowDfl] 		+ (Arguments.monto-rsTotales.monto)			, LvarRowDfl)>
				</cfif>
				<cfif rsTotales.descuento NEQ arguments.descuento>
					<cfset QuerySetCell(rsDistribucion, "descuento",	rsDistribucion.descuento[LvarRowDfl]	+ (Arguments.descuento-rsTotales.descuento)	, LvarRowDfl)>
				</cfif>
			</cfif>
		</cfif>


		<cfreturn rsDistribucion>
	</cffunction>


	<!--- Obtiene la cuenta de un Concepto de Servicio --->
	<cffunction name="fnObtieneCtaConcepto" output="false" returntype="struct">
	<!---	<cfargument name="Tipoitem"  	type="string">--->
		<cfargument name="Cid"			type="numeric"	default="null"	required="no">
        <cfargument name="CFid"			type="numeric">
<!---		<cfargument name="Aid"			type="numeric"	default="null"	required="no">--->
		<cfargument name="Presupuesto"	type="boolean" 	default="false">
        <cfargument name="Modulo"		type="string">
		<cfargument name="Ccodigo" 		type="numeric" default=0	required="no">
        

		<cfset var LvarRES = structNew()>
		<cfset var LvarFecha = now()>
    

		<cfobject component="sif.Componentes.AplicarMascara" name="mascara">

		<cftry>
		<cfif Arguments.Ccodigo neq 0>
            <cfset LvarRES.cuenta = mascara.fnComplementoItem(session.Ecodigo, Arguments.CFid, -1, "C", "", 0, "", "","","","", session.Ecodigo, -1, 0,Arguments.Ccodigo)>
		<cfelse>
  	    	<cfset LvarRES.cuenta = mascara.fnComplementoItem(session.Ecodigo, Arguments.CFid, -1, "S", "", Arguments.Cid, "", "")>
		</cfif>
		<cfcatch type="any">
			<cfset LvarRES.MSG = cfcatch.Message>
			<cfset LvarRES.cuenta = "">
		</cfcatch>
		</cftry>

		<cfif LvarRES.cuenta NEQ "">
			<!--- Obtener Cuenta --->
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
					  method="fnGeneraCuentaFinanciera"
					  returnvariable="LvarError">
						<cfinvokeargument name="Lprm_CFformato" 		value="#LvarRES.cuenta#"/>
                        <cfif Arguments.Modulo EQ "Modulo">
						<cfinvokeargument name="Lprm_fecha" 			value="#LvarFecha#"/>
                        </cfif>
						<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
			</cfinvoke>

			<cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
				<!--- trae el id de la cuenta financiera --->
				<cfset LvarRES.MSG = "OK">
				<cfquery name="rsTraeCuenta" datasource="#session.DSN#">
					select a.CFcuenta, p.CPcuenta, p.CPformato, p.CPdescripcion
					from CFinanciera a
						inner join CPVigencia b
							 on a.CPVid     = b.CPVid
							and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between b.CPVdesde and b.CPVhasta
						left join CPresupuesto p
							 on p.CPcuenta = a.CPcuenta
					where a.Ecodigo   = #session.Ecodigo#
					  and a.CFformato = '#LvarRES.cuenta#'
				</cfquery>

				<cfif Arguments.Presupuesto>
					<cfif rsTraeCuenta.CPcuenta EQ "">
						<cfset LvarRES.MSG 		= "Cuenta Financiera no tiene Cuenta de Presupuesto">
						<cfset LvarRES.cuenta	= "CtaFinanciera: #LvarRES.cuenta#">
					<cfelse>
						<cfset LvarRES.IdCuenta	= rsTraeCuenta.CPcuenta>
						<cfset LvarRES.cuenta	= rsTraeCuenta.CPformato>
					</cfif>
				<cfelse>
					<cfset LvarRES.IdCuenta	= rsTraeCuenta.CFcuenta>
				</cfif>
			<cfelse>
				<cfset LvarRES.MSG = LvarError>
				<cfif Arguments.Presupuesto>
					<cfset LvarRES.cuenta	= "CtaFinanciera: #LvarRES.cuenta#">
				</cfif>
			</cfif>
		</cfif>
		<cfreturn LvarRES>
	</cffunction>


    <cffunction name="fnObtieneCtaArticulo" output="false" returntype="struct">
        <cfargument name="Aid"	type="numeric">
		<cfargument name="CFid"	type="numeric">
        <cfargument name="Tipo"	default="0">
		<cfargument name="Presupuesto"	type="boolean" default="false">

		<cfset var LvarRES = structNew()>
		<cfset var LvarFecha = now()>

		<cfobject component="sif.Componentes.AplicarMascara" name="mascara">

		<cftry>

			<cfset LvarRES.cuenta = mascara.fnComplementoItem(session.Ecodigo, Arguments.CFid, -1, "A", Arguments.Aid, "","", "")>


		<cfcatch type="any">
			<cfset LvarRES.MSG = cfcatch.Message>
			<cfset LvarRES.cuenta = "">
		</cfcatch>
		</cftry>


		<cfif LvarRES.cuenta NEQ "">
			<!--- Obtener Cuenta --->
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
					  method="fnGeneraCuentaFinanciera"
					  returnvariable="LvarError">
						<cfinvokeargument name="Lprm_CFformato" 		value="#LvarRES.cuenta#"/>
						<cfinvokeargument name="Lprm_fecha" 			value="#LvarFecha#"/>
						<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
			</cfinvoke>

			<cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
				<!--- trae el id de la cuenta financiera --->
				<cfset LvarRES.MSG = "OK">
				<cfquery name="rsTraeCuenta" datasource="#session.DSN#">
					select a.CFcuenta, p.CPcuenta, p.CPformato, p.CPdescripcion
					from CFinanciera a
						inner join CPVigencia b
							 on a.CPVid     = b.CPVid
							and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between b.CPVdesde and b.CPVhasta
						left join CPresupuesto p
							 on p.CPcuenta = a.CPcuenta
					where a.Ecodigo   = #session.Ecodigo#
					  and a.CFformato = '#LvarRES.cuenta#'
				</cfquery>

				<cfif Arguments.Presupuesto>
					<cfif rsTraeCuenta.CPcuenta EQ "">
						<cfset LvarRES.MSG 		= "Cuenta Financiera no tiene Cuenta de Presupuesto">
						<cfset LvarRES.cuenta	= "CtaFinanciera: #LvarRES.cuenta#">
					<cfelse>
						<cfset LvarRES.IdCuenta	= rsTraeCuenta.CPcuenta>
						<cfset LvarRES.cuenta	= rsTraeCuenta.CPformato>
					</cfif>
				<cfelse>
					<cfset LvarRES.IdCuenta	= rsTraeCuenta.CFcuenta>
				</cfif>
			<cfelse>
				<cfset LvarRES.MSG = LvarError>
				<cfif Arguments.Presupuesto>
					<cfset LvarRES.cuenta	= "CtaFinanciera: #LvarRES.cuenta#">
				</cfif>
			</cfif>
		</cfif>
		<cfreturn LvarRES>
	</cffunction>


	<!--- Obtiene la distribucion de una linea --->
		<cffunction name="ObtenerDistribucion" access="public" returntype="query" output="no">
			<cfargument name="MontoOrigen"		type="numeric">
			<cfargument name="Monto"			type="numeric">
			<cfargument name="cantidad"			type="numeric">
			<cfargument name="LineaDeDescuento"	type="numeric">
			<cfargument name="CPDCid"			type="numeric">
			<cfargument name="Tipoitem"			type="string">
			<cfargument name="Aid"				type="numeric">
			<cfargument name="tipoCambio"		type="numeric">


			<!--- Se Verifica que la distribución esté Activa --->
				<cfquery name="rsSQL" datasource="#session.DSN#">
					Select	CPDCdescripcion, CPDCactivo, CPDCporcTotal
					  from CPDistribucionCostos
					 where CPDCid = #Arguments.CPDCid#
					   and Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfif rsSQL.recordcount EQ 0>
					<cfthrow message="Tipo de Distribución de Costos CPDCid=[#Arguments.CPDCid#] no existe">
				</cfif>
				<cfif rsSQL.CPDCactivo EQ 0>
					<cfthrow message="Tipo de Distribución de Costos #rsSQL.CPDCdescripcion# no está activo">
				</cfif>
				<cfif rsSQL.CPDCporcTotal NEQ 100>
					<cfthrow message="Tipo de Distribución de Costos #rsSQL.CPDCdescripcion# no llega al 100%">
				</cfif>

				<!--- Se genera la distribucion por centro funcional con los porcentajes correspondientes --->
					<cfquery name="rsDistribucion" datasource="#session.DSN#">
						Select	d.CFid, cf.CFcodigo, d.CPDCCFporc, row_number()over(order by d.CFid) as NumLineaDistribucion
						, #Arguments.cantidad#						 										as cantidad
						, round(#Arguments.MontoOrigen#*(CPDCCFporc/100),2)									as MontoOrigen
						, round(round(#Arguments.MontoOrigen#*(CPDCCFporc/100),2)*#Arguments.tipoCambio#,2)	as Monto
						, round(#Arguments.LineaDeDescuento#*(CPDCCFporc/100),2)							as descuento
						, CPDCCFdefault as dfl
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="0"> as IdCuenta
						,'' as Cuenta,'' as MSG
				  		from CPDistribucionCostosCF d
				  		inner join CFuncional cf on cf.CFid = d.CFid
					 	where CPDCid = #Arguments.CPDCid#
					</cfquery>

					<!--- Se obtiene la cuenta Financiera, y el CF default para ajustes --->
						<cfset Presupuesto = false>
						<cfset LvarErrores = 0>
						<cfset LvarRowDfl = 1>

					<cfloop query="rsDistribucion">
						<cfset LvarRow = rsDistribucion.currentRow>
						<cfset LvarStr = fnObtieneCtaConcepto(rsDistribucion.CFid, Arguments.Tipoitem, 0, Arguments.Aid, Presupuesto,Arguments.Modulo)>
						<cfif LvarStr.MSG EQ "OK">
							<cfset QuerySetCell(rsDistribucion, "IdCuenta", LvarStr.IdCuenta,	LvarRow)>
							<cfset QuerySetCell(rsDistribucion, "cuenta", 	LvarStr.Cuenta,		LvarRow)>
						<cfelse>
							<cfset LvarErrores = LvarErrores + 1>
							<cfset QuerySetCell(rsDistribucion, "cuenta", 	LvarStr.Cuenta,		LvarRow)>
							<cfset QuerySetCell(rsDistribucion, "MSG", 		LvarStr.MSG,		LvarRow)>
						</cfif>
						<cfif rsDistribucion.dfl EQ 1>
							<cfset LvarRowDfl = rsDistribucion.currentRow>
						</cfif>
					</cfloop>


						<!--- La diferencia entre el total distribuido y el monto original se le asigna al CF default --->
						<cfquery name="rsTotales" dbtype="query">
							select	sum(MontoOrigen) as MontoOrigen,
									sum(Monto) as Monto,
									sum(descuento)	 as descuento
							  from rsDistribucion
						</cfquery>

						<cfif rsTotales.MontoOrigen NEQ arguments.MontoOrigen OR rsTotales.Monto NEQ arguments.Monto OR rsTotales.descuento NEQ arguments.LineaDeDescuento>
							<cfif rsTotales.MontoOrigen NEQ arguments.MontoOrigen>
								<cfset QuerySetCell(rsDistribucion, "MontoOrigen",		rsDistribucion.MontoOrigen[LvarRowDfl] 		+ (Arguments.MontoOrigen-rsTotales.MontoOrigen)		, LvarRowDfl)>
							</cfif>
							<cfif rsTotales.Monto NEQ arguments.Monto>
								<cfset QuerySetCell(rsDistribucion, "Monto",		rsDistribucion.Monto[LvarRowDfl] 		+ (Arguments.Monto-rsTotales.Monto)		, LvarRowDfl)>
							</cfif>
							<cfif rsTotales.descuento NEQ arguments.LineaDeDescuento>
								<cfset QuerySetCell(rsDistribucion, "descuento",	rsDistribucion.descuento[LvarRowDfl]	+ (Arguments.LineaDeDescuento-rsTotales.descuento)	, LvarRowDfl)>
							</cfif>
						</cfif>

			<cfreturn rsDistribucion>
		</cffunction>


		<!--- Inserta en la tabla "DistribucionOrdenCxP" la linea NAP a referenciar --->
			<cffunction name="insertaDistribucionCxP" access="public" output="no">
				<cfargument name="Linea"					type="numeric">
				<cfargument name="NumeroLineaReferencia"	type="numeric">
				<cfargument name="TipoMovimiento"			type="string">
				<cfargument name="LineaDistribucion"		type="numeric">
				<cfargument name="CFid"						type="numeric">
				<cfargument name="rsDistribucionCuenta">


				<cfquery name="insertaTablaDistribucion" datasource="#session.DSN#">
					insert into DistribucionCxP(	Ecodigo,
													TipoMovimiento,
													IDdocumento,
													Linea,
													CPNAPDlinea,
													CFcuenta,
													CPcuenta,
													Ccuenta,
													CPDCid,
													CFid,
													LineaDistribucion)

								select cxp.Ecodigo,
									   '#Arguments.TipoMovimiento#',
									   cxp.IDdocumento,
									   cxp.Linea,
									   case
									   		when #Arguments.NumeroLineaReferencia# > 0 then
									   			(#Arguments.NumeroLineaReferencia# * 10000) + #Arguments.LineaDistribucion#
									   		else
									   			(#Arguments.NumeroLineaReferencia# * 10000) - #Arguments.LineaDistribucion#
									   	end,
									   (select CFcuenta from CFinanciera
   							 			where CFformato = '#Arguments.rsDistribucionCuenta#'),
										(select CPcuenta from CFinanciera
   							 			where CFformato = '#Arguments.rsDistribucionCuenta#'),
										(select Ccuenta from CFinanciera
   							 			where CFformato = '#Arguments.rsDistribucionCuenta#'),
									   cxp.CPDCid,
									   #Arguments.CFid#,
									   #Arguments.LineaDistribucion#

								from DDocumentosCxP cxp
								where cxp.Linea = #Arguments.Linea#

				</cfquery>
			</cffunction>


		<!--- Inserta en la tabla "DistribucionOrdenCM" la linea NAP a referenciar --->
			<cffunction name="insertaDistribucionOC" access="public" output="no">
				<cfargument name="DOlinea"					type="numeric">
				<cfargument name="NumeroLineaReferencia"	type="numeric">
				<cfargument name="TipoMovimiento"			type="string">
				<cfargument name="LineaDistribucion"		type="numeric">
				<cfargument name="CFid"						type="numeric">
				<cfargument name="rsDistribucionCuenta">


				<cfquery name="insertaTablaDistribucion" datasource="#session.DSN#">
					insert into DistribucionOC(Ecodigo,
													TipoMovimiento,
													EOidorden,
													DOconsecutivo,
													CPNAPDlinea,
													CFcuenta,
													CPcuenta,
													CPDCid,
													CFid,
													LineaDistribucion)

								select d.Ecodigo,
									   '#Arguments.TipoMovimiento#',
									   d.EOidorden,
									   d.DOconsecutivo,
									   case
									   		when #Arguments.NumeroLineaReferencia# > 0 then
									   			(#Arguments.NumeroLineaReferencia# * 10000) + #Arguments.LineaDistribucion#
									   		else
									   			(#Arguments.NumeroLineaReferencia# * 10000) - #Arguments.LineaDistribucion#
									   	end,
									   (select CFcuenta from CFinanciera
   							 			where CFformato = '#Arguments.rsDistribucionCuenta#'),
										(select CPcuenta from CFinanciera
   							 			where CFformato = '#Arguments.rsDistribucionCuenta#'),
									   d.CPDCid,
									   #Arguments.CFid#,
									   #Arguments.LineaDistribucion#

								from DOrdenCM d
								where d.DOlinea = #Arguments.DOlinea#

				</cfquery>
			</cffunction>


		<!--- Inserta en la tabla "DistribucionSC" la linea NAP a referenciar --->
			<cffunction name="insertaDistribucionSC" access="public" output="no">
				<cfargument name="DSlinea"					type="numeric">
				<cfargument name="NumeroLineaReferencia"	type="numeric">
				<cfargument name="TipoMovimiento"			type="string">
				<cfargument name="LineaDistribucion"		type="numeric">
				<cfargument name="CFid"						type="numeric">
				<cfargument name="rsDistribucionCuenta">


				<cfquery name="insertaTablaDistribucion" datasource="#session.DSN#">
					insert into DistribucionSC(		Ecodigo,
													TipoMovimiento,
													ESidsolicitud,
													DSconsecutivo,
													CPNAPDlinea,
													CFcuenta,
													CPDCid,
													CFid,
													LineaDistribucion)

								select dsc.Ecodigo,
									   '#Arguments.TipoMovimiento#',
									   dsc.ESidsolicitud,
									   dsc.DSconsecutivo,
									   (#Arguments.NumeroLineaReferencia# * 10000) + #Arguments.LineaDistribucion#,
									   (select CFcuenta from CFinanciera
   							 			where CFformato = '#Arguments.rsDistribucionCuenta#'),
									   dsc.CPDCid,
									   #Arguments.CFid#,
									   #Arguments.LineaDistribucion#

								from DSolicitudCompraCM dsc
								where dsc.DSlinea = #Arguments.DSlinea#

				</cfquery>
			</cffunction>


</cfcomponent>
