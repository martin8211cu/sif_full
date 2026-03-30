<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Detalles del Anticipo">
<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Detalles del Anticipo">

<cfset LvarSAporEmpleadoCFM = "#url.LvarSAporEmpleadoCFM#">
<cfset GEAid="#url.GEAid#">
<cfset calcular="#url.calcular#">
<cfset CFid="#url.CFid#">
<cfset GECVcodigo="">
<cfset GECVdescripcion="">
<cfset GEAfechaPagar="#url.GEAfechaPagar#">

<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->

<cfquery name="rsPlantillas" datasource="#session.dsn#">
			  select 
				gep.GEPVid,
				gep.GEPVdescripcion,
				gep.Mcodigo,
				mon.Mnombre,
				gep.GEPVmonto,
								
				gec.GECVid,
				gec.GECVcodigo,
				gec.GECVdescripcion,
				
				ged.GEADfechaini,
				ged.GEADfechafin,
				ged.GEADhoraini,
				ged.GEADhorafin,
				ged.GEADmontoviatico,
				ged.GEADtipocambio,
				ged.GEADmonto,
				ged.GEADtipocambio
				
				from GEanticipoDet ged
				
				inner join GEPlantillaViaticos gep
				on gep.GEPVid= ged.GEPVid
				
				inner join GEClasificacionViaticos gec
				on gep.GECVid=gec.GECVid
				
				inner join Monedas mon
					on mon.Mcodigo = gep.Mcodigo
					and mon.Ecodigo = gep.Ecodigo
					
				left outer join Htipocambio htc
					on htc.Mcodigo = mon.Mcodigo
					and <cf_dbfunction name="now"> between htc.Hfecha and htc.Hfechah 
				
				where ged.GEAid=#GEAid#
				and gep.Ecodigo=#session.ecodigo#
				order by ged.GEADfechaini,ged.GEADhoraini,gep.GEPVid
			 </cfquery>
			
				
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select ge.GEAdesde, ge.GEAhasta, ge.GEAhoraini, ge.GEAhorafin, ge.GEAtipoviatico, ge.Mcodigo,Mnombre
			from GEanticipo ge
			
			inner join Monedas mon
					on mon.Mcodigo = ge.Mcodigo
					and mon.Ecodigo = ge.Ecodigo
					
			left outer join Htipocambio htc
					on htc.Mcodigo = mon.Mcodigo
					and <cf_dbfunction name="now"> between htc.Hfecha and htc.Hfechah  		
					
			where GEAid=#GEAid#
	</cfquery>
<cfoutput>
	 <table width="100%" border="0" align="center">
		 <tr>
		 	<td><div align="left" style="font-size:16px"><strong>DATOS DEL ANTICIPO</strong></div></td>
		</tr>
		<tr>
			<td><div align="left"><strong>Moneda: #rsDatos.Mnombre#</strong></div> </td>
			<td><div align="left"><strong>Fecha Inicio:  #LSDateFormat(rsDatos.GEAdesde,'DD/MM/YYYY') #</strong></div></td>
			<td><div align="left"><strong>Fecha Final: #LSDateFormat(rsDatos.GEAhasta,'DD/MM/YYYY')  #</strong></div></td>
			<td><div align="left"><strong>Tipo: <cfif #rsDatos.GEAtipoviatico# eq 1> Interior <cfelseif  #rsDatos.GEAtipoviatico# eq 2> Exterior </cfif></strong></div></td>
		 </tr>
	 </table>
</cfoutput>


	<cfset modo= "ALTA">
			<form action="SolAntViatico_sql.cfm" method="post" name="formEncabezado" onsubmit="return validar();">
				<table width="770" border="0" align="center" bordercolor="#999999">
				 <tr bgcolor="#999999">
				<td width="260"><div align="center"><strong>Clasificaci&oacute;n</strong></div></td>
				<td width="90"><div align="center"><strong>Fecha Inicio</strong></div></td>
				<td width="60"><div align="center"><strong>Hora Inicio</strong></div></td>
				<td width="80"><div align="center"><strong>Fecha Final</strong></div></td>
				<td width="60"><div align="center"><strong>Hora Final</strong></div></td>
				  </tr>
				</table>
				<table width="800" border="0" align="center">
					  <tr>
						<td width="125"><div align="center">
						<cfoutput>
						<input type="hidden" name="GEPVid" value="#rsPlantillas.GEPVid#"/>	
						<input type="hidden" name="GEAid" value="#GEAid#"/>	
						<input type="hidden" name="CFid" value="#CFid#"/>	
						<input type="hidden" name="GEAfechaPagar" value="#GEAfechaPagar#"/>		
						<input type="hidden" name="GECVdescripcion" value=""/>
						<input type="hidden" name="LvarSAporEmpleadoCFM" value="#LvarSAporEmpleadoCFM#">	
						<input type="hidden" name="GEAdesde" value="#LSDateFormat(rsDatos.GEAdesde,'DD/MM/YYYY')#"/>
						<input type="hidden" name="GEAhasta" value="#LSDateFormat(rsDatos.GEAhasta,'DD/MM/YYYY')  #"/>
						</cfoutput>
						<!---<cfinput type="hidden" name="GEAid" value="#GEAid#"/>--->
						<cf_sifclasificacionViaticos id="GECVid" name="GECVcodigo" desc="GECVdescripcion2" tipoV="#tipo#" form="formEncabezado">
						 
						</div></td>
						<td width="80"><div align="center">
							<cf_sifcalendario name="GEADfechaini" value="#DateFormat(rsDatos.GEAdesde,'DD/MM/YYYY')#" form="formEncabezado">
						</div></td>
						<td width="60"><div align="center">
							<cf_hora name="GEADhoraini" form="formEncabezado" value="#rsDatos.GEAhoraini#">
						</div></td>
						<td width="80"><div align="center">
						   <cf_sifcalendario name="GEADfechafin" value="#DateFormat(rsDatos.GEAhasta,'DD/MM/YYYY')#" form="formEncabezado"> 
						</div></td>
						<td width="60"><div align="center">
							<cf_hora name="GEADhorafin" form="formEncabezado" value="#rsDatos.GEAhorafin#">
						</div></td>
						</tr>
						<tr><td></td>
							<td>
							<cf_botones modo="ALTA" exclude="limpiar">
							<cfif rsUsaPlanCuentas.Pvalor neq LvarParametroPlanCom>
								<td>&nbsp;</td>
							<cfelse>								
								<td colspan="2" align="center">
									<input type="button"  name="btnPlan"  value="Plan de Compras" tabindex="1" onClick="PlanCompras()" >
								</td>
							</cfif>	
							</tr>
					</table>
					
				 <input type="hidden" name="BMUsucodigo" value="#session.usucodigo#" />
				 <input type="hidden" name="modo" value="ALTA" />
			</form>
			
			<table width="100%" border="0" align="center" bordercolor="#999999">
			 <tr bgcolor="#999999">
				<td width="129"><div align="center"><strong>Plantilla</strong></div></td>
				<td width="159"><div align="center"><strong>Clasificaci&oacute;n</strong></div></td>
				<td width="80"><div align="center"><strong>Fecha Inicio</strong></div></td>
				<td width="60"><div align="center"><strong>Hora Inicio</strong></div></td>
				<td width="80"><div align="center"><strong>Fecha Final</strong></div></td>
				<td width="60"><div align="center"><strong>Hora Final</strong></div></td>
				<td width="75"><div align="center"><strong>Moneda Plantilla</strong></div></td>
				<td width="75"><div align="center"><strong>Monto Plantilla</strong></div></td>
				<td width="75"><div align="center"><strong>Tipo de Cambio </strong></div></td>
				<td width="75"><div align="center"><strong>Monto </strong></div></td>
				<td width="10"></td>
			  </tr>
			</table>
<cfoutput>	
			<cfif rsPlantillas.recordcount gt 0>
			<cfset totalP = 0>
			<table width="100%" border="0" align="center">
				 <cfloop query="rsPlantillas">
					<form action="SolAntViatico_sql.cfm" method="post" name="form#GEPVid#" id="form#GEPVid#">
						  <tr>
							<td width="148"><div align="center"><strong>
							  #GEPVdescripcion#
							  <input type="hidden" name="GEPVid" value="#GEPVid#"/>
							   <input type="hidden" name="modo"/>	
							   <input type="hidden" name="GEAid" value="#GEAid#"/>	
							   <input type="hidden" name="CFid" value="#CFid#"/>	
							   <input type="hidden" name="GEAfechaPagar" value="#GEAfechaPagar#"/>		   
							</strong></div></td>
							<td width="148"><div align="center">
							 #GECVdescripcion#
							  <input type="hidden" name="GECVdescripcion" value="#GECVdescripcion#"/>	
							</div></td>
							<td width="80"><div align="center">
								#DateFormat(GEADfechaini,'DD/MM/YYYY')#
							</div></td>
							<td width="60"><div align="center">
								<cf_hora name="GEADhoraini#GEPVid#" form="form#GEPVid#" value="#GEADhoraini#" image="false" readOnly="true">
							</div></td>
							<td width="80"><div align="center">
							   #DateFormat(GEADfechafin,'DD/MM/YYYY')#
							</div></td>
							<td width="60"><div align="center">
								<cf_hora name="GEADhorafin#GEPVid#" form="form#GEPVid#" value="#GEADhorafin#" image="false" readOnly="true">
							</div></td>
								<td width="75"><div align="center">
								#Mnombre#  
							</div></td>
							<td width="75"><div align="center">
								#LSNumberFormat(GEADmontoviatico, ',9.00')#  
							</div></td>
							<td width="75"><div align="center">
								#LSNumberFormat(GEADtipocambio, ',9.00')#  
							</div></td>
							<td width="75"><div align="center">
								#LSNumberFormat(GEADmonto, ',9.00')#  
							</div></td>
							<td width="10">
								<img src="/cfmx/sif/imagenes/deletesmall.gif" onclick="javascript:iniciar('form#GEPVid#','BAJA');"/>
							</td>
						  </tr>
						<cfset totalP +=#GEADmonto#>		
					</form>
					</cfloop>
					<tr>
						<td colspan="8">	
						</td>
						<td align="right">	
							<strong>Total:</strong>
						</td>
						<td align="right">
							<strong>#LSNumberFormat(totalP, ',9.00')#  </strong>
						</td>
					</tr>	
				</table>
				<cfset LvarSAporEmpleadoSQL = "">
				<cf_botones incluyeForm="true" irA="#LvarSAporEmpleadoCFM#?LvarSAporEmpleadoSQL=#LvarSAporEmpleadoSQL#&GEAid=#url.GEAid#"  formName="frmRegresar" modo="CAMBIO" include="Regresar" exclude="Nuevo,Baja,Cambio">	
			  </cfif>
			  
<cf_qforms form="formEncabezado">
<script language= "javascript1.2" type="text/javascript">
		objForm.GECVcodigo.description = "Clasificacion del Viatico";
		objForm.GECVcodigo.required = true;
	
	    function iniciar(form,modo)
		 {
			e = document.getElementById(form);
			e.modo.value = modo;
			e.submit();
			return true;
		}
		
		function fnFechaYYYYMMDD (LvarFecha)
		{
			return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
		}

		function validar(formulario)	{
			
		if (fnFechaYYYYMMDD(document.form1.GEADfechaini.value) > fnFechaYYYYMMDD(document.form1.GEADfechafin.value))
		{
			alert ("La Fecha de Inicio debe ser menor a la Fecha Final");
			return false;
		}
		
		if (fnFechaYYYYMMDD(document.form1.GEAdesde.value) > fnFechaYYYYMMDD(document.form1.GEADfechaini.value))
		{
			alert ("La Fecha de Inicio se sale del rango de fechas");
			return false;
		}
		
		if (fnFechaYYYYMMDD(document.form1.GEADfechafin.value) > fnFechaYYYYMMDD(document.form1.GEAhasta.value))
		{
			alert ("La Fecha Final se sale del rango de fechas");
			return false;
		}
		
		}//termina validar
		
		
	
		function PlanCompras()
		{
			var Lvartipo = 'S';
			var LvarCFid = document.formEncabezado.CFid.value;
			var LvarGEAid=document.formEncabezado.GEAid.value;
			var LvarfuncionExtra = 'updAntDetPCGDid';
			var LvarGEAfechaPagar=document.formEncabezado.GEAfechaPagar.value;
			
				
			if((Lvartipo != '') && (LvarCFid != '')&& (LvarGEAid != ''))
			{
				window.open('popUp-planDeCompras.cfm?tipo='+Lvartipo+'&GEAid='+LvarGEAid+'&CFid='+LvarCFid+'&fechaPago='+LvarGEAfechaPagar+'&funcionExtra='+LvarfuncionExtra+'&viatico=1','popup','width=1000,height=500,left=200,top=50,scrollbars=yes');
			}
			else
			{
			 alert("Falta el Tipo en el detalle o el Id del Centro Funcional ");
			}  
		}
		
		
		function funcRegresar()
		{
			<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
				var ajaxRequest1;  // The variable that makes Ajax possible!
				try{
					// Opera 8.0+, Firefox, Safari
					ajaxRequest1 = new XMLHttpRequest();
				} catch (e){
					// Internet Explorer Browsers
					try{
						ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
					} catch (e) {
						try{
							ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
						} catch (e){
							// Something went wrong
							alert("Your browser broke!");
							return false;
						}
					}
				}
				ajaxRequest1.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/verificaPCGDidCalculoViaticos.cfm?GEAid=#url.GEAid#', false);
				ajaxRequest1.send(null);
				if(parseInt(ajaxRequest1.responseText) > 0){
					alert("hay detalles que no tienen el plan de compras al que pertenece")
					return false;
				}
			</cfif>	
		}
		
</script>
</cfoutput>	
<cf_web_portlet_end>
<cf_templatefooter>