<cf_htmlReportsHeaders 
	irA="Transferencias_form.cfm"
	FileName="Reporte_Transferencias.xls"
	title="Reporte de transferencias"
	download="no"
	preview="no"
	Back="no"
	close="yes"
	>
<cfif isDefined("Url.TESTILid") >
  <cfset form.TESTILid = Url.TESTILid>
</cfif>

<cfif isDefined("Url.Imprimir")>
  <cfset form.Imprimir = Url.Imprimir>
</cfif>

<style type="text/css">
<!--
.style3 {font-size: 10px}
-->
</style>

<cfif isdefined ('form.TESTILid') and form.TESTILid NEQ ''>
	
    
	<!-- 1. Lote -->
	<cfquery datasource="#Session.DSN#" name="rsForm">
		select TESTILid, TESid, TESTILtipo, TESTILestado, TESTILdescripcion, TESTILfecha, ts_rversion
		  from TEStransfIntercomL 
		 where TESid=#session.Tesoreria.TESid#
		   and TESTILid=<cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric" >
	</cfquery>

	<!--- 3. Cantidad Transferencias --->	
	<cfquery name="rsFormLineas" datasource="#session.DSN#">
		select min(TESTIDid) as TESTIDid, min(CBidOri) as CBid, count(1) as cantidad 
		  from TEStransfIntercomD 
		 where TESid=#session.Tesoreria.TESid#
		   and TESTILid=<cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric" >
	</cfquery>
    
	<cfset form.TESTIDid = rsFormLineas.TESTIDid>
	<cfif isdefined("Form.TESTIDid") and Form.TESTIDid NEQ "" >	
		<!--- 1. Form detalle --->
		<cfquery name="rsDForm" datasource="#session.DSN#">
			select TESTILid, TESTIDid, TESTIDdocumento, TESTIDreferencia, TESTIDdescripcion,
					CBidOri, Miso4217Ori, EcodigoOri, TESTIDmontoOri, TESTIDcomisionOri, TESTIDtipoCambioOri,
					TESMPcodigo, 
					CBidDst, Miso4217Dst, EcodigoDst, TESTIDmontoDst, TESTIDtipoCambioDst,
				   	ts_rversion, TESTIDdocumentoDst, TESTIDdescripcionDst, TESTIDreferenciaDst
			  from TEStransfIntercomD 
			 where TESid=#session.Tesoreria.TESid#
			   and TESTILid=<cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric" >
			   and TESTIDid=<cfqueryparam value="#form.TESTIDid#" cfsqltype="cf_sql_numeric" >
		</cfquery>
	</cfif> 

    <cfquery datasource="#session.DSN#" name="rsEmpresa">
		select Edescripcion,Ecodigo
        from Empresas
        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

    
	<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;
		  
		 } 
		</style>
<cfoutput>
		
	<table align="center" width="100%" border="0" summary="ImpresioLiquidaciones">
		
		<tr>
			<td align="center" valign="top" colspan="8"><strong>#rsEmpresa.Edescripcion#</strong></td>
		</tr>
        
		<tr>
            <td align="center" valign="top" colspan="8">
				
			</td>	
		</tr>
        
		<tr>
			<td align="center" nowrap="nowrap" colspan="8"><strong> Registro de transferencias entre cuentas bancarias </strong></td>
		</tr>
		<tr>
			<td align="center" nowrap="nowrap" colspan="8"><strong> Fecha del reporte #dateFormat(now(),"DD/MM/YYYY")#</strong></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"class="RLTtopline"> <strong>Resumen de la Transferencia</strong></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Tipo:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">
				<cfif rsForm.TESTILtipo EQ 0>
					Transferencias internas
				<cfelseif rsForm.TESTILtipo EQ 1>
					Transferencias intercompañías
				<cfelseif rsForm.TESTILtipo EQ 2>
					Transferencias intercompañías para devolución
				</cfif>
				</span>
			</td>
		</tr>
        
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Descripcion:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="8">
			  <span class="style3">#rsForm.TESTILdescripcion#</span>		  </td>
		</tr>
        
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Fecha:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="8">
			  <span class="style3">#dateFormat(rsForm.TESTILfecha,"DD/MM/YYYY")#</span>		  </td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Anticipos Asociados</strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong>Anticipo-Linea-Concepto</strong></td>
			<td width="33%" align="center" valign="top" nowrap="nowrap"><strong>Fecha Anticipo</strong></td>			
			<td width="21%" align="right" valign="top" nowrap="nowrap"><strong>Monto del Anticipo</strong></td>
		</tr>
	<!---<cfloop query="rsAnticipos">
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsAnticipos.GEAnumero#-#rsAnticipos.Linea#-#rsAnticipos.GECdescripcion#</span></td>
			<td align="center" valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsAnticipos.GEAfechaPagar,"DD/MM/YYYY")# </span></td>			
			<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsAnticipos.GELAtotal,',9.00')# </span></td>
		</tr>	
	</cfloop>--->
	</table>
</cfoutput>
</cfif>






		
		<!--- ============================================================================================================ --->
		<!---   											Seccion Detalle   									           --->
		<!--- ============================================================================================================ --->		

	

	<table width="100%">
		<tr> 
			<td align="center" colspan="8">
			<div align="center"> 
			<cfif isdefined('Form.TESTILid') and Form.TESTILid NEQ "">
				<cfquery name="rsListaDet" datasource="#session.DSN#">
					select t.TESid, t.TESTILid, t.TESTIDid, t.TESTIDdocumento as doc
							, eo.Edescripcion as EmpOri, co.CBcodigo as CtaOri, t.Miso4217Ori as MonOri, t.TESTIDmontoOri as MntOri
							, ed.Edescripcion as EmpDst, cd.CBcodigo as CtaDst, t.Miso4217Dst as MonDst, t.TESTIDmontoDst as MntDst
                            ,TESTIDcomisionOri
					  from TEStransfIntercomD t
						inner join Empresas eo
							 on eo.Ecodigo = t.EcodigoOri
					  	inner join CuentasBancos co
							 on co.CBid = t.CBidOri
						inner join Empresas ed
							 on ed.Ecodigo = t.EcodigoDst
					  	inner join CuentasBancos cd
							 on cd.CBid = t.CBidDst
					 where TESid 	  = #session.Tesoreria.TESid#
					   and TESTILid	  = <cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric" >
                       and co.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit" >
                       and cd.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit" >
				</cfquery>

				<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsListaDet#"/>
					<cfinvokeargument name="desplegar" value="doc, EmpOri, CtaOri, MntOri, MonOri,TESTIDcomisionOri, EmpDst, CtaDst, MntDst, MonDst"/>
					<cfinvokeargument name="etiquetas" value="Documento, Empresa Origen, Cuenta Ori, Monto Origen, ,Comision Origen , Empresa Destino, Cuenta Dst, Monto Destino,"/>
					<cfinvokeargument name="formatos" value="S, S, S, M, S, M, S, S, M, S"/>
					<cfinvokeargument name="align" value="right, left, left, right, left, right, left, left, right, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="n"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="TESid,TESTILid,TESTIDid"/>
					<cfinvokeargument name="showlink" value="false"/>
				</cfinvoke>
			</cfif>
			</div>
			</td>
		</tr>
	</table>
