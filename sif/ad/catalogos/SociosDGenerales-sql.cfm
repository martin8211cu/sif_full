<!---
	Modificado por Gustavo Fonseca Hernández
		Fecha: 28-6-2005.
		Motivo: Se agrega el campo SNDcodigo en la tabla SNDirecciones.
	Modificado por Gustavo Fonseca Hernández
		Fecha: 6-7-2005.
		Motivo: Se agregan los campos SNnombre y SNcodigoext en la tabla SNDirecciones.
	Modificado por Gustavo Fonseca Hernández
		Fecha: 9-8-2005.
		Motivo: Se guarda el SNcodigoext y se concatena al SNcodigoext y al SNDcodigo en la tabla SNDirecciones '-1'.

 --->

<!--- Valida que identificacion de Socio de negocios no se repita --->



<!-- Querys AFGM-SPR CONTROL DE VERSIONES-->
<cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
select Pvalor 
from Parametros
where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and Pcodigo = '17200'
</cfquery>

<cfset value = "#rsPCodigoOBJImp.Pvalor#">
<!-- Fin Querys AFGM-SPR -->


<cffunction access="public" name="validaIdentificacion" output="true">
	<cfargument name="empresa" type="string" required="yes" default="" >
	<cfargument name="identificacion" type="string" required="no" default="" >
	<cfargument name="identificacion2" type="string" required="no" default="" >

	<cfif len(trim(arguments.empresa)) and len(trim(arguments.identificacion))>
		<cfquery name="rsIdentificacion" datasource="#session.DSN#">
			select count(1) as cantidad
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.identificacion#">
			and SNidentificacion2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.identificacion2#">
		</cfquery>
		<cfif rsIdentificacion.cantidad gt 0>
			<cfset request.Error.Backs = 1 >
			 <cfif session.Ecodigo neq arguments.empresa>
				<cf_errorCode	code = "50007"
								msg  = "La identificación @errorDat_1@ digitada, esta asignada a otro Socio de Negocios para la empresa corporativa."
								errorDat_1="#identificacion#"
				>
			<cfelse>
				<cf_errorCode	code = "50008"
								msg  = "La identificación @errorDat_1@ digitada, esta asignada a otro Socio de Negocios."
								errorDat_1="#identificacion#"
				>
			</cfif>
		</cfif>
	</cfif>
</cffunction>

<cfinclude template="SociosModalidad.cfm">

<cfparam name="form.SNinactivo" default="0">

<cfif Len(form.SNcodigoPadre)>
	<cfquery datasource="#session.dsn#" name="idPadre">
		select SNid
		from SNegocios
		where Ecodigo =  #Session.Ecodigo#
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoPadre#">
	</cfquery>
	<cfset form.SNidPadre=idPadre.SNid>
<cfelse>
	<cfset form.SNidPadre=''>
</cfif>


<cffunction name="altaClienteDetCorp">
	<cfargument name="Ecodigo" required="yes">
	<cfargument name="SNidentificacion" required="yes">
	<cfargument name="SNtipo" required="yes">
	<cfargument name="SNnombre" required="yes">
	<cfargument name="direccion1" required="no" default="~">
	<cfargument name="direccion2" required="no" default="~">
	<cfargument name="pais" required="no" default="~">
	<cfargument name="SNtelefono" required="no" default="~">
	<cfargument name="SNFax" required="no" default="~">
	<cfargument name="SNemail" required="no" default="~">
	<cfargument name="LOCidioma" required="no" default="~">
	<cfargument name="SNFecha" required="yes">
	<cfargument name="Usucodigo" required="yes">
	<cfargument name="SNcodigo" required="yes">

	<cfquery name="rsCliente" datasource="#session.DSN#">
		select 1
		from ClientesDetallistasCorp
		where CEcodigo = #Session.CEcodigo#
		  and CDCidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SNidentificacion#">
	</cfquery>

	<!--- Si no existe el cliente corporativo lo inserta --->
	<cfif isdefined('rsCliente') and rsCliente.recordCount EQ 0>
		<cfset cadenaDirec = ''>
		<cfif Arguments.direccion1 NEQ '~'>
			<cfset cadenaDirec = Arguments.direccion1>
		</cfif>
		<cfif Arguments.direccion2 NEQ '~'>
			<cfset cadenaDirec = cadenaDirec & '. ' & Arguments.direccion2>
		</cfif>

		<cftransaction>
			<cfquery name="rsNewCliente" datasource="#session.DSN#">
				insert INTO ClientesDetallistasCorp
					(CEcodigo, CDCidentificacion, CDCtipo, CDCnombre, CDCdireccion, Ppais, CDCfechaNac, CDCtelefono
						, CDCFax, CDCporcdesc, CDCExentoImp, CDCemail, LOCidioma, CDCfecha, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SNidentificacion#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SNtipo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SNnombre#">
					<cfif cadenaDirec NEQ ''>
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#cadenaDirec#">
					<cfelse>
						, null
					</cfif>
					<cfif Arguments.pais NEQ '~'>
						, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.pais#">
					<cfelse>
						, null
					</cfif>
					, null
					<cfif Arguments.SNtelefono NEQ '~'>
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SNtelefono#">
					<cfelse>
						, null
					</cfif>
					<cfif Arguments.SNFax NEQ '~'>
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SNFax#">
					<cfelse>
						, null
					</cfif>
					, 0
					, 0
					<cfif Arguments.SNemail NEQ '~'>
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SNemail#">
					<cfelse>
						, null
					</cfif>
					<cfif Arguments.LOCidioma NEQ '~'>
						, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LOCidioma#">
					<cfelse>
						, null
					</cfif>
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.SNFecha)#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">)

					<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsNewCliente">

			<cfquery name="rsNewCliente" datasource="#session.DSN#">
				insert into FACSnegocios
					(Ecodigo, CDCcodigo, SNcodigo, CDCactivo, CDCDefault, fechaalta, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNewCliente.identity#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
					, 1
					, 1
					, <cf_dbfunction name="now">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">)
			</cfquery>
		</cftransaction>
	</cfif>
</cffunction>

<cffunction name="nextSNcodigo" returntype="numeric">
	<cfargument name="Ecodigo" required="yes">
	<cfquery name="rsNextSNcodigo" datasource="#session.DSN#">
		select coalesce(max(SNcodigo),0)+1 as SNcodigo
		from SNegocios
		where Ecodigo = <cfqueryparam value="#Arguments.Ecodigo#" cfsqltype="cf_sql_integer">
		  and SNcodigo <> 9999
	</cfquery>
	<cfif rsNextSNcodigo.SNcodigo EQ 9999>
		<cfreturn rsNextSNcodigo.SNcodigo + 1>
	<cfelse>
		<cfreturn rsNextSNcodigo.SNcodigo>
	</cfif>
</cffunction>

<cffunction name="minESNid" returntype="numeric">
	<cfargument name="Ecodigo" required="yes">

	<cfquery name="minESNid" datasource="#session.dsn#">
		select min(ESNid) as ESNid
		from EstadoSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
	</cfquery>
	<cfif Len(minESNid.ESNid) EQ 0>
		<cf_errorCode	code = "50009" msg = "No se han definido los estados para socios de negocios">
	</cfif>
	<cfreturn minESNid.ESNid>
</cffunction>

<cffunction name="crear9999">
	<cfargument name="Ecodigo" required="yes">

	<cftransaction>
	<!--- Busca si existe algun registro en la tabla SNegocios --->
	<cfquery name="rsExisteSNegocios" datasource="#session.DSN#">
		select count(1) as Cantidad from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and SNcodigo = 9999
	</cfquery>

	<!--- Si el registro no existe hace el insert en la tabla SNegocios--->
	<cfif rsExisteSNegocios.Cantidad EQ 0>
		<cfquery name="Mcodigo" datasource="#session.dsn#">
			select Mcodigo
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfquery name="insertSNegocios" datasource="#session.DSN#">
			insert into SNegocios (Ecodigo, SNcodigo, SNidentificacion, SNtiposocio, SNnombre,
				SNFecha, SNtipo, SNnumero, ESNid,Mcodigo, EcodigoInclusion,BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
						9999,
						'9999',
						'C',
						'Socio de Negocios Genrico',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						'F',
						'999-9999',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#minESNid(Arguments.Ecodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo.Mcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
		</cfquery>
	</cfif>
	</cftransaction>

</cffunction>
<cfif not isdefined("Form.Nuevo")>

	<cfset crear9999(session.Ecodigo)>

	<cfif isdefined("Form.ALTA")>
		<cfif not modalidad.nuevo>
			<cf_errorCode	code = "50010" msg = "La configuracin actual no le permite definir socios de negocio locales">
		</cfif>

		<cf_sifdireccion action="readform" name="la_direccion">
		<cf_sifdireccion action="insert" name="la_direccion" data="#la_direccion#">
		<cftransaction>
			<cfparam name="form.ALTA_CORPORATIVO" default="0">

			<!--- generando consecutivo SNcodigoext MSEG--->
			<cfquery name="rsNextSNcodigoext" datasource="#session.DSN#">
				select coalesce(max(cast(cast(SNcodigoext as integer) as numeric)),0)+1 as SNcodigoext
				from SNegocios
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and SNcodigo <> 9999
			</cfquery>
			<cfset  Form.SNcodigoext = rsNextSNcodigoext.SNcodigoext>
			<cfif not isdefined("Form.SNidentificacion2") or Form.SNidentificacion2 EQ "">
				<cfset Form.SNidentificacion2 = Form.SNcodigoext>
			</cfif>
			<cfif not modalidad.altalocal>
				<cfset form.ALTA_CORPORATIVO = 1>
            </cfif>

            <!---►►Crea el Socio de Negocios en la Corporacion--->
			<cfif modalidad.replicar and form.ALTA_CORPORATIVO and session.EcodigoCorp NEQ session.Ecodigo>
				<cfset form.SNcodigoCorp = nextSNcodigo(session.EcodigoCorp)>

				<!---►►Moneda Local de la empresa--->
				<cfquery name="Mcodigo" datasource="#session.dsn#">
					select Mcodigo
					from Empresas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoCorp#">
				</cfquery>

            	<!---►►Valida que el Socio no exista ya en la empresa--->
				<cfset validaIdentificacion(session.EcodigoCorp, Form.SNidentificacion, Form.SNidentificacion2) >

				<!---►Inserta el Socio de Negocios--->
				<cfquery name="insertCorp" datasource="#session.DSN#">
					insert into SNegocios (Ecodigo, SNcodigo, SNidentificacion, SNidentificacion2,  SNnombre, SNcodigoext, Mcodigo,
										   SNdireccion, id_direccion, ESNid,
										   SNtelefono, SNFax, SNemail, SNFecha, SNtipo,
										   SNinactivo, usaINE, SNactivoportal, SNnumero,
										   Ppais, SNcertificado, LOCidioma, SNidPadre,
										   SNesCorporativo, SNinclusionAutoriz, EcodigoInclusion,esIntercompany,Intercompany,
										   SNtiposocio, SNMid, intfazLD, sincIntfaz,IdFisc,Nacional,Contrato,BMUsucodigo,IdRegimenFiscal,SNnombreFiscal
										   )
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoCorp#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigoCorp#">,
								<cfqueryparam cfsqltype="cf_sql_char" 	 value="#Form.SNidentificacion#">,
								<cfqueryparam cfsqltype="cf_sql_char" 	 value="#Form.SNidentificacion2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">,
								<cfif isdefined("Form.SNcodigoext") and len(trim(Form.SNcodigoext))>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNcodigoext#">,
								<cfelse>
									null,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo.Mcodigo#">,

								<cfqueryparam cfsqltype="cf_sql_varchar" value="#la_direccion.completaCorta#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#minESNid(session.EcodigoCorp)#">,

								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#LSParseDateTime(form.SNFecha)#">,
								<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.SNtipo#">,

								<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNinactivo#">,
								1,
								<cfif isdefined("form.usaINE") >
									,usaINE= 1
								<cfelse>
									,usaINE= 0
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnumero#">,

								<cfif len(trim(la_direccion.Pais))><cfqueryparam cfsqltype="cf_sql_char" value="#la_direccion.Pais#"><cfelse>null</cfif>,
								<cfif isdefined ("form.SNcertificado")>1<cfelse>0</cfif>,
								<cfqueryparam cfsqltype="cf_sql_char" value="#Form.LOCidioma#" null="#Len(trim(form.LOCidioma)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNidPadre#"  null="#Len(Form.SNidPadre) EQ 0#">,
								1,
								0,  #Session.Ecodigo#
								<cfif isdefined("Form.esIntercompany") and len(trim(Form.esIntercompany))>
									, 1
								<cfelse>
									, 0
								</cfif>
								<cfif isdefined("Form.Intercompany") and len(trim(Form.Intercompany)) and Form.Intercompany NEQ '-1'>
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Intercompany#">
								<cfelse>
									, null
								</cfif>
								<cfif isdefined('session.LvarModulo')>
								   , <cfif session.LvarModulo eq 'CC'>
										'C'
									 <cfelseif session.LvarModulo eq 'CP'>
										'P'
									 <cfelse>
									    'A'
									 </cfif>
								<cfelse>
									,  'A'
								</cfif>
                                <cfif isdefined('form.SNMid')>
                                	,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNMid#" voidnull>
                                <cfelse>
                                	, null
                                </cfif>,0
                                <cfif isdefined('form.sincIntfaz')>
                                	,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.sincIntfaz#"  null="#Len(Form.sincIntfaz) EQ 0#">
                                <cfelse>
                            		,0
                                </cfif>
                                <cfif isdefined('form.IDFis') and trim('form.IDFis') neq ''>
                            	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDFis#">
	                            <cfelse>
	                            	,null
	                            </cfif>
	                            <cfif isdefined('form.Nacion') and trim('form.Nacion') neq ''>
	                            	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nacion#">
	                            <cfelse>
	                            	,null
	                            </cfif>
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Contrato)#">
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
								<cfif isdefined('form.IdRegFiscal') and trim('form.IdRegFiscal') neq ''>
					 				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IdRegFiscal#">
								<cfelse>
									,null
								</cfif>
								<cfif isdefined('form.SNnombreFiscal') and trim('form.SNnombreFiscal') neq ''>
					 				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombreFiscal#">
								<cfelse>
									,null
								</cfif>
						)
						<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insertCorp">
				<!---<cftry><cfcatch type="any">
					****
					<cfabort>
				</cfcatch>
				</cftry>--->

				<cfquery datasource="#session.dsn#">
					insert into SNDirecciones (
						SNid, id_direccion, Ecodigo, SNcodigo, SNDcodigo, SNnombre, SNcodigoext,
						SNDfacturacion, SNDenvio, SNDactivo, SNDlimiteFactura,
						DEid, BMUsucodigo, SNDtelefono, SNDFax, SNDemail,SNDireccionFiscal)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertCorp.identity#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoCorp#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigoCorp#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">,
						<cfif isdefined("form.SNcodigoext") and len(trim(form.SNcodigoext))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNcodigoext#">,
						<cfelse>
							null,
						</cfif>
						1, 1, 1, 0, null, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">,
						<cfif Form.SNDirFiscSATmx eq 'on'>
							<cfqueryparam cfsqltype="cf_sql_bit" value="1">
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_bit" value="0">
						</cfif>
					)
				</cfquery>
			</cfif>

			<cfset Form.SNcodigo = nextSNcodigo(session.Ecodigo)>
			<cfparam name="form.ESNid" default="">
			<cfif Len(form.ESNid) EQ 0>
				<cfset form.ESNid = minESNid(session.Ecodigo)>
            </cfif>
			<cfparam name="insertCorp.identity" default="">
			<cfquery name="Mcodigo" datasource="#session.dsn#">
				select Mcodigo
				from Empresas
				where Ecodigo =  #Session.Ecodigo#
			</cfquery>

			<cfset validaIdentificacion(session.Ecodigo, Form.SNidentificacion, Form.SNidentificacion2) >

			<cfquery name="insert" datasource="#session.DSN#">
				<!--- insertar socio local --->
				insert into SNegocios (Ecodigo, SNcodigo, SNidentificacion, SNidentificacion2,  SNnombre, SNcodigoext, Mcodigo,
									   SNdireccion, id_direccion, ESNid,
									   SNtelefono, SNFax, SNemail, SNFecha, SNtipo,
									   SNinactivo, usaINE, SNactivoportal, SNnumero,
									   Ppais, SNcertificado, LOCidioma, SNidPadre,
									   SNesCorporativo, SNidCorporativo, SNinclusionAutoriz, EcodigoInclusion,esIntercompany,Intercompany,
									   SNtiposocio,SNMid,intfazLD,sincIntfaz,IdFisc,Nacional,SNcontratos, Contrato,BMUsucodigo,IdRegimenFiscal,SNnombreFiscal
									   )
					values ( #Session.Ecodigo# ,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" 	 value="#Form.SNidentificacion#">,
							<cfqueryparam cfsqltype="cf_sql_char" 	 value="#Form.SNidentificacion2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">,
							<cfif isdefined("form.SNcodigoext") and len(trim(form.SNcodigoext))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNcodigoext#">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo.Mcodigo#">,

							<cfqueryparam cfsqltype="cf_sql_varchar" value="#la_direccion.completa#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESNid#">,

							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#LSParseDateTime(form.SNFecha)#">,
							<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.SNtipo#">,

							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNinactivo#">,
							1,
							<cfif isdefined("form.usaINE")>
									1,
								<cfelse>
									0,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnumero#">,

							<cfif len(trim(la_direccion.Pais))><cfqueryparam cfsqltype="cf_sql_char" value="#la_direccion.Pais#"><cfelse>null</cfif>,
							<cfif isdefined ("form.SNcertificado")>1<cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.LOCidioma#" null="#Len(trim(form.LOCidioma)) EQ 0#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNidPadre#"  null="#Len(Form.SNidPadre) EQ 0#">,
              <cfif isdefined("Form.SNesCorporativo") and len(trim(Form.SNesCorporativo))>
							    1,
							<cfelse>
							    0,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNidPadre#"  null="#Len(Form.SNidPadre) EQ 0#">,
							0,  #Session.Ecodigo#
							<cfif isdefined("Form.esIntercompany") and len(trim(Form.esIntercompany))>
								, 1
							<cfelse>
								, 0
							</cfif>
							<cfif isdefined("Form.Intercompany") and len(trim(Form.Intercompany)) and Form.Intercompany NEQ '-1'>
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Intercompany#">
							<cfelse>
								, null
							</cfif>
							<cfif isdefined('session.LvarModulo')>
							   , <cfif session.LvarModulo eq 'CC'>
									'C'
								 <cfelseif session.LvarModulo eq 'CP'>
									'P'
								 <cfelse>
									'C'
								 </cfif>
							<cfelse>
								,	'A'
							</cfif>
                            <cfif isdefined('form.SNMid')>
                                ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNMid#" voidnull>
                            <cfelse>
                                ,null
                            </cfif>,0
                            <cfif isdefined('form.sincIntfaz')>
                                	,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.sincIntfaz#"  null="#Len(Form.sincIntfaz) EQ 0#">
                            <cfelse>
                            		,0
                            </cfif>
                            <cfif isdefined('form.IDFis') and trim('form.IDFis') neq ''>
                            	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDFis#">
                            <cfelse>
                            	,null
                            </cfif>
                            <cfif isdefined('form.Nacion') and trim('form.Nacion') neq ''>
                            	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nacion#">
                            <cfelse>
                            	,null
                            </cfif>
							<cfif isdefined('form.SNcontratos')>
								,1
							<cfelse>
								,0
							</cfif>
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Contrato)#">
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							<cfif isdefined('form.IdRegFiscal') and trim('form.IdRegFiscal') neq ''>
					 				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IdRegFiscal#">
							<cfelse>
									,null
							</cfif>
							<cfif isdefined('form.SNnombreFiscal') and trim('form.SNnombreFiscal') neq ''>
					 				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombreFiscal#">
								<cfelse>
									,null
							</cfif>

					)
					<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">

			<cfquery datasource="#session.dsn#">
				insert into SNDirecciones (
					SNid, id_direccion, Ecodigo, SNcodigo, SNDcodigo, SNnombre, SNcodigoext,
					SNDfacturacion, SNDenvio, SNDactivo, SNDlimiteFactura,
					DEid, BMUsucodigo, SNDtelefono, SNDFax, SNDemail, SNDireccionFiscal)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,
					 #Session.Ecodigo# ,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">,
					<cfif isdefined("form.SNcodigoext") and len(trim(form.SNcodigoext))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNcodigoext#">,
					<cfelse>
						null,
					</cfif>
					1, 1, 1, 0, null, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">,
					<cfif isdefined("Form.SNDirFiscSATmx")>
						<cfif Form.SNDirFiscSATmx eq 'on'>
							<cfqueryparam cfsqltype="cf_sql_bit" value="1">
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_bit" value="0">
						</cfif>
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_bit" value="0">
					</cfif>
				)
			</cfquery>
			<cfset modo="CAMBIO">
		</cftransaction>

		<!--- Insercion del socio de negocios en la tabla ClientesDetallistasCorp --->
		<cfset altaClienteDetCorp(
					session.Ecodigo
					, Form.SNidentificacion
					, Form.SNtipo
					, Form.SNnombre
					, la_direccion.direccion1
					, la_direccion.direccion2
					, la_direccion.pais
					, Form.SNtelefono
					, Form.SNFax
					, Form.SNemail
					, Form.LOCidioma
					, form.SNFecha
					, session.Usucodigo
					, Form.SNcodigo)>

	<!--- INICIA - Invocación del WS de sincronización de clientes POR EL MOMENTO NO APLICA: INDICACION DE JMARQUEZ (24-01-2018)--->
	<!--- <cflock scope="Application" timeout="5400">
		<cfinvoke component="ModuloIntegracion.Componentes.WSClienteProveedor" method="EjecutaWS" SIScodigo="LD"/>
	</cflock> --->
	<!--- TERMINA - Invocación del WS de sincronización de clientes --->
	<cfelseif isdefined("Form.Baja")>
		<!--- BORRAR DEMAS TABLAS
			no importa la configuracion del catalogo, de todos modos se borrara.
			La nica excepcin podra ser si es un socio corporativo que est siendo importado en otra
			empresa, habra que validar y borrar sus "hijos"
		--->

		<!---  Verifica que no hayan documentos del socio que se quiere dar de baja.--->
			<cfset LvarValida = 0>
			<cfquery name="rsBaja" datasource="#session.DSN#">
				select SNid
				from SNegocios
				where Ecodigo =  #Session.Ecodigo#
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			</cfquery>

			<cfquery name="rsValida1" datasource="#Session.DSN#">
				select count(1) as registro
				from SNSaldosIniciales
				where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBaja.SNid#">
			</cfquery>
			<cfif isdefined("rsValida1") and rsValida1.registro gt 0>
				<cfset LvarValida = 1>
			</cfif>

			<cfquery name="rsValida2" datasource="#Session.DSN#">
				select count(1) as registro
				from HDocumentos
				where Ecodigo =  #Session.Ecodigo#
 				 and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
			<cfif isdefined("rsValida2") and rsValida2.registro gt 0>
				<cfset LvarValida = 1>
			</cfif>

			<cfquery name="rsValida3" datasource="#Session.DSN#">
				select count(1) as registro
				from Documentos
				where Ecodigo =  #Session.Ecodigo#
 				 and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
			<cfif isdefined("rsValida3") and rsValida3.registro gt 0>
				<cfset LvarValida = 1>
			</cfif>

			<cfquery name="rsValida4" datasource="#Session.DSN#">
				select count(1) as registro
				from EDocumentosCxC
				where Ecodigo =  #Session.Ecodigo#
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
			<cfif isdefined("rsValida4") and rsValida4.registro gt 0>
				<cfset LvarValida = 1>
			</cfif>

			<cfquery name="rsValida5" datasource="#Session.DSN#">
				select count(1) as registro
				from FAX001
				where Ecodigo =  #Session.Ecodigo#
 				 and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
			<cfif isdefined("rsValida5") and rsValida5.registro gt 0>
				<cfset LvarValida = 1>
			</cfif>
			<cfquery name="rsValida6" datasource="#Session.DSN#">
				select count(1) as registro
				from HEDocumentosCP
				where Ecodigo =  #Session.Ecodigo#
 				 and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
			<cfif isdefined("rsValida6") and rsValida6.registro gt 0>
				<cfset LvarValida = 1>
			</cfif>
			<cfquery name="rsValida7" datasource="#Session.DSN#">
				select count(1) as registro
				from EDocumentosCP
				where Ecodigo =  #Session.Ecodigo#
 				 and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
			<cfif isdefined("rsValida7") and rsValida7.registro gt 0>
				<cfset LvarValida = 1>
			</cfif>
			<cfquery name="rsValida8" datasource="#Session.DSN#">
				select count(1) as registro
				from EDocumentosCxP
				where Ecodigo =  #Session.Ecodigo#
 				 and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
			<cfif isdefined("rsValida8") and rsValida8.registro gt 0>
				<cfset LvarValida = 1>
			</cfif>
			<cfif LvarValida eq 1>
				<cf_errorCode	code = "50011" msg = "El Socio de Negocios que intenta eliminar posee al menos un documento en el sistema. PROCESO CANCELADO">
				<cfabort>
			<cfelseif LvarValida eq 0>
				<cftransaction>
					<cfquery datasource="#Session.DSN#">
						delete from SNDirecciones
						where Ecodigo =  #Session.Ecodigo#
						 and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery datasource="#Session.DSN#">
						delete from SNegociosObjetos
						where Ecodigo =  #Session.Ecodigo#
						 and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery datasource="#Session.DSN#">
						delete from SNAnotaciones
						where Ecodigo =  #Session.Ecodigo#
						 and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery datasource="#Session.DSN#">
						delete from SNContactos
						where Ecodigo =  #Session.Ecodigo#
							and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery datasource="#Session.DSN#">
						delete from FACSnegocios
						where Ecodigo =  #Session.Ecodigo#
							and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery datasource="#Session.DSN#">
						delete from SNegocios
						where Ecodigo =  #Session.Ecodigo#
							and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset modo="ALTA">
				</cftransaction>
				<cflocation url="listaSocios.cfm">
			</cfif>
	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#session.dsn#" name="datos_actuales">
			select id_direccion, SNid, SNidCorporativo from SNegocios
			where Ecodigo =  #Session.Ecodigo#
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		</cfquery>
		<cf_sifdireccion action="readform" name="la_direccion">
		<cfset la_direccion.id_direccion = datos_actuales.id_direccion>
		<cf_sifdireccion action="update" key="#datos_actuales.id_direccion#" name="la_direccion" data="#la_direccion#">
		<cftransaction>
			<cf_dbtimestamp datasource="#session.dsn#"
				table="SNegocios"
				redirect="Socios.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo"
				type1="integer"
				value1="#session.Ecodigo#"
				field2="SNcodigo"
				type2="integer"
				value2="#form.SNcodigo#">

			<cfif isdefined("form.SNidentificacion") and isdefined("form.SNidentificacion_BD") and trim(form.SNidentificacion) neq trim(form.SNidentificacion_BD)>
				<cfset validaIdentificacion(Session.Ecodigo, Form.SNidentificacion, Form.SNidentificacion2) >
			</cfif>

			<cfquery name="update" datasource="#Session.DSN#">
				update SNegocios
				set GSNid            =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GSNid#" null="#len(trim(form.GSNid)) EQ 0#">,
					<cfif isdefined("form.SNesCorporativo")>
					    SNidPadre = null,
					<cfelse>
					    SNidPadre        =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNidPadre#" null="#Len(Form.SNidPadre) EQ 0#">,
					</cfif>
					SNidentificacion = 	<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNidentificacion#">,
					SNidentificacion2 = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNidentificacion2#">
					<cfif not modalidad.readonly>,
						SNnombre 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">,
						SNcodigoext    	 =
						<cfif isdefined("form.SNcodigoext") and len(trim(form.SNcodigoext))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNcodigoext#">,
						<cfelse>
							null,
						</cfif>
						SNdireccion 	 = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#la_direccion.completa#">,
						id_direccion 	 = 	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#la_direccion.id_direccion#">,
						SNtelefono 	     = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.SNtelefono#">,
						SNFax 			 = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.SNFax#">,
						SNemail 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.SNemail#">,
						SNFecha 		 = 	<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.SNFecha)#">,
						SNtipo 		     = 	<cfqueryparam cfsqltype="cf_sql_char"    	value="#Form.SNtipo#">,
						SNinactivo 	  	 = 	<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.SNinactivo#">,
						SNnumero 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.SNnumero#">,
						SNactivoportal   = 	<cfif isdefined("form.SNactivoportal")>1<cfelse>0</cfif>,
						SNcertificado 	 = 	<cfif isdefined ("form.SNcertificado")>1<cfelse>0</cfif>,
						Ppais 			 =	<cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#la_direccion.Pais#" voidnull>,
						LOCidioma 		 =  <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Form.LOCidioma#"    voidnull>,
						ESNid 			 =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Form.ESNid#" 		voidnull>
						<cfif isdefined("Form.esIntercompany") and len(trim(Form.esIntercompany))>
							, esIntercompany = 1
							, Intercompany = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Intercompany#">
						<cfelse>
							, esIntercompany = 0
							, Intercompany = null
						</cfif>
					</cfif>
                      ,SNMid 			=  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNMid#" voidnull>
                     , intfazLD = 2
                     <cfif isdefined("Form.sincIntfaz") and len(trim(Form.sincIntfaz))>
                          ,sincIntfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.sincIntfaz#"  >
                     <cfelse>
                          ,sincIntfaz = 0
                     </cfif>
					<cfif isdefined("form.usaINE")>
						,usaINE= 1
					<cfelse>
						,usaINE= 0
					</cfif>
					<cfif isdefined("form.SNesCorporativo")>
						,SNesCorporativo = 1
						,SNidCorporativo = null
					<cfelse>
						,SNesCorporativo = 0
						,SNidCorporativo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNidPadre#" null="#Len(Form.SNidPadre) EQ 0#">
					</cfif>
					 <cfif isdefined('form.IDFis') and trim('form.IDFis') neq ''>
                        ,IdFisc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDFis#">
                     </cfif>

                     <cfif isdefined('form.Nacion') and trim('form.Nacion') neq ''>
                    	,Nacional = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nacion#">
                     </cfif>
					 , Contrato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Contrato)#">
					 ,BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					 <cfif isdefined('form.IdRegFiscal') and trim('form.IdRegFiscal') neq '' and rsPCodigoOBJImp.Pvalor eq "4.0">
					 ,IdRegimenFiscal =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IdRegFiscal#">
					 </cfif>
					  <cfif isdefined('form.SNnombreFiscal') and trim('form.SNnombreFiscal') neq '' and rsPCodigoOBJImp.Pvalor eq "4.0">
					 ,SNnombreFiscal =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombreFiscal#">
					 </cfif>
				where Ecodigo =  #Session.Ecodigo#
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>

			<cfquery datasource="#session.DSN#">
				update SNDirecciones
					set
						SNnombre 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">,
						<cfif isdefined("form.SNcodigoext") and len(trim(form.SNcodigoext))>
							SNcodigoext    	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNcodigoext#">,
						</cfif>
						SNDcodigo 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnumero#">,
						SNDtelefono 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#">,
						SNDFax 			 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">,
						SNDemail 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">,
						<cfif isdefined("Form.SNDirFiscSATmx")>
							<cfif Form.SNDirFiscSATmx eq 'on'>
								SNDireccionFiscal= <cfqueryparam cfsqltype="cf_sql_bit" value="1">
							<cfelse>
								SNDireccionFiscal= <cfqueryparam cfsqltype="cf_sql_bit" value="0">
							</cfif>
						<cfelse>
							SNDireccionFiscal= <cfqueryparam cfsqltype="cf_sql_bit" value="0">
						</cfif>
				where Ecodigo =  #Session.Ecodigo#
				  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">
			</cfquery>
			<cftransaction action="commit">
				<!--- JARR Agosto 2020 se comento esta parte ya que al hacer el update de un Socio Corporativo
						modificaba a todos los SN relacionados --->
						
			<!--- cambio siempre  
			<cfif (Not modalidad.readonly)>
				<!--- update al corporativo, o a las copias de este corporativo --->
				<cfquery name="update" datasource="#Session.DSN#">
					update SNegocios set
						SNnombre 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">,
						SNcodigoext    	 =
						<cfif isdefined("form.SNcodigoext") and len(trim(form.SNcodigoext))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNcodigoext#">,
						<cfelse>
							null,
						</cfif>
						SNdireccion 	 = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	 value="#la_direccion.completa#">,
						id_direccion 	 = 	<cfqueryparam cfsqltype="cf_sql_numeric" 	 value="#la_direccion.id_direccion#">,
						SNtelefono 	     = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	 value="#Form.SNtelefono#">,
						SNFax 			 = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	 value="#Form.SNFax#">,
						SNemail 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	 value="#Form.SNemail#">,
						SNFecha 		 = 	<cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#LSParseDateTime(form.SNFecha)#">,
						SNtipo 		     = 	<cfqueryparam cfsqltype="cf_sql_char"    	 value="#Form.SNtipo#">,
						SNinactivo 	  	 = 	<cfqueryparam cfsqltype="cf_sql_integer" 	 value="#Form.SNinactivo#">,
						SNnumero 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	 value="#Form.SNnumero#">,
						SNactivoportal   = 	<cfif isdefined("form.SNactivoportal")>1<cfelse>0</cfif>,
						SNcertificado 	 = 	<cfif isdefined ("form.SNcertificado")>1<cfelse>0</cfif>,
						Ppais            =	<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#la_direccion.Pais#" voidnull>,
						LOCidioma        =  <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.LOCidioma#"    voidnull>
						<cfif isdefined("Form.esIntercompany") and len(trim(Form.esIntercompany))>
							, esIntercompany = 1
							, Intercompany   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Intercompany#">
						<cfelse>
							, esIntercompany = 0
							, Intercompany   = null
						</cfif>
                         , SNMid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNMid#" voidnull>
                         ,intfazLD = 2
                        <cfif isdefined("Form.sincIntfaz") and len(trim(Form.sincIntfaz))>
                          ,sincIntfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.sincIntfaz#"  >
                        <cfelse>
                          ,sincIntfaz = 0
                        </cfif>
						<cfif isdefined("form.usaINE") >
							,usaINE= 1
						<cfelse>
							,usaINE= 0
                        </cfif>
                        <cfif isdefined('form.IDFis') and trim('form.IDFis') neq ''>
                         ,IdFisc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDFis#">
                     	</cfif>
                     	<cfif isdefined('form.Nacion') and trim('form.Nacion') neq ''>
                    	 ,Nacional = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nacion#">
                     	</cfif>
						 , Contrato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Contrato)#">
					where SNidCorporativo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_actuales.SNid#">
					<cfif Len(datos_actuales.SNidCorporativo)>
					   or SNid 			  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_actuales.SNidCorporativo#">
					   or SNidCorporativo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_actuales.SNidCorporativo#">
					</cfif>
				</cfquery>
				
			</cfif>--->
		</cftransaction>

			<!--- INICIA - Invocación del WS de sincronización de clientes POR EL MOMENTO NO APLICA: INDICACION DE JMARQUEZ (24-01-2018) --->
			<!--- <cflock scope="Application" timeout="5400">
				<cfinvoke component="ModuloIntegracion.Componentes.WSClienteProveedor" method="EjecutaWS" SIScodigo="LD"/>
			</cflock> --->
			<!--- TERMINA - Invocación del WS de sincronización de clientes --->
		<cfset modo="CAMBIO">
	</cfif><!--- isdefined("Form.ALTA") isdefined("Form.Baja") isdefined("Form.Cambio") --->
</cfif><!--- not isdefined("Nuevo") --->

<cflocation url="Socios.cfm?SNcodigo=#form.SNcodigo#">


