<!--- Obtener la cantidad máxima de logines que se pueden asignar por paquete --->
<cfinvoke component="saci.ws.intf.base" method="servpaq" returnvariable="maxlogines">
	<cfinvokeargument name="paquete" value="">
</cfinvoke>


<cfquery name="maxServicios" datasource="#Attributes.Conexion#">
	select max(cant) as cantidad
	from (
		select coalesce(sum(SVcantidad), 0) as cant
		from ISBservicio
		where Habilitado = 1
		group by PQcodigo
	) temporal
</cfquery>

<cfset maxServicios.cantidad = maxlogines>

<cfquery name="rsServiciosDisponibles" datasource="#Attributes.Conexion#">
	select TScodigo
	from ISBservicioTipo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	order by TScodigo
</cfquery>

<cfif ExisteCuenta>
	<cfquery name="rsAllContratos" datasource="#Attributes.Conexion#">
		select a.Contratoid, a.CNsuscriptor, a.CNnumero,
			   b.PQcodigo, b.Miso4217, b.MRidMayorista, b.PQnombre, b.PQcomisionTipo, b.PQcomisionPctj, b.PQcomisionMnto, b.PQtoleranciaGarantia, b.PQtarifaBasica, b.PQcompromiso, b.PQhorasBasica, b.PQprecioExc, b.PQroaming, b.PQmailQuota, b.PQtelefono, b.PQinterfaz,
			   (select sum(SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as CantidadCorreos
			   <cfloop query="rsServiciosDisponibles">
			   , coalesce((select sum(x.SVcantidad) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.TScodigo = '#Trim(rsServiciosDisponibles.TScodigo)#' and x.Habilitado = 1), 0) as Cantidad_#Trim(rsServiciosDisponibles.TScodigo)#
			   </cfloop>
		from ISBproducto a
			inner join ISBpaquete b
				on b.PQcodigo = a.PQcodigo
			inner join ISBcuenta c
				on c.CTid = a.CTid
				and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idpersona#">
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
			and a.CTcondicion not in ('C')
			<cfif ExisteContrato>
				and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idcontrato#">
			</cfif>
		order by a.Contratoid
	</cfquery>
	
	<cfquery name="rsContratosAprobados" datasource="#Attributes.Conexion#">
		select b.PQcodigo, b.PQnombre
			   <cfloop query="rsServiciosDisponibles">
			   , coalesce((select sum(x.SVcantidad) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.TScodigo = '#Trim(rsServiciosDisponibles.TScodigo)#' and x.Habilitado = 1), 0) as Cantidad_#Trim(rsServiciosDisponibles.TScodigo)#
			   </cfloop>
		from ISBproducto a
			inner join ISBpaquete b
				on b.PQcodigo = a.PQcodigo
			inner join ISBcuenta c
				on c.CTid = a.CTid
				and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idpersona#">
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		and a.CTcondicion not in ('C','0','X')	<!--- Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->
		order by a.Contratoid
	</cfquery>	
</cfif>

<cfset permiteAgregarPaquetes = Attributes.vista NEQ 3>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td width="15%" align="#Attributes.alignEtiquetas#"><label>No.&nbsp;<cf_traducir key="cuenta">Cuenta</cf_traducir></label></td>
		<td>
			<cfif ExisteCuenta and rsCuenta.CUECUE GT 0>#rsCuenta.CUECUE#<cfelseif rsCuenta.CTtipoUso EQ 'U'>&lt;Por Asignar&gt;<cfelseif rsCuenta.CTtipoUso EQ 'A'>(Acceso) &lt;Por Asignar&gt;<cfelseif rsCuenta.CTtipoUso EQ 'F'>(Facturaci&oacute;n) &lt;Por Asignar&gt;</cfif>
		</td>
		<td align="#Attributes.alignEtiquetas#"><label><cf_traducir key="fecha">Fecha</cf_traducir> <cf_traducir key="de">de</cf_traducir> <cf_traducir key="apertura">Apertura</cf_traducir></label></td>
		<td>
			#LSDateFormat(rsCuenta.CTapertura, 'dd/mm/yyyy')#
		</td>
	  </tr>
	  <tr>
		<td align="#Attributes.alignEtiquetas#" valign="top" nowrap><label><cf_traducir key="observacion">Observaciones</cf_traducir></label></td>
		<td colspan="3">
			<cfif ExisteCuenta>
				#HTMLEditFormat(Trim(rsCuenta.CTobservaciones))#
			</cfif>
		</td>
	  </tr>

	<!--- Solo se pueden visualizar paquetes cuando se esta registrando una cuenta de acceso tanto para un cliente o un agente --->
	<cfif ExisteCuenta and rsCuenta.CUECUE GTE -1>
		<!--- Desplegar los paquetes ya seleccionados y NO modificables --->
		<cfloop query="rsContratosAprobados">
		  <cfif rsContratosAprobados.currentRow EQ 1>
		  <tr align="center">
			<td colspan="4" class="subTitulo"><strong>Productos aprobados anteriormente</strong></td>
		  </tr>
		  </cfif>

		  <tr>
			<td align="#Attributes.alignEtiquetas#"><label>Paquete</label></td>
			<td colspan="3">
				<cf_paquete 
					id = "#rsContratosAprobados.PQcodigo#"
					sufijo = "X#rsContratosAprobados.currentRow#"
					agente = "#Attributes.filtroAgente#"
					form = "#Attributes.form#"
					filtroPaqInterfaz = "0"
					readOnly = "true"
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
					showCodigo="false"
				>
			</td>
		  </tr>

		</cfloop>
			
		<!--- Desplegar los paquetes ya seleccionados y modificables --->
		<cfloop query="rsAllContratos">
		  <cfquery name="rsLogines" datasource="#Attributes.Conexion#">
			select a.LGnumero, a.Contratoid, coalesce(a.Snumero, 0) as Snumero, a.LGlogin, coalesce(a.LGtelefono, ' ') as LGtelefono, a.LGrealName, a.LGcese, a.LGserids, a.Habilitado, a.LGmostrarGuia
			from ISBlogin a
			where a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAllContratos.Contratoid#">
			order by a.LGprincipal desc, a.LGnumero
		  </cfquery>
		  <cfset loginesid = ValueList(rsLogines.LGnumero, ',')>
		  <cfset sobresnum = ValueList(rsLogines.Snumero, ',')>
		  <cfset logines = ValueList(rsLogines.LGlogin, ',')>
		  <cfset telefonos = ValueList(rsLogines.LGtelefono, ',')>
		  
		  <cfif rsAllContratos.currentRow EQ 1>
		  <tr align="center">
			<td colspan="4" class="subTitulo"><strong>Productos agregados a la cuenta</strong></td>
		  </tr>
		  </cfif>
	
		  <tr>
			<td align="#Attributes.alignEtiquetas#"><label><cf_traducir key="paquete">Paquete</cf_traducir></label></td>
			<td colspan="3">
				<cf_paquete 
					id = "#rsAllContratos.PQcodigo#"
					sufijo = "#rsAllContratos.currentRow#"
					agente = "#Attributes.filtroAgente#"
					form = "#Attributes.form#"
					funcion = "solicitarCampos#rsAllContratos.currentRow#"
					filtroPaqInterfaz = "0"
					readOnly = "true"
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
				>
			</td>
		  </tr>
		  
		  <tr id="trSuscriptor#rsAllContratos.currentRow#" <cfif not (isdefined("rsAllContratos.Cantidad_CABM") and rsAllContratos.Cantidad_CABM GT 0)> style="display: none;"</cfif>>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Nombre Suscriptor</label></td>
			<td>
				<input  class="cajasinbordeb" style="text-align: right;" size="20" type="text" name="CNsuscriptor#rsAllContratos.currentRow#"  maxlength="50" value="#rsAllContratos.CNsuscriptor#" tabindex="-1" />
			</td>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>No. Suscriptor<strong></strong></td>
			<td>
				<input  class="cajasinbordeb" style="text-align: right;" size="20" type="text" name="CNnumero#rsAllContratos.currentRow#"  maxlength="20" value="#rsAllContratos.CNnumero#" tabindex="-1" />			
			</td>
		  </tr>

		  <tr>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Tarifa B&aacute;sica</label></td>
			<td>
				<input type="text" name="PQtarifaBasica#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.PQtarifaBasica,',9.00')#" tabindex="-1" readonly />
			</td>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Derecho Horas Mensuales</label></td>
			<td>
				<input type="text" name="PQhorasBasica#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.PQhorasBasica,',9.00')#" tabindex="-1" readonly />
			</td>
		  </tr>
	
		  <tr>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Costo Hora Adicional</label></td>
			<td>
				<input type="text" name="PQprecioExc#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.PQprecioExc,',9.00')#" tabindex="-1" readonly />
			</td>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Cantidad de Correos</label></td>
			<td>
				<input type="text" name="CantidadCorreos#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.CantidadCorreos,',9.00')#" tabindex="-1" readonly />
			</td>
		  </tr>
	
		  <tr>
			<td align="#Attributes.alignEtiquetas#" nowrap>&nbsp;</td>
			<td>&nbsp;</td>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Cuota Mail</label></td>
			<td>
				<input type="text" name="PQmailQuota#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.PQmailQuota,'9')#" tabindex="-1" readonly /> KB
			</td>
		  </tr>
		  	<cfloop from="1" to="#maxServicios.cantidad#" index="iLog">
				<cfset loginid = "">
				<cfset valLogin = "">
				<cfif ListLen(logines) GTE iLog>
					<cfset loginid = ListGetAt(loginesid, iLog, ',')>
					<cfset valLogin = ListGetAt(logines, iLog, ',')>
				</cfif>
				<cfif len(loginid)>
				  <tr>
					<td align="#Attributes.alignEtiquetas#" nowrap><label><cf_traducir key="login">Login</cf_traducir>#iLog#</label></td>
					<td>
						#valLogin#
					</td>
					<td align="#Attributes.alignEtiquetas#" nowrap>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
		  		</cfif>
			</cfloop>
		  
		</cfloop>
	</cfif> <!--- rsCuenta.CUECUE GTE -1 --->
	</table>
</cfoutput>
