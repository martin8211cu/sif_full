<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_RegistroDeRelacionesDevaloracion"
						Default="Registro de Relaciones de valoraci&oacute;n"
						returnvariable="LB_RegistroDeRelacionesDevaloracion"/>		
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_EvaluaciondelDesempeno"
						Default="Evaluaci&oacute;n del Desempeño"
						returnvariable="LB_EvaluaciondelDesempeno"/>			
                  	
                    <cf_web_portlet_start border="true" titulo="#LB_RegistroDeRelacionesDevaloracion#" skin="#Session.Preferences.Skin#">
						<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0><cfset form.sel = url.sel></cfif>
						<cfif isdefined("url.RHVPid") and len(trim(url.RHVPid)) gt 0><cfset form.RHVPid = url.RHVPid></cfif>
						<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0><cfset form.modo = url.modo></cfif>
						<cfif isdefined("url.Nuevo") and len(trim(url.Nuevo)) gt 0><cfset form.Nuevo = url.Nuevo></cfif>
                        
						<cfif isdefined("url.FRHPcodigo") and len(trim(url.FRHPcodigo)) gt 0><cfset form.FRHPcodigo = url.FRHPcodigo></cfif>
						<cfif isdefined("url.FRHPdescpuesto") and len(trim(url.FRHPdescpuesto)) gt 0><cfset form.FRHPdescpuesto = url.FRHPdescpuesto></cfif>
						<cfif isdefined("url.CFid") and len(trim(url.CFid)) gt 0><cfset form.CFid = url.CFid></cfif>

                        
                        
				
						<cfparam name="form.sel" default="1" type="numeric">
						<cfif (form.sel gt 0) and (isdefined("form.Nuevo") or (isdefined("form.RHVPid") and len(trim(form.RHVPid)) gt 0))>
							<cfset Regresar  = "/cfmx/rh/ValoracionPuestos/operacion/registro_valoracion.cfm">
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td width="2%" rowspan="3">&nbsp;</td>
								<td width="74%">&nbsp;</td>
								<td width="2%">&nbsp;</td>
								<td width="20%">&nbsp;</td>
								<td width="2%" rowspan="3">&nbsp;</td>
							  </tr>
							  <tr>
								<td valign="top" align="center">
                                    <cfinclude template="registro_valoracion_header.cfm">
									<cfswitch expression="#sel#">						
										<cfcase value="1"><cfinclude template="registro_valoracion_form.cfm"></cfcase>
										 <cfcase value="2"><cfinclude template="formClasificacionGradoPuesto.cfm"></cfcase>
										<cfcase value="3"><cfinclude template="formDispersionPuesto.cfm"></cfcase>
									</cfswitch>
								</td>
								<td>&nbsp;</td>
								<td valign="top" align="center">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td>
                                            	<cfinclude template="registro_valoracion_pasos.cfm">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                            	<cfinclude template="registro_valoracion_Rep.cfm">
                                            </td>
                                        </tr>
                                        <cfif sel eq  3>
                                            <tr>
                                                <td>
                                                    <cfinvoke component="sif.Componentes.Translate"
                                                    method="Translate"
                                                    Key="LB_Equilibrio_Interno_Propuesto"
                                                    Default="Equilibrio Interno (Propuesto)"
                                                    returnvariable="LB_Equilibrio_Interno_Propuesto"/>
                                                    <cf_web_portlet_start border="true" titulo="#LB_Equilibrio_Interno_Propuesto#" skin="#Session.Preferences.Skin#">	
                                                        <iframe   scrolling="no" height="260" id="DispersionGraF" name="DispersionGraF" src=""><!--- src="DispersionGraF.cfm" --->
                                                        </iframe>
                                                    <cf_web_portlet_end>
                                                </td>
                                            </tr>
										</cfif>
                                    </table>
								</td>
							  </tr>
							  <tr>
								<td>&nbsp;</td>
							  </tr>
							</table>
						<cfelse>
							<cfinclude template="/rh/portlets/pNavegacion.cfm"><br>
							<cfinclude template="registro_valoracion_filtro.cfm"><br>
							<cfinclude template="registro_valoracion_lista.cfm">
						</cfif>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>
<cfif sel eq  3>
	<script language="javascript" type="text/javascript">
        graficar();
        function graficar() {
            var LST_PUNTOS		= document.form1.LST_PUNTOS.value;
            var LST_SALARIO		= document.form1.LST_SALARIO.value;
            var LST_AJUSTE1		= document.form1.LST_AJUSTE1.value;
            var LST_AJUSTE2		= document.form1.LST_AJUSTE2.value;
            var LST_AJUSTE3		= document.form1.LST_AJUSTE3.value;
			var RHVPid			= document.form1.RHVPid.value;

            
            params = "?LST_PUNTOS="+LST_PUNTOS+"&LST_SALARIO="+LST_SALARIO+"&LST_AJUSTE1="+LST_AJUSTE1+"&LST_AJUSTE2="+LST_AJUSTE2+"&LST_AJUSTE3="+LST_AJUSTE3+"&RHVPid="+RHVPid;
            var frame = document.getElementById("DispersionGraF");
			frame.src = "DispersionGraF.cfm"+params;
        }
		
		function graficar1(obj,pos,ajuste) {
            var LST_PUNTOS		= document.form1.LST_PUNTOS.value;
            var LST_SALARIO		= document.form1.LST_SALARIO.value;
            var LST_AJUSTE1		= document.form1.LST_AJUSTE1.value;
            var LST_AJUSTE2P	= document.form1.LST_AJUSTE2.value;
            var LST_AJUSTE3P	= document.form1.LST_AJUSTE3.value;
			var RHVPid			= document.form1.RHVPid.value;
            var LST_AJUSTE2		= "";
            var LST_AJUSTE3		= "";
			var part_num=0;
			var posicion=pos -1;
			var valor =obj.value;
			if(ajuste == 2) {
				var col_array=LST_AJUSTE2P.split("|");
				for (var i=0;i<col_array.length;i++)
				{
					if (i == posicion){
						LST_AJUSTE2 = LST_AJUSTE2 + valor + '|';
					}
					else{
						LST_AJUSTE2 = LST_AJUSTE2 + col_array[i] + '|';
					}
				}
			LST_AJUSTE3 = LST_AJUSTE3P;
			document.form1.LST_AJUSTE2.value = LST_AJUSTE2;
			}
			else{
				var col_array=LST_AJUSTE3P.split("|");

				for (var x=0;x<col_array.length;x++)
				{
					if (x == posicion){
						LST_AJUSTE3 = LST_AJUSTE3 + obj.value + '|';
					}
					else{
						LST_AJUSTE3 = LST_AJUSTE3 + col_array[x] + '|';
					}	
				}	
			LST_AJUSTE2 = LST_AJUSTE2P;		
			document.form1.LST_AJUSTE3.value = LST_AJUSTE3;
	
			}
            var frame = document.getElementById("DispersionGraF");
            params = "?LST_PUNTOS="+LST_PUNTOS+"&LST_SALARIO="+LST_SALARIO+"&LST_AJUSTE1="+LST_AJUSTE1+"&LST_AJUSTE2="+LST_AJUSTE2+"&LST_AJUSTE3="+LST_AJUSTE3+"&RHVPid="+RHVPid;
            frame.src = "DispersionGraF.cfm"+params;
        }
    </script>
</cfif>
