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

<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
	<cfinvokeargument name="DLlinea" value="#form.DLlinea#">
	<cfinvokeargument name="DEid" value="#form.DEid#">
</cfinvoke>
<cfif rsLF.recordcount gt 0>
	<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnValidaModificaciones" returnvariable="datosHanCambiado">
		<cfinvokeargument name="DLlinea" value="#form.DLlinea#">
		<cfinvokeargument name="DEid" value="#form.DEid#">
		<cfinvokeargument name="Fecha" value="#rsDetalleRHLiquidacionPersonal.DLfechaaplic#">
	</cfinvoke>
</cfif>
<cfquery name="rsRHLiqIngresosAutom" datasource="#session.DSN#">
	select coalesce(sum(importe),0)  as totIngresos 
	from RHLiqIngresos
	where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#"> 
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
	
	function funcAprobar(){
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
	}
	
	//-->
</SCRIPT>
<cfoutput>
<form action="#CurrentPage#" method="post" name="form1" >
		<input type="hidden" name="paso" value="#Gpaso#">
		<input type="hidden" name="DEid" value="#form.DEid#">
		<cfif DLlinea NEQ 0>
			<input name="DLlinea" type="hidden" value="#DLlinea#">
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
						  <cfquery name="rsSumRHLiqIngresos" datasource="#session.DSN#">
							select coalesce(sum( case when a.importe < 0 then a.importe else a.importe*b.CInegativo end ),0) as totIngresos

							from RHLiqIngresos a
							
							inner join CIncidentes b
							on b.CIid=a.CIid
							
							where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#"> 
							and a.RHLPautomatico = 0
						  </cfquery> 
					       <cfquery name="rsRHLiqIngresos" datasource="#session.DSN#">
							  select 1 as paso, a.DLlinea, a.DEid, b.RHLPid, b.RHLPdescripcion as nombre, b.importe, 
							  		c.CIcodigo, substring(c.CIdescripcion,1,25) as CIdescripcion
								from RHLiquidacionPersonal a
					
								  inner join RHLiqIngresos b
									on  a.Ecodigo = b.Ecodigo
									and a.DEid = b.DEid
									and a.DLlinea = b.DLlinea
									and b.RHLPautomatico = 0
					
								  inner join CIncidentes c
									on  b.CIid = c.CIid
									and b.Ecodigo = c.Ecodigo
									
								where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
							  order by 2
						  </cfquery> 
					
						   <cfinvoke 
								component="rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
								  <cfinvokeargument name="query" value="#rsRHLiqIngresos#"/>
								  <cfinvokeargument name="desplegar" value="CIcodigo, CIdescripcion, importe "/>
								  <cfinvokeargument name="etiquetas" value="#vCodigo#, #vDescripcion#, #vImporte#"/>
								  <cfinvokeargument name="formatos" value="S, S, M"/>
								  <cfinvokeargument name="align" value="left, left, right"/>
								  <cfinvokeargument name="ajustar" value="N"/>
								  <cfinvokeargument name="debug" value="N"/>
								  <cfinvokeargument name="keys" value="RHLPid"/> 
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
							<cfquery name="rsSumRHLiqCargas" datasource="#session.DSN#">
								select coalesce(sum(importe),0)  as totCargas
								from RHLiqCargas
								where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#"> 
							  </cfquery> 
							 <cfquery name="rsRHLiqCargas" datasource="#session.DSN#">
								select 3 as paso, a.DLlinea, a.DEid, 
									b.RHLCid, b.DEid, b.DClinea, b.SNcodigo, b.RHLCdescripcion, 
									b.importe, b.fechaalta, b.RHLCautomatico, b.BMUsucodigo,
									d.ECid, d.SNcodigo, d.DCcodigo, d.DCmetodo, d.DCdescripcion, d.DCvaloremp, d.DCvalorpat, 
									d.DCprovision, d.DCnorenta, d.DCtipo, d.SNreferencia, d.DCcuentac, d.DCtiporango, d.DCrangomin, 
									d.DCrangomax, d.BMUsucodigo
								from RHLiquidacionPersonal a

								  inner join RHLiqCargas b
									on  a.Ecodigo = b.Ecodigo
									and a.DEid = b.DEid
									and a.DLlinea = b.DLlinea
									
								  inner join DCargas d 
									on  b.DClinea = d.DClinea
									and b.Ecodigo = d.Ecodigo
									and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
								order by 2
							</cfquery> 
							<!--- <cfdump var="#rsRHLiqCargas#">
							<cfabort> --->
							 <cfinvoke 
								component="rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsRHLiqCargas#"/>
									<cfinvokeargument name="desplegar" value="DCcodigo, DCdescripcion, importe "/>
									<cfinvokeargument name="etiquetas" value="#vProvisiones#, #vDescripcion#, #vImporte#"/>
									<cfinvokeargument name="formatos" value="S, S, M"/>
									<cfinvokeargument name="align" value="left, left, right"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="debug" value="N"/>
									<cfinvokeargument name="keys" value="RHLCid"/> 
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
							<cfquery name="rsSumRHLiqDeduccion" datasource="#session.DSN#">
								select coalesce(sum(importe),0) as totDeduc
								from RHLiqDeduccion
								where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#"> 
							  </cfquery> 
								<cfquery name="rsRHLiqDeduccion" datasource="#session.DSN#">
									select	4 as paso, a.DLlinea, a.DEid, 
									b.RHLDid, b.DLlinea, b.Did, case when b.Did is null then sn.SNnombre else RHLDdescripcion end as nombre, b.RHLDreferencia, b.SNcodigo, b.importe, 
									b.fechaalta, b.RHLDautomatico, b.BMUsucodigo, case when b.Did is null then sn.SNnumero else td.TDcodigo end as Codigo, td.TDdescripcion
									from RHLiquidacionPersonal a
									  inner join RHLiqDeduccion b
										 on a.DEid = b.DEid
										and a.DLlinea = b.DLlinea
										
									left outer join DeduccionesEmpleado de
									   on b.DEid = de.DEid
									   and b.Did = de.Did
									   
									left outer join TDeduccion td
									   on de.Ecodigo = td.Ecodigo
									   and de.TDid = td.TDid
									   
									inner join SNegocios sn
										on b.SNcodigo = sn.SNcodigo
										and a.Ecodigo = sn.Ecodigo
						
									where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
									order by 2
								</cfquery> 
								 <cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsRHLiqDeduccion#"/>
										<cfinvokeargument name="desplegar" value="Codigo, nombre, importe "/>
										<cfinvokeargument name="etiquetas" value="#vCodigo#, #vDescripcion#, #vImporte#"/>
										<cfinvokeargument name="formatos" value="S, S, M"/>
										<cfinvokeargument name="align" value="left, left, right"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="keys" value="RHLDid"/> 
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
				<td align="right">#vSubtotal#:   <strong>#LSCurrencyFormat(rsSumRHLiqIngresos.totIngresos,'none')#</strong></td>
				<td align="right">#vSubtotal#:   <strong>#LSCurrencyFormat(rsSumRHLiqCargas.totCargas,'none')#</strong></td>
				<td align="right">#vSubtotal#:   <strong>#LSCurrencyFormat(rsSumRHLiqDeduccion.totDeduc,'none')#</strong></td>
			</tr>
			<tr align="right" nowrap>
				<td>
					<cfset totLiq = rsRHLiqIngresosAutom.totIngresos + rsSumRHLiqIngresos.totIngresos - rsSumRHLiqCargas.totCargas - rsSumRHLiqDeduccion.totDeduc>
					<cfif isdefined("rsRHLiquidacionPersonal") and len(trim(rsRHLiquidacionPersonal.renta)) and rsRHLiquidacionPersonal.renta gt 0 >
						<cfset totLiq = totLiq + rsRHLiquidacionPersonal.renta>
					</cfif>
					 <cf_translate key="LB_Total_Liquidacion">Total Liquidaci&oacute;n</cf_translate>: <strong>#LSCurrencyFormat(rsLF.RHLFLresultado,'none')#</strong>
				</td>
				<td colspan="2" align="center" nowrap>
					<cf_botones values="<< #vAnterior#,#vAprobar#" names="Anterior,Aprobar">
				
				</td>
			</tr>	
  </table>
</form>		
</cfoutput>

