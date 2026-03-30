<cf_htmlReportsHeaders 
	irA="Reporte_Requisiciones.cfm"
	FileName="Reporte_Requisiciones.xls"
	title="Reporte Requisiciones"
	download="no"
	preview="no"
	Back="no"
	close="yes"
	>

<cfset Fecha=LSDateFormat(now(),'dd/mm/yyyy')>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery datasource="#session.DSN#" name="rsForm">
    select a.EAid, a.EAdescripcion, a.Aid, rtrim(a.EAdocumento) as EAdocumento, a.EAfecha, a.EAusuario, a.ts_rversion,
    b.Bdescripcion,c.Acodigo, c.Adescripcion,d.DAcantidad, d.DAcosto, d.DAtipo 
    from EAjustes a 
    	inner join Almacen b 
        	on a.Aid = b.Aid 
            and b.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
        inner join DAjustes d
        	on d.EAid = a.EAid
        inner join Articulos c 
        	on c.Aid = d.Aid       
    where a.EAid = <cfqueryparam value="#url.EAid#" cfsqltype="cf_sql_numeric">
    order by   DAtipo asc
</cfquery>
<cfif rsForm.recordcount eq 0>
    <cflocation url="Ajustes-lista.cfm">
</cfif>

<cfset contador = 1>
<cfset MaxLineasReporte = 43>
<cfset LvarUnaVez = true>
<table width="100%" cellpadding="0" cellspacing="1" border="0">	
<cfloop query="rsForm">
	<cfoutput>
        <cfif contador eq 1>
        <tr align="center">
            <td style="font-size:24px" class="tituloListas" colspan="7"><strong>Ajustes de inventario</strong></td>
        </tr>
        <tr align="center">
            <td colspan="7">&nbsp;</td>
        </tr>
        <tr align="center">
            <td align="center" style="font-size:14px" colspan="7"class="tituloListas"><strong>Descripci&oacute;n del Ajuste:</strong> &nbsp; #rsForm.EAdescripcion#</td>
        </tr>
        <tr align="center">
            <td align="center" style="font-size:14px" colspan="7" class="tituloListas"><strong>N° de Documento:</strong> &nbsp; #rsForm.EAdocumento#</td>
        </tr>
        <tr align="center">
            <td align="center" style="font-size:14px" colspan="7" class="tituloListas"><strong>Almac&eacute;n:</strong> &nbsp; #rsForm.Bdescripcion#</td>
        </tr>
        <tr align="center">
            <td align="center" style="font-size:14px" colspan="7" class="tituloListas"><strong>Fecha del Ajuste:</strong> &nbsp; #DateFormat(rsForm.EAfecha, "DD-MM-YYYY")#				        </td>
        </tr>
            <tr>
                <td class="tituloAlterno"></td>
            </tr>		
            <tr>
                <td style="font-size:20px" nowrap="nowrap" colspan="7" align="center"><strong>Detalle de Artículos</strong></td>
            </tr>
            <tr>
                <td nowrap="nowrap" colspan="7" align="center"><hr /></td>
            </tr>			
            <tr nowrap="nowrap" align="center" class="tituloListas">
                <td align="left" nowrap="nowrap"><strong>Artículo Código</strong></td>
                <td colspan="4" align="left" nowrap="nowrap"><strong>    Descripción del Artículo</strong></td>
                <td align="right" nowrap="nowrap"><strong>Cantidad</strong></td>
                <td align="right" nowrap="nowrap"><strong>Costo</strong></td>	
            </tr>    
            <tr>
                <td style="font-size:18px"> <strong>Entradas</strong></td>
                <td nowrap="nowrap" colspan="6" align="center">&nbsp;</td>    
            </tr>
    </cfif>
    </cfoutput>						
		
	<cfoutput>		
        <cfif #rsForm.DAtipo# eq 1 and #LvarUnaVez#>
			<tr>
            	<td style="font-size:18px"> <strong>Salidas</strong></td>
            	<td nowrap="nowrap" colspan="6" align="center">&nbsp;</td>    
			</tr>
            <cfset LvarUnaVez=false>
        </cfif>
        
		<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
		  <td style="font-size:14px" align="left">#rsForm.Acodigo#</td>
			<td colspan="4" style="font-size:14px" align="left" nowrap="nowrap">#rsForm.Adescripcion#</td>
			<td style="font-size:14px" align="right">#rsForm.DAcantidad#&nbsp;&nbsp;</td>
            <td style="font-size:14px" align="right">#rsForm.DAcosto#&nbsp;&nbsp;</td>
		</tr>
		<cfset contador = contador + 1>
		
		<cfif contador eq MaxLineasReporte>
			<tr>
				<td>
					<p style="page-break-before: always">		
					<cfset contador = 1>		
				</td>
			</tr>
		</cfif>		
	
	</cfoutput>
</cfloop>

		<tr><td align="center" colspan="7">***Fin de Linea***</td></tr>
		<tr>
			<td nowrap="nowrap" colspan="7" align="center">&nbsp;</td>
		</tr>			
		<tr>
			<td nowrap="nowrap" colspan="7" align="center">&nbsp;</td>
		</tr>			
		<tr>
			<td nowrap="nowrap" colspan="7" align="center">&nbsp;</td>
		</tr>			
		<!---<tr>
			<td nowrap="nowrap"  colspan="2" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;________________________________</td>
			<td width="7%">&nbsp;</td>
			<td width="23%"  align="left" nowrap="nowrap">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;________________________________</td>

		</tr>
		<tr>
			<td nowrap="nowrap"  align="left" colspan="2"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Despachado por</strong></td>
			<td>&nbsp;</td>
			<td nowrap="nowrap"  align="left"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recibido Conforme</strong></td>
		</tr>--->
</table>