<!---trae las cuentas bancarias definidas en TESreintegroCB que es el catalogo de cuentas bancarias a reintegrar en Tesoreria--->
<cfset def = QueryNew("CBid")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.query" 		default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" 		default="CBid" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.onChange" 	default="" type="string"> <!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.onClick" 		default="" type="string"> <!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.tabindex" 	default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.value" 		default="" type="string"> <!--- valor --->
<cfparam name="Attributes.disabled" 	default="no" type="boolean"> <!--- desabilita el campo  --->
<cfparam name="Attributes.all" 			default="no" type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.none"			default="no" type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.Ccompuesto" 	default="no" type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.Dcompuesto" 	default="no" type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.destino"		default="false" type="boolean"> 	 <!--- Titulo Destino  --->

<cfinclude template="../Utiles/sifConcat.cfm">
<cfquery datasource="#session.dsn#" name="Request.rsTESctasBancos">
	select cp.CBid, cp.Ecodigo, mp.Miso4217, cp.CBcodigo, mep.Miso4217 as Miso4217Empresa, ep.Edescripcion #_Cat# ' - ' #_Cat# mp.Miso4217 #_Cat# ' - ' #_Cat# bp.Bdescripcion  #_Cat# ' - ' #_Cat# cp.CBcodigo as CBdescripcion
	 from TESreintegroCB t
		inner join CuentasBancos cp
			inner join Empresas ep
				inner join Monedas mep
					 on mep.Mcodigo = ep.Mcodigo
				 on ep.Ecodigo = cp.Ecodigo
			inner join Bancos bp
				 on bp.Bid = cp.Bid
			inner join Monedas mp
				 on mp.Ecodigo = cp.Ecodigo
				and mp.Mcodigo = cp.Mcodigo
			 on cp.CBid = t.CBid
	where t.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by CBdescripcion
</cfquery>

<cfset LvarCBid = "">
<cfset LvarCBidSelected = "">
<cfif Request.rsTESctasBancos.recordcount EQ 0>
	<font color="#FF0000" style="font-weight:bold;">No hay definidas Cuentas Bancarias para Reintegro</font>
	<cfabort>
<cfelse>
	<cfif ListLen('Attributes.query.columnList') GT 0 and trim(Attributes.query.CBid) NEQ "">
		<cfset LvarCBid = Attributes.query.CBid>
	<cfelseif Attributes.value NEQ "">
		<cfset LvarCBid = Attributes.value>
	<cfelseif isdefined("form.#Attributes.name#")>
		<cfset LvarCBid = form[attributes.name]>
	</cfif>
	<cfoutput>
	<select 
		name="#Attributes.name#" 
		id="#Attributes.name#" 
		<cfif Attributes.disabled> disabled </cfif>
		<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
		<cfif Len(Trim(Attributes.onChange)) GT 0> 
			onChange="javascript:#Attributes.onChange#"	
		</cfif>
		<cfif Len(Trim(Attributes.onClick)) GT 0> onClick="javascript:#Attributes.onClick#"	</cfif>
	>
	</cfoutput>
		<cfif attributes.all>
		<option value="">(Todas las Cuentas)</option>
		<cfelseif attributes.none>
		<option value="">(Escoja una Cuenta <cfif Attributes.destino>destino<cfelse>de Pago</cfif>)</option>
		</cfif>
		<cfoutput query="Request.rsTESctasBancos">
			<option value="#CBid#<cfif attributes.Ccompuesto>,#Ecodigo#,#Miso4217#,#Miso4217Empresa#</cfif>"
					<cfif trim(CBid) EQ trim(listFirst(LvarCBid))>selected<cfset LvarCBidSelected = Request.rsTESctasBancos.CBid></cfif>
				><cfif attributes.Dcompuesto>#CBdescripcion#<cfelse>#CBcodigo#</cfif></option>
		</cfoutput>
	</select>
</cfif>

<cfset form[Attributes.name] = LvarCBidSelected>
