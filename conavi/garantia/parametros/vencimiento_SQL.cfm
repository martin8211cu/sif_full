<cfif isdefined('form.CAMBIO')>
	<cftransaction>
	<cfif form.hayDias EQ "1">
		<cfset a = updateDato(1900,form.dias)>
	<cfelseif form.hayDias EQ "0">
		<cfset b = insertDato(1900,'GP','Dias antes para avisar las garantias en vencimiento',form.dias)>
	</cfif>
	
	<cfif form.hayResponsable EQ "1">
		<cfset a = updateDato(1950,form.responsable)>
	<cfelseif Form.hayResponsable EQ "0">
		<cfset b = insertDato(1950,'GP','Nombre del responsable de los correos',form.responsable)>
	</cfif>
	
	<cfif form.hayCorreo EQ "1">
		<cfset a = updateDato(2100,form.correo)>
	<cfelseif form.hayCorreo EQ "0">
		<cfset b = insertDato(2100,'GP','Correo del responsable',form.correo)>
	</cfif>
	</cftransaction>
	<cflocation url="vencimiento_form.cfm">
<cfelseif isdefined('form.Ver')>
	<cfset dias = ObtenerDato(1900)>
	<cfset responsable = ObtenerDato(1950)>
	<cfset correo = ObtenerDato(2100)>
	<cfset rs = ObtenerGarantias(dias.Pvalor)>
	<cfif rs.Recordcount GT 0 >
		<cfset hora=now()>
		<cfset texto='<table border="0" width="100%">
		<tr>
			<td>
				<strong>Sr(a) #responsable.Pvalor#,</strong><br><br>
			</td>
			<td align="right">
				Fecha de generaci&oacute;n del correo: <strong>#DateFormat(hora, "dd/mm/yyyy")# #TimeFormat(hora,'hh:mm tt')#</strong>.<br><br>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;&nbsp;&nbsp;Este correo es enviado por el usuario <strong>#session.usuario#</strong> de la empresa <strong>#session.enombre#</strong>.<br><br>
				&nbsp;&nbsp;&nbsp;Las siguientes garant&iacute;as estan a <strong><cfoutput>#dias.Pvalor#</cfoutput> d&iacute;as de vencer</strong>:
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr><td colspan="2"><table border="1" width="100%">
		<tr align="center" bgcolor="##99CC33"><td><strong>Num. Garant&iacute;a/Versi&oacute;n</strong></td><td><strong>Proveedor</strong></td><td><strong>Proceso/Linea</strong></td><td><strong>Monto</strong></td><td><strong>Banco</strong></td><td><strong>Fecha Vencimiento</strong></td><td><strong>Estado</strong></td></tr>
		'>
		<cfset i=0>
		<cftransaction>
		<cfloop query="rs">
			<cfset texto&='<tr>
				<td align="center">
					#COEGReciboGarantia# / #COEGVersion#
				</td>
				<td align="center">
					#SNnombre#&nbsp;(#SNnumero#)
				</td>
				<td align="center">
					#CMPProceso# / #CMPLinea#</cfoutput>
				</td>
				<td align="right">
					#Msimbolo#&nbsp;#numberFormat(CODGMonto,',9.00')#
				</td>
				<td align="center">
					#Bdescripcion#</cfoutput>
				</td>
				<td align="center">
					#DateFormat(CODGFechaFin, "dd/mm/yyyy")#
				</td>
				<td align="center">
					#Estado#
				</td>
			</tr>'>
			<cfset i+=1>
		</cfloop>
		</cftransaction>
		<cfset texto&='</table></td></tr>
		<tr>
			<td colspan="2">
				<br><strong>Total</strong> de garant&iacute;as a vencer: <strong>#i#</strong>.
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<br><strong>Si este correo a llegado por equivocaci&oacute;n le solicitamos eliminarlo.</strong>
			</td>
		</tr>'>
		<cfoutput>#texto#</cfoutput>
		<tr>
			<td colspan="2">
				<form action="vencimiento_SQL.cfm" name="form1" method="post">
					<br><cf_botones modo="ALTA" exclude='NUEVO,LIMPIAR,ALTA' include='Enviar,Regresar'>
				</form>
			</td>
		</tr></table>
	<cfelse>
		<table border="0" width="100%">
		<tr>
			<td align="center">
				<br><br>No se encontraron registros para mostrar.
			</td>
		</tr>
		<tr>
			<td>
				<form action="vencimiento_SQL.cfm" name="form1" method="post">
					<br><cf_botones modo="ALTA" exclude='NUEVO,LIMPIAR,ALTA' include='Regresar'>
				</form>
			</td>
		</tr></table>
	</cfif>
<cfelseif isdefined('form.Enviar')>
	<cfset dias = ObtenerDato(1900)>
	<cfset responsable = ObtenerDato(1950)>
	<cfset correo = ObtenerDato(2100)>
	<cfset rs = ObtenerGarantias(dias.Pvalor)>
	<cfset hora=now()>
	<cfset texto='<table border="0" width="100%">
		<tr>
			<td>
				<strong>Sr(a) #responsable.Pvalor#,</strong><br><br>
			</td>
			<td align="right">
				Fecha de generaci&oacute;n del correo: <strong>#DateFormat(hora, "dd/mm/yyyy")# #TimeFormat(hora,'hh:mm tt')#</strong>.<br><br>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;&nbsp;&nbsp;Este correo es enviado por el usuario <strong>#session.usuario#</strong> de la empresa <strong>#session.enombre#</strong>.<br><br>
				&nbsp;&nbsp;&nbsp;Las siguientes garant&iacute;as estan a <strong><cfoutput>#dias.Pvalor#</cfoutput> d&iacute;as de vencer</strong>:
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr><td colspan="2"><table border="1" width="100%">
		<tr align="center" bgcolor="##99CC33"><td><strong>Num. Garant&iacute;a/Versi&oacute;n</strong></td><td><strong>Proveedor</strong></td><td><strong>Proceso/Linea</strong></td><td><strong>Monto</strong></td><td><strong>Banco</strong></td><td><strong>Fecha Vencimiento</strong></td><td><strong>Estado</strong></td></tr>
		'>
		<cfset i=0>
		<cftransaction>
		<cfloop query="rs">
			<cfset texto&='<tr>
				<td align="center">
					#COEGReciboGarantia# / #COEGVersion#
				</td>
				<td align="center">
					#SNnombre#&nbsp;(#SNnumero#)
				</td>
				<td align="center">
					#CMPProceso# / #CMPLinea#</cfoutput>
				</td>
				<td align="right">
					#Msimbolo#&nbsp;#numberFormat(CODGMonto,',9.00')#
				</td>
				<td align="center">
					#Bdescripcion#</cfoutput>
				</td>
				<td align="center">
					#DateFormat(CODGFechaFin, "dd/mm/yyyy")#
				</td>
				<td align="center">
					#Estado#
				</td>
			</tr>'>
			<cfset i+=1>
		</cfloop>
		</cftransaction>
		<cfset texto&='</table></td></tr>
		<tr>
			<td colspan="2">
				<br><strong>Total</strong> de garant&iacute;as a vencer: <strong>#i#</strong>.
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<br><strong>Si este correo a llegado por equivocaci&oacute;n le solicitamos eliminarlo.</strong>
			</td>
		</tr>'>
	<cfoutput>#texto#</cfoutput>
	<tr>
		<td colspan="2">
			<form action="vencimiento_SQL.cfm" name="form1" method="post">
				<br><cf_botones modo="ALTA" exclude='NUEVO,LIMPIAR,ALTA' include='Enviar,Regresar'>
			</form>
		</td>
	</tr></table>		
	<cfinvoke component="conavi.Componentes.garantia"
		method="CORREO_GARANTIA"
		remitente="gestion@soin.co.cr"
		destinario="#correo.Pvalor#"
		asunto="Aviso vencimiento garantias."
		texto="#texto#</table>"
		usuario="#session.Usucodigo#"
		returnvariable="LvarEnviado"
	/>
</cfif>
<cfoutput>
<script language="javascript1.2" type="text/javascript">
	function funcRegresar(){
		validar= false;
		document.form1.action = 'vencimiento_form.cfm';
		document.form1.submit();
	}
	<cfif isdefined('LvarEnviado')>
		<cfif LvarEnviado>
			alert("Correo enviado con éxito a la cola de envio de correos del sistema con la siguiente dirección: #correo.Pvalor#.\nLa llegada del correo puede tardar varios minutos.");
		<cfelse>
			alert("Se ha producido un error al enviar el correo a la cola de envio, verifique la configuración del sistema.");
		</cfif>
	</cfif>
</script>
</cfoutput>

<!--- Inserta un registro en la tabla de Parámetros --->
<cffunction name="insertDato" >		
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfargument name="mcodigo" type="string" required="true">
	<cfargument name="pdescripcion" type="string" required="true">
	<cfargument name="pvalor" type="string" required="true">			
	
	
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad
		from Parametros 
		where Ecodigo = #Session.Ecodigo#
		 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#"> 
	</cfquery>
	
	<cfif rsCheck.cantidad eq 0>
		<cfquery datasource="#Session.DSN#">
			insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
				)
		</cfquery>	
	<cfelse>
		<cfquery datasource="#Session.DSN#">
			update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">
			where Ecodigo = #Session.Ecodigo#
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>			
	</cfif>
	<cfreturn true>
</cffunction>

<!--- Actualiza los datos del registro según el pcodigo --->
<cffunction name="updateDato" >					
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfargument name="pvalor" type="string" required="true">
	<cfquery name="updDato" datasource="#Session.DSN#">
		update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cffunction name="ObtenerGarantias" returntype="query">
	<cfargument name="dias" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select  e.SNnumero,e.SNnombre,
				d.COTRCodigo, 
				c.Bdescripcion, 
				b.COEGReciboGarantia,b.COEGVersion,
				a.CODGid, a.COEGid, a.CODGMonto, a.CODGFechaFin,
				g.COTRCodigo, g.COTRDescripcion,
				f.Msimbolo,
				h.CMPProceso,h.CMPLinea,
				case b.COEGEstado
					when 1 then 'Vigente'
					when 2 then 'Edici&oacute;n'
					when 3 then 'En proceso de Ejecuci&oacute;n'
					when 4 then 'En Ejecuci&oacute;n'
					when 5 then 'Ejecutada'
					when 6 then 'En proceso Liberaci&oacute;n'
					when 7 then 'Liberada'
					when 8 then 'Devuelta'
				end as Estado
			from CODGarantia  a
				inner join COEGarantia b
					on b.COEGid =a.COEGid<!--- and b.COEGVersion = a.COEGVersion--->
				inner join Bancos c
					on c.Bid = a.Bid
				inner join COTipoRendicion d
					on d.COTRid = a.COTRid
				inner join SNegocios e
               	 	on e.SNid = b.SNid
                inner join Monedas f
                	on f.Mcodigo = a.CODGMcodigo
				inner join COTipoRendicion g
            		on g.COTRid = a.COTRid
				inner join CMProceso h
					on h.CMPid = b.CMPid
		where b.COEGVersionActiva = 1 <!--- Version activa --->
			and b.Ecodigo = #session.Ecodigo#
			and <cf_dbfunction name="datediff" args="#now()#,a.CODGFechaFin"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.dias#">
		order by a.COEGid
	</cfquery>
	<cfreturn #rs#>
</cffunction>