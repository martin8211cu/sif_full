 <cf_htmlreportsheaders
	  title="Vale de Salida de Activo Fijo"
	 <!--- irA="agtProceso_Salida.cfm"--->
      irA="agtProceso_genera_Salida.cfm"
	  filename="Salida-de-ActivosF#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls"
	  back="yes"
	  Download="yes"
	  close="yes"
	  method="url"
	  >

<cfset LvarColSpan = 9>
<cfset cantidad = 0>


<cfset Fecha=LSDateFormat(now(),'dd/mm/yyyy')>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select
		Edescripcion,ts_rversion,
		Ecodigo
	from Empresas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsEnc" datasource="#Session.dsn#">
	select AFESid,TipoMovimiento,Descripcion,Fecha,FechaRegreso,Autoriza,Observaciones,
		ds.AFDdescripcion,ms.AFMSdescripcion, e.contrato
	from AFEntradaSalidaE e
	left join AFMotivosSalida ms
		on ms.AFMSid = e.AFMSid
	left join AFDestinosSalida ds
		on ds.AFDSid = e.AFDSid
	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and AFESid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.AFESid#">
</cfquery>

<cfquery datasource="#session.DSN#" name="rsDatos">
	select c.Aplaca,
    	   c.Adescripcion,
           c.Aserie,
           b.Fecha,
           b.FechaRegreso,
           b.Autoriza
	from AFEntradaSalidaD a
	inner join AFEntradaSalidaE b
		on a.AFESid = b.AFESid and
		a.Ecodigo = b.Ecodigo
	inner join Activos c
    	on a.Aid = c.Aid
        and b.Ecodigo = c.Ecodigo
	where	a.Ecodigo = #session.Ecodigo#
	and a.AFESid = #url.AFESid#
</cfquery>

<!--- <cfquery name="rsADQ" dbtype="query">
	select sum(LTAmontolocadq) as total_adq from rsDatos
 </cfquery>

 <cfquery name="rsMEJ" dbtype="query">
	select sum(LTAmontolocmej) as total_mej from rsDatos
 </cfquery>

 <cfquery name="rsREV" dbtype="query">
	select sum(LTAmontolocrev) as total_rev from rsDatos
 </cfquery>

 <cfquery name="rsTOT" dbtype="query">
	select sum(LTAmontoloctot) as total_tot from rsDatos
 </cfquery>--->


	<cffunction name="fnCantActivos" access="private" output="yes">
		<cfset cantidad = cantidad + 1>
	</cffunction>

<table width="70%" align="center" cellpadding="0" cellspacing="0" border="0">
	<cfoutput>
		<tr align="left">
			<td colspan="5" valign="botton">
			<h2 style="margin:1px">
				<cfif rsEnc.TipoMovimiento EQ "2">
					Vale de Salida de Activo Fijo
				<cfelseif rsEnc.TipoMovimiento EQ "1">
					Formato de Entrada de Activo
				<cfelseif rsEnc.TipoMovimiento EQ "3">
					Vale de Salida de Activo Fijo por Comodato
				<cfelseif rsEnc.TipoMovimiento EQ "4">
					Formato de Entrada de Activo por Comodato
				</cfif>
			</h2>
			<hr>
			</td>
		</tr>
	  <tr align="center">
			<td align="center" colspan="#LvarColSpan#" class="tituloListas">

			</td>
	  </tr>
	<cfif rsEnc.TipoMovimiento EQ "2" or rsEnc.TipoMovimiento EQ "3">
		<tr align="center">
			<td colspan="3" width="80%" align="left">
				<strong>Descripción</strong>
			</td>
			<td width="20%" colspan="2">
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td align="left"><strong>Fecha Salida:</strong></td>
						<td align="right" >#DateFormat(rsEnc.Fecha,"dd/mmm/yyyy")#</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr align="center">
			<td colspan="3"  align="left">
				#rsEnc.Descripcion#
			</td>

			<td width="20%" colspan="2">
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td align="left"><strong>Fecha Regreso:</strong></td>
						<td align="right" >#DateFormat(rsEnc.FechaRegreso,"dd/mmm/yyyy")#</td>
					</tr>
				</table>
			</td>

		</tr>
		<tr align="center">
			<td align="center" colspan="6" class="tituloListas">&nbsp;

			</td>
	  	</tr>
		<tr align="center">
			<td class="tituloListas" colspan="3" align="left">
				<strong>Destino</strong>
			</td>
			<td align="left">
			<cfif rsEnc.TipoMovimiento NEQ "3">
				<strong>Motivo</strong>
			<cfelse>
				<strong>Contrato</strong>
			</cfif>
			</td>
		</tr>

		<tr align="center">
			<td colspan="3" align="left">
				#rsEnc.AFDdescripcion#
			</td>
			<td  colspan="2" align="left" >
		<cfif rsEnc.TipoMovimiento NEQ "3">
				#rsEnc.AFMSdescripcion#
		<cfelse>
				#rsEnc.contrato#
		</cfif>
			</td>
		</tr>
		<tr align="center">
			<td align="center" colspan="5" class="tituloListas">&nbsp;

			</td>
	  	</tr>
	<cfelse>
		<tr align="center">
			<td align="right">
				<strong>Fecha Entrada:#DateFormat(rsEnc.Fecha,"dd/mmm/yyyy")#</strong>
			</td>
		</tr>
	</cfif>

		<tr align="left">
			<td align="left" colspan="6" >
				<strong>Observaciones</strong>
			</td>
	  	</tr>
	  	<tr align="left">
			<td colspan="5">
				<table width="100%" valign="top" height="60px" cellspacing="0" cellpadding="1" border="1" bordercolor="black">
					<tr valign="top">
						<td align="left" valign="top" >#rsEnc.Observaciones#</td>
					</tr>
				</table>
			</td>
	  	</tr>
	  	<tr align="center">
			<td align="center" colspan="5" class="tituloListas">&nbsp;

			</td>
	  	</tr>
	</cfoutput>
	<cfoutput>
	<tr>
		<td colspan="5">
			<table width="100%" cellpadding="0" cellspacing="0" border="1">
				<cfif rsEnc.TipoMovimiento EQ "2">
				<tr align="left">
					<td align="left" colspan="3" class="tituloListas">
						Activos de Salida
					</td>
			  	</tr>
				<cfelse>
				<tr align="left">
					<td align="left" colspan="3" class="tituloListas">
						Activos de Entrada
					</td>
			  	</tr>
				</cfif>
				<tr class="tituloListas">
					<td width="20%"><strong>Placa</strong></td>
					<td width="60%"><strong>Descripci&oacute;n</strong></td>
					<td ><strong>Número Serie</strong></td>
				</tr>
				<cfloop query="rsDatos">
				<tr >
					<td>#rsDatos.APlaca#</td>
					<td>#rsDatos.Adescripcion#</td>
					<td>#rsDatos.Aserie#</td>
				 </tr>
				</cfloop>
			</table>
		</td>
	</tr>
		<tr align="center">
			<td align="center" colspan="5" class="tituloListas">&nbsp;

			</td>
	  	</tr>
        <tr align="center">
			<td align="center" colspan="5" class="tituloListas">&nbsp;
				
			</td>
	  	</tr>
        <tr align="center">
			<td align="center" colspan="5" class="tituloListas">&nbsp;
				
			</td>
	  	</tr>
<cfif #rsEnc.Autoriza# NEQ "" >
	<tr align="center">
    		<td align="center" colspan="5" class="tituloListas">&nbsp;
				Autoriza
			</td>
            
            		<tr align="center">
                        <td align="center" colspan="5" class="tituloListas">&nbsp;
                            
                        </td>
	  				</tr>
                   	<tr align="center">
                        <td align="center" colspan="5" class="tituloListas">&nbsp;
                            
                        </td>
	  				</tr>
           
            		<tr align="center">
                       <td align="center" colspan="5" class="tituloListas">&nbsp;
                           _________________________________________
                        </td>
                    </tr>
            
                    <td align="center" colspan="5" class="tituloListas">&nbsp;
                        <strong>#rsEnc.Autoriza#</strong>
                    </td>
           
		</tr>
</cfif>    
                 
        <tr align="center">
			<td align="center" colspan="5" class="tituloListas">&nbsp;
				
			</td>
	  	</tr>
	</cfoutput>

</table>
