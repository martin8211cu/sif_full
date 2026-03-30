<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 04 de julio del 2005
	Motivo:	Se agregó el nuevo campo TESCFLtipo, esta campo indica el tipo de lote (I = Impresion, R = Reimpresion)
			Se modificó de manera q pudiera utilizarse para la Reimpresión de cheques.La variable para saber en cual 
			opción se encuetra es Reimpresion
----------->
<cfif IsDefined("url.sbVer")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESOPobservaciones, TESOPinstruccion, TESEdescripcion
		  from TESordenPago op
		  	inner join TESendoso e
				 on e.TESid = op.TESid
				and e.TESEcodigo = op.TESEcodigo
		 where op.TESid = #session.Tesoreria.TESid#
		   and op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OP#">
	</cfquery>
	<cfoutput>
	<script language="javascript">
		<cfif url.tipo EQ "O">
			alert("Instrucciones internas de Entrega:\n\n#JSStringFormat(rsSQL.TESOPobservaciones)#");
		<cfelseif url.tipo EQ "I">
			alert("Instrucciones para el Banco:\n\n#JSStringFormat(rsSQL.TESOPinstruccion)#");
		<cfelseif url.tipo EQ "E">
			alert("Código de Endoso:\n\n#JSStringFormat(rsSQL.TESEdescripcion)#");
		</cfif>
		var LvarIframe = parent.document.getElementById("ifrDescripcion");
		LvarIframe.src = "";
	</script>
	</cfoutput>
	<cfabort>
<cfelseif IsDefined("form.btnCrear")>
	<cftransaction>
		<cfset LvarReimpresionEspecial = (isdefined('Reimpresion') AND isdefined("url.Reimpresion2") AND isdefined("session.Reimpresion2") AND url.Reimpresion2 EQ session.Reimpresion2)>
		<cfquery name="insert" datasource="#session.dsn#">
			insert into TEScontrolFormulariosL (
				TESid,
				CBid,
				TESMPcodigo,
				TESCFLestado,
				TESCFLfecha,
				TESCFLtipo,
			<cfif LvarReimpresionEspecial>
				TESCFLespecial,
			</cfif>
				Usucodigo,
				BMUsucodigo)
			values (
				#session.Tesoreria.TESid#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">,
				0,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfif isdefined('Reimpresion')>'R'<cfelse>'I'</cfif>,
			<cfif LvarReimpresionEspecial>
				1,
			</cfif>
				#session.usucodigo#,
				#session.usucodigo#
				)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESCFLid">
		<cfif isdefined('Reimpresion')>
			<cfif isdefined('form.TESCFDnumFormulario') and not isdefined('form.btnNuevo')>
				<cfquery datasource="#session.DSN#">
					update TEScontrolFormulariosD
					   set TESCFLidReimpresion = #LvarTESCFLid#
					 where TESCFLidReimpresion IS null
					   and TESid				= #session.Tesoreria.TESid#
					   and CBid  				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
					   and TESMPcodigo 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
					   and TESCFDnumFormulario 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">
					   and TESCFDestado 		= 1
				</cfquery>
			</cfif>
		<cfelse>
			<cfif form.chkTipo NEQ 3>
				<cfquery datasource="#session.dsn#">
					update TESordenPago
					   set 	TESCFLid 	= #LvarTESCFLid#,
							TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">,
							TESOPestado = 11
					 where TESid		= #session.Tesoreria.TESid#
					   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
					   and TESCFLid		IS null
					   and TESTLid		IS null
					   and TESOPestado = 11
					   and (
							TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
					<cfif form.chkTipo EQ 2>
							OR	TESMPcodigo	is null
					</cfif>
						   )
					<cfif form.fechaDesde NEQ "">
					   and TESOPfechaPago >= <cf_dbfunction name="to_date" args="'#form.fechaDesde#'">
					</cfif>
					<cfif form.fechaHasta NEQ "">
					   and TESOPfechaPago <= <cf_dbfunction name="to_date" args="'#form.fechaHasta#'">
					</cfif>
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
	<cfif isdefined('Reimpresion')>
		<cflocation url="reimpresionCheques.cfm?TESCFLid=#URLEncodedFormat(LvarTESCFLid)#&CBid=#URLEncodedFormat(form.CBid)#">
	<cfelse>
		<cflocation url="impresionCheques.cfm?TESCFLid=#URLEncodedFormat(LvarTESCFLid)#&CBid=#URLEncodedFormat(form.CBid)#">
	</cfif>
<cfelseif IsDefined("form.btnSeleccionarOP")>
	<cfif isdefined("form.chk")>
		<cfquery name="rsTESCFL" datasource="#session.dsn#">
			select CBid, TESMPcodigo
			  from TEScontrolFormulariosL
			 where TESid	= #session.Tesoreria.TESid#
			   and TESCFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>	
		<cfif isdefined('Reimpresion')>
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosD
				   set TESCFLidReimpresion = #form.TESCFLid#
				where TESid			= #session.Tesoreria.TESid#
				  and CBid  		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				  and TESMPcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				  and TESCFDestado 	= 1
				  and TESCFDnumFormulario in (#form.chk#)
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update TESordenPago
				   set 	TESCFLid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">,
						TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">,
						TESOPestado = 11
				 where TESid		= #session.Tesoreria.TESid#
				   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESCFLid		IS null
				   and TESOPestado = 11
				   and TESOPid in (#form.chk#)
		  	</cfquery>
		</cfif>
	</cfif>
	<cfif isdefined('Reimpresion')>
		<cflocation url="reimpresionCheques.cfm?TESCFLid=#form.TESCFLid#">
	<cfelse>
		<cflocation url="impresionCheques.cfm?TESCFLid=#form.TESCFLid#">
	</cfif>
<cfelseif IsDefined("form.btnEliminar")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosL
			   set TESCFLestado = TESCFLestado
			 where TESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select TESCFLestado
			  from TEScontrolFormulariosL
			 where TESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfif rsSQL.TESCFLestado NEQ "0">
			<cf_errorCode	code = "50765" msg = "El lote está en proceso de impresión, no se puede eliminar">
		</cfif>
		<cfif isdefined('Reimpresion')>
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosD
				   set TESCFLidReimpresion = null
				 where TESCFLidReimpresion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESid	= #session.Tesoreria.TESid#
				   and TESCFDestado = 1
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update TESordenPago
				   set 	TESCFLid 	= null,
						TESOPestado = 11
				 where TESid		= #session.Tesoreria.TESid#
				   and TESCFLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESOPestado = 11
			</cfquery>
		</cfif>

		<!--- Se separan del lote los documentos anulados (para que permanezcan) --->
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosD
			   set TESCFLid	= NULL
			 where TESid			= #session.Tesoreria.TESid#
			   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
			   and TESCFDestado		= 3
		</cfquery>

		<!--- Se borran los documentos no impresos del lote --->
		<cfquery datasource="#session.dsn#">
			delete from TEScontrolFormulariosD
			 where TESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
			   and TESCFDestado	= 0
		</cfquery>

		<cfquery datasource="#session.dsn#">
			delete from TEScontrolFormulariosL
			 where TESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
	</cftransaction>
	<cfif isdefined('Reimpresion')>
		<cflocation url="reimpresionCheques.cfm">
	<cfelse>
		<cflocation url="impresionCheques.cfm">
	</cfif>
<cfelseif IsDefined("url.btnExcluirOP")>
	<cfif isdefined('Reimpresion')>
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosD
			   set TESCFLidReimpresion = null
			 where TESCFLidReimpresion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESCFLid#">
			   and TESid				= #session.Tesoreria.TESid#
			   and TESCFDnumFormulario	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESCFDnumFormulario#">
			   and TESCFDestado 		= 1
		</cfquery>
		<cflocation url="reimpresionCheques.cfm?TESCFLid=#url.TESCFLid#">	
	<cfelse>
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set 	TESCFLid 	= null,
					TESOPestado = 11
			 where TESid		= #session.Tesoreria.TESid#
			   and TESOPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESOPid#">
			   and TESCFLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESCFLid#">
			   and TESOPestado = 11
		</cfquery>
		<cflocation url="impresionCheques.cfm?TESCFLid=#url.TESCFLid#">
	</cfif>
<cfelseif IsDefined("form.btnActualizarFecha")>
	<cftransaction>
		<cf_navegacion name="TESOPfechaPago_A" default="#dateformat(now(),"DD/MM/YYYY")#" session>
		<cfset LvarHoy = createdate(datepart('yyyy',now()),datepart('m',now()),datepart('d',now()))>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			update TESordenPago
			   set TESOPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.TESOPfechaPago_A)#">
			 where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			<cfif isdefined('Reimpresion')>
			   and TESOPid in
			   	(
					select TESOPid
					  from TEScontrolFormulariosD
					 where TESCFLidReimpresion= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESCFLid#">
					   AND TESid			  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
				)
			<cfelse>
			   and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">	
			   and TESMPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TESMPcodigo#">	
			   and TESCFLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESCFLid#">	
			</cfif>
		</cfquery>
	</cftransaction>
	<cfif isdefined('Reimpresion')>
		<cflocation url="reimpresionCheques.cfm?TESCFLid=#form.TESCFLid#">
	<cfelse>
		<cflocation url="impresionCheques.cfm?TESCFLid=#form.TESCFLid#">
	</cfif>
<cfelseif IsDefined("form.btnInicioImpresion")>
	<!--- PASAR DE ESTADO 0 a 1 --->
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosL
			   set TESCFLestado = TESCFLestado
			 where TESid	= #session.Tesoreria.TESid#
			   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfquery name="rsTESCFL" datasource="#session.dsn#">
			select TESCFLestado
			  from TEScontrolFormulariosL
			 where TESid	= #session.Tesoreria.TESid#
			   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfif rsTESCFL.TESCFLestado NEQ "0">
			<cf_errorCode	code = "50766" msg = "Se esta tratando de Iniciar al Impresión de un Lote que no está en Estado 0=Preparacion">
		</cfif>

		<!--- Verifica Bloque de Formularios --->
		<cfquery name="rsTESCFT" datasource="#session.dsn#">
			select TESCFTnumInicial, TESCFTnumFinal, TESCFTultimo,
					TESCFTimprimiendo,
					case TESCFTultimo
						when 0 then TESCFTnumInicial
						else TESCFTultimo+1
					end as TESCFTsiguiente
			  from TEScontrolFormulariosT
			 where TESid			= #session.Tesoreria.TESid#
			   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#listFirst(form.TESCFT)#">
		</cfquery>
		<cfif isdefined('Reimpresion')>
			<cfquery datasource="#session.dsn#" name="rsTESOPs">
				select TESOPid
				  from TEScontrolFormulariosD
				 where TESCFLidReimpresion= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESCFLid#">
				   AND TESid			  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="rsTESOPs">
				select TESOPid, TESOPfechaPago
				  from TESordenPago
				 where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
				   and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">	
				   and TESMPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TESMPcodigo#">	
				   and TESCFLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESCFLid#">	
			</cfquery>
		</cfif>
		<cfif rsTESCFT.TESCFTimprimiendo EQ "1">
			<cf_errorCode	code = "50767" msg = "El Bloque de Formularios escogido está siendo utilizado por otro Lote de Impresión">
		<cfelseif rsTESCFT.TESCFTultimo GTE rsTESCFT.TESCFTnumFinal>
			<cf_errorCode	code = "50768" msg = "El Bloque de Formularios escogido ya está cerrado">
		</cfif>
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosT
			   set TESCFTimprimiendo = 1
			 where TESid			= #session.Tesoreria.TESid#
			   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#listFirst(form.TESCFT)#">
		</cfquery>

		<!--- Actualiza Consecutivos de Impresion del Lote--->
		<cfset LvarSiguiente 	= rsTESCFT.TESCFTsiguiente>
		<cfset LvarPrimero 		= form.TESCFLimpresoIni>
		<cfset LvarUltimo		= LvarPrimero + rsTESOPs.RecordCount - 1>
		<cfif LvarUltimo GT #rsTESCFT.TESCFTnumFinal#>
			<cfset LvarUltimo	= rsTESCFT.TESCFTnumFinal>
		</cfif>
		<cfif LvarPrimero LT LvarSiguiente>
			<cf_errorCode	code = "50769" msg = "El Número del Primer Formulario a Imprimir no puede ser menor al siguiente formulario libre en el Bloque de Formularios">
		<cfelseif LvarPrimero GT #rsTESCFT.TESCFTnumFinal#>
			<cf_errorCode	code = "50770" msg = "El Número del Primer Formulario a Imprimir no puede ser mayor al último formulario del Bloque de Formularios">
		<cfelseif LvarPrimero GT LvarSiguiente>
			<cfset LvarCancelarIni = rsTESCFT.TESCFTsiguiente>
			<cfset LvarCancelarFin = LvarPrimero - 1>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosL
			   set TESCFLestado = 1
			     , TESCFTnumInicial = #listFirst(form.TESCFT)#
			     , TESCFLultimoAnterior = #rsTESCFT.TESCFTultimo#
			<cfif LvarPrimero GT LvarSiguiente>
				 , TESCFLcancelarAIni	= #LvarCancelarIni#
				 , TESCFLcancelarAFin	= #LvarCancelarFin#
			</cfif>
				 , TESCFLimpresoIni		= #LvarPrimero#
				 , TESCFLimpresoFin		= #LvarUltimo#
			 where TESid			= #session.Tesoreria.TESid#
			   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>

		<!--- ANULACION ANTES DE IMPRESION DE LOTE --->
		<cfif LvarPrimero GT LvarSiguiente>
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosT
				   set TESCFTultimo 	= #LvarCancelarFin#
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
				   and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#listFirst(form.TESCFT)#">
			</cfquery>
			<cfloop index="LvarNum" from="#LvarCancelarIni#" to="#LvarCancelarFin#">
				<cfquery datasource="#session.dsn#">
					insert into TEScontrolFormulariosD
						(
							 TESid
							,CBid
							,TESMPcodigo
							,TESCFDnumFormulario
							,TESOPid
							,TESCFLid
							,TESCFDestado
							,UsucodigoEmision
							,TESCFDfechaEmision
							,UsucodigoAnulacion
							,TESCFDfechaAnulacion
							,TESCFDmsgAnulacion
							,BMUsucodigo
						)
						values (
							 #session.Tesoreria.TESid#
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
							,#LvarNum#
							,null
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
							,3	/* Anulado */
							,#session.Usucodigo#
							,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
							,#session.Usucodigo#
							,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="ANTES DE IMPRESION DE LOTE: #form.TESCFDmsgAnulacion#">
							,#session.Usucodigo#
						)
				</cfquery>
			</cfloop>
		</cfif>

		<!--- GENERA FORMULARIOS DEL LOTE --->
		<cfset LvarNum = LvarPrimero>
		<cfloop query="rsTESOPs">
			<cfif LvarNum GT LvarUltimo>
				<cfbreak>
			</cfif>
			
			<cfquery datasource="#session.dsn#">
				insert into TEScontrolFormulariosD
					(
						 TESid
						,CBid
						,TESMPcodigo
						,TESCFDnumFormulario
						,TESOPid
						,TESCFLid
						,TESCFDestado
						,UsucodigoEmision
						,TESCFDfechaEmision
						,BMUsucodigo
					)
					values (
						 #session.Tesoreria.TESid#
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
						,#LvarNum#
						,#rsTESOPs.TESOPid#
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
						,0	/* En Emision */
						,#session.Usucodigo#
						,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
						,#session.Usucodigo#
					)
			</cfquery>
			<cfset LvarNum = LvarNum + 1>
		</cfloop>
	</cftransaction>
	<cfif isdefined('Reimpresion')>
		<cflocation url="reimpresionCheques.cfm?TESCFLid=#form.TESCFLid#">
	<cfelse>
		<cflocation url="impresionCheques.cfm?TESCFLid=#form.TESCFLid#">
	</cfif>
<cfelseif IsDefined("form.btnImprimir")>
	<!--- PASAR DE ESTADO 1 a 0,2 --->
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosL
			   set TESCFLestado = TESCFLestado
			 where TESid			= #session.Tesoreria.TESid#
			   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfquery name="rsTESCFL" datasource="#session.dsn#">
			select 	  CBid
					, TESMPcodigo
					, TESCFTnumInicial
					, TESCFLestado
					, TESCFLultimoAnterior 
					, TESCFLcancelarAIni	
					, TESCFLcancelarAFin	
					, TESCFLimpresoIni		
					, TESCFLimpresoFin		
			  from TEScontrolFormulariosL
			 where TESid			= #session.Tesoreria.TESid#
			   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfif rsTESCFL.TESCFLestado NEQ "1">
			<cf_errorCode	code = "50771" msg = "Se esta tratando de Terminar la Impresión de un Lote que no está en Estado 1=Impresion">
		</cfif>

		<cfif form.btnImprimir EQ "NOINICIO">
			<!--- PASAR DE ESTADO 1 a 0 --->

			<!--- Se borran los Formularios de Ordenes de pago generados --->
			<cfquery datasource="#session.dsn#">
				delete from TEScontrolFormulariosD
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESCFDestado		= 0
			</cfquery>

 			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosL
				   set TESCFLestado = 0
					 , TESCFTnumInicial 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLultimoAnterior = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLcancelarAIni	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLcancelarAFin	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLimpresoIni		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLimpresoFin		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosT
				   set TESCFTimprimiendo = 0
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.TESCFTnumInicial#">
			</cfquery>
		<cfelseif form.btnImprimir EQ "ERROR" OR form.btnImprimir EQ "OK">
			<!--- PASAR DE ESTADO 1 a 2 --->
			<cfif form.btnImprimir EQ "OK">
				<cfquery name="rsDocs" datasource="#session.dsn#">
					select count(1) as cantidad
					     , max(TESCFDnumFormulario) as ultimo
					  from TEScontrolFormulariosD
					 where TESid			= #session.Tesoreria.TESid#
					   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
					   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
					   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
					   and TESCFDestado		= 0
				</cfquery>
				<cfif form.TotalPags NEQ rsDocs.cantidad>
					<cf_errorCode	code = "50772"
									msg  = "La cantidad de Formularios impresos (@errorDat_1@) es diferente a la esperada (@errorDat_2@)"
									errorDat_1="#form.TotalPags#"
									errorDat_2="#rsDocs.cantidad#"
					>
				<cfelseif form.UltimoDoc NEQ rsDocs.ultimo>
					<cf_errorCode	code = "50773"
									msg  = "El número del Ultimo Documento impreso (@errorDat_1@) no es el esperado (@errorDat_2@)"
									errorDat_1="#form.UltimoDoc#"
									errorDat_2="#rsDocs.ultimo#"
					>
				</cfif>
			</cfif>
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosL
				   set TESCFLestado = 2
				<cfif form.UltimoDoc GT 0>
				     , TESCFLimpresoFin = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.UltimoDoc#">
				</cfif>
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50774" msg = "Se ejecutó la Impresión con un Codigo de Retorno incorrecto">
		</cfif>
	</cftransaction>
	<cfif isdefined('Reimpresion')>
		<cflocation url="reimpresionCheques.cfm?TESCFLid=#form.TESCFLid#">
	<cfelse>
		<cflocation url="impresionCheques.cfm?TESCFLid=#form.TESCFLid#">
	</cfif>
	
<cfelseif IsDefined("form.btnResultado")>
	<!--- PASAR DE ESTADO 2 a 0,3--->

	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosL
			   set TESCFLestado = TESCFLestado
			 where TESid			= #session.Tesoreria.TESid#
			   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfquery name="rsTESCFL" datasource="#session.dsn#">
			select 	  tl.CBid
					, tl.TESMPcodigo
					, tl.TESCFTnumInicial
					, tl.TESCFLestado
					, tl.TESCFLultimoAnterior 
					, tl.TESCFLcancelarAIni	
					, tl.TESCFLcancelarAFin	
					, tl.TESCFLimpresoIni		
					, tl.TESCFLimpresoFin
					, tl.TESCFLespecial	
                    , mp.TESenviaCorreo 	
			  from TEScontrolFormulariosL tl
              inner join TESmedioPago mp
				on mp.TESid		= tl.TESid
				and mp.CBid			= tl.CBid
				and mp.TESMPcodigo 	= tl.TESMPcodigo 
			 where tl.TESid			= #session.Tesoreria.TESid#
			   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfif rsTESCFL.TESCFLestado NEQ "2">
			<cf_errorCode	code = "50775" msg = "Se esta tratando de Completar la Emisión de un Lote de Impresión de Cheques que no está en Estado 2=Después de Impresion">
		</cfif>
	
		<cfset LvarReimpresionEspecial = (rsTESCFL.TESCFLespecial EQ "1")>

		<cfset LvarUltimo		= form.UltimoDoc>
		<cfset LvarCancelarIni 	= form.CancelarDesde>
		<cfset LvarCancelarFin 	= form.CancelarHasta>
		<cfset LvarCancelarMsg 	= form.TESCFDmsgAnulacion>

		<cfif LvarUltimo GT 0>
			<cfif LvarUltimo LT rsTESCFL.TESCFLimpresoIni OR LvarUltimo GT rsTESCFL.TESCFLimpresoFin>
				<cf_errorCode	code = "50776"
								msg  = "El Número del Último Formulario bien impreso debe estar entre @errorDat_1@ y @errorDat_2@"
								errorDat_1="#rsTESCFL.TESCFLimpresoIni#"
								errorDat_2="#rsTESCFL.TESCFLimpresoFin#"
				>
			</cfif>
			<cfset LvarPrimeroAnular = LvarUltimo+1>
		<cfelse>
			<cfset LvarPrimeroAnular = rsTESCFL.TESCFLimpresoIni>
		</cfif>

		<!--- ANULACION DESPUES DE IMPRESION DE LOTE --->
		<cfif LvarCancelarIni NEQ 0>
			<cfif LvarCancelarIni NEQ LvarPrimeroAnular>
				<cf_errorCode	code = "50777"
								msg  = "El Número del Primer Formulario a Anular debe ser @errorDat_1@"
								errorDat_1="#LvarPrimeroAnular#"
				>
			</cfif>
			<cfif LvarCancelarIni GT LvarCancelarFin>
				<cf_errorCode	code = "50778" msg = "El Número del Primer Formulario a Anular debe menor o igual que el Ultimo a Anular">
			</cfif>
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosD
				   set TESCFDestado 		= 3
					 , UsucodigoAnulacion	= #session.Usucodigo#
					 , TESCFDfechaAnulacion	= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
					 , TESCFDmsgAnulacion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="DESPUES DE IMPRESION DE LOTE: #form.TESCFDmsgAnulacion#">
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESCFDnumFormulario	>= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCancelarIni#">
				   and TESCFDnumFormulario	<= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCancelarFin#">
			</cfquery>

			<!--- AGREGA NUEVOS DOCUMENTOS A CANCELAR DESPUES --->
			<cfquery name="rsDocs" datasource="#session.dsn#">
				select max(TESCFDnumFormulario) as ultimo
				  from TEScontrolFormulariosD
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
			</cfquery>
			<cfif LvarCancelarFin GT rsDocs.ultimo>
				<cfloop index="LvarNum" from="#rsDocs.ultimo+1#" to="#LvarCancelarFin#">
					<cfquery datasource="#session.dsn#">
						insert into TEScontrolFormulariosD
							(
								 TESid
								,CBid
								,TESMPcodigo
								,TESCFDnumFormulario
								,TESOPid
								,TESCFLid
								,TESCFDestado
								,UsucodigoEmision
								,TESCFDfechaEmision
								,UsucodigoAnulacion
								,TESCFDfechaAnulacion
								,TESCFDmsgAnulacion
								,BMUsucodigo
							)
							values (
								 #session.Tesoreria.TESid#
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
								,#LvarNum#
								,null
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
								,3	/* Anulado */
								,#session.Usucodigo#
								,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
								,#session.Usucodigo#
								,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="DESPUES DE IMPRESION DE LOTE: #form.TESCFDmsgAnulacion#">
								,#session.Usucodigo#
							)
					</cfquery>
				</cfloop>
			</cfif>

			<!--- INSERTA EN BITACORA LOS ANULADOS DESPUES --->
			<cfquery datasource="#session.dsn#">
				insert into TEScontrolFormulariosB
					(
						TESid, CBid, TESMPcodigo,TESCFDnumFormulario, 
						TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, 
						UsucodigoCustodio, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
					)
				select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
						,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
						,(select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEanulado = 1)
						,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						,1
						,#session.Usucodigo#
						,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
						,#session.Usucodigo#
						,#session.Usucodigo#
				  from TEScontrolFormulariosD
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESCFDnumFormulario	>= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCancelarIni#">
				   and TESCFDestado 	= 3
			</cfquery>
		</cfif>

		<cfif form.UltimoDoc EQ 0>
			<!--- PASAR DE ESTADO 2 a 0: Si no se imprimió ninguna Orden de Pago, el Lote se devuelve a Preparación --->
			
			<cfset LvarTESCFLid = form.TESCFLid>

			<!--- Se borran los Formularios de Ordenes de pago generados --->
			<cfquery datasource="#session.dsn#">
				delete from TEScontrolFormulariosD
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESCFDestado		= 0
			</cfquery>

			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosL
				   set TESCFLestado = 0
					 , TESCFTnumInicial 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLultimoAnterior = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLcancelarAIni	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLcancelarAFin	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLimpresoIni		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					 , TESCFLimpresoFin		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
			</cfquery>

			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosT
				   set TESCFTimprimiendo = 0
				<cfif LvarCancelarFin NEQ 0>
				     , TESCFTultimo 	= #LvarCancelarFin#
				</cfif>
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.TESCFTnumInicial#">
			</cfquery>
		<cfelse>
			<!--- PASAR DE ESTADO 2 a 3: Se completa la impresión del Lote y se realiza la aplicación de documentos --->
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosD
				   set TESCFDestado 		= 1	/* Cheque Impreso */
					 , UsucodigoEmision		= #session.Usucodigo#
					 , TESCFDfechaEmision	= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESCFDestado		= 0
				   and TESCFDnumFormulario <= #LvarUltimo#
			</cfquery>

			<cfquery datasource="#session.dsn#">
				insert into TEScontrolFormulariosB
					(
						TESid, CBid, TESMPcodigo,TESCFDnumFormulario, 
						TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, UsucodigoCustodio, 
						TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
					)
				select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
						,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
						,(select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEimpreso = 1)
						,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						,1
						,#session.Usucodigo#
						,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
						,#session.Usucodigo#
						,#session.Usucodigo#
				  from TEScontrolFormulariosD
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESCFDestado 	= 1
				   and TESCFDnumFormulario <= #LvarUltimo#
			</cfquery>

			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosL
				   set TESCFLestado 		= 3	/* Lote Emitido */
					 , TESCFLimpresoFin		= #LvarUltimo#
				<cfif LvarCancelarIni NEQ 0>
					 , TESCFLcancelarDIni	= #LvarCancelarIni#
					 , TESCFLcancelarDFin	= #LvarCancelarFin#
				</cfif>
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
			</cfquery>

			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosT
				   set TESCFTimprimiendo = 0	/* Talonario Desocupado */
				<cfif LvarCancelarFin NEQ 0>
				     , TESCFTultimo 	= #LvarCancelarFin#
				<cfelse>
				     , TESCFTultimo 	= #LvarUltimo#
				</cfif>
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
				   and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.TESCFTnumInicial#">
			</cfquery>

			<cfif isdefined('Reimpresion')>
				<!--- Se anulan los formularios que efectivamente se reimprimieron --->
                <cfinclude template="../../../Utiles/sifConcat.cfm">
				<cfquery datasource="#session.DSN#">
					update TEScontrolFormulariosD
					   set TESCFDestado 		= 3
						 , UsucodigoAnulacion	= #session.Usucodigo#
						 , TESCFDfechaAnulacion	= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
						 , TESCFDmsgAnulacion	= 'CHEQUE REIMPRESO CON CK. '  #_Cat#
													(
														select <cf_dbfunction name="to_char" args="n.TESCFDnumFormulario">
														  from TEScontrolFormulariosD n
														 where n.TESid			= TEScontrolFormulariosD.TESid
														   and n.CBid			= TEScontrolFormulariosD.CBid
														   and n.TESMPcodigo	= TEScontrolFormulariosD.TESMPcodigo
														   and n.TESCFLid		= TEScontrolFormulariosD.TESCFLidReimpresion
														   and n.TESOPid		= TEScontrolFormulariosD.TESOPid
														   and n.TESCFDestado	= 1  /* Unicamente los que se imprimieron */
													)
					 where TESCFLidReimpresion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
					   and TESid				= #session.Tesoreria.TESid#
					   and TESCFDestado			= 1
					   and exists 
							(
								select 1
								  from TEScontrolFormulariosD n
								 where n.TESid			= TEScontrolFormulariosD.TESid
								   and n.CBid			= TEScontrolFormulariosD.CBid
								   and n.TESMPcodigo	= TEScontrolFormulariosD.TESMPcodigo
								   and n.TESCFLid		= TEScontrolFormulariosD.TESCFLidReimpresion
								   and n.TESOPid		= TEScontrolFormulariosD.TESOPid
								   and n.TESCFDestado	= 1  /* Unicamente los que se imprimieron */
							)
				</cfquery>
				
				<!--- ACTUALIZA LOS REGISTROS DEL FORMULARIO EN LA BITACORA DE FORMULARIOS --->
				<cfquery datasource="#session.DSN#">
					update TEScontrolFormulariosB
					   set TESCFBultimo = 0
					where TESid				   = #session.Tesoreria.TESid#
					   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
					   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
					   and exists 
						   		(
									select 1
									  from TEScontrolFormulariosD cfd
									 where cfd.TESid			= #session.Tesoreria.TESid#
									   and cfd.CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">	
									   and cfd.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">	
									   and cfd.TESCFLidReimpresion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
									   and cfd.TESCFDnumFormulario = TEScontrolFormulariosB.TESCFDnumFormulario
									   and cfd.TESCFDestado	= 3
								)
				</cfquery>
				
				<cfquery datasource="#session.dsn#">
					insert into TEScontrolFormulariosB
						(
							TESid, CBid, TESMPcodigo,TESCFDnumFormulario, 
							TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, UsucodigoCustodio, 
							TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
						)
					select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
							,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
							,(select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEanulado = 1)
							,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
							,1
							,#session.Usucodigo#
							,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
							,#session.Usucodigo#
							,#session.Usucodigo#
					  from TEScontrolFormulariosD
					 where TESCFLidReimpresion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
					   and TESid				= #session.Tesoreria.TESid#
					   and TESCFDestado			= 3
				</cfquery>
				
				<!--- ACTUALIZA EL NUMERO DE CHEQUE DE LA O.P. --->
				<cfquery name="rsTESCFD" datasource="#session.dsn#">
					select TESOPid, TESCFDnumFormulario
					  from TEScontrolFormulariosD
					 where TESid			= #session.Tesoreria.TESid#
					   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
					   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
					   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
					   and TESCFDestado		= 1
				</cfquery>

				<cfloop query="rsTESCFD">
					<cfquery datasource="#session.dsn#">
						update TESordenPago
						   set TESOPestado			= TESOPestado
							 , TESMPcodigo		 	= '#rsTESCFL.TESMPcodigo#'
							 , TESCFLid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
							 , TESCFDnumFormulario 	= #rsTESCFD.TESCFDnumFormulario#
						<cfif LvarReimpresionEspecial>
							 , TESOPfechaPago		= <cf_dbfunction name="today">
						</cfif>
							 , TESOPfechaEmision	= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
							 , UsucodigoEmision		= #session.Usucodigo#
						 where TESid 		= #session.Tesoreria.TESid#
						   and TESOPid 		= #rsTESCFD.TESOPid#
						   and TESOPestado 	in (12,110)
					</cfquery>	
				</cfloop>

				<!--- Determina si hay cheques no impresos --->
				<cfquery name="rsTESOP" datasource="#session.dsn#">
					select count(1) as cantidad
					  from TEScontrolFormulariosD ni
					 where ni.TESid			= #session.Tesoreria.TESid#
					   and ni.CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">	
					   and ni.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">	
					   and ni.TESCFLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
					   and ni.TESCFDestado  <> 1  /* No impresos */
				</cfquery>
			<cfelse>
				<!--- PASAR ESTADO DE OP, SP, DP a 12=OP aplicada --->
				<cfquery name="rsTESCFD" datasource="#session.dsn#">
					select TESOPid, TESCFDnumFormulario
					  from TEScontrolFormulariosD
					 where TESid			= #session.Tesoreria.TESid#
					   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
					   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
					   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
					   and TESCFDestado		= 1
				</cfquery>

				<cfloop query="rsTESCFD">
					<cfquery datasource="#session.dsn#">
						update TESsolicitudPago
						   set TESSPestado 	= 110	/* Orden de Pago Emitida */
						 where TESid 		= #session.Tesoreria.TESid#
						   and TESOPid 		= #rsTESCFD.TESOPid#
						   and TESSPestado 	= 11
					</cfquery>	
					<cfquery datasource="#session.dsn#">
						update TESdetallePago 
						   set TESDPestado	= 110
						 where TESid 		= #session.Tesoreria.TESid#
						   and TESOPid 		= #rsTESCFD.TESOPid#
						   and TESDPestado 	= 11
					</cfquery>
					<cfquery datasource="#session.dsn#">
						update TESordenPago
						   set TESOPestado			= 110
							 , TESMPcodigo		 	= '#rsTESCFL.TESMPcodigo#'
							 , TESCFDnumFormulario 	= #rsTESCFD.TESCFDnumFormulario#
							 , TESOPfechaEmision	= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
							 , UsucodigoEmision		= #session.Usucodigo#
						 where TESid 		= #session.Tesoreria.TESid#
						   and TESOPid 		= #rsTESCFD.TESOPid#
						   and TESOPestado 	= 11
					</cfquery>	
				</cfloop>

				<!--- Determina si hay OPs del Lote que no se les asignó cheque --->
				<cfquery name="rsTESOP" datasource="#session.dsn#">
					select count(1) as cantidad
					  from TESordenPago
					 where TESid		= #session.Tesoreria.TESid#
					   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">	
					   and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">	
					   and TESCFLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
					   and TESCFDnumFormulario IS NULL
				</cfquery>
			</cfif>

			<!--- SI EXISTEN OP no impresas se pasan a un nuevo lote --->

			<cfif rsTESOP.cantidad GT 0>
				<cfquery name="insert" datasource="#session.dsn#">
					insert into TEScontrolFormulariosL (
						TESid,
						CBid,
						TESMPcodigo,
						TESCFLtipo,
						TESCFLestado,
						TESCFLfecha,
					<cfif LvarReimpresionEspecial>
						TESCFLespecial,
					</cfif>
						Usucodigo,
						BMUsucodigo)
					values (
						#session.Tesoreria.TESid#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">,
						<cfif isdefined('Reimpresion')>'R'<cfelse>'I'</cfif>,
						0,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfif LvarReimpresionEspecial>
						1,
					</cfif>
						#session.usucodigo#,
						#session.usucodigo#
						)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESCFLid">

				<cfif isdefined('Reimpresion')>
					<cfquery datasource="#session.dsn#">
						update TEScontrolFormulariosD
						   set TESCFLidReimpresion  = #LvarTESCFLid#
						 where TESCFLidReimpresion 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
						   and TESid				= #session.Tesoreria.TESid#
						   and exists 
						   		(
									select 1
									  from TEScontrolFormulariosD ni
									 where ni.TESid			= #session.Tesoreria.TESid#
									   and ni.CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">	
									   and ni.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">	
									   and ni.TESCFLid		= TEScontrolFormulariosD.TESCFLidReimpresion
									   and ni.TESOPid		= TEScontrolFormulariosD.TESOPid
									   and ni.TESCFDestado  <> 1  /* No impresos */
								)
					</cfquery>
				<cfelse>
					<cfquery datasource="#session.dsn#">
						update TESordenPago
						   set TESCFLid 	= #LvarTESCFLid#
						 where TESid		= #session.Tesoreria.TESid#
						   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">	
						   and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">	
						   and TESCFLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
						   and TESCFDnumFormulario IS NULL
					</cfquery>
				</cfif>
				<cfquery datasource="#session.dsn#">
					delete from TEScontrolFormulariosD
					 where TESid			= #session.Tesoreria.TESid#
					   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
					   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
					   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
					   and TESCFDestado		= 0
				</cfquery>
			</cfif>
		</cfif>	
		<cfquery datasource="#session.dsn#" name="rsContabiliza">
			Select Pvalor from Parametros 
			  where Ecodigo = #Session.Ecodigo#
			  and Pcodigo = 5001
		</cfquery>  
        
		<cfset ContabilizarEntrega = rtrim(rsContabiliza.Pvalor) eq '1'>
    	<cfif isdefined('Reimpresion')>
			<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
						method="sbAplicarLoteChequesReimpresion">
				<cfinvokeargument name="TESCFLid" value="#form.TESCFLid#"/>
			</cfinvoke>
            
		<cfelseif NOT ContabilizarEntrega>
			<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
						method="sbAplicarLoteCheques">
				<cfinvokeargument name="TESCFLid" value="#form.TESCFLid#"/>
			</cfinvoke>
		</cfif>
        
        <cfquery name="ListaEmail" datasource="#session.dsn#">
			select op.TESOPid, 
					cfd.TESCFDnumFormulario as Cheque
				  , op.TESOPnumero
			  from TEScontrolFormulariosD cfd
				inner join TESordenPago op
				  on cfd.TESOPid 	   	= op.TESOPid
				 and cfd.CBid 	   		= op.CBidPago
				 and cfd.TESMPcodigo 	= op.TESMPcodigo
		<cfif isdefined('Reimpresion')>
				inner join TEScontrolFormulariosD viejo
					 on viejo.TESid					= cfd.TESid
					and viejo.CBid					= cfd.CBid
					and viejo.TESMPcodigo			= cfd.TESMPcodigo
					and viejo.TESCFLidReimpresion	= cfd.TESCFLid
					and viejo.TESOPid				= cfd.TESOPid
					and viejo.TESCFDestado   		= 1
		</cfif>
			where cfd.TESid			= #session.Tesoreria.TESid#
			  and cfd.CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESCFL.CBid#">
			  and cfd.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESCFL.TESMPcodigo#">
			  and cfd.TESCFLid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
        
        <!---Si se definio en Medios de Pago que envia correo--->
		<cfif rsTESCFL.TESenviaCorreo eq 1>
            
            <!---Mails--->
            <cfloop query="ListaEmail">
                <cfset LvarTESOPid=#ListaEmail.TESOPid#>
                <cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">

                <cfsavecontent variable="contenido">
                    <cfinclude template="correoEmision.cfm">
                </cfsavecontent>
                
                <cfquery name="rsEmail" datasource="#session.dsn#">
                    select coalesce (TESBemail, SNCemail ) as email, TESOPnumero
                    from  TESordenPago a
                        left join TESbeneficiario b
                            on b.TESBid = a.TESBid 
                        left join SNegocios sn
                            inner join SNContactos snc
                                on snc.SNcodigo= sn.SNcodigo
                                and SNCarea = 2 <!---que sean del area de tesoreria--->
                            on sn.SNid = a.SNid
                        where TESOPid =  #LvarTESOPid#   
                </cfquery>    
                
               <cfloop query="rsEmail"> 
                    <cfif len(trim(rsEmail.email))> 
                        <cfquery name="rsInserta" datasource="#Session.DSN#">
                            insert into SMTPQueue ( SMTPremitente, 	SMTPdestinatario, 	SMTPasunto, 
                                                    SMTPtexto, 		SMTPintentos, 		SMTPcreado, 
                                                    SMTPenviado, 	SMTPhtml, 			BMUsucodigo ) 
                            values ( <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#enviadoPor#">, <!---agarra el nombre y apellidos de session--->
                                    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsEmail.email#">, <!---#rsEmail.email#--->
                                    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="Emision impresion de cheque">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#contenido#">,
                                    0,	#now()#,	#now()#,	1,
                                    #Session.Usucodigo#
                                    ) 
                        </cfquery>
                    </cfif>    
                </cfloop>
            </cfloop>
        </cfif>
        
	</cftransaction>
	
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select	tc.TESCFLid, tc.CBid, tc.TESMPcodigo, mp.FMT01CODemail
		from TEScontrolFormulariosL tc
			inner join TESmedioPago mp
				 on mp.TESid		= tc.TESid
				and mp.CBid			= tc.CBid
				and mp.TESMPcodigo 	= tc.TESMPcodigo
		where tc.TESid	= #session.Tesoreria.TESid#	
		  and tc.TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
	</cfquery>

	<cfif NOT isdefined('Reimpresion') AND rsForm.FMT01CODemail NEQ "">
		<cfoutput>
		<cf_popup
			url="/cfmx/sif/Utiles/cfreportesCarta.cfm?toEmail=true&Ecodigo=#Session.Ecodigo#&FMT01COD=#rsform.FMT01CODemail#&Conexion=#Session.DSN#&TESid=#session.tesoreria.TESid#&CBid=#rsform.CBid#&TESTCFid=#rsform.TESTCFid#&TESMPcodigo=#rsform.TESMPcodigo#"
			link="Notificación de Pago"
			boton="false" width="800" height="600" left="0" top="0" resize="yes" ejecutar="true"
			scrollbars="yes"
		>
		<script language="javascript">
		<cfif isdefined("LvarTESCFLid")>
			location.href = "impresionCheques.cfm?TESCFLid=#LvarTESCFLid#";
		<cfelse>
			location.href = "impresionCheques.cfm";
		</cfif>
		</script>
		</cfoutput>
		<cfexit>
	</cfif>

	<cfif isdefined("LvarTESCFLid")>
		<cfif isdefined('Reimpresion')>
			<cflocation url="reimpresionCheques.cfm?TESCFLid=#LvarTESCFLid#">
		<cfelse>
			<cflocation url="impresionCheques.cfm?TESCFLid=#LvarTESCFLid#">
		</cfif>
	<cfelse>
		<cfif isdefined('Reimpresion')>
			<cflocation url="reimpresionCheques.cfm">
		<cfelse>
			<cflocation url="impresionCheques.cfm">
		</cfif>
	</cfif>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>
<cfif isdefined('Reimpresion')>
	<cflocation url="reimpresionCheques.cfm">
<cfelse>
	<cflocation url="impresionCheques.cfm">
</cfif>


