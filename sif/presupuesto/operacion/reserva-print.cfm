<cf_dbfunction name="OP_Concat" returnvariable="_CAT">
<cfquery name="rsSQL" datasource="#session.dsn#">
	select Edescripcion from Empresas where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsDoc" datasource="#session.dsn#">
	select distinct	e.CPPid, e.CPCano, e.CPCmes, CPDEfechaDocumento, 
			CPDEtipoDocumento, CPDEsuficiencia, CPDEnumeroDocumento, CPDEreferencia, CPDEdescripcion, 
			CFidOrigen, e.Usucodigo, cf.CFcodigo, cf.CFdescripcion, cf.CFpath,
			CPDEenAprobacion, CPDEaplicado, CPDErechazado, CPDEmsgRechazo, NAP, NRP, 
			e.Mcodigo, Miso4217, CPDEtc,
			(select sum(CPDDmontoOri) from CPDocumentoD where CPDEid=e.CPDEid) as MontoOri,
			(select sum(CPDDmonto) from CPDocumentoD where CPDEid=e.CPDEid) as Monto,
			u.Usulogin,  
 			Direccion = (select CFdescripcion from CFuncional where CFid = (select CFidresp from CFuncional where CFid =            e.CFidOrigen)),case when CPDCid is not NULL then 'D' end as Dist, e.CPDEjustificacion			
	  from CPDocumentoE e
	  	inner join CFuncional cf on cf.CFid = e.CFidOrigen
		inner join Monedas m on m.Mcodigo = e.Mcodigo
		inner join Usuario u  on u.Usucodigo = e.Usucodigo
		inner join CPDocumentoD dd on dd.CPDEid=e.CPDEid
	 where e.CPDEid = 
	 	<cfif isdefined("url.CPDEid")>
			#url.CPDEid#
		<cfelse>
			#form.CPDEid#
		</cfif>			
	   and CPDEtipoDocumento = 'R'
</cfquery>

<!--- Obtiene el Nombre del Jefe del Centro Funcional Origen --->
<cfquery name="jefe_cf" datasource="#session.dsn#">
	select CFuresponsable, lt.DEid as DEid_jefe
	from CFuncional cf
		left join RHPlazas pl
			on cf.RHPid = pl.RHPid
		left join LineaTiempo lt
			on lt.RHPid = pl.RHPid
			and <cf_dbfunction name="now"> between LTdesde and LThasta
	where cf.CFid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDoc.CFidOrigen#">
	  and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif jefe_cf.CFuresponsable NEQ "">
	<cfquery name="jefe_cf" datasource="#session.dsn#">
		select Pnombre, Papellido1, Papellido2
		from Usuario u
			inner join DatosPersonales d
				on d.datos_personales = u.datos_personales
		where u.Usucodigo = #jefe_cf.CFuresponsable#
	</cfquery>
	<cfset LvarJefe = "#jefe_cf.Pnombre# #jefe_cf.Papellido1# #jefe_cf.Papellido2#">
<cfelseif jefe_cf.DEid_jefe NEQ "">
	<cfquery name="jefe_cf" datasource="#session.dsn#">
		select d.DEnombre, d.DEapellido1, d.DEapellido2
		from Usuario u
			inner join DatosPersonales d
				on d.datos_personales = u.datos_personales
		where u.Usucodigo = #jefe_cf.CRuresponsable#
	</cfquery>
	<cfset LvarJefe = "#jefe_cf.DEnombre# #jefe_cf.DEapellido1# #jefe_cf.DEapellido2#">
<cfelse>
	<cfset LvarJefe = "#rsDoc.CFdescripcion#">
</cfif>

<cfquery datasource="#session.dsn#" name="rsNomEncargadoCF">
	select de.DEnombre+' '+de.DEapellido1+' '+de.DEapellido2 as Nombre 
	from EmpleadoCFuncional ef 
    inner join DatosEmpleado de on de.DEid = ef.DEid and de.Ecodigo = ef.Ecodigo
	where ef.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDoc.CFidOrigen#">
	and ef.Ecodigo = #session.Ecodigo#
    and ECFencargado = 1
</cfquery>

<!--- Obtiene el Nombre del Centro Funcional de 2do Nivel --->
<cfif listLen(rsDoc.CFpath,"|") GTE 2>
	<cfset LvarCFcodigo2 = listGetAt(rsDoc.CFpath,2,"|")>
<cfelse>
	<cfset LvarCFcodigo2 = rsDoc.CFcodigo>
</cfif>
<cfquery name="rsDir" datasource="#session.dsn#">
	select CFcodigo, CFdescripcion
	  from CFuncional
	 where Ecodigo	= #session.Ecodigo#
	   and CFcodigo = '#LvarCFcodigo2#'
</cfquery>

<!--- Datos de la Empresa y Preriodo Presupuesto --->
<cfquery name="rsCPP" datasource="#Session.DSN#">
	select 	e.Edescripcion, e.Mcodigo, Miso4217,
			CPPid, 
			CPPtipoPeriodo, 
			CPPfechaDesde, 
			CPPfechaHasta, 
			CPPestado,
			'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as Descripcion
	 from CPresupuestoPeriodo p
	 	inner join Empresas e on e.Ecodigo = p.Ecodigo
	 	inner join Monedas m on m.Mcodigo = e.Mcodigo
	where p.CPPid = #rsDoc.CPPid#
</cfquery>

<!--- Datos de la Empresa y Preriodo Presupuesto --->
<cfif rsDoc.Dist EQ 'D'>
		<cfquery name="rsDet" datasource="#Session.DSN#">
			select distinct	a.CPDEid, a.CPCano,	cc.Cdescripcion, ccc.CCdescripcion, 
			case a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then  		     		'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 		            'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,											            case when CPDCid is not NULL then 'D' end as Dist, substring (CPformato, 10,5) as Rubro,
			SC.MontoOri, SC.Monto,a.CPCmes
			from CPDocumentoD a 
			inner join CPresupuesto c 		on c.Ecodigo = #Session.Ecodigo# and c.CPcuenta = a.CPcuenta
			left join Conceptos cc 		on cc.Cid = a.Cid
			left join CConceptos ccc 	on ccc.CCid = cc.CCid
			left join CFuncional ff 	on ff.CFid = a.CFid
			inner join (select substring (c.CPformato, 10,5) as Rub, sum(CPDDmontoOri) as MontoOri, sum(CPDDmonto) as            			Monto, CPCmes
						from CPDocumentoD a
						inner join CPresupuesto c on c.Ecodigo = #Session.Ecodigo# and c.CPcuenta = a.CPcuenta
						where CPDEid = 
						<cfif isdefined("url.CPDEid")>
							#url.CPDEid#
						<cfelse>
							#form.CPDEid#
						</cfif>	
						group by substring (c.CPformato, 10,5), CPCmes) as SC 
			on SC.Rub = substring (CPformato, 10,5)	and a.CPCmes= SC.CPCmes			
				where a.CPDEid = 
				  <cfif isdefined("url.CPDEid")>
				  	#url.CPDEid#
				  <cfelse>
					#form.CPDEid#
				  </cfif>	
				  and a.Ecodigo = #Session.Ecodigo#
				  group by a.CPDEid,a.CPCano,a.CPCmes, cc.Cdescripcion,ccc.CCdescripcion,substring (c.CPformato, 10,5),
								a.CPDCid, a.CPDDlinea, SC.MontoOri, SC.Monto
                                order by 10
		</cfquery>
		
<cfelse>
	<cfquery name="rsDet" datasource="#Session.DSN#">
		select	a.CPDEid, a.CPDDid, a.CPCano, coalesce(ff.CFcodigo,'#rsDoc.CFcodigo#') as CFcodigo, cc.Cdescripcion,        ccc.CCdescripcion, case a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril'        when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then        'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
		c.CPformato as Cuenta, coalesce(c.CPdescripcionF,c.CPdescripcion) as DescCuenta, 
		a.CPDDmonto as Monto ,a.CPDDmontoOri as MontoOri,
		case when CPDCid is not NULL then 'D' end as Dist
		from CPDocumentoD a 
		inner join CPresupuesto c on c.Ecodigo = #Session.Ecodigo# and c.CPcuenta = a.CPcuenta
		left join Conceptos cc on cc.Cid = a.Cid
		left join CConceptos ccc 	on ccc.CCid = cc.CCid
		left join CFuncional ff 	on ff.CFid = a.CFid
		where a.CPDEid = 
		<cfif isdefined("url.CPDEid")>
			#url.CPDEid#
		<cfelse>
			#form.CPDEid#
		</cfif>	
 	    and a.Ecodigo = #Session.Ecodigo#
		order by a.CPDDlinea
	</cfquery>
</cfif>
<cfoutput> 
<html>
<body>

<cfif isdefined("form.CPDEid")>
	<cf_htmlreportsheaders
			title="Provisiones Presupuestales Aprobadas" 
			filename="Provisiones Presupuestales Aprobadas.xls" 
			ira="../operacion/reserva-reprintForm.cfm"
			download="no">
	<cf_templatecss>
</cfif>
<table width="100%" border="0">
	<tr>
		<td colspan="5" align="center">
			<strong>#rsCPP.Edescripcion#</strong>
		</td>
	</tr>
	<tr>
		<td colspan="5" align="center">
			<cfif rsDoc.CPDEsuficiencia EQ 0>
				<strong>Documento de Provisión Presupuestaria</strong>
			<cfelse>
				<strong>Documento de Suficiencia Presupuestaria para Asignación</strong>
			</cfif>
		</td>
	</tr>
	<tr>
		<td colspan="5" align="center">
			<strong>#rsCPP.Descripcion#</strong>
		</td>
	</tr>
	<tr>
		<td align="left">Num. Solicitud:&nbsp;</td>
		<td>#rsDoc.CPDEnumeroDocumento#</td>
		<td></td>
		
		<td align="right">Fecha:&nbsp;</td>
		
		<td colspan="2">#dateFormat(rsDoc.CPDEfechaDocumento,"DD/MM/YYYY")#</td>
	</tr>
	<tr>
		<td align="left">Centro Funcional:&nbsp;</td>
		<td>#rsDoc.CFcodigo# #rsDoc.CFdescripcion#	</td><td></td>
		<td align="right">Referencia:&nbsp;</td><td>#rsDoc.CPDEreferencia#</td><td></td>
	</tr>
	<tr>
		<td align="left">Direccion:&nbsp;</td>
		<td width="100%">#rsDoc.Direccion#</td><td></td>
	<cfif rsDoc.Mcodigo NEQ rsCPP.Mcodigo>
		<td width="26%" align="right">Total a Pagar:&nbsp;</td>
		<td width="6%" align="right">#numberFormat(rsDoc.MontoOri,",9.99")#</td>
		<td width="7%" align="right">#rsDoc.Miso4217#&nbsp;</td>
	<cfelse>
		<td width="26%" align="right">Total a Pagar:&nbsp;</td>
		<td width="6%" align="right">#numberFormat(rsDoc.Monto,",9.99")#</td>
		<td width="7%" align="right">#rsDoc.Miso4217#&nbsp;</td>

	</cfif>
		
	</tr>
	<cfif rsDoc.Mcodigo NEQ rsCPP.Mcodigo>
	<tr>
		<td ></td><td></td><td></td>
		<td width="36%" align="right">Tipo de Cambio:&nbsp;</td>
		<td align="right">#numberFormat(rsDoc.CPDEtc,",9.9999")#</td> 
	</tr>
	</cfif>
	<tr>
		<td align="left">Descripcion:&nbsp;</td><td >#rsDoc.CPDEdescripcion#</td><td></td>
		<cfif rsDoc.Mcodigo NEQ rsCPP.Mcodigo>
			<td width="26%" align="right">Total a Pagar:&nbsp;</td>
			<td width="6%" align="right">#numberFormat(rsDoc.Monto,",9.99")#</td>
			<td width="7%" align="right">#rsCPP.Miso4217#&nbsp;</td>
		</cfif>
	</tr>
	<tr>
		<tr>&nbsp;</tr>
		<td align="left">Observaciones:&nbsp;</td><td >#rsDoc.CPDEjustificacion#</td><td></td>		
		<tr>&nbsp;</tr>
	</tr>
	<tr><td><br></td></tr>
	<tr>
		<td colspan="5" align="center">
		<table width="100%"  border="1" cellspacing="0" cellpadding="0" class="caja">
			
			<tr><font size=1>
				<td width="100" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><strong>&nbsp;AÑO&nbsp;</strong></span></td>
				<td width="100" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><strong>&nbsp;MES&nbsp;</strong></span></td>
				<td width="100" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><strong>&nbsp;RUBRO&nbsp;</strong></span></td>
				<td width="100" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><strong>&nbsp;SUB RUBRO&nbsp;</strong></span></td>
				<td width="200" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><strong>&nbsp;CUENTA PRESUPUESTO&nbsp;</strong></span></td>
			<cfif rsDoc.Mcodigo NEQ rsCPP.Mcodigo>
				<td width="100" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><strong>&nbsp;MONTO<BR>#rsDoc.Miso4217#&nbsp;</strong></span></td>
				<!--td align="right"><strong>MONTO<BR>#rsDoc.Miso4217#</strong></td-->
			</cfif>
			<td width="100" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><strong>&nbsp;MONTO<BR>#rsCPP.Miso4217#&nbsp;</strong></span></td>
				<!--td align="right"><strong>Monto<BR>#rsCPP.Miso4217#</strong></td-->
			</tr>
			<cfloop query="rsdet">
				<tr>
					<td align="center"> <font size=1> #rsDet.CPCano#</font></td>
					<td align="center"><font size=1>#rsDet.MesDescripcion#</font></td>

					<td><font size=1>#rsDet.CCdescripcion#</font></td>
					<td><font size=1>#rsDet.Cdescripcion#</font></td>
				<cfif rsDoc.Dist EQ 'D'>
						
						<cfquery name="rsCta" datasource="#session.dsn#">
							select top 1 CPformato as Cuenta
							from CPDocumentoD a 
							inner join CPresupuesto c 		on c.Ecodigo = #Session.Ecodigo# and c.CPcuenta = a.CPcuenta
							where a.CPDEid = 
							<cfif isdefined("url.CPDEid")>
								#url.CPDEid#
							<cfelse>
								#form.CPDEid#
							</cfif>	
							and a.Ecodigo = #Session.Ecodigo#
							and substring (c.CPformato,10,5) = '#rsdet.Rubro#'
						</cfquery>
						
					<td align="center"><font size=1>#rsCta.Cuenta#</font></td>
				<cfelse>
					<td align="center"><font size=1>#rsDet.Cuenta#</font></td>
				</cfif>
					
				<cfif rsDoc.Mcodigo NEQ rsCPP.Mcodigo>
					<td align="center"><font size=1>#numberFormat(rsDet.MontoOri,",9.99")#</font></td>
				</cfif>
					<td align="center"><font size=1>#numberFormat(rsDet.Monto,",9.99")#</font></td>
				</tr>
			</cfloop>
		</table>
		</td>
		</font>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="left">Fecha: #dateFormat(now(),"DD/MM/YYYY")#<br>#timeFormat(now(),"HH:MM:SS")#</td>
		<td colspan="3" align="center" style="border-top:1px solid ##000000">Solicitado por:<br>#rsNomEncargadoCF.Nombre#<br></td>
		
		<td align="right">Elaborado por:<br>#rsDoc.Usulogin#</td>
	</tr>
	<tr>
		<td height="45" colspan="5" style="border-top:1px solid ##000000">&nbsp;		</td>
	</tr>
</table>
<br>
<br>
			<table width="100%" >
				<tr >
					<td width="10%" align="left">Num. Solicitud:</td><td width="5%" align="left">#rsDoc.CPDEnumeroDocumento#</td>
					<td width="15%" align="right">Referencia:</td><td width="15%" align="left">#rsDoc.CPDEreferencia#</td>
					<td width="25%" align="right">Total Provisión:</td>
					<td width="10%" align="left">#numberFormat(rsDoc.MontoOri,",9.99")#</td>
					<td width="15%" align="right">Moneda: </td><td width="5%" align="left">#rsDoc.Miso4217#</td>
				</tr>
			</table>
	
	<tr>
	<table width="100%">
	<td height="55" width="100%" align="center"><font size="5"><strong>Final del Documento de Suficiencia Presupuestal</strong></font></td>
		</table>
	</tr>
</table>
</body>
</html>
</cfoutput>
