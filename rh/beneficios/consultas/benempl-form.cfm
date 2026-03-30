<cfif isdefined('url.Bid') and not isdefined('form.Bid')>
	<cfset form.Bid = url.Bid>
</cfif>
<cfquery name="rsBenEmpl" datasource="#session.DSN#">
	Select
		be.Bid,
		Bcodigo,
		Bdescripcion,
		be.DEid,(DEnombre + ' ' + DEapellido1 + ' ' + DEapellido2) as nombreEmpl,
		de.DEidentificacion, 
		BEfdesde,
		BEfhasta,
		BEmonto,
		BEporcemp,
		(BEmonto * BEporcemp / 100.0) as MontoEmp
		
	from RHBeneficiosEmpleado be
		inner join RHBeneficios b
			on b.Ecodigo=be.Ecodigo
				and b.Bid=be.Bid
		
		inner join DatosEmpleado de
			on de.Ecodigo=b.Ecodigo
				and de.DEid=be.DEid
			
	where be.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined('form.Bid') and form.Bid NEQ ''>		
			and be.Bid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">	
		</cfif>
		and BEactivo=1
	order by Bid
</cfquery>
	
<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	font-size: 16px;
}
-->
</style>

<cfset bene = "">
<cfset HoraReporte = Now()>
<cfset cuRew = 0>
<cfset numPag = 0>
<cfset maxLin = 35><!--- Maxima cantidad de lineas por pagina en la impresion --->

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr class="areaFiltro">
    <td colspan="5" align="center"><strong><font size="3"><cfoutput>#Session.Enombre#</cfoutput></font></strong></td>
  </tr>
  <tr>
    <td colspan="5" align="center">&nbsp;</td>
  </tr>    
  <tr>
    <td colspan="5" align="center"><span class="style1">Empleados por Beneficio</span></td>
  </tr>
  <tr>
    <td colspan="5" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
  </tr> 
  <tr>
    <td colspan="5" align="center">&nbsp;</td>
  </tr>   
  <tr>
    <td colspan="5" align="center">&nbsp;</td>
  </tr>
  <tr bgcolor="#CBDCDE">
  	<td style="border-bottom: 1px solid gray;"><strong>C&eacute;dula</strong></td>
    <td style="border-bottom: 1px solid gray;"><strong>Nombre</strong></td>
    <td style="border-bottom: 1px solid gray;"><strong>Fecha Desde</strong></td>
    <td style="border-bottom: 1px solid gray;"><strong>Fecha Hasta </strong></td>
    <td style="border-bottom: 1px solid gray;"><strong>Monto Total del Beneficio</strong></td>
    <td style="border-bottom: 1px solid gray;"><strong>Monto Empleado</strong></td>
<!---<td style="border-bottom: 1px solid gray;"><strong>% Empleado</strong></td>--->
  </tr>
  <tr>
    <td colspan="5" align="center">&nbsp;</td>
  </tr>  
	<cfif isdefined('rsBenEmpl') and rsBenEmpl.recordCount GT 0>
		<cfset bene = "">
		<cfoutput query="rsBenEmpl">
			<cfset cuRew = CurrentRow>
			<cfset LvarListaNon = (CurrentRow MOD 2)>
			<cfif bene NEQ Bid>
				<tr bgcolor="##E5E5E5">
					<td colspan="5" style="border-bottom: 1px solid gray;"><strong>#Bcodigo# - #Bdescripcion#</strong></td>
			  </tr>
				
				<cfset bene = Bid>
			</cfif>
 			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				<td>#DEidentificacion#</td>
				<td>#nombreEmpl#</td>
				<td><cfif len(trim(BEfdesde))>#LSDateFormat(BEfdesde, "dd/mm/yyyy")#<cfelse>&nbsp;</cfif></td>
				<td><cfif len(trim(BEfhasta))>#LSDateFormat(BEfhasta, "dd/mm/yyyy")#<cfelse>&nbsp;</cfif></td>
				<td align="left">#LSNumberFormat(BEmonto, ',9.00')#</td>
				<td align="left">#LSNumberFormat(MontoEmp, ',9.00')#</td>
			<!---	<td align="left">#LSNumberFormat(BEporcemp)#</td>--->
			</tr>	
			<cfif isdefined('Url.imprimir') and cuRew mod maxLin EQ 0 and cuRew NEQ 1>
				<cfset numPag = numPag + 1>
				<!--- Numeracion de paginacion --->			
				  <tr>
					<td colspan="5" align="center">&nbsp;</td>
				  </tr>	
				  <tr>
					<td colspan="5" align="right"><strong>P&aacute;gina: #numPag#</strong></td>
				  </tr> 
				  <tr>
					<td colspan="5" class="pageEnd" align="center">&nbsp;</td>
				  </tr>					   
				   
					<!--- Encabezado --->				  
				  <tr>
					<td colspan="5" align="center">&nbsp;</td>
				  </tr>							
				  <tr class="areaFiltro">
					<td colspan="5" align="center"><strong><font size="3">#Session.Enombre#</font></strong></td>
				  </tr>
				  <tr>
					<td colspan="5" align="center">&nbsp;</td>
				  </tr>    
				  <tr>
					<td colspan="5" align="center"><span class="style1">Empleados por Beneficio</span></td>
				  </tr>
				  <tr>
					<td colspan="5" align="center"><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></td>
				  </tr> 
				  <tr>
					<td colspan="5" align="center">&nbsp;</td>
				  </tr>   
				  <tr>
					<td colspan="5" align="center">&nbsp;</td>
				  </tr>			
			</cfif>
		</cfoutput>
	<cfif isdefined('Url.imprimir')>
		<cfset numPag = numPag + 1>
	  <tr>
		<td colspan="5" align="center">&nbsp;</td>
	  </tr>						
	  <tr>
		<td colspan="5" align="right"><cfoutput><strong>P&aacute;gina: #numPag#</strong></cfoutput></td>
	  </tr>		
	  <tr>
		<td colspan="5" align="center">&nbsp;</td>
	  </tr>						  
	  <tr>
		<td colspan="5" align="center"><strong>------------------------ Ultima P&aacute;gina ------------------------</strong></td>
	  </tr>				
	  <tr>
		<td colspan="5" align="center">&nbsp;</td>
	  </tr>					    
	</cfif>
</cfif>	
</table>


