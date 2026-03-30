<!--- 	*** TAG DE Cuentas Cliente ***		
		*** Busca en CuentasBancos por CBcc: Cuenta Cliente ***
--->

<!--- Consulta por Defceto --->
<cfquery name="def" datasource="#Session.DSN#">
	select -1 from dual
</cfquery>

<!--- Atributos --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="frCTR" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.onBlur" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.name" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.descripcion" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.size" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.sizedesc" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.CTR" default="CTR" type="string"> <!--- CTR --->
<cfparam name="Attributes.CCTR" default="CCTR" type="string"> <!--- CTR --->

<!--- Arma los parámetros para pasarlos al query y al conlis --->
<cfset params="">
<cfset params=params&"Conexion="&#Attributes.Conexion#>
<cfset params=params&"&Ecodigo="&#Session.Ecodigo#>
<cfset params=params&"&form="&#Attributes.form#>

<!--- Funciones JavaScript --->
<script language="JavaScript" type="text/javascript">
	<!--//
	var popUpWin<cfoutput>#Attributes.CCTR#</cfoutput>=0;

	function popUpWindow<cfoutput>#Attributes.CCTR#</cfoutput>(URLStr, left, top, width, height){

		if(popUpWin<cfoutput>#Attributes.CCTR#</cfoutput>) {
			if(!popUpWin<cfoutput>#Attributes.CCTR#</cfoutput>.closed) popUpWin<cfoutput>#Attributes.CCTR#</cfoutput>.close();
		}
		popUpWin<cfoutput>#Attributes.CCTR#</cfoutput> = open(URLStr, 'popUpWin<cfoutput>#Attributes.CCTR#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp<cfoutput>#Attributes.CCTR#</cfoutput>;
	}
	
	function closePopUp<cfoutput>#Attributes.CCTR#</cfoutput>(){
		if(popUpWin<cfoutput>#Attributes.CCTR#</cfoutput>) {
			if(!popUpWin<cfoutput>#Attributes.CCTR#</cfoutput>.closed) popUpWin<cfoutput>#Attributes.CCTR#</cfoutput>.close();
			popUpWin<cfoutput>#Attributes.CCTR#</cfoutput>=null;
		}
	}
	function doConlisCTR<cfoutput>#Attributes.CCTR#</cfoutput>() {
		
		<cfoutput>		
			var params ="";						
			params = "?formulario=#Attributes.form#&name=#Attributes.name#&desc=#Attributes.descripcion#&conexion=#Attributes.Conexion#";			
			popUpWindow<cfoutput>#Attributes.CCTR#</cfoutput>("/UtilesExt/ConlisCTR.cfm"+params,250,200,650,400);		
		</cfoutput>
		
	}
	function TraeCTR<cfoutput>#Attributes.CTR#</cfoutput>(valor) {
		<cfoutput>
			var params ="";
			params = "?form=#Attributes.form#&id=#Attributes.name#&desc=#Attributes.descripcion#&conexion=#Attributes.Conexion#";
			if (valor!='') {
				document.all["#Attributes.frame#"].src="/UtilesExt/sifCTRquery.cfm"+params+"&dato="+valor;
			}
			else
			{
				document.#Attributes.form#.#Attributes.name#.value = '';
				document.#Attributes.form#.#Attributes.descripcion#.value = '';
			}
			return;
		</cfoutput>	
	}
	//-->
</script>
<!--- --->
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
		<td nowrap>
			<input 	type="text" 
					name="#Attributes.name#" 
					id="#Attributes.name#" 
					maxlength="4" 
					size="#Attributes.size#" 
					onblur="javascript:TraeCTR#Attributes.CTR#(this.value);#Attributes.onBlur#"
					onfocus="this.select()"				
					value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Cmayor#</cfif>"
					tabindex="#Attributes.tabindex#">
					
			<input 	type="text" 
					name="#Attributes.descripcion#" 
					id="#Attributes.descripcion#" 
					maxlength="25" 
					size="#Attributes.sizedesc#" 
					value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Cdescripcion#</cfif>"
					readonly="true"
					disabled="true"
					tabindex="-1">
			<a  href="##" tabindex="-1"><img id="CCTR" src="/imagenes/Description.gif" alt="Cuentas" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCTR#Attributes.CCTR#();">
										
		</td>
	</cfoutput>
</table>
<!--- iframe para la ejecición de la consulta cuando escriben --->
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="/UtilesExt/sifCuentaCTRquery.cfm" ></iframe>
