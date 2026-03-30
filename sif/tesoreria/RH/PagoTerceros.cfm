<CF_NAVEGACION NAME="periodo" default="0">
<CF_NAVEGACION NAME="mes"     default="0">

<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char"   args="a.RCNid" returnvariable="RCNid">
<cfset RCNid   = "',' #_Cat# #RCNid#    #_Cat# ','">
<cfset RCNids  = "',' #_Cat# tes.RCNids #_Cat# ','">

<!---►►Periodo Auxiliares◄◄--->
<cfinvoke component="sif.Componentes.Parametros" method="Get" returnvariable="Param50">
	<cfinvokeargument name="Pcodigo" value="50">
</cfinvoke>
<cfif form.periodo EQ 0>
	<cfset form.periodo = Param50>
</cfif>
<!---►►Mes Auxiliares◄◄--->
<cfinvoke component="sif.Componentes.Parametros" method="Get" returnvariable="Param60">
	<cfinvokeargument name="Pcodigo" value="60">
</cfinvoke>
<cfif form.periodo EQ 0>
	<cfset form.mes = Param60>
</cfif>

<cfquery datasource="#session.dsn#" name="rsSocios">
<!---Todas las cargas Sociales patrono y obrero.--->
    select  Distinct 1 Tipo,Coalesce(c.SNid,b.SNid) SNid, Coalesce(c.SNnombre,b.SNnombre) SocioNegocio, d.DCdescripcion, tes.TESSPid , a.RCNid, tes.TESSPestado, 
			tes.TESSPnumero , Coalesce(tes.TESSPfechaPagar, <cf_dbfunction name="now">) FechaSP
         from RCuentasTipo a
         	inner join HERNomina no
            	on no.RCNid = a.RCNid		 	
            inner join SNegocios b
                on b.SNid = a.SNid
            inner join SNegocios c
  				on c.SNid = coalesce(b.SNidPadre, b.SNid)
            inner join DCargas d
                on d.DClinea = a.referencia
			LEFT OUTER JOIN TESsolicitudPago tes 
				ON <cf_dbfunction name="sFind" args=" #PreserveSingleQuotes(RCNids)#  ? #PreserveSingleQuotes(RCNid)# ?"  delimiters="?"> > 0
			   AND tes.SNid = Coalesce(c.SNid,b.SNid)
        where a.tiporeg in (30,31,40,41,50,51,52,55,56,57)
          and DCprovision = 0
          and a.Periodo = #form.periodo#
          and a.Mes     = #form.mes#
          and a.tipo='C' 
          and no.HERNestado in (4,6) 
          and a.Ecodigo = #session.Ecodigo#
          
          UNION ALL
	<!---Deducciones Empleado--->          
    select  Distinct 2 Tipo,Coalesce(c.SNid,b.SNid) SNid, Coalesce(c.SNnombre,b.SNnombre) SocioNegocio, e.TDdescripcion DCdescripcion, tes.TESSPid, a.RCNid, tes.TESSPestado,
			tes.TESSPnumero , Coalesce(tes.TESSPfechaPagar, <cf_dbfunction name="now">) FechaSP
         from RCuentasTipo a
         	inner join HERNomina no
            	on no.RCNid = a.RCNid		 	
            inner join SNegocios b
                on b.SNid = a.SNid
            inner join SNegocios c
				on c.SNid = coalesce(b.SNidPadre, b.SNid)
            inner join DeduccionesEmpleado d
                 on d.Did    = a.referencia
                and d.DEid   = a.DEid
            inner join TDeduccion e
                on e.TDid = d.TDid
			LEFT OUTER JOIN TESsolicitudPago tes
				ON <cf_dbfunction name="sFind" args=" #PreserveSingleQuotes(RCNids)#  ? #PreserveSingleQuotes(RCNid)# ?"  delimiters="?"> > 0
				 AND tes.SNid = Coalesce(c.SNid,b.SNid)
        where a.tiporeg in (60,61)
          and a.Periodo = #form.periodo#
          and a.Mes     = #form.mes#
          and a.tipo    = 'C' 
          and no.HERNestado in (4,6)
          and a.Ecodigo = #session.Ecodigo#
                    
          UNION ALL
	<!---Renta--->         
    select  Distinct 3 Tipo,Coalesce(c.SNid,b.SNid) SNid, Coalesce(c.SNnombre,b.SNnombre) SocioNegocio, 'Pago de Renta' DCdescripcion, tes.TESSPid, a.RCNid, tes.TESSPestado,
			tes.TESSPnumero , Coalesce(tes.TESSPfechaPagar, <cf_dbfunction name="now">) FechaSP
         from RCuentasTipo a
         	inner join HERNomina no
            	on no.RCNid = a.RCNid		 	
            inner join SNegocios b
                on b.SNid = a.SNid
            inner join SNegocios c
            	on c.SNid = coalesce(b.SNidPadre, b.SNid)
			LEFT OUTER JOIN TESsolicitudPago tes 
				ON <cf_dbfunction name="sFind" args=" #PreserveSingleQuotes(RCNids)#  ? #PreserveSingleQuotes(RCNid)# ?"  delimiters="?"> > 0
				 AND tes.SNid = Coalesce(c.SNid,b.SNid)
        where a.tiporeg in (70)
          and a.Periodo = #form.periodo#
          and a.Mes     = #form.mes#
          and a.tipo    = 'C' 
          and no.HERNestado in (4,6)
          and a.Ecodigo = #session.Ecodigo#
                  
        order by SocioNegocio, tes.TESSPid, DCdescripcion, a.RCNid
</cfquery>



<!---Se obtienen el nombre de los meses--->
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a
    	inner join VSidioma b 
        	on b.Iid = a.Iid
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cf_templateheader title="Pago de Retenciones de Nómina">
	<cf_web_portlet_start border="true" titulo="Pago de Retenciones de Nómina" skin="#Session.Preferences.Skin#">
    	<form action="PagoTerceros.cfm" name="formDeduccion" method="post">
        	<cfoutput>
		        <table align="center">
                    <tr>
                        <td>
							<!---Pinta un combo con el periodo Actual y 5 años anteriores--->
                            <select name="periodo" id="periodo" onchange="document.formDeduccion.submit()">
                                 <cfloop index="i" from="-5" to="0">
                                    <cfset vn_anno = year(DateAdd("yyyy", i, now()))>
                                    <option value="#vn_anno#"  <cfif vn_anno EQ form.periodo>  selected </cfif>>#vn_anno#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td>
							<!---Pinta un combo con los meses del Año--->
                            <select name="mes" id="mes" onchange="document.formDeduccion.submit()">
                                <cfloop query="rsMeses">
                                    <option value="#rsMeses.Pvalor#" <cfif rsMeses.Pvalor EQ form.mes>  selected </cfif> >#rsMeses.Pdescripcion#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                </table>
        </cfoutput>
        <!---Pinta cada uno de los Socio de Negocios--->
		<cfoutput query="rsSocios" group="SocioNegocio"> 
				<table cellpadding="0" cellspacing="0" class="grid-Contenedor " border="0">
					<tr>
		        		<td colspan="2" width="50%">   
							<div class="titlerestBusq">
			        			<span class="titlegray">
			        				#rsSocios.SocioNegocio#	
			        			</span>	
			        		</div>		        			
		        		</td>
                     	<td>
							<table>
								
							<cfoutput group="TESSPid">
							  <tr> 
							  	<td nowrap="nowrap" width="10%">
							  		<cfif LEN(TRIM(rsSocios.TESSPnumero))>SP: #rsSocios.TESSPnumero#</cfif>
								</td> 
								<td nowrap="nowrap" width="10%">
									<cfif NOT LEN(TRIM(rsSocios.TESSPestado)) OR (rsSocios.TESSPestado EQ 0) or (rsSocios.TESSPestado EQ 3)>
										Fecha Pago:<cf_sifcalendario  form="formDeduccion" value="#LSDateFormat(rsSocios.FechaSP,'dd/mm/yyyy')#" name="Fecha_#rsSocios.SNid#"> 
									<cfelse>
										Fecha Pago:<cf_sifcalendario Readonly form="formDeduccion" value="#LSDateFormat(rsSocios.FechaSP,'dd/mm/yyyy')#" name="Fecha_#rsSocios.SNid#"> 								
									</cfif>
									
								</td>
								<cfif LEN(TRIM(rsSocios.TESSPid))>
									<cfif (rsSocios.TESSPestado EQ 0) or (rsSocios.TESSPestado EQ 3)>
										<td align="center" width="10%">
											<input type="button" class="btnPublicar" onclick= "javascript:FnGenerar('R','#rsSocios.SNid#','Fecha_#rsSocios.SNid#')" value="ReGenerar" />
										</td>
									<cfelse>
										<td align="center" width="10%">&nbsp;
											
										</td>
									</cfif>
										<td width="10%">
											<input type="button" class="btnImprimir" onclick="javascript:window.open('/cfmx/sif/tesoreria/Solicitudes/imprSolicitPago.cfm?TESSPid=#rsSocios.TESSPid#','popup')" value="Ver Solicitud" />
										</td>
									<cfif NOT rsSocios.TESSPestado EQ 0 and not rsSocios.TESSPestado EQ 3>
										<td width="10%">&nbsp;</td>
									</cfif>
								<cfelse>
									<td align="center" width="10%">
										<input type="button" class="btnPublicar" onclick= "javascript:FnGenerar('G','#rsSocios.SNid#','Fecha_#rsSocios.SNid#','#rsSocios.RCNid#')" value="Generar" />
									</td>
									<td width="10%">&nbsp;</td>
								</cfif>
							</tr>
						  </cfoutput> 
					  </table> 
					  </td>
                    </tr>        
		        	
					<cfoutput group="DCdescripcion">
						<tr>
							<td colspan="5">
								#rsSocios.DCdescripcion#
							</td>
						</tr>
					</cfoutput>
				</table>		
		</cfoutput>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
		
<style type="text/css">
	.grid-Contenedor
	{
		border:solid 1px #1b75bb;
		padding:5px;
		background:none;
		margin-bottom:11px;
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
</style>

<script type="text/javascript" language="javascript">
	function FnGenerar(Accion, SNid, fecha,RCNid){
		if (Accion == 'G')
			accion = 'generar';
		else if (Accion == 'R')
			accion = 'regenerar';
		else if (Accion == 'A')
			accion = 'Aplicar';
			msgError ='';
		if(document.getElementById('Fecha_<cfoutput>#rsSocios.SNid#</cfoutput>').value = '')
			msgError = 'La fecha es requerida';
		if (msgError != "")
			alert('Se presentaron los siguientes problemas:\n'+msgError);
		else
				if(confirm('Esta seguro que desea '+accion+' la solicitud de pago?'))
					{
						location.href='PagoTerceros-sql.cfm?Action='+Accion+'&SNid='+SNid+'&Periodo='+document.getElementById('periodo').value+'&Mes='+document.getElementById('mes').value+'&RCNid='+RCNid;
					}
	}
</script>