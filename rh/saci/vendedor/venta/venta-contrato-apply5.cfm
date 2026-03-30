<cfif isdefined("form.Activar") or isdefined("url.Activar")>
	
	<!--- Validar que almenos haya un paquete en captura --->
	<cfquery name="chkPaquetes" datasource="#Session.DSN#">								<!--- Traer los productos en captura --->
		select a.Contratoid,b.PQcodigo as paquete
		from ISBproducto a
			inner join ISBpaquete b
			on b.PQcodigo = a.PQcodigo
			and b.Habilitado = 1
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
		and a.CTcondicion = 'C'
	</cfquery>
	
	<cfif chkPaquetes.recordCount EQ 0>
		<cfthrow message="ERROR: para activar la cuenta debe asignarle al menos un paquete.">
	
	<cfelse>
		<cfset errorMens="">
		
		<!--- 1 Validar que almenos haya un login por paquete en captura --->
		<cfquery name="chkLogines" datasource="#Session.DSN#">
			select a.CTid,a.Contratoid,b.PQcodigo as paquete,
				(select count(1) from ISBlogin x where x.Contratoid = a.Contratoid)as cantidad
			from ISBproducto a
				inner join ISBpaquete b
					on b.PQcodigo = a.PQcodigo
					and b.Habilitado=1
			where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			and a.CTcondicion = 'C'
		</cfquery>
		
		<cfset sinLogin = "">
		<cfloop query="chkLogines">
			<cfif chkLogines.cantidad EQ 0><cfset sinLogin = sinLogin &' '& IIF(sinLogin neq "", DE(","), DE(""))&' '&chkLogines.paquete></cfif>
		</cfloop>
		
		<cfif sinLogin neq "">
			<cfset errorMens= errorMens & " Los paquetes #sinLogin# deben tener al menos un login asignado.">
		</cfif>
		<!--- fin 1 --->			
		
		<!--- 2  Validar que todas los logines tengan un sobre asignado --->
		<cfquery name="chkSobre" datasource="#Session.DSN#">
			select a.CTid,a.Contratoid,b.PQcodigo as paquete,
				(	select count(1) from ISBlogin x 
					where x.Contratoid = a.Contratoid
					and x.Snumero is not null
				)as cantidad
			from ISBproducto a
				inner join ISBpaquete b
					on b.PQcodigo = a.PQcodigo
					and b.Habilitado=1
			where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			and a.CTcondicion = 'C'
		</cfquery>
		
		<cfset sinSobre = "">
		<cfloop query="chkSobre">
			<cfif chkSobre.cantidad EQ 0><cfset sinSobre = sinSobre &' '& IIF(sinSobre neq "", DE(","), DE(""))&' '&chkSobre.paquete></cfif>
		</cfloop>
								
		<cfif sinSobre neq "">
			<cfset errorMens= errorMens & " Los paquetes #sinSobre# en captura deben tener un sobre por cada login asignado.">
		</cfif>
		<!--- 2 Fin--->
		
		<!--- 3 Validar que todas los logines  de ACCS tengan un telefono asignado --->
		<cfquery name="chkTelefono" datasource="#Session.DSN#">
			select distinct a.CTid,a.Contratoid,e.PQcodigo,b.LGlogin,
				(select count(1) from ISBlogin x where x.LGnumero=b.LGnumero and x.Contratoid=a.Contratoid and LGtelefono is null) as sinTelefono
			from ISBproducto a
				inner join ISBlogin b
					on b.Contratoid = a.Contratoid
				inner join ISBserviciosLogin c
					on c.LGnumero = b.LGnumero
					and c.TScodigo='ACCS'
				inner join ISBpaquete e
					on e.PQcodigo = a.PQcodigo
					and e.Habilitado=1
					and e.PQtelefono=1
			where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			and a.CTcondicion = 'C'
		</cfquery>
		
		<cfset sinTel = "">
		<cfloop query="chkTelefono">
			<cfif chkTelefono.sinTelefono EQ 1><cfset sinTel = sinTel &' '& IIF(sinTel neq "", DE(","), DE(""))&' '&chkTelefono.LGlogin></cfif>
		</cfloop>
		
		<cfif sinTel NEQ "">
			<cfset errorMens= errorMens & " Los logines de tipo ACCS #sinTel# deben tener un teléfono asociado.">
		</cfif>
		<!---3 Fin --->
		
		<!--- 4  Validar que la cantidad de servicios asignados a cada producto sea la correcta --->
		<cfset idcontrato = "">
		<cfset paqServ = "">
		
		<cfloop query="chkPaquetes">
			
			<cfset idcontrato = chkPaquetes.Contratoid>
			<cfset paquete = chkPaquetes.paquete>
			<cfset muchosServ = "">
			<cfset pocosServ = "">
			
			<cfquery name="chkServicios" datasource="#Session.DSN#">
				select x.TScodigo,
					x.TSnombre,
					coalesce((
						select count(1)
						from ISBproducto a
						inner join ISBlogin b
							on b.Contratoid = a.Contratoid
						inner join ISBserviciosLogin c
							on c.LGnumero = b.LGnumero
							and c.PQcodigo = a.PQcodigo
							and c.TScodigo = x.TScodigo
							and c.Habilitado = 1
						inner join ISBservicio e
							on e.PQcodigo = c.PQcodigo
							and e.TScodigo = c.TScodigo
							and e.Habilitado = 1
						where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#idcontrato#">
						and a.CTcondicion = 'C'
					), 0) as ServActivos, 			<!---servicios que posee el producto actual en captura--->
					coalesce((
						select sum(b.SVcantidad) 
						from ISBproducto a
						inner join ISBservicio b
							on b.PQcodigo = a.PQcodigo
							and b.TScodigo=x.TScodigo
							and b.Habilitado = 1
						where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#idcontrato#">
						and a.CTcondicion = 'C'
					), 0) as ServPermitidos,		<!---servicios maximos que permite el paquete actual en captura--->
					coalesce((
						select sum(b.SVminimo) 
						from ISBproducto a
						inner join ISBservicio b
							on b.PQcodigo = a.PQcodigo
							and b.TScodigo=x.TScodigo
							and b.Habilitado = 1
						where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#idcontrato#">
						and a.CTcondicion = 'C'
					), 0) as ServMinimos			<!---servicios minimos que permite el paquete actual en captura--->
				from ISBservicioTipo x
				where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			

			<cfloop query="chkServicios">
				
				<cfset actu = chkServicios.ServActivos >
				<cfset permit= chkServicios.ServPermitidos>
				<cfset mini = chkServicios.ServMinimos >
				
				<cfif actu GT permit>
					<cfset muchosServ = muchosServ &' '& IIF(muchosServ neq "", DE(","), DE(""))&' '&chkServicios.TScodigo>
				</cfif>
				
				<cfif  mini GT actu>
					<cfset pocosServ = pocosServ &' '& IIF(pocosServ neq "", DE(","), DE(""))&' '&chkServicios.TScodigo>
				</cfif>
			</cfloop><!---loop chkServicios--->
			
			<cfif muchosServ NEQ "">
				<cfset paqServ = paqServ &' '& IIF(paqServ neq "", DE(";"), DE(""))&' '& muchosServ &' en el '&paquete>
			</cfif>
			
			<cfif pocosServ NEQ "">
				<cfset paqServ = paqServ &' '& IIF(paqServ neq "", DE(";"), DE(""))&' '& pocosServ &' en el '&paquete>
			</cfif>	
		
		</cfloop> <!---loop chkPaquetes--->
		
		<cfif paqServ NEQ "">
			<cfset errorMens= errorMens & " Se asignó una cantidad de servicios mayor o menor a la permitida en la configuración de los productos #paqServ#.">
		</cfif>
		<!--- 4 Fin--->
		
		<!--- 5  Validar que si la persona es de tipo juridico que posea al menos un contacto --->
		<cfquery name="rsPersoner" datasource="#Session.DSN#">
			select Ppersoneria as tipo from ISBpersona where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
		</cfquery>
		<cfif rsPersoner.tipo EQ 'J'>
			<cfquery name="rsPoseeContacto" datasource="#Session.DSN#">
				select count(1) as existe
				from  ISBpersonaRepresentante
				where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
				and RJtipo = 'L'
			</cfquery>
			<cfif rsPoseeContacto.existe EQ 0 >
				<cfset errorMens= errorMens & " El cliente de tipo Jurídico debe tener al menos un representante.">	
			</cfif>
		</cfif>
		<!--- 5 Fin--->
		<!---Muestra los mensajes si hay error--->
		<cfif errorMens NEQ "">	
			<cfthrow message="ERROR:#errorMens#">				
		</cfif>
		<!--------------------------------ACTIVACION DE CUENTAS, LOGINES, SOBRES--------------------------------------------------->
		
		<cftransaction>
			<cfquery name="rsStatusCuenta" datasource="#Session.DSN#">
				select a.Habilitado
				from ISBcuenta a
				where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			</cfquery>
			
			<!--- FALTA: Verificar que el monto de la garantia sea el correcto --->
	
			<!--- Activar la cuenta si no esta activa --->
			<cfif rsStatusCuenta.Habilitado EQ 0>
				<cfinvoke component="saci.comp.ISBcuenta" method="Activacion">
					<cfinvokeargument name="CTid" value="#form.CTid#">
					<cfinvokeargument name="CTapertura" value="#Now()#">
				</cfinvoke>
			</cfif>
			
			<!--- Activación de los logines y sobres --->
			<cfquery name="rsSobres" datasource="#Session.DSN#">
				select a.Contratoid, b.LGnumero, b.Snumero
				from ISBproducto a
					inner join ISBlogin b
						on b.Contratoid = a.Contratoid
				where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
				and a.CTcondicion = 'C'
			</cfquery>
	
			<!--- Activar los productos (Poner en condición 0) --->
			<cfquery name="rsProductos" dbtype="query">
				select distinct Contratoid
				from rsSobres
			</cfquery>
			<cfloop query="rsProductos">
				<cfinvoke component="saci.comp.ISBproducto" method="Activacion">
					<cfinvokeargument name="Contratoid" value="#rsProductos.Contratoid#">
				</cfinvoke>
			</cfloop>
	
			<cfloop query="rsSobres">
				<!--- Activar el login --->
				<cfinvoke component="saci.comp.ISBlogin" method="Activacion">
					<cfinvokeargument name="LGnumero" value="#rsSobres.LGnumero#">
				</cfinvoke>
				
				<!--- Activar el sobre --->
				<cfinvoke component="saci.comp.ISBsobres" method="Activacion" returnvariable="LvarError">
					<cfinvokeargument name="Snumero" value="#rsSobres.Snumero#">
				</cfinvoke>
				<cfif LvarError NEQ 0>
					<cfthrow message="ERROR: El sobre con número #rsSobres.Snumero# ya fue activado o no tiene un login asignado.">
				</cfif>
			</cfloop>
			<cfset ExtraParams = "Activado=1"><!---Envía por url q la cuenta se activo con exito--->
		
		</cftransaction>
		<!--- activar la cuenta en los sistemas externos (SIIC) --->
		<cfquery dbtype="query" name="por_activar">
			select distinct Contratoid from rsSobres
		</cfquery>
		<cfloop query="por_activar">
			<cfinvoke component="saci.ws.intf.H001_crearLoginSIIC" method="activar_cuenta"
				CTid="#Form.CTid#" Contratoid="#por_activar.Contratoid#" />
		</cfloop>

		<!---Fin de Activacion de cuentas, logines, sobres--->
	
	</cfif><!---chkPaquetes--->

</cfif>
