<cf_htmlReportsHeaders 
	irA="MovInterAlmacen.cfm"
	FileName="ReporteMovInterAlmacen.xls"
	title="Reporte Movimientos InterAlmacén"
	download="no"
	preview="no"
	Back="no"
	close="yes"
	>
<cf_navegacion name="EMid">
<cfset Fecha=LSDateFormat(now(),'dd/mm/yyyy')>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery datasource="#session.DSN#" name="rsRequiE">
    select er.EMdoc, er.EMfecha, aO.Almcodigo #_Cat# '-' #_Cat# aO.Bdescripcion as almacenO, aD.Almcodigo #_Cat# '-' #_Cat# aD.Bdescripcion as almacenD
    from EMinteralmacen er
    	inner join Almacen aO
        	on aO.Aid = er.EMalm_Orig
        inner join Almacen aD
        	on aD.Aid = er.EMalm_Dest
    where er.EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
</cfquery>

<cfquery name="rsRequiD" datasource="#session.DSN#">
    select d.DMcant, a.Acodigo #_Cat# '-' #_Cat# a.Adescripcion as Descripcion
    from DMinteralmacen d
    	inner join Articulos a
      		on a.Aid = d.DMAid 
    where d.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EMid#">
    order by a.Adescripcion, d.DMcant
</cfquery>

<cfset contador = 1>
<cfset MaxLineasReporte = 20>
<cfoutput>
<table width="100%" cellpadding="0" cellspacing="1" border="0">	
	<tr align="center"><td width="28%">&nbsp;</td></tr>
	<tr align="center">
		<td style="font-size:24px" class="tituloListas" colspan="7"><strong>Movimientos InterAlmac&eacute;n</strong></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr align="center"><td>&nbsp;</td></tr>
	<tr align="left">
		<td style="font-size:14px" colspan="7" class="tituloListas"><strong>Documento:</strong>&nbsp;#rsRequiE.EMdoc#</td>
	</tr>	
	<tr align="left">
		<td style="font-size:14px" colspan="7" class="tituloListas"><strong>Fecha:</strong>&nbsp;#DateFormat(rsRequiE.EMfecha, "DD/MM/YYYY")#</td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="7" class="tituloListas"><strong>Almacen Inicial:</strong>&nbsp;#rsRequiE.almacenO#</td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="7"class="tituloListas"><strong>Almacen Final:</strong> &nbsp;#rsRequiE.almacenD#</td>
	</tr>
    <tr>
        <td class="tituloAlterno"></td>
    </tr>		
    <tr>
        <td style="font-size:20px" nowrap="nowrap" colspan="7" align="center"><strong>Art&iacute;culos</strong></td>
    </tr>
    <tr>
        <td nowrap="nowrap" colspan="7" align="center"><hr /></td>
    </tr>			
    <tr nowrap="nowrap" align="center" class="tituloListas">
        <td width="70%" align="left" nowrap="nowrap"><strong>Descripci&oacute;n del Art&iacute;culo</strong></td>
        <td width="30%" align="left" nowrap="nowrap"><strong>Cantidad</strong></td>
    <tr><td colspan="2">&nbsp;</td></tr>
    <cfloop query="rsRequiD">
		<tr class="<cfif rsRequiD.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
		 	 <td style="font-size:14px" width="70%" align="left">#rsRequiD.Descripcion#</td>
			<td style="font-size:14px" width="30%" align="left" nowrap="nowrap">#LsnumberFormat(rsRequiD.DMcant,'9.99')#</td>
		</tr>
        <cfset contador = contador + 1>
        <cfif contador eq MaxLineasReporte>
        	<tr><td><p style="page-break-before: always"></td></tr>
        	<cfset contador = 1>
        </cfif>	
   	</cfloop>
    <tr><td align="center" colspan="2">&nbsp;</td></tr>
	<tr><td align="center" colspan="2">------- Fin de Linea --------</td></tr>
</table>
</cfoutput>
