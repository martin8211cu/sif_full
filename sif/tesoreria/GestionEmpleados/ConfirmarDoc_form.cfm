<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<form action="ConfirmarDoc_sql.cfm" name="form1" method="post" >
<cfif isdefined('url.GELid') and not isdefined ('form.GELid')>
	<!---<cfset form.GELid=#url.GELid#>--->
		<cfset modo = 'CAMBIO'>
</cfif>
<cfif isdefined ('url.Mensaje')>
	<script lenguage="javascript">
		alert('No se puede Confirmar la liquidación porque existen gastos que aún no han sido aplicados.');
	</script>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined('form.GELid')>
  <!--- <cfset llave=#form.GELid#>--->
<cfset modo = 'CAMBIO'>
		<cfquery datasource="#session.dsn#" name="encabezado">
			<!---select ant.CFid,ant.GELnumero,ant.GELfecha,ant.ts_rversion,ant.GELreembolso,
				( select rtrim(cf.CFcodigo) #LvarCNCT# '-' #LvarCNCT# cf.CFdescripcion
					from CFuncional cf 
					where cf.CFid = ant.CFid
				) as CentroFuncional,
				
				(select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2
					from DatosEmpleado Em,TESbeneficiario te
					where ant.TESBid=te.TESBid and   Em.DEid=te.DEid  
				) as Empleado,	
						
				(select Mo.Mnombre
					from Monedas Mo
					where ant.Mcodigo=Mo.Mcodigo
				)as Moneda,													
				ant.GELtotalGastos,
				ant.GELtipoCambio,
				ant.GELtotalAnticipos,
				ant.GELtotalDepositos,
				ant.GELdescripcion,ant.GELmsgRechazo, ant.GELtotalGastos,ant.TESid		
			from GEliquidacion ant 				
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" >--->
	</cfquery>
</cfif>

<!---Total Anticipos --->
<cfquery name="totalAntic" datasource="#session.dsn#">
	select coalesce(sum(GELAtotal),0) as totalAnticipos 
	from GEliquidacionAnts 
	where GELid=1
</cfquery>

<cfoutput>
<input type="hidden" name="GELid" value="#llave#">
	<table align="center" summary="Tabla de entrada"  width="90%" border="0">
		<tr>
			<td valign="top" align="right" width="162" nowrap="nowrap"><strong>N&uacute;m. Liquidaci&oacute;n:&nbsp;</strong></td>
			<td width="224" valign="top"></td>						
			<td width="177" align="right" valign="top"><strong>Fecha Liquidaci&oacute;n:&nbsp;</strong></td>
			<td width="317" valign="top"></td>
		</tr>
		<tr>
			<td align="right"><strong>Centro&nbsp;Funcional:&nbsp;</strong></td>
			<td colspan="1"></td>
		</tr>								
		<tr>
		  <td valign="top" align="right"></td>
		  <td valign="top"></td>
		  <td rowspan="6" valign="top" align="right" nowrap>
		   
		    <p><strong>Descripci&oacute;n:</strong> </p>			</td>
		  <td rowspan="6" valign="top" align="left">
		    <textarea name="CCHDdescripcion" onkeypress="return false;" cols="50" rows="4" MAXLENGTH=20></textarea>		    
		 </td>
   		</tr>
		<tr>
			<td align="right" nowrap="nowrap"> <strong>Empleado Liquidante:&nbsp;</strong></td>
			<td width="224" valign="top" nowrap="nowrap"></td>
		</tr>		
		<tr>
			<td valign="top" align="right"><strong>Moneda:&nbsp;</strong></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>Tipo de Cambio:</strong></td>
			<td valign="top"></td>
		</tr>
		<tr>
		  <td>
		  <td colspan="3">		  
		  </td>
		</tr>
				<tr>
		  <td valign="top" align="right"><div align="right"><strong>Caja:</strong></div></td>
		  <td valign="top"><font color="FF0000"></font></td>
		  <td valign="top" align="right" nowrap>&nbsp;</td>
		  <td valign="top">&nbsp;</td>
		</tr>
		
		<tr>
			<td valign="top" align="right" width="162" nowrap="nowrap"><strong>Días Hábiles:</strong></td>
			<td width="224" valign="top"></td>						
			<td width="177" align="right" valign="top"><strong>Solicitante;</strong></td>
			<td width="317" valign="top"></td>
		</tr>
		
		<tr>
			<td valign="top" align="right" width="162" nowrap="nowrap"><strong></strong></td>
			<td width="224" valign="top"></td>						
			<td width="177" align="right" valign="top"><strong>Autorizador:</strong></td>
			<td width="317" valign="top"></td>
		</tr>
		
		<tr>
		  <td valign="top" align="right">&nbsp;</td>
		  <td valign="top">&nbsp;</td>
		  <td valign="top" align="right" nowrap><strong>Total Anticipos:&nbsp;</strong></td>
		  <td valign="top">
		  
<!---Monto en Anticipos--->
			
			</td>
    	</tr>
		<tr>
			<td valign="top" align="right">&nbsp;</td>
		 	<td valign="top">&nbsp;</td>
			<td valign="top" align="right" nowrap><strong>Total de Gastos :&nbsp;</strong></td>
			<td valign="top">
<!---Monto en Doc Liquidantes--->
			</td>
   		</tr>
		<tr>
			<td valign="top" align="right" width="162"><strong></strong></td>
			<td width="224" valign="top"></td>					
			<td valign="top" align="right" nowrap><strong>Total Devoluciones:</strong></td>
			<td valign="top">
<!---Monto en Devoluciones   ********CAMBIAR******* --->
		</td>
    	</tr>
		<tr>
			<td valign="top" align="right" width="162"><strong></strong></td>
			<td width="224" valign="top"></td>					
			<td valign="top" align="right" nowrap>
		   <!---Rembolso--->
		    <strong>Reembolso:</strong></td>
		    <td valign="top">
		</tr>
		<tr>
		   </td>
		</tr>
	</table>
  </form>
 </cfoutput>

	<cf_web_portlet_end>
	</td>
  </tr>
</table>
	

