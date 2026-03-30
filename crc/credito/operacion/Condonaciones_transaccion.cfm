


<cfset EstadoCorteCalculoIntereses = 2>

<cfquery name="q_Tipo" datasource="#session.DSN#">
	select Tipo from CRCCuentas where id = #q_Condonacion.CRCCuentasid#
</cfquery>

<cfquery name="q_Corte" datasource="#session.DSN#">
	select codigo from CRCCortes 
		where 
			status = #EstadoCorteCalculoIntereses#
			and Tipo = '#q_Tipo.Tipo#';
</cfquery>

<cfset CodCortes = []>
<cfloop query="q_Corte">
     <cfset CodCortes[#currentRow#] = #codigo#>
</cfloop>

<cfquery name="q_MovCuenta" datasource="#session.DSN#">
	select
		MontoRequerido = B.Monto,
		Intereses =  case when (ISNULL(A.MontoAPagar, 0) + ISNULL(A.Intereses, 0)) - (ISNULL(A.Condonaciones, 0) + ISNULL(A.Pagado, 0) + ISNULL(A.Descuento, 0)) - case when A.MontoRequerido = 0 then A.UltimoRequerido else A.MontoRequerido end > 0
						then (ISNULL(A.MontoAPagar, 0) + ISNULL(A.Intereses, 0)) - (ISNULL(A.Condonaciones, 0) + ISNULL(A.Pagado, 0) + ISNULL(A.Descuento, 0)) - case when A.MontoRequerido = 0 then A.UltimoRequerido else A.MontoRequerido end
						else A.Intereses
					end
		, A.id
		, A.Corte
		, A.Descripcion
		<!--- , ISNULL(A.Intereses,0) as Intereses --->
		, ISNULL(A.Condonaciones,0) as Condonaciones
		<!--- , ISNULL(A.MontoRequerido,0) as MontoRequerido --->
		, ISNULL(A.Pagado,0) as Pagado
		, ISNULL(A.Descuento,0) as Descuento
		, B.CURP
		, B.Cliente
		, B.Fecha
		from (
				select  A.id, A.Descripcion, A.Ecodigo,A.Corte,A.CRCTransaccionid,A.MontoAPagar,A.Intereses,A.Condonaciones,A.Pagado,A.Descuento,A.MontoRequerido,
					UltimoRequerido = (
						select top 1 MontoRequerido 
						from CRCMovimientoCuenta 
						where MontoRequerido > 0 
							and CRCTransaccionid = A.CRCTransaccionid)
				from CRCMovimientoCuenta A
		) A
			inner join CRCTransaccion B 
				on A.CRCTransaccionid = B.id
		where 
			A.Ecodigo=#session.ecodigo#
			<cfif q_Condonacion.CondonacionAplicada neq 1> 
				and ISNULL(A.MontoAPagar,0) > (ISNULL(A.Pagado,0)+ISNULL(A.Descuento,0)+ISNULL(A.Condonaciones,0))
			<cfelse>
				and ISNULL(A.Condonaciones,0) > 0
			</cfif>
			and A.Corte like '%#trim(q_Tipo.Tipo)#%'
			and A.Corte in ('#ArrayToList(CodCortes,"','")#')
			and B.CRCCuentasid = #q_Condonacion.CRCCuentasid#
			AND MontoAPagar - (Pagado + A.Descuento) > 0
			<cfif q_Condonacion.CondonacionAplicada neq 1> and (ISNULL(A.Intereses,0)-ISNULL(A.Condonaciones,0)) > 0 </cfif>
		order by A.Corte;
</cfquery>


<cfset counter = 0>
<cfset th = "font-size: 14px; background-color:##ccc;">
<cfset thleft = "#th# text-align:left">
<cfset thcenter = "#th# text-align:center">
<cfset thright = "#th# text-align:right">

<cfoutput>
<br/>
<br/>

<!---
<style>
	input[type="number"] {
		-moz-appearance: textfield;
		width:80px;
	}
	input[type="number"]::-webkit-outer-spin-button,
	input[type="number"]::-webkit-inner-spin-button {
		-webkit-appearance: none;
		margin: 0;
		width:80px;
	}
</style>
--->

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<th  style="#thleft#">&emsp;Fecha</th>
		<th  style="#thleft#">&emsp;Corte</th>
		<th  style="#thleft#">&emsp;CURP</th>
		<th  style="#thleft#">&emsp;Cliente</th>
		<th  style="#thleft#">Descripci&oacute;n Transacci&oacute;n</th>
		<th  style="#thcenter#">Monto Requerido</th>
		<th  style="#thcenter#">Pagado</th>
		<th  style="#thcenter#">Descuentos</th>
		<th  style="#thcenter#">Intereses</th>
		<th  style="#thcenter#">Condonaciones</th>
		<th  style="#thcenter#">
			<cfif q_Condonacion.CondonacionAplicada neq 1>
				Condonacion por Aplicar
				<input type="checkbox" onchange="CheckAll(this.checked);">
			<cfelse>
				Condonacion Aplicada
			</cfif>
		</th>
	</tr>
	<tr>
		<!--- <th style="#thcenter#" name="totalCondonar1">$0.00</th> --->
	</tr>
	<cfloop query="q_MovCuenta">
		<cfif counter eq 0>
			<cfset tdStyle = "background-color:##ffffff;">
			<cfset counter = counter+1>
		<cfelse>
			<cfset counter = counter-1>
			<cfset tdStyle = "background-color:##def2f8;">
		</cfif>
		<cfif q_Condonacion.CondonacionAplicada eq 1>
			<cfif StructKeyExists(detallesCondonacion, id)>
				<tr>
					<td style="#tdStyle#">&emsp;#DateFormat(Fecha,'dd/mm/yyyy')#</td>
					<td style="#tdStyle#">&emsp;#Corte#</td>
					<td style="#tdStyle#">&emsp;#CURP#</td>
					<td style="#tdStyle#">&emsp;#Cliente#</td>
					<td style="#tdStyle#">#Descripcion#</td>
					<td style="#tdStyle#" align="center">$ #NumberFormat(MontoRequerido,'0.00')#</td>
					<td style="#tdStyle#" align="center">$ #NumberFormat(Pagado,'0.00')#</td>
					<td style="#tdStyle#" align="center">$ #NumberFormat(Descuento,'0.00')#</td>
					<td style="#tdStyle#" align="center">$ #NumberFormat(Intereses,'0.00')#</td>
					<td style="#tdStyle#" align="center">$ #NumberFormat(Condonaciones,'0.00')#</td>
					<td style="#tdStyle#" align="center">$ #NumberFormat(detallesCondonacion[id],'0.00')#</td>
				</tr>
			</cfif>
		<cfelse>
			<tr>
				<td style="#tdStyle#">&emsp;#DateFormat(Fecha,'dd/mm/yyyy')#</td>
				<td style="#tdStyle#">&emsp;#Corte#</td>
				<td style="#tdStyle#">&emsp;#CURP#</td>
				<td style="#tdStyle#">&emsp;#Cliente#</td>
				<td style="#tdStyle#">#Descripcion#</td>
				<td style="#tdStyle#" align="center">$ #NumberFormat(MontoRequerido,'0.00')#</td>
				<td style="#tdStyle#" align="center">$ #NumberFormat(Pagado,'0.00')#</td>
				<td style="#tdStyle#" align="center">$ #NumberFormat(Descuento,'0.00')#</td>
				<td style="#tdStyle#" align="center">$ #NumberFormat(Intereses,'0.00')#</td>
				<td style="#tdStyle#" align="center">$ #NumberFormat(Condonaciones,'0.00')#</td>
				<td style="#tdStyle#" align="center">
				<cfset max=Intereses-Condonaciones>
				$ <input type="text" size="10"
					name="monto_#id#" value="<cfif modo eq 'CAMBIO'><cfif StructKeyExists(detallesCondonacion, id)>#NumberFormat(detallesCondonacion[id],'0.00')#</cfif></cfif>" 
					onkeypress="return soloNumeros(event);"
					onkeyup="CalcularTotalCondonar();"  
					onblur="CalcularTotalCondonar(); MaxMonto('#id#',false);">
					<input type="hidden" name="maxMonto_#id#" value="#NumberFormat(Intereses - Condonaciones,'0.00')#">
				<input type="checkbox" name="check_#id#" value="#max#" onchange="CondonarTodo(this);">
			</tr>
		</cfif>
	</cfloop>
	<tr>
		<th colspan="7" style="#thright#">&emsp;Total a Condonar</th>
		<th style="#thcenter#" name="totalCondonar2">$0.00</th>
	</tr>
</table>

</cfoutput>

<script>
	var alertDisplayed = false;
	var monto = document.getElementsByName('Monto')[0].value;
	if( monto == 0){
		CalcularTotalCondonar();
	}
	document.getElementsByName('totalCondonar2')[0].innerHTML = "$ " + Math.round(document.getElementsByName('Monto')[0].value * 100) / 100;
	
	function CheckAll(c){
		var $inputs = $(":input[name^='check_']");
		var DOM_inputs = $inputs.get();
		for(var i = 0; i < DOM_inputs.length; i++){
			DOM_inputs[i].checked = c;
			CondonarTodo(DOM_inputs[i]);
		}
	}
	
	
	function CalcularTotalCondonar(){
		 
		var total = 0;
		var $inputs = $(":input[name^='monto_']");
		var DOM_inputs = $inputs.get();
		for(var i = 0; i < DOM_inputs.length; i++){
			total += Number(DOM_inputs[i].value);
		}
		/* document.getElementsByName('totalCondonar1')[0].innerHTML = "$ "+total; */
		document.getElementsByName('totalCondonar2')[0].innerHTML = "$ "+Math.round(total * 100) / 100;
		document.getElementsByName('Monto')[0].value = Math.round(total * 100) / 100;
		if(isNaN(parseFloat (total)) && !alertDisplayed){
			alertDisplayed = true;
			alert("No es un numero valido");
			alertDisplayed = false;
		}

	}
	
	function CondonarTodo(c){
		 
		id = c.name.split('_');
		var element = document.getElementsByName('monto_'+id[1])[0];
		if(c.checked){
			element.style.color="#6E6E6E";
			element.style.backgroundColor="#D8D8D8";
			element.value = c.value;
			element.disabled = true;
		}else{
			element.style.color="#000000";
			element.style.backgroundColor="#ffffff";
			element.value = "";
			element.disabled = false;
		}
		CalcularTotalCondonar();
	}
	
	function soloNumeros(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46)){ return true; }
        return /\d/.test(String.fromCharCode(keynum))
	}

	function MaxMonto(id,r){
		var montoCondo = Number(document.getElementsByName('monto_'+id)[0].value);
		var maxCondo = Number(document.getElementsByName('maxMonto_'+id)[0].value);
		var montoCondoL = document.getElementsByName('monto_'+id)[0].value;

		if(!isNaN(montoCondo)){
			if(montoCondo > maxCondo){
				if(!r){
					alert("El monto de condonacion $ "+montoCondo+" no debe superar los: $"+maxCondo);
				}else{
					var validar = {'ok':false, 'msg':"\n- El monto de condonacion $ "+montoCondo+" no debe superar los: $"+maxCondo}
					return validar;
				}
			}else{
				if(r){return {'ok':true};}
			}
		}else{
			if(r && montoCondo == 0 ){return {'ok':true};}
			if(r && (montoCondo+"").trim() == 'NaN' ){
				var validar = {'ok':false, 'msg':"\n- El monto de condonacion $ "+montoCondoL+" es incorrecto"}
				return validar;
			}
		}
	}

</script>

<!--- <cfdump var="#q_MovCuenta#"> --->