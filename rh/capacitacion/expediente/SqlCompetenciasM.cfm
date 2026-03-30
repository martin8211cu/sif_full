 
<cfif not isdefined("form.VERLIST")>
	<cfsilent>	
	 	<cfif isDefined("url.checkOperation") and url.checkOperation eq 2 and isDefined("url.RHCEid") and len(trim(url.RHCEid))>
			<cfif isDefined("Lvar_CompAuto")>
				<cfquery datasource="#session.dsn#" name="rsValida1">
					select count(1) as valor from RHCompetenciasEmpleado where RHCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCEid#"> and RHCestado = 1
				</cfquery>
				<cfif rsValida1.valor>
					<cf_Translate key="MSG_NoPuedeEditarEstarInformacionAprobacionPrevia" xmlFile="/rh/generales.xml">No puede editar esta información debido a una aprobación previa</cf_Translate>
				</cfif>
			</cfif>	
			<cfabort>
		</cfif>
		<cfif isDefined("url.checkOperation") and url.checkOperation eq 1>
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2658" default="0" returnvariable="lvarSoloAnnoCompetencia"/>
			<cfquery name="validaInsert" datasource="#session.DSN#">
				select RHCEid from
					RHCompetenciasEmpleado
				where 
					<cfif isdefined("url.RHOid") and len(trim(url.RHOid))>
						RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHOid#">
					<cfelse>						
						DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
					</cfif>	
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and idcompetencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.competencia#">
					and tipo =<cfqueryparam cfsqltype="cf_sql_char" value="#url.tipo#">
					<cfif lvarSoloAnnoCompetencia EQ 0>
						and RHCEfdesde = <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSparsedatetime(url.anno)#" >	
					<cfelse>
						and <cf_dbfunction name="date_part" args="YYYY,RHCEfdesde"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.anno#" >	
					</cfif>
			</cfquery> 
			<cfif not len(trim(validaInsert.RHCEid))>
				<cfquery name="rsCompetencias" datasource="#session.dsn#">
					select count(1) as cant from RHCompetenciasEmpleado rh
					where rh.tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo#">
						and rh.RHNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.nivel#">
						and rh.idcompetencia <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.competencia#">
						<cfif isdefined("url.RHOid") and len(trim(url.RHOid))>
							and rh.RHOid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHOid#">
						<cfelse>
							and rh.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
						</cfif>
						<cfif url.tipo eq 'C'>
							and (select count(1)
								from RHConocimientos
								where rh.idcompetencia = RHCid
									and coalesce(RHCinactivo,0)=0
								) > 0
						<cfelse>	
							and (select count(1)
								from RHHabilidades
								where rh.idcompetencia = RHHid
									and coalesce(RHHinactivo,0)=0
								) > 0
						</cfif>
					and rh.RHCEfdesde >= (select max(B.RHCEfdesde) from RHCompetenciasEmpleado B 
										<cfif isdefined("url.RHOid") and len(trim(url.RHOid))>
											where B.RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHOid#"> 
										<cfelse>
											where B.DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
										</cfif>
										and   B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and   B.Ecodigo = rh.Ecodigo 
										and   B.tipo = '#url.tipo#' 
										and   B.idcompetencia = rh.idcompetencia )
				</cfquery>
				<cf_translatedata tabla="RHNiveles" name="get" col="n.RHNdescripcion" returnvariable="LvarRHNdescripcion">
				<cfquery name="rsniveles" datasource="#session.dsn#">
					select count(1) as cant
					from RHNiveles n
					where n.RHNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.nivel#">
					and n.RHNmaxitem is not null
					and n.RHNmaxitem <= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompetencias.cant#">
				</cfquery> 
				<cfif rsniveles.cant>
						<cf_Translate key="MSG_HaExcedidoElMaximoDeCompetenciasNivelYou" xmlFile="/rh/generales.xml">Ha excedido el máximo de Competencias para este Nivel</cf_Translate>
				</cfif>
			</cfif>
			<cfabort>
		</cfif>
	</cfsilent>

	<cftransaction>	
		<cfif isdefined('form.RHCEfdesde') and len(trim(form.RHCEfdesde))>
	        <cfset finicio = #LSParseDateTime(RHCEfdesde)#>
	    <cfelse>
	        <cfset finicio = createdate(#form.AnnoIni#,01,01)>
	    </cfif>

	    <cfif isdefined('form.RHCEfhasta') and len(trim(form.RHCEfhasta))>
	        <cfset ffinal = #LSParseDateTime(form.RHCEfhasta)#>
	    <cfelseif isdefined('form.AnnoFin')>
	        <cfset ffinal = createdate(#form.AnnoFin#,12,31)>
	    <cfelse>
	        <cfset ffinal = createdate(6100,01,01)>
	    </cfif>
	 
		<cfif not isdefined("Form.NuevoC1") or not isdefined("Form.NuevoC2")>
			<cfif isdefined("Form.ALTAC1")>

				<!--- ************************************* --->
				<!--- lo primero que hace es verificar si   --->
				<!--- ya existe un registro con esa fecha   --->
				<!--- si existe modifica si no hace alta    --->
				<!--- ************************************* --->
				<cfquery name="validaInsert" datasource="#session.DSN#">
					select RHCEid from
						RHCompetenciasEmpleado
					where 
						<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
							RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
						<cfelse>						
							DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						</cfif>	
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and idcompetencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idcompetencia#">
						and tipo =<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
						and RHCEfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finicio#" >	
				</cfquery> 
					
				<cfif validaInsert.recordcount eq 0>
					<!--- ********************************** --->
					<!--- Hace alta   RHCompetenciasEmpleado --->
					<!--- ********************************** --->
					<cfquery name="RHCompetenciasEmpleadoInsert" datasource="#session.DSN#">
						insert into RHCompetenciasEmpleado (
							<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
								RHOid,
							<cfelse>
								DEid,
							</cfif>
							Ecodigo,
							idcompetencia,
							RHNid,
							tipo,
							RHCEfdesde,
							RHCEfhasta,
							RHCEdominio,
							RHCEjustificacion,
							BMUsucodigo,
							BMfecha)
						values(
							<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
							</cfif>	
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.idcompetencia#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idnivel#" null="#not len(trim(form.idnivel))#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">,
	                       	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#finicio#" >,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ffinal#" >,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCEdominio#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHCEjustificacion)#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="RHCompetenciasEmpleadoInsert">
					<cfset Nuevo = 'S'> 
					<cfinclude template="SQLvalidaFechas.cfm">
				<cfelse>
					<!--- ************************************ --->
					<!--- Hace cambio  RHCompetenciasEmpleado  --->
					<!--- ************************************ --->
	 
					<cfquery name="RHCompetenciasEmpleadoUpdate" datasource="#session.DSN#">
						update  RHCompetenciasEmpleado  set
						RHCEfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finicio#" >,
						RHCEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ffinal#" >,
						RHCEdominio = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCEdominio#">,
						RHCEjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHCEjustificacion)#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						RHNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idnivel#" null="#not len(trim(form.idnivel))#">
						where 
						<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
							RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
						<cfelse>
							DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						</cfif>	
						and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and  RHCEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#validaInsert.RHCEid#">
					</cfquery>	

					<cfset Nuevo = 'N'> 
				</cfif>
				<cfset form.MODOC1 = 'ALTA'>	
			<cfelseif isdefined("Form.CAMBIOC1")>
				<!--- ************************************ --->
				<!--- Hace cambio  RHCompetenciasEmpleado  --->
				<!--- con la nueva estructuracion de la    --->
				<!--- Pantalla no se esta usando           --->
				<!--- ************************************ --->
				<cfquery name="RHCompetenciasEmpleadoUpdate" datasource="#session.DSN#">
					update  RHCompetenciasEmpleado  set
					RHCEfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finicio#" >,
					RHCEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ffinal#" >,
					RHCEdominio = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCEdominio#">,
					RHCEjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHCEjustificacion)#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where
					<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
						RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
					<cfelse>
						DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					</cfif>	
					and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and  RHCEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEid#">
				</cfquery>
				<cfinclude template="SQLvalidaFechas.cfm">
			<cfelseif isdefined("Form.AltaC2")>
			
				<!--- ****************************************** --->
				<!--- Hace Alta   RHEmpleadoCurso   		     --->
	     		<!--- y  Alta   cambio  RHCompetenciasEmpleado   --->
				<!--- ****************************************** --->
				<cfif isdefined("form.Mcodigo2") and len(trim(form.Mcodigo2))>
					<cfquery name="RHEmpleadoCursoInsert" datasource="#session.DSN#">
						insert into RHEmpleadoCurso (
							<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
								RHOid,
							<cfelse>
								DEid,
							</cfif>
							RHCid,
							Ecodigo,
							Mcodigo,
							RHEMnotamin, 
							RHEMnota,      
							RHECtotempresa, 
							RHECtotempleado,
							idmoneda,             
							RHECcobrar,         
							RHEMestado,        
							BMfecha,               
							BMUsucodigo,
							RHECfdesde,
							RHECfhasta 					
							)
						values(
							<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
							</cfif>
							<!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#"> --->null,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo2#">,
							<!--- <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHEMnotamin,',','','all')#">  --->0,
							<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHEMnota,',','','all')#">,
							<!--- <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHECtotempresa,',','','all')#"> --->null,
							<!--- <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHECtotempleado,',','','all')#"> --->null,
							<!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idmoneda#"> --->null,
							<!--- <cfif isdefined("form.RHECcobrar")>1<cfelse>0</cfif> --->0,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEMestado#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHECfdesde)#" >,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHECfhasta)#" >
		
						)
					</cfquery>
				</cfif>
					
				<cfquery name="RHCompetenciasEmpleadoUpdate" datasource="#session.DSN#">
					update  RHCompetenciasEmpleado  set
					RHCEdominio = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCEdominio#">,
					RHCEjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHCEjustificacion)#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where
					<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
						RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
					<cfelse>
						DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					</cfif>
					and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and  RHCEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEid#">
				</cfquery>
			<cfelseif isdefined("Form.BajaC1") or isdefined("Form.MODODEl")>   <!--- modo baj---->
				<cfquery datasource="#session.dsn#">
					delete from RHCompetenciasEmpleado
					where RHCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEid#">
				</cfquery>
			</cfif>
	    </cfif>	
	</cftransaction>
</cfif>	

<cfif isDefined("Lvar_CompAuto") and  isdefined("form.DEid") and len(trim(form.DEid))>
	<cfparam name="action" default="/cfmx/rh/autogestion/autogestion.cfm">
<cfelseif isdefined("form.DEid") and len(trim(form.DEid))>
	<cfparam name="action" default="expediente.cfm">
<cfelse>
	<cfparam name="action" default="/cfmx/rh/Reclutamiento/catalogos/OferenteExterno.cfm">
</cfif>


<cfoutput>
	<form action="#action#" method="post" name="sql">
		<cfif not isdefined("form.VERLIST")>
			<input name="DEid" type="hidden" value="<cfif isdefined("Form.DEid")>#Form.DEid#</cfif>">
			<input name="RHOid" type="hidden" value="<cfif isdefined("Form.RHOid")>#Form.RHOid#</cfif>">
			<input type="hidden" name="changes" value="1">
			
			<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
				<input type="hidden" name="o" value="5">
			</cfif>
			
			<cfif isdefined("form.MODOC1")>
				<input name="MODOC1"   type="hidden" value="#form.MODOC1#">
			</cfif>	
			<cfif isdefined("form.ANOTA")>
				<input name="ANOTA"   type="hidden" value="#form.ANOTA#">
			</cfif>	
			<cfif isdefined("form.TIPO")>
					<input type="hidden" name="TIPO" value="#Form.TIPO#">
			</cfif>	
			<cfif isdefined("form.idcompetencia")>
					<input type="hidden" name="idcompetencia" value="#Form.idcompetencia#">
			</cfif>
			<cfif isdefined("form.idnivel")>
					<input type="hidden" name="idnivel" value="#Form.idnivel#">
			</cfif>
			<cfif isdefined("form.RHCid")>
				<input name="RHCid"   type="hidden" value="#form.RHCid#">
			</cfif>		
			<cfif isdefined("form.ADDCUR")>
				<input name="ADDCUR"   type="hidden" value="#form.ADDCUR#">
			</cfif>		
			<cfif isdefined("form.RHCEid")>
				<input name="RHCEid"   type="hidden" value="#form.RHCEid#">
			</cfif>			
		</cfif>	

		<cfif isDefined("Lvar_CompAuto")>
			<input name="o" type="hidden" value="8">
			<input type="hidden" name="tab" value="8">
		<cfelse>
			<input type="hidden" name="tab" value="2">	
		</cfif>
	</form>
</cfoutput>

<HTML>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</HTML>
