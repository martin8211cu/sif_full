<cf_navegacion name="MODO"  						default="ALTA">
<cf_navegacion name="GFAid" 						default="">
<cf_navegacion name="rsSelected.GFAid" 				default="">
<cf_navegacion name="rsSelected.GFACodigo" 			default="">
<cf_navegacion name="rsSelected.GFADescripcion" 	default="">
<cf_navegacion name="rsSelected.GFAPeriodicidad" 	default="">
<cf_navegacion name="rsSelected.GFAMetodo" 			default="">
<cf_navegacion name="rsSelected.GFAPorcentaje"		default="">
<cf_importJQuery>
<script language="javascript" type="text/javascript">
	$(document).ready(function(){
		$("#GFAMetodo").change(function (){
        	$("#GFAMetodo option:selected").each(function (){
                     if($(this).val() == 1) {$("#TRPorcentaje").hide("slow");$("#GFAPorcentaje").val(0);}
				else if($(this).val() == 2) {$("#TRPorcentaje").show(500);}
				else if($(this).val() == 3) {$("#TRPorcentaje").hide(500);$("#GFAPorcentaje").val(0);}
			}); }).change();});
	function validaporcentaje(){
		if($("#GFAPorcentaje").val() < 0 || $("#GFAPorcentaje").val() > 100){
			alert('El porcentaje debe ser un valor entre 0 y 100');
			return false;
		}
			return true;
	}
</script>
<cfif LEN(TRIM(form.GFAid))>
	<cfset MODO = 'CAMBIO'>
	<cfinvoke component="sif.Componentes.FAGeneracionAuto" method="GetGFATipos" returnvariable="rsSelected">
    	<cfinvokeargument name="GFAid" value="#form.GFAid#">
	</cfinvoke>
</cfif>
<cfinvoke component="sif.Componentes.FAGeneracionAuto" method="GetGFATipos" returnvariable="rsLista">
</cfinvoke>

<cf_templateheader title="Facturación">
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Tipos de Generación de Facturas">
		<cfinclude template="TiposGeneracion-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>