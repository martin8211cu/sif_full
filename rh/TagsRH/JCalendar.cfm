<cfparam name="Attributes.Name"  		 default="CapoFecha" type="string">
<cfparam name="Attributes.Value" 		 default="" 		 type="string">
<cfparam name="Attributes.function" 	 default="" 		 type="string"><!---Nombre de la funcion que se quiere que se ejecute en el onSelect--->
<cfparam name="Attributes.nameInnerHtml" default="" 		 type="string"><!---Un objeto que se le pueda hacer InnerHtml, con la fecha seleccionada--->
<cfparam name="Attributes.onChange" 	 default="" 		 type="string"><!---Nombre de la funcion que se quiere que se ejecute en el onChange--->
<cfparam name="Attributes.readOnly" 	 default="false" 	 type="boolean">

<script>
	!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
</script>
<cfif NOT isdefined('request.Scrip_jqueryIdioma')>
	<script src="/cfmx/jquery/jquery-grid/js/i18n/grid.locale-es.js" type="text/javascript"></script>
	<cfset request.Scrip_jqueryIdioma = true>
</cfif>
<cfif not isdefined('request.jCalendar')>
	<script src="/cfmx/jquery/jquery-ui/js/jquery.ui.core.js" type="text/javascript"></script>
    <script src="/cfmx/jquery/jquery-ui/js/jquery.ui.widget.js" type="text/javascript"></script>
    <script src="/cfmx/jquery/jquery-ui/js/jquery.ui.datepicker.js" type="text/javascript"></script>
    <cfset request.jCalendar = true>
</cfif>

<cfparam name="Request.jsMask" default="false">
<cfif Request.jsMask EQ false>
	<cfset Request.jsMask = true>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cfif>

<div id="div_<cfoutput>#Attributes.Name#</cfoutput>">
	<input name="<cfoutput>#Attributes.Name#</cfoutput>" id="<cfoutput>#Attributes.Name#</cfoutput>" type="text" value="<cfoutput>#Attributes.Value#</cfoutput>" size="10" maxlength="11" <cfif Attributes.readOnly eq true>readonly</cfif>>
    <input type="hidden" name="JCT_<cfoutput>#Attributes.Name#</cfoutput>" id="JCT_<cfoutput>#Attributes.Name#</cfoutput>" value="<cfoutput>#Attributes.Value#</cfoutput>">
</div>
<script type="text/javascript" language="JavaScript1.2">
   $("#JCT_<cfoutput>#Attributes.Name#</cfoutput>").datepicker({
      showOn: 'both',
      buttonImage: '/cfmx/rh/imagenes/calendar.gif',
      buttonImageOnly: true,
      changeYear: true,
	  changeMonth: true,
      numberOfMonths: 1,
	  disabled : true,
	  dateFormat: 'dd/mm/yy',
	  altField: $('#<cfoutput>#Attributes.Name#</cfoutput>'),
	  onSelect: function(textoFecha, objDatepicker){
		 if(esFechaValida(this)){
			 <cfif LEN(TRIM(Attributes.nameInnerHtml))>
			 $("#<cfoutput>#Attributes.nameInnerHtml#</cfoutput>").html(textoFecha);
			 </cfif>
			 <cfif LEN(TRIM(Attributes.function))>
				<cfoutput>#Attributes.function#</cfoutput>;
			 </cfif>
		 }

      }
   })<cfif Attributes.readOnly eq true>.datepicker("disable")</cfif>;
   
   oDateMask = new Mask("dd/mm/yyyy", "date");
   oDateMask.attach(document.getElementById('<cfoutput>#Attributes.Name#</cfoutput>'),"dd/mm/yyyy", "date", "", "", "", "if(esFechaValida(this)){<cfif LEN(TRIM(Attributes.function))><cfoutput>#Attributes.function#</cfoutput>;<cfelse>return true;</cfif>};", "");
   
   function esFechaValida(fecha){
        if (fecha != undefined && fecha.value != "" ){
            if (!/^\d{2}\/\d{2}\/\d{4}$/.test(fecha.value)){
                fecha.value = "";
                return false;
            }
            var dia  =  parseInt(fecha.value.substring(0,2),10);
            var mes  =  parseInt(fecha.value.substring(3,5),10);
            var anio =  parseInt(fecha.value.substring(6),10);
     
			switch(mes){
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					numDias=31;
					break;
				case 4: case 6: case 9: case 11:
					numDias=30;
					break;
				case 2:
					if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
					break;
				default:
					fecha.value = "";
					return false;
			}
     
            if (dia>numDias || dia==0){
                fecha.value = "";
                return false;
            }
            return true;
        }
    }	
	
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
			}
		else {
			return false;
			}
    }


</script>