<title>Lista de Activos no agregados</title>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_dbfunction name="now" returnvariable="hoy">
<!---RETIRO DE ACTIVOS--->
<cfif isdefined("URL.adv") and URL.adv eq 1>
	<cfset tabla = "
				AFResponsables a
				inner join Activos c
				   on a.Aid	 = c.Aid
				   and a.Ecodigo = c.Ecodigo
				   and not exists (Select 1 
							from CRCRetiros Ret 
							 where Ret.Ecodigo = c.Ecodigo 
							  and Ret.Aid = c.Aid 
							  and Ret.BMUsucodigo = #Session.Usucodigo#)
				inner join DatosEmpleado  d
				  on a.DEid 	= d.DEid 
				  and a.Ecodigo = d.Ecodigo
				inner join ADTProceso h 
				  on h.Aid = c.Aid
				inner join AFTransacciones i
				  on h.IDtrans = i.IDtrans  
				left outer join CRTipoDocumento e
				  on  a.Ecodigo = e.Ecodigo
				  and a.CRTDid =e.CRTDid
				left outer join CFuncional f
				  on  a.Ecodigo = f.Ecodigo
				  and a.CFid =f.CFid
				left outer join CRCentroCustodia g
				  on  a.Ecodigo = g.Ecodigo
				  and a.CRCCid  = g.CRCCid
				">													
				<cfset filtro = " a.Ecodigo = #Session.Ecodigo# "> 
				<cfif isdefined("url.AplacaINI") and len(trim(url.AplacaINI))>
				    <cfset filtro = filtro &  " and c.Aplaca = #url.AplacaINI#">
				</cfif>
				<cfif isdefined("url.DEid") and len(trim(url.DEid))>
				    <cfset filtro = filtro &  " and a.DEid = #url.DEid#">
				</cfif>	
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
				   <cfset filtro = filtro &  " and a.CFid ="& #url.CFid#>
				</cfif>
				<cfif isdefined("url.CRTDidFT") and len(trim(url.CRTDidFT)) and trim(url.CRTDidFT) NEQ "-1" >
				   <cfset filtro = filtro &  " and a.CRTDid = <cfqueryparam cfsqltype='cf_sql_numeric' value='#url.CRTDidFT#'">					
				</cfif>
				<cfif isdefined("url.CRCCidFT") and len(trim(url.CRCCidFT))>
				   <cfset filtro = filtro &  " and a.CRCCid = #url.CRCCidFT#">
				</cfif>						
				<cfset filtro = filtro &  "  and #hoy# between a.AFRfini and a.AFRffin ">
				<cfset filtro = filtro &  " order by CRCCcodigo,DEidentificacion,Aplaca">
				<cfset sqlerror = "select c.Aplaca, c.Adescripcion, i.AFTdes, d.DEnombre #_Cat# ' ' #_Cat# d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2  as usuario from #tabla# where #filtro#">
				
			<cfquery name="rsActivoNoAgregados" datasource="#Session.Dsn#">
				  #preservesinglequotes(sqlerror)#
			</cfquery>	
<!---TRASLADO DE ACTIVOS--->
<cfelseif isdefined("URL.adv") and URL.adv eq 2>
<cfquery name="rsActivoNoAgregados" datasource="#Session.Dsn#">
		Select b.Aplaca, b.Adescripcion, d.AFTdes, e.DEnombre #_Cat# ' ' #_Cat# e.DEapellido1 #_Cat# ' ' #_Cat# e.DEapellido2  as usuario
		    from AFResponsables a
			inner join Activos b
			 on  a.Aid = b.Aid 
 			inner join ADTProceso c
			 on c.Aid = a.Aid 
			 and c.Ecodigo = a.Ecodigo 
			inner join AFTransacciones d
			 on d.IDtrans = c.IDtrans  
			inner join DatosEmpleado e
			 on a.DEid = e.DEid 
			 and a.Ecodigo = e.Ecodigo
		     where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		      <cfif isdefined("url.CRCCid") and len(trim(url.CRCCid))>
			and CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CRCCid#">
		      </cfif>
			  and #hoy# between AFRfini and AFRffin
			  and not exists(
					select 1
					from AFTResponsables
					where AFTResponsables.AFRid = a.AFRid
					and AFTResponsables.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					and AFTResponsables.AFTRtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
					)
				 <cfif isdefined("url.DEid") and len(trim(url.DEid))>
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
				 </cfif>
				 <cfif isdefined("url.Aplacai") and len(trim(url.Aplacai))>
					and exists (
						    select 1
						    from Activos 
						    where Activos.Aid = a.Aid
						    and  Activos.Ecodigo = a.Ecodigo
						 <cfif isdefined("url.Aplacai") and len(trim(url.Aplacai))>
						   and Activos.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Aplacai#">
						</cfif>
							
						)
				</cfif>	
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
				</cfif>		
				<cfif isdefined("url.CRTDid") and len(trim(url.CRTDid))>
					and CRTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CRTDid#">
				</cfif>		
			
		 </cfquery>

<cfelseif isdefined("URL.adv") and URL.adv eq 3>
             <cfquery name="rsActivoNoAgregados" datasource="#session.DSN#">
			Select b.Aplaca , b.Adescripcion, d.AFTdes, e.DEnombre #_Cat# ' ' #_Cat# e.DEapellido1 #_Cat# ' ' #_Cat# e.DEapellido2  as usuario 
				from AFResponsables a
				     inner join Activos b
				         on a.Aid = b.Aid
					 and a.Ecodigo = b.Ecodigo
				     inner join ADTProceso c
	  				on c.Aid = b.Aid 
	   				and c.Ecodigo = b.Ecodigo 
		 		     inner join AFTransacciones d
	 				on d.IDtrans = c.IDtrans  
				     inner join DatosEmpleado e
					on a.DEid = e.DEid 
					and a.Ecodigo = e.Ecodigo
				where CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CRCCid#">
					and a.Ecodigo =  #Session.Ecodigo# 
					and #hoy# between AFRfini and AFRffin 
				<cfif isdefined("URL.AplacaINI") and len(trim(URL.AplacaINI))> 
					and Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.AplacaINI#">
				</cfif>
				<cfif isdefined("URL.DEid") and len(trim(URL.DEid))>
					and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.DEid#">
				</cfif>
				<cfif isdefined("URL.CFid_filtro") and len(trim(URL.CFid_filtro))>
					and a.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.CFid_filtro#">
				</cfif>
				<cfif isdefined("URL.CRTDid") and len(trim(URL.CRTDid))>
					and a.CRTDid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.CRTDid#">
				</cfif>	
				and AFRid not in (
					select AFRid 
					from AFTResponsables 
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and AFTRtipo = 2) 
					and exists (
					Select 1 
					from ADTProceso ADT 
					where ADT.Ecodigo = b.Ecodigo 
					and ADT.Aid = b.Aid)
			</cfquery>	
			
</cfif>

<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<table width="100%"  cellpadding="0" cellspacing="0" border="0">
	    <tr><td>
		<img border=''0'' src="/cfmx/sif/imagenes/stop4.gif">
		&nbsp;Advertencia! Los siguientes Activos cumplen con los filtros seleccionados, pero no fueron agregados ya que están siendo procesados desde Activos Fijos!							
	    </td></tr> 
            <tr><td align="center">&nbsp;</td></tr>	
	    <tr> <td>
		<fieldset style="background-color:#F3F4F8;  border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; border-right: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; ">
		    <legend align="left" style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
			Lista de Activos
			</legend>				
			<table width="100%"  cellpadding="2" cellspacing="2" border="0">	
				<tr>
					<td><strong>Placa</strong></td>
					<td><strong>Descripcion</strong></td>
					<td><strong>Transaccion</strong></td>
					<td><strong>Usuario</strong></td>
				</tr>											
				 <cfoutput query="rsActivoNoAgregados">
				<tr>
					<td>#rsActivoNoAgregados.Aplaca#</td>
					<td>#rsActivoNoAgregados.Adescripcion#</td>
					<td>#rsActivoNoAgregados.AFTdes#</td>
					<td>#rsActivoNoAgregados.usuario#</td>
				</tr>	
				</cfoutput>
			</table>
		</fieldset>	
	</td>
	</tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td align="center">
		<input type="button" name="btncerrar" value="Cerrar" onClick="javascript:window.close();">
		
	</td>
</tr>
</table>