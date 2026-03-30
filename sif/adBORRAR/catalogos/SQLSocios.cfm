<!--- como es un checkbox, me aseguro de que venga --->
<cfparam name="form.SNinactivo" default="0">

<cfif isdefined("Form.DGenerales")>
	<cfif not isdefined("Form.Nuevo")>
		<cftransaction>
		<!--- Busca si existe algun registro en la tabla SNegocios --->
		<cfquery name="rsExisteSNegocios" datasource="#session.DSN#">
			select count(1) as Cantidad from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and SNcodigo = 9999
		</cfquery>
		<cfquery name="minESNid" datasource="#session.dsn#">
			select min(ESNid) as ESNid
			from EstadoSNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif Len(minESNid.ESNid) EQ 0>
			<cf_errorCode	code = "50009" msg = "No se han definido los estados para socios de negocios">
		</cfif>
		
		<!--- Si el registro no existe hace el insert en la tabla SNegocios--->	
		<cfif rsExisteSNegocios.Cantidad EQ 0>
			<!--- para que no de error --->
			<cfparam name="form.SNcodigoext" default="">
			<cfif Len(form.SNcodigoext) EQ 0>
				<cfset form.SNcodigoext = ' '>
			</cfif>
			<cfquery name="Mcodigo" datasource="#session.dsn#">
				select Mcodigo
				from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="insertSNegocios" datasource="#session.DSN#">
				insert into SNegocios (Ecodigo, SNcodigo, SNidentificacion, SNtiposocio, SNnombre, SNFecha, SNtipo, SNnumero, SNcodigoext, ESNid,Mcodigo)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							9999,
							' ',         
							'A', 
							'Socio de Negocios Genérico', 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,    
							'F', 
							'999-9999',
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNcodigoext#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#minESNid.ESNid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo.Mcodigo#">
					)
			</cfquery>
		</cfif>
		</cftransaction>
		
		<cfif isdefined("Form.ALTA")>
							
			<cf_sifdireccion action="readform" name="la_direccion">
			<cf_sifdireccion action="insert" name="la_direccion" data="#la_direccion#">
			<cftransaction>
				<cfquery name="rsConsecutivo" datasource="#session.DSN#">
					select coalesce(max(SNcodigo),0)+1 as SNcodigo
					from SNegocios 
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
						and SNcodigo <> 9999
				</cfquery>
				
				<cfset Form.SNcodigo = 0>
				<cfif rsConsecutivo.SNcodigo EQ 9999>
					<cfset Form.SNcodigo = rsConsecutivo.SNcodigo + 1>
				<cfelse>
					<cfset Form.SNcodigo = rsConsecutivo.SNcodigo>
				</cfif>
				<cfparam name="form.ESNid" default="#minESNid.ESNid#">
			
				<cfquery name="insert" datasource="#session.DSN#">     
					insert into SNegocios (Ecodigo, SNcodigo, SNidentificacion,SNidentificacion2,  SNnombre, SNtiposocio,Mcodigo,
										   SNdireccion, id_direccion, CSNid, GSNid, ESNid, 
										   SNtelefono, SNFax, SNemail, SNFecha, SNtipo, 
										   SNinactivo, SNactivoportal, SNnumero, 
										   Ppais, SNcertificado, LOCidioma, SNcodigoext)
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" 	 value="#Form.SNidentificacion#">,
								<cfqueryparam cfsqltype="cf_sql_char" 	 value="#Form.SNidentificacion2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">,
								'P',
								 1,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#la_direccion.completa#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSNid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GSNid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESNid#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#LSParseDateTime(form.SNFecha)#">,
								<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.SNtipo#">, 
								<cfif isdefined("form.SNinactivo")><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNinactivo#"><cfelse>0</cfif>,
								1,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnumero#">,
								<cfif len(trim(la_direccion.Pais))><cfqueryparam cfsqltype="cf_sql_char" value="#la_direccion.Pais#"><cfelse>null</cfif>,
								<cfif isdefined ("form.SNcertificado")>1<cfelse>0</cfif>,
								<cfif isdefined("form.LOCidioma") and len(trim(form.LOCidioma)) gt 0 and form.LOCidioma NEQ '-1'><cfqueryparam cfsqltype="cf_sql_char" value="#Form.LOCidioma#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.SNcodigoext#">
						)
				</cfquery>
				<cfquery datasource="#session.DSN#">
					insert into SNDirecciones 
						(SNid, id_direccion, Ecodigo, SNcodigo, 
						 SNDfacturacion, SNDenvio, SNDactivo, SNDlimiteFactura, 
						 DEid, BMUsucodigo, SNDcodigo, SNnombre, 
						 SNcodigoext, 
						 SNDtelefono, SNDFax, SNDemail, 
						 DEidEjecutivo, DEidVendedor, 
						 DEidCobrador, SNDCFcuentaCliente, SNDCFcuentaProveedor)
					select 
						SNid, id_direccion, Ecodigo, SNcodigo, 
						1, 1, 1, 0.00, 
						null, BMUsucodigo, SNnumero, SNnombre, 
						case when rtrim(SNcodigoext) = '' then SNnumero else SNcodigoext end,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">, 
						null, null,
						null, null, null
					from SNegocios
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				</cfquery>
				
				<cfset modo="CAMBIO">
			</cftransaction>

		<cfelseif isdefined("Form.Baja")>
				<!--- BORRAR DEMAS TABLAS --->
			<cftransaction>
				<cfquery name="deleteSNegociosObjetos" datasource="#Session.DSN#">
					delete from SNegociosObjetos
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					 and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
				</cfquery>				
			
				<cfquery name="deleteSNAnotaciones" datasource="#Session.DSN#">
					delete from SNAnotaciones
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					 and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
			
				<cfquery name="deleteSNContactos" datasource="#Session.DSN#">
					delete from SNContactos
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
				
				<cfquery name="deleteSNegocios" datasource="#Session.DSN#">
					delete from SNegocios
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset modo="ALTA">
			</cftransaction>
			<cflocation url="listaSocios.cfm">

		<cfelseif isdefined("Form.Cambio")>
			<cfquery datasource="#session.dsn#" name="buscar_direccion">
				select id_direccion from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
		
			<cf_sifdireccion action="readform" name="la_direccion">
			<cf_sifdireccion action="update" key="#buscar_direccion.id_direccion#" name="la_direccion" data="#la_direccion#">
			
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

				<cfquery name="update" datasource="#Session.DSN#">
					update SNegocios set  
						SNidentificacion = 	<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNidentificacion#">,
						SNidentificacion2 = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNidentificacion2#">,
						SNnombre 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">,
						SNdireccion 	 = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#la_direccion.completa#">,
						id_direccion 	 = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,
						SNtelefono 	     = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#">,
						SNFax 			 = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">,
						SNemail 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">,
						SNFecha 		 = 	<cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#LSParseDateTime(form.SNFecha)#">,
						SNtipo 		     = 	<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.SNtipo#">,
						<cfif isdefined("Form.SNinactivo")>
							SNinactivo 	  	 = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNinactivo#">,
						</cfif>
						SNnumero 		 = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnumero#">,
						SNactivoportal   = 	<cfif isdefined("form.SNactivoportal")>1<cfelse>0</cfif>,
						SNcertificado 	 = 	<cfif isdefined ("form.SNcertificado")>1<cfelse>0</cfif>,
						<cfif len(trim(la_direccion.Pais))>
							Ppais =	<cfqueryparam cfsqltype="cf_sql_char" value="#la_direccion.Pais#">,
						<cfelse>
							Ppais =	null,
						</cfif>
						<cfif isdefined("form.LOCidioma") and len(trim(form.LOCidioma)) gt 0 and form.LOCidioma NEQ '-1'>
							LOCidioma = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.LOCidioma#">,
						<cfelse>
							LOCidioma = null,
						</cfif>
						<!--- CSNid, GSNid, ESNid, DEidEjecutivo, DEidVendedor, DEidCobrador, ZCSNid --->
						<cfif isdefined("form.CSNid") and len(trim(form.CSNid)) gt 0>
							CSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSNid#">,
						<cfelse>
							CSNid = null,
						</cfif>
						<cfif isdefined("form.GSNid") and len(trim(form.GSNid)) gt 0>
							GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GSNid#">,
						<cfelse>
							GSNid = null,
						</cfif>
						<cfif isdefined("form.ESNid") and len(trim(form.ESNid)) gt 0>
							ESNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESNid#">
						<cfelse>
							ESNid = null
						</cfif>
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				</cfquery>
				<cfset modo="CAMBIO">
			</cftransaction>
		</cfif>	<!--- isdefined("Form.ALTA") isdefined("Form.Baja") isdefined("Form.Cambio") --->
	</cfif> <!--- not isdefined("Nuevo") --->

<cfelseif isdefined("Form.ICrediticia")>
	<cfif isdefined("Form.Cambio")>
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
			
			<cfquery name="update" datasource="#Session.DSN#">
				update SNegocios set  
	
				<cfif len(trim(Form.SNvencompras)) EQ 0>
						SNvencompras = null,
					<cfelse>
						SNvencompras = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNvencompras#">,
					</cfif>
					<cfif len(trim(Form.SNvenventas)) EQ 0>
						SNvenventas = null,
					<cfelse>
						SNvenventas = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNvenventas#">,
					</cfif>
					<cfif isdefined("form.SNplazoentrega") and len(trim(form.SNplazoentrega)) gt 0>
						SNplazoentrega = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNplazoentrega#">,
					<cfelse>
						SNplazoentrega = null,
					</cfif>
					<cfif isdefined("form.SNplazocredito") and len(trim(form.SNplazocredito)) gt 0>
						SNplazocredito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNplazocredito#">,
					<cfelse>
						SNplazocredito = null,
					</cfif>
					SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNcodigoext#">,
					<!---  Mcodigo, SNmontoLimiteCC, SNdiasVencimientoCC, SNdiasMoraCC --->
					<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo)) gt 0>
						Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
					<cfelse>
						Mcodigo = null,
					</cfif>
					<cfif isdefined("form.SNmontoLimiteCC") and len(trim(form.SNmontoLimiteCC)) gt 0>
						SNmontoLimiteCC = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.SNmontoLimiteCC#">,
					<cfelse>
						SNmontoLimiteCC = null,
					</cfif>
					<cfif isdefined("form.SNdiasVencimientoCC") and len(trim(form.SNdiasVencimientoCC)) gt 0>
						SNdiasVencimientoCC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNdiasVencimientoCC#">,
					<cfelse>
						SNdiasVencimientoCC = null,
					</cfif>
					<cfif isdefined("form.SNdiasMoraCC") and len(trim(form.SNdiasMoraCC)) gt 0>
						SNdiasMoraCC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNdiasMoraCC#">,
					<cfelse>
						SNdiasMoraCC = null,
					</cfif>
					<cfif isdefined("form.DEid3") and len(trim(form.DEid3)) gt 0>
						DEidEjecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid3#">,
					<cfelse>
						DEidEjecutivo = null,
					</cfif>
					<cfif isdefined("form.DEid2") and len(trim(form.DEid2)) gt 0>
						DEidVendedor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid2#">,
					<cfelse>
						DEidVendedor = null,
					</cfif>
					<cfif isdefined("form.DEid1") and len(trim(form.DEid1)) gt 0>
						DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid1#">,
					<cfelse>
						DEidCobrador = null,
					</cfif>
					<cfif isdefined("form.ZCSNid") and len(trim(form.ZCSNid)) gt 0>
						ZCSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ZCSNid#">
					<cfelse>
						ZCSNid = null
					</cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
		</cftransaction>
		<cfset modo="CAMBIO">
		
	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<!--- BORRAR DEMAS TABLAS --->
			<cfquery name="deleteSNegociosObjetos" datasource="#Session.DSN#">
				delete from SNegociosObjetos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				 and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>				
		
			<cfquery name="deleteSNAnotaciones" datasource="#Session.DSN#">
				delete from SNAnotaciones
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				 and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
		
			<cfquery name="deleteSNContactos" datasource="#Session.DSN#">
				delete from SNContactos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfquery name="deleteSNegocios" datasource="#Session.DSN#">
				delete from SNegocios
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cftransaction>
		<cflocation url="listaSocios.cfm">
		<cfset modo="ALTA">
	</cfif>

<cfelseif isdefined("Form.IContable")>
	<cfif isdefined("Form.Cambio")>
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
			
			<cfquery name="update" datasource="#Session.DSN#">
				update SNegocios set  
					<cfif isdefined("form.LPid") and len(trim(form.LPid)) gt 0>
						LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPid#">,
					</cfif>
					<cfif isdefined("form.SNcuentacxc") and len(trim(form.SNcuentacxc)) gt 0>
						<cfif len(trim(form.SNcuentacxc)) gt 0>
							SNcuentacxc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcuentacxc#">,
						<cfelse>
							SNcuentacxc = null,
						</cfif>
					</cfif>
					<cfif isdefined("form.SNcuentacxp") and len(trim(form.SNcuentacxp)) gt 0>
						<cfif len(trim(form.SNcuentacxp)) gt 0>
							SNcuentacxp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcuentacxp#">,
						<cfelse>
							SNcuentacxp = null,
						</cfif>
					</cfif>
					cuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">,
					SNtiposocio 	 = 	<cfif isdefined("form.SNtiposocioC") and isdefined("form.SNtiposocioP")>'A'<cfelseif isdefined("form.SNtiposocioC")>'C'<cfelse>'P'</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
		</cftransaction>
		<cfset modo="CAMBIO">
		
	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<!--- BORRAR DEMAS TABLAS --->
			<cfquery name="deleteSNegociosObjetos" datasource="#Session.DSN#">
				delete from SNegociosObjetos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				 and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>				
		
			<cfquery name="deleteSNAnotaciones" datasource="#Session.DSN#">
				delete from SNAnotaciones
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				 and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
		
			<cfquery name="deleteSNContactos" datasource="#Session.DSN#">
				delete from SNContactos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfquery name="deleteSNegocios" datasource="#Session.DSN#">
				delete from SNegocios
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset modo="ALTA">
		</cftransaction>
		<cflocation url="listaSocios.cfm">

	<cfelseif isdefined("form.IContable") and  isdefined("form.btnaceptar")>
		<cftransaction>
			<!--- Busca si existe el criterio a insertar ya existe --->
			<cfquery name="rsExisteCuentasSocios" datasource="#session.DSN#">
				select count(1) as Cantidad from CuentasSocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
					and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			<!--- Si el criterio no existe hace el insert --->	
			<cfif rsExisteCuentasSocios.Cantidad EQ 0>
				<cfquery name="insertCuentasSocios" datasource="#session.DSN#">
					insert into CuentasSocios (SNcodigo, CCTcodigo, Ecodigo, Ccuenta)
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
						)
				</cfquery>
			<cfelse>
				<cf_errorCode	code = "50026" msg = "El criterio que desea insertar ya existe.">
			</cfif>
		</cftransaction>
		<cfset modo="CAMBIO">
	<cfelseif isdefined("form.IContable") and isdefined("Form.btnBorrar.X")>
		<cftransaction>
			<!--- Borrar un criterio --->
			<cfquery name="deleteCuentasSocios" datasource="#Session.DSN#">
				delete from CuentasSocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.datos#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfset modo="CAMBIO">
		</cftransaction>
	</cfif>
</cfif>


<cfoutput>
<form action="Socios.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) GT 0 and not isdefined("form.nuevo")>
		<input name="SNcodigo" type="hidden" value="#Form.SNcodigo#">
	</cfif>
	<cfif isdefined("form.DGenerales")>
		<input type="hidden" name="tab" value="1">
	</cfif>
	<cfif isdefined("form.ICrediticia")>
		<input type="hidden" name="tab" value="2">
	</cfif>
		<cfif isdefined("form.IContable")>
		<input type="hidden" name="tab" value="3">
	</cfif>
	
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">		
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


