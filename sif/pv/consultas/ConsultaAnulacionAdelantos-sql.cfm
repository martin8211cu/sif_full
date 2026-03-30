<cfquery name="rsDatos" datasource="#session.DSN#" maxrows="1001">
	select  e.FAM01CODD as CodigoCaja,
			b.Oficodigo as CodigoOficina,
			a.Documento as Documento,
			c.CDCidentificacion as IndentificacionCliente,
			c.CDCnombre as NombreCliente,
			a.BMfechaalta as FechaAnulacion, --formato dd/mm/yyyy hh:mi:ss (AM/PM)
			d.Miso4217 as Moneda,
			a.Monto as MontoAdelanto,
			f.Usulogin as LoginUsuarioAnulacion,
		 	a.FABAnulacionMotivo as MotivoDeAnulacion
			
	from FABitacoraAnulacionAd a 
		inner join Oficinas b
				on a.Ocodigo = b.Ocodigo and a.Ecodigo = b.Ecodigo
		inner join ClientesDetallistasCorp c
				on a.CDCcodigo = c.CDCcodigo
		inner join Monedas d
			on a.Mcodigo = d.Mcodigo
		inner join FAM001 e
				on a.FAM01COD = e.FAM01COD and a.Ecodigo = e.Ecodigo
		inner join Usuario f
				on a.BMUsucodigo = f.Usucodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01COD#">
	  	<!---Filtro de fechas---->		
		<cfif isdefined("url.fechadesde") and len(trim(url.fechadesde)) and isdefined("url.fechahasta") and len(trim(url.fechahasta))>
			<cfif url.fechadesde EQ url.fechahasta>
				and a.FABAnulacionFecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechadesde)#">
			<cfelseif url.fechadesde LT url.fechahasta>
				and a.FABAnulacionFecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechadesde)#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechahasta)#">
			<cfelse>
				and a.FABAnulacionFecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechahasta)#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechadesde)#">
			</cfif>
		</cfif>
		<cfif isdefined("url.fechadesde") and len(trim(url.fechadesde)) and not (isdefined("url.fechahasta") and len(trim(url.fechahasta)))>
			and a.FABAnulacionFecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechadesde)#">
		</cfif>		
		<cfif isdefined("url.fechahasta") and len(trim(url.fechahasta)) and not (isdefined("url.fechadesde") and len(trim(url.fechadesde)))>
			and a.FABAnulacionFecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechahasta)#">
		</cfif> 		
		<!---Filtro de documento ----->
	   	<cfif isdefined("url.Documento") and len(trim(url.Documento))>
			and a.Documento = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Documento#">			
		</cfif>
		<!---Filtro de cliente---->
	   	<cfif isdefined("url.CDCcodigo") and len(trim(url.CDCcodigo))>
			and a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo#">
		</cfif>
	order by a.Documento
</cfquery>

<cfif isdefined("rsDatos") and rsDatos.RecordCount EQ 0>
	<cfinclude template="POSDatosNoEncontrados.cfm">
</cfif>

<cfif isdefined("rsDatos") and rsDatos.RecordCount GT 1000>
	<cfinclude template="POSRegistrosExcedidos.cfm">
</cfif>

<!----Empresa----->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- Invocar reporte --->
<cfif isdefined("rsDatos") and rsDatos.RecordCount NEQ 0>
	<cfreport format="#url.formato#" template= "ConsultaAnulacionAdelantos.cfr" query="rsDatos">
		<cfreportparam name="Edescripcion" value="#session.enombre#">
	</cfreport>
</cfif>
