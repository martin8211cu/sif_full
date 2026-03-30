<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Lista de Cuentas Bancarias" returnvariable="LB_Titulo" xmlfile="TConlisCuentas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" xmlfile="TConlisCuentas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="TConlisCuentas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="TConlisCuentas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" xmlfile="TConlisCuentas.xml"/>
<html>
<head>
<title><cfoutput>#LB_Titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<!--- 1. Datos que muestra el conlis --->
<cfquery name="conlis" datasource="#Session.DSN#">

	select cb.CBid, CBcodigo, CBdescripcion, cb.Mcodigo, Mnombre
	from CuentasBancos cb
		inner join Monedas m 
			on cb.Mcodigo=m.Mcodigo
    <!---SML.03/12/2014 Inicio. Modificacion para solo aparezca las cuentas activas de acuerdo al Estatus de las Cuentas Bancarias de Tesoreria--->
        left join TEScuentasBancos tcb 
			on tcb.CBid  = cb.CBid
	<!---SML.03/12/2014 Final. Modificacion para solo aparezca las cuentas activas de acuerdo al Estatus de las Cuentas Bancarias de Tesoreria--->
	where cb.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		and tcb.TESCBactiva = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> <!---SML.03/12/2014 Modificacion para solo aparezca las cuentas activas de acuerdo al Estatus de las Cuentas Bancarias de Tesoreria--->
	<cfif isdefined("url.CBid") and (url.CBid NEQ "")>	
	    and cb.CBid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
	</cfif>  
	
	<cfif isdefined("Form.Filtrar") and (Form.CBcodigo NEQ "")>
		and upper(CBcodigo) like '%#Ucase(Form.CBcodigo)#%'
	</cfif>

	<cfif isdefined("Form.Filtrar") and (Form.CBdescripcion NEQ "")>
		and upper(CBdescripcion) like '%#Ucase(Form.CBdescripcion)#%'
	</cfif>
	
	<cfif isdefined("Form.Filtrar") and (Form.Mnombre NEQ "")>
		and upper(Mnombre) like '%#Ucase(Form.Mnombre)#%'
	</cfif>

	order by upper(CBcodigo)

</cfquery>

<!--- Moneda de la Empresa--->
<cfquery name="rsMoneda" datasource="#Session.DSN#" >
	select Mcodigo 
	from  Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>


<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=16>
<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>

<script language="JavaScript1.2">
function Asignar(valor1, valor2, valor3, valor4, valor5, valor6 ) {
// valor6 : quien invoca al conlis, si cuanta destino o cuenta origen

	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value      = valor1;
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value    = valor2;
	window.opener.document.<cfoutput>#url.form#.#url.mcodigo#</cfoutput>.value = valor3;
	window.opener.document.<cfoutput>#url.form#.#url.mnombre#</cfoutput>.value = valor4;


	if ( valor5 != '' ){
		window.opener.document.<cfoutput>#url.form#.#url.tipo#</cfoutput>.value    = valor5;
		window.opener.fm(window.opener.document.<cfoutput>#url.form#.#url.tipo#</cfoutput>, 4)

		if ( valor5 == '1.0000' ){
			window.opener.document.<cfoutput>#url.form#.#url.tipo#</cfoutput>.disabled = true
		}
		else{
			window.opener.document.<cfoutput>#url.form#.#url.tipo#</cfoutput>.disabled = false
		}
	}
	
	// activa o desactiva el monto
	if ( valor3 == '<cfoutput>#url.moneda#</cfoutput>' ){
		window.opener.document.<cfoutput>#url.form#.#url.monto#</cfoutput>.disabled = true
		window.opener.sugiere_monto(window.opener.document.transferencia.DTmontoori.value);
	}
	else{
		window.opener.document.<cfoutput>#url.form#.#url.monto#</cfoutput>.disabled = false
		window.opener.sugiere_monto('0.00');
	}
	
	//activa o desactiva el monto destino, cuando la moneda destino es igual a la local
	// o cuando ambas monedas son iguales pero no son la moneda local
	// Cuando ambas monedas son iguales, el monto destino DEBE ser el monto origen!
	if (
		window.opener.document.transferencia.dMcodigo.value == <cfoutput>#rsMoneda.Mcodigo#</cfoutput>
		|| 
		window.opener.document.transferencia.dMcodigo.value == window.opener.document.transferencia.oMcodigo.value
		) 
		{
			if ( 
				window.opener.document.transferencia.DTmontoori.value !== "" 
				&& 
				window.opener.document.transferencia.DTtipocambio.value 
				)
				{
					if (window.opener.document.transferencia.dMcodigo.value == <cfoutput>#rsMoneda.Mcodigo#</cfoutput>)
					{
						window.opener.document.transferencia.DTmontodest.value = window.opener.qf(window.opener.document.transferencia.DTmontoori.value) * window.opener.document.transferencia.DTtipocambio.value;
					}
					else
					{
						window.opener.document.transferencia.DTmontodest.value = window.opener.qf(window.opener.document.transferencia.DTmontoori.value);
					}
					window.opener.fm(window.opener.document.transferencia.DTmontodest, 2);
					window.opener.document.transferencia.DTmontodest.disabled = true;
				}
		}
	else{
		window.opener.document.transferencia.DTmontodest.disabled = false;
	}
	
	
	
	
	window.close();
}
</script>

<body>
	<form action="" method="post" name="conlis">
		<table width="100%" border="0" cellspacing="0">
			<tr> 
				<td  class="tituloListas" >
					<div align="left"><cfoutput>#LB_Codigo#</cfoutput></div>
				</td>

				<td class="tituloListas" >
					<div align="left"><cfoutput>#LB_Descripcion#</cfoutput></div>
				</td>
				
				<td  class="tituloListas" >
					<div align="left"><cfoutput>#LB_Moneda#</cfoutput></div>
				</td>
			
				<td width="1%" class="tituloListas">
					<div align="right"> 
						<input type="submit" name="Filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
					</div>
				</td>
			</tr>
			
			<tr> 
				<td ><input name="CBcodigo" type="text" size="30" maxlength="50" style=" text-transform: uppercase; "></td>
				<td ><input name="CBdescripcion" type="text" size="30" maxlength="60" style=" text-transform: uppercase; "></td>
				<td ><input name="Mnombre" type="text" size="30" maxlength="80" style=" text-transform: uppercase; "></td>
			</tr>
			
			<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
				
				<!--- Calcula el tipo de cambio: --->
				<!--- 1. Si la moneda de la empresa es igual a la moneda de la Cuenta, el tipo de cambio es 1 y no se modifica 
						 el input para tipo de cambio
					  2. Si no son iguales (el input de Tipo de Cambio se puede modificar siempre):
					  	 2.1 Sugiere el tipo de cambio para la fecha actual(hoy)   
						 2.2 Si no existe 2.1, entonces sugiere el ultimo tipo de cambio registrado para la empresa y moneda actuales
						 2.3 Si no existe 2.2, asigna cero como tipo de cambio
				--->

				<!--- 1. Monedas iguales(1)--->
				<cfif #url.oTipo# eq 'o'>
					<cfif #rsMoneda.Mcodigo# EQ #conlis.Mcodigo# >
						<cfset tcambio = "1.0000">
					<!--- Monedas diferentes(2) --->
					<cfelse>
						<cfquery name="rsTipoCambio" datasource="#Session.DSN#">
							select tc.Mcodigo, tc.TCcompra, tc.TCventa
							from Htipocambio tc
							where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
								and tc.Mcodigo =  <cfqueryparam value="#conlis.Mcodigo#" cfsqltype="cf_sql_integer">
								and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fecha)#">
								and tc.Hfechah >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fecha)#"> 
						</cfquery>
						
						<cfif #rsTipoCambio.RecordCount# gt 0 >
							<cfset tcambio = #rsTipoCambio.TCcompra# >
						<cfelse>
							<cfset tcambio = "0.0000" >
						</cfif>
						
					</cfif>
				<cfelse>
					<cfset tcambio = "" >
				</cfif>	
				
				<tr> 
					<td <cfif #conlis.CurrentRow# MOD 2>
							<cfoutput>class="listaPar"</cfoutput>
						<cfelse>
							<cfoutput>class="listaNon"</cfoutput>
						</cfif>>
						<a href="javascript:Asignar(#conlis.CBid#, '#JSStringFormat(conlis.CBcodigo)#', #conlis.Mcodigo#, '#JSStringFormat(conlis.Mnombre)#', '#JSStringFormat(tcambio)#', '#JSStringFormat(url.tipo)#');">#conlis.CBcodigo#</a>
					</td>

					<td <cfif #conlis.CurrentRow# MOD 2>
							<cfoutput>class="listaPar"</cfoutput>
						<cfelse>
							<cfoutput>class="listaNon"</cfoutput>
						</cfif>>
						<a href="javascript:Asignar(#conlis.CBid#, '#JSStringFormat(conlis.CBcodigo)#', #conlis.Mcodigo#, '#JSStringFormat(conlis.Mnombre)#', '#JSStringFormat(tcambio)#');">#conlis.CBdescripcion#</a>
					</td>

					<td <cfif #conlis.CurrentRow# MOD 2>
							<cfoutput>class="listaPar"</cfoutput>
						<cfelse>
							<cfoutput>class="listaNon"</cfoutput>
						</cfif>>
						<a href="javascript:Asignar(#conlis.CBid#, '#JSStringFormat(conlis.CBcodigo)#', #conlis.Mcodigo#, '#JSStringFormat(conlis.Mnombre)#', '#JSStringFormat(tcambio)#');">#conlis.Mnombre#</a>
					</td>

				</tr>
			</cfoutput> 

			<tr> 
				<td colspan="3">&nbsp; </td>
			</tr>
			
			<tr> 
				<td colspan="3">&nbsp; 
					<table border="0" width="50%" align="center">
						<cfoutput> 
							<tr> 
								<td width="23%" align="center"> 
									<cfif PageNum_conlis GT 1>
										<a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#">
											<img src="../../imagenes/First.gif" border=0>
										</a> 
									</cfif>
								</td>

								<td width="31%" align="center">
									<cfif PageNum_conlis GT 1>
										<a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#">
											<img src="../../imagenes/Previous.gif" border=0>
										</a> 
									</cfif>
								</td>

								<td width="23%" align="center">
									<cfif PageNum_conlis LT TotalPages_conlis>
										<a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#">
											<img src="../../imagenes/Next.gif" border=0>
										</a> 
									</cfif>
								</td>
				
								<td width="23%" align="center">
									<cfif PageNum_conlis LT TotalPages_conlis>
										<a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#">
											<img src="../../imagenes/Last.gif" border=0>
										</a> 
									</cfif>
								</td>
				
							</tr>
						</cfoutput> 
					</table>
				<div align="center"> </div>
				</td>
			</tr>
		</table>
		<p>&nbsp;</p>
	</form>
</body>
</html>
