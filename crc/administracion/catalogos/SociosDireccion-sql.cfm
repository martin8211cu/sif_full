<cfif Len(form.SNDlimiteFactura) IS 0><cfset form.SNDlimiteFactura = 0>
<cfelse>
	<cfset form.SNDlimiteFactura = Replace(form.SNDlimitefactura,',','','all')>
</cfif>

<cfquery name="rsSNid" datasource="#session.DSN#">
	select SNid
	from SNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif not isdefined("Form.NuevoDireccion")>
	<cfif isdefined("Form.AltaDireccion")>
		<cf_sifdireccion action="readform" name="la_direccion">
		<cf_sifdireccion action="insert" name="la_direccion" data="#la_direccion#">
		<cfset form.id_direccion=la_direccion.id_direccion>
		<cftransaction>
		<cfquery datasource="#session.dsn#">
			insert into SNDirecciones (
				SNid, id_direccion, Ecodigo, SNcodigo, SNDcodigo, SNnombre, SNcodigoext,
				SNDfacturacion, SNDenvio, SNDactivo,

				SNDtelefono,
				SNDFax,
				SNDemail,
				<cfif isdefined("form.DEid6") and len(trim(form.DEid6))>
				DEidEjecutivo,
				</cfif>
				<cfif isdefined("form.DEid4") and len(trim(form.DEid4))>
				DEidCobrador,
				</cfif>
				<cfif isdefined("form.DEid5") and len(trim(form.DEid5))>
				DEidVendedor,
				</cfif>
				SNDlimiteFactura, 
				DEid, 
				SNDCFcuentaCliente,
				SNDCFcuentaProveedor,
				BMUsucodigo)  
			select
				SNid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,
				Ecodigo, SNcodigo,
				<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SNDcodigo)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNnombre)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNcodigoext)#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.SNDfacturacion')#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.SNDenvio')#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.SNDactivo')#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNDtelefono)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNDFax)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNDemail#">,
				<cfif isdefined("form.DEid6") and len(trim(form.DEid6))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid6#">, <!--- Ejecutivo --->
				</cfif>
				<cfif isdefined("form.DEid4") and len(trim(form.DEid4))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid4#">, <!--- Cobrador --->
				</cfif>
				<cfif isdefined("form.DEid5") and len(trim(form.DEid5))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid5#">, <!--- Vendedor --->
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_money"   value="#form.SNDlimiteFactura#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid5#" null="#Len(form.DEid5) EQ 0#">, <!--- Vendedor --->
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNDCFcuentaCliente#" null="#len(trim(form.SNDCFcuentaCliente)) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNDCFcuentaProveedor#" null="#len(trim(form.SNDCFcuentaProveedor)) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			from SNegocios
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		
		<!--- Actualización de la tabla de Clasificaciones por dirección --->
		<cfquery name="rsSNCDid" datasource="#session.DSN#">
			select SNCDid
				from SNClasificacionSN sn
				where sn.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNid.SNid#">
		</cfquery>
		
		<cfloop query="rsSNCDid">
			<cfif Len(rsSNid.SNid) and session.Ecodigo neq session.Ecodigocorp and Len(session.Ecodigocorp)>
				<cfquery datasource="#session.dsn#" name="corp">
				  select SNCEcorporativo
				  from SNClasificacionE e
					join SNClasificacionD d
						on e.SNCEid = d.SNCEid
					where d.SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNCDid.SNCDid#">
				</cfquery>
				<cfif corp.SNCEcorporativo EQ 1>
					<cfset rsSNid.SNid = ''>
				</cfif>
			</cfif>
			
			<cfif Len(rsSNid.SNid)>
				<cfquery datasource="#session.dsn#">
					insert into SNClasificacionSND (id_direccion, SNid, SNCDid, BMUsucodigo)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNid.SNid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNCDid.SNCDid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
				</cfquery>
			</cfif>
		</cfloop>
		</cftransaction>
		
	<cfelseif isdefined("Form.BajaDireccion")>
		<!--- BORRAR DEMAS TABLAS
			no importa la configuracion del catalogo, de todos modos se borrara.
			La nica excepcin podra ser si es un socio corporativo que est siendo importado en otra
			empresa, habra que validar y borrar sus "hijos"
		--->
		<cftransaction>
			<cfquery datasource="#session.DSN#">
				delete from SNLimiteCredito
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
				  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				delete from SNClasificacionSND
				where SNid = <cfqueryparam value="#rsSNid.SNid#" cfsqltype="cf_sql_numeric">
					  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
			</cfquery>		
			<cfquery name="deleteSNegociosObjetos" datasource="#Session.DSN#">
				delete from SNDirecciones
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
				  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
			</cfquery>
			<cfset modo="ALTA">
			<cfset form.id_direccion="">
		</cftransaction>
		
	<cfelseif isdefined("Form.CambioDireccion")>
		<cftransaction>
			<cf_dbtimestamp datasource="#session.dsn#"
				table="SNDirecciones"
				redirect="Socios.cfm?tab=8"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo"
				type1="integer"
				value1="#session.Ecodigo#"
				field2="SNcodigo"
				type2="integer"
				value2="#form.SNcodigo#"
				field3="id_direccion"
				type3="numeric"
				value3="#form.id_direccion#">

			<cfquery name="update" datasource="#Session.DSN#">
				update SNDirecciones 
				set SNDfacturacion 	= 	<cfqueryparam cfsqltype="cf_sql_bit" 	value="#IsDefined('form.SNDfacturacion')#">,
					SNDenvio 		=	<cfqueryparam cfsqltype="cf_sql_bit" 	value="#IsDefined('form.SNDenvio')#">,
					SNDactivo 		=	<cfqueryparam cfsqltype="cf_sql_bit" 	value="#IsDefined('form.SNDactivo')#">,
					SNDlimiteFactura = 	<cfqueryparam cfsqltype="cf_sql_money"  value="#form.SNDlimiteFactura#">,
					SNDcodigo 		= 	<cfqueryparam cfsqltype="cf_sql_char" 	value="#form.SNDcodigo#">,
					SNnombre 		=	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnombre#">,
					SNcodigoext 	= 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNcodigoext#">,										
					DEid 			= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid5#" null="#Len(form.DEid5) EQ 0#">,
					SNDtelefono 	=	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNDtelefono)#">,
					SNDFax 			=	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNDFax)#">,
				 	SNDemail 		=	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNDemail#">,
					<cfif isdefined("form.DEid6") and len(trim(form.DEid6))>
						DEidEjecutivo 	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid6#">,
					<cfelse>
						DEidEjecutivo = null,
					</cfif>
					<cfif isdefined("form.DEid5") and len(trim(form.DEid5))>
						DEidVendedor 	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid5#">,
					<cfelse>
						DEidVendedor = null,
					</cfif>
					<cfif isdefined("form.DEid4") and len(trim(form.DEid4))>
				 		DEidCobrador 	=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid4#">,
					<cfelse>
						DEidCobrador = null,
					</cfif>
					SNDCFcuentaCliente 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNDCFcuentaCliente#" null="#len(trim(form.SNDCFcuentaCliente)) EQ 0#">,
					SNDCFcuentaProveedor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNDCFcuentaProveedor#" null="#len(trim(form.SNDCFcuentaProveedor)) EQ 0#">,

					BMUsucodigo 	=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where Ecodigo 		=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and SNcodigo 		= 	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				  and id_direccion 	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
			</cfquery>
		</cftransaction>
		<cf_sifdireccion action="readform" name="la_direccion"><!--- revisar este tag tavoG dice que estaba bien la cuestion del update --->
		<cfset la_direccion.id_direccion = form.id_direccion>
		<cfif not isdefined("form.DireccionPrincipal")>
			<cf_sifdireccion action="update" name="la_direccion" data="#la_direccion#">
		</cfif>
		<cfset modo="CAMBIO">
	</cfif>
<cfelse>
	<cfset form.id_direccion="">
</cfif>

<cfset params = "">
<cfif isdefined("url.SNCat") and url.SNCat eq 1>
	<cfset form.SNCat = url.SNCat>
</cfif>
<cfif isdefined("form.SNCat")>
	<cfset params = "SNCat=#form.SNCat#">
</cfif>

<cflocation url="SociosDirecciones_form.cfm?SNcodigo=#form.SNcodigo#&tab=8&id_direccion=#form.id_direccion#&#params#">