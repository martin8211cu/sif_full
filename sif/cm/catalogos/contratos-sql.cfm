<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(true)>
<cfset LvarEsContratosMultiples = LvarOBJ_PrecioU.EsContratosMultiples()>
<!--- <cf_dump var=#form#> --->

<cfparam name="action" default="contratos-lista.cfm">

<cfparam name="form.ECestado" default="0">
 <cfif isdefined("form.CMFPid") and len(trim(form.CMFPid)) and CMFPid eq -1>
	<cfquery name="rsSNFormaPagoDias" datasource="#session.dsn#">
		select coalesce(SNvencompras, -1) as Dias
		from SNegocios
		where Ecodigo = #session.Ecodigo#
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfquery>
	<cfquery name="rsFormaPagoSocio" datasource="#session.DSN#" maxrows="1">
		select min(CMFPid) as CMFPid
		from CMFormasPago
		where Ecodigo = #session.ecodigo#
			and CMFPplazo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSNFormaPagoDias.Dias#">
	</cfquery>
	<cfif rsFormaPagoSocio.CMFPid neq "" and rsSNFormaPagoDias.Dias neq "">
		<cfset form.CMFPid = rsFormaPagoSocio.CMFPid>
		<cfset Form.ECplazocredito = rsSNFormaPagoDias.Dias>
	<cfelse>
		<cfset form.CMFPid = "">
		<cfset Form.ECplazocredito = rsSNFormaPagoDias.Dias>
	</cfif>
</cfif>

<cfif not isdefined("form.btnNuevoD")>
	<!--- Caso 1: Agregar Encabezado --->
	<cfif isdefined("form.btnAgregarE")>
		<cftransaction>
			<cfquery name="insert" datasource="#session.DSN#" >
				insert into EContratosCM( Ecodigo, SNcodigo, CMIid, ECdesc, ECfechaini, ECfechafin, ECfalta, Usucodigo, CMTOcodigo, Rcodigo, ECplazocredito,ECporcanticipo, ECtiempoentrega, ECaviso, CMFPid, Consecutivo, ECestado, Tramite)
				 values ( <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
						  <cfqueryparam value="#form.SNcodigo#" 	cfsqltype="cf_sql_integer">,
						  <cfif isdefined("form.CMIid") and len(trim(form.CMIid))><cfqueryparam value="#form.CMIid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						  <cfqueryparam value="#form.ECdesc#"  		cfsqltype="cf_sql_varchar">,
						  <cfqueryparam value="#LSParseDateTime(form.ECfechaini)#" cfsqltype="cf_sql_timestamp">,
						  <cfqueryparam value="#LSParseDateTime(form.ECfechafin)#" cfsqltype="cf_sql_timestamp">,
						  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						  <cfqueryparam value="#Form.CMTOcodigo#" cfsqltype="cf_sql_char">,
						  <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char" null="#Len(Trim(Form.Rcodigo)) EQ 0#">,
						  <cfqueryparam value="#Form.ECplazocredito#" cfsqltype="cf_sql_integer">,
						  <cfqueryparam value="#replace(Form.ECporcanticipo,',','')#" cfsqltype="cf_sql_money">,
						  <cfif isdefined("form.ECtiempoentrega") and len(trim(form.ECtiempoentrega))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECtiempoentrega#"><cfelse>null</cfif>,
						  <cfif isdefined("form.ECaviso") and len(trim(form.ECaviso))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECaviso#"><cfelse>null</cfif>,
						  <cfif isdefined("form.CMFPid") and len(trim(form.CMFPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMFPid#"><cfelse>null</cfif>,
						  <cfqueryparam value="#Form.ConsecutivoContrato#" cfsqltype="cf_sql_numeric">,
						  <cfqueryparam value="#form.ECestado#" cfsqltype="cf_sql_bit">,
						  <cfif isdefined("form.ID_Tramite") and len(trim(form.ID_Tramite))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_Tramite#"><cfelse>null</cfif>
						)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		</cftransaction>
		<cfset modo="CAMBIO">
		<cfset action = "contratos.cfm">
	<!--- Caso 2: Borrar un Encabezado de Requisicion --->
	<cfelseif isdefined("form.btnBorrarE")>
		<cfquery name="deleted" datasource="#session.DSN#" >
			delete from DContratosCM
			where ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
			  and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="delete" datasource="#session.DSN#" >
			delete from EContratosCM
			where ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
			  and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset modo="ALTA">
	<!--- Caso 3: Agregar Detalle de Solicitud y opcionalmente modificar el encabezado --->
	<cfelseif isdefined("form.btnAgregarD")>
		<cfif NOT LvarEsContratosMultiples>
			<cfquery name="rsValidaContrato_0" datasource="#session.DSN#">
				select count(1) as cant
				from EContratosCM ec
					inner join DContratosCM  dc
					  on ec.ECid = dc.ECid
					  and ec.Ecodigo = dc.Ecodigo
					inner join SNegocios b
					  on ec.Ecodigo = b.Ecodigo
					  and ec.SNcodigo = b.SNcodigo
				where ec.Ecodigo = <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">
				  <cfif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'A'>
						and dc.Aid=<cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">
				  <cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'S'>
						and dc.Cid=<cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric">
				  </cfif>
				  and  (<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.ECfechaini)#"> between ec.ECfechaini
				  and ec.ECfechafin
					or <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.ECfechafin)#"> between ec.ECfechaini
				  and ec.ECfechafin)
			</cfquery>


			<cfquery name="rsValidaContrato" datasource="#session.DSN#">
				select ec.ECfechaini , ec.ECfechafin ,b.SNnumero, b.SNnombre
				from EContratosCM ec
					inner join DContratosCM  dc
					  on ec.ECid = dc.ECid
					  and ec.Ecodigo = dc.Ecodigo
					inner join SNegocios b
					  on ec.Ecodigo = b.Ecodigo
					  and ec.SNcodigo = b.SNcodigo
				where ec.Ecodigo = <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">

				  <cfif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'A'>
						and dc.Aid=<cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">
				  <cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'S'>
						and dc.Cid=<cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric">
				  </cfif>
				  and  (<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.ECfechaini)#"> between ec.ECfechaini
				  and ec.ECfechafin
					or <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.ECfechafin)#"> between ec.ECfechaini
				  and ec.ECfechafin)
			</cfquery>
		<cfelse>
			<cfquery name="rsValida" datasource="#session.DSN#">
				select ec.ECfechaini , ec.ECfechafin ,b.SNnumero, b.SNnombre, dc.DCdescripcion, u.Udescripcion
				from EContratosCM ec
					inner join DContratosCM  dc
					  on ec.ECid = dc.ECid
					  and ec.Ecodigo = dc.Ecodigo
					inner join SNegocios b
					  on ec.Ecodigo = b.Ecodigo
					  and ec.SNcodigo = b.SNcodigo
					inner join Unidades u
						on dc.Ucodigo = u.Ucodigo
						and dc.Ecodigo = u.Ecodigo
				where ec.Ecodigo = <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">
					and ec.SNcodigo = <cfqueryparam value="#form.SNCodigo#" cfsqltype="cf_sql_numeric">
					and dc.Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ucodigo#">
				  <cfif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'A'>
						and dc.Aid=<cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">
				  <cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'S'>
						and dc.Cid=<cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric">
				  </cfif>
				  and  (<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.ECfechaini)#"> between ec.ECfechaini
				  and ec.ECfechafin
					or <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.ECfechafin)#"> between ec.ECfechaini
				  and ec.ECfechafin)
			</cfquery>
			<cfif rsValida.recordCount NEQ 0>
				<cf_errorCode	code = "50256"
								msg  = "El bien que desea ingresar '@errorDat_1@', con la unidad de medida '@errorDat_2@', con el proveedor '@errorDat_3@' ya existe en un contrato vigente "
								errorDat_1="#rsValida.DCdescripcion#"
								errorDat_2="#rsValida.Udescripcion#"
								errorDat_3="#rsValida.SNnombre#"
				>
			</cfif>
		</cfif>

		<cfquery name="rsValida" datasource="#session.DSN#" >
			select   case DCtipoitem
					when 'A' then 'Articulo'
					when 'S' then 'Servicio'
					when 'F' then 'Activo Fijo'
				end DCtipoitem
				, Mnombre
			from DContratosCM a
				inner join Monedas b
						on a.Ecodigo=b.Ecodigo
								and a.Mcodigo=b.Mcodigo
			where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and ECid=<cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
				and a.Mcodigo=<cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">
				and DCtipoitem=<cfqueryparam value="#form.DCtipoitem#" cfsqltype="cf_sql_char">
				<cfif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'A'>
					and Aid=<cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">
				<cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'S'>
					and Cid=<cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric">
				<cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'F'>
					<cfif isdefined('form.ACcodigo') and form.ACcodigo neq ''
						and isdefined('form.ACid') and form.ACid neq ''>
							and ACcodigo=<cfqueryparam value="#form.ACcodigo#" cfsqltype="cf_sql_numeric">
							and ACid=<cfqueryparam value="#form.ACid#" cfsqltype="cf_sql_numeric">
					</cfif>
				</cfif>
		</cfquery>

		<cfif isdefined('rsValida') and rsValida.recordCount GT 0 or  isdefined('rsValidaContrato') and rsValidaContrato_0.cant GT 0>
			<cfset nombreError = ''>

			<cfquery name="rsNombres" datasource="#session.DSN#" >
				<cfif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'A'>
					select Adescripcion, Acodigo
					from Articulos
					where Aid=<cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">
						and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				<cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'S'>
					select Cdescripcion, Ccodigo
					from Conceptos
					where Cid=<cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric">
						and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				<cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'F'>
					<cfif isdefined('form.ACcodigo') and form.ACcodigo neq ''>
						select ACdescripcion
						from ACategoria
						where Ecodigo =<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and ACcodigo=<cfqueryparam value="#form.ACcodigo#" cfsqltype="cf_sql_numeric">
					</cfif>
				</cfif>
			</cfquery>

			<cfif isdefined('rsNombres') and rsNombres.recordCount GT 0>
				<cfif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'A'>
					<cfset nombreError = rsNombres.Adescripcion>
					<cfset codigoError = rsNombres.Acodigo>
				<cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'S'>
					<cfset nombreError = rsNombres.Cdescripcion>
					<cfset codigoError = rsNombres.Ccodigo>
				<cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'F'>
					<cfset nombreError = rsNombres.ACdescripcion>
				</cfif>
				<cfset nombreSocio = #trim(rsValidaContrato.SNnumero)# & "- " & #trim(rsValidaContrato.SNnombre)#>

			</cfif>

			<cfif isdefined('rsValida') and rsValida.recordCount GT 0>
				<cfoutput>
					<cf_errorCode	code = "50257"
									msg  = "Ya existe una línea para la moneda '@errorDat_1@' para el tipo de rubro '@errorDat_2@' y para '@errorDat_3@'"
									errorDat_1="#rsValida.Mnombre#"
									errorDat_2="#rsValida.DCtipoitem#"
									errorDat_3="#nombreError#"
					>
				</cfoutput>
			</cfif>
			<cfif NOT LvarEsContratosMultiples>
				<cfif isdefined('rsValidaContrato') and rsValidaContrato_0.cant GT 0>
					<cfif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'A'>
						<cfset NombItem = "Artículo">
					<cfelseif isdefined('form.DCtipoitem') and form.DCtipoitem EQ 'S'>
						<cfset NombItem = "Servicio">
					</cfif>

					<cf_errorCode	code = "50258"
									msg  = "Ya existe un contrato para el @errorDat_1@ @errorDat_2@-@errorDat_3@. <br>Del proveedor @errorDat_4@.<BR> <br>Entre las fechas @errorDat_5@ y @errorDat_6@"
									errorDat_1="#NombItem#"
									errorDat_2="#codigoError#"
									errorDat_3="#nombreError#"
									errorDat_4="#nombreSocio#"
									errorDat_5="#LSDateFormat(rsValidaContrato.ECfechaini,"dd/MM/yyyy")#"
									errorDat_6="#LSDateFormat(rsValidaContrato.ECfechafin,"dd/MM/yyyy")#"
					>
				</cfif>
			</cfif>
		<cfelse>
			<cfquery name="insertd" datasource="#session.DSN#" >
				insert into DContratosCM( ECid, Ecodigo, DCtipoitem, Aid, Cid, ACcodigo, ACid, DCpreciou, Mcodigo, DCtc, DCgarantia, DCdescripcion, DCdescalterna, Icodigo, Ucodigo, DCcantcontrato, DCcantsurtida, DCdiasEntrega)
				values ( <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#form.DCtipoitem#" cfsqltype="cf_sql_char">,
						 <cfif len(trim(form.Aid)) ><cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						 <cfif len(trim(form.Cid)) and form.DCtipoitem eq 'S' ><cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						 <cfif isdefined("form.ACcodigo") and form.DCtipoitem eq 'F'><cfqueryparam value="#form.ACcodigo#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
						 <cfif isdefined("form.ACid") and form.DCtipoitem eq 'F'><cfqueryparam value="#form.ACid#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
						 #LvarOBJ_PrecioU.enCF(form.DCpreciou)#,
						 <cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#form.DCtc#" cfsqltype="cf_sql_float">,
						 <cfqueryparam value="#form.DCgarantia#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#form.DCdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#form.DCdescalterna#" cfsqltype="cf_sql_varchar">,
						 <cfif len(trim(form.Limpuestos))><cfqueryparam cfsqltype="cf_sql_char" value="#form.Limpuestos#"></cfif>,
						 <cfif isdefined("form.Ucodigo") and len(trim(form.Ucodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.Ucodigo#"><cfelse>null</cfif>,
						 <cfif isdefined("form.DCcantcontrato") and len(trim(form.DCcantcontrato))><cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.DCcantcontrato,',','','all')#"><cfelse>0</cfif>,
						 <cfif isdefined("form.DCcantsurtida") and len(trim(form.DCcantsurtida))><cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.DCcantsurtida,',','','all')#"><cfelse>0</cfif>,
						 <cfif isdefined("form.DCdiasEntrega") and len(trim(form.DCdiasEntrega))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.DCdiasEntrega,',','','all')#"><cfelse>0</cfif>
				)
			</cfquery>

			<cf_dbtimestamp datasource="#session.dsn#"
							table="EContratosCM"
							redirect="contratos-lista.cfm"
							timestamp="#form.ts_rversion#"
							field1="ECid"
							type1="numeric"
							value1="#form.ECid#"
							field2="Ecodigo"
							type2="integer"
							value2="#session.Ecodigo#" >

			<cfquery name="update" datasource="#session.DSN#">
				update EContratosCM
				set ECdesc     = <cfqueryparam value="#form.ECdesc#"  cfsqltype="cf_sql_varchar">,
					ECfechaini = <cfqueryparam value="#LSParseDateTime(form.ECfechaini)#" cfsqltype="cf_sql_timestamp">,
					ECfechafin = <cfqueryparam value="#LSParseDateTime(form.ECfechafin)#" cfsqltype="cf_sql_timestamp">,
					CMTOcodigo = <cfqueryparam value="#Form.CMTOcodigo#" cfsqltype="cf_sql_char">,
					Rcodigo = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char" null="#Len(Trim(Form.Rcodigo)) EQ 0#">,
					CMFPid = <cfif isdefined("Form.CMFPid") and len(trim(Form.CMFPid))><cfqueryparam value="#Form.CMFPid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
					ECplazocredito = <cfqueryparam value="#Form.ECplazocredito#" cfsqltype="cf_sql_integer">,
					ECporcanticipo = <cfqueryparam value="#replace(Form.ECporcanticipo,',','')#" cfsqltype="cf_sql_money">,
					ECtiempoentrega = <cfif isdefined("form.ECtiempoentrega") and len(trim(form.ECtiempoentrega))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECtiempoentrega#"><cfelse>null</cfif>,
					CMIid = <cfif isdefined("form.CMIid") and len(trim(form.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#"><cfelse>null</cfif>,
					ECaviso = <cfif isdefined("form.ECaviso") and len(trim(form.ECaviso))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECaviso#"><cfelse>null</cfif>,
					ECestado = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.ECestado#">,
					Tramite = <cfif isdefined("form.ID_Tramite") and len(trim(form.ID_Tramite))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Tramite#"><cfelse>null</cfif>
				where ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>

		<cfset modo="CAMBIO">
		<cfset action = "contratos.cfm">
	<!--- Caso 4: Modificar Detalle de Requisicion y opcionalmente modificar el encabezado --->
	<cfelseif isdefined("Form.btnCambiarD")>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="DContratosCM"
						redirect="contratos-lista.cfm"
						timestamp="#form.dtimestamp#"
						field1="DClinea"
						type1="numeric"
						value1="#form.DClinea#"
						field2="Ecodigo"
						type2="integer"
						value2="#session.Ecodigo#" >

		<cfquery name="updated" datasource="#session.DSN#">
			update DContratosCM
			set Aid           = <cfif form.DCtipoitem eq 'A' and len(trim(form.Aid)) ><cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				Cid           = <cfif form.DCtipoitem eq 'S' and len(trim(form.Cid)) ><cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				ACcodigo      = <cfif form.DCtipoitem eq 'F' and isdefined("form.ACcodigo") ><cfqueryparam value="#form.ACcodigo#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
				ACid          = <cfif form.DCtipoitem eq 'F' and isdefined("form.ACid") ><cfqueryparam value="#form.ACid#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
				DCdescripcion = <cfqueryparam value="#form.DCdescripcion#" cfsqltype="cf_sql_varchar">,
				DCdescalterna =	<cfif len(trim(form.DCdescalterna)) ><cfqueryparam value="#form.DCdescalterna#" cfsqltype="cf_sql_longvarchar"><cfelse>null</cfif>,
				DCpreciou 	  = #LvarOBJ_PrecioU.enCF(form.DCpreciou)#,
				Mcodigo       = <cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">,
				DCtc	 	  =	<cfqueryparam value="#form.DCtc#" cfsqltype="cf_sql_float">,
				DCgarantia	  = <cfqueryparam value="#form.DCgarantia#" cfsqltype="cf_sql_integer">,
				Icodigo 	  = <cfif len(trim(form.Limpuestos))><cfqueryparam cfsqltype="cf_sql_char" value="#form.Limpuestos#"></cfif>,
				Ucodigo = <cfif isdefined("form.Ucodigo") and len(trim(form.Ucodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.Ucodigo#"><cfelse>null</cfif>,
				DCcantcontrato = <cfif isdefined("form.DCcantcontrato") and len(trim(form.DCcantcontrato))><cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.DCcantcontrato,',','','all')#"><cfelse>0</cfif>,
				<!----,DCcantsurtida = <cfif isdefined("form.DCcantsurtida") and len(trim(form.DCcantsurtida))><cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.DCcantsurtida,',','','all')#"><cfelse>0</cfif>---->
				DCdiasEntrega = <cfif isdefined("form.DCdiasEntrega") and len(trim(form.DCdiasEntrega))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.DCdiasEntrega#"><cfelse>null</cfif>
			where DClinea = <cfqueryparam value="#form.DClinea#" cfsqltype="cf_sql_numeric" >
			  and ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
			  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
		</cfquery>

		<cf_dbtimestamp datasource="#session.dsn#"
						table="EContratosCM"
						redirect="contratos-lista.cfm"
						timestamp="#form.ts_rversion#"
						field1="ECid"
						type1="numeric"
						value1="#form.ECid#"
						field2="Ecodigo"
						type2="integer"
						value2="#session.Ecodigo#" >

		<cfquery name="update" datasource="#session.DSN#">
			update EContratosCM
			set ECdesc     = <cfqueryparam value="#form.ECdesc#"  cfsqltype="cf_sql_varchar">,
				ECfechaini = <cfqueryparam value="#LSParseDateTime(form.ECfechaini)#" cfsqltype="cf_sql_timestamp">,
				ECfechafin = <cfqueryparam value="#LSParseDateTime(form.ECfechafin)#" cfsqltype="cf_sql_timestamp">,
				<!--- ????? ---->
				ECtiempoentrega = <cfif isdefined("form.ECtiempoentrega") and len(trim(form.ECtiempoentrega))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECtiempoentrega#"><cfelse>null</cfif>,
				CMIid = <cfif isdefined("form.CMIid") and len(trim(form.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#"><cfelse>null</cfif>,
				ECaviso = <cfif isdefined("form.ECaviso") and len(trim(form.ECaviso))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECaviso#"><cfelse>null</cfif>,
				<!--- ????? ---->
				 ECestado = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.ECestado#">,<!--- Estado del Contrato --->
				 Tramite = <cfif isdefined("form.ID_Tramite") and len(trim(form.ID_Tramite))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Tramite#"><cfelse>null</cfif>
			where ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
			  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfset modo="CAMBIO">
		<cfset action = "contratos.cfm">
	<!--- Caso 5: Borrar detalle de Contrato --->
	<cfelseif isdefined("Form.btnBorrarD")>
		<!---Verificar que el contrato no haya empezado a ser surtido----->
		<cfif isdefined("form.DCcantsurtida") and form.DCcantsurtida NEQ 0>
			<cf_errorCode	code = "50259" msg = "La línea del contrato no puede ser eliminada pues tiene cantidades surtidas">
		<cfelse>
			<cfquery name="deleted" datasource="#session.DSN#">
				delete from DContratosCM
				where DClinea = <cfqueryparam value="#form.DClinea#" cfsqltype="cf_sql_numeric" >
				  and ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
			</cfquery>
		</cfif>

		<cfset modo="CAMBIO">
		<cfset action = "contratos.cfm">
	<!--- Caso 6: Modificar Encabezado --->
	<cfelseif isdefined("Form.btnCambiarE")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="EContratosCM"
							redirect="contratos-lista.cfm"
							timestamp="#form.ts_rversion#"
							field1="ECid"
							type1="numeric"
							value1="#form.ECid#"
							field2="Ecodigo"
							type2="integer"
							value2="#session.Ecodigo#" >

			<cfquery name="update" datasource="#session.DSN#">
				update EContratosCM
				set ECdesc     = <cfqueryparam value="#form.ECdesc#"  cfsqltype="cf_sql_varchar">,
					ECfechaini = <cfqueryparam value="#LSParseDateTime(form.ECfechaini)#" cfsqltype="cf_sql_timestamp">,
					ECfechafin = <cfqueryparam value="#LSParseDateTime(form.ECfechafin)#" cfsqltype="cf_sql_timestamp">,
					CMTOcodigo = <cfqueryparam value="#Form.CMTOcodigo#" cfsqltype="cf_sql_char">,
					Rcodigo = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char" null="#Len(Trim(Form.Rcodigo)) EQ 0#">,
					CMFPid = <cfif isdefined("form.CMFPid") and len(trim(form.CMFPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMFPid#"><cfelse>null</cfif>,
					ECplazocredito = <cfqueryparam value="#Form.ECplazocredito#" cfsqltype="cf_sql_integer">,
					ECporcanticipo = <cfqueryparam value="#Form.ECporcanticipo#" cfsqltype="cf_sql_money">,
					ECtiempoentrega = <cfif isdefined("form.ECtiempoentrega") and len(trim(form.ECtiempoentrega))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECtiempoentrega#"><cfelse>null</cfif>,
					CMIid = <cfif isdefined("form.CMIid") and len(trim(form.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#"><cfelse>null</cfif>,
					ECaviso = <cfif isdefined("form.ECaviso") and len(trim(form.ECaviso))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECaviso#"><cfelse>null</cfif>,
					<!---ECestado = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.ECestado#"> --->
					Tramite = <cfif isdefined("form.ID_Tramite") and len(trim(form.ID_Tramite))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Tramite#"><cfelse>null</cfif>
					where ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
	<!--- Caso 7: Aplicar Contrato --->
	<cfelseif isdefined("Form.btnAplicar")>
		<cfinvoke component="/sif/Componentes/Contrato" method="init" returnvariable="Contrato" />
		<cfif isDefined("form.id_tramite") and LEN(TRIM(form.id_tramite))>
			<cftransaction>
				<cfset UpdContrato = Contrato.setEstado(Form.ECid,1)>
				<cfset UpdTramCont = Contrato.setTramite(Form.ECid,Form.id_tramite)>
				<!--- Iniciar trámite solamente si no ha sido iniciado --->
				<cfset dataItems = StructNew()>
				<cfset dataItems.ECId 			= Form.ECId>
				<cfset dataItems.Ecodigo		= session.Ecodigo>
				<!--- <cfset dataItems.ECestado	= 4> --->
				<cfset descripcion_tramite		= 'Aprobación de contrato No. ' & Form.CONSECUTIVOCONTRATO & '<br>Solicitada por: ' & session.usulogin>
				<cfinvoke component="sif.Componentes.Workflow.Management" method="startProcess" returnvariable="processInstanceId">
					<cfinvokeargument name="ProcessId"			value="#Form.id_tramite#">
					<cfinvokeargument name="RequesterId" 		value="#session.usucodigo#">
					<cfinvokeargument name="SubjectId"			value="#session.usucodigo#">
					<cfinvokeargument name="Description"		value="#descripcion_tramite#">
					<cfinvokeargument name="DataItems"			value="#dataItems#">
					<cfinvokeargument name="ObtenerUltimaVer"   value="true">
				</cfinvoke>
			</cftransaction>
		<cfelse>
			<cfset UpdContrato = Contrato.setEstado(Form.ECid,2)>
		</cfif>

		<cfset modo="CAMBIO">
		<cfset action = "contratos-lista.cfm">
	<cfelseif isdefined("Form.Cancel")>
		<cfinvoke component="/sif/Componentes/Contrato" method="init" returnvariable="Contrato" />
		<cftransaction>
			<cfset UpdContrato = Contrato.setEstado(Form.ECid,3)>
			<!--- set motivo --->
			<cfset UpdMotivo   = Contrato.setMotivo(Form.ECid,Form.Motivo)>
		</cftransaction>
		<cfset modo="CAMBIO">
		<cfset action = "contratosEditar-lista.cfm">
	</cfif>
<cfelse>
	<cfset action= "contratos.cfm">
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="ECid" type="hidden" value="<cfif isdefined("form.ECid") and len(trim(form.ECid))>#form.ECid#<cfelseif isdefined("form.btnAgregarE")>#insert.identity#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>



<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

