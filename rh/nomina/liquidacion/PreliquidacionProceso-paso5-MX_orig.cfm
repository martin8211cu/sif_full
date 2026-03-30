
<!--- ============================================= --->
<!--- Traducciones --->
<!--- ============================================= --->
	<!--- codigo --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Codigo"
		Default="C&oacute;digo"
		xmlfile="/rh/generales.xml"		
		returnvariable="vCodigo"/>		

	<!--- descripcion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Descripcion"
		Default="Descripci&oacute;n"
		xmlfile="/rh/generales.xml"		
		returnvariable="vDescripcion"/>		

	<!--- importe --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Importe"
		Default="Importe"
		returnvariable="vImporte"/>		

	<!--- anterior --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Anterior"
		Default="Anterior"
		xmlfile="/rh/generales.xml"				
		returnvariable="vAnterior"/>		

	<!--- Aprobar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Aprobar"
		Default="Aprobar"
		xmlfile="/rh/generales.xml"				
		returnvariable="vAprobar"/>	

	<!--- Socio --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Socio_de_Negocios"
		xmlfile="/rh/generales.xml"
		Default="Socio de Negocios"
		returnvariable="vSocio"/>		

	<!--- Referencia --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Referencia"
		Default="Referencia"
		returnvariable="vReferencia"/>		

	<!--- Deduccion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Deduccion"
		xmlfile="/rh/generales.xml"
		Default="Deducci&oacute;n"
		returnvariable="vDeduccion"/>	
		
	<!--- Provisiones --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Provisiones"
		Default="Provisiones"
		returnvariable="vProvisiones"/>		

	<!--- Subtotal --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Subtotal"
		Default="Subtotal"
		xmlfile="/rh/generales.xml"
		returnvariable="vSubtotal"/>		

<!--- ============================================= --->
<!--- ============================================= --->

<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnGetLF" returnvariable="rsLF">
	<cfinvokeargument name="RHPLPid" value="#form.RHPLPid#">
	<cfinvokeargument name="DEid" value="#form.DEid#">
</cfinvoke>


<cfif rsLF.recordcount gt 0>
	<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnValidaModificaciones" returnvariable="datosHanCambiado">
		<cfinvokeargument name="RHPLPid" value="#form.RHPLPid#">
		<cfinvokeargument name="DEid" value="#form.DEid#">
		<cfinvokeargument name="Fecha" value="#rsLF.RHPLPfsalida#">
        
	</cfinvoke>
</cfif>
<cfquery name="rsRHLiqIngresosPrevAutom" datasource="#session.DSN#">
	select coalesce(sum(importe),0)  as totIngresos 
	from RHLiqIngresosPrev
	where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#"> 
	  and RHLPautomatico = 1
</cfquery> 
<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function goPrevious() {
		document.form1.paso.value = "3";
		document.form1.submit();
	}
	
	<!---function funcAprobar(){
		<cfif rsLF.recordcount eq 0>
			alert("El paso 2 es necesario para la liquidación y este no ha sido proceso, debe de Guardar los datos generados por este para aprobar la Liquidación.")
			return false;
		<cfelseif datosHanCambiado>
			alert("Los datos del paso 2 han sido modificados y no se han guardado, debe de Guardar los datos para aprobar la Liquidación.")
			return false;
		<cfelse>
			if(confirm("Está seguro de aprobar la liquidación?, esta no podrá se modificada posterior a su aprobación."))
				return true;
			return false;
		</cfif>
	}--->
	
	//-->
</SCRIPT>
<cfoutput>
<form action="#CurrentPage#" method="post" name="form1" >
		<input type="hidden" name="paso" value="#Gpaso#">
		<input type="hidden" name="DEid" value="#form.DEid#">
		<cfif RHPLPid NEQ 0>
			<input name="RHPLPid" type="hidden" value="#RHPLPid#">
		</cfif>
	<table align="center" width="100%"   cellpadding="0" cellspacing="5" border="1">
			<tr>
			  <td width="33%" nowrap><div align="center"><strong><cf_translate key="LB_Otros_Ingresos">Otros Ingresos</cf_translate></strong></div></td>
				<td width="33%"><div align="center"><strong>
				<cf_translate key="LB_Aportes_Realizados">Cargas Sociales </cf_translate>
				</strong></div></td>
				<td width="33%" nowrap><div align="center"><strong>&nbsp;<cf_translate key="LB_Deducciones" xmlfile="/rh/generales.xml">Deducciones</cf_translate></strong></div></td>
			</tr>																						  
			<tr>
			  <td width="33%" valign="top">
				  <table width="95%" border="0">
				    <tr>
					  <td>
						  <cfquery name="rsSumRHLiqIngresosPrev" datasource="#session.DSN#">
							select coalesce(sum( case when a.importe < 0 then a.importe else a.importe*b.CInegativo end ),0) as totIngresos

							from RHLiqIngresosPrev a
							
							inner join CIncidentes b
							on b.CIid=a.CIid
							
							where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#"> 
							and a.RHLPautomatico = 0
						  </cfquery> 
					       <cfquery name="rsRHLiqIngresosPrev" datasource="#session.DSN#">
							  select 1 as paso, a.RHPLPid, a.DEid, b.RHPLPid, b.RHLPdescripcion as nombre, b.importe, 
							  		c.CIcodigo, substring(c.CIdescripcion,1,25) as CIdescripcion
								from RHPreLiquidacionPersonal a
					
								  inner join RHLiqIngresosPrev b
									on  a.Ecodigo = b.Ecodigo
									and a.DEid = b.DEid
									and a.RHPLPid = b.RHPLPid
									and b.RHLPautomatico = 0
					
								  inner join CIncidentes c
									on  b.CIid = c.CIid
									and b.Ecodigo = c.Ecodigo
									
								where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
							  order by 2
						  </cfquery> 
					
						   <cfinvoke 
								component="rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
								  <cfinvokeargument name="query" value="#rsRHLiqIngresosPrev#"/>
								  <cfinvokeargument name="desplegar" value="CIcodigo, CIdescripcion, importe "/>
								  <cfinvokeargument name="etiquetas" value="#vCodigo#, #vDescripcion#, #vImporte#"/>
								  <cfinvokeargument name="formatos" value="S, S, M"/>
								  <cfinvokeargument name="align" value="left, left, right"/>
								  <cfinvokeargument name="ajustar" value="N"/>
								  <cfinvokeargument name="debug" value="N"/>
								  <cfinvokeargument name="keys" value="RHPLPid"/> 
								  <cfinvokeargument name="showEmptyListMsg" value= "1"/>
								  <cfinvokeargument name="showLink" value= "false"/>
								  <cfinvokeargument name="checkboxes" value="N"/>
								  <cfinvokeargument name="botones" value=""/>
								  <cfinvokeargument name="irA" value= ""/>
								  <cfinvokeargument name="incluyeForm" value= "false"/>
								  <cfinvokeargument name="formName" value= "form1"/>
						  </cfinvoke>
					  </td>
				    </tr>
					<tr>
						<td  align="right" valign="bottom">
							
						</td>
					</tr>
				  </table>
				</td>
				<td width="33%" valign="top">
					<table width="95%" border="0">
						  <tr>
							<td>
							<cfquery name="rsSumRHLiqCargasPrev" datasource="#session.DSN#">
								select coalesce(sum(importe),0)  as totCargas
								from RHLiqCargasPrev
								where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#"> 
							  </cfquery> 
							 <cfquery name="rsRHLiqCargasPrev" datasource="#session.DSN#">
								select 3 as paso, a.RHPLPid, a.DEid, 
									b.RHLPCid, b.DEid, b.DClinea, b.SNcodigo, b.RHLCdescripcion, 
									b.importe, b.fechaalta, b.RHLCautomatico, b.BMUsucodigo,
									d.ECid, d.SNcodigo, d.DCcodigo, d.DCmetodo, d.DCdescripcion, d.DCvaloremp, d.DCvalorpat, 
									d.DCprovision, d.DCnorenta, d.DCtipo, d.SNreferencia, d.DCcuentac, d.DCtiporango, d.DCrangomin, 
									d.DCrangomax, d.BMUsucodigo
								from RHPreLiquidacionPersonal a

								  inner join RHLiqCargasPrev b
									on  a.Ecodigo = b.Ecodigo
									and a.DEid = b.DEid
									and a.RHPLPid = b.RHPLPid
									
								  inner join DCargas d 
									on  b.DClinea = d.DClinea
									and b.Ecodigo = d.Ecodigo
									and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
								order by 2
							</cfquery> 
							<!--- <cfdump var="#rsRHLiqCargasPrev#">
							<cfabort> --->
							 <cfinvoke 
								component="rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsRHLiqCargasPrev#"/>
									<cfinvokeargument name="desplegar" value="DCcodigo, DCdescripcion, importe "/>
									<cfinvokeargument name="etiquetas" value="#vProvisiones#, #vDescripcion#, #vImporte#"/>
									<cfinvokeargument name="formatos" value="S, S, M"/>
									<cfinvokeargument name="align" value="left, left, right"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="debug" value="N"/>
									<cfinvokeargument name="keys" value="RHLPCid"/> 
									<cfinvokeargument name="showEmptyListMsg" value= "1"/>
									<cfinvokeargument name="showLink" value= "false"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="botones" value=""/>
									<cfinvokeargument name="irA" value= ""/>
								  <cfinvokeargument name="incluyeForm" value= "false"/>
								  <cfinvokeargument name="formName" value= "form1"/>
						</cfinvoke>				
						
						</td>
						<tr valign="bottom">
						<td  align="right" >
							
						</td>
					</tr>
					  </tr>
					</table>
						
				</td>
				<td width="33%" nowrap valign="top">
					<table width="95%" border="0">
						<tr>
							<td width="183">
							<cfquery name="rsSumRHLiqDeduccionPrev" datasource="#session.DSN#">
								select coalesce(sum(importe),0) as totDeduc
								from RHLiqDeduccionPrev
								where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#"> 
							  </cfquery> 
								<cfquery name="rsRHLiqDeduccionPrev" datasource="#session.DSN#">
									select	
										b.RHLPDid, 
										case 
											when b.Did is null then sn.SNnombre 
											else RHLDdescripcion 
										end as nombre,
										b.importe, 
										case 
											when b.Did is null then sn.SNnumero 
											else td.TDcodigo 
										end as Codigo
									from RHPreLiquidacionPersonal a
									  inner join RHLiqDeduccionPrev b
										 on a.DEid = b.DEid
										and a.RHPLPid = b.RHPLPid
										
									left outer join DeduccionesEmpleado de
									   on b.DEid = de.DEid
									   and b.Did = de.Did
									   
									left outer join TDeduccion td
									   on de.Ecodigo = td.Ecodigo
									   and de.TDid = td.TDid
									   
									inner join SNegocios sn
										on b.SNcodigo = sn.SNcodigo
										and a.Ecodigo = sn.Ecodigo
						
									where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
									union
									select
											-1 as RHLPDid,
											'I.S.R' as nombre,
											RHLFLisptF as importe,
											'Deducciones' as codigo
									from RHLiqFLPrev
									where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
									and RHLFLisptF > 0
								</cfquery> 
								<cfquery name="rsRHLiqDeduccionPrevSUM" datasource="#session.DSN#">
									select isnull(sum(importe),0) totDeduc
									from (
										select	
											b.RHLPDid, 
											case 
												when b.Did is null then sn.SNnombre 
												else RHLDdescripcion 
											end as nombre,
											b.importe, 
											case 
												when b.Did is null then sn.SNnumero 
												else td.TDcodigo 
											end as Codigo
										from RHPreLiquidacionPersonal a
										inner join RHLiqDeduccionPrev b
											on a.DEid = b.DEid
											and a.RHPLPid = b.RHPLPid
											
										left outer join DeduccionesEmpleado de
										on b.DEid = de.DEid
										and b.Did = de.Did
										
										left outer join TDeduccion td
										on de.Ecodigo = td.Ecodigo
										and de.TDid = td.TDid
										
										inner join SNegocios sn
											on b.SNcodigo = sn.SNcodigo
											and a.Ecodigo = sn.Ecodigo
							
										where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
										union
										select
												-1 as RHLPDid,
												'I.S.R' as nombre,
												RHLFLisptF as importe,
												'Deducciones' as codigo
										from RHLiqFLPrev
										where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
										and RHLFLisptF > 0
									) a
								</cfquery> 
								 <cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsRHLiqDeduccionPrev#"/>
										<cfinvokeargument name="desplegar" value="Codigo, nombre, importe "/>
										<cfinvokeargument name="etiquetas" value="#vCodigo#, #vDescripcion#, #vImporte#"/>
										<cfinvokeargument name="formatos" value="S, S, M"/>
										<cfinvokeargument name="align" value="left, left, right"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="keys" value="RHLPDid"/> 
										<cfinvokeargument name="showEmptyListMsg" value= "1"/>
										<cfinvokeargument name="showLink" value= "false"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="botones" value=""/>
										<cfinvokeargument name="irA" value= "#CurrentPage#"/>
									  <cfinvokeargument name="incluyeForm" value= "false"/>
									  <cfinvokeargument name="formName" value= "form1"/>
								</cfinvoke>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="right">#vSubtotal#:   <strong>#LSCurrencyFormat(rsSumRHLiqIngresosPrev.totIngresos,'none')#</strong></td>
				<td align="right">#vSubtotal#:   <strong>#LSCurrencyFormat(rsSumRHLiqCargasPrev.totCargas,'none')#</strong></td>
				<td align="right">#vSubtotal#:   <strong>#LSCurrencyFormat(rsRHLiqDeduccionPrevSUM.totDeduc,'none')#</strong></td>
			</tr>
			<tr align="right" nowrap>
				<td>
					<cfset totLiq = rsRHLiqIngresosPrevAutom.totIngresos + rsSumRHLiqIngresosPrev.totIngresos - rsSumRHLiqCargasPrev.totCargas - rsSumRHLiqDeduccionPrev.totDeduc>
					<cfif isdefined("rsRHPreLiquidacionPersonal") and len(trim(rsRHPreLiquidacionPersonal.renta)) and rsRHPreLiquidacionPersonal.renta gt 0 >
						<cfset totLiq = totLiq + rsRHPreLiquidacionPersonal.renta>
					</cfif>
					 <cf_translate key="LB_Total_Liquidacion">Total Liquidaci&oacute;n</cf_translate>: <strong>#LSCurrencyFormat(rsLF.RHLFLresultado - rsSumRHLiqDeduccionPrev.totDeduc,'none')#</strong>
				</td>
				<td colspan="2" align="center" nowrap>
					<cf_botones values="<< #vAnterior#,#vAprobar#" names="Anterior,Aprobar">
				
				</td>
			</tr>	
  </table>
</form>		
</cfoutput>

