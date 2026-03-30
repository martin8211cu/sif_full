<!--- Parámetros del TAG --->
<cfparam name="Attributes.name" 			default="TESRPTCid"		type="string"> <!--- Nombre del código concepto --->
<cfparam name="Attributes.tabindex" 	default="" 					type="string">	<!--- número del tabindex --->
<cfparam name="Attributes.value" 		default="" 					type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.disabled" 	default="no" 				type="boolean"><!--- Lista de estados permitidos  --->
<cfparam name="Attributes.SNid" 		default="" 					type="string"> <!--- ID Socio Negocio --->
<cfparam name="Attributes.TESBid" 		default=""					type="string"> <!--- ID Beneficiario TES --->
<cfparam name="Attributes.CxP" 			default="yes"				type="boolean"><!--- Listar Pagos --->
<cfparam name="Attributes.CxC" 			default="no"				type="boolean"><!--- Listar Cobros --->
<cfparam name="Attributes.onchange" 	default=""					type="string"><!--- evento onchange --->
<cfparam name="Attributes.cf_CPdisabled" default=""					type="string"><!--- Viene del tag de Concepto de Pagos --->

<cfset LvarDisabled_Escoger	= "">
<cfset LvarDisabled_N_A		= "">
<cfset LvarDisabled_Datos	= "">
<cfif Attributes.cf_CPdisabled NEQ "">
	<cfif listGetAt(Attributes.cf_CPdisabled,1) EQ "S">
		<cfset LvarDisabled_Escoger	= "disabled">
	</cfif>
	<cfif listGetAt(Attributes.cf_CPdisabled,2) EQ "S">
		<cfset LvarDisabled_N_A		= "disabled">
	</cfif>
	<cfif listGetAt(Attributes.cf_CPdisabled,3) EQ "S">
		<cfset LvarDisabled_Datos	= "disabled">
	</cfif>
</cfif>

<cfoutput>
	<select 
		name="#Attributes.name#" 
		id="#Attributes.name#" 
		onchange="#Attributes.onchange#"
		<cfif Attributes.disabled> disabled </cfif>
		<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
	>
</cfoutput>

<cfif isdefined("Attributes.query")>
	<cfparam name="Attributes.query" type="query"> 	<!--- consulta por defecto --->
	<cfset LvarQuery = Attributes.query>
	<cfif isdefined("LvarQuery.#Attributes.name#")>
		<cfset Attributes.value = Attributes.query[Attributes.name]>
		<cfset Attributes.value = trim(Attributes.value)>
	<cfelseif isdefined("LvarQuery.TESRPTCid")>
		<cfset Attributes.value = trim(Attributes.query.TESRPTCid)>
	</cfif>
</cfif>
<cfif trim(Attributes.value) EQ "">
	<cfif isdefined("form.#Attributes.name#") AND form[attributes.name] NEQ "">
		<cfset Attributes.value = form[attributes.name]>
	</cfif>
</cfif>

<cfset LvarCid_default = "">
<cfif Attributes.SNid NEQ "">
	<cfquery name="rsSQL" datasource="#Session.DSN#" >
		select 	TESRPTCid, TESRPTCidCxC
		  from 	SNegocios
		 where 	SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.SNid#">
	</cfquery>
	<cfif rsSQL.TESRPTCid NEQ "" AND Attributes.CxP>
		<cfset LvarCid_default = rsSQL.TESRPTCid>
	<cfelseif rsSQL.TESRPTCidCxC NEQ "" AND Attributes.CxC>
		<cfset LvarCid_default = rsSQL.TESRPTCidCxC>
	</cfif>
<cfelseif Attributes.TESBid NEQ "">
	<cfquery name="rsSQL" datasource="#Session.DSN#" >
		select 	TESRPTCid
		  from 	TESbeneficiario
		 where 	TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.TESBid#">
	</cfquery>
	<cfif rsSQL.TESRPTCid NEQ "">
		<cfset LvarCid_default = rsSQL.TESRPTCid>
	</cfif>
</cfif>

<cfquery name="rsTESRPTconcepto" datasource="#Session.DSN#" >
	select 	TESRPTCid, 
			TESRPTCcodigo, 
			TESRPTCdescripcion
	  from 	TESRPTconcepto 
	 where 	CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	 <cfif LvarCid_default NEQ "">
		<!---and  TESRPTCid	= #LvarCid_default#--->
		<cfif Attributes.value EQ "">
			<cfset Attributes.value = LvarCid_default>
		</cfif>
	 </cfif>
	  and TESRPTCdevoluciones=0
	 <cfif Attributes.CxP>
	 	and TESRPTCcxp=1
	 </cfif>
	 <cfif Attributes.CxC>
	 	and TESRPTCcxc=1
	 </cfif>
	 order by TESRPTCcodigo
</cfquery>

<cfif rsTESRPTconcepto.recordCount EQ 0>
	 <cfif Attributes.CxP>
		<cfquery datasource="#Session.DSN#" >
			insert into	TESRPTconcepto (CEcodigo,TESRPTCcodigo,TESRPTCdescripcion,TESRPTCcxp,TESRPTCcxc) values (#Session.CEcodigo#,'CP','Concepto de Pago General',1,0)
		</cfquery>
	 </cfif>
	 <cfif Attributes.CxC>
		<cfquery datasource="#Session.DSN#" >
			insert into	TESRPTconcepto (CEcodigo,TESRPTCcodigo,TESRPTCdescripcion,TESRPTCcxp,TESRPTCcxc) values (#Session.CEcodigo#,'CC','Concepto de Cobro General',0,1)
		</cfquery>
	</cfif>

	<cfquery name="rsSQL" datasource="#Session.DSN#" >
		select 	count(1) as cantidad 
		  from 	TESRPTconcepto 
		 where 	CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		   and 	TESRPTCdevoluciones=1
	</cfquery>
	<cfif rsSQL.cantidad eq 0>
		<cfquery datasource="#Session.DSN#" >
			insert into	TESRPTconcepto (CEcodigo,TESRPTCcodigo,TESRPTCdescripcion,TESRPTCdevoluciones,TESRPTCcxp,TESRPTCcxc) values (#Session.CEcodigo#,'DA','Devoluciones de Anticipos',1,0,0)
		</cfquery>
	</cfif>
	<cfquery name="rsTESRPTconcepto" datasource="#Session.DSN#" >
		select 	TESRPTCid, 
				TESRPTCcodigo, 
				TESRPTCdescripcion
		  from 	TESRPTconcepto 
		 where 	CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			 <cfif Attributes.CxP>
				and TESRPTCcxp=1
			 </cfif>
			 <cfif Attributes.CxC>
				and TESRPTCcxc=1
			 </cfif>
			 and TESRPTCdevoluciones=0
		 order by TESRPTCcodigo
	</cfquery>
</cfif>

<cfset LvarTESRPTCid = ""> <!--- rsTESRPTconcepto.TESRPTCid>  --->

<cfif Attributes.cf_CPdisabled NEQ "">
	<cfoutput>
	<option value="-1" #LvarDisabled_Escoger#>(Escoger Concepto Pago)</option>
	<cfif LvarDisabled_Datos EQ ""> 
		<cfif attributes.value EQ "">
			<option value=""   #LvarDisabled_N_A# selected>(N/A para este movimiento)</option>
		<cfelse>
			<option value=""   #LvarDisabled_N_A#>(N/A para este movimiento)</option>
		</cfif>
	<cfelse>
		<option value=""   #LvarDisabled_N_A#>(N/A para esta cuenta)</option>
	</cfif>
	</cfoutput>
<cfelseif NOT isdefined("LvarCid_default")>
	<option value=""></option>
</cfif>
<cfoutput query="rsTESRPTconcepto"> 
	<option value="#rsTESRPTconcepto.TESRPTCid#"
		#LvarDisabled_Datos#
	<cfif Attributes.value NEQ "">
		<cfif trim(rsTESRPTconcepto.TESRPTCid) EQ trim(Attributes.value)>selected<cfset LvarTESRPTCid = rsTESRPTconcepto.TESRPTCid></cfif>
	</cfif>
	>						
		#rsTESRPTconcepto.TESRPTCcodigo# - #mid(rsTESRPTconcepto.TESRPTCdescripcion,1,30)#
	</option>
</cfoutput>
</select>

<cfset form[Attributes.name] = LvarTESRPTCid>
