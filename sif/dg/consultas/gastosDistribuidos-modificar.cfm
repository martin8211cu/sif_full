<cfif isdefined("url.btnModificar")>
	<cfset vdebitos = replace(url.Debitos,',', '', 'all') >
	<cfset vcreditos = replace(url.Creditos, ',', '', 'all') >
	<cfset vMov = vdebitos - vcreditos >
	<cfquery datasource="#session.DSN#">
		update DGGastosxDistribuir
		set Debitos = <cfqueryparam cfsqltype="cf_sql_money" value="#vdebitos#">,
			Creditos = <cfqueryparam cfsqltype="cf_sql_money" value="#vcreditos#">,
			montodist = <cfqueryparam cfsqltype="cf_sql_money" value="#vMov#">
		where DGDGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DGDGid#">
	</cfquery>

	<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		window.opener.location.href = '/cfmx/sif/dg/consultas/gastosDistribuidos.cfm?proceso=ok&DGGDid=#url.DGGDid#&periodo=#url.periodo#&mes=#url.mes#&orden=#url.orden#';
	</script>
	</cfoutput>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="data" datasource="#session.DSN#">
	select 	a.DGGDid,
			a.DGGDcodigo,
			a.DGGDdescripcion, 
			( select rtrim(DGCcodigo) #_Cat#' - ' #_Cat#DGdescripcion
			  from DGConceptosER
			  where DGCid = a.DGCiddest ) as destino, 
			DGCDid,
			( select rtrim(DGCDcodigo) #_Cat#' - ' #_Cat#DGCDdescripcion
			  from DGCriteriosDistribucion
			  where DGCDid = a.DGCDid ) as criterio, 
			DGCid,
			( select rtrim(DGCcodigo) #_Cat#' - ' #_Cat#DGdescripcion
			  from DGConceptosER
			  where DGCid = a.DGCid ) as concepto, 
			
			case Criterio when 30 then 'Presupuesto Acumulado' 
						  when 40 then 'Real Acumulado'
						  when 50 then 'Presupuesto Mes'
						  when 60 then 'Real Mes'
			end as Criterio
			
			
	from DGGastosDistribuir a
	where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DGGDid#" >
	order by a.DGGDcodigo
</cfquery>

<cfquery name="data2" datasource="#session.DSN#">
	select Debitos, Creditos, Debitos-Creditos as movimientos,  Cformato, Oficodigo, e.Edescripcion as empresa, DebitosOri, CreditosOri, Presupuesto
	from DGGastosxDistribuir a
	inner join CContables cc
	on cc.Ccuenta= a.Ccuenta
	
	inner join Oficinas o 
	on o.Ocodigo=a.Ocodigo
	and o.Ecodigo=a.Empresa
	
	inner join Empresas e
	on e.Ecodigo=a.Empresa
	
	where DGDGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DGDGid#" >
</cfquery>


<cf_templatecss>
<cfoutput>
			<table width="98%" align="center" cellpadding="2" cellspacing="0" bgcolor="##e5e5e5">
				<tr style="padding:1px">
					<td width="1%" nowrap="nowrap" ><strong>Gasto a Distribuir:</strong></td>
					<td >#trim(data.DGGDcodigo)# - #data.DGGDdescripcion#</td>
				</tr>
				<tr >
					<td width="1%" nowrap="nowrap" ><strong>Per&iacute;odo:</strong></td>
					<td >#url.Periodo#</td>
				</tr>

				<tr >
					<td width="1%" nowrap="nowrap" ><strong>Mes:</strong></td>
					<td >#url.Mes#</td>
				</tr>

				<tr >
					<td width="1%" nowrap="nowrap" ><strong>Empresa:</strong></td>
					<td >#data2.Empresa#</td>
				</tr>

				<tr >
					<td width="1%" nowrap="nowrap" ><strong>Oficina:</strong></td>
					<td >#data2.Oficodigo#</td>
				</tr>

				<tr >
					<td width="1%" nowrap="nowrap" ><strong>Cuenta:</strong></td>
					<td >#data2.Cformato#</td>
				</tr>

				<cfif len(trim(data.DGCid))>
					<tr style="padding:4px">
						<td width="1%" nowrap="nowrap"><strong>Concepto ER:</strong></td>
						<td >#data.concepto#</td>
					</tr>
					<tr >
						<td width="1%" nowrap="nowrap" ><strong>Criterio:</strong></td>
						<td >#data.Criterio#</td>
					</tr>
				<cfelse>
				<tr >
						<td width="1%" nowrap="nowrap" ><strong>Criterio de Distribuci&oacute;n:</strong></td>
						<td >#data.criterio#</td>
					</tr>
				</cfif>
				<tr style="padding:1px">
					<td width="1%"  nowrap="nowrap"><strong>Concepto ER destino:</strong></td>
					<td >#data.destino#</td>
				</tr>
			</table>

<form name="form1" method="get" action="gastosDistribuidos-modificar.cfm">
	<input type="hidden" name="DGDGid" 	value="#url.DGDGid#" />
	<input type="hidden" name="DGGDid" 	value="#url.DGGDid#" />
	<input type="hidden" name="periodo" value="#url.periodo#" />
	<input type="hidden" name="mes" 	value="#url.mes#" />			
	<input type="hidden" name="orden"	value="#url.orden#" />
	

	<table width="98%" align="center" cellpadding="3" cellspacing="0" style="border: 1px solid ##e5e5e5;">
		<tr><td>
			<table width="50%" align="center" cellpadding="3" cellspacing="1">
			
				<tr bgcolor="##fafafa">
					<td align="right" nowrap="nowrap"><strong>D&eacute;bitos original:</strong>&nbsp;</td>
					<td align="right">#LSNumberFormat(data2.Debitosori,',9.00')#</td>
				</tr>
				<tr bgcolor="##fafafa">
					<td align="right"  nowrap="nowrap"><strong>Cr&eacute;ditos original:</strong>&nbsp;</td>
					<td align="right">#LSNumberFormat(data2.Creditosori,',9.00')#</td>
				</tr>
				<tr bgcolor="##fafafa">
					<td align="right"  nowrap="nowrap"><strong>Presupuesto:</strong>&nbsp;</td>
					<td align="right">#LSNumberFormat(data2.presupuesto,',9.00')# </td>
				</tr>
		
				<tr>
					<td align="right"><strong>D&eacute;bitos:</strong>&nbsp;</td>
					<td align="right"><cf_monto name="Debitos" value="#data2.Debitos#" size="15" ></td>
				</tr>
				<tr>
					<td align="right"><strong>Cr&eacute;ditos:</strong>&nbsp;</td>
					<td align="right"><cf_monto name="Creditos" value="#data2.Creditos#" size="15" ></td>
				</tr>
				<tr>
					<td align="right"><strong>Movimientos:</strong>&nbsp;</td>
					<td align="right"><input type="text" size="16" style="text-align:right" readonly maxlength="15" name="movimientos" id="movimientos" value="#LSNumberFormat(data2.movimientos,',9.00')#" /> </td>
				</tr>
		
				<tr><td colspan="2" align="center">
					<input type="submit" name="btnModificar" value="Modificar" class="btnGuardar" />		
					<input type="button" name="btnCerrar" value="Cerrar" class="btnNormal" onClick="javascript:window.close();" />					
				</td></tr>
			</table>
	</td></tr>
	</table>
	
</form>

<cf_qforms>
<script src="../../js/utilesMonto.js"></script>
<script type="text/javascript" language="javascript1.2">
	function calcular(){
		if (document.form1.Debitos.value == ''){
			document.form1.Debitos.value = 0;
		}
		if (document.form1.Creditos.value == ''){
			document.form1.Creditos.value = 0;
		}
		
		var debitos = new Number(qf(document.form1.Debitos.value));
		var creditos = new Number(qf(document.form1.Creditos.value));		
		document.form1.movimientos.value = debitos-creditos;
		fm(document.form1.movimientos, 2);
	}
	
	function funcCreditos(){ calcular() }
	function funcDebitos(){ calcular() }
	
	objForm.Debitos.required = true;
	objForm.Creditos.description = 'Débitos';		

	objForm.Creditos.required = true;
	objForm.Creditos.description = 'Créditos';	
	
	

</script>


</cfoutput>
