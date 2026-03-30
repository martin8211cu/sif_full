<cfif Session.Params.ModoDespliegue EQ 1>
	<cfif isdefined("Form.o") and isdefined("Form.sel")>
		<cfset action = "/cfmx/rh/expediente/catalogos/expediente-cons.cfm">
	<cfelse>
		<cfset action = "/cfmx/rh/nomina/operacion/AccionesRecargos.cfm">
	</cfif>
<cfelseif Session.Params.ModoDespliegue EQ 0>
	<!--- SI ESTOY EN AUTOGESTION VERIFICA SI ES JEFE Y ENVIA LOS DATOS PARA LA OPCION DE TRAMITES PARA SIN --->
	<cfif isdefined("form.Jefe")>
		<cfset action = "/cfmx/rh/autogestion/autogestion.cfm?o=3&Jefe=#form.Jefe#&CentroF=#form.CentroF#">		
	<cfelse>
		<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
	</cfif>
</cfif>



<cfinvoke key="BTN_Aceptar" default="Continuar" returnvariable="BTN_Aceptar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Regresar" default="Cancelar" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>


<cfquery name="rsdatos" datasource="#Session.DSN#">
select RHTcodigo ,RHTdesc,RHTcomportam,RHTpfijo from RHTipoAccion
    where
    RHTid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">
    and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfquery name="rsTipoIdent" datasource="#Session.DSN#">
				select 
				a.DEid,			
				b.NTIdescripcion,
				a.DEidentificacion, 
				<!--- a.DESeguroSocial, --->
				{fn concat({fn concat({fn concat({fn concat(a.DEnombre , ' ' )}, a.DEapellido1 )}, ' ' )}, a.DEapellido2 )}  as NombreEmp
		from DatosEmpleado a 
		  inner join NTipoIdentificacion b
		    on  a.NTIcodigo = b.NTIcodigo				
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		<cfif Session.cache_empresarial EQ 0>
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfif>
</cfquery>

<cfoutput>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_RecursosHumanos"
	default="Recursos Humanos"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
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
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			default="Acciones de Recargo de Personal"
			vsgrupo="103"
			returnvariable="nombre_proceso"/>                                    
			<cf_web_portlet_start titulo="#nombre_proceso#">		  	      
				<cfinclude template="/rh/portlets/pNavegacion.cfm">			      
				<cfoutput>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top"><td>&nbsp;</td></tr>
					<tr valign="top"> 
						<td align="center">
                            <form name="form1" method="post" action="AccionesRecargos-sql.cfm">
                                <cfif isdefined('form.DEid')><input type="hidden" name="DEid" value="#Form.DEid#"></cfif>
                                <cfif isdefined('form.DEidentificacion')><input type="hidden" name="DEidentificacion" value="#Form.DEidentificacion#"></cfif>
                                <cfif isdefined('form.DLffin')><input type="hidden" name="DLffin" value="#Form.DLffin#"></cfif>
                                <cfif isdefined('form.DLfvigencia')><input type="hidden" name="DLfvigencia" value="#Form.DLfvigencia#"></cfif>
                                <cfif isdefined('form.DLobs')><input type="hidden" name="DLobs" value="#Form.DLobs#"></cfif>
								<cfif isdefined('form.EcodigoRef')><input type="hidden" name="EcodigoRef" value="#Form.EcodigoRef#"></cfif>
                               	<cfif isdefined('form.NombreEmp')> <input type="hidden" name="NombreEmp" value="#Form.NombreEmp#"></cfif>
                                <cfif isdefined('form.NTIcodigo')><input type="hidden" name="NTIcodigo" value="#Form.NTIcodigo#"></cfif>
                                <cfif isdefined('form.RHTcodigo')><input type="hidden" name="RHTcodigo" value="#Form.RHTcodigo#"></cfif>
                                <cfif isdefined('form.RHTid')><input type="hidden" name="RHTid"     value="#Form.RHTid#"></cfif>
                                <cfif isdefined('form.RHTpmax')><input type="hidden" name="RHTpmax" value="#Form.RHTpmax#"></cfif>
								
								<cfif isdefined('form.o')><input type="hidden" name="o" value="#Form.o#"></cfif>
								<cfif isdefined('form.sel')><input type="hidden" name="sel" value="#Form.sel#"></cfif>
								
								
                                <input type="hidden" name="previo" value="">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                	<tr>
                                    	<td  width="100%">
                                        	<fieldset><legend><cf_translate key="LB_Nueva_Accion">Nueva Acci&oacute;n</cf_translate></legend>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
                                                    <tr>
                                                        <td  width="8%" align="left" class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
														  <td  colspan="5" >#rsTipoIdent.NTIdescripcion#&nbsp;#rsTipoIdent.DEidentificacion#&nbsp;#rsTipoIdent.NombreEmp#</td>
                                                  </tr>
                                                    <tr>
                                                        <td align="left" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_Accion">Tipo de Acci&oacute;n</cf_translate>:</td>

                                                      <td width="30%" nowrap="nowrap">#rsdatos.RHTcodigo#-#rsdatos.RHTdesc#</td>
    
                                                      <td  width="6%"align="left" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate>:</td>
                                                        <td  width="10%"> #Form.DLfvigencia#</td>
                                                  <cfif (rsdatos.RHTcomportam eq 3 or rsdatos.RHTcomportam eq 4 or rsdatos.RHTcomportam eq 5)>
                                                    <td width="6%"  align="left" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Vence">Fecha Vence:</cf_translate></td>
                                                          <td width="50%"> #Form.DLffin#</td>
                                                    </cfif>
													</tr>					
                                                    <cfif rsdatos.RHTcomportam eq 9>
                                                        <tr>    
                                                            <td  align="left" nowrap class="fileLabel"><cf_translate key="LB_Nueva_Empresa">Nueva Empresa:</cf_translate></td>
                                                             <cfquery name="rsempresa" datasource="#Session.DSN#">
                                                                select Edescripcion  from Empresas 
                                                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoRef#">
                                                              </cfquery>
                                                            <td colspan="5"> #rsempresa.Edescripcion#</td>
                                                        </tr>
                                                    </cfif>
                                                    <tr>    
                                                        <td  align="left" nowrap class="fileLabel"><cf_translate key="LB_Observaciones">Observaciones:</cf_translate></td>
                                                      <td colspan="5"> #Form.DLobs#</td>
                                                  </tr>
                                                    <tr>
                                                        <td colspan="6" align="center">&nbsp;</td>
                                                     </tr>
                                                    <tr>
                                                        <td colspan="6" align="center">
                                                            <table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
                                                                <tr>
                                                                    <td align="right" nowrap>
                                                                        <input type="submit" name="btnAceptar" value="#BTN_Aceptar#" tabindex="1" >
                                                                        <input type="button"   onclick="javascript:regresar()" name="btnregresar" value="#BTN_Regresar#" tabindex="1" >
                                                                        <input type="button"  id="Imprimir" name="Imprimir" value="Imprimir" onclick="imprimir();">
                                                                    </td>
                                                                </tr>
                                                            </table>                                                        
                                                        
                                                        
                                                        </td>
                                                     </tr>
                                                </table>                                            
                                            </fieldset>
                                        </td>
                                     </tr>
                                     <tr>
                                        <td  width="100%" valign="top">
                                           <fieldset><legend style="color:##FF0000"><cf_translate key="LB_ayuda">Las siguientes informaci&oacute;n en la l&iacute;nea del tiempo del colaborador ser&aacute; modificada por acci&oacute;n que va generar</cf_translate></legend>
                                           		<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
                                                	<tr bgcolor="##CCCCCC">
                                                        <td  width="10%"align="center" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Rige">Rige</cf_translate></td>
                                                        <td  width="10%"align="center" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Vence">Vence</cf_translate></td>
                                                		<td   colspan="2 "width="10%"align="left" nowrap class="fileLabel"><cf_translate key="LB_Tipo">Tipo</cf_translate></td>
                                                        <td  width="10%"align="left" nowrap class="fileLabel"><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
                                                        <td  width="10%"align="left" nowrap class="fileLabel"><cf_translate key="LB_Puesto">Puesto</cf_translate></td>
                                                        <td  width="10%"align="right" nowrap class="fileLabel"><cf_translate key="LB_Salario">Salario</cf_translate></td>
                                                        <td  width="2%"align="left" nowrap class="fileLabel">&nbsp;</td>
                                                     </tr> 
                                                     <cfloop query="RSaccion">
														<cfset LvarListaNon = (RSaccion.CurrentRow MOD 2)>
														<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>

                                                        <tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">                                                      
                                                            <td  width="10%"align="center" nowrap>#LSDateFormat(RSaccion.LTdesde, "dd/mm/yyyy")#</td>
                                                            <td  width="10%"align="center" nowrap>
                                                            <cfif LSDateFormat(RSaccion.LThasta, "dd/mm/yyyy") eq "01/01/6100">
                                                            	<cf_translate key="LB_Indefinido">Indefinido</cf_translate>
                                                            <cfelse>
                                                            	#LSDateFormat(RSaccion.LThasta, "dd/mm/yyyy")#
															</cfif>
                                                            </td>                                                         
															<td  width="1%"align="left" nowrap>
                                                            	<cfswitch expression="#RSaccion.RHTcomportam#">
                                                                        <cfcase value="2">
                                                                            <cf_translate  key="LB_Cese">Cese</cf_translate>
                                                                        </cfcase>
                                                                        <cfcase value="3">
                                                                            <cf_translate  key="LB_Vacaciones">Vacaciones</cf_translate>
                                                                        </cfcase>
                                                                        <cfcase value="4">
                                                                            <cf_translate  key="LB_Permiso">Permiso</cf_translate>
                                                                        </cfcase>
                                                                        <cfcase value="5">
                                                                            <cf_translate  key="LB_Incapacidad">Incapacidad</cf_translate>
                                                                        </cfcase>
                                                                        <cfcase value="6">
                                                                            <cf_translate  key="LB_x">Cambio</cf_translate>
                                                                        </cfcase>
                                                                        <cfcase value="7">
                                                                            <cf_translate  key="LB_Anulacion">Anulaci&oacute;n</cf_translate>
                                                                        </cfcase>
                                                                        <cfcase value="9">
                                                                            <cf_translate  key="LB_Cambio_de_Empresa">Cambio de Empresa</cf_translate>
                                                                        </cfcase>
                                                                    </cfswitch>
                                                            </td>
                                                            <td  width="10%"align="left" nowrap>#trim(RSaccion.RHTdesc)#</td>

                                                            <td   nowrap="nowrap" width="10%"align="left">#trim(RSaccion.CFcodigo)#-#trim(RSaccion.CFdescripcion)#</td>
                                                            <td   nowrap="nowrap" width="10%"align="left">#trim(RSaccion.RHPcodigo)#-#trim(RSaccion.RHPdescpuesto)#</td>
                                                            <td  width="10%"align="right">#LSNumberFormat(RSaccion.LTsalario,'9,.00')#</td>
                                                            <td  width="2%"align="center">
                                                            <img  onclick="javascript:VerAcciones(#form.DEid#,#RSaccion.DLlinea#)" style="cursor:pointer" src="/cfmx/rh/imagenes/findsmall.gif" border="0" align="top" hspace="2">
                                                            </td>
                                                         </tr> 
                                                     </cfloop>
                                                </table>
                                           </fieldset>
                                        </td>
                                    </tr>
                                </table>
                                
                            </form>
						</td>
					</tr>
					<tr valign="top"> <td>&nbsp;</td></tr>
				</table>
                </cfoutput>			      
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>	
<cf_templatefooter>



</cfoutput>
<script language="JavaScript">
	function regresar(){
		document.form1.action='<cfoutput>#action#</cfoutput>';
		document.form1.submit();
	
	}
	function VerAcciones(valor,valor2) {
		var PARAM  = "ver_Accion.cfm?RAP=true&DEid="+ valor + "&DLlinea=" + valor2
		open(PARAM,'Vacaciones','left=150,top=150,scrollbars=yes,resizable=yes,width=950,height=450')
	}
	
	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print()	
        tablabotones.style.display = ''
	}
	
</script>