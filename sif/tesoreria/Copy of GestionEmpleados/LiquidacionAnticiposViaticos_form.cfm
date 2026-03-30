<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Detalles de la Liquidación del Viatico">
<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Detalles de la Liquidación del Viatico">
<style type="text/css">
	<!--
	.style1 {
		color: #FFFFFF;
		font-weight: bold;
	}
	-->
</style>

<cfset GECVcodigo="">
<cfset GECVdescripcion="">	
<cfparam name="url.GEAid" default="-1">
<cfset GEAid="#url.GEAid#">
<cfset GELid="#url.GELid#">
<cfquery name="rsPlantillas" datasource="#session.dsn#">
			  select 
				gep.GEPVid,	gep.GEPVdescripcion,gep.Mcodigo,gep.GEPVmonto,
				mon.Mnombre,
							
				gec.GECVid,	gec.GECVcodigo,	gec.GECVdescripcion,
				
				ged.GEADfechaini,ged.GEADfechafin,ged.GEADhoraini,ged.GEADhorafin,ged.GEADmontoviatico,ged.GEADmonto,ged.GEADtipocambio,ged.GECid
				
				from GEanticipoDet ged
				
				inner join GEPlantillaViaticos gep
				on gep.GEPVid= ged.GEPVid
				
				inner join GEClasificacionViaticos gec
				on gep.GECVid=gec.GECVid
				
				inner join Monedas mon
					on mon.Mcodigo = gep.Mcodigo
					and mon.Ecodigo = gep.Ecodigo
					
			
				where ged.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
				and gep.Ecodigo=#session.ecodigo#
				
				
				UNION
				
			select 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GEPVid, '---' as GEPVdescripcion,  ged.McodigoPlantilla,  ged.GEADmonto as GEPVmonto,
				mon.Mnombre, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GECVid, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as GECVcodigo,gecg.GECdescripcion as GECVdescripcion,
				ged.GEADfechaini, ged.GEADfechafin, ged.GEADhoraini, ged.GEADhorafin, ged.GEADmontoviatico , ged.GEADmonto, ged.GEADtipocambio, ged.GECid
				
				from GEanticipoDet ged
				
				inner join GEconceptoGasto gecg 
				on gecg.GECid= ged.GECid
				
				inner join GEanticipo ge
				on ge.GEAid=ged.GEAid
				
				inner join Monedas mon
					on mon.Mcodigo =  ged.McodigoPlantilla
					and mon.Ecodigo = ge.Ecodigo
					
			
				where ged.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
				and ge.Ecodigo=#session.ecodigo#
				and ged.GEADfechaini is  null
				order by GEPVid, GECVdescripcion
</cfquery>
		
<cfquery name="rsDatos" datasource="#session.dsn#">
	select ge.GEAdesde, ge.GEAhasta, ge.GEAhoraini, ge.GEAhorafin, ge.Mcodigo,Mnombre
		from GEanticipo ge
		
		inner join Monedas mon
				on mon.Mcodigo = ge.Mcodigo
				and mon.Ecodigo = ge.Ecodigo
				
		left outer join Htipocambio htc
				on htc.Mcodigo = mon.Mcodigo
				and <cf_dbfunction name="now"> between htc.Hfecha and htc.Hfechah  		
				
		where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
</cfquery>

<cfquery name="rsLiquidaciones" datasource="#session.dsn#">
	select 
		gep.GEPVid, gep.GEPVdescripcion, gep.Mcodigo, mon.Mnombre, gep.GEPVmonto, gec.GECVid, gec.GECVcodigo, gec.GECVdescripcion, gel.GELVfechaIni, gel.GELVfechaFin, 
		gel.GELVhoraIni, gel.GELVhorafin, gel.GELVmontoOri, gel.GEPVmontoGastMV, gel.GELVtipoCambio, gel.GELVmonto,gel.GECid, gel.GELVid

		from GEliquidacionViaticos gel 
		inner join GEPlantillaViaticos gep 
		on gep.GEPVid= gel.GEPVid 

		inner join GEClasificacionViaticos gec 
		on gep.GECVid=gec.GECVid 

		inner join Monedas mon 
		on mon.Mcodigo = gep.Mcodigo
		and mon.Ecodigo = gep.Ecodigo 

		where gel.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#">
		<cfif #GEAid# neq -1> <!---Si no es liquidacion directa---> 
			and gel.GEAid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
		</cfif>
		and gep.Ecodigo=#session.ecodigo# 
		
		UNION

	select 
		<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GEPVid, '---' as GEPVdescripcion, ged.McodigoPlantilla,mon.Mnombre, gel.GELVmontoOri as GEPVmonto,
		<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GECVid, '-' as GECVcodigo,gecg.GECdescripcion as GECVdescripcion, 
		gel.GELVfechaIni, gel.GELVfechaFin, gel.GELVhoraIni, gel.GELVhorafin, gel.GELVmontoOri, gel.GEPVmontoGastMV, gel.GELVtipoCambio, gel.GELVmonto ,gel.GECid, gel.GELVid
		
		from GEliquidacionViaticos gel 
		
		inner join GEconceptoGasto gecg 
			on gecg.GECid= gel.GECid 
		
		inner join GEanticipo ge
			on ge.GEAid=gel.GEAid
			
		inner join GEanticipoDet ged
			on ge.GEAid=ged.GEAid	
			and gel.GEADid=ged.GEADid
		
		inner join Monedas mon 
		on mon.Mcodigo = ged.McodigoPlantilla
		 and mon.Ecodigo = ge.Ecodigo 
	
		where gel.GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#">
		<cfif #GEAid# neq -1> <!---Si no es liquidacion directa---> 
			and gel.GEAid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
		</cfif>	
		and ge.Ecodigo=#session.ecodigo#  
		and gel.GELVfechaIni is  null
		order by GEPVid, GECVdescripcion
				
</cfquery>
<cfquery name="rsTipo" datasource="#session.dsn#">
		select GEAtipoviatico
			from GEliquidacion
			where GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#">
	</cfquery>
	<cfset tipo=#rsTipo.GEAtipoviatico#>
	
<cfoutput>	
<table width="100%" border="5" align="center">
	<tr>
		<table width="100%" border="0" align="center">
			 <tr bgcolor="999999">
				<td width="129"><div align="center"><strong>Plantilla</strong></div></td>
				<td width="159"><div align="center"><strong>Clasificaci&oacute;n</strong></div></td>
				<td width="80"><div align="center"><strong>Fecha Inicio</strong></div></td>
				<td width="60"><div align="center"><strong>Hora Inicio</strong></div></td>
				<td width="80"><div align="center"><strong>Fecha Final</strong></div></td>
				<td width="60"><div align="center"><strong>Hora Final</strong></div></td>
				<td width="75"><div align="center"><strong>Moneda Plantilla</strong></div></td>
				<td width="75"><div align="right"><strong>Monto Plantilla</strong></div></td>
				<td width="75"><div align="right"><strong>Tipo de Cambio </strong></div></td>
				<td width="75"><div align="right"><strong>Monto </strong></div></td>
			  </tr>
		</table>

		<cfif rsPlantillas.recordcount gt 0>
			<table width="100%" border="0" align="center">
			<cfset i = 0>
			<cfset totalP = 0>
			<cfloop query="rsPlantillas">
				<cfset i += 1>
				<form name="form#i#">
					 <tr>
						<td width="148"><div align="center"><strong>
						  #GEPVdescripcion#
						</strong></div></td>
						<td width="148"><div align="center">
						 #GECVdescripcion#
						</div></td>
						<td width="80"><div align="center">
							#DateFormat(GEADfechaini,'DD/MM/YYYY')#
						</div></td>
						<td width="60"><div align="center">
							<cf_hora name="GEADhoraini#i#" form="form#i#" value="#GEADhoraini#" image="false" readOnly="true">
						</div></td>
						<td width="80"><div align="center">
						   #DateFormat(GEADfechafin,'DD/MM/YYYY')#
						</div></td>
						<td width="60"><div align="center">
							<cf_hora name="GEADhorafin#i#" form="form#i#" value="#GEADhorafin#" image="false" readOnly="true">
						</div></td>
							<td width="75"><div align="center">
							#Mnombre#  
						</div></td>
						<td width="75"><div align="right">
							#LSNumberFormat(GEADmontoviatico, ',9.00')#  
						</div></td>
						<td width="75"><div align="right">
							#LSNumberFormat(GEADtipocambio, ',9.00')#  
						</div></td>
						<td width="75"><div align="right">
							#LSNumberFormat(GEADmonto, ',9.00')#  
						</div></td>
					 </tr>
				</form>	
				<cfset totalP +=#GEADmonto#>		
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
		</cfif>	
&nbsp;&nbsp;&nbsp;&nbsp;
	 	<table width="100%" border="0" align="center">
			 <tr bgcolor="0033BB">
				<td colspan="4"><div align="center" class="style1" style="font-size:12px">Datos de la Liquidaci&oacute;n</div></td>
			</tr>
			<tr>
				<td><div align="left"><strong>Moneda: #rsDatos.Mnombre#</strong></div> </td>
				<td><div align="left"><strong>Fecha Inicio:  #LSDateFormat(rsDatos.GEAdesde,'DD/MM/YYYY') #</strong></div></td>
				<td><div align="left"><strong>Fecha Final: #LSDateFormat(rsDatos.GEAhasta,'DD/MM/YYYY')  #</strong></div></td>
				<td><div align="left"><strong>Tipo: <cfif #tipo# eq 1> Interior <cfelseif  #tipo# eq 2> Exterior </cfif></strong></div></td>
			 </tr>
		 </table>



		<cfset modo= "ALTA">
			<form action="LiquidacionAnticiposViaticos_sql.cfm" method="post" name="formEncabezado" onsubmit="return validar();">
				<table width="770" border="0" align="center">
					 <tr bgcolor="999999">
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
							<input type="hidden" name="GEAid" value="#GEAid#"/>	
							<input type="hidden" name="GELid" value="#GELid#"/>		
							<input type="hidden" name="GECVdescripcion" value=""/>
							<input type="hidden" name="GEAdesde" value="#LSDateFormat(rsDatos.GEAdesde,'DD/MM/YYYY')#"/>
							<input type="hidden" name="GEAhasta" value="#LSDateFormat(rsDatos.GEAhasta,'DD/MM/YYYY')  #"/>
									
							<cf_sifclasificacionViaticos id="GECVid" name="GECVcodigo" desc="GECVdescripcion2" tipoV="#tipo#" form="formEncabezado" >
							 
							</div></td>
							<td width="80"><div align="center">
								<cf_sifcalendario name="GEADfechaini" value="#DateFormat(now(),'DD/MM/YYYY')#" form="formEncabezado">
							</div></td>
							<td width="60"><div align="center">
								<cf_hora name="GEADhoraini" form="formEncabezado">
							</div></td>
							<td width="80"><div align="center">
							   <cf_sifcalendario name="GEADfechafin" value="#DateFormat(now(),'DD/MM/YYYY')#" form="formEncabezado"> 
							</div></td>
							<td width="60"><div align="center">
								<cf_hora name="GEADhorafin" form="formEncabezado">
							</div></td>
						</tr>
				</table>
				<cf_botones modo="ALTA" exclude="limpiar">	
				 <input type="hidden" name="BMUsucodigo" value="#session.usucodigo#" />
				 <input type="hidden" name="modo" value="ALTA" />
			</form>
			<table width="100%" border="0" align="center" >
				 <tr bgcolor="999999">
						<td width="150"><div align="center"><strong>Plantilla</strong></div></td>
						<td width="159"><div align="center"><strong>Clasificaci&oacute;n</strong></div></td>
						<td width="80"><div align="center"><strong>Fecha Inicio</strong></div></td>
						<td width="65"><div align="center"><strong>Hora Inicio</strong></div></td>
						<td width="80"><div align="center"><strong>Fecha Final</strong></div></td>
						<td width="70"><div align="center"><strong>Hora Final</strong></div></td>
						<td width="75"><div align="center"><strong>Moneda Plantilla</strong></div></td>
						<td width="90"><div align="center"><strong>Monto Plantilla</strong></div></td>
						<td width="90"><div align="center"><strong>Monto Real </strong></div></td>
						<td width="65"><div align="center"><strong>Tipo de Cambio </strong></div></td>
						<td width="90"><div align="center"><strong>Monto </strong></div></td>
						<td width="20"></td>
				  </tr>
			</table>
	 	<cfif rsPlantillas.recordcount gt 0 or GEAid eq -1>
			 <form action="LiquidacionAnticiposViaticos_sql.cfm" method="post" name="formDet" id="formDet">
				 <input type="hidden" name="modo" id="modo" value="">
				 <input type="hidden" name="GEAid" value="#GEAid#"/>	
				 <input type="hidden" name="GELid" value="#GELid#"/>	
				 <input type="hidden" name="linea" id="linea" value="0"/>	
				 <cfset LvarCount= 0>
				 <cfset totalL = 0>
				<table width="100%" border="0" align="center"> 
					 <cfloop query="rsLiquidaciones">	
						<cfset LvarCount= LvarCount + 1>
						<tr>
							<td width="148"  nowrap="nowrap">
								<cfif len(trim(GEPVid)) gt 0 and len(trim(GECid))	>
									<input type="hidden" name="GEPVid" value="#GEPVid#"/>
								<cfelse>
									<input type="hidden" name="GEPVid" value="0"/>
								</cfif>	
								<input type="hidden" name="GELVid" value="#GELVid#"/>
								<div align="center"><strong>
								  #GEPVdescripcion#
								  <input type="hidden" name="GECid" value="#GECid#"/>	
								 </strong></div>
							</td>
							<td width="148"  nowrap="nowrap">
								<div align="center">
									#GECVdescripcion#
									<input type="hidden" name="GECVdescripcion" value="#GECVdescripcion#"/>	
								</div>
							</td>
							<td width="80"  nowrap="nowrap">
								<div align="center">
									<input type="text" name="FInicio" readonly="true" size="10" value="#DateFormat(GELVfechaIni,'DD/MM/YYYY')#"/>							
								</div>
							</td>
							<td width="60"  nowrap="nowrap">
								<div align="center">
									<cf_hora name="GELVhoraIni" form="formDet" value="#GELVhoraIni#" image="false" readOnly="true">
								</div>
							</td>
							<td width="80"  nowrap="nowrap">
								<div align="center">
									<input type="text" name="FFin" readonly="true" size="10" value="#DateFormat(GELVfechaFin,'DD/MM/YYYY')#"/>
								</div>
							</td>
							<td width="70"  nowrap="nowrap">
								<div align="center">
									<cf_hora name="GELVhorafin" form="formDet" value="#GELVhorafin#" image="false" readOnly="true">
								</div>
							</td>
							<td width="75"  nowrap="nowrap">
								<div align="center">
									#Mnombre#  
								</div>
							</td>
							<td width="90"  nowrap="nowrap">
								<div align="right">
									<input type="hidden" name="GELVmontoOri" value="#GELVmontoOri#"/>
									#LSNumberFormat(GELVmontoOri, ',9.00')#  
								</div>
							</td>
							<td width="90"  nowrap="nowrap">
								<div align="right">
									<cf_inputNumber name="montoReal" size="12" value="#GEPVmontoGastMV#" enteros="12" decimales="2" onchange="CambiaTipoD(#LvarCount#)">
								</div>
							</td>
							<td width="60" nowrap="nowrap">
								<div align="right">
									<input type="hidden" name="GELVtipoCambio" value="#GELVtipoCambio#"/>
									#LSNumberFormat(GELVtipoCambio, ',9.00')#  
								</div>
							</td>
							<td width="90" nowrap="nowrap">
								<div align="right">
								<input type="text" name="GELVmonto" value="#LSNumberFormat(GELVmonto,',9.00')#" readonly="true" size="12" align="left"/>
									  
								</div>
							</td>
							<td width="10">
								<img src="/cfmx/sif/imagenes/deletesmall.gif" onclick="javascript:iniciar('formDet','BAJA',#LvarCount#);"/>
							</td>
						</tr>
						<iframe name="monedax1" id="monedax1" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
						<cfset totalL +=#GELVmonto#>		
					</cfloop>
					<tr>
						<td colspan="9">	
						</td>
						<td align="right">	
							<strong>Total:</strong>
						</td>
						<td>
							<strong>#LSNumberFormat(totalL, ',9.00')#  </strong>
						</td>
					</tr>	
				</table>
				<cf_botones incluyeForm="true"   formName="frmRegresar" modo="CAMBIO" include="Regresar" exclude="Nuevo" Functions="funcPopUp(this.form)">	
			</form>
		</cfif>
	</tr>  
</table>
		
<cf_qforms form="formEncabezado">
<script language= "javascript1.2" type="text/javascript">
		objForm.GECVcodigo.description = "Clasificacion del Viatico";
		objForm.GECVcodigo.required = true;
	
	    function iniciar(form,modo,linea)
		 {
		    e = document.getElementById(form);
            e.modo.value = modo;
			e.linea.value = linea;
          	e.submit();	
			return true;
		}
</script>

<script language= "javascript1.2" type="text/javascript">
		function validar(formulario)	{
			
			if (fnFechaYYYYMMDD(document.form1.GEADfechaini.value) > fnFechaYYYYMMDD(document.form1.GEADfechafin.value))
			{
				alert ("La Fecha de Inicio debe ser menor a la Fecha Final");
				return false;
			}
			
			if (fnFechaYYYYMMDD(document.form1.GEAdesde.value) > fnFechaYYYYMMDD(document.form1.GEADfechaini.value))
			{
				alert ("La Fecha de Inicio se sale del rango de fechas"+ document.form1.GEAdesde.value + " > " +document.form1.GEADfechaini.value);
				return false;
			}
			
			if (fnFechaYYYYMMDD(document.form1.GEADfechafin.value) > fnFechaYYYYMMDD(document.form1.GEAhasta.value))
			{
				alert ("La Fecha Final se sale del rango de fechas");
				return false;
			}
		
		}//termina validar
		
		function fnFechaYYYYMMDD (LvarFecha)
		{
			return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
		}
</script>

<script language= "javascript1.2" type="text/javascript">
		function funcPopUp(form){
			GEAid = form.GEAid.value;
			GELid = form.GELid.value;
			
			var Observacion=false;
			
			if (form.montoReal)
			{
				if (form.montoReal.length)
				{
					<!-- Arreglo
					for(var i=0; i<form.montoReal.length; i++)
					{
						form.montoReal[i].value = qf(form.montoReal[i]);//esto es para quitar las comas y no se confunda con el arreglo
						form.GELVmontoOri[i].value = qf(form.GELVmontoOri[i]);
						form.GELVmonto[i].value = qf(form.GELVmonto[i]);
						if(Number(form.montoReal[i].value) > Number(form.GELVmontoOri[i].value))
						{
							var Observacion=true;
						}
					}
				}
				else
				{
					<!-- Para el campo
					form.montoReal.value = qf(form.montoReal);//esto es para quitar las comas y no se confunda con el arreglo
					form.GELVmontoOri[i].value = qf(form.GELVmontoOri[i]);
					form.GELVmonto[i].value = qf(form.GELVmonto[i]);
					if(form.montoReal.value > form.GELVmontoOri.value )
						{
							var Observacion=true;
						}
				}
			}
			if(Observacion==true)
			{   
				var PARAM  = "LiquidacionAnticiposObs-popUp.cfm?GEAid="+GEAid+"&GELid="+GELid+""
				window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=450,height=300')
				return false;
			}
			
			
		}//termina validarDet
		
		function CambiaTipoD(LvarCount)
		{
			Linea=LvarCount-1;
			document.formDet.montoReal[Linea].value = qf(formDet.montoReal[Linea]);
			document.formDet.GELVtipoCambio[Linea].value=qf(formDet.GELVtipoCambio[Linea]);
			montoReal = document.formDet.montoReal[Linea].value;
			GELVtipoCambio = document.formDet.GELVtipoCambio[Linea].value;
			document.getElementById('monedax1').src = 'LiquidacionAnticiposCambia.cfm?GELVtipoCambio='+GELVtipoCambio+'&montoReal='+montoReal+'&Linea='+Linea+'';	
		}
		
</script>
</cfoutput>	
<cf_web_portlet_end>
<cf_templatefooter>