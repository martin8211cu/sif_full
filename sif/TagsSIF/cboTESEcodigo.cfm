<cfset def = QueryNew("Ecodigo")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.query" 		default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.TESid" 		default="TESid" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.name" 		default="Ecodigo" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.onChange" 	default="" type="string"> <!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.tabindex" 	default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.value" 		default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.disabled" 	default="no" type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.Tipo" 		default="PAGO" type="string"> <!--- Empresas PAGO, Empresas TES=Tesoreria, Empresa CE=Cliente Empresarial --->

<cfset LvarTESid = session.Tesoreria[Attributes.TESid]>

<cfif Attributes.Tipo EQ "PAGO">
	<cfquery datasource="#session.dsn#" name="rsTESempresas">
		Select distinct ep.Ecodigo, ep.Edescripcion
		 from TEScuentasBancos t
			inner join CuentasBancos cp
				inner join Empresas ep
					 on ep.Ecodigo = cp.Ecodigo
			   on cp.CBid = t.CBid
		where t.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESid#">	
		  and t.TESCBactiva = 1
          and cp.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		order by ep.Edescripcion
	</cfquery>
	<cfif rsTESempresas.recordcount EQ 0>
		<font color="#FF0000" style="font-weight:bold;">No hay Cuentas de Pago definidas en la Tesorería</font>
		<cfabort>
	</cfif>
<cfelseif Attributes.Tipo EQ "TES">
	<cfquery datasource="#session.dsn#" name="rsTESempresas">
		Select	distinct te.Ecodigo, e.Edescripcion
		  from	TESempresas te
			inner join Empresas e
				 on e.Ecodigo = te.Ecodigo
		where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESid#">	
		UNION
		Select	te.Ecodigo, e.Edescripcion
		  from	TEScentrosFuncionales te
			inner join Empresas e
				 on e.Ecodigo = te.Ecodigo
		where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESid#">	
	</cfquery>
	<cfif rsTESempresas.recordcount EQ 0>
		<font color="#FF0000" style="font-weight:bold;">No hay Empresas ni Centros Funcionales definidos en la Tesorería</font>
		<cfabort>
	</cfif>
<cfelse>
	<cfquery datasource="#session.dsn#" name="rsTESempresas">
		Select e.Ecodigo, e.Edescripcion
		  from Empresas e
		 where cliente_empresarial = #session.CEcodigo#
	</cfquery>
	<cfif rsTESempresas.recordcount EQ 0>
		<cf_errorCode	code = "50587"
						msg  = "ERROR FATAL: No hay empresas definidas en el CEcodigo=@errorDat_1@"
						errorDat_1="#session.CEcodigo#"
		>
	</cfif>
</cfif>
<cfset LvarEcodigo = "">

<cfif ListLen('Attributes.query.columnList') GT 0 and trim(Attributes.query.Ecodigo) NEQ "">
	<cfset Attributes.value = Attributes.query.Ecodigo>
<cfelseif Attributes.value EQ "">
	<cfif isdefined("form.#Attributes.name#")>
		<cfset Attributes.value = form[attributes.name]>
	<cfelseif isdefined("session.tesoreria.#Attributes.name#")>
		<cfset Attributes.value = session.tesoreria[attributes.name]>
	</cfif>
</cfif>
<cfoutput>
<select 
	name="#Attributes.name#" 
	id="#Attributes.name#" 
	<cfif Attributes.disabled> disabled </cfif>
	<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
	<cfif Len(Trim(Attributes.onChange)) GT 0> onChange="javascript:#Attributes.onChange#"	</cfif>
>
</cfoutput>
	<option value="">(Todas las empresas)</option>
	<cfoutput query="rsTESempresas">
		<option value="#Ecodigo#"
			<cfif Attributes.value NEQ "">
				<cfif trim(Ecodigo) EQ trim(Attributes.value)>selected<cfset LvarEcodigo = rsTESempresas.Ecodigo></cfif>
			</cfif>
			>#Edescripcion#</option>
	</cfoutput>
</select>

<cfset session.Tesoreria[Attributes.name] = LvarEcodigo>
<cfset form[Attributes.name] = LvarEcodigo>


