<cfparam name="action" default="ListaPrecios-lista.cfm">

<cfif not isdefined("form.NuevoDet")>
	<!--- Caso 1: Agregar Encabezado --->
	<cfif isdefined("form.AgregarEnc")>
		<cftransaction>
			<cfquery name="insert" datasource="sifpublica" >
				insert into EListaPrecios( ELPUsucodigo, CEcodigo, Usucodigo, fechaalta, ELPfdesde, ELPfhasta, Estado, ELPdescripcion, Observaciones, ELPplazocredito, ELPincimpuestos )
					values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ELPfdesde)#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ELPfhasta)#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Estado#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ELPdescripcion#">, 
							<cfif len(trim("form.Observaciones"))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#" >,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ELPplazocredito#">,
							<cfif isdefined("Form.ELPincimpuestos")>1<cfelse>0</cfif>
					)
				<cf_dbidentity1 datasource="sifpublica">
			</cfquery>	
			<cf_dbidentity2 datasource="sifpublica" name="insert">
		</cftransaction>
		<cfset modoE = "CAMBIO">
		<cfset action = "ListaPrecios.cfm">
		
	<!--- Caso 2: Borrar un Encabezado de Lista de Precios --->
	<cfelseif isdefined("form.BorrarEnc")>
		<!--- Borra primeramente el Detalle de la Lista de Precios --->
		<cfquery name="deleted" datasource="sifpublica" >
			delete from DListaPrecios
			where ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#" >			
		</cfquery>
		
		<!--- Luego borra el Encabezado de Lista de Precios --->
		<cfquery name="delete" datasource="sifpublica" >
			delete from EListaPrecios
			where CEcodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.cecodigo#" >
			  and ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#" >			
		</cfquery>	  
		<cfset modoE = "ALTA">
		  
	<!--- Caso 3: Agregar Detalle de la Lista de Precios y opcionalmente Modificar el encabezado --->
	<cfelseif isdefined("form.AgregarDet")>
		<cftransaction>
			<cfquery name="insertd" datasource="sifpublica" >
				insert into DListaPrecios( ELPid, DLPcodigo, DLPdescripcion, DLPdescalterna, DLPobservaciones, DLPcodbarras, DLPgarantia, DLPplazoentrega, DLPplazocredito, DLPprecio, DLPunidad, DLPclase, Mcodigo, DLPporcimpuesto, Usucodigo, fechaalta )
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.DLPcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DLPdescripcion#">,
							<cfif len(trim("form.DLPdescalterna"))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DLPdescalterna#">,
							<cfelse>
								null,
							</cfif>
							<cfif len(trim("form.DLPobservaciones"))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DLPobservaciones#">,
							<cfelse>
								null,
							</cfif>
							<cfif len(trim("form.DLPcodbarras"))>
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.DLPcodbarras#">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DLPgarantia#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DLPplazoentrega#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DLPplazocredito#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.DLPprecio#">,
							<cfif len(trim("form.DLPunidad"))>
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.DLPunidad#">,
							<cfelse>
								null,
							</cfif>
							<cfif len(trim("form.DLPclase"))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DLPclase#">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#form.DLPporcimpuesto#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="sifpublica">
			</cfquery>
			<cf_dbidentity2 datasource="sifpublica" name="insertd">
		</cftransaction>

		<cf_dbtimestamp datasource="sifpublica"
						table="EListaPrecios"
						redirect="ListaPrecios-lista.cfm"
						timestamp="#form.ts_rversion#"
						field1="ELPid" 
						type1="numeric" 
						value1="#form.ELPid#"
						field2="CEcodigo" 
						type2="numeric" 
						value2="#session.cecodigo#" >

		<cfquery name="update" datasource="sifpublica">
			update EListaPrecios
			set ELPfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ELPfdesde)#">,
				ELPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ELPfhasta)#">,
				Estado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Estado#">,
				ELPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ELPdescripcion#">,
				Observaciones = <cfif len(trim("form.DLPobservaciones"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#"><cfelse>null</cfif>,
				ELPplazocredito = <cfif isdefined("form.ELPplazocredito")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ELPplazocredito#"><cfelse>null</cfif>,
				ELPincimpuestos = <cfif isdefined("Form.ELPincimpuestos")>1<cfelse>0</cfif>
			where ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
		</cfquery>
		<cfset modoE = "CAMBIO">
		<cfset action = "ListaPrecios.cfm">

	<!--- Caso 4: Modificar Detalle de la Lista de Precios y opcionalmente modificar el encabezado --->			
	<cfelseif isdefined("Form.CambiarDet")>
		<cf_dbtimestamp datasource="sifpublica"
						table="DListaPrecios"
						redirect="ListaPrecios-lista.cfm"
						timestamp="#form.dts_timestamp#"
						field1="DLPlinea" 
						type1="numeric" 
						value1="#form.DLPlinea#"
						field2="ELPid" 
						type2="numeric" 
						value2="#form.ELPid#" >

		<cfquery name="updated" datasource="sifpublica">
			update DListaPrecios
			set DLPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DLPcodigo#">,
				DLPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DLPdescripcion#">,
				DLPdescalterna = <cfif len(trim("form.DLPdescalterna"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DLPdescalterna#"><cfelse>null</cfif>,
				DLPobservaciones = <cfif len(trim("form.DLPobservaciones"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DLPobservaciones#"><cfelse>null</cfif>,
				DLPcodbarras = <cfif len(trim("form.DLPcodbarras"))><cfqueryparam cfsqltype="cf_sql_char" value="#form.DLPcodbarras#"><cfelse>null</cfif>, 
				DLPgarantia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DLPgarantia#">,
				DLPplazoentrega = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DLPplazoentrega#">,
				DLPplazocredito = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DLPplazocredito#">,
				DLPprecio = <cfqueryparam cfsqltype="cf_sql_money" value="#form.DLPprecio#">,
				DLPunidad = <cfif len(trim("form.DLPunidad"))><cfqueryparam cfsqltype="cf_sql_char" value="#form.DLPunidad#"><cfelse>null</cfif>,
				DLPclase = <cfif len(trim("form.DLPclase"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DLPclase#"><cfelse>null</cfif>,
				Mcodigo = <cfif isdefined("form.Mcodigo")><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#"><cfelse>null</cfif>,
				DLPporcimpuesto = <cfif isdefined("form.DLPporcimpuesto")><cfqueryparam cfsqltype="cf_sql_float" value="#form.DLPporcimpuesto#"><cfelse>null</cfif>
			where DLPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLPlinea#">
			  and ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#">
		</cfquery>

		<cf_dbtimestamp datasource="sifpublica"
						table="EListaPrecios"
						redirect="ListaPrecios-lista.cfm"
						timestamp="#form.ts_rversion#"
						field1="ELPid" 
						type1="numeric" 
						value1="#form.ELPid#"
						field2="CEcodigo" 
						type2="numeric" 
						value2="#session.cecodigo#" >

		<cfquery name="update" datasource="sifpublica">
			update EListaPrecios
			set ELPfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ELPfdesde)#">,
				ELPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ELPfhasta)#">,
				Estado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Estado#" >,
				ELPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ELPdescripcion#" >,
				Observaciones = <cfif len(trim("form.DLPobservaciones"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#"><cfelse>null</cfif>,
				ELPplazocredito = <cfif isdefined("form.ELPplazocredito")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ELPplazocredito#"><cfelse>null</cfif>,
				ELPincimpuestos = <cfif isdefined("Form.ELPincimpuestos")>1<cfelse>0</cfif>
			where ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#" >
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#" >

		</cfquery>
		<cfset modoE = "CAMBIO">
		<cfset action = "ListaPrecios.cfm">
		
	<!--- Caso 5: Borra el detalle de la Lista Precios --->
	<cfelseif isdefined("Form.BorrarDet")>
		<cfquery name="deleted" datasource="sifpublica">
			delete from DListaPrecios
			where DLPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLPlinea#">
			  and ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#">
		</cfquery>	
		<cfset modoE = "CAMBIO">
		<cfset action = "ListaPrecios.cfm">
	</cfif>
<cfelse>
	<cfset action= "ListaPrecios.cfm">
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="ELPid" type="hidden" value="<cfif isdefined("form.ELPid") and len(trim(form.ELPid))>#form.ELPid#<cfelseif isdefined("form.AgregarEnc")>#insert.identity#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>