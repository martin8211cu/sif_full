<!--- 
	Modificador por: Ana Villavicencio 
	Fecha: 04 de agosto del 2005
	Motivo: Se agrego al filtro para la lista la moneda de la solicidud.
 --->

<cfset navegacion = "&PASO=3">
<cf_navegacion name="SNcodigo_F">
<cf_navegacion name="McodigoOri_F">
<cf_navegacion name="Dfechavenc_F">
<cf_navegacion name="Beneficiario_F">
<cfquery name="rsSolicitud" datasource="#session.DSN#">
	select SNcodigoOri
	from TESsolicitudPago
	where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
</cfquery>
<cfif isdefined('url.Mcodigo') and LEN(TRIM(url.Mcodigo))>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>
<!--- <cf_dump var="#rsSolicitud#"> --->
<cfset titulo = 'Lista de Documentos de CxP a Seleccionar'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<table width="100%" border="0" cellspacing="6">
	  <tr>
		<td width="100%" valign="top">
			<form name="formFiltro" method="post" action="solicitudesCP.cfm" style="margin: '0' ">
				<input type="hidden" name="PASO" value="3" tabindex="-1">
				<input type="hidden" name="TESSPid" value="<cfoutput>#form.TESSPid#</cfoutput>" tabindex="-1">
				<input type="hidden" name="Mcodigo" value="<cfoutput>#form.Mcodigo#</cfoutput>" tabindex="-1">
				<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
				  <tr>
				  	<td align="right"><strong>Documento:&nbsp;</strong></td>
					<td><input name="Ddocumento_F" type="text" value="" tabindex="1"></td>
					<td nowrap align="right" valign="middle"><strong>Hasta Fecha:&nbsp;</strong></td>
					<td width="13%" nowrap valign="middle">
						<cfset fechadoc = ''>
						<cfif isdefined('form.Dfechavenc_F') and len(trim(form.Dfechavenc_F))>
							<cfset fechadoc = LSDateFormat(form.Dfechavenc_F,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="Dfechavenc_F" tabindex="1">												
					</td>
					<td width="24%" rowspan="2" nowrap align="center" valign="middle">
						<cf_botones tabindex="1" 
									include="Filtrar" 
									includevalues="Filtrar"
									exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
						<!--- <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="1"> --->
					</td>
				  </tr>
			  </table>
			</form>
		</td></tr>
		<tr>
			<td width="100%">
				<cfif isdefined('form.Ddocumento_F') and len(trim(form.Ddocumento_F))>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ddocumento_F=" & Form.Ddocumento_F>
				</cfif>							
				<cfif isdefined("Form.Dfechavenc_F") and Len(Trim(Form.Dfechavenc_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Dfechavenc_F=" & Form.Dfechavenc_F>
				</cfif>		
				<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodigo=" & Form.Mcodigo>
				</cfif>	
				<cfquery datasource="#session.dsn#" name="lista">
					Select 
						IDdocumento,
						Ddocumento as numero, tt.CPTcodigo as referencia,
						sn.SNcodigo,
						SNnombre,
						Dfechavenc,
						m.Mcodigo,
						Mnombre,
						EDsaldo-TESDPaprobadoPendiente as Monto
					from EDocumentosCP ed
						inner join CPTransacciones tt
							 on tt.Ecodigo 		= ed.Ecodigo
							and tt.CPTcodigo 	= ed.CPTcodigo
							and tt.CPTtipo 		= 'C'
						inner join SNegocios sn
							on sn.SNcodigo=ed.SNcodigo	
								and sn.Ecodigo=ed.Ecodigo
								and sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitud.SNcodigoOri#">
						inner join Monedas m
							on m.Mcodigo=ed.Mcodigo
								and m.Ecodigo=ed.Ecodigo
					
					where ed.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						<cfif isdefined('form.Dfechavenc_F') and len(trim(form.Dfechavenc_F))>
							<cfparam name="form.Dfechavenc_F" default="#DateFormat(now(),'DD/MM/YYYY')#">
							and Dfechavenc <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.Dfechavenc_F)#">
						</cfif>	
						<cfif isdefined('form.Ddocumento_F') and LEN(TRIM(form.Ddocumento_F))>
						  and upper(Ddocumento) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.Ddocumento_F))#%">
						</cfif>
						<cfif isdefined('form.Mcodigo') and len(trim(form.Mcodigo))>
							and m.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
						</cfif>							
									
						and (EDsaldo - TESDPaprobadoPendiente) > 0	
						and not exists
							   <!--- Que el documento no esté En preparacion SP o enviada a aprobacion SP --->
								(
									Select 1
									  from TESdetallePago dp
									 where dp.EcodigoOri		= ed.Ecodigo
									   and dp.TESDPidDocumento 	= ed.IDdocumento
									   and dp.TESDPestado 		in (0,1)  
								)
	
					Order by Dfechavenc,sn.SNcodigo,m.Mcodigo
				</cfquery>	
			<form name="formListaAsel" action="solicitudesCP_sql.cfm" method="post">
			<input type="hidden" name="PASO" value="3" tabindex="-1">
			<input name="TESSPid" type="hidden" value="<cfoutput>#form.TESSPid#</cfoutput>" tabindex="1">
			<input name="Mcodigo" type="hidden" value="<cfoutput>#form.Mcodigo#</cfoutput>" tabindex="1">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								query="#lista#"
								desplegar="numero,referencia,SNnombre,Dfechavenc,Mnombre,Monto"
								etiquetas="Documento,Referencia, Socio Negocio, Fecha<BR>Vencimiento, Moneda, Saldo Vence"
								formatos="S,S,S,D,S,M"
								align="left,left,left,center,right,right"
								ira="solicitudesCP_sql.cfm"
								form_method="post"
								showLink="no"
								showEmptyListMsg="yes"
								keys="IDdocumento"
								checkboxes="S"
								incluyeform="false"
								formName="formListaAsel"
								navegacion="#navegacion#"
							/>		
							<cf_botones values="Seleccionar,Volver a la Solicitud" names="btnSeleccionarDoc, btnVolver" tabindex="1">
						</td>
					</tr>
				</table>
			</form>
		</td>
	  </tr>
	  <tr><td>&nbsp;</td></tr>		  
	</table>

	<cf_web_portlet_end>
