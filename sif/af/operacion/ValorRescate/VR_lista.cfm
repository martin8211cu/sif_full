<cfset LvarHoy = createODBCdate(now())>
<cfset LvarHaceUnMes = dateadd("d",-7, LvarHoy)>
							
<cf_navegacion name="AFTRid" 				session default="">
<cf_navegacion name="AFTRdescripcion_2"		session default="">
<cf_navegacion name="AFTRfecha_I" 			session value="">
<cf_navegacion name="AFTRfecha_F" 			session default="">



	<cfif isdefined("form.cboCFid")>
		<cfset form.AFTRid = form.cboCFid>
	</cfif>
	<cfset form.cboCFid = form.AFTRid>
		
	<cfif isdefined("form.AFTRdescripcion")>	
		<cfset form.AFTRdescripcion_2 = form.AFTRdescripcion>
	</cfif>
	<cfset form.AFTRdescripcion = form.AFTRdescripcion_2>
	
	
	
<table width="100%" border="0" cellspacing="6">
		<tr>
			<td width="50%" valign="top">
			<form name="formFiltro" method="post" action="ValorRescate.cfm"  style="margin: '0' ">
			<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr>
		
<!-----------------Descripcion--->
			<td width="10%" align="left" nowrap><strong><cfoutput>Descripción:</cfoutput></strong></td>
			<td width="90%" nowrap>
				<input type="text" name="desc" />
		  </td>	
		  						
		</tr>
		
<!-------------------FILTRO DE FECHA--->				
<tr>
			<td nowrap align="left"><strong>Fecha:</strong></td>
			<td colspan="1">
				<table cellpadding="0" cellspacing="0" border="0">
					  <tr>
						<td nowrap valign="middle">
						<cf_sifcalendario form="formFiltro" value="#form.AFTRfecha_I#" name="AFTRfecha_I" tabindex="1">											  					  	</td>
						<td nowrap align="right" valign="middle"><strong>&nbsp;Hasta:</strong></td>
						<td nowrap valign="middle">
						<cf_sifcalendario form="formFiltro" value="#form.AFTRfecha_F#" name="AFTRfecha_F" tabindex="1">									 						</td>
					  </tr>
			  </table>
			</td>
		

<!-----------------FILTRAR--->		
		
			<td ></td>
			<td align="center"><div align="center">
			         <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" />
				 				   
	             </div>
			</td>
		</tr>
		</table>
			<cfinclude template="QuerryVR.cfm">
</table>

<iframe name="ifrDescripcion" id="ifrDescripcion" src="" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" >
</iframe>



