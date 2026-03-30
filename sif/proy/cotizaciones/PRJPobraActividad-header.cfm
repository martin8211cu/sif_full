<cfparam name="url.PRJPAid">
<cfparam name="url.PRJPOid">

<cfquery datasource="#session.dsn#" name="hdr">
	select PRJPOid, PRJPOcodigo,PRJPOdescripcion, PRJPOcliente, PRJPOlugar, PRJPOnumero
	from PRJPobra
	where PRJPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJPOid#" null="#Len(url.PRJPOid) is 0#">
</cfquery>

<cfquery datasource="#session.dsn#" name="hdr1">
	select PRJPAid, PRJPAcodigo,PRJPAdescripcion
	from PRJPobraArea
	where PRJPAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJPAid#" null="#Len(url.PRJPAid) is 0#">
</cfquery>

<cfoutput>

		<table width="100%" border="0" cellspacing="0" cellpadding="4" style="border:1px solid black">
		  <tr>
			<td colspan="7" class="subTitulo"><br><a href="PRJPobras.cfm?PRJPOid=#hdr.PRJPOid#&btnatras=1">Regresar a las Obras:</a></td>    
		  </tr>		
		  <tr>
			<td>&nbsp;</td>
			<td><strong>Obra:</strong></td>
			<td>#hdr.PRJPOcodigo#</td>
			<td>&nbsp;</td>
			<td><strong>Lugar: </strong></td>
			<td>#hdr.PRJPOlugar#</td>
			<td>&nbsp;</td><td>&nbsp;</td>
			<!--- 
			<td rowspan="7" align="center">
					
					<form name="form_back" method="get" action="PRJPobraArea.cfm">
						<input type="hidden" name="PRJPAid" value="#hdr1.PRJPAid#">
						<input type="hidden" name="PRJPOid" value="#hdr.PRJPOid#">						
						<input type="submit" name="Submit" value="<< Regresar a Areas">
					</form>					
			</td>
			 --->
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td><strong>Descripci&oacute;n:</strong></td>
			<td>#hdr.PRJPOdescripcion#</td>
			<td>&nbsp;</td>
			<td><strong>Cliente:</strong></td>
			<td>#hdr.PRJPOcliente#</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="7" class="subTitulo"><br><a href="PRJPobraArea.cfm?PRJPAid=#hdr1.PRJPAid#&PRJPOid=#hdr.PRJPOid#&btnatras=1">Regresar a las Areas:</a></td>    
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td><strong>Area:</strong></td>
			<td>#hdr1.PRJPAcodigo#</td>
			<td>&nbsp;</td>
			<td><strong>Descripcion: </strong></td>
			<td>#hdr1.PRJPAdescripcion#</td>
			<td>&nbsp;</td>  
		  </tr>
		</table>
</cfoutput>
