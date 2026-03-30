<SCRIPT SRC="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.form1.CFid.value = '';
		document.form1.CFcodigo.value = '';
		document.form1.CFdescripcion.value = '';
		document.form1.Corte.value = '';
	}
	function Validafecha(){
			
		if(document.form1.Corte.value == ''){
			alert("Digite por favor la fecha de corte.");
			return false;
		}
		if(document.form1.dia.value > 31){
			alert("Fecha Inválida!");
			return false;
		}
	}
	
</script>
<script language="JavaScript1.2" type="text/javascript">


/**
 * DHTML date validation script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
 */
// Declaring valid date character, minimum year and maximum year
var dtCh= "/";
var minYear=1900;
var maxYear=2100;

function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   } 
   return this
}

function isDate(dtStr){
	//alert(dtStr);
	//return false;
	var daysInMonth = DaysArray(12)
	var pos1=dtStr.indexOf(dtCh)
	var pos2=dtStr.indexOf(dtCh,pos1+1)
	var strMonth=dtStr.substring(0,pos1)
	var strDay=dtStr.substring(pos1+1,pos2)
	var strYear=dtStr.substring(pos2+1)
	strYr=strYear
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)
	if (pos1==-1 || pos2==-1){
		alert("El formato debe ser : mm/dd/yyyy")
		return false
	}
	if (strMonth.length<1 || month<1 || month>12){
		alert("Por favor digite un mes válido")
		return false
	}
	if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		alert("Por favor digite un día válido")
		return false
	}
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
		alert("Por favor digite un año de 4 digitos entre "+minYear+" y "+maxYear)
		return false
	}
	if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
		alert("Por favor digite una fecha válida")
		return false
	}
return true
}

function ValidateForm(){
	return Validafecha();
	if(document.form1.dia.value > 0){
		var LvarFecha = '';
		
		if(document.form1.mes.value < 10){
			LvarFecha = LvarFecha  + '0' + document.form1.mes.value 
		}
		else{
			LvarFecha = LvarFecha  +  '/' + document.form1.mes.value ;
			}	
			
		if(document.form1.dia.value < 10){
			LvarFecha = LvarFecha  + '/0' + document.form1.dia.value 
		}
		else{
			LvarFecha = LvarFecha  +  '/' +  document.form1.dia.value ;
			}	
			
		LvarFecha = LvarFecha + '/' + '<cfoutput>#datepart("yyyy", now())#</cfoutput>';	
			
		if (isDate(LvarFecha)==false){
			//dt.focus()
			return false
		}
		return true
	}
 }

</script>

<cfoutput>
	<form method="post" name="form1" action="EmpleAnualVac-SQL.cfm"  onSubmit="javascript:return ValidateForm();">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr valign="top">
				<td width="50%">
					<table width="100%">
						<tr>
							<td height="173" valign="top">	
								<cf_web_portlet_start border="true" titulo="Vacaciones y Anualidades de Empleados" skin="info1">
									<div align="justify">
									  <p>En &eacute;ste reporte muestra las Vacaciones y Anualidades de Empleados 
									  que se cumplen este mes. Se ordena por: Centro Funcional y fecha.</p>
								</div>
							  <cf_web_portlet_end></td>
						</tr>
					</table>  
				</td>
				<td width="50%" valign="top">
					<table width="100%" cellpadding="0" cellspacing="0" align="center">
						
						
					  <tr>
						<td><strong>Centro Funcional:</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					   
						<tr>
							<td align="left" nowrap>
							  	<cf_rhcfuncional tabindex="1">							</td>
							<td align="center">&nbsp;</td>
							<td align="center">							</td>
						</tr>
												
						<tr>
						  <td><strong>Fecha Corte:</strong></td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>	
						<tr>
							<td>
								<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>

								<cf_sifcalendario tabindex="2" name="Corte" value="#fecha#">							</td>
							<td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>
						<tr>
						  <td><strong>Tipo de Cumplimiento:</strong></td>
							<td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>
							
						<tr>
						  	<td align="left">
								<select name="Cumplimiento" tabindex="3">
									<option value="A">Anuales</option>
									<option value="V">Vacaciones</option>
								</select>
							</td>
						</tr>
						<tr>
						  <td>
							  <strong>Mes:</strong>						  </td>
						   <td >&nbsp;</td>
						  <td >&nbsp;</td>
					  </tr>
					  <tr>
						  <td >
						  		<select name="mes" tabindex="4">
									<option value="1"  <cfif datepart('m',now()) EQ 1>selected</cfif>>Enero</option>
									<option value="2"  <cfif datepart('m',now()) EQ 2>selected</cfif>>Febrero</option>
									<option value="3"  <cfif datepart('m',now()) EQ 3>selected</cfif>>Marzo</option>
									<option value="4"  <cfif datepart('m',now()) EQ 4>selected</cfif>>Abril</option>
									<option value="5"  <cfif datepart('m',now()) EQ 5>selected</cfif>>Mayo</option>
									<option value="6"  <cfif datepart('m',now()) EQ 6>selected</cfif>>Junio</option>
									<option value="7"  <cfif datepart('m',now()) EQ 7>selected</cfif>>Julio</option>
									<option value="8"  <cfif datepart('m',now()) EQ 8>selected</cfif>>Agosto</option>
									<option value="9"  <cfif datepart('m',now()) EQ 9>selected</cfif>>Setiembre</option>
									<option value="10" <cfif datepart('m',now()) EQ 10>selected</cfif>>Octubre</option>
									<option value="11" <cfif datepart('m',now()) EQ 11>selected</cfif>>Noviembre</option>
									<option value="12" <cfif datepart('m',now()) EQ 12>selected</cfif>>Diciembre</option>
								</select>							</td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>	
						<tr>
						  <td><strong>Día:</strong></td>
						  <td >&nbsp;</td>
						  <td >&nbsp;</td>
					  </tr>
						<tr>
						  <td><input name="dia" type="text" value="" size="5"
							onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
							onblur="javascript: fm(this,0);"  onFocus="this.select()" /></td>
						  <td >&nbsp;</td>
						  <td >&nbsp;</td>
					  </tr>
						<tr>
						  <td><strong>Formato:</strong></td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>	
						<tr>
							<td>
								<select name="formato" tabindex="6">
                                	<option value="FlashPaper">FlashPaper</option>
                                	<option value="pdf">Adobe PDF</option>
                                	<option value="Excel">Microsoft Excel</option>
                              	</select>							</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="3" align="center">&nbsp;</td>
						</tr>																						
						<tr>
							<td align="center" colspan="3"><input type="submit" value="Generar" name="Reporte" tabindex="7">
							<input type="reset" name="Limpiar" value="Limpiar" tabindex="8" onClick="javascript:limpiar();"></td>
							</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
	</cfoutput>
