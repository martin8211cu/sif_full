<cfparam name="Attributes.Tipo"			default="">
<cfparam name="Attributes.AprobacionSP"	default="no" type="boolean">
<!--- SP_lista trabaja a nivel empresarial, excepto cuando es RechazoSP que es a nivel de Tesorería --->
<cfparam name="Attributes.RechazoSP"	default="no" type="boolean">
<cfparam name="Attributes.PasarSP"		default="no" type="boolean">
<cfparam name="Attributes.FiltarxUsuario"default="no" type="boolean">
<cfset LvarDesdeTesoreria = Attributes.RechazoSP OR Attributes.PasarSP>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif IsDefined("url.sbVer")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESSPmsgRechazo
				, case TESSPestado
					when 3 then 'Solicitud de Pago Rechazada por:'
					when 13 then 'Solicitud de Pago Anulada en la Orden de Pago ' #LvarCNCT# <cf_dbfunction name="to_char" args="op.TESOPnumero"> #LvarCNCT# ' por:'
					when 23 then 'Solicitud de Pago Rechazada en Tesorería por:'
					when 103 then 'Solicitud de Pago Rechazada en la Orden de Pago ' #LvarCNCT# <cf_dbfunction name="to_char" args="op.TESOPnumero"> #LvarCNCT# ' por:'
					else 'Motivo Rechazo Anterior:'
				end Estado

		  from TESsolicitudPago sp
			left outer join TESordenPago op
				on op.TESOPid = sp.TESOPid
		 where sp.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SP#">
	</cfquery>
	<cfoutput>
	<script language="javascript">
		alert("#rsSQL.Estado#\n\n#JSStringFormat(rsSQL.TESSPmsgRechazo)#");
		var LvarIframe = parent.document.getElementById("ifrDescripcion");
		LvarIframe.src = "";

	</script>
	</cfoutput>
	<cfabort>
</cfif>

<cfset LvarPrimera = false>
<cfset LvarHoy = createODBCdate(now())>
<cfset LvarHaceUnMes = dateadd("d",-7, LvarHoy)>

<cfparam name="session.SP_TipoAnterior" default="*">

<cfif session.SP_TipoAnterior NEQ Attributes.Tipo or isdefined("url._")>
	<cfset session.SP_TipoAnterior = Attributes.Tipo>

	<cfset session.Tesoreria.CFid = "-1">
	<cf_navegacion name="CFid_F"				value="" session>
	<cf_navegacion name="UsucodigoSP_F"			value="" session>

	<cf_navegacion name="TESSPestado_F"			value="" session>
	<cf_navegacion name="TESSPtipoDocumento_F"	value="" session>
	<cf_navegacion name="SNcodigo_F" 			value="" session>
	<cf_navegacion name="TESBid_F" 				value="" session>
	<cf_navegacion name="CDCcodigo_F" 			value="" session>

	<cf_navegacion name="TESBeneficiario_F" 	value="" session>
	<cf_navegacion name="TESSPfechaPago_I" 		session default="#LSDateFormat(LvarHaceUnMes,'dd/mm/yyyy')#">
	<cf_navegacion name="TESSPfechaPago_F" 		session value="">
	<cf_navegacion name="McodigoOri_F"			value="" session>
	<cf_navegacion name="EcodigoOri_F"			value="" session>
	
	<cfset LvarPrimera = true>
</cfif>

<cfif Attributes.Tipo EQ "">					<!--- TODOS --->
	<cfif not Attributes.AprobacionSP AND not LvarDesdeTesoreria>
		<cf_navegacion name="TESSPestado_F"		session default="0">
	<cfelse>
		<cf_navegacion name="TESSPestado_F"		default="0">
	</cfif>
	<cf_navegacion name="TESSPtipoDocumento_F"	session default="">
	<cf_navegacion name="SNcodigo_F" 			session default="">
	<cf_navegacion name="TESBid_F" 				session default="">
	<cf_navegacion name="CDCcodigo_F" 			session default="">
<cfelseif Find(Attributes.Tipo,"0,5") GT 0>		<!--- MANUAL --->
	<cf_navegacion name="TESSPtipoDocumento_F"	value="#Attributes.Tipo#">
	<cf_navegacion name="TESSPestado_F"			value="0">

	<cf_navegacion name="TESBid_F" 				session default="">
	<cf_navegacion name="SNcodigo_F" 			session default="">
	<cf_navegacion name="CDCcodigo_F" 			value="">
<cfelseif Attributes.Tipo EQ 4>					<!--- POS --->
	<cf_navegacion name="TESSPtipoDocumento_F"	value="#Attributes.Tipo#">
	<cf_navegacion name="TESSPestado_F"			value="0">

	<cf_navegacion name="CDCcodigo_F" 			session default="">
	<cf_navegacion name="SNcodigo_F" 			value="">
	<cf_navegacion name="TESBid_F" 				value="">
<cfelse>										<!--- CxP, Anti.CxP, Anti.CxC --->
	<cf_navegacion name="TESSPtipoDocumento_F"	value="#Attributes.Tipo#">
	<cf_navegacion name="TESSPestado_F"			value="0">

	<cf_navegacion name="SNcodigo_F" 			session default="">
	<cf_navegacion name="TESBid_F" 				value="">
	<cf_navegacion name="CDCcodigo_F" 			value="">
</cfif>

<cfif isdefined("form.cboCFid")>
	<cfset form.CFid_F = form.cboCFid>
</cfif>
<cf_navegacion name="CFid_F" 				session default="">
<cfset form.cboCFid = form.CFid_F>

<cfif isdefined("form.Usucodigo")>
	<cfset form.UsucodigoSP_F = form.Usucodigo>
</cfif>
<cf_navegacion name="UsucodigoSP_F"			session default="">
<cfset form.Usucodigo = form.UsucodigoSP_F>


<cf_navegacion name="TESBeneficiario_F" 	session default="">
<cf_navegacion name="TESSPfechaPago_I" 		session default="#LSDateFormat(LvarHaceUnMes,'dd/mm/yyyy')#">
<cf_navegacion name="TESSPfechaPago_F" 		session default="">
<cf_navegacion name="McodigoOri_F"			session default="">
<cf_navegacion name="EcodigoOri_F"			session default="">

<cfif len(trim(form.SNcodigo_F))>
	<cf_navegacion name="TESBid_F" 			session	value="">
	<cf_navegacion name="CDCcodigo_F" 		session	value="">
<cfelseif len(trim(form.TESBid_F))>
	<cf_navegacion name="CDCcodigo_F" 		session	value="">
</cfif>

<style type="text/css">
<!--
.pStyle_MSG {color: #FF0000}
-->
</style>
<script type="text/javascript" language="javascript1.2" src="../sif/js/utilesMonto.js"></script>
<table width="100%"border="0" cellspacing="6">
	<tr>
	<td valign="top">
		<form name="formFiltro" method="post" onsubmit="fnValidaCampos()" action="<cfoutput>#Attributes.IrA#</cfoutput>" style="margin: '0' ">
			<table width="100%" class="areaFiltro"  border="0" cellpadding="0" cellspacing="0">
			<cfif LvarDesdeTesoreria>
				<tr>
					<td nowrap align="right">
						<strong>Trabajar con Tesorer&iacute;a:</strong>&nbsp;
					</td>
					<td>
						<cf_cboTESid onchange="this.form.submit();" tabindex="1">
					</td>
					<td nowrap align="right">
						<strong>Empresa Origen:</strong>&nbsp;
					</td>
					<td colspan="2">
						<cf_cboTESEcodigo name="EcodigoOri_F" tabindex="1" Tipo="TES">
					</td>
				</tr>
			</cfif>
			<tr>
				<td nowrap align="right"><strong>Centro Funcional:</strong></td>
				<td nowrap align="left">
					<cfif Attributes.Tipo NEQ "">
						<cf_cboCFid form="formFiltro" todos="yes">
						<cfset form.CFid_F = session.Tesoreria.CFid>
					<cfelseif Attributes.AprobacionSP>
						<cf_cboCFid form="formFiltro" todos="yes" AprobacionSP="yes">
						<cfset form.CFid_F = session.Tesoreria.CFid>
					<cfelseif form.CFid_F EQ "">
						<cf_rhcfuncional form="formFiltro" id="CFid_F">
					<cfelse>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							select CFid as CFid_F, CFcodigo, CFdescripcion
							  from CFuncional
							 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
						</cfquery>
						<cf_rhcfuncional form="formFiltro" id="CFid_F" query="#rsSQL#">
					</cfif>
				</td>
             </tr>
             <tr>
				<td nowrap align="right"><strong>Solicitante:</strong></td>
				<td colspan="2">
                	<cfif #Attributes.FiltarxUsuario#>
                    	<cfquery name="rsSQL" datasource="#session.dsn#">
                            select u.Usucodigo, u.Usulogin
                                , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                              from Usuario u 
                                inner join DatosPersonales dp
                                   on dp.datos_personales = u.datos_personales
                             where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                        </cfquery>
                        <cfoutput>
                        	&nbsp;#rsSQL.Usunombre#
                        </cfoutput>
                    <cfelse>
						<cfif form.UsucodigoSP_F EQ "">
                            <cf_sifusuario conlis="true" form="formFiltro" >
                        <cfelse>
                            <cfquery name="rsSQL" datasource="#session.dsn#">
                                select u.Usucodigo, u.Usulogin
                                    , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                                  from Usuario u 
                                    inner join DatosPersonales dp
                                       on dp.datos_personales = u.datos_personales
                                 where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
                            </cfquery>
                            <cf_sifusuario conlis="true" form="formFiltro" query="#rsSQL#">
                        </cfif>
                	</cfif>        
				</td>
			</tr>
			<cfif Attributes.Tipo EQ "" OR Find(Attributes.Tipo,"1,2,3,4") EQ 0>
				<tr>
					<td nowrap align="right"><strong>Beneficiario Contado:</strong></td>
					<td align="left">
						<cf_tesbeneficiarios form="formFiltro" TESBid="TESBid_F" TESBidValue="#Form.TESBid_F#" tabindex="1" size="40">
					</td>
				</tr>
			</cfif>
			<cfif Attributes.Tipo EQ "">
				<tr>
					<td nowrap align="right"><strong>Cliente Detallista:</strong></td>
					<td align="left">
						<cf_sifClienteDetCorp form="formFiltro" CDCidentificacion="CDCidentificacion_F" CDCcodigo="CDCcodigo_F" idquery="#Form.CDCcodigo_F#" tabindex="1">
					</td>
				</tr>
			</cfif>
				<tr>
				<td nowrap align="right" valign="middle"><strong>Fechas Desde:</strong></td>
				<td nowrap align="left" valign="middle">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td nowrap valign="middle">
								<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_I#" name="TESSPfechaPago_I" tabindex="1">
							</td>
							<td nowrap align="right" valign="middle"><strong>&nbsp;Hasta:</strong></td>
							<td nowrap valign="middle">
								<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_F#" name="TESSPfechaPago_F" tabindex="1">
							</td>
						</tr>
					</table>
				</td>
			  </tr>
			  <tr>
				<td nowrap align="right"><strong>Nom. Beneficiario:</strong></td>
				<td align="left">
					<input type="text" name="TESBeneficiario_F" value="<cfoutput>#form.TESBeneficiario_F#</cfoutput>"  tabindex="1">
                    <strong>Moneda:</strong>
                    <cfquery name="rsMonedas" datasource="#session.DSN#">
						select Mcodigo, Mnombre
						  from Monedas m 
						  where m.Ecodigo = #session.Ecodigo#
					</cfquery>
					
					<select name="McodigoOri_F" tabindex="1">
						<option value="">(Todas las monedas)</option>
						<cfoutput query="rsMonedas">
							<option value="#Mcodigo#" <cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F EQ Mcodigo>selected</cfif>>#Mnombre#</option>
						</cfoutput>
					</select>		
				</td>
			</tr>
			<tr>
				<td nowrap align="right"><strong>Num. Solicitud:</strong></td>
				<td align="left">
					<select name="TESSPtipoDocumento_F" id="TESSPtipoDocumento_F" <cfif Attributes.Tipo NEQ "">disabled</cfif> tabindex="1">
						<cfif Attributes.Tipo EQ ""><option value="-1">-- Todos --</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "0"><option value="0" <cfif form.TESSPtipoDocumento_F EQ 0>selected</cfif>>Solicitudes Manuales</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "5"><option value="5" <cfif form.TESSPtipoDocumento_F EQ 5>selected</cfif>>Solicitudes Manuales x Centro Funcional</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "1"><option value="1" <cfif form.TESSPtipoDocumento_F EQ 1>selected</cfif>>Pago de Documentos de CxP</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "2"><option value="2" <cfif form.TESSPtipoDocumento_F EQ 2>selected</cfif>>Pago de Anticipos de CxP</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "3"><option value="3" <cfif form.TESSPtipoDocumento_F EQ 3>selected</cfif>>Devolución de Anticipos de CxC</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "4"><option value="4" <cfif form.TESSPtipoDocumento_F EQ 4>selected</cfif>>Devolución de Anticipos de POS</option></cfif>

						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "6"><option value="6" <cfif form.TESSPtipoDocumento_F EQ 6>selected</cfif>>Pago de Anticipos a Gastos de Empleado</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "7"><option value="7" <cfif form.TESSPtipoDocumento_F EQ 7>selected</cfif>>Liquidación a Gastos de Empleado</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "8"><option value="8" <cfif form.TESSPtipoDocumento_F EQ 8>selected</cfif>>Fondos de Caja Chica</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "9"><option value="9" <cfif form.TESSPtipoDocumento_F EQ 9>selected</cfif>>Reintegro de Caja Chica</option></cfif>
						<cfif Attributes.Tipo EQ "" OR Attributes.Tipo EQ "10"><option value="10" <cfif form.TESSPtipoDocumento_F EQ 10>selected</cfif>>Transferencias entre Cuentas Bancarias</option></cfif>
					</select>
					<cfparam name="form.TESSPnumero_F" default="">
					<input type="text" name="TESSPnumero_F" id="TESSPnumero_F" value=""  tabindex="1" onKeyUp="if(snumber(this,event,' ')){ if(Key(event)=='13') {this.blur();}}">
				</td>
			<cfif Attributes.Tipo EQ "" AND not Attributes.AprobacionSP AND not LvarDesdeTesoreria>
				<td nowrap align="right" valign="middle"><strong>Estado:</strong></td>
				<td nowrap valign="middle" colspan="2">
					<select name="TESSPestado_F" id="TESSPestado_F" tabindex="1">
						<option value="-1">-- Todos --</option>
						<option value="0" <cfif form.TESSPestado_F EQ 0>selected</cfif>>En Preparación</option>
						<option value="1" <cfif form.TESSPestado_F EQ 1>selected</cfif>>En Aprobación</option>
						<option value="3" <cfif form.TESSPestado_F EQ 3>selected</cfif>>Rechazadas</option>
						<optgroup label="Aprobadas:"></optgroup>
						<option value="2" <cfif form.TESSPestado_F EQ 2>selected</cfif>>&nbsp;&nbsp;Aprobadas</option>
						<option value="202" <cfif form.TESSPestado_F EQ 202>selected</cfif>>&nbsp;&nbsp;Aprobadas con Cesiones o Embargos</option>
						<option value="212" <cfif form.TESSPestado_F EQ 212>selected</cfif>>&nbsp;&nbsp;Aplicadas sin Orden de Pago</option>
						<optgroup label="Enviados a Tesorería:"></optgroup>
						<option value="23" <cfif form.TESSPestado_F EQ 23>selected</cfif>>&nbsp;&nbsp;Rechazadas en Tesorería</option>
						<option value="10" <cfif form.TESSPestado_F EQ 10>selected</cfif>>&nbsp;&nbsp;En Preparación de Orden de Pago</option>
						<option value="11" <cfif form.TESSPestado_F EQ 11>selected</cfif>>&nbsp;&nbsp;En Emisión de Orden de Pago</option>
                        <option value="110" <cfif form.TESSPestado_F EQ 110>selected</cfif>>&nbsp;&nbsp;En Orden de Pago Sin Entregar</option>
						<option value="12" <cfif form.TESSPestado_F EQ 12>selected</cfif>>&nbsp;&nbsp;En Orden de Pago Emitida</option>
						<option value="13" <cfif form.TESSPestado_F EQ 13>selected</cfif>>&nbsp;&nbsp;En Orden de Pago Anulada</option>
						<option value="DUP" <cfif form.TESSPestado_F EQ "DUP">selected</cfif>>SOLICITUDES DUPLICADAS</option>
					</select>
				</td>
			</cfif>
			  </tr>
              <tr>
              	<td colspan="4">
					<input name="btnFiltrar" type="submit" class="btnFiltrar" id="btnFiltrar" value="Filtrar" tabindex="2"> 
                </td>
              </tr>
			</table>
		<cfif Attributes.Tipo NEQ "">
			<input type="checkbox" name="chkCancelados"
				<cfif isdefined("form.chkCancelados")>checked</cfif>
				onclick="this.form.submit();"
				tabindex="1"
				> Listar Solicitudes Canceladas
				<cfset LvarPrimera = false>
		</cfif>
		</form>
		<cfif FALSE AND LvarPrimera>
			</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center" bgcolor="#CCCCCC">
					<strong>La lista no ha sido filtrada</strong><BR>
					Asegúrese de que haya seleccionado los filtros adecuados antes de presionar <strong>Filtrar</strong>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
			<cfabort>
		<cfelse>
        	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
			<cf_dbfunction name="to_char" args="sp.TESSPid" returnvariable="lvarToCharTESSPid">
			<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
				Select
				<cfif LvarDesdeTesoreria>
					<!--- RechazoSP:  es a nivel de Tesoreria (opcion en Ordenes de Pago) --->
					#session.Tesoreria.TESid# as TESid,
				</cfif>
					  sp.TESSPid
					, TESSPnumero
					, sp.TESSPtotalPagarOri
					, m.Mnombre
					, m.Miso4217
					, sp.TESSPmsgRechazo
					, sp.TESSPfechaPagar
                    ,case when 1 = 1 then '<a style="cursor:pointer;float:none" title="Detalles" onclick="return fnObtDetalles('''#_Cat##lvarToCharTESSPid##_Cat#''')"><img border="0" align="absmiddle" style="width:25px; height:25px;" name="imagen" src="/cfmx/sif/imagenes/Page_Load.gif"></a>'  end as detalle
					, case 
						when sp.SNcodigoOri is not null then
							(
								select coalesce(sn.SNnombrePago, sn.SNnombre)  from SNegocios sn where sn.Ecodigo = sp.EcodigoOri and sn.SNcodigo=sp.SNcodigoOri
							)
						when sp.TESBid is not null then
							(
								select tb.TESBeneficiario from TESbeneficiario tb where tb.TESBid = sp.TESBid
							)
						else
							(
								select cd.CDCnombre from ClientesDetallistasCorp cd where cd.CDCcodigo=sp.CDCcodigo
							)
						end
						#LvarCNCT# ' <strong>'#LvarCNCT# coalesce(sp.TESOPbeneficiarioSuf, '') #LvarCNCT# '</strong>' as Nombre
					, case sp.TESSPestado
							when  0 then 'En Preparación'
							when  1 then 'En Aprobación'
							when  2 then 'Aprobada'
							when  3 then 'Rechazada'
							when 23 then 'Rechazada en Tesorería'
							when 10 then 'Preparando OP=' #LvarCNCT# coalesce(<cf_dbfunction name="to_char" args="op.TESOPnumero">,'***')
							when 11 then 'Emitiendo OP=' #LvarCNCT# <cf_dbfunction name="to_char" args="op.TESOPnumero"> 
                            when 110 then 'Sin Aplicar OP=' #LvarCNCT# <cf_dbfunction name="to_char" args="op.TESOPnumero"> 
							when 12 then 'Pagada en OP=' #LvarCNCT# <cf_dbfunction name="to_char" args="op.TESOPnumero">
							when 13 then 'Anulada en OP=' #LvarCNCT# <cf_dbfunction name="to_char" args="op.TESOPnumero">
							when 101 then 'Aprobando OP=' #LvarCNCT# <cf_dbfunction name="to_char" args="op.TESOPnumero">
							when 103 then 'Rechazada en OP=' #LvarCNCT# <cf_dbfunction name="to_char" args="op.TESOPnumero">
							when 202 then 'Aprobada con Cesiones'
							when 212 then 'Aplicada sin OP.'
							else 'Estado desconocido'
						end as TESSPestado
					, case sp.TESSPtipoDocumento
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
					end as Origen
					, 10 as PASO
						<cfif isdefined("form.chkCancelados")>
						,	1 as chkCancelados
						</cfif>
						, case when <cf_dbfunction name="length" args="sp.TESSPmsgRechazo"> > 1 then
							'<span onclick="sbVer(' #LvarCNCT# <cf_dbfunction name="to_Char" args="sp.TESSPid"> #LvarCNCT# ');" style="cursor:help;">SÍ</span>'
						  end as MSG
					, 'Empresa Origen: ' #LvarCNCT# e.Edescripcion as Edescripcion
					,( 
						select rtrim(o.Oficodigo) #LvarCNCT# ':' #LvarCNCT# cf.CFcodigo
						from CFuncional cf 
							inner join Oficinas o on o.Ecodigo = cf.Ecodigo and o.Ocodigo = cf.Ocodigo 
						where cf.CFid = sp.CFid
					) as CFcodigo
					, u.Usulogin
				from TESsolicitudPago sp
					inner join Empresas e
					   on e.Ecodigo=sp.EcodigoOri
	
					inner join Monedas m
					   on m.Ecodigo=sp.EcodigoOri
					  and m.Mcodigo=sp.McodigoOri
				
					inner join Usuario u
						on u.Usucodigo=sp.UsucodigoSolicitud
				
					inner join DatosPersonales dp
						on dp.datos_personales=u.datos_personales
	
					left outer join TESordenPago op
						on op.TESOPid = sp.TESOPid

			<cfif LvarDesdeTesoreria>
				<!--- RechazoSP:  es a nivel de Tesoreria (opcion en Ordenes de Pago) --->
				where sp.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				<cfif len(trim(form.EcodigoOri_F))>
					and sp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoOri_F#">				
				</cfif>
			<cfelse>
				where sp.EcodigoOri= #session.Ecodigo# 
				<cfif Attributes.Tipo NEQ "">
					<cfif session.Tesoreria.CFid LT 0>
						<!--- Todos los Centros Funcionales, todos los CFs del aprobador y sin CF --->
						and (	sp.CFid is NULL
							 OR 
								(
									select count(1) from TESusuarioSP tu
									 where tu.Usucodigo = #session.Usucodigo#
									   and tu.CFid		= sp.CFid
									   and tu.TESUSPsolicitante = 1
								) > 0
						)
					<cfelseif session.Tesoreria.CFid EQ 0>
						<!--- Sin Centro Funcional, sin CF (TEMPORAL PARA LOS VIEJOS) --->
						and sp.CFid is NULL
					<cfelse>
						<!--- Un Centro Funcional --->
						and sp.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">
					</cfif>				
					<cfset form.CFid_F = "">
				<cfelseif Attributes.AprobacionSP>
					<cfif session.Tesoreria.CFid LT 0>
						<!--- Todos los Centros Funcionales, todos los CFs del aprobador y sin CF --->
						and (	sp.CFid is NULL
							 OR 
								(
									select count(1) from TESusuarioSP tu
									 where tu.Usucodigo = #session.Usucodigo#
									   and tu.CFid		= sp.CFid
									   and tu.TESUSPaprobador = 1
								) > 0
							)
					<cfelseif session.Tesoreria.CFid EQ 0>
						<!--- Sin Centro Funcional, sin CF (TEMPORAL PARA LOS VIEJOS) --->
						and sp.CFid is NULL
					<cfelseif session.Tesoreria.CFid_subordinados EQ 0>
						<!--- No subordinados, los del CF --->
						and sp.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">
					<cfelse>
						<!--- Subordinados, todos los de los CFs subordinados --->
						and 
							(
								select count(1) from CFuncional CFsub
								 where CFsub.Ecodigo	= sp.EcodigoOri
								   and CFsub.CFid		= sp.CFid
								   and CFsub.CFpath 	like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(session.Tesoreria.CFid_subPath) & "%"#">
							) > 0
					</cfif>				
					<cfset form.CFid_F = "">
				</cfif>
			</cfif>
				<cfif Attributes.AprobacionSP>
					and sp.TESSPestado = 1
					and NOT exists
						(
							select 1 
								from TESTramiteSolPago 
								where CFid = sp.CFid
						)

				<cfelseif LvarDesdeTesoreria>
					and TESSPestado in (2,10)
				<cfelseif isdefined("form.chkCancelados")>
					and sp.TESSPestado in (3,13,23,103)
					and TESSPidDuplicado is null
				<cfelseif isdefined('form.TESSPestado_F') and form.TESSPestado_F EQ "DUP">
					and sp.TESSPidDuplicado is not null
				<cfelseif isdefined('form.TESSPestado_F') and len(trim(form.TESSPestado_F)) and form.TESSPestado_F NEQ '-1'>
					and sp.TESSPestado=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESSPestado_F#">
				</cfif>
	
				<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
					and sp.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
				</cfif>				
	
				<cfif len(trim(form.TESSPtipoDocumento_F)) and form.TESSPtipoDocumento_F NEQ '-1'>
					and sp.TESSPtipoDocumento=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESSPtipoDocumento_F#">
				</cfif>				
	
				<cfif len(trim(form.UsucodigoSP_F))>
					and sp.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#UsucodigoSP_F#">				
				</cfif>
				
				<cfif isdefined('form.TESSPnumero_F') and len(trim(form.TESSPnumero_F))>
					and TESSPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPnumero_F#">
				<cfelse>
					<!--- Por Fechas desde y hasta --->
					<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
						and TESSPfechaPagar <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.TESSPfechaPago_F)#">
					</cfif>	
					<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
						and TESSPfechaPagar >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.TESSPfechaPago_I)#">
					</cfif>	

					<!--- Por Códigos o Nombres de Socio, Beneficiario o Cliente Detallista --->
					<cfif len(trim(form.SNcodigo_F))>
						and sp.SNcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo_F#">				
					<cfelseif len(trim(form.TESBid_F))>
						and sp.TESBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid_F#">				
					<cfelseif len(trim(form.CDCcodigo_F))>
						and sp.CDCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo_F#">				
					<cfelseif isdefined('form.TESBeneficiario_F') and len(trim(form.TESBeneficiario_F))>
						and upper(
							case 
								when sp.SNcodigoOri is not null then
									(
										select coalesce(sn.SNnombrePago, sn.SNnombre)  from SNegocios sn where sn.Ecodigo = sp.EcodigoOri and sn.SNcodigo=sp.SNcodigoOri
									)
								when sp.TESBid is not null then
									(
										select tb.TESBeneficiario from TESbeneficiario tb where tb.TESBid = sp.TESBid
									)
								else
									(
										select cd.CDCnombre from ClientesDetallistasCorp cd where cd.CDCcodigo=sp.CDCcodigo
									)
							end #LvarCNCT# ' ' #LvarCNCT# sp.TESOPbeneficiarioSuf
								) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.TESBeneficiario_F))#%">					
					</cfif>					
		
					<!--- Por Moneda --->
					<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
						and sp.McodigoOri=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
					</cfif>
				</cfif>	
                
                <cfif isdefined('Attributes.FiltarxUsuario') and #Attributes.FiltarxUsuario#>
                	and u.Usucodigo= #session.Usucodigo#
                </cfif>

				<cfif LvarDesdeTesoreria>
					<cfset LvarCortes = "Edescripcion">
					order by sp.EcodigoOri, sp.TESSPnumero
				<cfelse>
					<cfset LvarCortes = "">
					order by sp.TESSPnumero
				</cfif>
			</cfquery>
			<cfif isdefined("form.chkCancelados")>
				<cfset LvarMSGrechazo = "Motivo<br>Cancelación">
			<cfelseif Attributes.Tipo NEQ "">
				<cfset LvarMSGrechazo = "Motivo<br>Rechazo<BR>Anterior">
			<cfelse>
				<cfset LvarMSGrechazo = "Motivo<br>Rechazo">
			</cfif>
			<cfif Attributes.AprobacionSP>
				<cfset LvarAprobarCHK="S">
				<cfset LvarAprobarBTN="Aprobar">
			<cfelse>
				<cfset LvarAprobarCHK="N">
				<cfset LvarAprobarBTN="">
			</cfif>
            <cf_Lightbox link="" Titulo="Detalle de Tesoreria" width="95" height="95" name="DetaTeso" url="/cfmx/proyecto7/solicitudesAprobar_form.cfm"></cf_Lightbox>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				Cortes="#LvarCortes#"
				desplegar="Origen,TESSPnumero,Nombre,TESSPfechaPagar,Miso4217,TESSPtotalPagarOri,TESSPestado,Usulogin,detalle"
				etiquetas="Tipo,Num.<BR>Solicitud,Nombre Beneficiario,Fecha Pago<BR>Solicitada, Moneda, Total Pago<BR>Solicitado, Estado, Solicitante,Detalle"
				formatos="S,I,S,D,S,M,S,S,S"
				align="left,left,left,center,right,right,center,left,center"
				ira="#Attributes.IrA#"
				form_method="post"
				showEmptyListMsg="yes"
                showlink="false"
				keys="TESSPid"	
				MaxRows="15"
				navegacion="#navegacion#"
				filtro_nuevo="#isdefined("form.btnFiltrar")#"
				usaAJAX = "no"
			/>		
		</cfif>	<!---	botones="#LvarAprobarBTN#"	checkboxes="#LvarAprobarCHK#"--->
	</td>
  </tr>
</table>
<iframe name="ifrDescripcion" id="ifrDescripcion" src="" width="0" height="0">
</iframe>
<script language="javascript">
	function fnValidaCampos(){
		error="";
		valor1 = document.getElementById("TESSPnumero_F").value;	
		if(!fnValidaNumero(valor1) && valor1 !="" ){
			error += "\n - El campo Num. Solicitud debe ser numérico.";
			document.getElementById("TESSPnumero_F").value="";
		}
		if(error!=""){
			alert("Se presentaron los sigiuentes problemas:"+error);
			return false;
		}else{
			return true;
		}
		
	}
	function fnValidaNumero(valor){
		valor = parseInt(valor)
		
      //Compruebo si es un valor numérico
      if (isNaN(valor)) {
            //entonces (no es numero) devuelvo false
            return false
      }else{
            //En caso contrario (Si era un número) devuelvo el true
            return true
      } 
	}	
	function sbVer(TESSPid)
	{
		var LvarIframe = document.getElementById("ifrDescripcion");
		<cfoutput>
		LvarIframe.src = "#Attributes.IrA#?sbVer=1&SP=" + TESSPid;
		</cfoutput>
		document.lista.nosubmit = true;		
	}
<cfif Attributes.AprobacionSP>
	function funcAprobar()
	{
		if (!confirm("¿Desea Aprobar las solicitudes seleccionadas?"))
		{
			document.lista.nosubmit = false;
			return false;
		}
	}
</cfif>

function fnObtDetalles(TESSPid){         
	fnLightBoxSetURL_DetaTeso("/cfmx/proyecto7/solicitudesAprobar_form.cfm?TESSPid="+TESSPid);
	fnLightBoxOpen_DetaTeso();
}
</script>
