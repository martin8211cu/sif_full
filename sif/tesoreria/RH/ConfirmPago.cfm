
<!---Bandera que impide que el exportador de Archivo de nomina haga submit para lanzar el Archivo a pantalla.--->
<cf_navegacion name="NoRecargar" default="true">

<!---Se obtiene el detalle de todas las nominas pendientes de confirmación--->
<cfquery name="rsNominas" datasource="#session.dsn#">
	select no.ERNid, no.RCNid, no.HERNestado, tn.Tdescripcion, cp.CPdescripcion ,cp.CPtipo , cp.CPdesde, cp.CPhasta , no.Bid
    	from HERNomina no
        	inner join TiposNomina tn 
            	on tn.Ecodigo  = no.Ecodigo
               and tn.Tcodigo  = no.Tcodigo
            inner join CalendarioPagos cp
            	on cp.CPid     = no.RCNid  
            inner join CuentasBancos ba
            	on ba.CBcc = no.CBcc
            left outer join EMovimientos em
            	on em.ERNid = no.ERNid
            inner join RHEjecucion re
            	on re.RCNid = no.RCNid
               and re.NAP_Compromiso is not null
    where no.Ecodigo    = #session.Ecodigo#
<!---4=Verificado, 6=Enviando a Pago--->
      and no.HERNestado in (4,6) 
    group by cp.CPtipo, no.ERNid, no.RCNid, no.HERNestado,  tn.Tdescripcion, cp.CPdescripcion ,cp.CPtipo ,cp.CPdesde, cp.CPhasta , no.Bid, em.ERNid
	order by cp.CPtipo,cp.CPdesde
</cfquery>

<cfquery name="rsExportadores" datasource="#session.dsn#">
	select a.EIid, b.Bdescripcion, a.RHEdescripcion, ei.EIcfexporta, a.RHComisionBancaria
    from RHExportaciones a
        inner join Bancos b
            on b.Bid = a.Bid
        inner join <cf_dbdatabase table="EImportador" datasource="sifcontrol"> ei
        	on ei.EIid = a.EIid
	where a.Ecodigo = #session.Ecodigo#
      and a.Inactivo <> 1 
</cfquery>

<cf_templateheader title="Confirmación Pago de Nomina">
	<cf_web_portlet_start border="true" titulo="Confirmación Pago de Nomina" skin="#Session.Preferences.Skin#">
    <cfif NOT rsExportadores.RecordCount>
        <h3 align="center">No existen Formatos de Exportacion Activos, para darle mantenimiento Digijase a la siguiente <a href="/cfmx/rh/pago/catalogos/FExportacion.cfm" style="color:#F00">opción</a> </h3><cfabort>
    </cfif> 
    <cfif NOT rsNominas.RecordCount>
        <h3 align="center">No existen Nominas pendientes de Confirmación</h3><cfabort>
    </cfif> 
    	<form name="fnNominas" id="fnNominas">
    	<table width="100%" border="0">
        
<!---►►Se recorre cada una de las Nominas◄◄--->
			<cfset LvarSinNominas = true>
        <cfloop query="rsNominas">
        	<cfset LvarPrintHeader = true> 
<!---►►Contenedor con el Encabezado de la Nomina◄◄--->   
          	<cfset PrintHeader('C')> 
<!---►►Recorre cada una de los Exportadores◄◄--->                
			<cfoutput query="rsExportadores">
<!---►►Verifica si ya se encuentra Generado, no Aplicado◄◄--->
                <cfquery name="rsEMovimientos" datasource="#session.dsn#">
                    select EMid, EMdocumento, EMfecha
                        from EMovimientos 
                    where ERNid = #rsNominas.ERNid#
                      and EIid  = #rsExportadores.EIid#
                </cfquery>

            <cfif rsExportadores.RHComisionBancaria EQ 1>
<!---►►Si tiene comision, Verifica si ya la comision se encuentra Generado, no Aplicado◄◄--->
                <cfquery name="rsEMovimientosCom" datasource="#session.dsn#">
                    select EMid, EMdocumento, EMtotal
                        from EMovimientos 
                    where ERNid = #rsNominas.ERNid#
                      and EIid  = #rsExportadores.EIid#
                      and EMreferencia = 'Comision'
                </cfquery>
            </cfif>

                
<!---►►Verifica si ya se encuentra Generado y Aplicado◄◄--->           
                <cfquery name="rsMlibros" datasource="#session.dsn#">
                    select MLid, MLfecha
                        from MLibros 
                    where ERNid = #rsNominas.ERNid#
                      and EIid  = #rsExportadores.EIid#
                </cfquery>
<!---►►Algunas Variables, Nesesarias◄◄--->           
				<cfif NOT rsEMovimientos.RecordCount>
                    <cfset rsEMovimientos.EMfecha = NOW()>
                </cfif>
                <cfset InputName     = 'inp_'&rsNominas.ERNid&'_'&rsExportadores.EIid>
                <cfset FechaName     = 'Fec_'&rsNominas.ERNid&'_'&rsExportadores.EIid>
                <cfset DocComision   = 'inpCom_'&rsNominas.ERNid&'_'&rsExportadores.EIid>
                <cfset MontoComision = 'monCom_'&rsNominas.ERNid&'_'&rsExportadores.EIid>
<!---►►Verifica si el Exportador tiene un CFM Asociado◄◄--->            
				<cfif NOT LEN(TRIM(rsExportadores.EIcfexporta))>
                		<cfset PrintHeader('I')>
                        <tr>
                            <td nowrap="nowrap">#rsExportadores.RHEdescripcion#</td> 
                            <td nowrap="nowrap"><span style="color:##F00; font-size:9px">El Importador no posee cfm Asociado</span> </td>
                        </tr>
<!---►►Si se posee un cfm Asociado, se invoca para saber cuales empleados pertenecen a cada Exportador◄◄--->
                 <cfelse>
						<cfset URL.ERNid  		  = rsNominas.ERNid>
                        <cfset URL.Bid       	  = rsNominas.Bid>  
                        <cfset URL.estado 	 	  = 'h'>
                        <cfset URL.UpdateParam210 = false>
                        <cfset URL.EIid = rsExportadores.EIid>
                        
                        <cfinclude template="#rsExportadores.EIcfexporta#">
<!---►►Se verifica que el Exportador, Tenga la logica de devolver los empleados◄◄--->
                        <cfif NOT isdefined('rsEmpleados')>
                        	<cfset PrintHeader('I')>
                        	<tr>
                                <td nowrap="nowrap">#rsExportadores.RHEdescripcion#</td> 
                                <td nowrap="nowrap"><span style="color:##F00; font-size:9px">El Exportador no tiene definido el resulset 'rsEmpleados'.</span></td>
                            </tr>
<!---►►Si paso todas las Validaciones se pinta el Exportador/Nomina◄◄--->
                        <cfelseif rsEmpleados.RecordCount and NOT rsMlibros.RecordCount>
<!---►►Encabezado del Exportador◄◄--->
                            <cfset varRowspan = 1>
                            <cfif rsExportadores.RHComisionBancaria EQ 1>
                                <cfset varRowspan = 2>
                            </cfif>
							<cfset PrintHeader('I')>
                            <tr>
                                <td rowspan="#varRowspan#" vertical-align="center" nowrap="nowrap" width="25%">#rsExportadores.RHEdescripcion#</td> 
                                <td rowspan="#varRowspan#" vertical-align="center" nowrap="nowrap" width="10%"><span style="color:##00F; font-size:9px">#rsEmpleados.RecordCount# Empleados</span></td>
                                <td nowrap="nowrap" width="10%">
                                     <cfif rsMlibros.RecordCount>
                                        #LSDateFormat(rsMlibros.MLfecha,'dd/mm/yyyy')#
                                     <cfelse>
                                        <cf_sifcalendario form="fnNominas" value="#LSDateFormat(rsEMovimientos.EMfecha,'dd/mm/yyyy')#" name="#FechaName#"> 
                                     </cfif>
                                </td>

                               <cfif rsEMovimientos.RecordCount>
                                    <td nowrap="nowrap" width="15%">
                                        <input type="text" name="#InputName#" placeholder="N° Deposito" id="#InputName#" value="#rsEMovimientos.EMdocumento#" />
                                    </td>
                                    <td rowspan="#varRowspan#" vertical-align="center" nowrap="nowrap" width="8%">
										<cfif rsExportadores.RHComisionBancaria EQ 1>
                                            <input type="button" class="btnRefresh" onclick="javascript:FnGenerar('#rsNominas.ERNid#','#InputName#','#rsExportadores.EIid#','#FechaName#','R','#DocComision#', '#MontoComision#', 'C')" value="Regenerar" />
                                    	<cfelse>
											 <input type="button" class="btnRefresh" onclick="javascript:FnGenerar('#rsNominas.ERNid#','#InputName#','#rsExportadores.EIid#','#FechaName#','R')" value="Regenerar" />
										</cfif>
									</td>
                                    <td nowrap="nowrap" width="16%" align="center">
                                        <input type="button" class="btnImprimir" onclick="javascript:window.open('/cfmx/sif/mb/Reportes/RPRegistroMovBancariosMasivo-frame.cfm?lista=#rsEMovimientos.EMid#','popup')" value="Ver Bancos" />
                                    </td>
                                    <td nowrap="nowrap" width="16%" align="center">
                                        <input type="button" class="btnImprimir" onclick="javascript:FnGenerar('#rsNominas.ERNid#','#InputName#','#rsExportadores.EIid#','#FechaName#','V')" value="Ver Asiento" />
                                    </td>
									 <td rowspan="#varRowspan#" vertical-align="center" nowrap="nowrap" width="8%">
                                    <cfif rsExportadores.RHComisionBancaria EQ 1>                                       
                                     	<input type="button" class="btnAplicar" onclick="javascript:FnGenerar('#rsNominas.ERNid#','#InputName#','#rsExportadores.EIid#','#FechaName#','A','#DocComision#', '#MontoComision#', 'C')" value="Aplicar" />
                                    <cfelse>
                                        <input type="button" class="btnAplicar" onclick="javascript:FnGenerar('#rsNominas.ERNid#','#InputName#','#rsExportadores.EIid#','#FechaName#','A')" value="Aplicar" />
                                    </cfif>
                                   </td>
                                </tr>

                                <tr>
                                    
                                <!--- En caso de que el bit de comision bancaria esta activo --->
                                    <cfif rsExportadores.RHComisionBancaria EQ 1>
                                        <td nowrap="nowrap" width="10%">
                                            <input type="text" size="10" name="#DocComision#" placeholder="N° Comisión" id="#DocComision#" value="#rsEMovimientosCom.EMdocumento#" />
                                        </td>
                                        <td nowrap="nowrap" width="15%">
                                            <input type="text" name="#MontoComision#" placeholder="Monto Comisión" id="#MontoComision#" value="#rsEMovimientosCom.EMtotal#" />
                                        </td>  
                                        <td nowrap="nowrap" width="16%" align="center">
                                            <input type="button" class="btnImprimir" onclick="javascript:window.open('/cfmx/sif/mb/Reportes/RPRegistroMovBancariosMasivo-frame.cfm?lista=#rsEMovimientosCom.EMid#','popup')" value="Ver Bancos Comisión" />
                                        </td>
                                        <td nowrap="nowrap" width="16%" align="center">
                                            <input type="button" class="btnImprimir" onclick="javascript:FnGenerar('#rsNominas.ERNid#','#DocComision#','#rsExportadores.EIid#','#FechaName#','V', '#DocComision#', '#MontoComision#', 'C')" value="Ver Asiento Comisión" />
                                        </td>
                                    </cfif>
                                </tr>
                            <cfelse>
                                <td nowrap="nowrap" width="15%">
                                    <input type="text" name="#InputName#" placeholder="N° Deposito" id="#InputName#" />
                                </td>
                                <td rowspan="#varRowspan#" nowrap="nowrap" width="8%" vertical-align="center">
                                    <input type="button" class="btnPublicar" onclick="javascript:FnGenerar('#rsNominas.ERNid#','#InputName#','#rsExportadores.EIid#','#FechaName#','G', <cfif rsExportadores.RHComisionBancaria EQ 1> '#DocComision#', '#MontoComision#', 'C' <cfelse> -1, -1, 0</cfif>)" value="Generar"/>
                                </td>
                                <td width="8%">&nbsp;</td>
                                <td width="8%">&nbsp;</td>
								<td width="8%">&nbsp;</td>
                           </tr>

                           <cfif rsExportadores.RHComisionBancaria EQ 1>
                               <tr>
                                    <td nowrap="nowrap" width="10%">
                                        <input type="text" size="10" name="#DocComision#" placeholder="N° Comisión" id="#DocComision#" />
                                    </td>
                                     <td nowrap="nowrap" width="15%">
                                        <input type="text" name="#MontoComision#" placeholder="Monto Comisión" id="#MontoComision#" />
                                    </td>
                                    <td width="8%">&nbsp;</td>
                                    <td width="8%">&nbsp;</td>
                                    <td width="8%">&nbsp;</td>
                                    <td width="8%">&nbsp;</td>
                               </tr> 
                            </cfif>
							
                        </cfif>
                            <cfset rsEmpleados = JavaCast( "null", 0 ) />
                        <cfelse>
                            <cfset rsEmpleados = JavaCast( "null", 0 ) />	
                        </cfif>
						
                        </cfif>
						
                </cfoutput>
               	<cfset PrintHeader('F')>
             </cfloop>
             <cfif LvarSinNominas>
             	<tr><td>
             	<h3 align="center">No existen Nominas pendientes de Confirmación</h3>
                </td></tr>
             </cfif>
         </table>
         </form>
	<cf_web_portlet_end>
<cf_templatefooter>

<cffunction name="PrintHeader" access="public">
	<cfargument name="Accion" type="string" default="C" hint="C=Crear, I=Inicio, F=Fin">
		<cfif Arguments.Accion EQ 'C'>
             <cfsavecontent variable="EncabezadoNomina">
                    <tr><td>
                    <table cellpadding="0" width="100%" cellspacing="0" class="grid-Contenedor " border="0">
                    <tr>
                        <td colspan="8">
                            <cfoutput>
                                <div class="titlerestBusq">
                                    <span class="titlegray">
										<cfif rsNominas.CPtipo EQ 0>
											#rsNominas.Tdescripcion#
										<cfelseif rsNominas.CPtipo EQ 1>
											#rsNominas.CPdescripcion#
										<cfelse>
											Desconocido
										</cfif>
									
									</span> 
                                    <span class="titlegray">-</span> 
                                    <span class="titlered">
                                        #LSDATEFORMAT(rsNominas.CPdesde,'DD-MM-YYYY')#
                                        <cfif LSDATEFORMAT(rsNominas.CPdesde,'DD-MM-YYYY') NEQ  LSDATEFORMAT(rsNominas.CPhasta,'DD-MM-YYYY')>
                                         al #LSDATEFORMAT(rsNominas.CPhasta,'DD-MM-YYYY')#
                                        </cfif>
                                    </span>
                                 </div>
                            </cfoutput>
                        </td>
                    </tr>
                </cfsavecontent>
        <cfelseif Arguments.Accion EQ 'I'>
        		<cfif LvarPrintHeader>
					<cfoutput>#EncabezadoNomina#</cfoutput>
                    <cfset LvarPrintHeader = False> 
                    <cfset LvarSinNominas  = False>
                </cfif>
        <cfelseif Arguments.Accion EQ 'F'>
        	 <cfif NOT LvarPrintHeader>
             	</table></td></tr>
             </cfif>
        <cfelse>
            <cfthrow message="Accion no valida ##">
        </cfif>
</cffunction>
<script type="text/javascript" language="javascript">
	function FnGenerar(ERNid,inputName,EIid,fechaName,Accion, DocComision, MontoComision, ConComision){
        msgError ='';
        if(ConComision == 'C'){
            if (document.getElementById(DocComision).value == '')
                msgError = msgError + '- El documento de Comisión es requerido\n';
            if (document.getElementById(MontoComision).value == '')
                msgError = msgError + '- El Monto de la Comisión es requerido\n';
        }
        if (Accion == 'G')
			accion = 'generar';
		else if (Accion == 'R')
			accion = 'regenerar';
		else if (Accion == 'A')
			accion = 'Aplicar';
		else if (Accion == 'V')
			accion = 'Ver el Asiento de ';
		if (document.getElementById(inputName).value == '')
			msgError = msgError + '- El documento de confirmación es requerido\n';
		if (document.getElementById(fechaName).value == '')
			msgError = msgError + '- La Fecha de confirmación es requerido';
		if (msgError != "")
			alert('Se presentaron los siguientes problemas:\n'+msgError);
		else
			if(confirm('Esta seguro que desea '+accion+' el Movimiento Bancario?'))
				{  
                    if(ConComision == 'C')
                    { 
					   location.href='ConfirmPago-sql.cfm?Action='+Accion+'&ERNid='+ERNid+'&Doc='+document.getElementById(inputName).value+'&EIid='+EIid+'&Fecha='+document.getElementById(fechaName).value+'&DocComision='+document.getElementById(DocComision).value+'&MontoComision='+document.getElementById(MontoComision).value;
                    }
                    else
                    { 
                       location.href='ConfirmPago-sql.cfm?Action='+Accion+'&ERNid='+ERNid+'&Doc='+document.getElementById(inputName).value+'&EIid='+EIid+'&Fecha='+document.getElementById(fechaName).value;
                    }

				}
			
		}
</script>

<style type="text/css">
.grid-Contenedor
{
	border:solid 1px #1b75bb;
	padding:5px;
	background:none;
	margin-bottom:2px;
	font-family: Arial, Verdana, Geneva, sans-serif;
	font-size:13px;
	color:#1A1818;
	height:95px;
	width:100%;
	cursor:pointer;
}

.grid-Contenedor:hover
{
	-moz-box-shadow: 5px 5px 2px #ccc;
	-webkit-box-shadow: 5px 5px 2px #ccc;
	box-shadow:2px 2px 4px 2px  #999999;
}
.grid-Contenedor  .titlerestBusq .titlegray
{
	display:inline;
	color:#3B3B3D;
	font-weight:bold;
	font-size:14px;
}
.grid-Contenedor .titlerestBusq .titlered
{
	display:inline;
	color:#BB2129;
	font-weight:bold;
	font-size:14px;
}
.grid-Contenedor  span.celest
{
	color:#1B75BB;
	font-size:14px;
}

.grid-Contenedor h2
{
font-size:17px;
font-family:Verdana, Geneva, sans-serif;
color:#A20D22;
margin:0px;	
}
greenButton {
	cursor:pointer;
	text-shadow: 1px 1px 0 #000;
    background: #000066;
    background-color: #000066;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#000066', endColorstr='#38B945'); /* for IE */
	background: -webkit-gradient(linear, left top, left bottom, from(#000066), to(#38B945));
    background-image: -moz-linear-gradient(center top , #000066 0%, #38B945 100%);
    color: #fff;
    border-radius: 7px;
    border: 1px solid gray;
    font: bold 12px/1 "Arial",helvetica,arial,sans-serif;
    padding: 7px 0;
    width: 100px;
}
.greenButton:hover {
	
    background: green;
    background-color: green;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#000066', endColorstr='green'); /* for IE */
	background: -webkit-gradient(linear, left top, left bottom, from(#000066), to(green));
    background-image: -moz-linear-gradient(center top , #000066 0%, green 100%);
}

.greenButton:active {
    box-shadow: 0 0 5px 2px green inset;
}
/* --------------- BOTONES --------------- */

.button, .button:visited { /* botones genéricos */
background: #222 url(http://sites.google.com/site/zavaletaster/Home/overlay.png) repeat-x;
display: inline-block;
padding: 5px 10px 6px;
color: #FFF;
text-decoration: none;
-moz-border-radius: 6px;
-webkit-border-radius: 6px;
-moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
-webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
text-shadow: 0 -1px 1px rgba(0,0,0,0.25);
border-top: 0px;
border-left: 0px;
border-right: 0px;
border-bottom: 1px solid rgba(0,0,0,0.25);
position: relative;
cursor:pointer;
}

button::-moz-focus-inner,
input[type="reset"]::-moz-focus-inner,
input[type="button"]::-moz-focus-inner,
input[type="submit"]::-moz-focus-inner,
input[type="file"] > input[type="button"]::-moz-focus-inner {
border: none;
}

.button:hover { /* el efecto hover */
background-color: #111
color: #FFF;
}

.button:active{ /* el efecto click */
top: 1px;
}
</style>