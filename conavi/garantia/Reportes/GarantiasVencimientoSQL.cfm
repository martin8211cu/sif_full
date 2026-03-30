<cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">
<cfquery name="hdr" datasource="#session.dsn#">
			select 	a.CODGFechaFin, a.CODGid, b.COEGReciboGarantia,c.CMPid, d.SNnombre,d.SNtelefono,d.SNFax,d.SNdireccion,
			case when b.COEGTipoGarantia = 1 then 'Participación' else 'Cumplimiento' end as COEGTipoGarantia, 
			a.COTRid, b.COEGid, a.CODGMonto, h.Mnombre, g.Bdescripcion, c.CMPProceso, 
			f.COTRDescripcion, d.SNemail, c.CMPProceso, b.COEGNumeroControl 
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
		and b.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">	
		<!---and a.CODGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CODGid#">IMPORTANTE PODER CAPTURAR ID DETALLE--->
		and b.COEGVersionActiva = 1
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
		  <td>&nbsp;&nbsp;&nbsp;N&uacute;mero de control: <strong>#hdr.COEGNumeroControl# </strong></td>
        </tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong> - #hdr.COTRDescripcion# N° #hdr.COEGReciboGarantia# del #hdr.Bdescripcion#</strong>
			tiene como fecha de vencimiento <strong>#LSDateFormat(hdr.CODGFechaFin,'dd/mm/yyyy')#. </strong> #hdr.CMPProceso#</td>
		</tr> 
		<tr><td></td></tr><tr><td></td></tr>
		<tr><td>
		&nbsp;&nbsp;&nbsp;&nbsp;Se les previene para que procedan con la ampliación de la carta arriba indicada, la 
		cual debera estar vigente hasta que la administración
		</td></tr>
		<tr><td>
		&nbsp;&nbsp;&nbsp;&nbsp;haya recibido el objeto de la contratación a entera satisfacción.
		</td></tr>		
		<tr><td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;De lo contrario, se incurría en incumplimiento a las disposiciones del Cartel y la
		Administración estaría facultada para ejecutar la garantía <strong>un día hábil antes del vencimiento,</strong>  
		según se establece en los artículos 16.5 y 36 del Reglamento General de la Contratación Administrativa 
		</td></tr>
		<tr><td></td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;Cordialmente,</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;#enviadoPor#</td></tr>
	'>	
	
	<cfif isdefined('form.Enviar')>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CORREO_GARANTIA"
			remitente="gestion@soin.co.cr"
			destinario="#hdr.SNemail#"
			asunto="Aviso vencimiento garantias."
			texto="#texto#"
			usuario="#session.Usucodigo#"
			returnvariable="LvarId"
		/>
		
		<cfquery name="rsInsertSeguiGarantia" datasource="#Session.DSN#">
			insert into COSeguiGarantia (COEGid,COSGObservacion,COSGFecha, COSGUsucodigo, BMUsucodigo)  
			select b.COEGid,'Se envio correo recordatorio de vencimiento',
				<cf_dbfunction name="now">,#session.Usucodigo#, #session.Usucodigo#
				from CMProceso a
					inner join COEGarantia b
						on b.CMPid  = a.CMPid
					inner join SNegocios c
						on c.SNid = b.SNid
				where a.Ecodigo = #session.Ecodigo#
				and b.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
		<!---and a.CODGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CODGid#">--->									
		</cfquery>
		<cflocation url="GarantiasVencimiento.cfm">
	</cfif>	