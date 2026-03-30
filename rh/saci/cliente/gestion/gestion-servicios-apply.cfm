<!--- Primero que nada veamos si hay pago en línea pendiente, en este caso procedemos al pago --->
<cfif IsDefined('url.pagoenlinea')>
	<cfset StructAppend(form, session.pagando)>
</cfif>
<cfif form.Gtipo_n is 11 And (form.Gmonto_n GT 0)>
	<!--- 11 = PAGO-EN-LINEA --->
	<!--- ver si el pago se realizó --->
	<cfquery datasource="#session.dsn#" name="pagado">
		select PTmonto, PTid, PTcodAutorizacion
		from ISBpago
		where PTlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Login_1#">
		  and PTusado = 0
		  and PTautorizado = 1
		  and PTmonto >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gmonto_n#">
		  <cfif IsDefined('url.pagoenlinea')>
		  	and PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pagoenlinea#">
		  </cfif>
		order by PTmonto
	</cfquery>
	<cfif pagado.RecordCount is 0>

		<cfif IsDefined('url.pagoenlinea')>
			<cfset ExtraParams="recargaok=0">
			<cfinclude template="gestion-redirect.cfm">
			<!--- Se supone que de aquí no pasa, pero pongo el cfthrow por lo que potis --->
			<cfthrow message="El pago para #form.tj# por #form.costo_total# no fue aceptado.">
		</cfif>
	
	
		<!--- guardar el form en session, y mandar a pagar --->
		<cfset session.pagando = StructNew()>
		<cfset StructAppend(session.pagando, form)>
		<cfinvoke component="saci.pagos.vpos" method="send" returnvariable="vpos_struct"
			monto="#form.Gmonto_n#"
			moneda="#form.Miso4217_n#"
			origen="SACI"
			tipoTransaccion="AUAG"
			login="#Form.Login_1#"
			descripcion="Paquete #form.PQcodigo_n#" />
		<cflocation url="../../pagos/vpos-request.cfm?datos=#vpos_struct.datos#&validar=#vpos_struct.validar#" addtoken="no">
	<cfelse>
		<cfset form.Gref_n = 'Aut #pagado.PTcodAutorizacion#, Tran #pagado.PTid#'>
		<cfset form.PTid = pagado.PTid>
	</cfif>
</cfif>

<!---Obtiene la cuenta de Facturación--->
<cfquery name="rsCuentaFacturacion" datasource="#Session.DSN#">
	select Top 1 a.CTidFactura as cu
	from ISBproducto a
	where a.CTid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid_n#">
</cfquery>

<cfset LvarCTidFactura = rsCuentaFacturacion.cu>

<!--- Verifica si el paquete requiere telefonos --->
<cfquery name="rsPaquete" datasource="#session.DSN#">
	select PQdescripcion, PQtelefono,PQmailQuota
	from ISBpaquete
	where  PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#"> 
</cfquery>
<cfset quota = rsPaquete.PQmailQuota>

<!--- Obtener la cantidad máxima de logines que se pueden asignar por paquete --->
<cfquery name="maxServicios" datasource="#session.DSN#">
	select max(cant) as cantidad
	from (
		select coalesce(sum(SVcantidad), 0) as cant
		from ISBservicio
		where  PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#">
		 and Habilitado = 1
		group by PQcodigo
	) temporal
</cfquery>

<!--- Obtener los TScodigos permitidos por el paquete --->
<cfquery name="rsServiciosDisponibles" datasource="#session.DSN#">
	select a.TScodigo,a.SVcantidad,a.SVminimo
		, (select z.TSdescripcion from ISBservicioTipo z where z.TScodigo=a.TScodigo and z.Habilitado=1 and z.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) as descripcion
	from ISBservicio a
	where a.PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#">
	and a.Habilitado = 1
	and a.TScodigo in (select x.TScodigo from ISBservicioTipo x where x.Habilitado=1 and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	order by TScodigo
</cfquery>

<!--- Obtener el nombre de la persona como REALNAME --->
<cfquery name="rsDatos" datasource="#session.DSN#">
	select Pnombre ||' '|| Papellido ||' '|| Papellido2 as realname
	from ISBpersona
	where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cli#">	
</cfquery>

<cfset logss = "">
<cfset contrato = "">
<cftransaction>
	<!------------------------------------------ ALTA DE PAQUETE ----------------------------------->
	<cfinvoke component="saci.comp.ISBproducto" method="Alta" returnvariable="contrato">
		<cfinvokeargument name="CTid" value="#form.CTid_n#">
		<cfinvokeargument name="CTidFactura" value="#LvarCTidFactura#">
		<cfinvokeargument name="PQcodigo" value="#form.PQcodigo_n#">
		<cfif isdefined("session.saci.vendedor.id") and Len(Trim(session.saci.vendedor.id))>
			<cfinvokeargument name="Vid" value="#session.saci.vendedor.id#">
		</cfif>
		<cfinvokeargument name="CTcondicion" value="1">
		<cfinvokeargument name="CNnumero" value="Sin asignar..agregado por autogestion"> <!---NOTA: este valor es provicional... ver que valor se le asigna a CNnumero--->
		<cfinvokeargument name="CNapertura" value="#Now()#">
	</cfinvoke>
	
	<!------------------------------------------ ALTA DE LOGINES ----------------------------------->
	<cfloop from="1" to="#maxServicios.cantidad#" index="k">
		<cfif isdefined("Form.Login_#k#") and Len(Trim(Form['Login_' & k]))>
			<cfset login = Form['Login_' & k]>
			<cfset telefono = "">
			<cfif rsPaquete.PQtelefono EQ 1>
				<cfset telefono = Form['LGtelefono_' & k]>
			</cfif>
			
			<!--- Verificar existencia de Login antes de guardar y cancelar el guardado de los logines enviando un mensaje de error --->
			<cfinvoke component="saci.comp.ISBlogin" method="Existe" returnvariable="ExisteLogin" LGlogin="#login#" />
			
			<cfif not ExisteLogin>
				<!--- Insertar Login --->
				<cfset serv = "">
				<cfloop query="rsServiciosDisponibles">
					<cfif isdefined("Form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#k#")>
						<cfset serv = serv & Iif(Len(Trim(serv)), DE(","), DE("")) & Form['chk_#Trim(rsServiciosDisponibles.TScodigo)#_#k#']>
					</cfif>
				</cfloop>	
				<!--- Indica si algun servicio del login es de tipo correo --->
				<cfif listLen(serv)>
					<cfquery name="rsCorreo" datasource="#session.dsn#">
						select count(1)as cant
						from ISBservicioTipo
						where TScodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#serv#">)
							and TStipo='C'
					</cfquery>
				</cfif>
					
				<cfinvoke component="saci.comp.ISBlogin" method="Alta" returnvariable="loginid">
					<cfif isdefined("Form.Snumero_#k#") and Len(Trim(Form['Snumero_' & k]))>
						<cfinvokeargument name="Snumero" value="#Form['Snumero_' & k]#">
					</cfif>
					<cfinvokeargument name="Contratoid" value="#contrato#">
					<cfinvokeargument name="LGlogin" value="#login#">
					<cfinvokeargument name="LGrealName" value="#rsDatos.realname#">
					<cfif isdefined("rsCorreo") and rsCorreo.cant GT 0 >
					<cfinvokeargument name="LGmailQuota" value="#quota#">
					</cfif>
					<cfinvokeargument name="LGroaming" value="false">
					<cfinvokeargument name="LGprincipal" value="#ListFind(serv, 'ACCS', ',') NEQ 0 or ListFind(serv, 'CABM', ',') NEQ 0#">
					<cfinvokeargument name="Habilitado" value="true">
					<cfinvokeargument name="LGbloqueado" value="false">
					<cfinvokeargument name="LGmostrarGuia" value="false">
					<cfinvokeargument name="LGtelefono" value="#telefono#">
					<cfinvokeargument name="Servicios" value="#serv#">
					<cfinvokeargument name="registrar_en_bitacora" value="true">
				</cfinvoke>
				<cfset logss = logss & IIF(len(trim(logss)),DE(','),DE(''))&loginid>	 
			</cfif>
		</cfif>
	</cfloop>
	
	<!-------------------------------- ALTA DE GARANTIA ------------------------------------------>
	<cfset loginid = "">
	<cfquery name="rsLogPrincipal" datasource="#session.DSN#">
		select  b.LGnumero,b.LGlogin
		from ISBproducto a
			inner join ISBlogin b
				on b.Contratoid=a.Contratoid
					and b.LGprincipal=1
		where
			a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#contrato#">
			and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid_n#">
			and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.PQcodigo_n#">					
	</cfquery>	
	<cfif isdefined('rsLogPrincipal') and rsLogPrincipal.recordCount GT 0>
		<cfset loginid = rsLogPrincipal.LGnumero>
	<cfelse>
		<cfthrow message="No existe el login principal para el contrato (#contrato#) en la pagina de Autogestion.">
	</cfif>
						
 	<cfset form.CTid = Form.CTid_n>
 	<cfset form.Contratoid = contrato>
	<cfset cargaSufijo = "_n">
			
	<!--- Insercion de los datos del deposito de garantia --->
	<cfinclude template="../../utiles/depoGaran-apply.cfm">	
	<!--- Marcar ISBpago como utilizada --->
	<cfif form.Gtipo_n is 11 And (form.Gmonto_n GT 0)>
		<cfquery datasource="#session.dsn#">
			update ISBpago
			set PTusado = 1
			where PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PTid#">
		</cfquery>
	</cfif>

</cftransaction>
	
	<!------------------------Generar password global por logines-------------------------------->
<cfif len(trim(logss))>	
	<cfloop index="LGnumero" list="#logss#" delimiters=",">
		<cfinvoke component="saci.comp.random-password" returnvariable="clave" method="Generar"><!---genera el password aleatorio--->
			<cfinvokeargument name="LGnumero" value="#LGnumero#">
		</cfinvoke>
		<cftransaction>
			<cfloop index="TScodigo" list="#serv#" delimiters=",">
				<cfinvoke component="saci.comp.ISBlogin" method="CambioPassword" >					<!---Realiza el cambio de password--->
					<cfinvokeargument name="LGnumero" value="#LGnumero#">
					<cfinvokeargument name="TScodigo" value="#TScodigo#">
					<cfinvokeargument name="SLpassword" value="#clave#">
				</cfinvoke>
				<cfinvoke component="saci.comp.ISBserviciosLogin" method="conVigencia" >			<!---Pone como plazo de vigencia un dia para que el cliente cambie su password--->
					<cfinvokeargument name="LGnumero" value="#LGnumero#">
					<cfinvokeargument name="TScodigo" value="#TScodigo#">
				</cfinvoke>
			</cfloop>
		</cftransaction>
	</cfloop>	
</cfif>

<!--- activar la cuenta en los sistemas externos (SIIC) --->
<cfinvoke component="saci.ws.intf.H001_crearLoginSIIC" method="activar_cuenta"
	CTid="#Form.CTid_n#" Contratoid="#contrato#" />

<cfset ExtraParams="recargaok=1&PQcodigo_n=#form.PQcodigo_n#&pkg_n=#contrato#">
<cfinclude template="gestion-redirect.cfm">
