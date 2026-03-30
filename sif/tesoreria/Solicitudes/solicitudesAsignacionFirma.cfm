<!--- 
	Creado por: Maria de los Angeles Blanco López
		Fecha: 19 Octubre 2011
 --->
<cf_templateheader title="Asignación de Firmas de Solicitudes de Pago">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Asignación de Firmas de Solicitudes de Pago'> 

<cf_navegacion name="FechaI" 		navegacion="" session default="">
<cf_navegacion name="FechaF" 		navegacion="" session default="">
<cf_navegacion name="fltUsuario" 		navegacion="" session default="-1">
<cf_navegacion name="CFid" 		navegacion="" session default="">
<cf_navegacion name="TESBid" 		navegacion="" session default="">
<cf_navegacion name="SNid" 		navegacion="" session default="">
<cf_navegacion name="fltMoneda" 		navegacion="" session default="-1">
<cf_navegacion name="NumSol" 		navegacion="" session default="">

<cfquery datasource="#session.dsn#" name="rsCentrosFun">
	select CFid, CFcodigo, CFdescripcion 
	from CFuncional CF
	inner join CPDocumentoE  DP on CF.CFid = DP.CFidOrigen
</cfquery>

<cfquery datasource="#session.dsn#" name="rsMoneda">
	select Mcodigo, Mnombre 
	from Monedas 
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery datasource="#session.dsn#" name="rsUsuarios">
	select distinct U.Usucodigo, U.Usulogin 
	from TESsolicitudPago SP
	inner join Usuario U on SP.UsucodigoSolicitud = U.Usucodigo
</cfquery>

<cfset LvarNavegacion = "">

<cfif isdefined("form.FechaI") and form.FechaI NEQ "" and isdefined("form.FechaF") and form.FechaF NEQ "">
	<cfset LvarNavegacion = LvarNavegacion & "&SP.TESSPfechaPagar between convert(datetime,'#form.FechaI#',103) and            convert(datetime,'#form.FechaF#',103)">
</cfif>

<cfif isdefined("CFid") and CFid NEQ "">
	 <cfset LvarNavegacion = LvarNavegacion & "&SP.CFid = #CFid#">
</cfif>

<cfif isdefined("TESBid") and TESBid NEQ "">
	<cfset LvarNavegacion = LvarNavegacion & "&SP.TESBid = #TESBid#">
</cfif>

<cfif isdefined("SNid") and SNid NEQ "">
	<cfset LvarNavegacion = LvarNavegacion & "&SP.SNid = #SNid#">
</cfif>

<cfif isdefined("form.fltMoneda") and form.fltMoneda NEQ -1>
	<cfset LvarNavegacion = LvarNavegacion & "&MN.Mcodigo = #form.fltMoneda#">
</cfif>

<cfif isdefined("form.fltUsuario") and form.fltUsuario NEQ -1>
	<cfset LvarNavegacion = LvarNavegacion & "&SP.UsucodigoSolicitud = #form.fltUsuario#">
</cfif>

<cfif isdefined("form.NumSol") and len(trim(form.NumSol))>
	<cfset LvarNavegacion = LvarNavegacion & "&SP.TESSPnumero = ltrim(rtrim(#form.NumSol#))">
</cfif>	

<cfif LvarNavegacion NEQ "">
	<cfset LvarNavegacion = mid(LvarNavegacion,2,Len(LvarNavegacion))>
</cfif>


<cfoutput>
<table width="100%" border="0" cellspacing="6">
<tr>
	<td width="50%" valign="top">
	<form name="form1" method="post" action="solicitudesAsignacionFirma.cfm">
	<table class="areaFiltro" width="100%" border="0" cellpadding="0" cellspacing="" align="center">	
		<tr>
			<td valign="top">
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>						
					<tr><td align="right"><strong>Tesoreria:</strong></td>
					<td>
							<cf_cboTESid onchange="this.form1.submit();" tabindex="1">
					</td>
					<td align="right"><strong>Socio Negocios:</strong></td>
					<td>
						<cf_conlis title="LISTA DE SOCIOS DE NEGOCIO"
						campos = "SNid, SNcodigo, SNnombre" 
						desplegables = "N,S,S" 
						modificables = "N,S,N" 
						size = "0,15,34"
						asignar="SNid, SNcodigo, SNnombre"
						asignarformatos="S,S,S"
						tabla="SNegocios"
						columnas="SNid, SNcodigo, SNnombre"
						filtro="Ecodigo = #session.Ecodigo#"
						desplegar="SNcodigo, SNnombre"
						etiquetas="Código, Socio Negocios"
						formatos="S,S,S"
						align="left,left,left"
						showEmptyListMsg="true"
						EmptyListMsg=""
						form="form1"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="SNcodigo, SNnombre"
						index="1"			
						fparams="SNid"/>        				
					</td>
					</tr>
					<tr>
					<td align="right"><strong>Centro Funcional:</strong></td>
					<td>
						<cf_conlis title="LISTA DE CENTROS FUNCIONALES"
						campos = "CFid, CFcodigo, CFdescripcion" 
						desplegables = "N,S,S" 
						modificables = "N,S,N" 
						size = "0,15,34"
						asignar="CFid, CFcodigo, CFdescripcion"
						asignarformatos="S,S,S"
						tabla="CFuncional CF inner join TEScentrosFuncionales TCF on CF.CFid = TCF.CFid"
						columnas="CF.CFid, CF.CFcodigo, CFdescripcion"
						filtro="TESid = #session.Tesoreria.TESid#"
						desplegar="CFcodigo, CFdescripcion"
						etiquetas="Código, Centro Funcional"
						formatos="S,S,S"
						align="left,left,left"
						showEmptyListMsg="true"
						EmptyListMsg=""
						form="form1"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="CF.CFcodigo, CF.CFid, CFdescripcion"
						index="1"			
						fparams="CFid"
						/>        				
					</td>
					<td align="right"><strong>Solicitante :</strong></td>
					<td>
					<select name="fltUsuario" tabindex="5"> 
					<option value="-1" selected="-1">(Todos)</option>
		            <cfloop query="rsUsuarios">
                    	<option value="#rsUsuarios.Usucodigo#" <cfif isdefined("form.fltUsuario") and trim(form.fltUsuario) EQ trim(rsUsuarios.Usucodigo)>selected="selected"</cfif>>#rsUsuarios.Usulogin#</option>  
               		</cfloop>
                	</select> 
					</td>
					</tr>
					<tr>
					<td align="right"><strong>Beneficiario :</strong></td>
					<td>
						<cf_conlis title="LISTA DE BENEFICIARIOS"
						campos = "TESBid, TESbeneficiarioId, TESBeneficiario" 
						desplegables = "N,S,S" 
						modificables = "N,S,N" 
						size = "0,15,34"
						asignar="TESBid, TESbeneficiarioId, TESBeneficiario"
						asignarformatos="S,S,S"
						tabla="TESbeneficiario"
						columnas="TESBid, TESBeneficiarioId, TESBeneficiario"
						filtro="CEcodigo = #Session.CEcodigo#"
						desplegar="TESBeneficiarioId, TESBeneficiario"
						etiquetas="Identificación, Nombre"
						formatos="S,S,S,S"
						align="left,left,left,left"
						showEmptyListMsg="true"
						EmptyListMsg=""
						form="form1"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="TESBeneficiarioId, TESBeneficiario"
						index="1"			
						funcion=""
						fparams="TESBid"
						/>        
					</td>
					<td align="right"><strong>Moneda:</strong></td>
					<td>
		        	<select name="fltMoneda"> 
	            	<option value="-1" selected="selected">(Todos)</option>
    	        	<cfloop query="rsMoneda">
        	       		<option value="#rsMoneda.Mcodigo#" <cfif isdefined("form.fltMoneda") and trim(form.fltMoneda) EQ trim(rsMoneda.Mcodigo)>selected="selected"</cfif>>#rsMoneda.Mnombre#</option>
            		</cfloop>
            		</select>
	           		</td>
					</tr>	
					<tr>
					<td align="right"><strong>Fecha&nbsp;Desde:</strong>
					<td >
					<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
						<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1"> 
					<cfelse>	
						<cfset LvarFecha = createdate(year(now()),1,1)>
					<cf_sifcalendario form="form1" value="" name="FechaI" tabindex="1"> 	
					</cfif> 
					</td>
					</td>
					<td align="right">
					<strong>Fecha Hasta:</strong>
					<td>
					<cfif isdefined("form.FechaF") and len(trim(form.FechaF))>
						<cf_sifcalendario form="form1" value="#form.FechaF#" name="FechaF" tabindex="1"> 
					<cfelse>
						<cf_sifcalendario form="form1" value="" name="FechaF" tabindex="1"> 				
					</cfif>
					</td>
					</td>
					</tr>
					<tr>
					<td align="right"><strong>Número&nbsp;Solicitud :</strong>
					<td><input type="text" name="NumSol" value=""/></td>
					<td  align="left"><cf_botones values="Filtrar" names="Filtrar" tabindex="0"></td>				
					</tr>				
			</table>								
			</td>
		</tr>
	</table>
	</form>
	
	<cfquery name="rsLista" datasource="#session.dsn#">
		select distinct SP.TESSPid, TESSPnumero, Beneficiario = isnull(TB.TESBeneficiario,SNnombre), 			       	        SP.TESSPfechaPagar, Fecha_Pago = convert(varchar(10),SP.TESSPfechaPagar,103), MN.Miso4217, U.Usulogin, 
		TotalPagar = round(SP.TESSPtotalPagarOri,2), 
		(select rtrim(o.Oficodigo) + ':' + cf.CFcodigo
	 	from CFuncional cf 
		inner join Oficinas o on o.Ecodigo = cf.Ecodigo and o.Ocodigo = cf.Ocodigo 
		where cf.CFid = SP.CFid) 
		as CFcodigo
		from TESsolicitudPago SP 
		inner join TESdetallePago DP on SP.TESSPid = DP.TESSPid
		inner join Monedas MN on MN.Mcodigo = SP.McodigoOri and MN.Ecodigo = SP.EcodigoOri
		inner join Usuario U on SP.UsucodigoSolicitud = U.Usucodigo
		left join TESbeneficiario TB on TB.TESBid = SP.TESBid 
		left join SNegocios SN on SN.SNcodigo = SP.SNcodigoOri and SN.Ecodigo = SP.EcodigoOri
		where SP.TESid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Tesoreria.TESid#">
	<cfif isdefined("CFid") and CFid NEQ "">
		and SP.CFid = #CFid#
	</cfif>
	<cfif isdefined("TESBid") and TESBid NEQ "">
		and SP.TESBid = #TESBid#
	</cfif>
	<cfif isdefined("SNid") and SNid NEQ "">
		and SP.SNid = #SNid#
	</cfif>
	<cfif isdefined("form.fltMoneda") and form.fltMoneda NEQ -1>
		and MN.Mcodigo = #form.fltMoneda#
	</cfif>
	<cfif isdefined("form.FechaI") and form.FechaI NEQ "" and isdefined("form.FechaF") and form.FechaF NEQ "">
		and SP.TESSPfechaPagar between convert(datetime,'#form.FechaI#',103) and            convert(datetime,'#form.FechaF#',103)
	</cfif>
	<cfif isdefined("form.fltUsuario") and form.fltUsuario NEQ -1>
		and SP.UsucodigoSolicitud = #form.fltUsuario#
	</cfif>
	<cfif isdefined("form.NumSol") and len(trim(form.NumSol))>
		and SP.TESSPnumero = ltrim(rtrim(#form.NumSol#))
	</cfif>		
	</cfquery>		
	
	<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="cortes" value=""/>
			<cfinvokeargument name="desplegar" value="TESSPnumero, CFcodigo, Beneficiario, Fecha_Pago, TotalPagar, Miso4217, Usulogin"/>
			<cfinvokeargument name="etiquetas" value="Num.<BR>Solicitud, Ofi:Centro<BR>Funcional, Beneficiario, Fecha Pago, Total Pago, Moneda, Usuario"/>
			<cfinvokeargument name="formatos" value="I,S,S,S,S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
			<cfinvokeargument name="align" value="center,center, left, center, center, center, center"/>
			<cfinvokeargument name="checkboxes" value=""/>
			<cfinvokeargument name="irA" value="solicitudesAsignacionFirma_Valores.cfm"/>
            <cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="TESSPid"/>
			<cfinvokeargument name="botones" value=""/>
            <cfinvokeargument name="navegacion" value="#LvarNavegacion#"/>
			</cfinvoke>
	</td>
</tr>
</table>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<cfset session.ListaReg = "">

