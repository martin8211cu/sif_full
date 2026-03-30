<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		ecd.ECid,
		ecd.Ecodigo,
		ecd.Ecodigodest,
		(
			select min(Edescripcion) 
			from Empresas
			where Ecodigo = ecd.Ecodigodest
		) as EmpresaDest, 
		ecd.idcontableori,
		ecd.Idcontabledest,
		ec2.Cconcepto,
		ecd.fechaasiento,
		u.Usulogin,
		u.datos_personales,
		coalesce((
			select sum(case when dcd.tipomov = 'D' then 1 else -1 end * dcd.DCmonto)
			from DControlDocInt dcd
			where dcd.ECid = ecd.ECid
		), 0) as TipoMovimiento
	from EControlDocInt ecd

		inner join HEContables ec2
		on ec2.IDcontable = ecd.idcontableori
	
		inner join Usuario u
		on u.Usucodigo = ecd.Usucodigo			

	where ecd.ECid in (#form.chk#)
	order by ecd.ECid
</cfquery>

<style type="text/css">

.PiePagina {
	font-size:10px;
}
</style>

<cfset LvarIdcontabledest = '-1'>
<cfset LvarImprimirDetalle = '-1'>
<fieldset>
<cf_htmlreportsheaders
	irA="DocIntercomp.cfm"
	title="Documentos Interempresa" 
	download="false"
	filename="nada.xls">
<table border="0" cellpadding="0" cellspacing="2" width="100%">
	<cfloop query="rsReporte">
		<cfset LvarTipoMovimiento = rsReporte.TipoMovimiento>
		<cfset LvarTotalDocumento = abs(LvarTipoMovimiento)>

		<!--- Busca Información de la Empresa --->
		<cfquery name="rsEmpresa" datasource="#session.DSN#">
			select 
				Edescripcion, 
				ETelefono1,
				ETelefono2,
				EDireccion1,
				EDireccion2,
				EDireccion3,
				EIdentificacion
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReporte.Ecodigo#">
		</cfquery>

		<cfquery name="rsEmpresaDest" datasource="#session.DSN#">
			select 
				Edescripcion, 
				ETelefono1,
				ETelefono2,
				EDireccion1,
				EDireccion2,
				EDireccion3,
				EIdentificacion
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReporte.ecodigoDest#">
		</cfquery>
		
		<cfquery name="rsConsecutivo" datasource="#session.DSN#">
			select count(1) as Consecutivo
			from EControlDocInt
			where ECid <= #rsReporte.ECid#
			  and Ecodigo = #rsReporte.Ecodigo#
		</cfquery>
		
		<!--- rsHEContableDestino --->
		<cfquery name="rsPoliza" datasource="#session.DSN#">
			select  a.IDcontable, 
				((
					select min(e.Cdescripcion) 
					from ConceptoContableE e
					where e.Ecodigo = a.Ecodigo
					and e.Cconcepto = a.Cconcepto
				)) as Cdescripcion,
				a.Eperiodo, 
				a.Emes, 
				a.Edocumento, 
				a.Efecha, 
				a.Oorigen,
				a.ECfechacreacion, 
				a.Edescripcion
			from HEContables a
			where a.IDcontable = #rsReporte.Idcontabledest#
		</cfquery>

		<cfif isdefined("rsPoliza") and rsPoliza.recordcount eq 0>
			<!--- rsEContableDestino --->
			<cfquery name="rsPoliza" datasource="#session.DSN#">
				select  a.IDcontable, 
					((
						select min(e.Cdescripcion) 
						from ConceptoContableE e
						where e.Ecodigo = a.Ecodigo
						and e.Cconcepto = a.Cconcepto
					)) as Cdescripcion,
					a.Eperiodo, 
					a.Emes, 
					a.Edocumento, 
					a.Efecha, 
					a.Oorigen,
					a.ECfechacreacion, 
					a.Edescripcion
				from EContables a
				where a.IDcontable = #rsReporte.Idcontabledest#
			</cfquery>
		</cfif>
		
		<!--- rsHEContableOrigen --->
		<cfquery name="rsPolizaOri" datasource="#session.DSN#">
			select  a.IDcontable, 
				((
					select min(e.Cdescripcion) 
					from ConceptoContableE e
					where e.Ecodigo = a.Ecodigo
					and e.Cconcepto = a.Cconcepto
				)) as Cdescripcion,
				a.Eperiodo, 
				a.Emes, 
				a.Edocumento, 
				a.Efecha, 
				a.Oorigen,
				a.ECfechacreacion, 
				a.Edescripcion
			from HEContables a
			where a.IDcontable = #rsReporte.idcontableori#
		</cfquery>

		<cfif isdefined("rsPolizaOri") and rsPolizaOri.recordcount eq 0>
			<!--- rsEContableOrigen --->
			<cfquery name="rsPolizaOri" datasource="#session.DSN#">
				select  a.IDcontable, 
					((
						select min(e.Cdescripcion) 
						from ConceptoContableE e
						where e.Ecodigo = a.Ecodigo
						and e.Cconcepto = a.Cconcepto
					)) as Cdescripcion,
					a.Eperiodo, 
					a.Emes, 
					a.Edocumento, 
					a.Efecha, 
					a.Oorigen,
					a.ECfechacreacion, 
					a.Edescripcion
				from EContables a
				where a.IDcontable = #rsReporte.idcontableori#
			</cfquery>
		</cfif>
		<cfflush interval="32">
		<cfoutput>
		<cfif len(trim(rsEmpresa.Edescripcion))>
		<tr>
			<td colspan="5" align="left" style="font-size:25px">
				<strong>#rsEmpresa.Edescripcion#</strong>
			</td>
		</tr>
		</cfif>
		<cfif len(trim(rsEmpresa.EIdentificacion))>
		<tr>
			<td colspan="5" nowrap="nowrap">#rsEmpresa.EIdentificacion#</td>
		</tr>
		</cfif>

		<cfif len(trim(rsEmpresa.EDireccion1))>
		<tr>
			<td colspan="5" align="left" nowrap="nowrap">#rsEmpresa.EDireccion1#</td>
		</tr>
		</cfif>

		<cfif len(trim(rsEmpresa.EDireccion2))>
		<tr>
			<td colspan="5" align="left" nowrap="nowrap">#rsEmpresa.EDireccion2#</td>
		</tr>
		</cfif>

		<cfif len(trim(rsEmpresa.EDireccion3))>
		<tr>
			<td colspan="5" align="left" nowrap="nowrap">#rsEmpresa.EDireccion3#</td>
		</tr>
		</cfif>

		<cfif len(trim(rsEmpresa.ETelefono1))>
		<tr>
			<td align="left" nowrap="nowrap" colspan="5">#rsEmpresa.ETelefono1#</td>
		</tr>
		</cfif>
		<cfif len(trim(rsEmpresa.ETelefono2))>
		<tr>
			<td align="left" nowrap="nowrap" colspan="5">#rsEmpresa.ETelefono2#</td>
		</tr>
		</cfif>
		<tr>
			<td colspan="4" align="right">Nota de <cfif LvarTipoMovimiento LT 0>Cr&eacute;dito<cfelse>D&eacute;bito</cfif>&nbsp;No.:&nbsp;</td>
			<td align="left"><strong>#rsConsecutivo.Consecutivo#</strong></td>
		</tr>
		<tr>
			<td colspan="5">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">Señor:<strong>&nbsp;#rsReporte.EmpresaDest#</strong></td>
			<td>Fecha&nbsp;</td>
		</tr>
		<tr>
			<td nowrap="nowrap" colspan="4">No. de Cliente:&nbsp;#rsEmpresaDest.EIdentificacion#</td>
			<td>#dateformat(rsReporte.fechaasiento,'dd/mm/yyyy')#<!--- #dateformat(now(),'dd/mm/yyyy')# ---></td>
		</tr>
		<tr><td>&nbsp;</td></tr>

		<cfset LvarMontoEnLetras = LvarObj.fnMontoEnLetras(LvarTotalDocumento)>
		<tr><td colspan="5">La suma de: <strong> #LvarMontoEnLetras# (#numberformat(LvarTotalDocumento, ",.00")#)</strong></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="5"><hr size="1" /></td>
		</tr>
		<tr>
			<td>
				Oficina
			</td>
			<td colspan="2">
				Cuenta
			</td>
			<td align="right">
				Debitos
			</td>
			<td align="right">
				Creditos
			</td>
		</tr>
		</cfoutput>
		<cfquery name="rsReporte2" datasource="#session.DSN#">
			select 
				dcd.Ocodigodest,
				dcd.tipomov,
				(
					select min(Oficodigo)
					from Oficinas
					where Ecodigo = #rsReporte.ecodigoDest#
					and Ocodigo = dcd.Ocodigodest
				) as OficinaDest,
		
				(
					select min(CFformato)
					from CFinanciera
					where CFcuenta =dcd.CFcuenta
				) 
				as CFformato,
		
				(
					select min(CFdescripcion)
					from CFinanciera
					where CFcuenta =dcd.CFcuenta
				) 
				as CFdescripcion,
				   
				dcd.Dtipocambio,
				case when dcd.tipomov = 'D' then dcd.DCmonto else 0.00 end as Debito, 
				case when dcd.tipomov = 'C' then dcd.DCmonto else 0.00 end as Credito, 
				dcd.DCmonto,
				coalesce(
					(
						select min(hd.Ddescripcion)
						from HDContables hd
						where hd.IDcontable = dcd.IDcontable
						  and hd.Dlinea     = dcd.Dlinea
					),
					(
						select min(hd.Ddescripcion)
						from DContables hd
						where hd.IDcontable = dcd.IDcontable
						  and hd.Dlinea     = dcd.Dlinea
					)
				) as DescLinea
			from DControlDocInt dcd
			where dcd.ECid = #rsReporte.ECid#
			order by DClinea
		</cfquery>
		<cfset LvarTotalDebitos = 0>
		<cfset LvarTotalCreditos = 0>
		
		<cfoutput query="rsReporte2">
			<tr>
				<td>
					#OficinaDest# 
				</td>
				<td colspan="2">
					#cfformato# (#left(cfdescripcion, 15)#) #DescLinea#
				</td>
				<td align="right">
					#numberformat(debito,',9.00')#
				</td>
				<td align="right">
					#numberformat(credito,',9.00')#
				</td>
				<cfset LvarTotalDebitos = LvarTotalDebitos + debito>
				<cfset LvarTotalCreditos = LvarTotalCreditos + credito>
			</tr>
		</cfoutput>
		<cfoutput>
			<tr>
				<td colspan="3">&nbsp;</td>
				<td align="right" style="border-top:double">
					#numberformat(LvarTotalDebitos,',9.00')#
				</td>
				<td align="right" style="border-top:double">
					#numberformat(LvarTotalCreditos,',9.00')#
				</td>
			</tr>
			<tr><td colspan="5">&nbsp;</td></tr>
			<tr>
				<td style="border-top:groove; border-width:1px; " colspan="5" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="5" align="left">Preparado por:_____________________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Aprobado por: _____________________________</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr class="PiePagina">
				<td nowrap="nowrap" colspan="5">Asiento Destino:&nbsp;#rsPoliza.Cdescripcion#&nbsp;/&nbsp;#rsPoliza.Edocumento#&nbsp;/&nbsp;#rsPoliza.Edescripcion#&nbsp;/&nbsp;#rsPoliza.Eperiodo#&nbsp;/&nbsp;#rsPoliza.Emes#</td>
			</tr>
			<tr class="PiePagina">
				<td nowrap="nowrap" colspan="5">Asiento Origen:&nbsp;#rsPolizaOri.Cdescripcion#&nbsp;/&nbsp;#rsPolizaOri.Edocumento#&nbsp;/&nbsp;#rsPolizaOri.Edescripcion#&nbsp;/&nbsp;#rsPolizaOri.Eperiodo#&nbsp;/&nbsp;#rsPolizaOri.Emes#</td>
			</tr>
			
			<tr style="page-break-after: always;"><td>&nbsp;</td></tr>
		</cfoutput>

		
	</cfloop>
	
</table>
</fieldset>



