<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">

<cfparam name="url.tipo" default="">
<cfparam name="url.cedula" default="">
<cfparam name="form.tipo" default="#url.tipo#">
<cfparam name="form.cedula" default="#url.cedula#">

<cfset LvarSERVIDOR_SOA = "10.7.7.216">
<cfset LvarPUERTO_SOA = "7001">
<cfset LvarPUERTO_OSB = "7021">
<cfif isdefined("btn1")>
	<cfset LvarOpc = 1>
	<cfset LvarWSDL = "http://#LvarSERVIDOR_SOA#:#LvarPUERTO_OSB#/OSB/personaJuridicaOSB?WSDL">
<cfelseif isdefined("btn2")>
	<cfset LvarOpc = 2>
	<cfset LvarWSDL = "http://#LvarSERVIDOR_SOA#:#LvarPUERTO_OSB#/OSB/estadosPersonaBPEL?WSDL">
<cfelseif isdefined("btn3")>
	<cfset LvarOpc = 3>
	<cfset LvarWSDL = "http://#LvarSERVIDOR_SOA#:#LvarPUERTO_OSB#/OSB/estadosPersonaWF?WSDL">
<cfelse>
	<cfset LvarWSDL = "http://#LvarSERVIDOR_SOA#:#LvarPUERTO_SOA#/soa-infra/services/default/estadosPersona/consultarWS?WSDL">
	<cfset LvarOpc = 0>
</cfif>

<cfif LvarOpc EQ 0>
	<form action="test_SOA.cfm" method="post">
		<p>Tipo:&nbsp;&nbsp;&nbsp;&nbsp;
			<select name="tipo" id="tipo">
				<option value="J" <cfif form.tipo EQ "J">selected</cfif>>Juridica</option>
				<option value="F" <cfif form.tipo EQ "F">selected</cfif>>Fisica</option>
			</select>
			<BR>
		Cedula: 
		<input name="cedula" size="10" value="<cfoutput>#form.cedula#</cfoutput>"/>
		</p>
		<hr>
		<p>OPCION 1: Implementación de Transformación y Agregación únicamente por OSB (Persona Jurídica)</p>
		<p><img src="personaJuridicaOSB.jpg" width="621" height="106" />
		<input type="submit" value="Invocar" name="btn1" 
				onclick="
					if (document.getElementById('tipo').value != 'J') {alert('Sólo se puede invocar con Persona Jurídica'); return false;}
					if (document.getElementById('cedula').value == '') {alert('Favor digitar la Cédula'); return false;}
				"
		/>
		</p>

		<hr>
		<p>OPCION 2: Implementación de Transformación, Agregación, Orquestación y Monitoreo por OSB+BPEL+BAM (Persona Física y Jurídica)</p>
		<p><img src="estadosPersonaOSB_BPEL_BAM.jpg" width="621" height="172" />
		<input type="submit" value="Invocar" name="btn2" 
				onclick="
					if (document.getElementById('cedula').value == '') {alert('Favor digitar la Cédula'); return false;}
				"
		/>
		</p>

		<cfparam name="session.BAM" default="false">
		<cfif isdefined("url.BAM")>
			<cfset session.BAM = (url.BAM EQ 1)>
		</cfif>
		<hr>
		<p>OPCION 3: Implementación de Transformación, Agregación, Orquestación, Monitoreo e Interacción Humana por OSB, BPEL, BAN y HumanWorkFlow (Persona Física y Jurídica)</p>
		<p><img src="estadosPersonaOSB_BPEL_WF.jpg" width="621" height="172" />
		<input type="submit" name="btn3" 
				value="Invocar"
				onclick="
					if (document.getElementById('cedula').value == '') {alert('Favor digitar la Cédula'); return false;}
				"
		/>
		</p>
	</form>
<cfelse>
	<cfset LvarCedulaJur = createObject("component","P_Cedula")>

	<cfset LvarCedulaJur.tipoCedula=form.tipo>
	<cfset LvarCedulaJur.numeroCedula=form.cedula>
	<cfinvoke 	webservice="#LvarWSDL#"
				method="getEstadosPersona"
				returnVariable="LvarResult"
	
				parameters="#LvarCedulaJur#"
	>
	<cfoutput>
	<cfif LvarOpc EQ 1>
		<p>OPCION 1: Implementación de Transformación y Agregación únicamente por OSB (Persona Jurídica)</p>
		<p><img src="personaJuridicaOSB.jpg" width="621" height="106" />
			<input type="button" value="Regresar" onclick="location.href='test_SOA.cfm?tipo=#form.tipo#&cedula=#form.cedula#'" />
		</p>
	<cfelseif LvarOpc EQ 2>
		<p>OPCION 2: Implementación de Transformación, Agregación, Orquestación y Monitoreo por OSB+BPEL+BAM (Persona Física y Jurídica)</p>
		<p><img src="estadosPersonaOSB_BPEL_BAM.jpg" width="621" height="172" />
			<input type="button" value="Regresar" onclick="location.href='test_SOA.cfm?tipo=#form.tipo#&cedula=#form.cedula#'" />
			<input type="button" value="Monitoreo" onclick="sbPopupWindow();" />
		</p>
	<cfelseif LvarOpc EQ 3>
		<p>OPCION 3: Implementación de Transformación, Agregación, Orquestación, Monitoreo e Interacción Humana por OSB, BPEL, BAN y HumanWorkFlow (Persona Física y Jurídica)</p>
		<p><img src="estadosPersonaOSB_BPEL_WF.jpg" width="621" height="172" />
			<input type="button" value="Regresar" onclick="location.href='test_SOA.cfm?tipo=#form.tipo#&cedula=#form.cedula#'" />
			<input type="button" value="Monitoreo" onclick="sbPopupWindow();" />
			<input type="button" value="Aprobacion Manual" 
				<cfif form.tipo EQ "F">
					onclick="sbPopupWindow2();" />&nbsp;usuario01/weblogic
				<cfelse>
					onclick="alert('El proceso manual de Aprobación sólo se requiere para Personas Físicas');" />
				</cfif>
		</p>
	</cfif>
		<hr>
		<strong>SERVICIO: #LvarWSDL#</strong><BR>
		<hr>
		<strong>METODO:	getEstadosPersona</strong><BR>
		Nombre 	= #LvarResult.getNOMBRE()#<BR>
		Estado_RN	= #LvarResult.getESTADO_RN()#<BR>
		Estado_CCSS	= #LvarResult.getESTADO_CCSS()#<BR>
		Estado_TD	= #LvarResult.getESTADO_TD()#<BR>
		<hr>
	</cfoutput>
	<cfif LvarOpc EQ 1>
		<strong>DEFINICION DEL PROYECTO PersonaJuridicaOSB en el OSB</strong><BR>
		<IMG src="osbPersonaJuridica.jpg" />
	</cfif>
	<cfif LvarOpc EQ 2>
		<strong>DEFINICION DEL PROYECTO EstadosPersonaBPEL en el SOA Suite</strong><BR>
		<IMG src="osbBpelEstadosPersona.jpg" />
		<br>
		<cfif form.tipo EQ "F">
			<strong>DEFINICION DEL BPEL PARA PERSONA FISICA (implementación en Serie)</strong><BR>
			<IMG src="bpelFisico.jpg" />
		<cfelse>
			<strong>DEFINICION DEL BPEL PARA PERSONA JURIDICA (implementación en Paralelo)</strong><BR>
			<IMG src="bpelJuridico.jpg" />
		</cfif>
	</cfif>
	<cfif LvarOpc EQ 3>
		<strong>DEFINICION DEL PROYECTO EstadosPersonaWF en el SOA Suite</strong><BR>
		<IMG src="osbBpelEstadosPersona2.jpg" />
		<br>
		<cfif form.tipo EQ "F">
			<strong>DEFINICION DEL BPEL PARA PERSONA FISICA (implementación en Serie e inicializa HumanWorkFlow)</strong><BR>
			<IMG src="bpelFisico2.jpg" />
		<cfelse>
			<strong>DEFINICION DEL BPEL PARA PERSONA JURIDICA (implementación en Paralelo)</strong><BR>
			<IMG src="bpelJuridico2.jpg" />
		</cfif>
	</cfif>
</cfif>

<script language="javascript">
		var LvarPopupWin = null;
		function sbPopupWindow()
		{		
			var URLStr='http://10.7.7.216:7001/OracleBAM/6512/reportserver/default.jsp?Event=viewReport&ReportDef=7&Buttons=False&ReportParameters=()&c=<cfoutput>#getTickCount()#</cfoutput>';
			var left 	= 0;
			var top		= 0;
			var width	= 1024;
			var height	= 800;

			if(LvarPopupWin)
			{
				if(!LvarPopupWin.closed) LvarPopupWin.close();
			}
			LvarPopupWin = open(URLStr, 'MonitoreoBAM', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			if (! LvarPopupWin && !document.popupblockerwarning) 
			{
				alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
				document.popupblockerwarning = 1;
			}
			else
			{
				if(LvarPopupWin.focus) LvarPopupWin.focus();
			}
			return true;
		}
		function sbPopupWindow2()
		{		
			var URLStr='http://10.7.7.216:7001/integration/worklistapp?c=<cfoutput>#getTickCount()#</cfoutput>';
			var left 	= 0;
			var top		= 0;
			var width	= 1024;
			var height	= 800;

			if(LvarPopupWin)
			{
				if(!LvarPopupWin.closed) LvarPopupWin.close();
			}
			LvarPopupWin = open(URLStr, 'MonitoreoBAM', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			if (! LvarPopupWin && !document.popupblockerwarning) 
			{
				alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
				document.popupblockerwarning = 1;
			}
			else
			{
				if(LvarPopupWin.focus) LvarPopupWin.focus();
			}
			return true;
		}
</script>