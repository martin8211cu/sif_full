<!--- Querys--->
<cfquery name="rsRHTipoAccionQuery" datasource="#Session.DSN#">
  	<cfif not Attributes.autogestion>
		select a.RHTid, rtrim(a.RHTcodigo) as RHTcodigo, a.RHTdesc, a.RHTpfijo, a.RHTpmax, a.RHTcomportam, a.RHTcempresa,
		coalesce(a.RHTsubcomportam,0) as RHTsubcomportam
		from RHTipoAccion a, RHUsuarioTipoAccion b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and a.RHTcomportam not in (7, 8)
		   and a.Ecodigo = b.Ecodigo
		   and a.RHTid  = b.RHTid 
		   and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
           <cfif isdefined('Attributes.FiltroExtra') and LEN(TRIM(Attributes.FiltroExtra))>
		   	and #Attributes.FiltroExtra#
		   </cfif>
		union
		select a.RHTid, rtrim(a.RHTcodigo) as RHTcodigo, a.RHTdesc, a.RHTpfijo, a.RHTpmax, a.RHTcomportam, a.RHTcempresa,
		coalesce(a.RHTsubcomportam,0) as RHTsubcomportam
		from RHTipoAccion a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHTcomportam not in (7, 8)
		  and not exists(select 1 from RHUsuarioTipoAccion u where u.RHTid = a.RHTid)
          <cfif isdefined('Attributes.FiltroExtra') and  LEN(TRIM(Attributes.FiltroExtra))>
		   	and #Attributes.FiltroExtra#
		   </cfif>
		order by 2,3
	<cfelse>
		select a.RHTid, rtrim(a.RHTcodigo) as RHTcodigo, a.RHTdesc, a.RHTpfijo, a.RHTpmax, a.RHTcomportam, a.RHTcempresa,
		coalesce(a.RHTsubcomportam,0) as RHTsubcomportam
		from RHTipoAccion a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHTcomportam not in (7, 8)
		  and not exists(select 1 from RHUsuarioTipoAccion u where u.RHTid = a.RHTid)
		  and RHTautogestion = 1
          <cfif isdefined('Attributes.FiltroExtra') and  LEN(TRIM(Attributes.FiltroExtra))>
		   	and #Attributes.FiltroExtra#
		   </cfif>
		order by 2,3
	</cfif>
</cfquery>

<!--- JavaScripts --->
<script language="JavaScript" type="text/javascript">
/**************************************************************************/

function ajaxFunction1_ComboRiesgo(){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vTipoRiesgo ='';
	var vmodoD 		='';
	vRHTsubcomportam 	= document.form1.RHTsubcomportam.value;
/*	vmodoD1 		= document.modo.value;*/
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest1 = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}
	
	ajaxRequest1.open("GET", '/cfmx/rh/nomina/operacion/ComboRiesgo.cfm?xRHTsubcomportam='+vRHTsubcomportam, false);
	ajaxRequest1.send(null);
	document.getElementById("contenedor_Riesgos").innerHTML = ajaxRequest1.responseText;
}
/**************************************************************************/

function ajaxFunction1_ComboConsecuencia(){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vTipoRiesgo ='';
	var vmodoD 		='';
	vTipoRiesgo 		= document.form1.TipoRiesgo.value;
	vRHTsubcomportam 	= document.form1.RHTsubcomportam.value;
	
/*	vmodoD1 		= document.modo.value;*/
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest1 = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}

	ajaxRequest1.open("GET", '/cfmx/rh/nomina/operacion/ComboConsecuencia.cfm?xTipoRiesgo='+vTipoRiesgo+'&xRHTsubcomportam='+vRHTsubcomportam, false);
	ajaxRequest1.send(null);
	document.getElementById("contenedor_Consecuencia").innerHTML = ajaxRequest1.responseText;
}

/**************************************************************************/


function ajaxFunction1_ComboControlIncapacidad(){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vTipoRiesgo ='';
	var vmodoD 		='';
	vConsecuencia 		= document.form1.Consecuencia.value;
	vTipoRiesgo 		= document.form1.TipoRiesgo.value;
	vRHTsubcomportam 	= document.form1.RHTsubcomportam.value;

/*	vmodoD1 		= document.modo.value;*/
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest1 = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}

	ajaxRequest1.open("GET", '/cfmx/rh/nomina/operacion/ComboControlInacapacidad.cfm?xConsecuencia='+vConsecuencia+'&xTipoRiesgo='+vTipoRiesgo+'&xRHTsubcomportam='+vRHTsubcomportam, false);
	ajaxRequest1.send(null);
	document.getElementById("contenedor_ControlIncapacidad").innerHTML = ajaxRequest1.responseText;
}



	<!--- 
		A esta funcion se le puede pasar indices de los controles en 'hidectls' que se quieren ocultar
		si no se mandan argumentos adicionales quiere decir que se quiere ocultar todos los controles enviados por el attributo 'hidectls'
	--->
	<cfif Len(Trim(Attributes.hidectls)) NEQ 0>
	function hideControls(val) {
		<cfoutput>
		<cfset ctls = ListToArray(Attributes.hidectls, ",")>
		
		var ctls = new Array();
		<cfloop index="i" from="1" to="#ArrayLen(ctls)#">
			ctls[ctls.length] = "#ctls[i]#";
		</cfloop>
		</cfoutput>
		
<!---		if (val == "1") {
			// Si vienen más argumentos
			if (arguments[1] != null) {
				for (var i=1; i<arguments.length; i++) {
					var ctl = document.getElementById(ctls[arguments[i]-1]);
					if (ctl) ctl.style.display = "";
				}
			} else {
				for (var i=0; i<ctls.length; i++) {
					var ctl = document.getElementById(ctls[i]);
					if (ctl) ctl.style.display = "";
				}
			}
		} else {
			if (arguments[1] != null) {
				for (var i=1; i<arguments.length; i++) {
					var ctl = document.getElementById(ctls[arguments[i]-1]);
					if (ctl) ctl.style.display = "none";
				}
			} else {
				for (var i=0; i<ctls.length; i++) {
					var ctl = document.getElementById(ctls[i]);
					if (ctl) ctl.style.display = "none";
				}
			}
		}
		
--->		
	
<!---2010-03-17
ljimenez se cambion un if por el case ya que se incorporo un nuevo combo 
que se debe de pintar deacuerdo a subcomportamiento de la la accion de incapacidad--->
		
		switch (val)
			{
			case '1':{
				if (arguments[1] != null) {
					for (var i=1; i<arguments.length; i++) {
						var ctl = document.getElementById(ctls[arguments[i]-1]);
						if (ctl) ctl.style.display = "";
					}
				} else {
					for (var i=0; i<ctls.length; i++) {
						var ctl = document.getElementById(ctls[i]);
						if (ctl) ctl.style.display = "";
					}
				}
			}
			break;
			case '2':{
				if (arguments[1] != null) {
					for (var i=1; i<arguments.length; i++) {
						var ctl = document.getElementById(ctls[arguments[i]-1]);
						if (ctl) ctl.style.display = "";
					}
				} else {
					for (var i=0; i<ctls.length; i++) {
						var ctl = document.getElementById(ctls[i]);
						if (ctl) ctl.style.display = "";
					}
				}
			}
			break;
			case '3':{
				if (arguments[1] != null) {
					for (var i=1; i<arguments.length; i++) {
						var ctl = document.getElementById(ctls[arguments[i]-1]);
						if (ctl) ctl.style.display = "";
					}
				} else {
					for (var i=0; i<ctls.length; i++) {
						var ctl = document.getElementById(ctls[i]);
						if (ctl) ctl.style.display = "";
					}
				}
			}
			break;
			default:{
				if (arguments[1] != null) {
					for (var i=1; i<arguments.length; i++) {
						var ctl = document.getElementById(ctls[arguments[i]-1]);
						if (ctl) ctl.style.display = "none";
					}
				} else {
					for (var i=0; i<ctls.length; i++) {
						var ctl = document.getElementById(ctls[i]);
						if (ctl) ctl.style.display = "none";
					}
				}
				}
			} 
			
		// Llama a una funcion de validacion que deberia crearse en la pagina que utiliza este tag 
		// si es que se requiere
		if (window.validateControls) validateControls(val);
		return true;
	}
	</cfif>
	
	//function Asignar(id, cod, acc, pmax, plazofijo) {
	function Asignar(obj) {
		var arrayparams, id, pmax, plazofijo, comportam, cambioempr,riesgo;
		arrayparams = obj.value.split("|");
		
		id = arrayparams[0];
		pmax = arrayparams[1];
		plazofijo = arrayparams[2];
		comportam = arrayparams[3];
		cambioempr = arrayparams[4];
		riesgo = arrayparams[5];

		<cfoutput>
		document.#Attributes.form#.RHTid#index#.value = id;
		document.#Attributes.form#.RHTsubcomportam#index#.value = riesgo;
		//document.#Attributes.form#.RHTcodigo#index#.value = cod;
		//document.#Attributes.form#.RHTdesc#index#.value = acc;
		document.#Attributes.Form#.RHTpmax#index#.value = pmax;

		hideControls(plazofijo, 1, 2);
		<!--- SI NO ES CAMBIO DE EMPRESA se oculta el campo de Empresa --->
		<!---2010-03-17
		ljimenez se cambion un if por el case ya que se incorporo un nuevo combo 
		que se debe de pintar deacuerdo a subcomportamiento de la la accion de incapacidad--->
		switch (comportam)
			{
			case '9':{
				hideControls(cambioempr, 3);
				hideControls('0', 4);
				}
			break;
			case '5':{
				hideControls(riesgo, 4);
				hideControls('0', 3);
				}
			break;
			default:{
				hideControls('0', 3);
				hideControls('0', 4);
				}
			} 
		</cfoutput>
		ajaxFunction1_ComboRiesgo();
		ajaxFunction1_ComboConsecuencia();
		ajaxFunction1_ComboControlIncapacidad();
	}

</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	    <td nowrap>
			<input type="hidden" name="RHTid#index#"   value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTid#index#")>#Evaluate("Attributes.query.RHTid#index#")#</cfif>">
			<input type="hidden" name="RHTpmax#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTpmax#index#")>#Evaluate("Attributes.query.RHTpmax#index#")#</cfif>">
			<input type="hidden" name="RHTsubcomportam#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTsubcomportam#index#")>#Evaluate("Attributes.query.RHTsubcomportam#index#")#</cfif>">
			<select name="RHTcodigo" tabindex="#Attributes.tabindex#" onChange="JavaScript:Asignar(this); ">
				<option value=""></option>
				<cfloop query="rsRHTipoAccionQuery">
					<option value="#RHTid#|#RHTpmax#|#RHTpfijo#|#RHTcomportam#|#RHTcempresa#|#RHTsubcomportam#">#RHTcodigo# - #RHTdesc#</option>
				</cfloop>
			</select>
		</td>
	</tr>
</table>
</cfoutput>