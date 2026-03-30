<cfif NOT ISDEFINED('URL.CMPid')>
	No se pudo recuperar el id del proceso<cfabort>
</cfif>
<cfquery name="rsProcesoP" datasource="#Session.DSN#">
    select b.SNcodigo, a.CMPid, pc.CMPdescripcion, pc.CMPfechapublica, pc.CMPfmaxofertas, b.SNemail, b.Ecodigo
    from CMProveedoresProceso a
    	inner join SNegocios b
        	on a.Ecodigo  = b.Ecodigo
    	   and a.SNcodigo = b.SNcodigo
        inner join CMProcesoCompra pc
        	on pc.CMPid = a.CMPid
    where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.CMPid#">
      and b.SNtiposocio <> 'C'
	  order by 1
</cfquery>
<cfset LvarEmailPARA ="">
<cfloop query="rsProcesoP">
	<cfquery name="rsContactoSN" datasource="#session.DSN#">
            select SNCemail 
            from SNContactos
            where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsProcesoP.Ecodigo#">
              	and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsProcesoP.SNcodigo#">
              and SNCarea = 1
    </cfquery>
	<cfif LEN(TRIM(rsProcesoP.SNemail)) and NOT rsProcesoP.SNemail EQ "[NULL]">
    	<cfif LEN(TRIM(LvarEmailPARA))>
        	<cfset LvarEmailPARA = LvarEmailPARA & ";">	
        </cfif>
        	<cfset LvarEmailPARA = LvarEmailPARA & rsProcesoP.SNemail>	
    </cfif>
	<cfif rsContactoSN.recordcount gt 0>
		<cfloop query="rsContactoSN">
			<cfif LEN(TRIM(SNCemail)) and NOT SNCemail EQ "">
				<cfif LEN(TRIM(LvarEmailPARA))>
					<cfset LvarEmailPARA = LvarEmailPARA & ";"></br>	
				</cfif>
				<cfset LvarEmailPARA = LvarEmailPARA & SNCemail>	</br>	
			</cfif>
		</cfloop>
	</cfif>
</cfloop>

<cfset enviadoPor    = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">

<cfset LvarEmailCC   = "">
<cfset LvarAsunto    = "Invitación Proceso Compra: #rsProcesoP.CMPdescripcion#">
<cfset url.opcion    = 'proveedor'>
<cfset url.local     = 1>
<cfset Session.Compras.ProcesoCompra.CMPid = url.CMPid>
<cfset LvarTitle 	  = 'Invitación al proceso de compra'>
<cfset LvarXproveedor = FALSE>

<cfsavecontent variable="miHTML">
	<cfinclude template="/sif/cm/operacion/ConlisReporte.cfm">
</cfsavecontent>

<!---<cfset miHTML		 = mailBody('#rsProcesoP.CMPdescripcion#', '#rsProcesoP.CMPfechapublica#', '#rsProcesoP.CMPfmaxofertas#')>
--->

<cf_web_portlet_start border="true" titulo="Envío de Correo" skin="#Session.Preferences.Skin#">        
<cfoutput>
    <form action="ProcesoCompra-send.cfm" name="form1" id="form1" method="post"<!--- onSubmit="return validar(this)"--->>
        <input type="hidden" name="EOidorden" id="EOidorden" value="#HTMLEditFormat(rsProcesoP.CMPid)#">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
            <tr>
                <td class="subTitulo tituloListas">&nbsp;</td>
                <td colspan="3" class="subTitulo tituloListas">
                    <img src="OrdenesCompra-email.gif" width="37" height="12">&nbsp;&nbsp;Envío de Correo
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>De:</td>
                <td>&nbsp;</td>
                <td><input size="60" type="text" readonly="" value="#enviadoPor#"></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>Para:</td>
                <td>&nbsp;</td>
                <td><input size="60" type="text" name="SMTPdestinatario" id="SMTPdestinatario" onFocus="this.select()" value="">&nbsp;Use punto y coma ';' como separador</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>CC:</td>
                <td>&nbsp;</td>
                <td><input size="60" type="text" name="SMTPcc" id="SMTPcc" onFocus="this.select()" value="">&nbsp;Use punto y coma ';' como separador</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>BCC:</td>
                <td>&nbsp;</td>
                <td><input size="60" type="text" name="SMTPbcc" id="SMTPbcc" onFocus="this.select()" value="#HTMLEditFormat(Trim(LvarEmailPARA))#">&nbsp;Use punto y coma ';' como separador</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>Asunto:</td>
                <td>&nbsp;</td>
                <td><input size="60" type="text" name="SMTPasunto" id="SMTPasunto" readonly="" value="#LvarAsunto#"></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td colspan="3">
                    <input type="submit" class="btnEmail" value="Enviar" name="btnEnviar" class="btnAplicar">
                </td>
            </tr>
            <tr>
                <td colspan="4"><hr></td>
            </tr>
        </table>
        <cf_sifeditorhtml name="DFtexto" indice="1" value="#miHTML#" height="400" toolbarset="Default">
    </form>
</cfoutput>
<cf_web_portlet_end>
<cffunction name="mailBody" returntype="string">
	<cfargument name="CMPdescripcion"  type="string" required="yes">
    <cfargument name="CMPfechapublica" type="date"   required="yes">
    <cfargument name="CMPfmaxofertas"  type="date"   required="yes">

	<cfsavecontent variable="_mail_body">
		
		<style type="text/css">
		<!--
		.style1 {
			font-size: 10px;
			font-family: "Times New Roman", Times, serif;
		}
		.style2 {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-weight: bold;
			font-size: 14;
		}
		.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
		.style8 {font-size: 14}
		
		.style9 {font-size: 13}
		-->
		</style>
		</head>
		
		<body>

		<cfoutput>
		  <table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			<tr bgcolor="##003399">
			  <td colspan="2" height="24"></td>
			</tr>
			<tr bgcolor="##999999">
			  <td colspan="2"> <strong>Invitación a Proceso de Compra</strong> </td>
			</tr>
			<tr>
			  <td width="70">&nbsp;</td>
			  <td width="476">&nbsp;</td>
			</tr>
			<tr>
			  <td><span class="style2">De</span></td>
			  <td><span class="style7">#session.Enombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>

			<tr>
			  <td><span class="style7"><strong>Asunto</strong></span></td>
			  <td>
			  	<span class="style7">Invitación a Proceso de Compra.</span>
			  </td>
			</tr>
		
			<tr>
			  <td colspan="2">
				<table border="0" width="100%" cellpadding="2" cellspacing="0" > 
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Proceso de Compra:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#Arguments.CMPdescripcion#</span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Fecha de Publicación:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#LSDateFormat(Arguments.CMPfechapublica,'dd/mm/yyyy')#</span></td>
					</tr>

					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Fecha maxima para recibir ofertas:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#LSDateFormat(Arguments.CMPfmaxofertas,'dd/mm/yyyy')#</span></td>
					</tr>

					<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
				</table>
			  </td>
			</tr>
				
			<cfset hostname = session.sitio.host>
			<cfset Usucodigo = session.Usucodigo>
			<cfset CEcodigo = session.CEcodigo>
		
			<!---<tr>
			  <td>&nbsp;</td>
			  <td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
			  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span></td>
			</tr>--->
		
		  </table>
		</cfoutput>
	</cfsavecontent>

	<cfreturn _mail_body >
</cffunction>
