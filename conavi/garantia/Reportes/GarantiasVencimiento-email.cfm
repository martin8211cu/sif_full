<cf_templateheader title="Envío Correo de Vencimiento Garantia">
<cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">
		<cfquery name="hdr" datasource="#session.dsn#">
			select 	a.CODGFechaFin, a.CODGid, b.COEGReciboGarantia,c.CMPid, d.SNnombre,d.SNtelefono,d.SNFax,d.SNdireccion,
			case when b.COEGTipoGarantia = 1 then 'Participación' else 'Cumplimiento' end as COEGTipoGarantia, 
			a.COTRid, b.COEGid, a.CODGMonto, h.Mnombre, g.Bdescripcion, c.CMPProceso, 
			f.COTRDescripcion, d.SNemail, c.CMPProceso 
	from COHDGarantia a
		inner join COHEGarantia b
			on b.COEGid = a.COEGid
			and b.COEGversion = a.COEGVersion
		left outer join CMProceso c
			on c.CMPid  = b.CMPid
		inner join SNegocios d
			on d.SNid = b.SNid
		inner join COTipoRendicion f
			on 	f.COTRid = a.COTRid
		inner join Bancos g
			on g.Bid = a.Bid
		inner join Monedas h
			on h.Mcodigo = b.Mcodigo 			
	where a.Ecodigo = #session.Ecodigo#	
		and b.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.COEGid#">	
		and b.COEGVersionActiva = 1
		<!---and a.CODGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CODGid#">IMPORTANTE PODER CAPTURAR ID DETALLE--->
		</cfquery>
		
		<cfset texto='<table border="0" width="100%">	
		<tr><td></td></tr>
		<tr><td><strong>&nbsp;&nbsp;&nbsp;Señores</strong></td></tr>
		<tr><td><strong>&nbsp;&nbsp;&nbsp;#hdr.SNnombre#</strong></td></tr>
		<tr><td><strong>&nbsp;&nbsp;&nbsp;Tel: #hdr.SNtelefono# Fax: #hdr.SNFax#</strong></td></tr>		
		<tr><td><strong>&nbsp;&nbsp;&nbsp;DIRECCION: #hdr.SNdireccion#</strong></td></tr>
		<tr><td></td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;Estimados Señores</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;Por este medio se les comunica que la siguiente garantía de <strong>#hdr.COEGTipoGarantia#</strong> 
		se encuentra pronta a vencer: </td></tr>
		<tr><td></td></tr><tr><td></td></tr>		
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong> - #hdr.COTRDescripcion# N° #hdr.COEGReciboGarantia# del #hdr.Bdescripcion# por #LSNumberFormat(hdr.CODGMonto,',9.00')# #hdr.Mnombre#</strong>
			tiene como fecha de vencimiento <strong>#LSDateFormat(hdr.CODGFechaFin,'dd/mm/yyyy')#. </strong> #hdr.CMPProceso#</td>
		</tr> 
		<tr><td></td></tr><tr><td></td></tr>
		<tr><td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Se les previene para que procedan con la ampliación de la carta arriba indicada, la 
		cual debera estar vigente hasta que la administración
		</td></tr>
		<tr><td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;haya recibido el objeto de la contratación a entera satisfacción.
		</td></tr>		
		<tr><td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;De lo contrario, se incurría en incumplimiento a las disposiciones del Cartel y la
		Administración estaría facultada para ejecutar la garantía <strong>un día hábil &nbsp;&nbsp;&nbsp;&nbsp; antes del vencimiento,</strong>  
		según se establece en los artículos 16.5 y 36 del Reglamento General de la Contratación Administrativa 
		</td></tr>
		<tr><td></td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;Cordialmente,</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;#enviadoPor#</td></tr>
	'>	
			
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Vencimiento Garantia '>
			<cfinclude template="/home/menu/pNavegacion.cfm">
<!---			<cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">--->
	
			<cfoutput>
				<form action="GarantiasVencimientoSQL.cfm" name="form1" id="form1" method="post" onSubmit="return validar(this)">
					<input type="hidden" name="COEGid" id="COEGid" value="#HTMLEditFormat(url.COEGid)#">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td class="subTitulo tituloListas">&nbsp;</td>
							<td colspan="3" class="subTitulo tituloListas">
								<img src="emailVencimientosGarantia.gif" width="37" height="12">Vencimiento Gárantia
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
	  						<td><input size="60" type="text" readonly="" name="email" id="email" onFocus="this.select()" value="#HTMLEditFormat(Trim(hdr.SNemail))#"></td>
						</tr>						
						<tr>
							<td>&nbsp;</td>
							<td>Asunto:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" readonly="" value="Vencimiento Gárantia #HTMLEditFormat(hdr.COEGReciboGarantia)# del Proceso #HTMLEditFormat(hdr.CMPProceso)#"></td>
						</tr>
						<cfoutput>#texto#</cfoutput>
						<tr>
							<td>
								<!---<form action="GarantiasVencimiento-email.cfm" name="form1" method="post">--->
									<br>
									<cf_botones modo="ALTA" exclude='NUEVO,LIMPIAR,ALTA' 
									include='Enviar'> </br>
								<!---</form>--->
							</td>
	  					</tr>
						<tr>
	  						<td colspan="4"><hr></td>
	  					</tr>
					</table>
				</form>
				
	</cfoutput>	
	
	<!---<cfif isdefined('form.Enviar')>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CORREO_GARANTIA"
			remitente="gestion@soin.co.cr"
			<!---destinario="#hdr.SNemail#"--->
			destinario="jcastro@soin.co.cr"
			asunto="Aviso vencimiento garantias."
			texto="#texto#"
			usuario="#session.Usucodigo#"
			returnvariable="LvarId"
		/>
		
		<cfquery name="rsInsertSeguiGarantia" datasource="#Session.DSN#">
			insert into COSeguiGarantia (COEGid,COSGObservacion,COSGFecha, COSGUsucodigo, BMUsucodigo)  
			select b.COEGid,'Se envio correo de recordario vencimiento',
				<cf_dbfunction name="now">,#session.Usucodigo#, #session.Usucodigo#
				from CMProceso a
					inner join COEGarantia b
						on b.CMPid  = a.CMPid
					inner join SNegocios c
						on c.SNid = b.SNid
				where a.Ecodigo = #session.Ecodigo#
				and b.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.COEGid#">
		<!---and a.CODGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CODGid#">--->									
		</cfquery>
		<cflocation url="GarantiasVencimiento.cfm">
	</cfif>	--->
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
			
			if (!isEmail(f.email.value)) {
				return confirm ('El correo que ha indicado no parece válido.  ¿Desea continuar?');
			}
			return true;
		}
	</script>
</cfoutput>
