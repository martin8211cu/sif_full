
<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tratado_De_Libre_Comercio"
	Default="Tratado de Libre Comercio"
	returnvariable="LB_title"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Importar_Padron_Electoral"
	Default="Importar Padr&oacute;n Electoral"
	returnvariable="LB_Importar_Padron_Electoral"/>
		
	
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
		<cfoutput>#LB_title#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="../../css/rh.css" rel="stylesheet" type="text/css">
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

	  <cfinclude template="../../../../sif/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
				  <cf_web_portlet_start border="true" titulo="#LB_Importar_Padron_Electoral#" skin="#Session.Preferences.Skin#">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td colspan="3" align="center">
					<cfset regresar = "/cfmx/hosting/tratado/index.cfm">
					<cfinclude template="../../../../sif/portlets/pNavegacion.cfm">
				</td></tr>
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				<tr>
					<td align="center" width="2%">&nbsp;</td>
					<td align="center" valign="top" width="60%">
                        <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">   
                        <tr>
                            <td>                   
                                <cfinvoke component="sif.Componentes.Translate"
                                method="Translate"
                                Key="LB_PasosParaLaImportacion"
                                Default="Pasos para la Importación"
                                returnvariable="LB_PasosParaLaImportacion"/>
                                
                                <cf_web_portlet_start border="true" titulo="#LB_PasosParaLaImportacion#" skin="info1">
                                <cf_translate  key="AYUDA_SeleccionDeArchivo">
                                    <li><u>Selecci&oacute;n de archivo:</u> Seleccione el archivo que desea importar presionando el botón de <strong>Browse</strong></li><br>
                                </cf_translate>
                                
                                <cf_translate  key="AYUDA_Importacion">
                                <li><u>Importaci&oacute;n:</u> Una vez seleccionado el archivo presione el bot&oacute;n de <strong>Importar</strong></li><br>
                                </cf_translate>
                                
                                <cf_translate  key="AYUDA_ResumenDeImportacion">
                                <li><u>Resumen de Importaci&oacute;n:</u> Al importar el archivo se mostrar&aacute; informaci&oacute;n relacionada con la importaci&oacute;n.</li><br>
                                </cf_translate>
                                
                                <cf_translate  key="AYUDA_Revision">
                                <li><u>Revisi&oacute;n:</u> Una vez importado el archivo, se puede revisar y confirmar su generaci&oacute;n al dar click en <strong>Regresar</strong>.<br>
                                </cf_translate>
                                  <br>
                                <cf_web_portlet_end>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            	<cfquery name="Determina_delimitador" datasource="sifcontrol">
                                    select * 
                                    from EImportador a
                                    where EIcodigo =  'PERSONAS'
                                </cfquery>
                                <cfif Determina_delimitador.EIdelimitador eq 'C'>
									<cfset Delimitador = 'Coma'>
                                <cfelseif Determina_delimitador.EIdelimitador eq 'T'>
                                    <cfset Delimitador = 'Coma'>
                                <cfelseif Determina_delimitador.EIdelimitador eq 'L'>
                                    <cfset Delimitador = 'Linea'>
                                <cfelse>
                                    <cfset Delimitador = 'Pipe'>	
                                </cfif>

                                <cfquery name="rsFormato" datasource="#Session.DSN#">
                                    select 
                                        FTLCid,
                                        ETLCid,
                                        FTLCcedula,
                                        FTLCformato,
                                        FTLCnombreCKC,
                                        FTLCapellido1CKC,
                                        FTLCapellido2CKC,
                                        FTLCopcion1,
                                        FTLCopcion2,
                                        FTLCopcion3,
                                        FTLCopcion4,
                                        FTLCdescricion1,
                                        FTLCdescricion2,
                                        FTLCdescricion3,
                                        FTLCdescricion4
                                    from  EmpFormatoTLC	
                                    where  ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#" >	
                                </cfquery>
                                
                                                                                                
                                <cfinvoke component="sif.Componentes.Translate"
                                method="Translate"
                                Key="LB_FormatoDeArchivoDeImportacion"
                                Default="Formato de Archivo de Importación"
                                returnvariable="LB_FormatoDeArchivoDeImportacion"/>
                                <cf_web_portlet_start border="true" titulo="#LB_FormatoDeArchivoDeImportacion#" skin="info1">
                                    <cf_translate  key="AYUDA_ElArchivoDebeSerUnArchivoPlanoConElSiguienteFormato">
                                    El archivo debe ser un archivo plano con el siguiente formato: <br><br>
                                    Separador de columnas: &nbsp; (<cfoutput>#Delimitador#</cfoutput>)<br>
                                    Fin de l&iacute;nea: &nbsp; &lt;Enter&gt; &nbsp; (chr(13))<br><br>
                                    </cf_translate>
                                	<strong><cf_translate  key="LB_Columnas">Columnas</cf_translate>:</strong><br><br>		
                                	 
                                    <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">  
										<cfset contador = 1>
                                        <tr>   
                                            <td>
                                                <font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                            </td>
                                            <cfset contador = contador + 1>
                                            <td>
                                                <font   style="font-size:10px"><cf_translate  key="LB_Cedula_Juridica_de_la_empresa">C&eacute;dula jur&iacute;dica de la empresa</cf_translate> &nbsp;&nbsp;</font>
                                            </td>
                                            <td>
                                                <font   style="font-size:10px">Varchar (15)</font>
                                            </td>
                                        </tr>  
                                         <cfset contador = contador + 1>
                                        
                                        
										<cfif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 1>
                                            <tr>   
                                                <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                    <font   style="font-size:10px"><cf_translate  key="LB_Cedula">C&eacute;dula</cf_translate></font>
                                                </td>
                                            	<td>
                                       		 		<font   style="font-size:10px">Varchar (9)</font>
                                        		</td>
                                                <td>
                                                	<font   style="font-size:10px"><cf_translate key="MSG_ejemplo_cedula1">Con 9 d&iacute;gitos, ejemplo 102340567</cf_translate></font>
                                                </td>
                                            </tr>     
                                        <cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 2>
                                            <tr>   
                                               <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                    <font   style="font-size:10px"><cf_translate  key="LB_Cedula">C&eacute;dula</cf_translate></font>
                                                </td>
                                                <td>
                                                	<font   style="font-size:10px">Varchar (7)</font>
                                                </td>
                                                <td>
                                                	<font   style="font-size:10px"><cf_translate key="MSG_ejemplo_cedula2">Con 7 d&iacute;gitos, ejemplo 1234567</cf_translate></font>
                                                </td>
                                            </tr>                                                   
                                        <cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 3>
                                            <tr>   
                                                <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                    <font   style="font-size:10px"><cf_translate  key="LB_Cedula">C&eacute;dula</cf_translate></font>
                                                </td>
                                                <td>
                                                   <font   style="font-size:10px"> Varchar (11)</font>
                                                </td>
                                                <td>
                                                    <font   style="font-size:10px"><cf_translate key="MSG_ejemplo_cedula3">Con 9 d&iacute;gitos y separador, ejemplo 1-0234-0567</cf_translate></font>
                                                </td>
                                            </tr>  
                                        <cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 4>
                                            <tr>   
                                                <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                	<font   style="font-size:10px"><cf_translate  key="LB_Cedula">C&eacute;dula</cf_translate></font>
                                                </td>
                                                <td>
                                                	<font   style="font-size:10px">Varchar (9)</font>
                                                </td>
                                                <td>
                                                	<font   style="font-size:10px"><cf_translate key="MSG_ejemplo_cedula4">Con 7 d&iacute;gitos y separador, ejemplo 1-234-567</cf_translate></font>
                                                </td>
                                            </tr>                                            
                                        
                                        </cfif> 
										<cfif isdefined("rsFormato.FTLCnombreCKC") and rsFormato.FTLCnombreCKC eq 1>	
                                            <tr>
                                                <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                    <font   style="font-size:10px"><cf_translate  key="LB_Nombre">Nombre</cf_translate></font>
                                                </td>
                                                <td colspan="1">
                                                   <font   style="font-size:10px"> Varchar (100)</font>
                                                </td>
                                             </tr>
                                         </cfif>   
                                         <cfif isdefined("rsFormato.FTLCapellido1CKC") and rsFormato.FTLCapellido1CKC eq 1>	
                                            <tr>
                                                <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                    <font   style="font-size:10px"><cf_translate  key="LB_Apellido1">Primer Apellido</cf_translate></font>
                                                </td>
                                                <td colspan="1">
                                                    <font   style="font-size:10px">Varchar (80)</font>
                                                </td>
                                             </tr>
                                         </cfif> 
                                         <cfif isdefined("rsFormato.FTLCapellido1CKC") and rsFormato.FTLCapellido2CKC eq 1>	
                                            <tr>
                                                <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                    <font   style="font-size:10px"><cf_translate  key="LB_Apellido2">Segundo Apellido</cf_translate></font>
                                                </td>
                                                <td colspan="1">
                                                    <font   style="font-size:10px">Varchar (80)</font>
                                                </td>
                                             </tr>
                                         </cfif> 
                                         <cfif isdefined("rsFormato.FTLCopcion1") and rsFormato.FTLCopcion1 eq 1>	
                                            <tr>
                                                <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                   <font   style="font-size:10px"> <cfoutput>#rsFormato.FTLCdescricion1#</cfoutput></font>
                                                </td>
                                                <td colspan="1">
                                                    <font   style="font-size:10px">Varchar (50)</font>
                                                </td>
                                             </tr>
                                         </cfif> 
                                         <cfif isdefined("rsFormato.FTLCopcion2") and rsFormato.FTLCopcion2 eq 1>	
                                            <tr>
                                                <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                   <font   style="font-size:10px"><cfoutput>#rsFormato.FTLCdescricion2#</cfoutput></font>
                                                </td>
                                                <td colspan="1">
                                                   <font   style="font-size:10px"> Varchar (50)</font>
                                                </td>
                                             </tr>
                                         </cfif> 
                                         <cfif isdefined("rsFormato.FTLCopcion3") and rsFormato.FTLCopcion3 eq 1>	
                                            <tr>
                                                <td>
                                       		 		<font   style="font-size:10px">(<cfoutput>#contador#</cfoutput>)</font>
                                        		</td>
                                                <cfset contador = contador + 1>
                                                <td>
                                                   <font   style="font-size:10px"> <cfoutput>#rsFormato.FTLCdescricion3#</cfoutput></font>
                                                </td>
                                                <td colspan="1">
                                                    <font   style="font-size:10px">Varchar (50)</font>
                                                </td>
                                             </tr>
                                         </cfif> 
                                	</table>
                                   
                               <cf_web_portlet_end>
                            </td>
                        </tr>
                        </table>
					</td>
					
					<td align="center" style="padding-left: 15px " valign="top">
						<cf_sifimportar2 EIcodigo="PERSONAS" mode="in" />
					</td>
				</tr>
			</table>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>