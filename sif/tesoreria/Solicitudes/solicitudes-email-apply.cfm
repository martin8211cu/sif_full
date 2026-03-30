<!--- Consultas --->
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
		 where a.EcodigoOri			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and a.TESSPid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
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
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
		</cfquery>
    <cfelse>
    	<cfset hdr.SNnombre = ""> 	
    </cfif>	         
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

<!--- Asignacion de variables --->
<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset email_from = Politicas.trae_parametro_global("correo.cuenta")>
<cfif len(triM(email_from)) EQ 0>
	<cfset email_from = "spago@nacion.com">
</cfif>
<cfset email_subject = "Aprobacion de Solicitud de Pago #rsForm.TESSPnumero#">
<cfset email_to = form.email >
<cfset email_cc = ''>
<cfquery name="rsPvalor" datasource="#session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Pcodigo = 15500
</cfquery>
<cfsavecontent variable="email_body" >
	<html>
		<head>
			<style type="text/css">
				.tituloIndicacion {
					font-size: 10pt;
					font-variant: small-caps;
					background-color: #CCCCCC;
				}
				.tituloListas {
					font-weight: bolder;
					vertical-align: middle;
					padding: 2px;
					background-color: #F5F5F5;
				}
				.listaNon { 
					background-color:#FFFFFF; 
					vertical-align:middle; 
					padding-left:5px;
				}
				.listaPar { 
					background-color:#FAFAFA; 
					vertical-align:middle; 
					padding-left:5px;
				}
				body,td {
					font-size: 12px;
					background-color: #f8f8f8;
					font-family: Verdana, Arial, Helvetica, sans-serif;
				}
			</style>
		</head>
		<body>
        <cfoutput>
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
                <tr>
                    <td colspan="3">
					   <!---se hace la pregunta para saber cual link usar--->
						<cfif rsPvalor.recordcount and rsPvalor.Pvalor EQ 1>
                            Para visualizar las Solicitud de Pago haga click <a href="http://#session.sitio.host#/cfmx/proyecto7/tesoreria.cfm">aquí</a>.
                       	</cfif>
                    </td>
                </tr>
            </table>
            </cfoutput>
		</body>
	</html>
</cfsavecontent>
<cfset LvarSNnombre = email_to>
<cfset LvarSNnombreCC = email_cc>
<cfset LvarSNnombreCC = replace(LvarSNnombreCC,',',' ' ,'all')>
<cfset LvarSNnombreCC = replace(LvarSNnombreCC,';',' ' ,'all')>

	<cfmail from="#email_from#" to="#PreserveSinglequotes(LvarSNnombre)#" subject="#email_subject#" type="html">
        #email_body#
	</cfmail>	

<cflocation url = "solicitudes-email-enviado.cfm?TESSPnumero=#URLEncodedFormat(rsForm.TESSPnumero)#&email=#URLEncodedFormat(form.email)#&Ccemail=#URLEncodedFormat(email_cc)#">
