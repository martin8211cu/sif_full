<!---<cf_dump var="#form#">--->
<cfif IsDefined("form.CalcularViaticos")>
	<cflocation url="SolAntViatico_sql.cfm?GEAid=#form.GEAid#&calcular=true&CFid=#form.CFid#&GEAfechaPagar=#form.GEAfechaPagar#&LvarSAporEmpleadoCFM=#form.LvarSAporEmpleadoCFM#">
</cfif>

<cfif IsDefined("form.CalcularTC")>
	<cflocation url="SolAntViaticoTC_form.cfm?GEAid=#form.GEAid#&LvarSAporEmpleadoCFM=#form.LvarSAporEmpleadoCFM#">
</cfif>

<cfset LvarTipoDocumento = 6>
<cfset LvarSufijoForm = "Anticipo">

<cfparam name="form.GEAviatico" default="0">
<cfparam name="form.GEAtipoviatico" default="0">
<cfparam name="form.GECusaTCE" default="0">

<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<cfset LvarSAporEmpleadoCFM = "solicitudes#url.tipo#.cfm">

<!---Formulado por en parametros generales--->
<cfquery name="rsSQL" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarConPlanCompras=rsSQL.Pvalor EQ "1"> <!---1 equivale a plan de compras en parametros generales--->

<!---INICIALIZAR CENTRO FUNCIONAL--->
<cfif isdefined ('form.modo')>
	<cfif form.modo EQ 'ALTA' and IsDefined("form.Aprobar")>
		<cfset form.Alta=true>
	</cfif>
	
	<cfif	form.modo EQ 'CAMBIO' and IsDefined("form.Aprobar")>
		<cfset form.Cambio=true>
	</cfif>
</cfif>
<cf_cboCFid soloInicializar="true">

<cfif IsDefined("form.Alta") or IsDefined("form.AltaC") or isdefined("form.Cambio") or isdefined("form.CambioC")>
	<cfset LvarCxC_Anticipo = 0>
	<!---ID del parmetro de la cuanta financiera destinada a los gastos de Empleado si es cambiado, debera cambiarse tambien en la configuracion de ParametrosGE.cfm--->
	<cfif isdefined("form.Cambio") AND isdefined("form.GECid")>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select GECtipo
			  from GEcomision 
			 where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GECid#">
		</cfquery>
		<cfif rsSQL.GECtipo EQ form.GECtipo>
			<cfset LvarCxC_Anticipo = form.CxC_Anticipo>
		</cfif>
	</cfif>
<!---Quitar esto para actualizar solo cuando cambian de tipo---><cfset LvarCxC_Anticipo = 0>
	<cfif LvarCxC_Anticipo EQ 0 OR LvarCxC_Anticipo EQ "">
		<cfif isdefined("form.GECid")>
			<cfif form.GECtipo EQ 1>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1210
				</cfquery>
				<cfif rsSQL.Pvalor EQ "">
					<cfthrow type="toUser" message="Falta definir la Cuenta por Cobrar a Empleados para Comisiones Nacionales en la opción Parámetros de Gastos de Empleado">
				</cfif>
			<cfelse>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1211
				</cfquery>
				<cfif rsSQL.Pvalor EQ "">
					<cfthrow type="toUser" message="Falta definir la Cuenta por Cobrar a Empleados para Comisiones Extranjeras en la opción Parámetros de Gastos de Empleado">
				</cfif>
			</cfif>
		<cfelse>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1200
			</cfquery>
			<cfif rsSQL.Pvalor EQ "">
				<cf_errorCode	code = "50746" msg = "Falta definir la Cuenta por Cobrar para la gestión de Anticipos a Empleados en la opción Parámetros de Gastos de Empleado">
			</cfif>
		</cfif>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select CFcuenta
			  from CFinanciera 
			 where CFcuenta = #rsSQL.Pvalor#
		</cfquery>
		<cfset LvarCxC_Anticipo = rsSQL.CFcuenta>
	</cfif>
		
	<!---verificar si el empleado es un beneficiario--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
				method="Empleado_to_Beneficiario" 
				DEid = "#form.DEid#" 		
				returnvariable="LvarTESBid"
	>
</cfif>

<!---INSERTA ANTICIPO--->	
<cfif IsDefined("form.Alta") OR IsDefined("form.AltaC")>

	<cfif NOT isdefined("session.Tesoreria.TESid")>
			<cf_errorCode	code = "50741" msg = "No existe la Tesoreria para esta empresa actual o no se logro calcular el numero para la nueva solicitud de pago">
	</cfif>
	
	<cftransaction>
		<cfif isdefined("form.GECid") AND form.GECid EQ 0>
			<cfquery name="rsNewC" datasource="#session.dsn#">
				select coalesce(max(GECnumero),0) + 1 as new
				  from GEcomision
				 where Ecodigo=#session.Ecodigo#
			</cfquery>
			<cfquery datasource="#session.dsn#" name="insertar">
				insert GEcomision (
					TESid, 
					TESBid, 
					CFid, 
					Ecodigo, 
					GECnumero, 
					GECdescripcion, 

					GECfechaPagar,
					GECdesde, 
					GEChoraini, 
					GEChasta, 
					GEChorafin, 

					GECautomovil, 
					GEChotel, 
					GECavion, 
					GECobservaciones, 
					GECobservaciones2, 
					GECusaTCE,
					GECtipo,
					CBid_TCE,
					UsucodigoSolicitud
				) values (
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
					<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#LvarTESBid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
					#session.Ecodigo#,
					<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#rsNewC.new#">,
					<cf_jdbcquery_param 	cfsqltype="cf_sql_char" 	value="#form.GEAdescripcion#">,
					<cf_jdbcquery_param value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,

					<cf_jdbcquery_param value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhoraini#">,
					<cf_jdbcquery_param value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhorafin#">,
					
					<cfparam name="form.GECautomovil" default="0">
					<cfparam name="form.GEChotel" default="0">
					<cfparam name="form.GECavion" default="0">
					#form.GECautomovil#,#form.GEChotel#,#form.GECavion#,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservaciones#"  len="255" null="#trim(form.GECobservaciones) EQ ""#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservaciones2#" len="255" null="#trim(form.GECobservaciones2) EQ ""#">,
					<cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.GECusaTCE#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GECtipo#">,

					<cfparam name="form.CBid_TCE" default="">
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid_TCE#" null="#form.CBid_TCE EQ ""#">,
					#session.Usucodigo#
				)
				<cf_dbidentity1 datasource="#session.DSN#" name="insertar" returnvariable="LvarGECid">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertar" returnvariable="LvarGECid">
		<cfelseif isdefined("form.GECid") AND form.GECid NEQ "">
			<cfset LvarGECid = form.GECid>
		<cfelse>
			<cfset LvarGECid = "">
		</cfif>

		<cfif IsDefined("form.AltaC")>
			<cftransaction action="commit" />
			<cfparam name="form.GEAid" default="0">
			<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#&GECid=#LvarGECid#">	
		</cfif>
		<cfquery name="rsNew" datasource="#session.dsn#">
			select coalesce(max(GEAnumero),0) + 1 as new
			from GEanticipo
			where Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery datasource="#session.dsn#" name="insertar">
			insert into GEanticipo 
				(CFcuenta,
				TESid,
				CFid,
				CCHid,
				GEAtipoP,
				Ecodigo,
				GEAnumero,
				GEAtipo,
				GEAestado,
				Mcodigo,
				GEAdescripcion,
				GEAfechaSolicitud,
				UsucodigoSolicitud,
				TESBid,
				GEAhasta,
				GEAdesde,			
				GEAtotalOri,
				GEAfechaPagar,
				BMUsucodigo,
				GEAmanual,
				GEAviatico,
				GEAtipoviatico,
				GEAhoraini,
				GEAhorafin						
			<cfif LvarGECid NEQ "">
				,GECid
			</cfif>
			)values(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCxC_Anticipo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 
				0,
				#session.Ecodigo#,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#rsNew.new#">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#LvarTipoDocumento#">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="0">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#form.McodigoOri#">,
					<cfif isdefined('form.GEAdescripcion') and len(trim(form.GEAdescripcion))>
						<cf_jdbcquery_param 	cfsqltype="cf_sql_char" 	value="#form.GEAdescripcion#">,
					</cfif>	
				<cf_jdbcquery_param 	cfsqltype="cf_sql_timestamp"  value="#Now()#">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#LvarTESBid#">,
				<cf_jdbcquery_param value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
				<cf_jdbcquery_param value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,	
				0,
				<cf_jdbcquery_param value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">,
				<cfif isdefined('form.GEAmanual') and len(trim(form.GEAmanual)) AND form.GEAmanual NEQ 0>
					<cf_jdbcquery_param 	cfsqltype="cf_sql_money" 	value="#form.GEAmanual#">
				<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="1">
				</cfif>,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.GEAviatico#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.GEAtipoviatico#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhoraini#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhorafin#">			
			<cfif LvarGECid NEQ "">
				,#LvarGECid#
			</cfif>
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="insertar">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertar" returnvariable="LvarTESSAid">
		<cfset #form.GEAid#=#LvarTESSAid#>

		<cfif NOT LvarConPlanCompras> 
			<cfquery datasource="#session.dsn#" name="insertadetalle">
				insert into GEanticipoDet (
					GEAid,
					GECid,
					BMUsucodigo,
					GEADmonto,
					GEADmontoviatico,
					GEADtipocambio,
					McodigoPlantilla,
					Linea)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.MontoDetA,',','','ALL')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.MontoDetA,',','','ALL')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.GEAmanual,',','','ALL')#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
					0)
					<cf_dbidentity1 datasource="#session.DSN#" name="insertadetalle">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertadetalle" returnvariable="LvarTESSADid">
		</cfif>

		<!---INSERTA DETALLE 1 VEZ--->	
						
		<!---ARMAR LA CUENTA FINANCIERA--->
		<cfquery name="rsCtas" datasource="#session.DSN#">
			select sad.GEADid, cf.CFcuentac, cg.GECcomplemento
			from GEanticipo sa
				inner join CFuncional cf
				on cf.CFid = sa.CFid
					inner join GEanticipoDet sad
					on sad.GEAid = sa.GEAid
						inner join GEconceptoGasto cg
						on cg.GECid = sad.GECid
			where sa.GEAid = #form.GEAid#
		</cfquery>			
		<cfobject component="sif.Componentes.AplicarMascara" name="LvarOBJ">
		
		<cfloop query="rsCtas">
			<cfset LvarCFformato = LvarOBJ.AplicarMascara(rsCtas.CFcuentac, rsCtas.GECcomplemento)>
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" 
				method="fnGeneraCuentaFinanciera" 
				returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" value="#trim(LvarCFformato)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_DSN" value="#session.dsn#"/>
				<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
				</cfinvoke>
					<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
						<cfset mensaje="ERROR">
								<cfquery name="borraDetalle" datasource="#session.dsn#">
									delete from GEanticipoDet where GEADid=#LvarTESSADid#
								</cfquery>
								
								<cfquery name="borraAnticipo" datasource="#session.dsn#">
									delete from GEanticipo where GEAid=#LvarTESSAid#
								</cfquery>							
							<cfthrow message="#LvarError#">									
					</cfif>
			<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
				<cfquery datasource="#session.DSN#">
						update GEanticipoDet 
						set CFcuenta = #LvarCFcuenta#
						where GEADid = # rsCtas .GEADid#
				</cfquery>
				
		</cfloop>
		<cfset sbUpdateTotal(false)>	
	</cftransaction>
	<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#">	
</cfif>

<!---NUEVO ANTICIPO--->
	<cfif IsDefined("form.Nuevo")>
			<cflocation url="#LvarSAporEmpleadoCFM#?Nuevo">
	<cfelseif IsDefined("form.NuevaSA")>
			<cflocation url="#LvarSAporEmpleadoCFM#?Nuevo&GECid=#form.GECid#">
	</cfif>
	
<!---ELIMINAR ANTICIPO--->	
	<cfif IsDefined("form.Baja")>
		<cfquery datasource="#session.dsn#" name="eliminarDetalle">
				delete from GEanticipoDet where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">					
			</cfquery>	
			<cfquery datasource="#session.dsn#" name="eliminar">
				delete from GEanticipo where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">					
			</cfquery>		
		<cflocation url="#LvarSAporEmpleadoCFM#">
	</cfif>


<!---Aprueba la solicitud de Anticipo--->
<cfif IsDefined("form.AprobarC")>
	<cfthrow message="No se ha implementado la Aprobación de Comisiones">
</cfif>
<cfif IsDefined("form.Aprobar")>
	<cfif isdefined ('form.FormaPago') and form.FormaPago EQ 0>
			<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
			<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc">
	</cfif>			
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="rsAnticipo">
			update GEanticipo 
			   set CCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FormaPago#" null="#form.FormaPago EQ 0#">
			 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
		</cfquery>
		<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEanticipo_Aprobar" returnvariable="LvarTESSPid">
			<cfinvokeargument name="GEAid"  		value="#form.GEAid#">
			<cfinvokeargument name="CCHTid"  		value="-1">
		</cfinvoke>	
	</cftransaction>	
	<cfif isdefined ('form.chkImprimir')>
		<!--- <cf_SP_imprimir location="AprobarTrans.cfm"> --->
		<cfif isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
			<cfif form.FormaPago EQ 0>
				<cflocation url="imprSolicAnticipoCCH.cfm?GEAid=#form.GEAid#&url=#LvarSAporEmpleadoCFM#&TESSPid=#LvarTESSPid#">					
			<cfelse>
				<cflocation url="imprSolicAnticipoCCH.cfm?GEAid=#form.GEAid#&url=#LvarSAporEmpleadoCFM#">					
			</cfif>
		</cfif>	
	</cfif>
	<cflocation url="#LvarSAporEmpleadoCFM#">
 </cfif>

<!---Envia la solicitud de Pago a Aprobar--->
<cfif IsDefined("form.ImprimirC")>
	<cflocation url="imprSolicAnticipoCOM.cfm?GEAid=0&GECid=#form.GECid#&url=#LvarSAporEmpleadoCFM#">
</cfif>
<cfif IsDefined("form.AAprobarC")>
	<cfquery name="rsAnts" datasource="#session.dsn#">
		select GEAid, GEAdesde,GEAtotalOri, GEAviatico, GEAtipoviatico
		  from GEanticipo a
		 where GECid=#form.GECid# 
		   and GEAestado in (0,3)
	</cfquery>
	
	<cfif rsAnts.recordcount EQ 0>
		<cfthrow message="La Comisión no se puede Enviar a Aprobar o Aprobar porque no tiene Anticipos 'En Preparación'">
	</cfif>

	<cfset LvarTipo='COMISION'>
	<cfquery name="rsComision" datasource="#session.dsn#">
		select a.GECdescripcion, e.Mcodigo as McodigoLocal, 
				(
				select sum(round(GEAtotalOri*GEAmanual,2))
				  from GEanticipo
				 where GECid=a.GECid
				   and GEAestado in (0,3)
				) as GEAtotalLocal
		  from GEcomision a
		  	inner join Empresas e on e.Ecodigo=a.Ecodigo
		 where a.GECid=#form.GECid# 
	</cfquery>
	
	<cftransaction>
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
				<cfinvokeargument name="Mcodigo" 			value="#rsComision.McodigoLocal#"/>
				<cfinvokeargument name="CCHTdescripcion" 	value="#rsComision.GECdescripcion#"/>
				<cfinvokeargument name="CCHTmonto"	 		value="#rsComision.GEAtotalLocal#"/>
				<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
				<cfinvokeargument name="CCHTtipo" 			value="COMISION"/>
				<cfinvokeargument name="CCHTtrelacionada"   value="COMISION"/>
				<cfinvokeargument name="CCHTrelacionada"    value="#form.GECid#"/>
		</cfinvoke>
		<!--- Actulización del estado del Anticipo--->
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update GEanticipo set 
					GEAestado =1,
					CCHTid=#LvarCCHTidProc#
			 where GECid=#form.GECid# 
			   and GEAestado in (0,3)
		</cfquery>
		<!--- Actulización del estado de la Comision --->
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update GEcomision
			   set  GECestado =1
			 where GECid=#form.GECid# 
			   and GECestado in (0,3)
		</cfquery>
	</cftransaction>
	<cfif isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="imprSolicAnticipoCOM.cfm?GEAid=#form.GEAid#&GECid=#form.GECid#&url=#LvarSAporEmpleadoCFM#">
	</cfif>
	<cflocation url="#LvarSAporEmpleadoCFM#">
<cfelseif isdefined ('form.AAprobar')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select count(1) as cantidad from GEanticipo where GEAid=#form.GEAid# and GEAestado not in (0,3)
	</cfquery>
	
	<cfif rsValida.cantidad gt 0>
		<cfthrow message="El anticipo no se puede Enviar a Aprobar o Aprobar porque su estado es diferente de 'En Preparación'">
	</cfif>
	
	<!---Se buscan anticipos sin liquidar del mismo tipo--->
	<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="AnticiposSinLiquidarMismoTipo">
		<cfinvokeargument name="GEAid"  		value="#form.GEAid#">
		<cfinvokeargument name="DEid"  			value="#form.DEid#">
	</cfinvoke>
	
	<!---Si es viatico e interior --->
	<cfif #form.GEAviatico# eq 1 and #form.GEAtipoviatico# eq 1>
		<!---Valida que no sobrepase el monto máximo de viáticos al interior definido en parametrosGE--->
		<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="MontoMaxViaticoInt">
			<cfinvokeargument name="DEid"  			value="#form.DEid#">
			<cfinvokeargument name="fechaIni"  		value="#form.GEAdesde#">
			<cfinvokeargument name="MontoAnt"  		value="#form.GEAtotalOri#">
		</cfinvoke>	
	</cfif>
	
	<cftransaction>
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
				<cfinvokeargument name="Mcodigo" 			value="#form.McodigoOri#"/>
				<cfinvokeargument name="CFcuenta" 			value="#form.CFcuenta#"/>
				<cfinvokeargument name="CCHTdescripcion" 	value="#GEAdescripcion#"/>
				<cfinvokeargument name="CCHTmonto"	 		value="#replace(form.GEAtotalOri,',','','ALL')#"/>
				<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
				<cfinvokeargument name="CCHTtipo" 			value="ANTICIPO"/>
				<cfinvokeargument name="CCHTrelacionada"    value="#form.GEAid#"/>
				<cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
		</cfinvoke>
		<!--- Actulización del estado del Anticipo--->
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update GEanticipo set 
					GEAestado =1,
					CCHTid=#LvarCCHTidProc#
			where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cftransaction>
	<cfif isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="imprSolicAnticipoCCH.cfm?GEAid=#form.GEAid#&url=#LvarSAporEmpleadoCFM#">					
	</cfif>
	<cflocation url="#LvarSAporEmpleadoCFM#">
</cfif>

	<cfif IsDefined("form.CambioC")>
		<cfset sbUpdateComision (0)>
		<cfparam name="form.GEAid" default="0">
		<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#&GECid=#form.GECid#">	
	</cfif>

<!---MODIFICAR ANTICIPO--->
	<cfif IsDefined("form.Cambio")>
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
			select GEAviatico, GEAmanual
			  from GEanticipo 
			 where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#" null="#Len(form.GEAid) Is 0#">
		</cfquery>
		<cfquery datasource="#session.dsn#" name="actualizar">
			update GEanticipo set 
				TESBid	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESBid#">, 				
				CFid	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
				Mcodigo	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
			<cfif isdefined('form.GEAmanual') and len(trim(form.GEAmanual)) and form.GEAmanual NEQ 0>
				GEAmanual=<cfqueryparam cfsqltype="cf_sql_money" value="#form.GEAmanual#">,
			<cfelse>
				<cfset form.GEAmanual = 1>
				GEAmanual=<cfqueryparam cfsqltype="cf_sql_money" value="1">,
			</cfif>
			<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0>	
				CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FormaPago#">,
				GEAtipoP=0,
			<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0>
				CCHid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				GEAtipoP=1,
			</cfif>
				GEAfechaPagar	=<cfqueryparam value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
				GEAdescripcion	=<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAdescripcion#">,	
				GEAdesde		=<cfqueryparam value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,
				GEAhasta		=<cfqueryparam value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
				<cfif #rsAnticipo.GEAviatico# eq 0> 
				GEAviatico		=<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAviatico#">,
				GEAtipoviatico	=<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAtipoviatico#">,
				</cfif>
				GEAhoraini		=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhoraini#">,
				GEAhorafin		=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhorafin#">	
			where GEAid 	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#" null="#Len(form.GEAid) Is 0#">
		</cfquery>

		<cfset sbUpdateTotal(form.GEAmanual NEQ rsAnticipo.GEAmanual)>
		<cfset sbUpdateComision (form.GEAid)>

		<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#">	
	</cfif>
	

<!---IR LISTA--->
<cfif IsDefined("form.IrLista")>
	<cflocation url="solicitudes#url.tipo#.cfm">	
</cfif>

<!---IMPRIMIR--->
<cfif isdefined("form.Imprimir")>
<cf_navegacion name="TESSPid" default="#rs#">
		<cf_SP_imprimir location="solicitudes#url.tipo#.cfm">
</cfif>

<!---DUPLICAR--->
<cfif isdefined("form.Duplicar")>
		<cfquery name="rsNewID" datasource="#session.dsn#">
				select coalesce(max(GEAnumero),0) + 1 as newSolid
				from GEanticipo
				where Ecodigo=#session.Ecodigo#
		</cfquery>	
		<cftransaction>	
			
			<cfquery datasource="#session.dsn#" name="selecInser">
				select 
					TESid,
					GEAtipo,
					GEAfechaPagar,
					Mcodigo,
					GEAmanual,
					CFid,
					GEAtotalOri,
					GEAdescripcion,
					CFcuenta,
					TESBid,
					GEAdesde,
					GEAhasta,
					GEAviatico,        
					GEAtipoviatico,   
					GEAhoraini,        
					GEAhorafin 
				 from GEanticipo
				 where Ecodigo = #session.Ecodigo#
				   and GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">	
			</cfquery>
			
			<cfquery datasource="#session.dsn#" name="Duplicado">
				insert into GEanticipo (
					TESid, 
					GEAnumero,
					GEAtipo,
					GEAestado,
					GEAfechaPagar,
					Mcodigo,
					GEAmanual,
					CFid,
					GEAtotalOri,
					GEAdescripcion,
					GEAfechaSolicitud,
					UsucodigoSolicitud,
					CFcuenta,
					Ecodigo,
					TESBid,
					BMUsucodigo,
					GEAdesde,
					GEAhasta,
					GEAviatico,        
					GEAtipoviatico,   
					GEAhoraini,        
					GEAhorafin 
					)
				VALUES(
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.TESid#"              voidNull>, 
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsNewID.newSolid#"          	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selecInser.GEAtipo#"            voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="0">,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selecInser.GEAfechaPagar#"      voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.Mcodigo#"            voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selecInser.GEAmanual#"          voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.CFid#"               voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selecInser.GEAtotalOri#"        voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="350" value="#selecInser.GEAdescripcion#"     voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
				    #session.Usucodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.CFcuenta#"           voidNull>,
				   #session.Ecodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.TESBid#"             voidNull>,
				    #session.Usucodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selecInser.GEAdesde#"           voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selecInser.GEAhasta#"           voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selecInser.GEAviatico#"         voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selecInser.GEAtipoviatico#"     voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.GEAhoraini#"         voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.GEAhorafin#"         voidNull>
				)	
				
				<cf_dbidentity1 datasource="#session.DSN#" name="Duplicado">		
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="Duplicado" returnvariable="idDumpli">
	
	
	<cfquery datasource="#session.dsn#" name="saveDupli">
			update GEanticipo 
			set GEAidDuplicado	= <cfqueryparam cfsqltype="cf_sql_integer" value="#idDumpli#">
			where GEAid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
	</cfquery>
<!---Muestra los Detalles de los anticipos duplicados --->
	
	<cfquery name="BuscaDetalle" datasource="#session.dsn#">
		select * from GEanticipoDet where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
	</cfquery>

		<cfloop query="BuscaDetalle">	
		
		<cfquery name="selectPrueba" datasource="#session.dsn#">
			select
				#idDumpli# as GEAid, 
				CFcuenta,
				TESDPaprobadopendiente, 
				GEADutilizado,
				GEADmonto,
				GECid,
				GEPVid,             
				BMUsucodigo,
				GEADfechaini, 
				GEADfechafin,
				GEADhoraini,
				GEADhorafin,           
				GEADmontoviatico,  
				GEADtipocambio,     
				McodigoPlantilla,     
				PCGDid
				from GEanticipoDet
				where GEADid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#BuscaDetalle.GEADid#">
		</cfquery>
		
		<cfquery name="prueba" datasource="#session.dsn#">
			insert INTO GEanticipoDet
			(
			GEAid,
			CFcuenta,
			TESDPaprobadopendiente,
			GEADutilizado,
			GEADmonto,
			GECid,
			GEPVid,             
			BMUsucodigo,
			GEADfechaini, 
			GEADfechafin,
			GEADhoraini,
			GEADhorafin,           
			GEADmontoviatico,  
			GEADtipocambio,     
			McodigoPlantilla,     
			PCGDid
			)
		VALUES(
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GEAid#"                  voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.CFcuenta#"               voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.TESDPaprobadopendiente#" voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.GEADutilizado#"          voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.GEADmonto#"              voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GECid#"                  voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GEPVid#"                 voidNull>,
			    #session.Usucodigo#,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectPrueba.GEADfechaini#"           voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectPrueba.GEADfechafin#"           voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GEADhoraini#"            voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GEADhorafin#"            voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.GEADmontoviatico#"       voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.GEADtipocambio#"         voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.McodigoPlantilla#"       voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.PCGDid#"                 voidNull>
			  
		)
			<cf_dbidentity1 datasource="#session.DSN#" name="prueba">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="prueba" returnvariable="LvarTESSADid">
		</cfloop>
	</cftransaction>

	<cflocation url="#LvarSAporEmpleadoCFM#">	
</cfif>

<!---|____________________________________________________________________________________________________|--->
<!---***********************************************DETALLE*************************************************--->
<!---|____________________________________________________________________________________________________|--->


<!---INGRESAR DETALLE--->

<cfif isdefined('form.AltaDet')>
	
	<!---Si no es por plan de compras verifica que el concepto no se ingrese mas de una vez--->
	<cfif NOT LvarConPlanCompras>
		<cfquery name="verificaDetalle" datasource="#session.dsn#">
			select 
				count(1) as cantidad  
			from 
				GEanticipoDet 
			where 
				GEAid=#form.GEAid# 
				and GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">
		</cfquery>
		
		<cfif #verificaDetalle.cantidad# gt 0>
			<cf_errorCode	code = "50747" msg = "Ese Concepto ya se ingreso">
		</cfif>
	</cfif>	
		
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="insertadetalle">
			insert into GEanticipoDet (
				GEAid,
				GECid,
				BMUsucodigo,
				GEADmonto,
				GEADtipocambio,
				GEADmontoviatico,
				McodigoPlantilla,
				<cfif LvarConPlanCompras> 		
					PCGDid,
					CFcuenta,
				</cfif>	
				Linea)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GEAid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.concepto#">,
				#session.Usucodigo#,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#form.MontoDetCalculado#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#form.GEAmanualDet#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#form.MontoDet#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.McodigoOriD#">,
				<cfif LvarConPlanCompras>
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.PCGDid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CFcuenta#">,
				</cfif>	
				0)
				<cf_dbidentity1 datasource="#session.DSN#" name="insertadetalle">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertadetalle" returnvariable="LvarTESSADid1">
		<cfset #form.GEADid#=#LvarTESSADid1#>						
					
		<!---CREA CUENTA FINANCIERA--->		
		<!---Mascara para la cuenta financiera--->		
		
		<!---si NO es por plan de compras arma la cuenta como siempre lo ha hecho--->	
		<cfif NOT LvarConPlanCompras> 		
			<cfquery name="rsCtas" datasource="#session.DSN#">
				select sad.GEADid, cf.CFcuentac, cg.GECcomplemento
				from GEanticipo sa
					inner join CFuncional cf
					on cf.CFid = sa.CFid
						inner join GEanticipoDet sad
						on sad.GEAid = sa.GEAid
							inner join GEconceptoGasto cg
							on cg.GECid = sad.GECid
				where sa.GEAid = #form.GEAid#
			</cfquery>				
			<cfobject component="sif.Componentes.AplicarMascara" name="LvarOBJ">				
			<cfloop query="rsCtas">
				<cfset LvarCFformato = LvarOBJ.AplicarMascara(rsCtas.CFcuentac, rsCtas.GECcomplemento)>
					<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" 
								method="fnGeneraCuentaFinanciera" 
								returnvariable="LvarError">
								<cfinvokeargument name="Lprm_CFformato" 		value="#trim(LvarCFformato)#"/>
								<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
								<cfinvokeargument name="Lprm_DSN" 				value="#session.dsn#"/>
								<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
					</cfinvoke>
					<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
						<cfset mensaje="ERROR">
								<cfquery name="borraDetalle" datasource="#session.dsn#">
									delete from GEanticipoDet where GEADid=#LvarTESSADid1#
								</cfquery>			
							<cfthrow message="#LvarError#">									
					</cfif>
					<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
					<cfquery datasource="#session.DSN#">
							update GEanticipoDet 
							set CFcuenta = #LvarCFcuenta#
							where GEADid = #form.GEADid#
					</cfquery>
			</cfloop>
		</cfif>	<!---termina de armar las cuentas y actualiza totales--->
		<cfset sbUpdateTotal(false)>	
	</cftransaction>	
	<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#">
</cfif>


<!---MODIFICAR DETALLE--->
<cfif isdefined('form.CambioDet')>
	<!---<cf_dump var="#form#">--->
	<cfquery datasource="#session.dsn#" name="actualizadetalle">
		update GEanticipoDet set
			GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">,
			<cfif LvarConPlanCompras>
				PCGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCGDid#">,
			</cfif>	
			CFcuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
			GEADmonto=<cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoDetCalculado#">,
			GEADtipocambio=<cfqueryparam cfsqltype="cf_sql_money" value="#form.GEAmanualDet#">,
			GEADmontoviatico=<cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoDet#">,
			McodigoPlantilla=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOriD#">
		where
			GEADid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEADid#">
	</cfquery>
	<cfset sbUpdateTotal(false)>	
	<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#&GEADid=#form.GEADid#">
</cfif>

<!---ELIMINAR DETALLE--->
	<cfif isdefined('form.BajaDet')>
		<cfquery datasource="#session.dsn#" name="eliminaDetalle">
			delete from GEanticipoDet where GEADid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEADid#">
		</cfquery>		
		<cfset sbUpdateTotal(false)>
		<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#">
	</cfif>
	
<!---NUEVO DETALLE--->
	<cfif isdefined('form.NuevoDet')>
		<cflocation url="solicitudes#url.tipo#.cfm?GEAid=#form.GEAid#">
	</cfif>
	
	
<cffunction name="sbUpdateTotal" output="false" access="private">
	<cfargument name="CambioTC" type="boolean">
	
	<cfif Arguments.CambioTC>
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
			select GEAmanual
			  from GEanticipo 
			 where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#" null="#Len(form.GEAid) Is 0#">
		</cfquery>

		<cfquery datasource="#session.dsn#">
			update GEanticipoDet
			   set GEADmonto = GEADmontoviatico * GEADtipocambio / #rsAnticipo.GEAmanual#
			 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
		</cfquery>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update GEanticipo
 		   set GEAtotalOri = 
					coalesce(
					( 
						select sum(GEADmonto)
						  from GEanticipoDet
						 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
					)
					, 0)
		  where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#" null="#Len(form.GEAid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="sbUpdateComision" output="false" access="private">
	<cfargument name="GEAid" type="boolean">
	<cfif NOT (isdefined("form.GECid") AND form.GECid NEQ "" AND form.GECid NEQ "0")>
		<cfreturn>
	</cfif>
	<cfquery datasource="#session.dsn#" name="insertar">
		update GEcomision
		   set
				TESBid				= <cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#LvarTESBid#">,
				CFid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
				GECdescripcion		= <cf_jdbcquery_param 	cfsqltype="cf_sql_char" 	value="#form.GEAdescripcion#">,
				GECfechaPagar		= <cf_jdbcquery_param value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
				UsucodigoSolicitud	= #session.Usucodigo#,

				GECdesde		= <cf_jdbcquery_param value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,	
				GEChoraini		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhoraini#">,
				GEChasta		= <cf_jdbcquery_param value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
				GEChorafin		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhorafin#">,
					
				<cfparam name="form.GECautomovil" default="0">
				<cfparam name="form.GEChotel" default="0">
				<cfparam name="form.GECavion" default="0">
				GECautomovil	= #form.GECautomovil#,
				GEChotel		= #form.GEChotel#,
				GECavion		= #form.GECavion#,

				GECobservaciones	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservaciones#"  len="255" null="#trim(form.GECobservaciones) EQ ""#">,
				GECobservaciones2	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservaciones2#" len="255" null="#trim(form.GECobservaciones2) EQ ""#">,
				GECusaTCE			= <cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.GECusaTCE#">,
				GECtipo				= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GECtipo#">,

				<cfparam name="form.CBid_TCE" default="">
				CBid_TCE		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid_TCE#" null="#form.CBid_TCE EQ ""#">
		 where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid#">
	</cfquery>
	<cfquery datasource="#session.dsn#" name="actualizar">
		update GEanticipo set 
			TESBid			=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESBid#">, 				
			CFid			=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
			GEAfechaPagar	=<cfqueryparam value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
			GEAdescripcion	=<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAdescripcion#">,	
			UsucodigoSolicitud	= #session.Usucodigo#,
			GEAdesde		=<cfqueryparam value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,
			GEAhasta		=<cfqueryparam value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
			GEAhoraini		=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhoraini#">,
			GEAhorafin		=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhorafin#">	
		  where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid#">
		    and GEAid <><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GEAid#">
			and GEAestado = 0
	</cfquery>
</cffunction>
