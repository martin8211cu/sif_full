
<cfinvoke component="rh.Componentes.Pais" 		   method="getPais" 		   returnvariable="rsPais"/>
<cfinvoke component="asp.Componentes.Procesos" 	  method="VerificaProceso"  returnvariable="CLD_PTU"  	SPcodigo="CLD_PTU">
<cfinvoke component="rh.Componentes.TipoNomina" method="GetTipoNomina" returnvariable="rsTNominaGN">
    <cfinvokeargument name="Tcodigo" value="#form.Tcodigo#">
</cfinvoke>
<!---Reviso si tiene calendarios y si tiene empleados sino muestro el boton de eliminar--->
    <cfinvoke component="rh.Componentes.CalendarioPago" method="getCalendarioPago" Tcodigo="#form.Tcodigo#" returnvariable="rsCP"/>
	<cfinvoke component="rh.Componentes.Empleado" 	   method="GetEmpleado" 	   Tcodigo="#form.Tcodigo#" returnvariable="rsEmp" />

    
<script type="text/javascript">
$(document).ready(function(){
						   
$(".overlay").css("height", $(document).height()).hide();

$(".trigger-nomina").click(function(){
			var trigger = $('.trigger-nomina');
		 if (trigger.hasClass('active')) {
			$(this).toggleClass("active");
			$(this).css('zIndex', 10);
         $(".panelGN").toggle("fast");
		 $(".overlay").fadeToggle("normal", "linear");
		 
        } else {
			$(this).toggleClass("active");
			$(this).css('zIndex', 101);
			$(".panelGN").toggle("fast");
         $(".overlay").fadeToggle("normal", "linear");
        }
		return false;
	});
	
	$(".overlay").click(function(){		
			if ($('.trigger-nomina').hasClass('active')) {
				$('.trigger-nomina').toggleClass("active");
				$('.trigger-nomina').css('zIndex', 10);
				$(".panelGN").toggle("fast");
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
        	$(".panelGN").toggle("fast");
			$(".trigger-nomina").toggleClass("active");
			$(".trigger-nomina").css('zIndex', 10);
		 	$(".overlay").fadeToggle("normal", "linear");
		  	
        }  else {
			$(this).toggleClass("active");
			$(this).css('zIndex', 101);
			$(".panelGN").toggle("fast");
			$(".trigger-nomina").toggleClass("active");
			$(".trigger-nomina").css('zIndex', 10);
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
	function estaVacio(s){
		return trim(s).length == 0;
	}
	function fnValidarPRG(){
		error="";
		if(estaVacio(document.formPRG.Tdescripcion.value))
		error += "\n - El campo Nombre es requerido.";
		
		if(!estaVacio(error)){
			alert("Se presentaron los sigiuentes problemas:"+error);
			
			return false
		}
		
		if(confirm("Esta seguro de modificar el Grupo de Nómina?"))
					return true;
				return false;

	}
	function fnSetFactorDiasS(){
		if(document.formPRG.Ttipopago.value == 0 || document.formPRG.Ttipopago.value == 1 ){
			document.formPRG.FactorDiasSalario.value = 30.333;
		}
		else if(document.formPRG.Ttipopago.value == 3 || document.formPRG.Ttipopago.value== 2){
			document.formPRG.FactorDiasSalario.value = 30; 
		}
	}
</script>
<body>
<div class="overlay"></div>
<div id="menu-sidebar">
<div id="menu-sidebar-top"></div>
<a class="trigger-nomina" title="Haga click para ver la Ficha de Empleado" href="#">
</a>
<div class="panelGN">
<a id="panel-empleado-close" style="display: inline;"></a>
<form method="post" id="formPRG" name="formPRG" action="/cfmx/rh/Cloud/Nomina/Nomina-SQL.cfm" onSubmit="return fnValidarPRG();" >
	<input type="hidden" name="PRG" 	 id="PRG" 	   value="PRG" />
    <input type="hidden" name="Tcodigo" id="Tcodigo" value="<cfoutput>#rsTNominaGN.Tcodigo#</cfoutput>">
   	<h2>Informacion del Grupo de N&oacute;mina</h2>
<table>
<tr>
<td class="text_align_right">
<a class="panel_titulo">Nombre del Grupo </a>
</td>
<td class="text_align_left">
<a class="panel_detalle"><input name="Tdescripcion" id="Tdescripcion" type="text" width="100" value="<cfoutput>#rsTNominaGN.Tdescripcion#</cfoutput>"> </a>
</td>
</tr>
<tr>
<td class="text_align_right">
<a class="panel_titulo">Tipo de Pago </a>
</td>
<td class="text_align_left">
<a class="panel_detalle">
<cfif NOT rsCP.recordCount and NOT rsEmp.recordCount>
       <select name="Ttipopago" id="Ttipopago" style="width:100%" onChange="fnSetFactorDiasS();">
            <option value="0" <cfif rsTNominaGN.Ttipopago eq 0>selected</cfif>>Semanal </option>
            <option value="1" <cfif rsTNominaGN.Ttipopago eq 1>selected</cfif>>Bisemanal </option>
            <option value="2" <cfif rsTNominaGN.Ttipopago eq 2>selected</cfif>>Quincenal </option>
            <option value="3" <cfif rsTNominaGN.Ttipopago eq 3>selected</cfif>>Mensual </option>
        </select>
<cfelse>
        <input type="hidden" name="Ttipopago" id="Ttipopago" value="<cfoutput>#rsTNominaGN.Ttipopago#</cfoutput>">
        <cfif rsTNominaGN.Ttipopago EQ 0> Semanal 
        <cfelseif  rsTNominaGN.Ttipopago EQ 1> Bisemanal
        <cfelseif  rsTNominaGN.Ttipopago EQ 2> Quincenal
        <cfelseif  rsTNominaGN.Ttipopago EQ 3> Mensual
        <cfelseif  rsTNominaGN.Ttipopago EQ 4> Horas
        </cfif>
</cfif>
		<!---Se cambia el modo de establecer el Factor dias de Salario pues estaba erroneo--->
        <cfif rsTNominaGN.Ttipopago eq 0 or rsTNominaGN.Ttipopago eq 1 > 
            <input type="hidden" name="FactorDiasSalario" id="FactorDiasSalario" value="30.333" />
        <cfelseif rsTNominaGN.Ttipopago eq 2 or rsTNominaGN.Ttipopago eq 3 > 
            <input type="hidden" name="FactorDiasSalario" id="FactorDiasSalario" value="30" /> 
        <cfelse>
            <input type="hidden" name="FactorDiasSalario" id="FactorDiasSalario" value="30.333" />
        </cfif> 
</a>
</td>
</tr>
</td>
<td class="text_align_left">
<a class="panel_detalle">
	<input type="submit" name="Cambio" id="Cambio" value="Modificar"> 
<cfif NOT rsCP.recordCount and NOT rsEmp.recordCount>
	<input type="submit" name="Baja" id="Baja" value="Eliminar">
</cfif>
</a>
</td>
</tr>
</table>
</form>
</div><!-- CIERRA PANEL BIGGER -->
<cfif modoEmp neq true>
<ul>
    <li class="separator"></li>
    <cfif isdefined("form.Tcodigo")>
   	<li class="drop"> <a href="#" class="menu-vert-acciones">Acciones</a>
        <ul>
            <li class="first"><a href="#" onClick="fnLightBoxOpen_Aguinaldo()">Pago de Aguinaldos</a></li>
           <cfif CLD_PTU>
                <li class="separator"></li>
                <li><a href="#" onClick="fnLightBoxOpen_PTU()">Pago de de PTU</a></li>
            </cfif>
            <li class="separator"></li>
            <li><a href="#"  onclick="fnLightBoxOpen_Vacaciones()">Vacaciones Masivas</a></li>
            <li class="separator"></li>
            <li><a href="#" onClick="fnLightBoxOpen_DeducMasivas()">Deducciones Masivas</a></li>
            <li class="separator"></li>
            <li class="last"><a href="#" onClick="fnLightBoxOpen_IncMasivas()">Incidencias Masivas</a></li>
        </ul>
  	
    <li class="separator"></li>
       <cf_Lightbox link="" Titulo="Deducciones Masivas" width="70" height="80" name="DeducMasivas" url="/cfmx/rh/Cloud/Nomina/windowsDeducMasivas.cfm?Tcodigo=#form.Tcodigo#"></cf_Lightbox>
       <cf_Lightbox link="" Titulo="PTU" width="100" height="90" name="PTU" url="/cfmx/rh/Cloud/Nomina/windowsPTU.cfm?Tcodigo=#form.Tcodigo#"></cf_Lightbox>
       <cf_Lightbox link="" Titulo="Incidencias Masivas" width="70" height="50" name="IncMasivas" url="/cfmx/rh/Cloud/Nomina/windowsIncMasivas.cfm?Tcodigo=#form.Tcodigo#"></cf_Lightbox>
      </cfif>
</ul> 
<cfelse>
<ul>
    <li class="separator"></li>
    <cfif isdefined("form.Tcodigo")>
   	<li class="drop"> <a href="#" class="menu-vert-acciones">Acciones</a>
        <ul>
            <li class="first"><a href="#" onClick="fnLightBoxOpen_DeducMasivas()">Deducciones Masivas</a></li>
            <li class="separator"></li>
            <li class="last"><a href="#" onClick="fnLightBoxOpen_IncMasivas()">Incidencias Masivas</a></li>
        </ul>
       <cf_Lightbox link="" Titulo="Deducciones Masivas" width="70" height="80" name="DeducMasivas" url="/cfmx/rh/Cloud/Nomina/windowsDeducMasivas.cfm?Tcodigo=#form.Tcodigo#"></cf_Lightbox>
       <cf_Lightbox link="" Titulo="PTU" width="100" height="90" name="PTU" url="/cfmx/rh/Cloud/Nomina/windowsPTU.cfm?Tcodigo=#form.Tcodigo#"></cf_Lightbox>
       <cf_Lightbox link="" Titulo="Incidencias Masivas" width="70" height="50" name="IncMasivas" url="/cfmx/rh/Cloud/Nomina/windowsIncMasivas.cfm?Tcodigo=#form.Tcodigo#"></cf_Lightbox>
      </cfif>
    <li class="separator"></li>
</ul> 
</cfif>

<div id="menu-sidebar-bottom"></div>
</div><!-- CIERRA menu sidebar -->
<cfset params = "">
<cfif isdefined('form.Tcodigo') and len(trim(form.Tcodigo))>
	<cfset params = "Tcodigo=#form.Tcodigo#">
</cfif>
<cf_Lightbox link="" Titulo="Grupo de Nomina"    width="55" height="30" name="GrupoNomina" url="/cfmx/rh/Cloud/Nomina/windowsNuevoGrupo.cfm?#params#"></cf_Lightbox>
<cf_Lightbox link="" Titulo="Pago de Aguinaldos" width="50" height="70" name="Aguinaldo"   url="/cfmx/rh/Cloud/Nomina/Aguinaldo.cfm"></cf_Lightbox>