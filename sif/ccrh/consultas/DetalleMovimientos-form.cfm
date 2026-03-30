<cfif isdefined("url.TDid") and not isdefined("form.TDid")>
	<cfset form.TDid = url.TDid >
</cfif>
<cfif isdefined("url.FechaInicial") and not isdefined("form.FechaInicial")>
	<cfset form.FechaInicial = url.FechaInicial >
</cfif>
<cfif isdefined("url.FechaFinal") and not isdefined("form.FechaFinal")>
	<cfset form.FechaFinal = url.FechaFinal >
</cfif>

<style type="text/css">
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<!--- VERIFICA QUE LAS FECHA INICIAL SEA MENOR QUE LA FECHA FINAL, Y SI NO LAS INVIERTE--->
<cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial)) and isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
	<cfset form.FechaInicial = LSParseDateTime(form.FechaInicial) >
	<cfset form.FechaFinal = LSParseDateTime(form.FechaFinal) >
	<cfif form.FechaInicial gt form.FechaFinal >
		<cfset tmp = form.FechaInicial >
		<cfset form.FechaInicial = form.FechaFinal >
		<cfset form.FechaFinal = tmp >
	</cfif>
</cfif>
<!----------------------------------Imprime el Reporte-------------------------------------->
<cfset parametros = ''>
<cf_rhimprime datos="/sif/ccrh/consultas/DetalleMovimientos-form.cfm" paramsuri="&FechaInicial=#LSDateFormat(form.FechaInicial,'dd/mm/yyyy')#&FechaFinal=#LSDateFormat(form.FechaFinal,'dd/mm/yyyy')#&TDid=#form.TDid##parametros#">
<!------------------------------------------------------------------------------------------>
<cfif isdefined("url.totaliza") and not isdefined("form.totaliza")>
	<cfset form.totaliza = url.totaliza >
</cfif>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="data" datasource="#session.DSN#">
		select 	a.Did, 
				a.DEid,
				0 as Tipo,
				a.Dfechadoc as FechaTrans,
				c.DEnombre #_Cat# ' ' #_Cat# c.DEapellido1 #_Cat# ' ' #_Cat# c.DEapellido2 as DEnombre,
				c.DEidentificacion,
				a.Dreferencia, 
				b.TDcodigo,
				b.TDdescripcion,  
				a.Dfechaini, 
				a.Dfechafin,
				a.Dmonto, 
				a.Dsaldo,
				a.Dmonto as MontoMov,
				0 as Amortizacion
		from DeduccionesEmpleado a
		
		inner join TDeduccion b
		  on b.TDid = a.TDid
		  and b.Ecodigo = a.Ecodigo
		  and b.TDfinanciada = 1
		  
		<cfif isdefined("form.TDcodigo") and len(trim(form.TDcodigo))>
			and b.TDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigo#">
		</cfif>
		
		inner join DatosEmpleado c
		  on c.DEid = a.DEid
		  and a.Ecodigo = a.Ecodigo

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  <!--- and a.Dsaldo > 0  --->
		   
		and a.Dfechadoc between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaInicial#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaFinal#">

		union
	
		select 	a.Did, 
				a.DEid,
				1 as Tipo,
				d.PPfecha_pago as FechaTrans,
				c.DEnombre #_Cat# ' ' #_Cat# c.DEapellido1 #_Cat# ' ' #_Cat# c.DEapellido2 as DEnombre,
				c.DEidentificacion,
				a.Dreferencia, 
				b.TDcodigo,
				b.TDdescripcion,  
				a.Dfechaini, 
				a.Dfechafin,
				a.Dmonto, 
				a.Dsaldo,
				d.PPprincipal + d.PPinteres as MontoMov,
				d.PPprincipal as Amortizacion
		from DeduccionesEmpleado a
		
		inner join TDeduccion b
		  on b.TDid = a.TDid
		  and b.Ecodigo = a.Ecodigo
		  and b.TDfinanciada = 1
		  
		<cfif isdefined("form.TDcodigo") and len(trim(form.TDcodigo))>
			and b.TDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigo#">
		</cfif>
		
		inner join DatosEmpleado c
		  on c.DEid = a.DEid
		  and a.Ecodigo = a.Ecodigo
 
		inner join DeduccionesEmpleadoPlan d
		  on d.Did = a.Did
		  and d.PPpagado in (1,2)
		  and d.PPfecha_doc <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.FechaFinal#">

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  <!--- and a.Dsaldo > 0 --->

		and a.Dfechadoc between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaInicial#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaFinal#">

		order by 8,1,3

	</cfquery>	


<cfoutput>

<table width="99%" cellpadding="0" cellspacing="0">
	<tr>
	  <td colspan="3" align="center"><font size="5">#session.enombre#</font></td>
    </tr>
	<tr>
	  <td colspan="3" align="center">Detalle de Movimientos	  </td>
     </tr>
	<tr>
	<td width="50%" align="right"><strong>Fecha Inicial:</strong>#LSDateFormat(form.FechaInicial,'dd/mm/yyyy')#</td>
    <td width="3%" align="left">&nbsp;</td>
    <td width="47%" align="left"><strong> Fecha Final:</strong>#LSDateFormat(form.FechaFinal,'dd/mm/yyyy')# </td>
    </tr>
	<tr>
	  <td colspan="3" align="center">&nbsp; </td>
    </tr>
</table>
<br>

<cfif data.recordcount gt 0 >
	<table width="99%" cellpadding="0" cellspacing="0" align="center">
		<cfset corte = '' >
		<!--- totales por empleado--->
		<cfset vSumDebitos  = 0 >
		<cfset vSumCreditos  = 0 >
	
		<!--- totales generales --->
		<cfset vSumDebitosGeneral  = 0 >
		<cfset vSumCreditosGeneral  = 0 >
		<cfloop query="data">
			<cfif corte neq data.TDcodigo>
				<cfif data.CurrentRow neq 1>
					<tr>
						<td class="topLine"><strong>Total #EtiquetaCorte#</strong></td>
						<td class="topLine" colspan="3" align="right">&nbsp;</td>
						<td class="topLine" align="right"><strong>#LSNumberFormat(vSumDebitos,',9.00')#</strong></td>
						<td class="topLine" align="right"><strong>#LSNumberFormat(vSumCreditos,',9.00')#</strong></td>
					</tr>
					<tr><td colspan="6">&nbsp;</td></tr>
					<tr><td colspan="6">&nbsp;</td>
					</tr>
				</cfif>
				<cfset EtiquetaCorte = data.TDcodigo & ' ' & data.TDdescripcion>
				<tr><td colspan="6"><strong><font size="2">Tipo de Deducci&oacute;n:&nbsp;#EtiquetaCorte#</font></strong></td></tr>
				<tr>
				<td colspan="6">&nbsp;</td></tr>
	
				<tr class="tituloListas">
					<td><strong>Documento</strong></td>
					<td><strong>Identificaci&oacute;n</strong></td>
					<td><strong>Empleado</strong></td>
					<td><strong>Fecha Doc </strong></td>
					<td align="right"><strong>Monto D&eacute;bito</strong></td>
					<td align="right"><strong>Monto Cr&eacute;dito</strong></td>
				</tr>
				<cfset vSumDebitos  = 0 >
				<cfset vSumCreditos  = 0 >
			</cfif>
	
			<!--- totales por empleado --->
			<cfif data.Tipo EQ 0>
				<cfset vSumDebitos = vSumDebitos + data.MontoMov>
			<cfelse>
				<cfset vSumCreditos = vSumCreditos + data.MontoMov>
			</cfif>

			<tr class="<cfif data.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>" >
				<td nowrap>#data.Dreferencia#</td>
				<td nowrap>#data.DEidentificacion#</td>
				<td nowrap>#data.DEnombre#</td>
				<td>#LSDateFormat(data.FechaTrans,'dd/mm/yyyy')#</td>
				<td align="right" nowrap>
					<cfif data.Tipo EQ 0>
						#LSNumberFormat(data.MontoMov,',9.00')#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td align="right" nowrap>
					<cfif data.Tipo EQ 1>
						#LSNumberFormat(data.MontoMov,',9.00')#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			</tr>
			<cfset corte = data.TDcodigo >
	
			<!--- totales generales --->
			<cfif data.Tipo EQ 0>
				<cfset vSumDebitosGeneral  = vSumDebitosGeneral + data.MontoMov>
			<cfelse>
				<cfset vSumCreditosGeneral  = vSumCreditosGeneral + data.MontoMov>
			</cfif>
		</cfloop>
		
		<!--- pinta el ultimo total --->
		<tr>
			<td class="topLine"><strong>Total #EtiquetaCorte#</strong></td>
			<td class="topLine" colspan="3" align="right" nowrap>&nbsp;</td>
				<td align="right" class="topLine" nowrap>
					#LSNumberFormat(vSumDebitos,',9.00')#
				</td>
				<td align="right" class="topLine" nowrap>
					#LSNumberFormat(vSumCreditos,',9.00')#
				</td>
		</tr>
		
		<!--- Total general --->
		<tr><td colspan="6">&nbsp;</td></tr>
		<tr><td colspan="6">&nbsp;</td></tr>
		<tr>
			<td class="topLine"><strong>Totales generales</strong></td>
			<td class="topLine" colspan="3" align="right">&nbsp;</td>
			<td class="topLine" align="right">
				<strong>#LSNumberFormat(vSumDebitosGeneral,',9.00')#</strong>
			</td>
			<td class="topLine" align="right">
				<strong>#LSNumberFormat(vSumCreditosGeneral,',9.00')#</strong>
			</td>
		</tr>
		
		<tr><td colspan="6">&nbsp;</td></tr>
		<tr><td colspan="6" align="center">------------ Fin del Reporte ------------</td></tr>
	</table>
<cfelse>
	<table width="99%" align="center" cellpadding="0" cellspacing="0">
		<tr><td align="center"><strong><font size="2">No se encontraron registros</font></strong></td></tr>
	</table>
</cfif>
</cfoutput>
