<cfset def = QueryNew("CBid")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.query" 			default="#def#" type="query">   <!--- consulta por defecto --->
<cfparam name="Attributes.TESid" 			default="TESid" type="string">  <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.name" 			default="CBid" 	type="string">  <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.onChange" 		default="" 		type="string">  <!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.onClick" 			default="" 		type="string">  <!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.tabindex" 		default="" 		type="string">  <!--- número del tabindex --->
<cfparam name="Attributes.value" 			default="" 		type="string">  <!--- número del tabindex --->
<cfparam name="Attributes.disabled" 		default="no" 	type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.all" 				default="no" 	type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.none"				default="no" 	type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.Ccompuesto" 		default="no" 	type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.Dcompuesto" 		default="no" 	type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.cboTESMPcodigo"	default="" 		type="string"> 	<!--- Nombre del select que debe llenarse con Medio Pago  --->
<cfparam name="Attributes.destino"			default="false" type="boolean"> <!--- Titulo Destino  --->
<cfparam name="Attributes.CBid"				default="" 		type="string">
<cfparam name="Attributes.reintegro"		default="false" type="boolean"> <!--- Utilizar para Reintegro cuentas corrientes --->
<cfparam name="Attributes.soloBcos"			default="false" type="boolean"> <!--- Utilizar para Reintegro cuentas corrientes --->
<cfparam name="Attributes.soloTCEs"			default="false" type="boolean"> <!--- Utilizar para Reintegro cuentas corrientes --->
<cfparam name="Attributes.FiltroMcodigo"	default="" 		type="string">  <!---►►Lista de los Mcodigos permitidos◄◄ --->

<!--- Si aun no se ha seteado la session con la tesoreria actual, lo hacemos --->
<cfif not isdefined('session.Tesoreria.TESid')>
  <cfquery name="rsTesoreria" datasource="#session.dsn#">
		Select t.TESid
		  from TESempresas te
		  inner join Tesoreria t
			on t.TESid = te.TESid	
		 where te.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and t.EcodigoAdm	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset session.Tesoreria.TESid = rsTesoreria.TESid>
</cfif>
<cfset LvarTESid = session.Tesoreria[Attributes.TESid]>

<cfinclude template="../Utiles/sifConcat.cfm">

<cfquery name="rsSQL" datasource="#session.dsn#">
	insert into TEStipoMedioPago
		(TESTMPtipo, TESTMPdescripcion, TESTMPexplicacion, TESTMPformatoImpresion, TESTMPformatoArchivo, TESTMPcontrolFormulario)
	select 5, 'TCE', 'TCE = Pago con Tarjeta Credito', 	0, 0, 0		from dual where not exists (select 1 from TEStipoMedioPago where TESTMPtipo = 5)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into TESmedioPago (
			TESid, CBid, TESMPcodigo, TESTMPtipo, TESMPdescripcion, TESMPsoloManual, 
			TESTGcodigoTipo, TESTGtipoCtas, TESTGtipoConfirma
		)
	select 	t.TESid, t.CBid, 'TCE', 5, 'Pago con Tarjeta de Crédito Empresarial', 1, 
			10, 0, 2
	 from TEScuentasBancos t
		inner join CuentasBancos cp
			on cp.CBid = t.CBid
	where t.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESid#">	
      and cp.CBesTCE = 1
	  and (
	  		select count(1)
			  from TESmedioPago
			 where TESid = t.TESid
			   and CBid		= t.CBid
		) = 0
</cfquery>

<cfquery datasource="#session.dsn#" name="Request.rsTESctasBancos">
	select cp.CBesTCE,cp.CBid, cp.Ecodigo, mp.Miso4217, cp.CBcodigo, mep.Miso4217 as Miso4217Empresa, ep.Edescripcion #_Cat# ' - ' #_Cat# mp.Miso4217 #_Cat# ' - ' #_Cat# bp.Bdescripcion  #_Cat# ' - ' #_Cat# cp.CBcodigo as CBdescripcion
	 from TEScuentasBancos t
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
	where t.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESid#">	
	<cfif Attributes.reintegro>
	  and t.TESCBreintegrable = 1
	<cfelse>
	  and t.TESCBactiva = 1
	</cfif>
	<cfif Attributes.soloBcos>
	  and cp.CBesTCE = 0
	<cfelseif Attributes.soloTCEs>
	  and cp.CBesTCE = 1
	</cfif>

	<cfif Len(Trim(Attributes.cboTESMPcodigo)) GT 0>
	  and  (
				select count(1) from TESmedioPago mpg
				 where mpg.TESid = t.TESid
				   and mpg.CBid = t.CBid
	  		) > 0
	</cfif>
	<cfif Len(Trim(Attributes.CBid)) GT 0>
	  and  t.CBid = #Attributes.CBid#
	</cfif>
    <!---►►Filtro por Moneda◄◄--->
    <cfif LEN(TRIM(Attributes.FiltroMcodigo))>
    	and mp.Mcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.FiltroMcodigo#" list="yes">)
    </cfif>
	order by cp.CBesTCE, CBdescripcion
</cfquery>

<cfset LvarCBid = "">
<cfset LvarCBidSelected = "">
<cfif Request.rsTESctasBancos.recordcount EQ 0>
	<cfif Len(Trim(Attributes.cboTESMPcodigo)) GT 0>
		<font color="#FF0000" style="font-weight:bold;">No hay Cuentas con Medios de Pago definidas en la Tesorería</font>
	<cfelse>
		<font color="#FF0000" style="font-weight:bold;">No hay Cuentas con Medios de Pago definidas en la Tesorería</font>
	</cfif>
	<cfabort>
<cfelse>
	<cfif ListLen('Attributes.query.columnList') GT 0 and trim(Attributes.query.CBid) NEQ "">
		<cfset LvarCBid = Attributes.query.CBid>
	<cfelseif Attributes.value NEQ "">
		<cfset LvarCBid = Attributes.value>
	<cfelseif isdefined("form.#Attributes.name#")>
		<cfset LvarCBid = form[attributes.name]>
	<cfelseif isdefined("session.tesoreria.#Attributes.name#")>
		<cfset LvarCBid = session.tesoreria[attributes.name]>
	</cfif>
	<cfoutput>
	<select 
		name="#Attributes.name#" 
		id="#Attributes.name#" 
		<cfif Attributes.disabled> disabled </cfif>
		<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
		<cfif Len(Trim(Attributes.onChange)) GT 0> 
			onChange="javascript:#Attributes.onChange#<cfif Len(Trim(Attributes.cboTESMPcodigo)) GT 0>;sbCambiaTESCBid(this,'#Attributes.cboTESMPcodigo#','');</cfif>"	
		<cfelseif Len(Trim(Attributes.cboTESMPcodigo)) GT 0>
			onChange="javascript:sbCambiaTESCBid(this,'#Attributes.cboTESMPcodigo#','');"	
		</cfif>
		<cfif Len(Trim(Attributes.onClick)) GT 0> onClick="javascript:#Attributes.onClick#"	</cfif>
	>
	</cfoutput>
		<cfif attributes.all>
		<option value="">(Todas las Cuentas)</option>
		<cfelseif attributes.none>
		<option value="">(Escoja una Cuenta <cfif Attributes.destino>destino<cfelse>de Pago</cfif>)</option>
		</cfif>
		<cfset LvarPonerTCE = true>
		<cfoutput query="Request.rsTESctasBancos">
			<cfif CBesTCE EQ 1 AND LvarPonerTCE>
				<cfset LvarPonerTCE = false>
				<optgroup label="Tarjetas de Credito Empresarial">
			</cfif>
			<option value="#CBid#<cfif attributes.Ccompuesto>,#Ecodigo#,#Miso4217#,#Miso4217Empresa#</cfif>"
					<cfif trim(CBid) EQ trim(listFirst(LvarCBid))>selected<cfset LvarCBidSelected = Request.rsTESctasBancos.CBid></cfif>
				><cfif attributes.Dcompuesto>#CBdescripcion#<cfelse>#CBcodigo#</cfif></option>
		</cfoutput>
		<cfif NOT LvarPonerTCE>
			</optgroup>
		</cfif>
	</select>
</cfif>

<cfset session.Tesoreria[Attributes.name] = LvarCBidSelected>
<cfset form[Attributes.name] = LvarCBidSelected>