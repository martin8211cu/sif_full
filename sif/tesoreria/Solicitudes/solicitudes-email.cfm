<cfparam name="url.Ecodigo" default="#Session.Ecodigo#">
<cfparam name="url.TESSPid" default="0">
<cf_templateheader title="Envío solicitud de pago para aprobacion">
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select 
			a.TESSPid, 
			a.TESSPfechaSolicitud,
			a.TESSPnumero,
			a.SNcodigoOri,
			a.TESSPfechaPagar,
			a.McodigoOri,
			a.TESBid, sn.SNid,
			a.TESSPtipoCambioOriManual,
			a.TESSPtotalPagarOri,
			a.TESSPmsgRechazo,
			a.CFid,
			b.Ocodigo,
			a.BMUsucodigo,
			a.ts_rversion,
			a.TESSPtotalPagarOri
			,TESOPobservaciones
			,TESOPinstruccion
			,TESOPbeneficiarioSuf
			
			,(select count(1) from TESdetallePago where TESSPid = a.TESSPid)
			as Sufciencias

		  from TESsolicitudPago a
				left outer join CFuncional b
					on b.CFid 		= a.CFid
					and b.Ecodigo 	= a.EcodigoOri
				left outer join SNegocios sn
					on sn.SNcodigo	= a.SNcodigoOri
					and sn.Ecodigo 	= a.EcodigoOri
		 where a.EcodigoOri			= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
		   and a.TESSPid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>
    <cfquery name="rsMoneda" datasource="#session.DSN#">
        select Mcodigo, Mnombre
        from Monedas
        where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.McodigoOri#">
            and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    <cfif  rsForm.TESBid gt 0 > 
       <cfquery name="hdr" datasource="#session.dsn#">
            select TESBeneficiarioId, TESBeneficiario as SNnombre, TESBid 
            from TESbeneficiario 
            where CEcodigo   = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Session.CEcodigo#" >
              and TESBid     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsForm.TESBid#">
              and TESBactivo = 1
        </cfquery>
	<cfelseif rsForm.SNid gt 0>
    	<cfquery name="hdr" datasource="#session.dsn#">
			select a.SNnombre, a.SNcodigo
			from  SNegocios a
			where a.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsForm.SNid#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#url.Ecodigo#">
		</cfquery>
    <cfelse>
    	<cfset hdr.SNnombre = ""> 	
    </cfif>	
<!---     tu.Usucodigo, tu.CFid
                , tu.TESUSPaprobador
                , tu.TESUSPmontoMax
                , u.Usulogin--->           
    <cfquery name="Cfuncional" datasource="#session.dsn#">
        select distinct dp.Pemail1      
        from TESusuarioSP tu
            inner join Usuario u
                inner join DatosPersonales dp
                   on dp.datos_personales = u.datos_personales
                on u.Usucodigo = tu.Usucodigo
            inner join CFuncional cf
                on cf.CFid = tu.CFid
        where tu.CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
        	and tu.TESUSPaprobador = 1
          	and (tu.TESUSPmontoMax 	= 0 or tu.TESUSPmontoMax 	> <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsForm.TESSPtotalPagarOri#">)
    </cfquery>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Envío solicitud de pago para aprobacion'>
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#" >
	
			<cfoutput>
				<form action="solicitudes-email-apply.cfm" name="form1" id="form1" method="post" onSubmit="return validar(this)">
					<input type="hidden" name="TESSPid" id="TESSPid" value="#url.TESSPid#">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td class="subTitulo tituloListas">&nbsp;</td>
							<td colspan="3" class="subTitulo tituloListas">
								<img src="solicitudes-email.gif" width="37" height="12">&nbsp;&nbsp;Env&iacute;o solicitud pago para aprobaci&oacute;n.
							</td>
	  					</tr>
						<tr>
							<td>&nbsp;</td>
							<td>De:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" readonly="" value="#enviadoPor# "></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Para:</td>
	  						<td>&nbsp;</td>
                            <cfset emails ="">
                            <cfloop query="Cfuncional">
                            	<cfset emails = #emails# & #Cfuncional.Pemail1# & ";">
                           	</cfloop>
	  						<td><input size="60" type="text" name="email" id="email" onFocus="this.select()" value=" #HTMLEditFormat(Trim(emails))#">&nbsp;Use punto y coma ';' como separador </td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Asunto:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" readonly="" value="Aprobacion de Solicitud de Pago #HTMLEditFormat(rsForm.TESSPnumero)#"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
	  						<td colspan="3">
								<input type="submit" value="Enviar" name="btnEnviar">
							</td>
	  					</tr>
						<tr>
	  						<td colspan="4"><hr></td>
	  					</tr>
					</table>

                    <table>
                       	<tr>
							<td colspan="3"> Sistema de Tesorería. La siguiente Solicitud de Pago requiere de su aprobación</td>
						</tr>
						<tr>
							<td>Solicitud:</td>
	  						<td colspan="2">
								#HTMLEditFormat(rsForm.TESSPnumero)#
							</td>
	  					</tr>
						<tr>
							<td>Fecha Solicitud:</td>
	  						<td colspan="2">
								#LSDateFormat(rsForm.TESSPfechaSolicitud,'DD/MM/YYYY')#
							</td>
	  					</tr>
                       	<tr>
							<td>Moneda:</td>
	  						<td colspan="2">
								#rsMoneda.Mnombre#
							</td>
	  					</tr>
                       	<tr>
							<td>Monto:</td>
	  						<td colspan="2">
								#NumberFormat(rsForm.TESSPtotalPagarOri,',0.00')#
							</td>
	  					</tr>
                        <tr>
							<td>Beneficiario:</td>
	  						<td colspan="2">
								#hdr.SNnombre#
							</td>
	  					</tr>
                    </table>
				</form>
	</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>

<cfoutput>
<cf_qforms form="form1">
	<script language="javascript" type="text/javascript">
		objForm.email.description="#JSStringFormat('E-mail')#";
		
		function habilitarValidacion() {
			objForm.email.required = true;
		}
		
		function deshabilitarValidacion() {
			objForm.email.required = false;
		}
		
		habilitarValidacion();
		
		function isEmail(s){
			return /^[\w\.-]+@[\w-]+(\.[\w-]+)+$/.test(s);
		}
			
		function validar(f){
			if (f.email.value.length < 5) {
				alert ('Por favor indique la direccion de correo de proveedor');
				return false;
			}
			return true;
		}
	</script>
</cfoutput>


