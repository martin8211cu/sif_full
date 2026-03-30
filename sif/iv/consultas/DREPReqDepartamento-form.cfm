<cfquery name="data" datasource="#session.DSN#">
	select a.Aid, b.Acodigo, b.Adescripcion, a.Kunidades*-1 as DRcantidad
	from Kardex a
	 inner join HERequisicion c
	 on a.Ecodigo=c.Ecodigo
	    and a.ERid=c.ERid
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	inner join Articulos b
	on a.Aid = b.Aid
	and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where a.ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERid#">
	order by Acodigo
</cfquery>

<cfquery name="reqData" datasource="#session.DSN#">
	select 	a.ERid, 
			a.ERdescripcion, 
			a.Aid, 
			b.Bdescripcion, 
			b.Almcodigo,
			a.ERdocumento, 
			a.TRcodigo, 
			c.TRdescripcion, 
			a.Dcodigo, 
			d.Ddescripcion, 
			a.ERFecha
	from HERequisicion a
	inner join Almacen b
	    on a.Aid=b.Aid
	inner join TRequisicion c
	    on a.TRcodigo=c.TRcodigo
	   and a.Ecodigo=c.Ecodigo
	inner join Departamentos d
	    on a.Dcodigo=d.Dcodigo
	   and a.Ecodigo=d.Ecodigo
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.ERid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERid#">
	order by a.Dcodigo, a.ERFecha
</cfquery>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 1px;
		padding-bottom: 1px;
	}
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
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>

<table width="98%" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<td colspan="3">
			<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" >
				<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
					<td colspan="4"  valign="middle" align="center"><font size="4"><strong><cfoutput>#session.Enombre#</cfoutput></strong></font></td>
					</strong>
				</tr>
		
				<tr> 
					<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					<td colspan="4" align="center" class="bottomline">
						<font size="3">
							<strong>
								Detalle de Requisici&oacute;n
							</strong>
						</font>
					</td>
					</strong>
				</tr>
			</table>
			</cfoutput>
		</td>	
	</tr>

	<tr>
		<td colspan="3" >
			<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
				<tr>
					<td colspan="3" align="center">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" >
							<tr>
								<td align="left" width="1%" nowrap><font size="2"><strong>Requisici&oacute;n</strong></font>:&nbsp;</td>
								<td colspan="3" ><font size="2">#reqData.ERdescripcion#</font></td>
							</tr>
							<tr>
								<td align="left"><strong><font size="2">Documento</strong>:&nbsp;</td>
								<td><font size="2">#reqData.ERdocumento#</font></td>
								<td align="left" width="1%"><strong><font size="2">Tipo</font></strong>:&nbsp;</td>
								<td><font size="2">#trim(reqData.TRcodigo)#-#reqData.TRdescripcion#</font></td>
							</tr>
							<tr>
								<td align="left"><strong><font size="2">Almac&eacute;n</font></strong>:&nbsp;</td>
								<td><font size="2">#reqData.Bdescripcion#</font></td>
								<td align="left"><strong><font size="2">Fecha</font></strong>:&nbsp;</td>
								<td><font size="2">#LSDateFormat(reqData.ERFecha,'dd/mm/yyyy')#</font></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</cfoutput>
		</td>	
	</tr>

	<tr bgcolor="#B6D0F1">
		<td><strong>Art&iacute;culo </strong></td>
		<td><strong>Descripci&oacute;n</strong></td>
		<td align="right"><strong>Cantidad</strong></td>
		<!---<td align="right"><strong>Costo</strong></td>--->
	</tr>	
	<cfif data.RecordCount gt 0>
		<cfoutput query="data">
			<tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
				<td>#data.Acodigo#</td>
				<td>#data.Adescripcion#</td>
				<td align="right">#LSCurrencyFormat(data.DRcantidad, 'none')#</td>
				<!---<td align="right">#LSCurrencyFormat(data.DRcosto, 'none')#</td>--->
			</tr>
		</cfoutput>
		<tr><td colspan="3" align="center"><strong>------ Fin del Reporte ------</strong></td>
		</tr>
	<cfelse>
		<tr><td colspan="3">--- No se encontraron Registros ---</td></tr>
	</cfif>
</table>

<br>

