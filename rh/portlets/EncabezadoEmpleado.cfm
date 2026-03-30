<!---===============ENCABEZADO DEL EMPLEADO==========================================
DEBE ESTAR DEFINIDO EL DEID DEL EMPLEADO(POR URL O POR FORM) ANTES DE DEL INCLUDE
INVOCACION <cfinclude template="/rh/portlets/EncabezadoEmpleado.cfm">   
TODA LA INFORMACIÓN DEL EMPLEADO QUEDA EN UNA VARIABLE LLAMADA rsEmp
=================================================================================--->
 <iframe frameborder="0" id="Archivos" name="Archivos" height="0" width="0" src=""></iframe>
 <cfif NOT ISDEFINED('form.DEid') AND ISDEFINED('URL.DEid')>
	<CFSET form.DEid = url.DEid>
 <cfelseif NOT ISDEFINED('URL.DEid') AND ISDEFINED('form.DEid')>
 	<CFSET url.DEid = form.DEid>
</cfif>
<cfif NOT ISDEFINED('rsEmp')>
	<cfinvoke component="rh.Componentes.Empleado" 	   method="GetEmpleado" 	   returnvariable="rsEmp" DEid="#form.DEid#"/>
</cfif>
<cfif NOT ISDEFINED('fnEstaCesado')>
	<cfinvoke component="rh.Componentes.Empleado" 	   method="fnEstaCesado" 	   returnvariable="estaCesado" DEid="#form.DEid#"/>
</cfif>
<cfif isdefined("url.lvarmodo")>
	<cfset lvarmodo = url.lvarmodo>
</cfif>
<cfinvoke component="sif.Componentes.MB_Banco" method="GetBanco" returnvariable="rsBancos"/>
<cfinvoke component="rh.Componentes.Pais" 		   method="getPais" 		   returnvariable="rsPais"/>
<cfinvoke component="asp.Componentes.Roles" 	   method="VerificaRol" 	   returnvariable="CLD_ANTI"  SRcodigo="CLD_ANTI">

<cfinvoke component="asp.Componentes.Procesos"    method="VerificaProceso" 	returnvariable="CLD_ZE"  	SPcodigo="CLD_ZE">
<cfinvoke component="asp.Componentes.Procesos"    method="VerificaProceso" 	returnvariable="CLD_RFC" 	SPcodigo="CLD_RFC">
<cfinvoke component="asp.Componentes.Procesos"    method="VerificaProceso" 	returnvariable="CLD_SDI"   	SPcodigo="CLD_SDI">
<cfinvoke component="asp.Componentes.Procesos" 	  method="VerificaProceso"  returnvariable="CLD_CURP"  	SPcodigo="CLD_CURP">
<cfinvoke component="asp.Componentes.Procesos" 	  method="VerificaProceso"  returnvariable="CLD_IT"  	SPcodigo="CLD_IT">
<cfinvoke component="asp.Componentes.Procesos" 	  method="VerificaProceso"  returnvariable="CLD_CM"  	SPcodigo="CLD_CM">


<cfinvoke component="rh.Componentes.ZonaEconomica" method="GetZonasEconomicas" returnvariable="rsZE">
<cfinvoke component="rh.Componentes.RH_VacacionesEmpleado" method="GetVacaciones" returnvariable="strucVaca" DEid="#form.DEid#"/>
<cfparam name="modo" default="Cambio">
<cfif isdefined('form.DEid')>
	<cfset modo = 'CAMBIO'>
    <cfinvoke component="rh.Componentes.Empleado" method="GetEmpleado" 	 returnvariable="rsEmp" 	 DEid="#form.DEid#"/>
    <cfinvoke component="rh.Componentes.Empleado" method="fnEstaCesado"  returnvariable="estaCesado" DEid="#form.DEid#"/>
</cfif>
<script type="text/javascript">
$(document).ready(function(){
						   
$(".overlay").css("height", $(document).height()).hide();

$(".trigger").click(function(){
			var trigger = $('.trigger');
		 if (trigger.hasClass('active')) {
			$(this).toggleClass("active");
			$(this).css('zIndex', 10);
         $(".panel").toggle("fast");
		 $(".overlay").fadeToggle("normal", "linear");
		 
        } else {
			$(this).toggleClass("active");
			$(this).css('zIndex', 101);
			$(".panel").toggle("fast");
         $(".overlay").fadeToggle("normal", "linear");
        }
		return false;
	});
	
	$(".overlay").click(function(){		
			if ($('.trigger').hasClass('active')) {
				$('.trigger').toggleClass("active");
				$('.trigger').css('zIndex', 10);
				$(".panel").toggle("fast");
				$(".overlay").fadeToggle("normal", "linear");
			}
			 if ($('.menu-vert-archivos').hasClass('active')) {
				$('.menu-vert-archivos').toggleClass("active");
				$('.menu-vert-archivos').css('zIndex', 10);
				$(".panel-archivos").toggle("fast");
				$(".overlay").fadeToggle("normal", "linear");
			}	
		return false;
	});
$("#panel-empleado-close").click(function(){
			var panel_empleado = $('#panel-empleado-close');
		 if (panel_empleado.hasClass('active')) {
			$(this).toggleClass("active");
			$(this).css('zIndex', 10);
        	$(".panel").toggle("fast");
			$(".trigger").toggleClass("active");
			$(".trigger").css('zIndex', 10);
		 	$(".overlay").fadeToggle("normal", "linear");
		  	
        }  else {
			$(this).toggleClass("active");
			$(this).css('zIndex', 101);
			$(".panel").toggle("fast");
			$(".trigger").toggleClass("active");
			$(".trigger").css('zIndex', 10);
         	$(".overlay").fadeToggle("normal", "linear");
		  	
        }
		return false;
	});	

$(".triggerbigger").click(function(){
		$(".panelbigger").toggle("fast");
		$(this).toggleClass("active");
return false;
	});	
	
$(".tabla-header-right-arrow").click(function(){	
		$(".tabla-content").fadeToggle("normal", "linear");;
		$(this).toggleClass("active");

	});	
	
});

$(document).ready(function() {  
		
$(".menu-vert-archivos").click(function(){
		
			var menu_archivos = $('.menu-vert-archivos');
		 if (menu_archivos.hasClass('active')) {
			$(this).toggleClass("active");
			$(this).css('zIndex', 10);
         $(".panel-archivos").toggle("fast");
		 $(".overlay").fadeToggle("normal", "linear");
		 
        } else {
			$(this).toggleClass("active");
			$(this).css('zIndex', 101);
			$(".panel-archivos").toggle("fast");
         $(".overlay").fadeToggle("normal", "linear");
        }
		return false;
	});
	
$("#panel-archivos-close").click(function(){
		
			var panel_archivos = $('#panel-archivos-close');
		 if (panel_archivos.hasClass('active')) {
			$(this).toggleClass("active");
			$(this).css('zIndex', 10);
         	$(".panel-archivos").toggle("fast");
		 	$(".overlay").fadeToggle("normal", "linear");
	    	$(".menu-vert-archivos").toggleClass("active");		
			$(".menu-vert-archivosr").css('zIndex', 10);
        } else {
			$(this).toggleClass("active");
			$(this).css('zIndex', 101);
			$(".panel-archivos").toggle("fast");
        	$(".overlay").fadeToggle("normal", "linear");
	    	$(".menu-vert-archivos").toggleClass("active");
			$(".menu-vert-archivos").css('zIndex', 10);
        }
	});
	
});
 
</script>
<cfparam name="valueDefecto" default="No definido">
<cfset LvarCantAños = "">
<cfset LvarLabelAños = "">
<cfif len(trim(rsEmp.DEfechanac))>
	<cfset LvarCantAños = datediff('yyyy',lsparsedatetime(rsEmp.DEfechanac),now())>
    <cfif LvarCantAños EQ 1>
        <cfset LvarLabelAños = 'Año'>
    <cfelse>
        <cfset LvarLabelAños = 'Años'>
    </cfif>
</cfif>
<script language="javascript" type="text/javascript">
//-----------------------------------------------------------------
function PrintCombo(nombre, valor)
{	
	if(valor == 'true')
	{
		document.getElementById('inp_'+nombre).style.display = 'none';
		document.getElementById('comb_'+nombre).style.display = '';		
	}
	else
	{
		document.getElementById('inp_'+nombre).style.display = '';
		document.getElementById('comb_'+nombre).style.display = 'none';
	}
}
//---------------------------------------------------------------
function MostrarOtrosDatos(valor)
{
	if(valor == 'true'){
		document.getElementById('OtrosDatos').style.display = '';
		document.getElementById('FlechaMostrar').style.display = 'none';
		document.getElementById('FlechaOcular').style.display = '';
	}
	else
	{
		document.getElementById('OtrosDatos').style.display = 'none';
		document.getElementById('FlechaMostrar').style.display = '';
		document.getElementById('FlechaOcular').style.display = 'none';
	}
}
//--------------------------------------------------------------
function PrintComboAll(valor)
{
	PrintCombo('Ppais', valor);
	PrintCombo('DEemail', valor);
	PrintCombo('DEtelefono1', valor);
	PrintCombo('DEcivil', valor);
	PrintCombo('DEtelefono2', valor);
	PrintCombo('DESeguroSocial', valor);
	PrintCombo('DEfechanac', valor);
	PrintCombo('DEsexo', valor);
	PrintCombo('DEporcAnticipo', valor);
	PrintCombo('DEnombre', valor);
	PrintCombo('dirRes',valor);
	PrintCombo('dirNac', valor);
	PrintCombo('volver', valor);
	PrintCombo('DEapellido1', valor);
	PrintCombo('DEapellido2', valor);
	PrintCombo('DEcuenta', valor);
	PrintCombo('Bid', valor);
	PrintCombo('CBcc', valor);
	PrintCombo('CBTcodigo', valor);
	
	if (document.form1.cmp.value=="true"){
		PrintCombo('DEpassword', valor);
		PrintCombo('DEpasswordN', valor);
	}
	if (document.form1.sdip.value=="true"){
		PrintCombo('DEsdi', valor);
	}
	if (document.form1.itp.value=="true"){
		PrintCombo('DEtarjeta', valor);
	}
	if (document.form1.rfcp.value=="true"){
		PrintCombo('RFC', valor);
	}
	if (document.form1.zep.value=="true"){
		PrintCombo('ZEid', valor);
	}
	if (document.form1.curpp.value=="true"){
		PrintCombo('CURP', valor);
	}
	if (document.form1.curpp.value=="true"&& document.form1.rfcp.value=="true"){
		PrintCombo('IMG', valor);
	}
}
<cfif not isdefined('url.contrar')>
//----------------------------------------------------------------------
function refeshDireccion()
{
	ColdFusion.navigate('/cfmx/rh/Cloud/Empleado/Expediente-div.cfm?DIEMtipo=0&showdir=true&DEid=<cfoutput>#rsEmp.DEid#</cfoutput>&funcion=fnLightBoxOpen_Residencia()','dirRes');
	ColdFusion.navigate('/cfmx/rh/Cloud/Empleado/Expediente-div.cfm?DIEMtipo=1&showdir=true&DEid=<cfoutput>#rsEmp.DEid#</cfoutput>&funcion=fnLightBoxOpen_Nacimiento()','dirNac');
}
</cfif>
//------------------------------------------------------------------------
function CalularRFCCURP()
{	
	if (confirm('¿Esta seguro que desea calcular el RFC y el CURP?'))
	{
		fecha   	= document.form1.DEfechanac.value;
		sexo    	= document.form1.DEsexo.value;
		nombre  	= document.form1.DEnombre.value;
		paterno 	= document.form1.DEapellido1.value;
		materno 	= document.form1.DEapellido2.value;
		NivelCurp   = document.form1.NivelCurp.value;
			
		var fr  	= document.getElementById("divAjaxCurp");
		fr.src = '/cfmx/rh/expediente/catalogos/iframe-datosEmpleado.cfm?RFCCURP=true&fecha='+fecha+'&sexo='+sexo+'&nombre='+nombre+'&paterno='+paterno+'&materno='+materno+'&NivelCurp='+NivelCurp+'&fnReturn=window.parent.fnUpdCurp();';	
	}
}
//--------------------------------------------------------------------------
function fnUpdCurp()
{
	var fr2  	= document.getElementById("divAjaxCurpUpd");
	fr2.src = 'Expediente-div.cfm?DEid=<cfoutput>#rsEmp.DEid#</cfoutput>&RFC='+document.getElementById('RFC').value+'&CURP='+document.getElementById('CURP').value;
}
//------------------------------------------------------------------------
function fnUpdFechaNac()
{	
	var frFN  	= document.getElementById("divAjaxFechaNacimiento");
	frFN.src = 'Expediente-div.cfm?DEid=<cfoutput>#rsEmp.DEid#</cfoutput>&DEfechanac='+document.getElementById('DEfechanac').value;
}
//--------------------------------------------------------------------------/*/
</script>
<body>
<div class="overlay"></div>
<div id="menu-sidebar">
<div id="menu-sidebar-top"></div>
<a class="trigger" onClick="PrintComboAll('false');" title="Haga click para ver la Ficha de Empleado" href="#">
<img src="/cfmx/plantillas/Cloud/images/menu-sidebar/emp-icon.png" width="67" height="79" border="0" /></a>
<div class="panel">
<a id="panel-empleado-close" style="display: inline;"></a>
<form name="form1" id="form1">
<cfif CLD_CURP>
	<input name="curpp" type="hidden" value="true">
<cfelse>
	<input name="curpp" type="hidden" value="false">
</cfif>
<cfif CLD_ZE>
	<input name="zep" type="hidden" value="true">
<cfelse>
	<input name="zep" type="hidden" value="false">
</cfif>
<cfif CLD_RFC>
	<input name="rfcp" type="hidden" value="true">
<cfelse>
	<input name="rfcp" type="hidden" value="false">
</cfif>
<cfif CLD_SDI>
	<input name="sdip" type="hidden" value="true">
<cfelse>
	<input name="sdip" type="hidden" value="false">
</cfif>
<cfif CLD_IT>
	<input name="itp" type="hidden" value="true">
<cfelse>
	<input name="itp" type="hidden" value="false">
</cfif>
<cfif CLD_CM>
	<input name="cmp" type="hidden" value="true">
<cfelse>
	<input name="cmp" type="hidden" value="false">
</cfif>
	<H2>Información del Empleado</H2>
	<table width="860" border="0" align="left">
    	<tbody>
        	<!---======Identificacion========--->
        	<tr>
            	<td width="100">Identificación:</td>
                <td><cfoutput>#rsEmp.DEidentificacion#</cfoutput></td>
                <td>&nbsp;</td>
                <!---======Nacionalidad========--->
                <td>Nacionalidad:</td>
                <td><div id="inp_Ppais"><cfoutput>#IIF(LEN(TRIM(rsEmp.Ppais)) GT 0,'rsEmp.Nacionalidad','valueDefecto')#</cfoutput></div>
                    <div id="comb_Ppais" style="display:none">
                        <select style="max-width:130px" name="Ppais" onChange="document.getElementById('inp_Ppais').innerHTML = this[document.form1.Ppais.selectedIndex].text;">               
                            <cfloop query="rsPais">
                            <option value="<cfoutput>#rsPais.Ppais#</cfoutput>"<cfif rsPais.Ppais EQ rsEmp.Ppais> selected</cfif>><cfoutput>#rsPais.Pnombre#</cfoutput></option>
                            </cfloop>
                        </select>
                    </div> 
                  </td>
                 <!---=====Sexo=========--->      
            <td width="140">Sexo:</td>
                <td> <div id="inp_DEsexo"><cfoutput>#rsEmp.LabelDEsexo#</cfoutput></div>
                    <div id="comb_DEsexo" style="display:none">
                        <select name="DEsexo" style="width:130px" id="DEsexo" onChange="document.getElementById('inp_DEsexo').innerHTML = this[document.form1.DEsexo.selectedIndex].text;">
                            <option value="M" <cfif modo NEQ 'ALTA' and rsEmp.DEsexo EQ 'M'> selected</cfif>>
                                    <cf_translate key="LB_Masculino">Masculino</cf_translate>
                            </option>
                            <option value="F" <cfif modo NEQ 'ALTA' and rsEmp.DEsexo EQ 'F'> selected</cfif>>
                                    <cf_translate key="LB_Femenino">Femenino</cf_translate>
                            </option>
                        </select>
              </div></td>
            </tr>
            <tr>
            	<!---=====Nombre=========---> 
                <td>Nombre:</td>
                <td><div id="inp_DEnombre"><cfoutput>#rsEmp.DEnombre#</cfoutput></div>                 
                   	<cfdiv id="comb_DEnombre" style="display:none">
               			<input name="DEnombre" value="<cfoutput>#rsEmp.DEnombre#</cfoutput>" onMouseOut="document.getElementById('inp_DEnombre').innerHTML = this.value;">
              		</cfdiv>
           		</td>
                 <td></td>
                 <td>1° Apellido:&nbsp;</td>
                 <td><div id="inp_DEapellido1"><cfoutput>#rsEmp.DEapellido1#</cfoutput></div>                 
                   	<cfdiv id="comb_DEapellido1" style="display:none">
               			<input name="DEapellido1" value="<cfoutput>#rsEmp.DEapellido1#</cfoutput>" onMouseOut="document.getElementById('inp_DEapellido1').innerHTML = this.value;">
              		</cfdiv>
                  </td>
                  <td>2° Apellido:&nbsp;</td>
                <td><div id="inp_DEapellido2"><cfoutput>#rsEmp.DEapellido2#</cfoutput></div>                 
                   <cfdiv id="comb_DEapellido2" style="display:none">
               <input name="DEapellido2" value="<cfoutput>#rsEmp.DEapellido2#</cfoutput>" onMouseOut="document.getElementById('inp_DEapellido2').innerHTML = this.value;">
              </cfdiv></td>
         	</tr>
        	<tr>
                <!---==========Edad===========--->
                <td>Edad:</td>
                <td><div id="lbEdad"><cfoutput>#LvarCantAños# #LvarLabelAños#</cfoutput></div></td>
                <td>&nbsp;</td>
                <!---=======Telefono===========--->
                <td>Teléfono:</td>
                <td> 
                     <div id="inp_DEtelefono1">
						<cfoutput>#IIF(LEN(TRIM(rsEmp.DEtelefono1)) GT 0,'rsEmp.DEtelefono1','valueDefecto')#</cfoutput>
                    </div>
                    <div id="comb_DEtelefono1" style="display:none">
                   		<input name="DEtelefono1" value="<cfoutput>#rsEmp.DEtelefono1#</cfoutput>" onChange="document.getElementById('inp_DEtelefono1').innerHTML = this.value;">
                    </div>
                </td>
                <!---====Correo Eletronico====--->
                <td>E-mail:</td>
                <td> <div id="inp_DEemail"><cfoutput>#IIF(LEN(TRIM(rsEmp.DEemail)) GT 0,'rsEmp.DEemail','valueDefecto')#</cfoutput></div>
                    <cfdiv id="comb_DEemail" style="display:none">
                    <input name="DEemail" value="<cfoutput>#rsEmp.DEemail#</cfoutput>" onMouseOut="document.getElementById('inp_DEemail').innerHTML = this.value;">
                    </cfdiv></td>	
            </tr>
            <tr>
            	 <!---======= Estado Civil=======--->
            	<td>Estado Civil:</td>
                <td>
                	<div id="inp_DEcivil"><cfoutput>#IIF(LEN(TRIM(rsEmp.DEcivilLabel)) GT 0,'rsEmp.DEcivilLabel','valueDefecto')#</cfoutput></div>
                    <div id="comb_DEcivil" style="display:none">
                        <select name="DEcivil" style="width:130px" id="DEcivil" onChange="document.getElementById('inp_DEcivil').innerHTML = this[document.form1.DEcivil.selectedIndex].text;">
                         <option value="0" <cfif rsEmp.DEcivil EQ 0> selected</cfif>><cf_translate key="LB_Soltero">Soltero(a)</cf_translate></option>
                         <option value="1" <cfif rsEmp.DEcivil EQ 1> selected</cfif>><cf_translate key="LB_Casado">Casado(a)</cf_translate></option>
                         <option value="2" <cfif rsEmp.DEcivil EQ 2> selected</cfif>><cf_translate key="LB_Divorciado">Divorciado(a)</cf_translate></option>
                         <option value="3" <cfif rsEmp.DEcivil EQ 3> selected</cfif>><cf_translate key="LB_Viudo">Viudo(a)</cf_translate></option>
                         <option value="4" <cfif rsEmp.DEcivil EQ 4> selected</cfif>><cf_translate key="LB_UnionLibre">Union Libre</cf_translate></option>
                         <option value="5" <cfif rsEmp.DEcivil EQ 5> selected</cfif>><cf_translate key="LB_Separado">Separado(a)</cf_translate></option>
                        </select>
                    </div>
            	</td>	
                <td>&nbsp;</td>
                <!---=======Celular===========---> 
                <td>Celular:</td>
                <td>
                   <div id="inp_DEtelefono2"><cfoutput>#IIF(LEN(TRIM(rsEmp.DEtelefono2)) GT 0,'rsEmp.DEtelefono2','valueDefecto')#</cfoutput></div>
                   <div id="comb_DEtelefono2" style="display:none">
                    <input name="DEtelefono2" value="<cfoutput>#rsEmp.DEtelefono2#</cfoutput>" onMouseOut="document.getElementById('inp_DEtelefono2').innerHTML = this.value;">
                   </div>
                </td>
            	<!---===Fecha Nacimiento========---> 
                <td>Fecha Nacimiento:</td>
                <td><div id="inp_DEfechanac"><cfoutput>#IIF(LEN(TRIM(rsEmp.DEfechanac)) GT 0,'LSDateFormat(rsEmp.DEfechanac, "DD/MM/YYYY")','valueDefecto')#</cfoutput></div>
                    <div id="comb_DEfechanac" style="display:none">
                        <cf_jCalendar name="DEfechanac" value="#LSDateFormat(rsEmp.DEfechanac, "DD/MM/YYYY")#" nameInnerHtml="inp_DEfechanac" function="fnUpdFechaNac()">
                    </div></td>	
        	</tr>
            <tr>
            	<!---==N° Seguro Social========---> 
                <td>N° Seguro Social:</td>
                <td>
                    <div id="inp_DESeguroSocial"><cfoutput>#IIF(LEN(TRIM(rsEmp.DESeguroSocial)) GT 0,'rsEmp.DESeguroSocial','valueDefecto')#</cfoutput></div>
                    <div id="comb_DESeguroSocial" style="display:none">
                        <input name="DESeguroSocial" value="<cfoutput>#rsEmp.DESeguroSocial#</cfoutput>" onMouseOut="document.getElementById('inp_DESeguroSocial').innerHTML = this.value;"/>
                    </div>
                </td>	
                <td rowspan="2">&nbsp;</td>

                <td nowrap="" class="fileLabel">Fecha de Antig&uuml;edad: </td>
                <td>
                   <cfoutput>#strucVaca['FechaAntiguedad']#</cfoutput> 
              </td>				
              <td>Antig&uuml;edad Laboral:</td>
                <td><cfoutput>#strucVaca['AntiguedadLaboral']#</cfoutput></td>
            </tr>
            <tr>
              <td>Cuenta Cliente:</td>
              <td>
              	<div id="inp_CBcc"><cfoutput>#IIF(LEN(TRIM(rsEmp.CBcc)) GT 0,'rsEmp.CBcc','valueDefecto')#</cfoutput></div>
                <div id="comb_CBcc" style="display:none">
                    <input name="CBcc" value="<cfoutput>#rsEmp.CBcc#</cfoutput>" onMouseOut="document.getElementById('inp_CBcc').innerHTML = this.value;"/>
                </div>
				</td>
              <td nowrap="" class="fileLabel">Banco:</td>
              <td>   <cfset banco= "Indefinido">
                    	<cfloop query="rsBancos">
							<cfif rsBancos.Bid EQ rsEmp.Bid> 
                            <cfset banco= #rsBancos.Bdescripcion#> </cfif>
                        </cfloop>
                    <div id="inp_Bid"><cfoutput>#banco#</cfoutput>
                    </div> 
                    <div id="comb_Bid" style="display:none">
					<select name="Bid" id="Bid" style="width:130px" onChange="document.getElementById('inp_Bid').innerHTML = this[document.form1.Bid.selectedIndex].text;">
                    <option value="">-<cf_translate key="CMB_ninguno">Ninguno</cf_translate>-</option>
                        <cfloop query="rsBancos">
                        	<option value="<cfoutput>#rsBancos.Bid#</cfoutput>" <cfif rsBancos.Bid EQ rsEmp.Bid>selected</cfif>><cfoutput>#rsBancos.Bdescripcion#</cfoutput></option>
                        </cfloop>
                	</select>
                  </div>
                </td>
              <td>Cuenta:</td>
              <td>
              	<div id="inp_DEcuenta"><cfoutput>#IIF(LEN(TRIM(rsEmp.DEcuenta)) GT 0,'rsEmp.DEcuenta','valueDefecto')#</cfoutput></div>
                <div id="comb_DEcuenta" style="display:none">
                    <input name="DEcuenta" value="<cfoutput>#rsEmp.DEcuenta#</cfoutput>" onMouseOut="document.getElementById('inp_DEcuenta').innerHTML = this.value;"/>
                </div>              
              </td>
            </tr>
        	<tr>
                <td>Tipo de Cuenta:</td>
                <td width="150">
              	<div id="inp_CBTcodigo">
 					<cfif rsEmp.CBTcodigo EQ 0>Corriente</cfif> 
                    <cfif rsEmp.CBTcodigo EQ 1> Ahorro </cfif>
        		</div>
                <div id="comb_CBTcodigo" style="display:none">
                    <select name="CBTcodigo" onChange="document.getElementById('inp_CBTcodigo').innerHTML = this[document.form1.CBTcodigo.selectedIndex].text;" <cfif lvarSoloLectura>disabled</cfif> >
                        <option value="0" <cfif rsEmp.CBTcodigo EQ 0> selected="selected"</cfif>> Corriente</option>
                        <option value="1" <cfif rsEmp.CBTcodigo EQ 1> selected="selected"</cfif>> Ahorro</option>
                    </select>
                </div>  
                </td>
                <td width="1">&nbsp;</td>
                <!---=====Salario Diario Integrado(SDI)=====--->
                <cfif CLD_SDI>
                    <td width="140"><cf_translate key="LB_SalarioDiarioIntegrado">Salario Diario Integrado(SDI)</cf_translate>:</td>
                    <td width="130">
                        <div id="inp_DEsdi"><cfoutput>#LSCurrencyFormat(rsEmp.DEsdi,'none')#</cfoutput></div>
                        <div id="comb_DEsdi" style="display:none">
                        <input name="DEsdi" id="DEsdi" type="text"  size="20" maxlength="16" onFocus="javascript:this.value=qf(this); this.select();" 
                                    onblur="javascript:fm(this,2); "  
                                    onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                                    value="<cfoutput>#LSCurrencyFormat(rsEmp.DEsdi,'none')#</cfoutput>"/>
                         <div>
                    </td>
				</cfif>
                <cfif CLD_IT>
					<!---====ID Tarjetas===--->
                    <td><cf_translate key="LB_Id_de_Tarjeta">Id de Tarjeta</cf_translate>
                     :</td>
                    <td><div id="inp_DEtarjeta"><cfoutput>#trim(rsEmp.DEtarjeta)#</cfoutput></div>
                        <div id="comb_DEtarjeta" style="display:none">
                            <input name="DEtarjeta" id="DEtarjeta" size="20" type="text" value="<cfoutput>#trim(rsEmp.DEtarjeta)#</cfoutput>" size="25" maxlength="10"/>
                        </div></td>
                 </cfif>
           </tr>
          <tr> <cfif CLD_RFC>
                    <td><cf_translate key="LB_RFC">RFC</cf_translate>:</td>
                    <td>
                    <div id="inp_RFC"><cfoutput>#rsEmp.RFC#</cfoutput></div>
                    <div id="comb_RFC" style="display:none">
                        <input name="RFC"  type="text" value="<cfoutput>#rsEmp.RFC#</cfoutput>"  id="RFC"  maxlength="18" size="25"/>
                    </div>
                    </td>
                </cfif>
          		<td colspan="3" rowspan="2" valign="middle" align="left">
					<cfif CLD_CURP and CLD_RFC>
                        <div id="inp_IMG"></div>
                        <div id="comb_IMG" style="display:none">
                            <img src="/cfmx/rh/imagenes/inicializa.JPG" title="Calcular RFC/CURP" onClick="CalularRFCCURP()"/>
                        </div>
                    </cfif>
                </td>
                <!---====Porcentaje de Anticipos====--->
                <td>Anticipo(%):</td>
                <td><div id="inp_DEporcAnticipo"><cfoutput>#LSCurrencyFormat(rsEmp.DEporcAnticipo,'none')#</cfoutput></div> 
                    <div id="comb_DEporcAnticipo" style="display:none">
                    	<cf_inputNumber name="DEporcAnticipo"  value="#LSCurrencyFormat(rsEmp.DEporcAnticipo,'none')#" size="20" enteros="15" decimales="3" negativos="false" comas="yes" onmouseout="document.getElementById('inp_DEporcAnticipo').innerHTML = this.value;">
                    </div></td>
          </tr>
          <tr>
		  		<cfif CLD_CURP>
                    <td><cf_translate key="LB_CURP">CURP</cf_translate></td>
                    <td>
                         <div id="inp_CURP"><cfoutput>#rsEmp.CURP#</cfoutput></div>
                        <div id="comb_CURP" style="display:none">
                            <input name="CURP" type="text" value="<cfoutput>#rsEmp.CURP#</cfoutput>" id="CURP" maxlength="18" size="25"/>
                        </div>
                    </td> 
                </cfif>
				<!---====Zona Económica======--->
				<cfif CLD_ZE>
                    <td><cf_translate key="LB_ZonaEconomica">Zona Económica</cf_translate>: </td>
                    <td><div id="inp_ZEid"><cfoutput>#IIF(LEN(TRIM(rsEmp.ZEid)) GT 0,'rsEmp.ZEid','valueDefecto')#</cfoutput></div> 
                        <div id="comb_ZEid" style="display:none">
                        <select name="ZEid" style="width:130px">
                                <option value="-1">-<cf_translate key="CMB_NoAsignada">No Asignada</cf_translate>-</option>
                            <cfloop query="rsZE">
                                <option value="<cfoutput>#rsZE.ZEid#</cfoutput>" <cfif rsZE.ZEid EQ rsEmp.ZEid>selected</cfif>><cfoutput>#rsZE.ZEdescripcion#</cfoutput></option>
                            </cfloop>
                        </select>
                      </div>
                      </td>
                  </cfif>
   	      </tr>
           <tr>
                <!---====Direcciones===--->
                <td>Dir. Residencia:</td>
                <td colspan="4">
                <div id="inp_dirRes"></div>
                <div id="comb_dirRes" style="display:none">
                	<div id="dirRes"></div>
                </div>
                </td><!---====Contraseña Tarjetas===--->
                <cfif CLD_CM>
                 <td valign="top"> <div id="inp_DEpasswordN"></div><div id="comb_DEpasswordN" style="display:none"> 
   	            	<cf_translate key="LB_Contrasena_para_marcas">Contraseña para Marcas</cf_translate>:
                </div>
                </td>
                 <td valign="top">
                  <div id="inp_DEpassword"></div>
                <div id="comb_DEpassword" style="display:none"> 
                 	<input name="DEpassword" id="DEpassword" type="password" size="20" maxlength="20" value="*****">
                </div>
                </td>
                </cfif>
       		</tr>
                <td>Dir. Nacimiento:</td>
                <td colspan="4">
                <div id="inp_dirNac"></div>
                <div id="comb_dirNac" style="display:none">
                	<div id="dirNac"></div>
                </div>
                </td>
                 <td>
                </td>
                 <td>
                </td>

             </tr>
   		</tbody>
   	</table>
    	<div>
 <div id="inp_volver"  align="right"><input type="button" align="right" name="edit" value="Editar" onClick="PrintComboAll('true')" /> </div>
<div id="comb_volver" style="display:none"  align="right">	
    <input type="button" name="volver" align="right" value="Volver" onClick="PrintComboAll('false')" />
</div> 

<input name="NivelCurp"   id="NivelCurp" 	type="hidden" value="N/A"/>
<iframe id="divAjaxCurp"	  		width="0" height="0" frameborder="0"></iframe>
<iframe id="divAjaxCurpUpd" 		width="0" height="0" frameborder="0"></iframe>
<iframe id="divAjaxFechaNacimiento" width="0" height="0" frameborder="0"></iframe>
<cfset LvarCLD= "">
 <cfif CLD_CURP>
	<cfset LvarCLD = "&CURP={CURP}">
  </cfif>
  <cfif CLD_ZE and rsZE.recordcount GT 0>
	<cfset LvarCLD= LvarCLD & "&ZEid={ZEid}">
  </cfif>
  <cfif CLD_SDI>
  	<cfset LvarCLD= LvarCLD & "&DEsdi={DEsdi}">
  </cfif>
  <cfif CLD_RFC>
  	<cfset LvarCLD= LvarCLD & "&RFC={RFC}">
  </cfif>
  <cfif CLD_IT>
  	<cfset LvarCLD= LvarCLD & "&DEtarjeta={DEtarjeta}">
  </cfif>
  <cfif CLD_CM>
  	<cfset LvarCLD= LvarCLD & "&DEpassword={DEpassword}">
  </cfif>  
   <cfdiv bind="url:/cfmx/rh/Cloud/Empleado/Expediente-div.cfm?DEnombre={DEnombre}&DEapellido1={DEapellido1}&DEapellido2={DEapellido2}&DEemail={DEemail}&DEid=#rsEmp.DEid#&DESeguroSocial={DESeguroSocial}&DEtelefono1={DEtelefono1}&DEtelefono2={DEtelefono2}&Ppais={Ppais}&DEcivil={DEcivil}&DEfechanac={DEfechanac}&DEsexo={DEsexo}#LvarCLD#&DEporcAnticipo={DEporcAnticipo}&Bid={Bid}&CBTcodigo={CBTcodigo}&CBcc={CBcc}&DEcuenta={DEcuenta}"
   bindOnLoad="false" 
   ID="theDivDEemail"/>
   
<cf_Lightbox link="" titulo="Dirección Residencia" width="60" height="50" name="Residencia" url="/cfmx/rh/Cloud/Empleado/Direccion.cfm?DIEMtipo=0&DEid=#rsEmp.DEid#"></cf_Lightbox>
<cf_Lightbox link="" titulo="Dirección Nacimiento" width="60" height="50" name="Nacimiento" url="/cfmx/rh/Cloud/Empleado/Direccion.cfm?DIEMtipo=1&DEid=#rsEmp.DEid#"></cf_Lightbox>
<cfif not isdefined('url.contrar')>
	<script language="javascript" type="text/javascript">
        refeshDireccion();
    </script> 
</cfif>
</form>
<!---  </div><!-- CIERRA PANEL BIGGER -->--->
	</div>
	</div>
    
<!---</div> <!-- CIERRA PANEL -->--->
<ul>
<li class="separator"></li>
<li class="drop"> <a href="#" class="menu-vert-acciones">Acciones</a>
<ul>

<li class="first"><a href="/cfmx/rh/Cloud/Empleado/windowsAusencia.cfm?DEid=<cfoutput>#form.DEid#</cfoutput>&Tcodigo=<cfoutput>#rsEmp.Tcodigo#</cfoutput>"  id="RegAusencia">Registrar Ausencias</a></li>
      <cfsavecontent variable="RegAusencia"></cfsavecontent>
<cf_Lightbox link="#RegAusencia#" titulo="Nueva Ausencia" width="60" height="60" autoScale="true" name="RegAusencia" url="windowsAusencia.cfm?DEid=#form.DEid#"></cf_Lightbox>
<!---<li class="separator"></li>
<li><a href="windowsDeducciones.cfm?DEid=<cfoutput>#form.DEid#</cfoutput>" id="RegDeduccion"> Registrar Deducciones</a></li>
	<cfsavecontent variable="RegDeduccion"></cfsavecontent>
<cf_Lightbox link="#RegDeduccion#" Titulo="Nueva Deducción" width="50" height="50" name="RegDeduccion" url="windowsDeducciones.cfm?DEid=#rsEmp.DEid#"></cf_Lightbox>--->
<li class="separator"></li>
<li><a href="/cfmx/rh/Cloud/Empleado/windowsIncapacidad.cfm?DEid=<cfoutput>#rsEmp.DEid#</cfoutput>&Tcodigo=<cfoutput>#rsEmp.Tcodigo#</cfoutput>" id="RegIncapacidad" > Registro de Incapacidades</a></li>
	<cfsavecontent variable="RegIncapacidad"></cfsavecontent>
<cf_Lightbox link="#RegIncapacidad#" titulo="Nueva Incapacidad" width="60" height="60" autoScale="true" name="RegIncapacidad" url="windowsIncapacidad.cfm?DEid=#rsEmp.DEid#&Tcodigo=#rsEmp.Tcodigo#"></cf_Lightbox>

			<!---Esto va en un Menu--->
            <cfif not lvarSoloLectura>
             <li class="separator"></li>
             <li><a href="/cfmx/rh/Cloud/Empleado/NuevoEmpleado.cfm?modo=cambio&nombrar=nombrar&DEid=<cfoutput>#form.DEid#</cfoutput>"  id="Nombrar">Nombrar</a></li>
                <cfsavecontent variable="Nombrar"></cfsavecontent>
                <cf_Lightbox link="#Nombrar#" titulo="Nombrar" width="80" height="100" name="Nombrar" url="/cfmx/rh/Cloud/Empleado/NuevoEmpleado.cfm?nombrar=nombrar&DEid=#form.DEid#"></cf_Lightbox>
            </cfif>
            <cfquery name="rsLiq" datasource="#session.dsn#">
                select count(1) as cantidad
                from RHLiquidacionPersonal
                where Ecodigo= #session.Ecodigo#
                  and RHLPestado = 1
                  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
            </cfquery>
            <cfif (rsEmp.Activo and not estaCesado) or (estaCesado)>
            <li class="separator"></li>
                    <li><a href="/cfmx/rh/Cloud/Empleado/windowsCeseLiquidacion.cfm?tipo=1&DEid=<cfoutput>#form.DEid#</cfoutput>&RHTcodigo=<cfoutput>#rsEmp.Tcodigo#</cfoutput>" id="Cese" >Cese</a></li>
                <cfsavecontent variable="Cese"></cfsavecontent>
                <cf_Lightbox link="#Cese#" titulo="Cese" width="60" height="50" name="Cese" url="/cfmx/rh/Cloud/Empleado/windowsCeseLiquidacion.cfm?tipo=1&DEid=#form.DEid#"></cf_Lightbox>
            </cfif>
            <cfif rsLiq.cantidad gt 0 and rsEmp.Activo and estaCesado and lvarSoloLectura>
            	<li class="separator"></li>
				<li><a href="/cfmx/rh/Cloud/Empleado/windowsReporte.cfm?DEid=<cfoutput>#form.DEid#</cfoutput>" id="ReporteLiq" >Reportes Liquidaci&oacute;n</a></li>
                <cfsavecontent variable="ReporteLiq"></cfsavecontent>
                <cf_Lightbox link="#ReporteLiq#" titulo="" width="80" height="80" name="ReporteLiq" url="/cfmx/rh/Cloud/Empleado/windowsReporte.cfm?DEid=#form.DEid#"></cf_Lightbox>
                <cfif isdefined('form.abrirReporteLiq')>
                    <cf_Lightbox link="" titulo="" width="80" height="80" name="AbrirReportesLiq" url="/cfmx/rh/Cloud/Empleado/windowsReporte.cfm?DEid=#form.DEid#&DLlinea=#form.DLlinea#&noRegresar=noRegresar"></cf_Lightbox>
                    <script type="text/javascript">
                    $(document).ready(function() {
                        fnLightBoxOpen_AbrirReportesLiq();
                    });
                    </script>
                </cfif>
            </cfif> 
<li class="separator"></li>
<li class="last"><a href="windowsCargas.cfm?DEid=<cfoutput>#rsEmp.DEid#</cfoutput>"  id="RegCarga">Registrar Cargas Obrero Patronal</a></li>
<cfsavecontent variable="RegCarga"></cfsavecontent>
<cf_Lightbox link="#RegCarga#" titulo="Nueva Cargas" width="60" height="40" autoScale="true" name="RegCarga" url="windowsCargas.cfm?DEid=#rsEmp.DEid#"></cf_Lightbox>
</ul>

</li>
<li class="separator"></li>
<li><a href="#" class="menu-vert-archivos">Archivos</a></li>
<cfif lvarmodo eq "EXPEDIENTE" >
<li class="separator"></li>
<li><a href="/cfmx/rh/Cloud/Empleado/index.cfm?lvarmodo=LIQUIDACION&DEid=<cfoutput>#url.DEid#</cfoutput>" class="menu-vert-liquidacion">Liquidaci&oacute;n</a></li>
<cfelse>
<li class="separator"></li>
<li><a href="/cfmx/rh/Cloud/Empleado/index.cfm?lvarmodo=EXPEDIENTE&DEid=<cfoutput>#url.DEid#</cfoutput>" class="menu-vert-Expediente">Expediente</a></li>
</cfif>
<li class="separator"></li>
</ul> 

<div class="panel-archivos">
<a id="panel-archivos-close" style="display: inline;"></a>
<div class="archivos-content">
<div class="panel-archivos-top">

<a href="#" title="Agregar Archivo" onClick="return fnNuevoarchivo(this,<cfoutput>#form.DEid#</cfoutput>)">Agregar Archivo</a>
  <cf_notas  link="" titulo="Agregar Archivo" msg=" " width="450" modal="true" pageIndex="1"> 
</div>
<cfdiv style="width:100%;height:300px;overflow:auto;" >
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descargar"
	Default="Descargar"
	returnvariable="LB_Descargar"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Modificar"
	Default="Modificar"
	returnvariable="LB_Modificar"/>	
					<cf_dbfunction name="to_char" args="RHAEid" returnvariable="vRHAEid">
					<cfinvoke component="rh.Componentes.ArchivosEmpleado" method="getLista" returnvariable="rsLista">
                    	<cfinvokeargument name="DEid" value="#form.DEid#">
                        <cfinvokeargument name="vRHAEid" value="#vRHAEid#">
                       <cfinvokeargument name="LB_Modificar" value="#LB_Modificar#">
                        <cfinvokeargument name="LB_Descargar" value="#LB_Descargar#">
                        <cfif isdefined("form.txtRHAEdescr") and len(trim(form.txtRHAEdescr))>
                            <cfinvokeargument name="txtRHAEdescr" value="#form.txtRHAEdescr#">
                        </cfif>
                        <cfif isdefined("form.RHAEtipoFiltro") and len(trim(form.RHAEtipoFiltro))>
                        	<cfinvokeargument name="RHAEtipoFiltro" value="#form.RHAEtipoFiltro#"> 
                        </cfif>
                    </cfinvoke> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <cfloop query="rsLista">
    <tr> 
    	<cfif rsLista.RHAEtipo eq "jpg" or rsLista.RHAEtipo eq "png" or rsLista.RHAEtipo eq "JPG" or rsLista.RHAEtipo eq "PNG">
        	<td width="15%"><img src="/cfmx/plantillas/Cloud/images/icon-image.png" width="34" height="36" /></td>
        <cfelse>
        	<td width="15%"><img src="/cfmx/plantillas/Cloud/images/icon-pdf.png" width="35" height="36" />
        </td></cfif>
      	
        <td>
            <span class="archivos-date"><cfoutput>#DateFormat(rsLista.RHAEfecha)#</cfoutput></span><br />
        	<input name="RHAEdescr" id="RHAEdescr" size="30" maxlength="30" value="<cfoutput>#rsLista.RHAEdescr#</cfoutput>" /><br/>
            <span class="archivos-name"><cfoutput>#rsLista.RHAEarchivo#</cfoutput></span>
        </td>
        <td class="archivos-icon" width="20%">
            <a name="Descargar" title="Descargar" onClick="Descargar(<cfoutput>#RHAEid#</cfoutput>)" class="archivos-icon-download"></a> 
             <img style="cursor:pointer" onClick="fnBajaArchivo(<cfoutput>#RHAEid#</cfoutput>);" name="Eliminar" src="/cfmx/sif/imagenes/Borrar01_S.gif">
        </td>
    </tr>
  </cfloop> 
</table>

</cfdiv>

</div><!-- CIERRA ARCHIVOS content -->
<cfif rsLista.RecordCount>
	<cfdiv bind="url:/cfmx/rh/Cloud/Empleado/acciones_archivos-sql.cfm?modoA=CAMBIO&RHAEdescr={RHAEdescr}&RHAEid=#rsLista.RHAEid#" bindOnLoad="false"/>
</cfif>

</div><!-- CIERRA PANEL ARCHIVOS -->

<div id="menu-sidebar-bottom"></div>
</div><!-- CIERRA menu sidebar -->
</body>
 <iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" ></iframe>

<script language="JavaScript" type="text/javascript">
	function Descargar(llave){
		var RHAEid		= llave;
		params = "?RHAEid="+RHAEid;
		var frame = document.getElementById("FRAMECJNEGRA");
	    frame.src = "/cfmx/rh/Cloud/Empleado/descargararchivo.cfm"+params;		
	}	
	function fnNuevoarchivo(e,DEid){
		fnMostrarToolTipArchi_1(e,false,fnCrearArchi(DEid));
	}
	function fnCrearArchi(DEid){
			nota = "<a id='tooltip-archivos-close' style='display: inline;' onClick=' fnCerrarToolTip_1()'></a><form name='form22' method='post' action='/cfmx/rh/Cloud/Empleado/acciones_archivos-sql.cfm' enctype='multipart/form-data' onSubmit='javascript:return fnValidar();'><table cellspacing='1' width='100%'><input type='hidden' name='modoA' value='ALTA'><input type='hidden' name='urlpag' value='"+document.URL+"'><input type='hidden' name='DEid' value='<cfoutput>#form.DEid#</cfoutput>'><input type='hidden' name='RHAEfecha' value='<cfoutput>#LSDateFormat(Now(), 'DD/MM/YYYY')#</cfoutput>'> <tr><td> Descripcion: <input type='text' value='' name='RHAEdescr' id='RHAEdescr'></td> </tr><tr><td ><strong><cf_translate  key='LB_Archivo'>Archivo</cf_translate>:&nbsp;</strong> <input type='file' name='archivo' ></td></tr> <tr><td align='center'><input class='btnGuardar' type='submit' name='Cargar'  value='Cargar Archivo'> </td></tr>";
		nota = nota + "<table></form>";
		return nota;
	}
	function fnBajaArchivo(RHAEid){
		document.getElementById("Archivos").src="/cfmx/rh/Cloud/Empleado/acciones_archivos-sql.cfm?modoA=BAJA&RHAEid="+RHAEid;
		setTimeout('document.location.reload()',1000);
	}
	function fnValidar(){
		error = "";
		if(document.form22.RHAEdescr.value == "" )
			error += "\n - El campo Decripcion es requerido.";
		if(document.form22.archivo.value == "" )
			error += "\n - El campo Archivo es requerido.";
		if(error != ""){
			alert("Se presentaron los sigiuentes problemas:"+error);
			return false
		}
		return true;
	}
</script>