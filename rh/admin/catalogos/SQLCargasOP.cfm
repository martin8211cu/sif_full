<!---<cf_dump var=#form#>--->
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_El_registro_que_desea_insertar_ya_existe"
Default="El registro que desea intertar ya existe..."
returnvariable="MG_El_registro_que_desea_insertar_ya_existe"/>


<cfparam name="action" default="CargasOP.cfm">

<cfset modo="CAMBIO">
<cfset modoDet="ALTA">

<cfif not isdefined("Form.NuevoD")>
<cftransaction>

		<cfset existe = false>
		<cfset cambioEncab = false>

		<!--- Permite saber si se modificó algún campo del encabezado --->
		<cfif isDefined("Form.CambioEncabezado") and Len(Trim(Form.CambioEncabezado)) GT 0 and Compare(Trim(Form.CambioEncabezado),"1") EQ 0>
			<cfset cambioEncab = true>
		</cfif>

		<cfif isdefined("Form.AgregarE") >
			<cfquery name="rsExisteEncab" datasource="#Session.DSN#">
				select 1 from ECargas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and ECcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ECcodigo#">
			</cfquery>

			<cfif rsExisteEncab.RecordCount gt 0>
				<cf_throw message="#MG_El_registro_que_desea_insertar_ya_existe#" errorcode="2075">
			</cfif>
		</cfif>

		<cfif isdefined("Form.AgregarD") >
			<cfquery name="rsExisteDet" datasource="#Session.DSN#">
				select 1
				from DCargas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and DCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.DCcodigo)#">
			</cfquery>

			<cfif rsExisteDet.RecordCount gt 0>
				<cf_throw message="#MG_El_registro_que_desea_insertar_ya_existe#" errorcode="2075">
			</cfif>
		</cfif>


			<cfif isDefined("Form.AgregarE")>
				<cfif not existe>
					<cfquery name="insECargas" datasource="#Session.DSN#" >
						insert into ECargas (Ecodigo, ECcodigo, ECdescripcion, Usucodigo, Ulocalizacion, ECfecha, ECauto, ECprioridad,
							 ECCreditoFiscal, ECSalarioBaseC, ECresumido, RHCSATid)
						values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ECcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECdescripcion#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								 '00',
								 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								 <cfif isDefined("Form.ECauto")>1<cfelse>0</cfif>,
								 <cfif isDefined("Form.ECprioridad") and len(trim(Form.ECprioridad))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.ECprioridad, ',', '', 'all')#"><cfelse>0</cfif>,
								 <cfif isDefined("Form.ECCreditoFiscal")>1<cfelse>0</cfif>,
								 <cfif isDefined("Form.ECSalarioBaseC")>1<cfelse>0</cfif>,
								 <cfif isDefined("Form.ECResumido")>1<cfelse>0</cfif>,
								 <cfif isdefined("form.ConceptoSAT")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#"><cfelse>0</cfif>
						)
						<cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="insECargas">

					<cfset modo="CAMBIO">
					<cfset modoDet="ALTA">
				</cfif>

			<cfelseif isdefined("Form.BorrarE")>

					<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
						<cfinvokeargument  name="nombreTabla" value="RHCargasRebajar">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and CPid = #form.ECid#">
						<cfinvokeargument name="necesitaTransaccion" value="false">
					</cfinvoke>
				<cfquery datasource="#Session.DSN#" >
					delete from RHCargasRebajar
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
				</cfquery>
					<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
						<cfinvokeargument  name="nombreTabla" value="DCTDeduccionExcluir">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="Clinea in(select DClinea from DCargas a where a.Ecodigo = #Session.Ecodigo# and a.ECid = #Form.ECid# and a.DClinea = DCTDeduccionExcluir.DClinea">
						<cfinvokeargument name="necesitaTransaccion" value="false">
					</cfinvoke>
					<cfquery datasource="#Session.DSN#" >
					delete from DCTDeduccionExcluir
					where DClinea in( 	select DClinea
										from DCargas a
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										  and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and a.DClinea = DCTDeduccionExcluir.DClinea
									)
					</cfquery>
					<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
						<cfinvokeargument  name="nombreTabla" value="DCargas">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and a.ECid = #Form.ECid#">
						<cfinvokeargument name="necesitaTransaccion" value="false">
					</cfinvoke>
				<cfquery name="DCargas" datasource="#Session.DSN#" >
					delete from DCargas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
				</cfquery>
					<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
						<cfinvokeargument  name="nombreTabla" value="ECargas">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and a.ECid = #Form.ECid#">
						<cfinvokeargument name="necesitaTransaccion" value="false">
					</cfinvoke>
				<cfquery name="ECargas" datasource="#Session.DSN#" >
					delete from ECargas
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
				</cfquery>
				<cfset modo    = "ALTA">
				<cfset modoDet = "ALTA">
				<cfset action = "listaCargasOP.cfm" >

			<cfelseif isdefined("Form.AgregarD")>

				<cfif cambioEncab>
					<cfquery name="dataExiste" datasource="#session.DSN#">
						select 1
						from RHCargasRebajar
						where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#" >
					</cfquery>

					<cfquery name="ECargas" datasource="#Session.DSN#" >
						update ECargas set
							ECdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECdescripcion#">
							<cfif dataExiste.recordcount eq 0 >,ECprioridad = <cfif isDefined("Form.ECprioridad") and len(trim(Form.ECprioridad))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.ECprioridad, ',', '', 'all')#"><cfelse>0</cfif></cfif>
							, ECauto =
								<cfif isDefined("Form.ECauto")>
									<cfqueryparam cfsqltype="cf_sql_bit" value="1">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_bit" value="0">
								</cfif>
							, ECCreditoFiscal =
								<cfif isDefined("Form.ECCreditoFiscal")>
									<cfqueryparam cfsqltype="cf_sql_bit" value="1">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_bit" value="0">
								</cfif>
							, ECSalarioBaseC =
								<cfif isDefined("Form.ECSalarioBaseC")>
									<cfqueryparam cfsqltype="cf_sql_bit" value="1">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_bit" value="0">
								</cfif>

							,ECresumido=
							   <cfif isDefined("Form.ECResumido")>
									<cfqueryparam cfsqltype="cf_sql_bit" value="1">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_bit" value="0">
								</cfif>
							,RHCSATid  =
								<cfif isdefined("form.ConceptoSAT")>
                                	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ConceptoSAT#">
                                <cfelse>0</cfif>
                            where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
				</cfif>
				<cfquery name="insDCargas" datasource="#Session.DSN#">
					insert into DCargas (ECid, Ecodigo, SNcodigo, DCcodigo, DCmetodo, DCdescripcion,
										DCvaloremp, DCvalorpat, DCprovision, DCnorenta, DCtipo, SNreferencia,
										DCcuentac, DCtiporango, DCrangomin, DCrangomax,
										DCSumarizarLiq,DCMostrarLiq,DCclave,DCcodigoext,
										DCcalcInteres, DCporcInteres, DCaplica,
										DCdisminuyeSBC, DCvsmg, DCdbc, DCusaSMGA, DCnomostrar,DCUsaUMA,DCEsExcedente)
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
						   , <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						   , <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
						   , <cfqueryparam cfsqltype="cf_sql_char" value="#replace(trim(Form.DCcodigo),' ','_','all')#">
						   , <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DCmetodo#">
						   , <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DCdescripcion#">
						   , <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCvaloremp#"><!--- OJO en la bd esta como number ORACLe, sybase= money--->
						   , <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCvalorpat#"><!--- OJO en la bd esta como number ORACLe, sybase= money--->
						  <cfif isDefined("Form.DCprovision")>
							  ,<cfqueryparam cfsqltype="cf_sql_bit" value="1">
						  <cfelse>
							  ,<cfqueryparam cfsqltype="cf_sql_bit" value="0">
						  </cfif>
						  <cfif isDefined("Form.DCnorenta")>
							  ,<cfqueryparam cfsqltype="cf_sql_bit" value="1">
						  <cfelse>
							  ,<cfqueryparam cfsqltype="cf_sql_bit" value="0">
						  </cfif>
						  , <cfqueryparam cfsqltype="cf_sql_bit" value="#Form.DCtipo#">
						  , <cfif form.DCtipo eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigoref#"><cfelse>null</cfif>
						  , <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DCcuentac#">
						  , <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DCtiporango#">
						<cfif Form.DCtiporango EQ 1>
						  , <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCrangomin1#">
						<cfelseif Form.DCtiporango EQ 2>
						  , <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCrangomin2#">
						<cfelse>
						  , 0.00
						</cfif>
						<cfif Form.DCtiporango EQ 1>
						  , <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCrangomax1#">
						<cfelseif Form.DCtiporango EQ 2>
						  , <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCrangomax2#">
						<cfelse>
						  , 0.00
						</cfif>
						<cfif isDefined("Form.DCSumarizarLiq")>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>
						<cfif isDefined("Form.DCMostrarLiq")>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>
						<cfif isdefined('form.DCclave') and LEN(TRIM(form.DCclave))>
						  ,<cfqueryparam cfsqltype="cf_sql_char" value="#form.DCclave#">
						<cfelse>
							,null
						</cfif>
						<cfif isdefined('form.DCcodigoext') and LEN(TRIM(form.DCcodigoext))>
						  ,<cfqueryparam cfsqltype="cf_sql_char" value="#form.DCcodigoext#">
						<cfelse>
							,null
						</cfif>
						<cfif isdefined('form.DCcalcInteres') and LEN(TRIM(form.DCcalcInteres))
							and isdefined('form.DCporcInteres') and LEN(TRIM(form.DCporcInteres))>
							,1,<cfqueryparam cfsqltype="cf_sql_float" value="#form.DCporcInteres#">
						<cfelse>
							,0,null
						</cfif>
						  <cfif isDefined("Form.DCaplica")>
							  ,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DCaplica#">
						  <cfelse>
							  ,0
						  </cfif>

						  <cfif isDefined("Form.DCdisminuyeSBC")>
							  ,1, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DCvsmg#">
						  <cfelse>
							  ,0,0
						  </cfif>
						  <cfif isDefined("Form.DCdbc")>
							  ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DCdbc#">
						  <cfelse>
							  ,1
						  </cfif>
						  <cfif isDefined("Form.DCusaSMGA")>
							  ,1
						  <cfelse>
							  ,0
						  </cfif>
						  <cfif isDefined("Form.DCnomostrar")>
							  ,1
						  <cfelse>
							  ,0
						  </cfif>
						  ,#isDefined("Form.DCUsaUMA") ? 1 : 0#
						  ,#isDefined("Form.DCEsExcedente") ? 1 : 0#

						)
				</cfquery>
				<cfset modo="CAMBIO">
				<cfset modoDet="ALTA">

			<cfelseif isdefined("Form.BorrarD")>
				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
					<cfinvokeargument  name="nombreTabla" value="DCTDeduccionExcluir">
					<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
					<cfinvokeargument name="condicion" value="DClinea = #form.DClinea#">
					<cfinvokeargument name="necesitaTransaccion" value="false">
				</cfinvoke>

				<cfquery datasource="#session.DSN#">
					delete from DCTDeduccionExcluir
					where DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#">
				</cfquery>
					<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
						<cfinvokeargument  name="nombreTabla" value="DCargas">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and ECid=#Form.ECid# and DClinea=#Form.DClinea#">
						<cfinvokeargument name="necesitaTransaccion" value="false">
					</cfinvoke>
				<cfquery name="delDCargas" datasource="#Session.DSN#" >
					delete from DCargas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and ECid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
					  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#">
				</cfquery>
				<cfset modo="CAMBIO">
				<cfset modoDet="ALTA">

			<cfelseif isdefined("Form.CambiarD")>

				<cfif cambioEncab>
					<cfquery name="dataExiste" datasource="#session.DSN#">
						select 1
						from RHCargasRebajar
						where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#" >
					</cfquery>

					<cfquery name="updECargas" datasource="#Session.DSN#" >
						update ECargas set
							ECdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECdescripcion#">
							, ECauto = <cfif isDefined("Form.ECauto")>1<cfelse>0</cfif>
							, ECCreditoFiscal = <cfif isDefined("Form.ECCreditoFiscal")>1<cfelse>0</cfif>
							, ECSalarioBaseC = <cfif isDefined("Form.ECSalarioBaseC")>1<cfelse>0</cfif>
							, ECresumido=  <cfif isDefined("Form.ECResumido")>1<cfelse>0</cfif>
							<cfif dataExiste.recordcount eq 0 >, ECprioridad = <cfif isDefined("Form.ECprioridad") and len(trim(Form.ECprioridad))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.ECprioridad, ',', '', 'all')#"><cfelse>0</cfif></cfif>
							,RHCSATid  =
								<cfif isdefined("form.ConceptoSAT")>
                                	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#">
                                <cfelse>0</cfif>
						where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
				</cfif>
				<!--- SI EL DETALLE NO TIENE EL CHK DE 'ES PROVISION' ENTONCES SE TIENE QUE VERIFICAR SI EXISTEN
					EXCEPCIONES DE CONCEPTOS DE PAGO, SI LOS HAY, SE TIENEN QUE ELIMINAR--->
				<cfif not isDefined("Form.DCprovision")>
					<cfquery name="rsVerifProv" datasource="#session.DSN#">
						select 1
						from DCTDeduccionExcluir
						where DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#">
					</cfquery>

					<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
						<cfinvokeargument  name="nombreTabla" value="DCTDeduccionExcluir">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="DClinea = #Form.DClinea#">
						<cfinvokeargument name="necesitaTransaccion" value="false">
					</cfinvoke>

					<cfif rsVerifProv.RecordCount>
						<cfquery name="deleteExcep" datasource="#session.DSN#">
							delete from DCTDeduccionExcluir
							where DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#">
						</cfquery>
					</cfif>
				</cfif>
				<cfquery name="udpDCargas" datasource="#Session.DSN#" >
					update DCargas set
						SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
						DCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#replace(trim(Form.DCcodigo),' ','_','all')#">,
						DCmetodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DCmetodo#">,
						DCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DCdescripcion#">,
						DCvaloremp = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCvaloremp#">,
						DCvalorpat = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCvalorpat#">,
						DCprovision = <cfif isDefined("Form.DCprovision")>1<cfelse>0</cfif>,
						DCnorenta =  <cfif isDefined("Form.DCnorenta")>1<cfelse>0</cfif>,
						DCtipo = <cfqueryparam cfsqltype="cf_sql_bit" value="#Form.DCtipo#">,
						SNreferencia = <cfif form.DCtipo eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigoref#"><cfelse>null</cfif>,
						DCcuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DCcuentac#">,
						DCtiporango = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DCtiporango#">,
						<cfif Form.DCtiporango EQ 1>
						DCrangomin = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCrangomin1#">,
						<cfelseif Form.DCtiporango EQ 2>
						DCrangomin = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCrangomin2#">,
						<cfelse>
						DCrangomin = 0.00,
						</cfif>
						<cfif Form.DCtiporango EQ 1>
						DCrangomax = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCrangomax1#">
						<cfelseif Form.DCtiporango EQ 2>
						DCrangomax = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCrangomax2#">
						<cfelse>
						DCrangomax = 0.00
						</cfif>
						<cfif isDefined("Form.DCSumarizarLiq")>
						  ,DCSumarizarLiq = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						  ,DCSumarizarLiq = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>
						<cfif isDefined("Form.DCMostrarLiq")>
						  ,DCMostrarLiq = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						  ,DCMostrarLiq = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>
						,DCclave =
						<cfif isdefined('form.DCclave') and LEN(TRIM(form.DCclave))>
						  <cfqueryparam cfsqltype="cf_sql_char" value="#form.DCclave#">
						<cfelse>
							null
						</cfif>
						,DCcodigoext =
						<cfif isdefined('form.DCcodigoext') and LEN(TRIM(form.DCcodigoext))>
						  <cfqueryparam cfsqltype="cf_sql_char" value="#form.DCcodigoext#">
						<cfelse>
						  null
						</cfif>
						<cfif isdefined('form.DCcalcInteres') and LEN(TRIM(form.DCcalcInteres))
							and isdefined('form.DCporcInteres') and LEN(TRIM(form.DCporcInteres))>
							,DCcalcInteres=1,DCporcInteres=<cfqueryparam cfsqltype="cf_sql_float" value="#form.DCporcInteres#">
						<cfelse>
							,DCcalcInteres=0,DCporcInteres=null
						</cfif>
						<cfif isDefined("Form.DCaplica")>
						  ,DCaplica = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DCaplica#">
						<cfelse>
						  ,DCaplica = 0
						</cfif>

						<cfif isDefined("Form.DCdisminuyeSBC") >
						  ,DCvsmg = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DCvsmg#">
						<cfelse>
						  ,DCvsmg = 0
						</cfif>
						<cfif isDefined("Form.DCdisminuyeSBC")>
						  ,DCdisminuyeSBC = 1
						<cfelse>
						  ,DCdisminuyeSBC = 0
						</cfif>
						<cfif isDefined("Form.DCdbc")>
							,DCdbc = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DCdbc#">
						<cfelse>
							,DCdbc = 1
						</cfif>
						<cfif isDefined("Form.DCusaSMGA")>
						  ,DCusaSMGA = 1
					    <cfelse>
						  ,DCusaSMGA = 0
					    </cfif>
						<cfif isDefined("Form.DCnomostrar")>
						  ,DCnomostrar = 1
					    <cfelse>
						  ,DCnomostrar = 0
					    </cfif>
					      ,DCUsaUMA = #isDefined("Form.DCUsaUMA") ? 1 : 0#
						  ,DCEsExcedente = #isDefined("Form.DCEsExcedente") ? 1 : 0#


					where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#">
				</cfquery>
				<cfset modo="CAMBIO">
				<cfset modoDet="CAMBIO">
			</cfif>

</cftransaction>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">

	<cfif isdefined("insECargas")>
	   	<input name="ECid" type="hidden" value="<cfif isdefined("insECargas.identity")>#insECargas.identity#</cfif>">
	<cfelse>
	   	<input name="ECid" type="hidden" value="<cfif isdefined("Form.ECid") and not isDefined("Form.BorrarE")>#Form.ECid#</cfif>">
	</cfif>


	<cfif modoDet neq 'ALTA'>
   		<input name="DClinea" type="hidden" value="<cfif isdefined("Form.DClinea")>#Form.DClinea#</cfif>">
	</cfif>

	<cfif isdefined("Form.Aplicar")>
   		<input name="Aplicar" type="hidden" value="<cfif isdefined("Form.Aplicar")>#Form.Aplicar#</cfif>">
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


