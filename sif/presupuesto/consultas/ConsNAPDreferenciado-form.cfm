<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif 	isdefined("url.NAP") AND url.NAP NEQ ""
	AND isdefined("url.LIN") AND url.LIN NEQ "">
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select CPNAPnum, 
				'Presupuesto ' #_Cat#
					case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
						#_Cat# ' de ' #_Cat# 
						case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
						#_Cat# ' a ' #_Cat# 
						case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				as CPPdescripcion,
			   a.CPPid, CPPtipoPeriodo, CPPfechaDesde, CPPfechaHasta,
			   CPCano, 
			   CPCmes, 
			   case a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
			   CPNAPfecha, 
			   CPNAPmoduloOri #_Cat# ' - ' #_Cat# coalesce(Odescripcion,'') as Modulo, 
			   CPNAPdocumentoOri, 
			   CPNAPreferenciaOri, 
			   CPNAPfechaOri, 
			   UsucodigoOri, 
			   UsucodigoAutoriza
		from CPNAP a
			inner join CPresupuestoPeriodo p
				on a.CPPid = p.CPPid
			left outer join Origenes b
				on a.CPNAPmoduloOri = b.Oorigen
		where a.Ecodigo = #Session.Ecodigo#
		and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.NAP#">
	</cfquery>
	<cfif rsEncabezado.recordCount EQ 0>
		<cfset LvarNAP = url.NAP>
	</cfif>
</cfif>	

<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

<cfif 	not isdefined("url.NAP") OR url.NAP EQ "" 
	OR 	not isdefined("url.LIN") OR url.LIN EQ "" OR isdefined("LvarNAP")>
	<div align="center" style="font-weight:bold;">
	<br><br><br>
	<cfoutput>
	<span class="style1">
	<cfif isdefined("LvarNAP")>
			No existe el NAP=#url.NAP# línea=#url.LIN#
	<cfelse>
			No se indicó NAP + línea
	</cfif>
	</span>
	</cfoutput>
	<br>
	<br><br><br>
	</div>
	</form>
	<cfset LvarExit = true>
	<cfexit>
</cfif>

<cfquery name="rsEncabezadoNRP" datasource="#Session.DSN#">
	select CPNRPnum, CPNRPfecha, UsucodigoOri, CPNRPfechaAutoriza, UsucodigoAutoriza
	from CPNRP a
	where a.Ecodigo = #Session.Ecodigo#
	and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.NAP#">
</cfquery>

<cfquery name="rsUsuarioOrigen" datasource="asp">
	select b.Pnombre #_Cat# rtrim(' ' #_Cat# b.Papellido1 #_Cat# rtrim(' ' #_Cat# b.Papellido2)) as NombreCompleto
	from Usuario a, DatosPersonales b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.UsucodigoOri#">
	  and a.Uestado = 1
	  and a.Utemporal = 0
	  and a.datos_personales = b.datos_personales
</cfquery>

<cfquery name="rsUsuarioAutoriza" datasource="asp">
	select b.Pnombre #_Cat# rtrim(' ' #_Cat# b.Papellido1 #_Cat# rtrim(' ' #_Cat# b.Papellido2)) as NombreCompleto
	from Usuario a, DatosPersonales b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.UsucodigoAutoriza#">
	  and a.Uestado = 1
	  and a.Utemporal = 0
	  and a.datos_personales = b.datos_personales
</cfquery>

<cfif rsEncabezadoNRP.CPNRPnum NEQ "">
	<cfquery name="rsUsuarioOrigenNRP" datasource="asp">
		select b.Pnombre #_Cat# rtrim(' ' #_Cat# b.Papellido1 #_Cat# rtrim(' ' #_Cat# b.Papellido2)) as NombreCompleto
		from Usuario a, DatosPersonales b
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoNRP.UsucodigoOri#">
		  and a.Uestado = 1
		  and a.Utemporal = 0
		  and a.datos_personales = b.datos_personales
	</cfquery>
	
	<cfquery name="rsUsuarioAutorizaNRP" datasource="asp">
		select b.Pnombre #_Cat# rtrim(' ' #_Cat# b.Papellido1 #_Cat# rtrim(' ' #_Cat# b.Papellido2)) as NombreCompleto
		from Usuario a, DatosPersonales b
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoNRP.UsucodigoAutoriza#">
		  and a.Uestado = 1
		  and a.Utemporal = 0
		  and a.datos_personales = b.datos_personales
	</cfquery>
</cfif>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">
		<cfoutput>
		<cf_web_portlet_start titulo="Número de Autorización Presupuestario">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2" bgcolor="##E5E5E5">
		  <tr>
			<td rowspan="2" align="right" nowrap class="fileLabel">DOCUMENTO AUTORIZACION</td>
			<td align="right" nowrap class="fileLabel">Período:</td>
			<td colspan="3" nowrap>
				#rsEncabezado.CPPdescripcion#
			</td>
			<td align="right" nowrap class="fileLabel">Mes:</td>
			<td nowrap>
				#rsEncabezado.CPCano# - #rsEncabezado.MesDescripcion#
			</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap class="fileLabel style1">
				<a style="text-decoration:underline; color:##333399" href="ConsNAP.cfm?NAP=#rsEncabezado.CPNAPnum#">NAP:</a>
			</td>
		    <td nowrap>
				<a style="text-decoration:underline; color:##333399" href="ConsNAP.cfm?NAP=#rsEncabezado.CPNAPnum#">#rsEncabezado.CPNAPnum#</a>
			</td>
			<td align="right" nowrap class="fileLabel">Fecha Autorizacion:</td>
			<td nowrap>
				#LSDateFormat(rsEncabezado.CPNAPfecha,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezado.CPNAPfecha,'HH:MM:SS')#
			</td>
		    <td class="fileLabel" align="right" nowrap>Autorizado por:</td>
		    <td nowrap>#rsUsuarioAutoriza.NombreCompleto#</td>
		  </tr>
		  <tr><td style="height:1px; background-color:##999999" colspan="8"></td></tr>
		  <tr>
			<td rowspan="2" align="right" nowrap class="fileLabel">DOCUMENTO ORIGINAL</td>
			<td class="fileLabel" align="right" nowrap>M&oacute;dulo:</td>
			<td nowrap colspan="3">#rsEncabezado.Modulo#</td>
			<td class="fileLabel" align="right" nowrap>Referencia:</td>
			<td nowrap>#rsEncabezado.CPNAPreferenciaOri#&nbsp;</td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>Documento:</td>
			<td nowrap>#rsEncabezado.CPNAPdocumentoOri#</td>
			<td class="fileLabel" align="right" nowrap>Fecha:</td>
			<td nowrap>#LSDateFormat(rsEncabezado.CPNAPfechaOri,'dd/mm/yyyy')#</td>
			<td class="fileLabel" align="right" nowrap>Usuario: </td>
			<td nowrap colspan="3">#rsUsuarioOrigen.NombreCompleto#</td>
		  </tr>

		<cfif Len(Trim(rsEncabezadoNRP.CPNRPnum))>
		  <tr><td style="height:1px; background-color:##999999" colspan="8"></td></tr>
		  <tr>
			<td rowspan="2" align="right" nowrap class="fileLabel">DOCUMENTO RECHAZO APROBADO</td>
		    <td align="right" nowrap class="fileLabel style1" rowspan="2">NRP:</td>
		    <td nowrap rowspan="2"><span class="style1">#rsEncabezadoNRP.CPNRPnum#</span></td>
			<td align="right" nowrap class="fileLabel">Fecha Rechazo:</td>
			<td nowrap>
				#LSDateFormat(rsEncabezadoNRP.CPNRPfecha,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezadoNRP.CPNRPfecha,'HH:MM:SS')#
			</td>
		    <td class="fileLabel" align="right" nowrap>Intentado por:</td>
		    <td nowrap>#rsUsuarioAutorizaNRP.NombreCompleto#</td>
	      </tr>
		  <tr>
			<td align="right" nowrap class="fileLabel">Fecha Aprobacion:</td>
			<td nowrap>
				#LSDateFormat(rsEncabezadoNRP.CPNRPfechaAutoriza,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezadoNRP.CPNRPfechaAutoriza,'HH:MM:SS')#
			</td>
		    <td class="fileLabel" align="right" nowrap>Aprobado por:</td>
		    <td nowrap>#rsUsuarioAutorizaNRP.NombreCompleto#</td>
	      </tr>
		</cfif>
		</table>
		<cf_web_portlet_end>
		</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			  <cfoutput>
				<td align="center" class="fileLabel #session.preferences.Skin#_tdcontenido" style="background-color:##E5E5E5;padding-left: 10px; padding-right: 10px; border-bottom:none">
				LINEA DE NAP REFERENCIADO
				</td>
			</tr>
			<tr>
				<td align="center" class="#session.preferences.Skin#_tdcontenido">
			  </cfoutput>
			  
				  <cfquery name="rslistaNAPS" datasource="#session.DSN#">
					select a.CPNAPnum,
							a.CPNAPDlinea, 
							a.CPPid,
							<cf_dbfunction name="to_char" args="a.CPCano" datasource="#session.DSN#">
								#_Cat#'-'#_Cat#
							case a.CPCmes 
								when 1 then 'ENE' 
								when 2 then 'FEB' 
								when 3 then 'MAR' 
								when 4 then 'ABR' 
								when 5 then 'MAY' 
								when 6 then 'JUN' 
								when 7 then 'JUL' 
								when 8 then 'AGO' 
								when 9 then 'SET' 
								when 10 then 'OCT' 
								when 11 then 'NOV' 
								when 12 then 'DIC' 
								else '' 
							end as MesDescripcion,
							a.CPcuenta,
							o.Odescripcion,
							(case a.CPNAPDtipoMov
								when 'A'  	then 'Presupuesto<BR>Ordinario'
								when 'M'  	then 'Presupuesto<BR>Extraordinario'
								when 'ME'  	then 'Excesos<BR>Autorizados'
								when 'VC' 	then 'Variación<BR>Cambiaria'
								when 'T'  	then 'Traslado'
								when 'TE'  	then 'Traslado<BR>Aut.Externa'
								when 'RA' 	then 'Reserva<BR>Per.Ant.'
								when 'CA' 	then 'Compromiso<BR>Per.Ant.'
								when 'RP' 	then 'Provisión<BR>Presupuestaria'
								when 'RC' 	then 'Reserva'
								when 'CC' 	then 'Compromiso'
								when 'E'  	then 'Ejecución'
								when 'E2'  	then 'Ejecución<BR>No Contable'
								WHEN 'EJ' 	THEN 'Ejercido'
								WHEN 'P'  	THEN 'Pagado'
								else a.CPNAPDtipoMov
							end) as TipoMovimiento,
							a.CPNAPDmonto as Monto,
							a.CPNAPDutilizado as Utilizado,
							a.CPNAPDmonto-a.CPNAPDutilizado as Saldo,
							b.CPformato as CuentaPresupuesto,
							case a.CPCPtipoControl
								when 0 then 'Abierto'
								when 1 then 'Restringido'
								when 2 then 'Restrictivo'
								else ''
							end as TipoPresupuesto, 
							case a.CPCPcalculoControl
								when 1 then 'Mensual'
								when 2 then 'Acumulado'
								when 3 then 'Total'
								else ''
							end as MetodoControl, 
							case
							when a.CPNAPnumRef is not null then
							'<img style=''cursor=pointer;'' alt=''Consulta la utilizacion de la Línea de NAP que referencia'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNAPDreferenciado(' #_Cat#
								<cf_dbfunction name="to_char" args="a.CPNAPnumRef" datasource="#session.DSN#">
								#_Cat#','#_Cat#
								<cf_dbfunction name="to_char" args="a.CPNAPDlineaRef" datasource="#session.DSN#">
								#_Cat#');''>'
							end as Referencia
						from CPNAPdetalle a, CPresupuesto b, Oficinas o
						where a.Ecodigo = #session.ecodigo#
							and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.NAP#">
							and a.CPNAPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LIN#">
							and b.CPcuenta = a.CPcuenta
							and b.Ecodigo  = a.Ecodigo
							and o.Ecodigo = a.Ecodigo
							and o.Ocodigo = a.Ocodigo
				  </cfquery>
			  
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rslistaNAPS#"/>
							<cfinvokeargument name="desplegar" value="CPNAPDlinea, MesDescripcion, CuentaPresupuesto, Odescripcion, TipoPresupuesto, MetodoControl, TipoMovimiento, Monto, Utilizado, Saldo, Referencia"/>
							<cfinvokeargument name="etiquetas" value="Linea, Mes, Cuenta<BR>Presupuesto, Oficina, Tipo<BR>Control, Cálculo<BR>Control, Tipo<BR>Movimiento, Monto<BR>Autorizado, Monto<BR>Utilizado, Saldo, NAP<BR>Ref."/>
							<cfinvokeargument name="formatos" value="V,V,V,V,V,V,V,M,M,M,V"/>
							<cfinvokeargument name="align" value="left, center, left, left, center, center, center, right, right, right, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="ConsNAP.cfm"/>
							<cfinvokeargument name="MaxRows" value="0"/>
							<cfinvokeargument name="formName" value="listaNAPS"/>
							<cfinvokeargument name="PageIndex" value="3"/>
							<cfinvokeargument name="showLink" value="FALSE"/>
							<cfinvokeargument name="debug" value="N"/>
						</cfinvoke>
				</td>
				</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">&nbsp;</td>
  </tr>
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select CPNAPDmonto
			  from CPNAPdetalle
			 where Ecodigo = #Session.Ecodigo# 
			   and CPNAPnum = #url.NAP#
			   and CPNAPDlinea = #url.LIN#
		</cfquery>
		<cf_web_portlet_start titulo="NAP que lo Referencian">
		
			<cfquery name="rslistaNAPLINref" datasource="#session.DSN#">
				Select 	a.CPNAPnum,
						a.CPNAPDlinea, 
						a.CPPid,
						a.CPCano,
						a.CPCmes,
						<cf_dbfunction name="to_char" args="a.CPCano" datasource="#session.DSN#">
							#_Cat#'-'#_Cat#
						case a.CPCmes 
							when 1 then 'ENE' 
							when 2 then 'FEB' 
							when 3 then 'MAR' 
							when 4 then 'ABR' 
							when 5 then 'MAY' 
							when 6 then 'JUN' 
							when 7 then 'JUL' 
							when 8 then 'AGO' 
							when 9 then 'SET' 
							when 10 then 'OCT' 
							when 11 then 'NOV' 
							when 12 then 'DIC' 
							else '' 
						end as MesDescripcion,
						a.CPcuenta,
						b.CPNAPmoduloOri as Modulo,
						b.CPNAPdocumentoOri as Documento,
                        <cf_dbfunction name='sPart' args='b.CPNAPreferenciaOri,1,10'> as DocReferencia,
						b.CPNAPfechaOri as FechaDoc,
						b.CPNAPfecha as FechaAutorizacion,
						a.CPNAPDmonto as Monto,
							(select sum(CPNAPDmonto) 
							   from CPNAPdetalle 
							  where Ecodigo = a.Ecodigo 
								AND CPNAPnumRef = a.CPNAPnumRef
								AND CPNAPDlineaRef = a.CPNAPDlineaRef
								AND (CPNAPnum < a.CPNAPnum OR
									 CPNAPnum = a.CPNAPnum and CPNAPDlinea <= a.CPNAPDlinea
									)
							)
						as MontoAcumulado,
							#rsLinea.CPNAPDmonto# +
						   (select sum(CPNAPDmonto) 
							   from CPNAPdetalle 
							  where Ecodigo = a.Ecodigo 
								AND CPNAPnumRef = a.CPNAPnumRef
								AND CPNAPDlineaRef = a.CPNAPDlineaRef
								AND (CPNAPnum < a.CPNAPnum OR
									 CPNAPnum = a.CPNAPnum and CPNAPDlinea <= a.CPNAPDlinea
									)
							)
						as Saldo,
						c.CPformato as CuentaPresupuesto,
						'nap' as NAP			
				from CPNAPdetalle a, CPNAP b, CPresupuesto c
				where a.Ecodigo = #session.ecodigo#
					and a.CPNAPnumRef = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.NAP#">
					and a.CPNAPDlineaRef = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LIN#">
					and a.Ecodigo = b.Ecodigo
					and a.CPNAPnum = b.CPNAPnum
					and a.CPcuenta = c.CPcuenta
					and a.Ecodigo = c.Ecodigo
					order by a.Ecodigo, a.CPNAPnum, a.CPNAPDlinea asc
			</cfquery>
			
		
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rslistaNAPLINref#"/>
				<cfinvokeargument name="desplegar" value="CPNAPnum, Modulo, Documento, DocReferencia, FechaDoc, FechaAutorizacion, MesDescripcion, Monto, MontoAcumulado, Saldo"/>
				<cfinvokeargument name="etiquetas" value="NAP, M&oacute;dulo, Documento, Referencia, Fecha<BR>Documento, Fecha<BR>Autorizaci&oacute;n, Mes<BR>Presupuesto, Monto<BR>Autorizado, Monto<BR>Acumulado, Saldo"/>
				<cfinvokeargument name="formatos" value="V,V,V,V,D,D,V,M,M,M"/>
				<cfinvokeargument name="align" value="left, left, left, left, center, center, center, right, right, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="ConsNAP.cfm"/>
				<cfinvokeargument name="keys" value="CPNAPnum, CPNAPDlinea, CPPid, CPCano, CPCmes, CPcuenta"/>
				<cfinvokeargument name="MaxRows" value="0"/>
				<cfinvokeargument name="formName" value="listaNAPLINref"/>
				<cfinvokeargument name="PageIndex" value="3"/>
				<cfinvokeargument name="debug" value="N"/>
			</cfinvoke>
		<cf_web_portlet_end>
	</td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center">
		<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: history.back();">
	</td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
</table>

<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		function fnConsultaNAPDreferenciado(NAP, LIN){
			var param  = "NAP=" + NAP + "&" + "LIN=" + LIN;
			document.listaNAPS.nosubmit=true;
			
			if (NAP != "" && LIN != "") {
				document.listaNAPS.action = 'ConsNAPDreferenciado.cfm?' + param;
				document.listaNAPS.submit();
			}
			return false;
		}
	</script>
</cfoutput>

