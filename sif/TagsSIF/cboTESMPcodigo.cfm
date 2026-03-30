<cfset def = QueryNew("CBid,TESMPcodigo")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.query" 		default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.TESid" 		default="TESid" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.CBid" 		default="CBid" 	type="string"> <!--- Nombre del ID Cuenta Bancos --->
<cfparam name="Attributes.name" 		default="TESMPcodigo" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.onChange" 	default="" type="string"> <!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.onClick" 		default="" type="string"> <!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.tabindex" 	default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.CBidValue" 	default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.value" 		default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.disabled" 	default="no" type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.Session"		default="yes" type="boolean"> 	 <!--- Nombre del select que debe llenarse con Medio Pago  --->
<cfparam name="Attributes.SoloChks"		default="no" type="boolean"> 	 <!--- Nombre del select que debe llenarse con Medio Pago  --->
<cfparam name="Attributes.NoChks"		default="no" type="boolean"> 	 <!--- Nombre del select que debe llenarse con Medio Pago  --->
<cfparam name="Attributes.SoloTipo"		default="-1" 	type="numeric"> 	 <!--- Nombre del select que debe llenarse con Medio Pago  --->
<cfparam name="Attributes.MultipleMP"	default="true" 	type="boolean"> 
<cfset LvarTESid = session.Tesoreria[Attributes.TESid]>

<cfinclude template="../Utiles/sifConcat.cfm">
 <cf_importJQuery>
<cfset LvarCBid = "">
<cfif ListLen('Attributes.query.columnList') GT 0 and trim(Attributes.query.CBid) NEQ "">
	<cfset LvarCBid = Attributes.query.CBid>
<cfelseif Attributes.CBidValue NEQ "">
	<cfset LvarCBid = Attributes.CBidValue>
<cfelseif isdefined("form.#Attributes.CBid#")>
	<cfset LvarCBid = form[attributes.CBid]>
<cfelseif isdefined("session.tesoreria.#Attributes.CBid#") and Attributes.Session>
	<cfset LvarCBid = session.tesoreria[attributes.CBid]>
</cfif>
<cfset session.tesoreria[attributes.CBid] = LvarCBid>

<cfset LvarTESMPcodigo = "">
<cfset LvarTESMPcodigoSelected = "">
<cfif LvarCBid NEQ "">
	<cfif ListLen('Attributes.query.columnList') GT 0 and trim(Attributes.query.TESMPcodigo) NEQ "">
		<cfset LvarTESMPcodigo = Attributes.query.TESMPcodigo>
	<cfelseif Attributes.value NEQ "">
		<cfset LvarTESMPcodigo = Attributes.value>
	<cfelseif isdefined("form.#Attributes.name#")>
		<cfset LvarTESMPcodigo = form[Attributes.name]>
	<cfelseif isdefined("session.tesoreria.#Attributes.name#") and Attributes.Session>
		<cfset LvarTESMPcodigo = session.tesoreria[Attributes.name]>
	</cfif>
</cfif>
<cfoutput>
<select 
	name="#Attributes.name#" 
	id="#Attributes.name#" 
	<cfif Attributes.disabled> disabled </cfif>
	<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
	<cfif Len(Trim(Attributes.onChange)) GT 0> onChange="javascript:#Attributes.onChange#" </cfif>
	<cfif Len(Trim(Attributes.onClick)) GT 0> onClick="javascript:#Attributes.onClick#"	</cfif>
>
</cfoutput>
<cfif LvarCBid NEQ "">
	<cfquery datasource="#session.dsn#" name="rsTESmedioPago">
		select 	rtrim(TESMPcodigo) as TESMPcodigo, 
				rtrim(TESMPdescripcion) #_Cat#
					case TESTMPtipo
						when 1 then ' (CHK)'
						when 2 then ' (TRI)'
						when 3 then ' (TRE)'
						when 4 then ' (TRM)'
						when 5 then ' '
						else ' (???)'
					end
				as TESMPdescripcion
		  from TESmedioPago mp
		 where mp.TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESid#">	
		   and mp.CBid	= #LvarCBid#
		<cfif Attributes.SoloChks>
					and mp.TESTMPtipo = 1
					and mp.TESMPsoloManual = 0
		</cfif>
		<cfif Attributes.SoloTipo NEQ  -1>
					and mp.TESTMPtipo = #Attributes.SoloTipo#
		</cfif>
		<cfif Attributes.NoChks>
					and mp.TESTMPtipo <> 1
		</cfif>
	</cfquery>
	<cfif rsTESmedioPago.recordCount NEQ 1>
		<option value="">(Escoja un Medio de Pago)</option>
	</cfif>
	<cfoutput query="rsTESmedioPago">
		<option value="#TESMPcodigo#"
				<cfif trim(TESMPcodigo) EQ trim(LvarTESMPcodigo)>selected<cfset LvarTESMPcodigoSelected = LvarTESMPcodigo></cfif>
			>#TESMPcodigo# - #TESMPdescripcion#</option>
	</cfoutput>
<cfelse>
		<option value="">(Escoja un Medio de Pago)</option>
</cfif>
</select>
<cfif not isdefined("request.sbCambiaTESCBid") AND isdefined("Request.rsTESctasBancos")>
	<cfoutput>
	<script language="javascript">
	<cfset request.sbCambiaTESCBid = true>
			var LvarMedioPago 		= new Object();
			var LvarTipoMedioPago 	= new Object();
			var LvarSoloManual 		= new Object();
			var LvarTiposCtas 		= new Object();
			
	<cfloop query="Request.rsTESctasBancos">
		<cfquery datasource="#session.dsn#" name="rsTESmedioPago">
			select 	rtrim(TESMPcodigo) as TESMPcodigo, 
					rtrim(TESMPdescripcion) #_Cat#
						case TESTMPtipo
							when 1 then ' (CHK)'
							when 2 then ' (TRI)'
							when 3 then ' (TRE)'
							when 4 then ' (TRM)'
							else ' (???)'
						end
					as TESMPdescripcion,
					mp.TESTMPtipo, 
					mp.TESMPsoloManual,
					mp.TESTGcodigoTipo,
					mp.TESTGtipoCtas 
			  from TESmedioPago mp
			 where mp.TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESid#">	
			   and mp.CBid	= #Request.rsTESctasBancos.CBid#
			<cfif Attributes.SoloChks>
			   and mp.TESTMPtipo = 1
			   and mp.TESMPsoloManual = 0
			</cfif>
			<cfif Attributes.SoloTipo NEQ -1>
			   and mp.TESTMPtipo = #Attributes.SoloTipo#
			</cfif>
		</cfquery>
				LvarMedioPago ["#Request.rsTESctasBancos.CBid#"] 		= new Array();
				LvarTipoMedioPago ["#Request.rsTESctasBancos.CBid#"] 	= new Array();
				LvarSoloManual ["#Request.rsTESctasBancos.CBid#"] 		= new Array();
				LvarTiposCtas ["#Request.rsTESctasBancos.CBid#"] 		= new Array();
		<cfif rsTESmedioPago.recordCount EQ 1>
				LvarMedioPago ["#Request.rsTESctasBancos.CBid#"][0] 	= new Option("#rsTESmedioPago.TESMPdescripcion#","#rsTESmedioPago.TESMPcodigo#");
				LvarTipoMedioPago ["#Request.rsTESctasBancos.CBid#"][0]	= "#rsTESmedioPago.TESTMPtipo#";
				LvarSoloManual ["#Request.rsTESctasBancos.CBid#"][0] 	= "#rsTESmedioPago.TESMPsoloManual#";
				LvarTiposCtas ["#Request.rsTESctasBancos.CBid#"][0] 	= { tc : "#rsTESmedioPago.TESTGcodigoTipo#", tcn : "#rsTESmedioPago.TESTGtipoCtas#" };
		<cfelse>
				LvarMedioPago ["#Request.rsTESctasBancos.CBid#"][0] 	= new Option("(Escoja un Medio Pago)","", true);
				LvarTipoMedioPago ["#Request.rsTESctasBancos.CBid#"][0]	= "";
				LvarSoloManual ["#Request.rsTESctasBancos.CBid#"][0] 	= "";
				LvarTiposCtas ["#Request.rsTESctasBancos.CBid#"][0] 	= { tc : "", tcn : "" };
			<cfset LvarCBid = Request.rsTESctasBancos.CBid>
			<cfloop query="rsTESmedioPago">
				LvarMedioPago ["#LvarCBid#"][#rsTESmedioPago.currentRow#]		= new Option("#rsTESmedioPago.TESMPdescripcion#","#rsTESmedioPago.TESMPcodigo#");
				LvarTipoMedioPago ["#LvarCBid#"][#rsTESmedioPago.currentRow#]	= "#rsTESmedioPago.TESTMPtipo#";
				LvarSoloManual ["#LvarCBid#"][#rsTESmedioPago.currentRow#]		= "#rsTESmedioPago.TESMPsoloManual#";
				LvarTiposCtas ["#LvarCBid#"][#rsTESmedioPago.currentRow#]		= { tc : "#rsTESmedioPago.TESTGcodigoTipo#", tcn : "#rsTESmedioPago.TESTGtipoCtas#" };
			</cfloop>
		</cfif>
	</cfloop>
	<!---►►Multiples Medio de Pago◄◄--->
	<cfif Attributes.MultipleMP>
		function sbCambiaTESCBid (CBid, MedioPago, TESMPcodigo){
			$('[name^="'+MedioPago+'"]').each(function(index) {
				if (CBid.value == ""){
					this.options.length = 1;
					this.selectedIndex = 0;
					this.options[0] = new Option("(Escoja Cuenta y Medio Pago)","", true);
					return;
				}
				$("##"+this.id+" option").remove();
				for (i=0; i<LvarMedioPago[CBid.value].length; i++){
				
					if (TESMPcodigo != "" && TESMPcodigo == LvarMedioPago [CBid.value][i].value){
							$("##"+this.id).append(new Option(LvarMedioPago [CBid.value][i].text, LvarMedioPago [CBid.value][i].value),false,false);
					}
					else{
							$("##"+this.id).append(new Option(LvarMedioPago [CBid.value][i].text, LvarMedioPago [CBid.value][i].value),true,true);
					}
				}
				$(this.option).eq(2).attr('selected', 'selected');
			});
		}
	<!---►►Un solo medio de Pago◄◄--->
	<cfelse>
		function sbCambiaTESCBid (CBid, MedioPago, TESMPcodigo)
		{
			var LvarMP = document.getElementById(MedioPago);
			if (CBid.value == "")
			{
				LvarMP.options.length = 1;
				LvarMP.selectedIndex = 0;
				LvarMP.options[0] = new Option("(Escoja Cuenta y Medio Pago)","", true);
				return;
			}
			LvarMP.options.length = LvarMedioPago[CBid.value].length;
			LvarMP.selectedIndex = 0;
			for (var i=0; i<LvarMedioPago[CBid.value].length; i++)
			{
				LvarMP.options[i] = LvarMedioPago [CBid.value][i];
				if (TESMPcodigo != "" && TESMPcodigo == LvarMP.options[i].text)
				{
					LvarMP.selectedIndex = i;
				}
			}
		}
	</cfif>
	</script>
	</cfoutput>
</cfif>

<cfset session.Tesoreria[Attributes.CBid] = LvarCBid>
<cfset form[Attributes.CBid] = LvarCBid>
<cfset session.tesoreria[Attributes.name] = LvarTESMPcodigoSelected>
