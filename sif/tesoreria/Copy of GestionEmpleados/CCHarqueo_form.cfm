<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<form name="form1" method="post" action="CCHarqueo_sql.cfm">
<!---<cf_dump var="#form#">--->
<cfif isdefined ('form.CCHAid') and len(trim(form.CCHAid)) gt 0>
	<cfset modo ='CAMBIO'>
		<cfquery name="rsform" datasource="#session.dsn#">
			select a.CCHAid,a.CCHid,a.CCHvales,a.CCHgastos,a.CCHefectivo,a.CCHfaltante, a.CCHsobrante,
			c.CCHresponsable,
			(select DEnombre #LvarCNCT#' '#LvarCNCT#DEapellido1#LvarCNCT#' '#LvarCNCT#DEapellido2 from DatosEmpleado where DEid=c.CCHresponsable) as CCHresponsable1
			from CCHarqueo a 
				inner join CCHica c
				on c.CCHid=a.CCHid
			where CCHAid=#form.CCHAid#
		</cfquery>
	<cfoutput><input type="hidden" value="#rsform.CCHAid#" name="CCHAid" /></cfoutput>
	<cfset LvarF='#rsForm.CCHid#'>
		<cfquery name="rsMonto" datasource="#session.dsn#">
		select CCHImontoasignado from CCHImportes where CCHid=#rsform.CCHid#	
	</cfquery>
	
	<!---<cfquery name="rsTotal" datasource="#session.dsn#">
		select CCHIanticipos,CCHIgastos, CCHImontoasignado,(CCHImontoasignado-(CCHIanticipos+CCHIgastos)) as disponible
		from CCHImportes 
		where CCHid=#rsform.CCHid#
	</cfquery>--->
	
	<cfquery name="rsTotal" datasource="#session.dsn#">
		select b.Vales as CCHIanticipos,b.Gastos as CCHIgastos, b.MontoAsignado as CCHImontoasignado,(b.MontoAsignado -(b.Vales+b.Gastos )) as disponible
		from CCHarqueo a
		inner join 	CCHarqueoD b
			on b.CCHAid= a.CCHAid
		where CCHid=#rsform.CCHid#
	</cfquery>

	<cfset vales=rsTotal.CCHIanticipos>
	<cfset gastos=rsTotal.CCHIgastos>	
<cfelse>
	<cfset modo = 'ALTA'>
	<cfset LvarF=''>
</cfif>

<cfquery name="rsCajas" datasource="#session.dsn#">
	select CCHid,CCHcodigo,CCHdescripcion from CCHica where Ecodigo=#session.Ecodigo#
</cfquery>



<cfoutput>
<table width="100%">
<tr>
	<td align="right">
		<strong>Caja:</strong>
	</td>
	<td align="left">
	<cfif modo eq 'ALTA'>
		<cf_conlis title="LISTA DE CAJAS"
				campos = "CCHid, CCHcodigo, CCHdescripcion" 
				desplegables = "N,S,S" 
				modificables = "N,S,N" 
				size = "0,15,34"
				asignar="CCHid, CCHcodigo, CCHdescripcion"
				asignarformatos="S,S,S"
				tabla="CCHica"
				columnas="CCHid, CCHcodigo, CCHdescripcion"
				filtro="Ecodigo = #Session.Ecodigo# and CCHestado='ACTIVA' "
				desplegar=" CCHcodigo, CCHdescripcion"
				etiquetas=" C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				align="left,left"
				showEmptyListMsg="true"
				EmptyListMsg=""
				form="form1"
				width="800"
				height="500"
				left="70"
				top="20"
				filtrar_por="CCHcodigo, CCHdescripcion"
				index="1"	
				funcion="TraeName(CCHid)"
				fparams="CCHid"				
				/>   
	<cfelse>
				<cf_conlis title="LISTA DE CAJAS"
				campos = "CCHid, CCHcodigo, CCHdescripcion" 
				desplegables = "N,S,S" 
				modificables = "N,S,N" 
				size = "0,15,34"
				asignar="CCHid, CCHcodigo, CCHdescripcion"
				asignarformatos="S,S,S"
				tabla="CCHica"
				columnas="CCHid, CCHcodigo, CCHdescripcion"
				filtro="Ecodigo = #Session.Ecodigo# and CCHestado='ACTIVA' "
				desplegar=" CCHcodigo, CCHdescripcion"
				etiquetas=" C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				align="left,left"
				showEmptyListMsg="true"
				EmptyListMsg=""
				form="form1"
				width="800"
				height="500"
				left="70"
				top="20"
				filtrar_por="CCHcodigo, CCHdescripcion"
				index="1"	
				traerInicial="#LvarF NEQ ''#"	
				traerFiltro="CCHid=#LvarF#"	
				funcion="TraeName(CCHid)"
				fparams="CCHid"	
				readOnly="yes"			
				/>  
	</cfif>     
	</td>
</tr>
<tr>
	<td align="right">
		<strong>Encargado:</strong>
	</td>
	<td align="left">
	
	<cfif not isdefined ('rsform')>
		<input type="text" name="nameE" id="nameE" maxlength="55" size="65" disabled="disabled">
	<cfelse>
		<input type="text" name="nameE" id="nameE" maxlength="55" size="65" value="#rsform.CCHresponsable1#" disabled="disabled" />
	</cfif>
	
	</td>
</tr>

<tr>
	<td align="right">
		<strong>Vales Registrados:</strong>
	</td>
	<td align="left">
		<cfif modo eq 'ALTA'>
		 	<cf_inputNumber name="vales" size="20" value="0.00" enteros="13" decimales="2" maxlenght="15">
		<cfelse>
			<cf_inputNumber name="vales" size="20" value="#rsForm.CCHvales#" enteros="13" decimales="2" maxlenght="15">
		</cfif>
	</td>
</tr>

<tr>
	<td align="right">
		<strong>Total de Gastos Liquidados:</strong>
	</td>
	<td align="left">
	<cfif modo eq 'ALTA'>
		<cf_inputNumber name="gasto" size="20" value="0.00" enteros="13" decimales="2" maxlenght="15">
	<cfelse>
		<cf_inputNumber name="gasto" size="20" value="#rsForm.CCHgastos#" enteros="13" decimales="2" maxlenght="15">
	</cfif>
	
	</td>
</tr>

<tr>
	<td align="right">
		<strong>Total de Efectivo:</strong>
	</td>
	<td align="left">
	<cfif modo eq 'ALTA'>
		<cf_inputNumber name="efectivo" size="20" value="0.00" enteros="13" decimales="2" maxlenght="15">
	<cfelse>
		<cf_inputNumber name="efectivo" size="20" value="#rsForm.CCHefectivo#" enteros="13" decimales="2" maxlenght="15">
	</cfif>
	</td>
</tr>

<tr>
	<td colspan="3" align="center" nowrap="nowrap">
	<cfif modo eq 'ALTA'>
		<input type="submit" value="Aplicar" name="aplica" />
		<input type="submit" value="Regresar" name="Regresar" />
	<cfelse>
		<cf_botones values='Regresar,Reporte' name='Regresar,Reporte'>
	</cfif>
	</td>
</tr>
<tr>
<td colspan="3">
<cfif modo eq 'CAMBIO'>
	<fieldset>
	
	<legend><strong>Resultados del arqueo</strong></legend>
	<table width="%100" border="1" bordercolor="666666">
	<tr bgcolor="CCCCCC">	
		<td><strong>Concepto</strong></td>
		<td><strong>Registrado</strong></td>
		<td><strong>Físico</strong></td>
		<td><strong>Diferencia</strong></td>	
	</tr>
	
	<tr>
		<td><strong>Monto Asignado</strong></td>
		<td align="right">#NumberFormat(rsMonto.CCHImontoAsignado,",0.00")#</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
	</tr>
	
	<tr>
		<td><strong>Vales no Liquidados</strong></td>
		<td align="right">#NumberFormat(vales,",0.00")#</td>
		<td align="right">#NumberFormat(rsform.CCHvales,",0.00")#</td>
		<td align="right"><cfset difVales=#vales#-#rsform.CCHvales#>#NumberFormat(difVales,",0.00")#</td>
	</tr>
	
	<tr>
		<td><strong>Gastos Liquidados</strong></td>
		<td align="right">#NumberFormat(gastos,",0.00")#</td>
		<td align="right">#NumberFormat(rsform.CCHgastos,",0.00")#</td>
		<td align="right"><cfset difGasto=#gastos#-#rsform.CCHgastos#>#NumberFormat(difGasto,",0.00")#</td>
	</tr>
	
	<tr>
		<td><strong>Efectivo Disponible</strong></td>
		<td align="right"><cfset tot=rsMonto.CCHImontoAsignado-vales-gastos>#NumberFormat(tot,",0.00")#</td>
		<td align="right">#NumberFormat(rsform.CCHefectivo,",0.00")#</td>
		<td align="right"><cfset difEfec=(rsMonto.CCHImontoAsignado-vales-gastos)-rsform.CCHefectivo>#NumberFormat(difEfec,",0.00")#</td>
	</tr>
	
	<tr>
		<td><strong>Total</strong></td>
		<td align="right"><cfset tot1=vales+gastos+tot>#NumberFormat(tot1,",0.00")#</td>
		<td align="right"><cfset tot2=rsform.CCHvales+rsform.CCHgastos+rsform.CCHefectivo>#NumberFormat(tot2,",0.00")#</td>
		<td align="right"><cfset tot3=difVales+difGasto+difEfec>#NumberFormat(tot3,",0.00")#</td>
	</tr>
	
	</table>
	
	
	</fieldset>

</td>
</tr>
<tr>

<td>
	<strong>Faltante:</strong>
	#rsForm.CCHFaltante#
</td>
<td>
	<strong>Sobrante:</strong>
	#rsForm.CCHSobrante#
</td>

</tr>
</cfif>
<iframe name="ifnameE" id="ifnameE" marginheight="50" marginwidth="50" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
</table>
</cfoutput>

<script language="javascript">

function TraeName(m){		
		document.getElementById('ifnameE').src ='TraeEmpleado.cfm?CCHid='+m+'';
	}
</script>
