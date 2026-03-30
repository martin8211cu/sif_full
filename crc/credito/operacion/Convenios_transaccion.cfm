



<cfquery name="q_Tipo" datasource="#session.DSN#">
	select Tipo from CRCCuentas where id = #q_Condonacion.CRCCuentasid#
</cfquery>

<cfquery name="q_Corte" datasource="#session.DSN#">
	select codigo from CRCCortes 
		where 
			FechaFin <= '#DateFormat(Now(),"yyyy/mm/dd")#' 
			and FechaInicio <= '#DateFormat(Now(),"yyyy/mm/dd")#'
			and codigo like '%#q_Tipo.Tipo#%';
</cfquery>

<cfset CodCortes = []>
<cfloop query="q_Corte">
     <cfset CodCortes[#currentRow#] = #codigo#>
</cfloop>

<cfquery name="q_MovCuenta" datasource="#session.DSN#">
	select
		A.id
		, A.Corte
		, A.Descripcion
		, ISNULL(A.Intereses,0) as Intereses
		, ISNULL(A.Condonaciones,0) as Condonaciones
		, ISNULL(A.MontoRequerido,0) as MontoRequerido
		, ISNULL(A.Pagado,0) as Pagado
		, ISNULL(A.Descuento,0) as Descuento
		from CRCMovimientoCuenta A
			inner join CRCTransaccion B 
				on A.CRCTransaccionid = B.id
		where 
			A.Ecodigo=1 
			and (ISNULL(A.Intereses,0)+ISNULL(A.MontoRequerido,0)) > (ISNULL(A.Pagado,0)+ISNULL(A.Descuento,0)+ISNULL(A.Condonaciones,0))
			and A.Corte like '%#q_Tipo.Tipo#%'
			and A.Corte in ('#ArrayToList(CodCortes,"','")#')
			and B.CRCCuentasid = #q_Condonacion.CRCCuentasid#
			and ISNULL(A.Intereses,0) > 0
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

<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<th rowspan="2" style="#thleft#">&emsp;Corte</th>
		<th rowspan="2" style="#thleft#">Descripci&oacute;n Transacci&oacute;n</th>
		<th rowspan="2" style="#thcenter#">Monto Requerido</th>
		<th rowspan="2" style="#thcenter#">Pagado</th>
		<th rowspan="2" style="#thcenter#">Descuentos</th>
		<th rowspan="2" style="#thcenter#">Intereses</th>
		<th rowspan="2" style="#thcenter#">Condonaciones</th>
		<cfif q_Condonacion.CondonacionAplicada neq 1>
			<th rowspan="2" style="#thcenter#">Condonacion por Aplicar</th>
		<cfelse>
			<th rowspan="2" style="#thcenter#">Condonacion Aplicada</th>
		</cfif>
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
					<td style="#tdStyle#">&emsp;#Corte#</td>
					<td style="#tdStyle#">#Descripcion#</td>
					<td style="#tdStyle#" align="center">$ #MontoRequerido#</td>
					<td style="#tdStyle#" align="center">$ #Pagado#</td>
					<td style="#tdStyle#" align="center">$ #Descuento#</td>
					<td style="#tdStyle#" align="center">$ #Intereses#</td>
					<td style="#tdStyle#" align="center">$ #Condonaciones#</td>
					<td style="#tdStyle#" align="center">$ #detallesCondonacion[id]#</td>
				</tr>
			</cfif>
		<cfelse>
			<tr>
				<td style="#tdStyle#">&emsp;#Corte#</td>
				<td style="#tdStyle#">#Descripcion#</td>
				<td style="#tdStyle#" align="center">$ #MontoRequerido#</td>
				<td style="#tdStyle#" align="center">$ #Pagado#</td>
				<td style="#tdStyle#" align="center">$ #Descuento#</td>
				<td style="#tdStyle#" align="center">$ #Intereses#</td>
				<td style="#tdStyle#" align="center">$ #Condonaciones#</td>
				<td style="#tdStyle#" align="center">
				<cfset max=Intereses-Condonaciones>
				$ <input type="number" min="0" max="#max#" 
					name="monto_#id#" value="<cfif modo eq 'CAMBIO'><cfif StructKeyExists(detallesCondonacion, id)>#detallesCondonacion[id]#</cfif></cfif>" onkeyup="CalcularTotalCondonar();">
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

	var monto = document.getElementsByName('Monto')[0].value;
	if( monto == 0){
		CalcularTotalCondonar();
	}
	document.getElementsByName('totalCondonar2')[0].innerHTML = "$ " + document.getElementsByName('Monto')[0].value
	
	function CalcularTotalCondonar(){
		var total = 0;
		var $inputs = $(":input[name^='monto_']");
		var DOM_inputs = $inputs.get();
		for(var i = 0; i < DOM_inputs.length; i++){
			total += Number(DOM_inputs[i].value);
		}
		/* document.getElementsByName('totalCondonar1')[0].innerHTML = "$ "+total; */
		document.getElementsByName('totalCondonar2')[0].innerHTML = "$ "+total;
		document.getElementsByName('Monto')[0].value = total;

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
        if ((keynum == 8) || (keynum == 46)) { return true;}
		if(Number(v.value) > Number(m)){return false;}
         
        return /\d/.test(String.fromCharCode(keynum));
	}
</script>

<!--- <cfdump var="#q_MovCuenta#"> --->