<style>
    /* Center the loader */
    #loader {
      position: absolute;
      left: 46%;
      top: 40%;
      z-index: 1;
      width: 50px;
      height: 50px;
      margin: -24px 0 0 -24px;
      border: 12px solid #f3f3f3;
      border-radius: 70%;
      border-top: 12px solid #3498db;
      width: 150px;
      height: 150px;
      -webkit-animation: spin 2s linear infinite;
      animation: spin 2s linear infinite;
    }
    
    @-webkit-keyframes spin {
      0% { -webkit-transform: rotate(0deg); }
      100% { -webkit-transform: rotate(360deg); }
    }
    
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    
    /* Add animation to "page content" */
    .animate-bottom {
      position: relative;
      -webkit-animation-name: animatebottom;
      -webkit-animation-duration: 1s;
      animation-name: animatebottom;
      animation-duration: 1s
    }
    
    @-webkit-keyframes animatebottom {
      from { bottom:-100px; opacity:0 }
      to { bottom:0px; opacity:1 }
    }
    
    @keyframes animatebottom {
      from{ bottom:-100px; opacity:0 }
      to{ bottom:0; opacity:1 }
    }

    .disabledbutton {
        pointer-events: none;
        opacity: 0.4;
    }
    
    #myDiv {
      display: none;
      text-align: center;
    }
    </style>


<!--- 
Creado por Jose Gutierrez 
	17/04/2018
 --->
 <cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
    <cfset LB_TituloH 				= t.Translate('LB_TituloH','Generar Estados de Cuentas')>
    <cfset TIT_AvanzarCorte 		= t.Translate('TIT_AvanzarCorte','Avanzar Corte')>
    <cfset LB_TituloTabla			= t.Translate('LB_TituloTabla','Cortes con saldo vencido calculado y monto a pagar calculados')>
    <cfset LB_Id					= t.Translate('LB_Id','Id')>
    <cfset LB_Codigo				= t.Translate('LB_Codigo','C&oacute;digo')>
    <cfset LB_FechaInicio 			= t.Translate('LB_FechaInicio','Fecha Inicio')>
    <cfset LB_FechaFin				= t.Translate('LB_FechaFin','Fecha Fin')>
    <cfset LB_FechaInicioSV			= t.Translate('LB_FechaInicioSV','Fecha Inicio SV')>
    <cfset LB_FechaFinSV			= t.Translate('LB_FechaFinSV','Fecha Fin SV')>
    <cfset LB_EstadoCalculo 		= t.Translate('LB_EstadoCalculo', 'Estado de C&aacute;lculo')>
    <cfset LB_Cerrado		 		= t.Translate('LB_Cerrado', 'Cerrado')>
    <cfset BTN_Aplicar		 		= t.Translate('BTN_Aplicar', 'Aplicar')>
    <cfset BTN_Regresar		 		= t.Translate('BTN_Regresar', 'Regresar')>
    <cfset LB_UltimosCrtsCerr		= t.Translate('LB_UltimosCrtsCerr', '&Uacute;ltimos cortes cerrados.')>
    <cfset LB_ProximosCrtsCerr		= t.Translate('LB_ProximosCrtsCerr', 'Pr&oacute;ximos cortes a cerrar.')>
    <cfset LB_CortesAntSCerrar		= t.Translate('LB_CortesAntSCerrar', 'Cortes vencidos sin cerrar.')>
    <cfset LB_MsjError				= t.Translate('LB_MsjError', 'No existen cortes para el proceso de "Avanzar Corte".')>
    <cfset LB_MsjErrorCrts			= t.Translate('LB_MsjErrorCrts', 'No existen cortes anteriores sin cerrar para este proceso".')>
    <cfset LB_CrtsTM				= t.Translate('LB_CrtsTM', 'Cortes Mayoristas por vencer.')>
    
    
    <cf_templateheader title="#LB_TituloH#">
    
    <cfinclude template="/home/menu/pNavegacion.cfm">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_AvanzarCorte#'>
    
    <cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
    <cfset val = objParams.getParametroInfo('30200711')>
    <cfif val.codigo eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no existe"></cfif>
    <cfif val.valor eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no esta definido"></cfif>
    
    <cfquery name="checkRol" datasource="#session.dsn#">
        select * from UsuarioRol where 
                    Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">  
                and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#val.valor#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
    </cfquery>
    
    <cfoutput>
    <cfif checkRol.recordCount neq 0>
    
        <cfinclude template="../../../sif/Utiles/sifConcat.cfm">
    
        <form name="frmCorte" id="frmCorte" method="post" action="GeneraEstadosCuentas_sql.cfm">
            <div id="loader"></div>
            <div id="myForm" class="animate-bottom">
                <table width="100%" border="0" cellspacing="" cellpadding="" align="center" class="PlistaTable">
                <tr>
                    <td width="100%">
                        <table width="80%" align="center" cellpadding="5" cellspacing="6" border="0" class="PlistaTable">
                            <tr class="tituloListas">
                                <td colspan="8" align="center" height="50"> <strong>#LB_TituloTabla#:&nbsp;</strong> </td><br>
                            </tr>	
                            <tr class="tituloListas" height="30">
        <!--- 						<td> <strong>#LB_Id#:&nbsp;</strong> </td> --->
                                <td> <strong>&nbsp;</strong></td>
                                <td> <strong>#LB_Codigo#:&nbsp;</strong> </td>
                                <td> <strong>#LB_FechaInicio#:&nbsp;</strong></td>
                                <td> <strong>#LB_FechaFin#:&nbsp;</strong></td>
        <!---						<td> <strong>#LB_FechaInicioSV#:&nbsp;</strong></td>
                                <td> <strong>#LB_FechaFinSV#:&nbsp;</strong></td> --->
                                <td> <strong>#LB_EstadoCalculo#:&nbsp;</strong></td>
                                <td> <strong>&nbsp;</strong></td>
                            </tr>
                                <cfquery name="qCortesACerrar" datasource="#session.DSN#">
                                    select id, Codigo, FechaInicio, FechaFin, status, FechaInicioSV, FechaFinSV,cerrado
                                    from CRCCortes 
                                    where ((Tipo <> 'TM' and status = '0' and Cerrado = 0) or (Tipo ='TM' and status = 1))
                                </cfquery>
        
                                <cfquery name="cortesSinCerrar" datasource="#session.DSN#">
                                    select * from CRCCortes 
                                    where ((Tipo <> 'TM' and status = '0' and Cerrado = 0) or (Tipo ='TM' and status = 1)) 
                                    and convert(date,GETDATE()) > convert(date,FechaFin)
                                </cfquery>
        
                                <cfquery name="qCortesSVPM" datasource="#session.DSN#">
                                    select *, 'Monto a Pagar Calculado' descripcion,
                                        case tipo
                                            when 'D' then 'Vales'
                                            when 'TC' then 'Tarjeta de Credito'
                                            else 'No definido'
                                        end TipoDesc
                                    from CRCCortes 
                                    where Cerrado = 1
                                    and status = 1
                                    and Ecodigo = #session.Ecodigo#
                                </cfquery>	
        
                                <cfif qCortesSVPM.recordCount neq 0 >
                                    <cfloop query="qCortesSVPM" >
                                        <tr>   
                                            <td><cfoutput><input type="radio" name="Corte" value="#Codigo#"/></cfoutput></td>
                                            <td><cfoutput>#Codigo#&nbsp;&nbsp;</cfoutput></td>
                                            <td><cfoutput>#DateFormat(FechaInicio,"dd/mm/yyyy")#&nbsp;&nbsp;</cfoutput></td>
                                            <td><cfoutput>#DateFormat(FechaFin,"dd/mm/yyyy")#&nbsp;&nbsp;</cfoutput></td>
        <!---									<td><cfoutput>#DateFormat(FechaInicioSV,"dd/mm/yyyy")#&nbsp;&nbsp;</cfoutput></td>
                                            <td><cfoutput>#DateFormat(FechaFinSV,"dd/mm/yyyy")#&nbsp;&nbsp;</cfoutput></td> --->
                                            <td><cfoutput>#descripcion#&nbsp;</cfoutput></td>
                                            <td>
                                                <cfif trim(tipo) eq "D">
                                                    <input type="hidden" value="#Codigo#" name="CorteD">
                                                    <input type="button" onclick="ejecutaActionRecibo()" value="Generar Recibos de Pagos" name="btnExtrac">
                                                </cfif>
                                            </td>
                                        </tr> 
                                    </cfloop> 
                                </cfif>
                                <tr>
                                    <td colspan="8" align="center">
                                        <input type="button" onclick="ejecutaActionExt()" value="Generar" name="btnExtrac">
                                        <input type="hidden" name="avanzar" id="avanzar" value="1">
                                    </td>
                                </tr>
                        </table>		 
                        
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <!---
                        <table border="1">
                            <tr>
                                <td> Avanzar Corte </td>
                                <td> <input type="radio" name="avanzar" checked="" value="1"  <cfif isDefined('form.avanzar') and  #form.avanzar# eq 1> checked  </cfif> > </td>
                            </tr>
                            <tr>
                                <td> Ejecutar Corte por fecha Actual(Fecha de la PC) </td>
                                <td> <input type="radio" name="avanzar" value="2"  <cfif isDefined('form.avanzar') and  #form.avanzar# eq 2> checked  </cfif> ></td>
                            </tr>	
                            <tr>
                                <td> </td>
                                <td> <input type="submit" value="Aplicar" > </td>
                            </tr>	
                        </table>--->		
                
                    </td>
                </tr>
            </table>
            </div>
        </form>
    <cfelse>
        <cfthrow message="No cuentas con los permisos para realizar esta operacion">
    </cfif>
    <cf_web_portlet_end>			
    
    <cf_templatefooter>
    
    <script type="text/javascript">
        window.onload=validarCortesACerrar;
    
    
        function validarCortesACerrar(){
    
            if(#cortesSinCerrar.recordCount# <= 0){
                document.frmCorte.Cambio.style.visibility='hidden';
                document.frmCorte.Cambio.disabled = true;
                
            }else{
                document.frmCorte.Cambio.style.visibility='';
                document.frmCorte.Cambio.disabled = false;
                
            }
        }
    
    </script>

    <script language="javascript" type="text/javascript">
        document.getElementById("loader").style.display = "none";
        document.getElementById("myForm").style.display = "initial";

        function ejecutaActionExt(){
            <!--- loader --->
            document.getElementById("myForm").className += "disabledbutton";
            document.getElementById("loader").style.display = "initial";
            document.getElementById("myForm").style.display = "block";
            document.getElementById("avanzar").value = "1";
            document.getElementById("frmCorte").submit();
        }
        
        function ejecutaActionRecibo(){
            <!--- loader --->
            document.getElementById("myForm").className += "disabledbutton";
            document.getElementById("loader").style.display = "initial";
            document.getElementById("myForm").style.display = "block";
            document.getElementById("avanzar").value = "0";
            document.getElementById("frmCorte").submit();
        }
    </script>
    </cfoutput>
    
    
    