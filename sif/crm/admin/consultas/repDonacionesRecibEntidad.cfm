<cfif (isdefined("Url.btnConsultar")) and Url.btnConsultar NEQ '' and not isdefined('Form.btnConsultar')>
	<cfparam name="Form.btnConsultar" default="#Url.btnConsultar#">
</cfif>

<cfif isdefined('form.btnConsultar') and form.btnConsultar NEQ ''>
	<!--- Para el filtro de la lista --->
	<cfif (isdefined("Url.CRMEid_filtro")) and Url.CRMEid_filtro NEQ ''>
		<cfparam name="Form.CRMEid_filtro" default="#Url.CRMEid_filtro#">
	</cfif>
	<cfif (isdefined("Url.fechaini_filtro")) and Url.fechaini_filtro NEQ ''>
		<cfparam name="Form.fechaini_filtro" default="#Url.fechaini_filtro#">
	</cfif>
	<cfif (isdefined("Url.fechafin_filtro")) and Url.fechafin_filtro NEQ ''>
		<cfparam name="Form.fechafin_filtro" default="#Url.fechafin_filtro#">
	</cfif>	
							
	<cfif isdefined('form.CRMEid_filtro') and form.CRMEid_filtro NEQ ''>
		<cfquery name="rsEntidad" datasource="#Session.DSN#">
			select (CRMEnombre + ' ' + CRMEapellido1 + ' ' + CRMEapellido2) as Nombre_Completo
			from CRMEntidad
			where CEcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and CRMEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEid_filtro#">
				and <cf_dbfunction name="now"> between CRMEfechaini and CRMEfechafin
		</cfquery>								
	</cfif>

	<cfset filtro = "">
	<cfset navegacion = "">
	<cfset navegacionSel = "">
	<cfif isdefined("Form.CRMEid_filtro") and Len(Trim(Form.CRMEid_filtro)) NEQ 0>
		<cfset filtro = filtro & " and ed.CRMEid=" & #Form.CRMEid_filtro#>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CRMEid_filtro=" & Form.CRMEid_filtro>
	</cfif>
	
	<cfif isdefined("Form.fechaini_filtro") and Len(Trim(Form.fechaini_filtro)) NEQ 0>
		<cfset filtro = filtro & " and CRMEDfecha >= convert(datetime,'" & #Form.fechaini_filtro# & "',103)">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fechaini_filtro=" & Form.fechaini_filtro>
	</cfif>

	<cfif isdefined("Form.fechafin_filtro") and Len(Trim(Form.fechafin_filtro)) NEQ 0>
		<cfset filtro = filtro & " and CRMEDfecha <= convert(datetime,'" & #Form.fechafin_filtro# & "',103)">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fechafin_filtro=" & Form.fechafin_filtro>
	</cfif>	

	<!--- <cf_sifHTML2Word Titulo="Donaciones Recibidas por Entidad">  --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="center" class="tituloAlterno">
				<cfif isdefined('rsEntidad') and rsEntidad.recordCount GT 0>
					Donaciones Recibidas por <cfoutput>#rsEntidad.Nombre_Completo#</cfoutput>
				<cfelse>
					Donaciones Recibidas por Entidad 
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="center" class="tituloAlterno">
				<cfif isdefined('form.fechaini_filtro') and form.fechaini_filtro NEQ ''>
					Del <cfoutput>#form.fechaini_filtro#</cfoutput>
				</cfif>
				<cfif isdefined('form.fechafin_filtro') and form.fechafin_filtro NEQ ''>
					Al <cfoutput>#form.fechafin_filtro#</cfoutput>
				</cfif>				
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>		  
		  <tr>
			<td>
				<cfinvoke 
				 component="sif.crm.Componentes.pListas"
				 method="pListaCRM"
				 returnvariable="pListaCRMRet">
					<cfinvokeargument name="tabla" value="
						CRMDDonacion dd,
						CRMEDonacion ed,
						CRMEntidad e																						
					"/>
					<cfinvokeargument name="columnas" value="
						dd.CRMEid,
						(e.CRMEnombre + ' ' + e.CRMEapellido1 + ' ' + e.CRMEapellido2) as NombreDonante,
						case
							when datalength(CRMEDdescripcion) > 60 then (substring((CRMEDdescripcion),1,60) + '...') 
							else (CRMEDdescripcion)
						end CRMEDdescripcion,
						convert(varchar,CRMEDfecha,103) as CRMEDfecha,
						case
							when datalength(CRMDDdescripcion) > 60 then (substring((CRMDDdescripcion),1,60) + '...') 
							else (CRMDDdescripcion)
						end CRMDDdescripcion,
						case CRMDDtipopago
							when 'E' then 'Efectivo' 
							when 'D' then 'Deposito' 
							when 'T' then 'Tarjeta' 
							when 'C' then 'Cheque' 
							else ''
						end as CRMDDtipopago,
						CRMDmonto"/>
					<cfinvokeargument name="desplegar" value="CRMEDdescripcion,CRMDDdescripcion,CRMEDfecha,CRMDDtipopago,CRMDmonto"/>
					<cfinvokeargument name="etiquetas" value="Donaci&oacute;n,Detalle Donaci&oacute;n,Fecha,Tipo Pago, Monto"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="
							dd.Ecodigo=#session.Ecodigo#	
							and dd.CEcodigo=#session.CEcodigo#
							and dd.Ecodigo=ed.Ecodigo
							and dd.CEcodigo=ed.CEcodigo
							and dd.CRMEDid=ed.CRMEDid 	
							and ed.Ecodigo=e.Ecodigo
							and ed.CEcodigo=e.CEcodigo
							and dd.CRMEid=e.CRMEid 
							#filtro#					
						order by NombreDonante,CRMDmonto"/>
					<cfinvokeargument name="align" value="left,left,center,center,rigth"/>
					<cfinvokeargument name="Conexion" value="#session.DSN#"/>	
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="irA" value=""/>
					<cfinvokeargument name="Cortes" value="NombreDonante"/>	
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="ajustar" value="S"/>	
				</cfinvoke>	
			</td>
		  </tr>
		  <tr>
			<td align="center">
				--- Fin del Reporte ---
			</td>
		  </tr>
		  <tr>
			<td align="center">&nbsp;
			</td>
		  </tr>
		</table>
	<!--- </cf_sifHTML2Word> --->	
</cfif>