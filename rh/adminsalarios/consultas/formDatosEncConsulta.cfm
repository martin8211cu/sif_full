<cfif isdefined("Url.Eid") and not isdefined("Form.Eid")>
	<cfset Form.Eid = Url.Eid>
</cfif>
<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
	<cfset Form.Mcodigo = Url.Mcodigo>
</cfif>
<cfif isdefined("Url.ETid") and not isdefined("Form.ETid")>
	<cfset Form.ETid = Url.ETid>
</cfif>

<cfif not ( isdefined("form.Mcodigo") and isdefined("form.ETid") ) and isdefined("form.Eid")>
	<cfquery name="dataEncuesta" datasource="sifpublica">
		select a.EEid, a.Eid, a.Edescripcion, b.EEnombre
		from Encuesta a
		
		inner join EncuestaEmpresa b
		on a.EEid=b.EEid
		
		where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
	</cfquery>
	<cfquery name="rsOrganizacion" datasource="sifpublica">
		select ETid, ETdescripcion 
		from EmpresaOrganizacion
		where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataEncuesta.EEid#">
	</cfquery>
	<cfquery name="rsMonedas" datasource="#session.DSN#">
		select Mcodigo,Mnombre,Msimbolo
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>


		<cfoutput>
	<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<form name="form1" action="DatosEncConsulta.cfm" method="post">
		<!--- ENCABEZADO DE LA ENCUESTA --->
		<table width="100%" border="0" align="center">
			<!----<tr>
				<td colspan="2" align="center" class="tituloProceso">Consulta de Encuestas</td>
			</tr>---->
			<tr>
				<td colspan="2" >&nbsp;</td>
			</tr>

			<tr>
				<td colspan="2" align="center">
					<table width="20%" align="center" >
						<tr>
							<td align="right"><strong>Empresa Encuestadora:&nbsp;<strong></td>
							<td>#dataEncuesta.EEnombre#</td>
						</tr>
						<tr>
							<td align="right"><strong>Encuesta:&nbsp;<strong></td>
							<td>#dataEncuesta.Edescripcion#</td>
						</tr>
						<tr>
							<td width="7%" align="left" nowrap><div align="right"><strong>Seleccione el tipo de Organizaci&oacute;n:&nbsp;</strong></div></td>
							<td width="93%" nowrap>
								<cfoutput>
									<select name="ETid" id="ETid"  style="width:150px; "> 
										<option value="" >-- seleccionar --</option>
										<cfloop query="rsOrganizacion">
											<option value="#rsOrganizacion.ETid#" >#rsOrganizacion.ETdescripcion#</option>
										</cfloop>
									</select>
								</cfoutput>						
							</td>
						</tr>
			
			
						<tr>
							<td width="7%" align="left" nowrap><div align="right"><strong>Seleccione Moneda:&nbsp;</strong></div></td>
							<td width="93%" nowrap>
			
								<cfoutput>
									<select name="Mcodigo" id="Mcodigo" style="width:150px; " > 
										<option value="" >-- seleccionar --</option>
										<cfloop query="rsMonedas">
											<option value="#rsMonedas.Mcodigo#" >
												#rsMonedas.Mnombre# - #rsMonedas.Msimbolo#</option>
										</cfloop>
									</select>
								</cfoutput>						
			
							</td>
						</tr>
						<tr>
							<td  colspan="2" align="center" nowrap>
								<input type="submit" name="Ver" value="Consultar" onclick="javascript:document.form1.action='';">
								<input type="button" name="Regresar" value="Regresar" onclick="javascript:Lista();">
							</td>
						</tr>

					</table>
				</td>
			</tr>
		</table>
		<input type="hidden" name="Eid" value="#form.Eid#">
	</form>
	</cfoutput>
	
	<script language="JavaScript1.2">
		function Lista() {
			location.href = 'listaDatosEncConsulta.cfm';
		}

		<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		//-->
	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
	
		objForm.Mcodigo.required = true;
		objForm.Mcodigo.description="Moneda";
		objForm.ETid.required = true;
		objForm.ETid.description="Tipo de Organización";
	</script>	
<cfelse>

	<cfif isdefined("Form.Mcodigo") and LEN(form.Mcodigo) GT 0>
		<cfquery name="rsEncMcodigo" datasource="sifpublica">
			select 1
			from EncuestaSalarios
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
			  and Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		</cfquery>
	<cfelse>
		<cfquery name="rsConsulta" datasource="sifpublica">
			select *
			from EncuestaSalarios
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
		</cfquery>
		<cfif isdefined("rsConsulta") and rsConsulta.RecordCount Gt 0>
			<cfset Mcodigo = #rsConsulta.moneda#>
		</cfif>	
	</cfif>
	
	<cfif not isdefined("rsEncMcodigo")>
		<cfset Form.modo = 'ALTA'>
	<cfelse>
		<cfset Form.modo = 'CAMBIO'>
	</cfif>

	<cfset vparams = "">
	<cfif isdefined("Form.Eid")>
		<cfset vparams = vparams & "&Eid=" & form.Eid>
	</cfif>
	
	<cfif isdefined("Form.Mcodigo")>
		<cfset vparams = vparams & "&Mcodigo=" & form.Mcodigo>
	</cfif>
	
	<cfif isdefined("Form.ETid")>
		<cfset vparams = vparams & "&ETid=" & form.ETid>
	</cfif>

	<cfif isdefined("Form.modo")>
		<cfset vparams = vparams & "&modo=" & form.modo>
	<cfelse>
		<cfset vparams = vparams & "&modo=CAMBIO">
	</cfif>
	
	<cfquery name="rsForm" datasource="sifpublica">
		select 	a.*, 
				b.EEcodigo,
				b.EEnombre, 
				c.Edescripcion, 
				d.ETdescripcion, 
				e.EPcodigo, 
				e.EPdescripcion, 
				f.EAdescripcion
	
		from EncuestaSalarios a 
	
		left outer join EncuestaEmpresa b
		  on a.EEid = b.EEid 
		  
		left outer join Encuesta c
		  on a.EEid = c.EEid and  
			 a.Eid = c.Eid 
	
		left outer join EmpresaOrganizacion d
		  on a.EEid = b.EEid and
			 a.ETid = d.ETid 
	
		left outer join EncuestaPuesto e
		  on a.EEid = b.EEid and
			 a.EPid =e.EPid 
	
		left outer join EmpresaArea f
		  on e.EEid = f.EEid and
			 e.EAid = f.EAid 
	
		where a.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Eid#">
		  and a.Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
		  
		  <cfif isdefined("form.ETid") and len(trim(form.ETid))>
		  	and a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
		  </cfif>
		  
		order by b.EEcodigo, d.ETdescripcion,f.EAdescripcion, e.EPcodigo
	</cfquery>

	<cfif isdefined("Mcodigo")>
		<cfset Form.Mcodigo = Mcodigo>
	</cfif>
	
	<cfquery name="rsMonedas" datasource="#session.DSN#">
		select Mcodigo,Mnombre,Msimbolo
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif isdefined("url.imprimir")>
		<cfquery name="rsMonedaCons" datasource="#session.DSN#">
			select Mnombre || '-' || Msimbolo as Moneda
			from Monedas
			Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
		</cfquery>
	</cfif>
	
	<cfsavecontent variable="encabezado1">
	<cfoutput>
		<cf_EncReporte
				Titulo="#rsForm.EEnombre#"
				Color="##E3EDEF"
				filtro1="#rsForm.Edescripcion#"
				filtro2="Tipo de Organizaci&oacute;n - #rsForm.ETdescripcion#"
				cols= "8"
			>
	</cfoutput>
	</cfsavecontent>
	
	<cfsavecontent variable="encabezado2">
		<tr>
			<td  class="tituloListas" width="31%" style="padding-left:40px; " title="Puesto por Área"><b>Puesto</b></td>
			<td align="center" class="tituloListas" width="10%" title="Cantidad de Observaciones"><b>Obs</b></td>
			<td align="center" class="tituloListas" width="9%"  title="Promedio periodo actual"><b>Promedio</b></td>
			<td align="center" class="tituloListas" width="9%"  title="Promedio periodo anterior" nowrap><b>Promedio Anterior</b></td>
			<td align="center" class="tituloListas" width="8%"  title="Percentil 25"><b>P25</b></td>
			<td align="center" class="tituloListas" width="8%"  title="Percentil 50"><b>P50</b></td>
			<td align="center" class="tituloListas" width="8%"  title="Percentil 75"><b>P75</b></td>
			<td align="center" class="tituloListas" width="9%"  title="Variación"><b>Variacion</b></td>
		</tr>
	</cfsavecontent>
	
	<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">
	<cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<cf_rhimprime datos="/rh/adminsalarios/consultas/formDatosEncConsulta.cfm" paramsuri="#vparams#">
					</td>	
				</tr>
			</table>	
		</cfif>
	</cfoutput>

	<!--- ENCABEZADO DE LA ENCUESTA --->
	<table width="100%" border="0" align="center">
		<cfoutput><cfif not isdefined("url.imprimir")>#encabezado1#</cfif></cfoutput>
	</table><br>

	<table width="100%" border="0" style="border-collapse:collapse;" cellpadding="0" cellspacing="0">
		<cfoutput>
		<cfif not isdefined("url.imprimir") >
			<cfif isdefined("Form.EAid")>
				<cfset Form.Area = rsForm.EAid>
				<tr>
					<td colspan="8"><b>#rsForm.EAdescripcion#</b></td>
				</tr>
			</cfif>
		</cfif>
		</cfoutput>

		<cfif rsForm.RecordCount GT 0>
			<cfoutput query="rsForm" group="EEcodigo" >
				<cfoutput group="ETdescripcion">
					<cfif rsForm.CurrentRow neq 1 >
						<tr><td colspan="8">&nbsp;</td></tr>
					</cfif>
					<tr><td colspan="8" class="tituloPersona" style="text-align:left; " ><strong>Tipo de Organizaci&oacute;n: #rsForm.ETdescripcion#</strong></td></tr>
					#encabezado2#
					<cfoutput group="EAdescripcion">
						<tr><td colspan="8" style="padding-left:20px;"><strong>&Aacute;rea: #rsForm.EAdescripcion#</strong></td></tr>
						<cfoutput>
							<tr>
								<td style="padding-left:40px;" nowrap>&nbsp;&nbsp;#rsForm.EPcodigo# - #rsForm.EPdescripcion#</td>
								<td width="5%" align="center">#rsForm.EScantobs#</td>
								<td align="right" >#LSNumberFormat(rsForm.ESpromedio,',9.00')#</td>
								<td align="right" >#LSNumberFormat(rsForm.ESpromedioanterior,',9.00')#</td>
								<td align="right" >#LSNumberFormat(rsForm.ESp25,',9.00')#</td>
								<td align="right" >#LSNumberFormat(rsForm.ESp50,',9.00')#</td>
								<td align="right" >#LSNumberFormat(rsForm.ESp75,',9.00')#</td>
								<td align="center" >#LSNumberFormat(rsForm.ESvariacion,',9.00')#</td>
							</tr>
						</cfoutput>
					</cfoutput>
				</cfoutput>
			</cfoutput>

			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>						
			<tr > 
				<td colspan="9" align="center">
					<strong>--- Fin del Reporte ---</strong>
				</td>
			</tr>  
		<cfelse>
			<cfoutput>
				<tr><td colspan="8">&nbsp;</td></tr>
				<tr><td align="center" colspan="9"><strong>--------- NO HAY DATOS DISPONIBLES ---------</strong></td></tr>
			</cfoutput>
		</cfif>

		<tr><td colspan="8">&nbsp;</td></tr>
		<tr><td colspan="8">&nbsp;</td></tr>	

		<cfoutput>
			<cfif not isdefined("url.imprimir")>
				<tr>
					<td colspan="8" align="center">
						<form style="margin:0; " name="form1" method="post">
						<input type="button"  name="Regresar" value="Regresar" onclick="javascript: Lista();" tabindex="1">
						</form>								
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</table>

	<script>
		<cfoutput>
		function Lista() {
			location.href = 'DatosEncConsulta.cfm?Eid=#form.Eid#';
		}
		</cfoutput>
	</script>
</cfif>