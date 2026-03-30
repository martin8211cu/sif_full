<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 05 de julio del 2005
	Motivo:	Se agregó un nuevo botón para listar nuevas solicitudes a agregar en la orden de pago
		Aqui se listan todas las solicitudes de pago q no han sido asignadas a una orden de pago.
		paso = 3
		
	Modificado por: Ana Villavicencio 
	Fecha: 04 de agosto del 2005
	Motivo: Error en la navegación de la lista de solicitudes.
			Se agrego el dato de TESOPid en la variable de navegacion.
	Linea: 79
----------->

<cf_navegacion name="PASO" value="3">
<cf_navegacion name="SNcodigo_F">
<cf_navegacion name="TESSPfechaPagar_F">
<cf_navegacion name="EcodigoOri_F">
<cf_navegacion name="Beneficiario_F">
<cf_navegacion name="McodigoOri_F">
<cfif isdefined('form.TESOPid')>
	<cfquery name="rsTESOP" datasource="#session.DSN#">
		select CBidPago as CBidPagar, TESMPcodigo, op.SNid, op.SNidP, op.TESBid, op.CDCcodigo,
				case 
					when op.SNid is not null AND sn.SNidCorporativo is not null then 'SNC'
					when op.SNid is not null then 'SN'
					when op.TESBid 		is not null then 'B'
					when op.CDCcodigo	is not null then 'CD'
					else '???'
				end as TipoBeneficiario
		from TESordenPago op
			left join SNegocios sn
				on sn.SNid = op.SNid
		where op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
	</cfquery>
</cfif>


<cfset titulo = 'Lista de Solicitudes de Pago a Seleccionar (Aprobadas sin Orden de Pago)'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<table width="100%" border="0" cellspacing="6">
		<tr>
			<td width="50%" valign="top">
				<form name="formFiltro" method="post" action="ordenesPago.cfm?PASO=3&TESOPid=<cfoutput>#form.TESOPid#</cfoutput>" style="margin: '0' ">
					<input type="hidden" name="PASO" value="3" tabindex="-1">
					<input type="hidden" name="TESOPid" value="<cfoutput>#form.TESOPid#</cfoutput>" tabindex="-1">
					<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
					  <tr>
						<td nowrap align="right">
							<strong>Empresa Solicitud:</strong>&nbsp;
						</td>
						<td>
							<cf_cboTESEcodigo name="EcodigoOri_F" tabindex="1" Tipo="CE">
						</td>
						<td width="23%" align="right" nowrap>
							<strong>Moneda Factura:</strong>
						</td>
						<td>
							<cfquery name="rsMonedas" datasource="#session.DSN#">
								select distinct Mcodigo, (select min(Mnombre) from Monedas m2 where m.Mcodigo=m2.Mcodigo) as Mnombre
								from Monedas m 
									inner join TESempresas e
										 on e.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
										and e.Ecodigo = m.Ecodigo
							</cfquery>
							
							<select name="McodigoOri_F" tabindex="1">
								<option value="">(Todas las monedas)</option>
								<cfoutput query="rsMonedas">
									<option value="#Mcodigo#" <cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F EQ Mcodigo>selected</cfif>>#Mnombre#</option>
								</cfoutput>
							</select>
						</td>
						<td width="14%" nowrap align="right" valign="middle"><strong>Hasta Fecha:</strong></td>
						<td width="13%" nowrap valign="middle">
							<cfset fechadoc = ''>
							<cfif isdefined('form.TESSPfechaPagar_F') and len(trim(form.TESSPfechaPagar_F))>
								<cfset fechadoc = LSDateFormat(form.TESSPfechaPagar_F,'dd/mm/yyyy') >
							</cfif>
							<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="TESSPfechaPagar_F" tabindex="1">												
						</td>
						<td width="24%" nowrap align="center" valign="middle">
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="1"></td>
					  </tr>
					</table>
				</form>
			</td>
		</tr>  
		<cfif isdefined("Form.TESOPid") and Len(Trim(Form.TESOPid)) NEQ 0>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TESOPid=" & Form.TESOPid>
		</cfif>
        <cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery datasource="#session.dsn#" name="lista">
			Select	
				case TESSPtipoDocumento
					when 0 		then 'Manual'
					when 1 		then 'CxP' 
					when 2 		then 'Antic.CxP' 
					when 3 		then 'Antic.CxC' 
					when 4 		then 'Antic.POS' 
					when 5 		then 'ManualCF' 
					when 6 		then 'Antic.GE' 
					when 7 		then 'Liqui.GE' 
					when 8		then 'Fondo.CCh' 
					when 9 		then 'Reint.CCh' 
					when 10		then 'TEF Bcos' 
					when 100 	then 'Interfaz' 
					else 'Otro'
				end as Origen,
				TESSPid,
				TESSPnumero,
				SNcodigoOri,
				'#rsTESOP.TipoBeneficiario#' as TipoBeneficiario,
				<cfif rsTESOP.SNid NEQ "">
					coalesce (SNnombrePago, SNnombre)
				<cfelseif rsTESOP.TESBid NEQ "">
					tb.TESBeneficiario
				<cfelseif rsTESOP.CDCcodigo NEQ "">
					cd.CDCnombre
				<cfelse>
					'???'
				</cfif>
				#_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'') as Beneficiario,
				TESSPfechaPagar,
				Edescripcion,
				m.Mcodigo,
				Mnombre,
				TESSPtotalPagarOri,
				CBid as CBidPagar, 0 as TESMPcodigo
			from TESsolicitudPago sp
				<cfif rsTESOP.SNid NEQ "">
				inner join SNegocios sn
					 on sn.SNcodigo=sp.SNcodigoOri
					and sn.Ecodigo=sp.EcodigoOri
					and coalesce(sn.SNidCorporativo, sn.SNid) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESOP.SNidP#">
				<cfelseif rsTESOP.TESBid NEQ "">
				inner join TESbeneficiario tb
					 on tb.TESBid = sp.TESBid
					and sp.TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESOP.TESBid#">
				<cfelse>
				inner join ClientesDetallistasCorp cd
					 on cd.CDCcodigo=sp.CDCcodigo
				</cfif>
				inner join Empresas e
					on e.Ecodigo=sp.EcodigoOri
				inner join Monedas m
					on m.Mcodigo=sp.McodigoOri
						and m.Ecodigo=sp.EcodigoOri
			where sp.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				and TESSPestado = 2				<!--- Aprobadas --->
				and TESSPtipoDocumento <> 10	<!--- NO TEF bcos --->
				<cfif isdefined('form.TESSPfechaPagar_F') and len(trim(form.TESSPfechaPagar_F))>
					and sp.TESSPfechaPagar <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESSPfechaPagar_F)#">
				</cfif>					
				<cfif isdefined('form.EcodigoOri_F') and len(trim(form.EcodigoOri_F)) and form.EcodigoOri_F NEQ '-1'>
					and sp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoOri_F#">
				</cfif>						
				<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F NEQ '-1'>
					and sp.McodigoOri=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
				</cfif>							
			Order by TESSPfechaPagar,SNcodigoOri,McodigoOri
		</cfquery>	
		<tr>		  
			<td>
				<form name="formListaAsel" method="post" action="ordenesPago_sql.cfm" style="margin: '0' ">
					<cfoutput>
					<cfif isdefined('form.TESOPid')>
					<input name="TESOPid" type="hidden" value="#form.TESOPid#">
					</cfif>
					<input name="PASO" type="hidden" value="3">
					</cfoutput>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="Edescripcion, Origen, TESSPnumero,TipoBeneficiario, Beneficiario,TESSPfechaPagar,Mnombre,TESSPtotalPagarOri"
						etiquetas="Empresa Solicitud, Origen, Num.Solicitud,Tipo,Socio o Beneficiario, Fecha Pago<BR>Solicitada, Moneda,Monto Solicitado"
						formatos="S,S,S,S,S,D,S,M"
						align="left,left,left,center,left,center,left,right"
						ira="ordenesPago_sql.cfm"
						form_method="post"
						showLink="no"
						showEmptyListMsg="yes"
						keys="TESSPid"
						checkboxes="S"
						incluyeForm="no"
						formName="formListaAsel"
						botones=""
						navegacion="#navegacion#"
					/>
					<BR>
					<cf_botones values="Seleccionar,Volver a la Orden" names="btnSeleccionarSP, btnVolver">
					<cfoutput>
					</cfoutput>
				</form>
			</td>
		</tr>		  
	</table>
	<cf_web_portlet_end>

<script language="javascript" type="text/javascript">
 document.formFiltro.EcodigoOri_F.focus();
</script>


