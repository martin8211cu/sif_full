<cfif isdefined("url.PPpagado") and not isdefined("form.PPpagado")>
	<cfset form.PPpagado = url.PPpagado >
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

<!----------------------------------IMPRIME REPORTE-------------------------------------->
<cfset parametros = ''>
<cf_rhimprime datos="/sif/ccrh/consultas/PagosRealizados-form.cfm" paramsuri="&FechaInicial=#LSDateFormat(form.FechaInicial,'dd/mm/yyyy')#&FechaFinal=#LSDateFormat(form.FechaFinal,'dd/mm/yyyy')#&PPpagado=#form.PPpagado##parametros#">
<!-------------------------------------------------------------------------------------->

<cfif isdefined("url.totaliza") and not isdefined("form.totaliza")>
	<cfset form.totaliza = url.totaliza >
</cfif>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsUsuario" datasource="#session.DSN#">
		select distinct b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2  as nombre 
		from Usuario a 	   
		
			inner join DatosPersonales b
			on b.datos_personales = a.datos_personales 
		
		where a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#"/>
	</cfquery>
	
	 <cfquery name="data" datasource="#session.DSN#">
		select 
			d.DEidentificacion,
			d.DEapellido1 #_Cat# '  ' #_Cat# d.DEapellido2 #_Cat#  ' , '  #_Cat# d.DEnombre as nombre,
			e.TDid,
			e.TDdescripcion,
			a.PPfecha_pago,
			a.PPnumero,
			a.PPdocumento,
			
			case a.PPpagado
			when 0 then 'Sin tipo'
			when 1 then 'Ordinario'
			when 2 then 'Extra-Ordinario' end
			as PPpagado,
			
			f.EPEdocumento documento,
			a.PPpagoprincipal + a.PPpagointeres as monto
			
		from DeduccionesEmpleadoPlan a
			  
			inner join  DeduccionesEmpleado c
				on a.Did = c.Did
			  
			inner join DatosEmpleado d
				on c.DEid = d.DEid
			  
			inner join TDeduccion e
				on   e.TDid = c.TDid
				and e.Ecodigo = c.Ecodigo
				
			left outer join EPagosExtraordinarios f
				on  f.Did = a.Did
				and f.PPnumero = a.PPnumero
			
		where 
			a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"/>
			
			<!--- filtro por tipo de pago --->
			<cfif isdefined("form.PPpagado") and len(trim(form.PPpagado))>
			and a.PPpagado = <cfqueryparam  cfsqltype="cf_sql_integer" value="#form.PPpagado#"/>
			</cfif>
			
			<!--- filtro por fechas --->
			 <cfif (isdefined("form.FechaInicial") and len(trim(#form.FechaInicial#))NEQ 0) and (isdefined("form.FechaFinal") and len(trim(#form.FechaFinal#))NEQ 0)>
				and a.PPfecha_pago between <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#form.FechaInicial#"/>
				 						and <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#DateAdd('s',-1,DateAdd('d',1,form.FechaFinal))#"/>
			<cfelse>
				
				<cfif isdefined("form.FechaInicial") and len(trim(#form.FechaInicial#))NEQ 0>
					and a.PPfecha_pago >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#form.FechaInicial#"/>
				</cfif>
				
				<cfif isdefined("form.FechaFinal") and len(trim(#form.FechaFinal#))NEQ 0>
					and a.PPfecha_pago <= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#DateAdd('s',-1,DateAdd('d',1,form.FechaFinal))#"/>
				</cfif> 
		    </cfif> 
		
		order by a.PPpagado, e.TDdescripcion, d.DEapellido1 #_Cat# d.DEapellido2 , a.PPfecha_pago
	</cfquery>

<cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
	  <td colspan="3" align="center"><font size="5">#session.enombre#</font></td>
    </tr>
	<tr>
	  <td colspan="3" align="center">Detalle Pagos</td>
     </tr>
	<tr>
	<td  align="right"><strong>Fecha Inicial:</strong>#LSDateFormat(form.FechaInicial,'dd/mm/yyyy')#</td>
    <td  align="left">&nbsp;</td>
    <td  align="left"><strong> Fecha Final:</strong>#LSDateFormat(form.FechaFinal,'dd/mm/yyyy')# </td>
    </tr>
	
	<tr>
	<td colspan="3" align="center"><strong>Usuario:</strong>#rsUsuario.nombre#</td>
    </tr>
	
	<tr>
	<td colspan="3" align="center">
			
			<cfset tipo="">
			
			<cfif isdefined("form.PPpagado") and len(trim(form.PPpagado))>
				<cfif #form.PPpagado# EQ 1>	
					<cfset tipo="Ordinario">	
				<cfelse>
					<cfset tipo="Extra-Ordinario">
				</cfif>
			<cfelse>
				<cfset tipo="Todos">
			</cfif>
			
			<strong> Tipo:</strong>#tipo#
	</td>
    </tr>
	
	<tr>
	  <td colspan="3" align="center">&nbsp; </td>
    </tr>
</table>
<br>

<cfif data.recordcount gt 0 >
	<table  width="99%"cellpadding="0" cellspacing="0" align="center">
		
		<cfset corte ="">
		<cfset anterior =data.TDid>
		
		<!--- totales --->
		<cfset SumTipo  = 0>
		<cfset SumTipoD  = 0>
		<cfset SumTotal  = 0>
		
		<tr class="tituloListas">
			
			<td  align="left" class="topLine"><strong>Tipo:</strong></td>
			
			<td  align="left" class="topLine"><strong>Identificación</strong></td>
				
			<td  align="left"class="topLine"><strong>Empleado</strong></td>
			
			<td  align="left" class="topLine"><strong>Deducción</strong></td>
			
			<td  align="left" class="topLine"><strong>Referencia</strong></td>
			
			<td  align="left" class="topLine"><strong>Fecha del Pago</strong></td>
			
			<td  align="center" class="topLine"><strong>Cuota</strong></td>
			
			<td   align="right" class="topLine"><strong>Monto</strong></td>
			
		</tr>
		<tr>
						
			<td class="topLine">#data.PPpagado#</td>
			<td  colspan="7"class="topLine">&nbsp;</td>
					
		</tr>
		
		<cfloop query="data">
		
			
			<cfif anterior neq data.TDid>
							
				<tr>
						<td class="topLine">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						
						<td colspan="5" class="topLine"><strong>Sub Total</strong></td>
						
						<td class="topLine" align="right">&nbsp;</td>
						
						<td class="topLine" align="right"><strong>#LSNumberFormat(SumTipoD,',9.00')#</strong></td>
					
					</tr>
					<tr>
						<td  colspan="8" class="topLine">&nbsp;</td>
					</tr>
					
				<cfset SumTipoD = 0>
				
				</cfif>
			<cfset anterior = data.TDid>
					
		
			
			<cfif corte neq data.PPpagado>
				
				<cfif data.CurrentRow neq 1> <!--- Dibuja un corte --->
					
					<tr>
						<td class="topLine">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						
						<td colspan="5" class="topLine"><strong>Total</strong></td>
						
						<td class="topLine" align="right">&nbsp;</td>
						
						<td class="topLine" align="right"><strong>#LSNumberFormat(SumTipo,',9.00')#</strong></td>
					
					</tr>
					
					<tr>
							
							<td class="topLine">#data.PPpagado#</td>
							<td  colspan="7"class="topLine">&nbsp;</td>
						
					</tr>
				</cfif>
				
				
				
				<cfset SumTotal = #SumTotal# + #SumTipo#>
					
				<cfset SumTipo = 0>
				
				<cfset corte = data.PPpagado>
				
				
			</cfif>
				
						
			<tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				
				<td align="left">#data.DEidentificacion#</td>
				
				<td align="left">#data.nombre#</td>
				
				<td align="left">#data.TDdescripcion#</td>
				
				<td align="left">
					<cfif #data.documento# neq ""> #data.documento#
					<cfelse>#data.PPdocumento#
					</cfif>
				</td>
				
				<td align="left">#LSDateFormat(data.PPfecha_pago,'dd-mm-yyyy')#</td>
				
				<td align="center">#data.PPnumero#</td>
				
				<td  align="right">#LSNumberFormat(data.monto,',9.00')#</td>
				
			</tr>
			
			<cfset SumTipo = #SumTipo# + #data.monto#>
			<cfset SumTipoD = #SumTipoD# + #data.monto#>
			
			
		</cfloop>
		
		<cfset SumTotal = #SumTotal# + #SumTipo#>
		<tr>
						<td class="topLine">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						
						<td colspan="5" class="topLine"><strong>Sub Total</strong></td>
						
						<td class="topLine" align="right">&nbsp;</td>
						
						<td class="topLine" align="right"><strong>#LSNumberFormat(SumTipoD,',9.00')#</strong></td>
					
					</tr>
					<tr>
						<td  colspan="8" class="topLine">&nbsp;</td>
		</tr>
		<tr>
				<td class="topLine">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				
				<td colspan="5" class="topLine"><strong>Total</strong></td>
				
				<td class="topLine" align="right">&nbsp;</td>
				
				<td class="topLine" align="right"><strong>#LSNumberFormat(SumTipo,',9.00')#</strong></td>
					
		</tr>

		<cfif isdefined("form.PPpagado")>
			<cfif #form.PPpagado# EQ "">
			<tr>
				
				<td colspan="6" class="topLine"><strong>Total</strong></td>
				
				<td class="topLine" align="right">&nbsp;</td>
				
				<td class="topLine" align="right"><strong>#LSNumberFormat(SumTotal,',9.00')#</strong></td>
			
			</tr>
			</cfif>
		</cfif>
	</table>
	
<cfelse>
	<table width="99%" align="center" cellpadding="0" cellspacing="0">
		<tr><td align="center"><strong><font size="2">No se encontraron registros</font></strong></td></tr>
	</table>
</cfif>
</cfoutput>

