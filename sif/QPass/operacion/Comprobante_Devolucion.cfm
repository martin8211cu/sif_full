<cfparam name="form.irA" default="">

<cf_htmlReportsHeaders 
		title="Impresion de Comprobante de Envío" 
		filename="Devolucion.xls"
		irA="#form.irA#"
		download="false"
		preview="no"
		back = "#form.irA NEQ ''#"
		close= "#form.irA EQ ''#" 
		>
<cfif not isdefined("form.btnDownload")>  
	<cf_templatecss>
</cfif>
<cfif isDefined("Url.QPEAPid") >
  <cfset form.QPEAPid = Url.QPEAPid>
</cfif>

<cfif isDefined("Url.Imprimir")>
  <cfset form.Imprimir = Url.Imprimir>
</cfif>

<style type="text/css">
<!--
.style3 {font-size: 12px}
-->
</style>

<cfset Fecha=LSDateFormat(now(),'dd/mm/yyyy')>
	<cf_dbfunction name="op_concat" returnvariable="_Cat">
	<cfquery name="rsEnc" datasource="#session.dsn#">
		select 
			b.QPPnombre,
            b.QPPcodigo,
			a.QPEAPDocumento,
			a.QPEAPDescripcion, 
            d.Pnombre #_Cat# ' ' #_Cat# d.Papellido1 #_Cat# ' ' #_Cat# d.Papellido2 as Usuario,
			a.BMFecha as Fecha
			from QPEAsignaPromotor a
            	inner join QPPromotor b
                	on b.QPPid = a.QPPid
                inner join Usuario c
                	on c.Usucodigo = a.Usucodigo
                inner join DatosPersonales d
                	on d.datos_personales = c.datos_personales
			where a.QPEAPid = #form.QPEAPid#
		</cfquery>

	<cfquery name="rscantidad" datasource="#session.dsn#">
		select count(1) as cantidad 
			from QPDAsignaPromotor a
            	inner join QPassTag b
                	on b.QPTidTag = a.QPTidTag
			where a.QPEAPid = #form.QPEAPid#
            and b.QPTEstadoActivacion =1 <!--- los tags que esten en la tabla QPDAsignaPromotor y tengan estado 1 es por que fueron devueltos --->
	</cfquery>

	
	<cfquery datasource="#session.DSN#" name="rsForm">
		select 
			x.QPEdescripcion,
			a.QPTEstadoActivacion, 
			l.QPLdescripcion,
			a.Ocodigo,
			a.QPTidTag, 
			l.QPLcodigo,
			a.QPTPAN, 
			a.QPTNumSerie
		from QPassTag a
			inner join QPassLote l
				on a.QPidLote = l.QPidLote
			inner join QPDAsignaPromotor b
				on a.QPTidTag  =b.QPTidTag 
			inner join QPassEstado x
				on a.QPidEstado = x.QPidEstado
		where a.Ecodigo = #session.Ecodigo#
        	and a.QPTEstadoActivacion = 1 <!--- los tags que esten en la tabla QPDAsignaPromotor y tengan estado 1 es por que fueron devueltos --->
            and b.QPDAPestado = 2
			and b.QPEAPid = #form.QPEAPid#
            and b.BMFecha >= #createdate(year(now()), month(now()), day(now()))#
	</cfquery>
	<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;
		  
		 } 
	</style>
<cfoutput>
	<table align="center" width="100%" border="0">
		
		<tr>
			<td align="center" valign="top" colspan="3"><strong>#session.Enombre#</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>Devolución de dispositivos Quick Pass al encargado de la sucursal</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>Documento: #rsEnc.QPEAPDocumento#</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>&nbsp;</strong></td>
		</tr>

		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">Fecha del trasiego: <strong><cfif #form.irA#  eq 'QPReimprimeDoc.cfm'>#LSDateFormat(rsEnc.Fecha,'dd/mm/yyyy')# <cfelse>#Fecha#</cfif></strong></td>
		</tr>
		<tr>
			<td colspan="2">Promotor que devuelve: <strong>#rsEnc.QPPcodigo# - #rsEnc.QPPnombre#</strong></td>
			<td align="left"><strong>Firma: _______________________</strong></td>
		</tr>

		<tr>
        	<td colspan="2">Usuario que recibe: <strong>#rsEnc.Usuario#</strong></td>
			<td align="left"><strong>Firma: _______________________</strong></td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>&nbsp;</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>&nbsp;</strong></td>
		</tr>
			<td align="left"valign="top" colspan="3"><strong>Estado:</strong> Devuelto a Encargado de Sucursal (En poder del Banco)</td>
		<tr>
			<td align="left" valign="top" colspan="3"><strong>Cantidad de dispositivos a devolver el día de hoy (#dateformat(now(),'dd/mm/yyyy')# a las #timeformat(now(),'hh:mm:ss tt')#) : [#rscantidad.cantidad#] </strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>Detalle del Envío</strong></td>
		</tr>

		<tr>
			<td align="center" valign="top" colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td><strong>PAN</strong></td>
			<td><strong>Caja de empaque</strong></td>			
			<td><strong>Estado inventario</strong></td>
		</tr>
	<cfloop query="rsForm">
		<tr>
			<td><span class="style3">&nbsp;#rsForm.QPTPAN#</span></td>
			<td><span class="style3">#rsForm.QPLdescripcion#</span></td>			
			<td><span class="style3">#rsForm.QPEdescripcion#</span></td>
		</tr>	
	</cfloop>
		<tr>
			<td align="center" nowrap="nowrap" colspan="3"><span class="style3">****** Ultima Linea *******</span></td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
	
	</table>
</cfoutput>
