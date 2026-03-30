<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif isdefined("url.NAP") and Len(Trim(url.NAP))>
	<cfset form.CPNAPnum = url.NAP>
<cfelseif isdefined("url.CPNAPnum") and Len(Trim(url.CPNAPnum))>
	<cfset form.CPNAPnum = url.CPNAPnum>
</cfif>

<cfquery name="rsSQL" datasource="#Session.DSN#">
	select m.Mcodigo, m.Mnombre
	  from Monedas m, Empresas e
	 where e.Ecodigo = #Session.Ecodigo#
	   and m.Ecodigo = e.Ecodigo
	   and m.Mcodigo = e.Mcodigo
</cfquery>
<cfif find(",",rsSQL.Mnombre) GT 0>
	<cfset LvarMnombreEmpresa = trim(mid(rsSQL.Mnombre,find(",",rsSQL.Mnombre)+1,100))>
<cfelse>	
	<cfset LvarMnombreEmpresa = rsSQL.Mnombre>
</cfif>
<cfset LvarMcodigoEmpresa = rsSQL.Mcodigo>

<cfset navegacion = "">
<cfif isdefined("Form.CPNAPnum") and Len(Trim(Form.CPNAPnum))>
	<cfset navegacion = navegacion & "CPNAPnum=" & Form.CPNAPnum>
</cfif>
<!--- Necesario para la pantalla de consulta de presupuesto --->
<cfif isdefined("Form.CPNAPDlinea") and Len(Trim(Form.CPNAPDlinea))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "CPNAPDlinea=" & Form.CPNAPDlinea>
</cfif>
<cfif isdefined("Form.CPNAPnum") AND Len(Trim(Form.CPNAPnum))>
	<cfquery name="rsME" datasource="#Session.DSN#">
		select CPNAPnumModificado
		  from CPNAP a
		 where a.Ecodigo = #Session.Ecodigo#
		   and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNAPnum#">
	</cfquery>
	<cfif rsME.CPNAPnumModificado NEQ "">
		<cfset form.CPNAPnum = rsME.CPNAPnumModificado>
	</cfif>
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
			   CPNAPmoduloOri#_Cat#' - '#_Cat#coalesce(Odescripcion,'') as Modulo, 
			   CPNAPdocumentoOri, 
			   CPNAPreferenciaOri, 
			   CPNAPfechaOri, 
			   CPNAPnumReversado, 
			   UsucodigoOri, 
			   UsucodigoAutoriza,
			   CPOid
		from CPNAP a
			inner join CPresupuestoPeriodo p
				on a.CPPid = p.CPPid
			left outer join Origenes b
				on a.CPNAPmoduloOri = b.Oorigen
		where a.Ecodigo = #Session.Ecodigo#
		and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNAPnum#">
		order by a.Ecodigo, a.CPNAPnum
	</cfquery>
	<cfif rsEncabezado.recordCount EQ 0>
		<cfset LvarNAP = Form.CPNAPnum>
	<cfelse>
		<cfquery name="rsTotal" datasource="#Session.DSN#">
			select sum(CPNAPDsigno*CPNAPDmonto) as Monto
			  from CPNAPdetalle a
			 where a.Ecodigo = #Session.Ecodigo#
			   and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNAPnum#">
		</cfquery>
		<cfif rsTotal.Monto EQ "">
			<cfset rsTotal.Monto = 0>
		</cfif>
	</cfif>
</cfif>	

<style type="text/css">
<!--
.style1 {color: #FF0000}
.style2 {color: #3300CC}
.pStyle_Signo {font-weight:bold}
.pStyle_Monto {font-weight:bold}
-->
</style>

<cfif not isdefined("Form.CPNAPnum") OR Form.CPNAPnum EQ "" OR isdefined("LvarNAP")>
	<script language="javascript" src="../../js/utilesMonto.js"></script>
	<br><br><br>
	<form method="post">
	<div align="center" style="font-weight:bold;">
	Numero de Autorizacion Presupuestario NAP:&nbsp;&nbsp;
	<script language="javascript" src="../../js/utilesMonto.js"></script>
	<input 	name="CPNAPnum" id="CPNAPnum" 
			onblur="fm(this,-1);" onfocus="javascript:this.value=qf(this); this.select();"  
			size="10" onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
	&nbsp;&nbsp;
	<input type="submit" value="Aceptar">
	<br><br>
	<cfif isdefined("LvarNAP")>
		<cfoutput>
		<span class="style1">
			No existe el NAP=#Form.CPNAPnum#
		</span>
		</cfoutput>
		<br><br>
	<cfelse>
		<br><br>
	</cfif>
	</div>
	</form>
	<cfset LvarExit = true>
	<cfexit>
</cfif>

<cfquery name="rsEncabezadoNRP" datasource="#Session.DSN#">
	select CPNRPnum, CPNRPfecha, UsucodigoOri, CPNRPfechaAutoriza, UsucodigoAutoriza
	from CPNRP a
	where a.Ecodigo = #Session.Ecodigo#
	and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNAPnum#">
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
			<td class="fileLabel" align="right" nowrap>NAP:</td>
			<td nowrap>#rsEncabezado.CPNAPnum#</td>
			<td align="right" nowrap class="fileLabel">Fecha Autorizacion:</td>
			<td nowrap>
				#LSDateFormat(rsEncabezado.CPNAPfecha,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezado.CPNAPfecha,'HH:MM:SS')#
			</td>
		    <td class="fileLabel" align="right" nowrap>Autorizado por:</td>
		    <td nowrap>#rsUsuarioAutoriza.NombreCompleto#</td>
		  </tr>
			<tr>
			  <td colspan="2" class="fileLabel" align="right" nowrap>Total Autorizado:</td>
			  <td colspan="3">#LSCurrencyFormat(rsTotal.monto,'none')# #LvarMnombreEmpresa#</td>
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

		<cfif Len(Trim(rsEncabezado.CPNAPnumReversado))>
		  <tr>
			<td align="right" nowrap class="fileLabel">&nbsp;</td>
			<td class="fileLabel" align="right" nowrap>
				<a style="text-decoration:underline;" class="style2" href="ConsNAP.cfm?NAP=#rsEncabezado.CPNAPnumReversado#">NAP Reversado:</a>
			</td>
			<td class="fileLabel" align="right" nowrap>
				<a style="text-decoration:underline;" class="style2" href="ConsNAP.cfm?NAP=#rsEncabezado.CPNAPnumReversado#">#rsEncabezado.CPNAPnumReversado#</a>
			</td>
		  </tr>
		</cfif>
		<cfif rsEncabezado.CPOid NEQ "">
			<cfquery name="rsOrigenAbierto" datasource="#Session.DSN#">
				select CPOdesde, CPOhasta, Usucodigo
				  from CPOrigenesControlAbierto
				where Ecodigo = #Session.Ecodigo#
				  and CPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.CPOid#">
			</cfquery>
			<cfquery name="rsUsuarioAbierto" datasource="asp">
				select b.Pnombre #_Cat# rtrim(' ' #_Cat# b.Papellido1 #_Cat# rtrim(' ' + b.Papellido2)) as NombreCompleto
				from Usuario a, DatosPersonales b
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrigenAbierto.Usucodigo#">
				  and a.Uestado = 1
				  and a.Utemporal = 0
				  and a.datos_personales = b.datos_personales
			</cfquery>
		
		  <tr><td style="height:1px; background-color:##999999" colspan="8"></td></tr>
		  <tr>
			<td rowspan="2" align="right" nowrap class="fileLabel">MODULO ORIGEN ABIERTO</td>
			<td align="right" nowrap class="fileLabel">Abierto Desde:</td>
			<td nowrap>#LSDateFormat(rsOrigenAbierto.CPOdesde,'dd/mm/yyyy')#</td>
			<td align="right" nowrap class="fileLabel">Hasta:</td>
			<td nowrap>#LSDateFormat(rsOrigenAbierto.CPOhasta,'dd/mm/yyyy')#</td>
		    <td class="fileLabel" align="right" nowrap>Abierto por:</td>
		    <td nowrap>#rsUsuarioAbierto.NombreCompleto#</td>
	      </tr>
		  <tr>
		  	<td>&nbsp;</td>
		  	<td  class="fileLabel style1" colspan="6">El Documento generó un Rechazo pero fue originado desde un módulo que tenía autorizado un Control Abierto</td>
		  </tr>

		<cfelseif Len(Trim(rsEncabezadoNRP.CPNRPnum))>
		  <tr><td style="height:1px; background-color:##999999" colspan="8"></td></tr>
		  <tr>
			<td rowspan="3" align="right" nowrap class="fileLabel">DOCUMENTO RECHAZO APROBADO</td>
		    <td align="right" nowrap class="fileLabel style1" rowspan="2">
				<a style="text-decoration:underline;" class="style1" href="ConsNRP.cfm?NRP=#rsEncabezadoNRP.CPNRPnum#">NRP:</a>
			</td>
		    <td nowrap rowspan="2">
				<a style="text-decoration:underline;" class="style1" href="ConsNRP.cfm?NRP=#rsEncabezadoNRP.CPNRPnum#">#rsEncabezadoNRP.CPNRPnum#</a>
			</td>
			<td align="right" nowrap class="fileLabel">Fecha Rechazo:</td>
			<td nowrap>
				#LSDateFormat(rsEncabezadoNRP.CPNRPfecha,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezadoNRP.CPNRPfecha,'HH:MM:SS')#
			</td>
		    <td class="fileLabel" align="right" nowrap>Intentado por:</td>
		    <td nowrap>#rsUsuarioOrigenNRP.NombreCompleto#</td>
	      </tr>
		  <tr>
			<td align="right" nowrap class="fileLabel">Fecha Aprobacion:</td>
			<td nowrap>
				#LSDateFormat(rsEncabezadoNRP.CPNRPfechaAutoriza,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezadoNRP.CPNRPfechaAutoriza,'HH:MM:SS')#
			</td>
		    <td class="fileLabel" align="right" nowrap>Aprobado por:</td>
		    <td nowrap>#rsUsuarioAutorizaNRP.NombreCompleto#</td>
	      </tr>
		  <tr>
		  	<td>&nbsp;</td>
		  	<td  class="fileLabel style1" colspan="6">El Documento generó un Rechazo pero tenía Aprobado su Número de Rechazo Presupuestario</td>
		  </tr>
		</cfif>
		</table>
		<cf_web_portlet_end>
		</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">&nbsp;</td>
  </tr>
	<cfquery name="rsME" datasource="#Session.DSN#">
		select CPNAPnum
		  from CPNAP a
		 where a.Ecodigo = #Session.Ecodigo#
		   and a.CPNAPnumModificado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNAPnum#">
	</cfquery>
	<cfif rsME.CPNAPnum NEQ "">
	<tr>
		<td align="center" style="padding-left: 10px; padding-right: 10px;">
			<cf_web_portlet_start titulo="Detalle del NAP de Aprobación del Rechazo Presupuestario">
				<cfquery name="rsListaNAP_ME" datasource="#Session.DSN#">
						Select 
							a.CPNAPnum,
							a.CPNAPDlinea, 
							a.CPPid,
							<cf_dbfunction name="to_char" args="a.CPCano" datasource="#session.dsn#">
							 #_Cat# '-' #_Cat#
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
							case when a.CPNAPDsigno < 0 then '(-)' when a.CPNAPDsigno > 0 then '(+)' else '(n/a)' end as Signo,
							a.CPNAPDmonto as Monto,
							a.CPNAPDdisponibleAntes as DisponibleAnterior,
							a.CPNAPDdisponibleAntes + a.CPNAPDsigno*a.CPNAPDmonto as DisponibleGenerado,
							a.CPNAPDconExceso,
							b.CPformato as CuentaPresupuesto,
							case a.CPCPtipoControl
								when 0 then 'Abierto'
								when 1 then 'Restringido'
								when 2 then 'Restrictivo'
								else ''
							end as TipoControl, 
							case a.CPCPcalculoControl
								when 1 then 'Mensual'
								when 2 then 'Acumulado'
								when 3 then 'Total'
								else ''
							end as CalculoControl , 
							case
							when a.CPNAPnumRef is not null then
						'<img style=''cursor=pointer;'' alt=''Consulta la utilizacion de la Línea de NAP que referencia'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNAPDreferenciado(' #_Cat#
							<cf_dbfunction name="to_char" args="a.CPNAPnumRef" datasource="#session.dsn#">
							#_Cat# ','	#_Cat# 
							<cf_dbfunction name="to_char" args="a.CPNAPDlineaRef" datasource="#session.dsn#">
							#_Cat# ');''>'
							end as Referencia,
							case
								when a.CPNAPDreferenciado=1 then
						'<img style=''cursor=pointer;'' alt=''Consulta la utilizacion de esta Línea de NAP'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNAPDreferenciado(' #_Cat#
							<cf_dbfunction name="to_char" args="a.CPNAPnum" datasource="#session.dsn#">
							#_Cat# ',' #_Cat#
							<cf_dbfunction name="to_char" args="a.CPNAPDlinea" datasource="#session.dsn#">
							#_Cat# ');''>'
							end as Utilizado	
					from CPNAPdetalle a, CPresupuesto b, Oficinas o
					where a.Ecodigo = #session.ecodigo# 
						and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsME.CPNAPnum#">
						and b.CPcuenta = a.CPcuenta
						and b.Ecodigo  = a.Ecodigo
						and o.Ecodigo = a.Ecodigo
						and o.Ocodigo = a.Ocodigo
					order by a.CPNAPDlinea
				</cfquery>
		
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsListaNAP_ME#"/>
					<cfinvokeargument name="desplegar" value="CPNAPDlinea, MesDescripcion, CuentaPresupuesto, Odescripcion, TipoControl, CalculoControl, TipoMovimiento, DisponibleAnterior, Signo, Monto, DisponibleGenerado, Referencia, Utilizado"/>
					<cfinvokeargument name="etiquetas" value="Linea, Mes, Cuenta<BR>Presupuesto, Oficina, Tipo<BR>Control, Cálculo<BR>Control, Tipo<BR>Movimiento, Disponible<BR>Anterior,Signo<BR>Monto,Monto<BR>Autorizado, Disponible<BR>Generado, NAP<BR>Ref., Utilizado<br>por"/>
					<cfinvokeargument name="formatos" value="V,V,V,V,V,V,V,M,V,M,R CPNAPDconExceso EQ 1,V,V"/>
					<cfinvokeargument name="align" value="left, center, left, left, center, center, center, right, center, right, right, center, center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value=""/>
					<cfinvokeargument name="MaxRows" value="20"/>
					<cfinvokeargument name="formName" value="listaNAPSME"/>
					<cfinvokeargument name="PageIndex" value="11"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			<cf_web_portlet_end>
			<BR>
		</td>
	</tr>
	</cfif>
	<tr>
		<td align="center" style="padding-left: 10px; padding-right: 10px;">
			<cf_web_portlet_start titulo="Detalle del NAP">
				<cfquery name="rsOrderBy" datasource="#Session.DSN#">
					select	CPCano, CPCmes, CPcuenta, Ocodigo, 
							count(abs(CPNAPDlinea)) as Cantidad
					from 	CPNAPdetalle
					where	Ecodigo = #Session.Ecodigo# 
					  and 	CPNAPnum = #Form.CPNAPnum#
					group 	by CPCano, CPCmes, CPcuenta, Ocodigo
					having	count(abs(CPNAPDlinea)) > 1
				</cfquery>
				<cfset LvarOrderByLinea = (rsOrderBy.CPcuenta EQ "")>
				<cfquery name="rsListaNAPS" datasource="#Session.DSN#">
						Select 
							a.CPNAPnum,
							a.CPNAPDlinea, 
							a.CPPid,
							<cf_dbfunction name="to_char" args="a.CPCano" datasource="#session.dsn#">
							 #_Cat# '-' #_Cat#
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
							case when a.CPNAPDsigno < 0 then '(-)' when a.CPNAPDsigno > 0 then '(+)' else '(n/a)' end as Signo,
							a.CPNAPDmonto as Monto,
							a.CPNAPDdisponibleAntes as DisponibleAnterior,
							a.CPNAPDdisponibleAntes + a.CPNAPDsigno*a.CPNAPDmonto as DisponibleGenerado,
							a.CPNAPDconExceso,
							b.CPformato as CuentaPresupuesto,
							case a.CPCPtipoControl
								when 0 then 'Abierto'
								when 1 then 'Restringido'
								when 2 then 'Restrictivo'
								else ''
							end as TipoControl, 
							case a.CPCPcalculoControl
								when 1 then 'Mensual'
								when 2 then 'Acumulado'
								when 3 then 'Total'
								else ''
							end as CalculoControl , 
							case
							when a.CPNAPnumRef is not null then
						'<img style=''cursor=pointer;'' alt=''Consulta la utilizacion de la Línea de NAP que referencia'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNAPDreferenciado(' #_Cat#
							<cf_dbfunction name="to_char" args="a.CPNAPnumRef" datasource="#session.dsn#">
							#_Cat# ','	#_Cat# 
							<cf_dbfunction name="to_char" args="a.CPNAPDlineaRef" datasource="#session.dsn#">
							#_Cat# ');''>'
							end as Referencia,
							case
								when a.CPNAPDreferenciado=1 then
						'<img style=''cursor=pointer;'' alt=''Consulta la utilizacion de esta Línea de NAP'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNAPDreferenciado(' #_Cat#
							<cf_dbfunction name="to_char" args="a.CPNAPnum" datasource="#session.dsn#">
							#_Cat# ',' #_Cat#
							<cf_dbfunction name="to_char" args="a.CPNAPDlinea" datasource="#session.dsn#">
							#_Cat# ');''>'
							end as Utilizado	
					from CPNAPdetalle a, CPresupuesto b, Oficinas o
					where a.Ecodigo = #session.ecodigo# 
						and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNAPnum#">
						and b.CPcuenta = a.CPcuenta
						and b.Ecodigo  = a.Ecodigo
						and o.Ecodigo = a.Ecodigo
						and o.Ocodigo = a.Ocodigo
					<cfif isdefined("url.chkCeros")>
						and a.CPNAPDmonto <> 0
					</cfif>
					<cfif LvarOrderByLinea>
					  order by abs(a.CPNAPDlinea), a.CPNAPDsigno*a.CPNAPDmonto desc
					<cfelse>
					  order by a.CPCano, a.CPCmes, b.CPformato, o.Oficodigo, a.CPNAPDsigno*a.CPNAPDmonto desc
					</cfif>
				</cfquery>
		
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsListaNAPS#"/>
					<cfinvokeargument name="desplegar" value="CPNAPDlinea, MesDescripcion, CuentaPresupuesto, Odescripcion, TipoControl, CalculoControl, TipoMovimiento, DisponibleAnterior, Signo, Monto, DisponibleGenerado, Referencia, Utilizado"/>
					<cfinvokeargument name="etiquetas" value="Linea, Mes, Cuenta<BR>Presupuesto, Oficina, Tipo<BR>Control, Cálculo<BR>Control, Tipo<BR>Movimiento, Disponible<BR>Anterior,Signo<BR>Monto,Monto<BR>Autorizado, Disponible<BR>Generado, NAP<BR>Ref., Utilizado<br>por"/>
					<cfinvokeargument name="formatos" value="V,V,V,V,V,V,V,M,V,M,R CPNAPDconExceso EQ 1,V,V"/>
					<cfinvokeargument name="align" value="left, center, left, left, center, center, center, right, center, right, right, center, center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="MaxRows" value="20"/>
					<cfinvokeargument name="formName" value="listaNAPS"/>
					<cfinvokeargument name="PageIndex" value="12"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
				<cfoutput>
				&nbsp;&nbsp;<input type="checkbox" name="chkCeros" <cfif isdefined("url.chkCeros")>checked</cfif> onclick="location.href='#GetFileFromPath(GetTemplatePath())#?<cfif isdefined("url.NAP") and Len(Trim(url.NAP))>NAP<cfelse>CPNAPnum</cfif>=#form.CPNAPnum#&CPNAPDlinea=1' + (this.checked ? '&chkCeros=1' : '');"> Eliminar Movimientos en Cero
				</cfoutput>	
			<cf_web_portlet_end>
			<cfif rsME.CPNAPnum NEQ "">
				</td></tr><tr><td class="style1">&nbsp;&nbsp;&nbsp;(*) Movimientos que provocaron la Aprobación de un Rechazo Presupuestario
			</td></tr></cfif>
<cfquery name="rsDetalleNAPpago" datasource="#Session.DSN#">
	select 	CPNAPDPdocumento as Documento,
			<cf_dbfunction name="to_char" args="a.CPCano" datasource="#session.dsn#">
			 #_Cat# '-' #_Cat#
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
			end as Mes,
			CPformato as Cuenta,
			Oficodigo as Ofi,
			CASE CPNAPDPtipoMov 
				WHEN 'EJ' THEN 'Ejercido'
				WHEN 'P'  THEN 'Pagado'
				ELSE CPNAPDPtipoMov 
			END as Mov,
			round(CPNAPDPmonto,2) as Monto
	  from CPNAPdetallePagado a, CPresupuesto b, Oficinas o
	  where a.Ecodigo = #session.ecodigo# 
		and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNAPnum#">
		and b.CPcuenta = a.CPcuenta
		and b.Ecodigo  = a.Ecodigo
		and o.Ecodigo = a.Ecodigo
		and o.Ocodigo = a.Ocodigo
</cfquery>
<cfif rsDetalleNAPpago.recordcount GT 0>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">
		<cf_web_portlet_start titulo="Movimientos de Flujo de Efectivo">
			<div align="center">
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsDetalleNAPpago#"/>
					<cfinvokeargument name="desplegar" value="Documento, Mes, Cuenta, Ofi, Mov, Monto"/>
					<cfinvokeargument name="etiquetas" value="Documento, Mes, Cuenta<BR>Presupuesto, Ofi, Tipo<BR>Movimiento, Monto"/>
					<cfinvokeargument name="formatos" value="V,V,V,V,V,V"/>
					<cfinvokeargument name="align" value="left, center, left, left, center, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="MaxRows" value="20"/>
					<cfinvokeargument name="formName" value="listaNAPSreversion"/>
					<cfinvokeargument name="PageIndex" value="13"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			</div>
		<cf_web_portlet_end>
	</td>
  </tr>
</cfif>
	
<cfquery name="rsFinanciamiento" datasource="#Session.DSN#">
	select 	a.CPPFid, CPPFcodigo, CPPFdescripcion,
			CPCano, CPCmes, CPNAPPFingresos, CPNAPPFconsumos
	  from CPNAPpryFinanciados a
	  	inner join CPproyectosFinanciados p
			on p.CPPFid = a.CPPFid
	  where a.Ecodigo = #session.ecodigo# 
		and a.CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNAPnum#">
</cfquery>
<cfif rsFinanciamiento.recordcount GT 0>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">
		<cf_web_portlet_start titulo="Aprobación de Financiamiento Presupuestal">
			<div align="center">
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsFinanciamiento#"/>
					<cfinvokeargument name="desplegar" value="CPPFcodigo, CPPFdescripcion, CPCano, CPCmes, CPNAPPFingresos, CPNAPPFconsumos"/>
					<cfinvokeargument name="etiquetas" value="Proyecto, Descripcion, Ano, Mes, Total Ingresos<BR>Realizados, Total<BR>Consumos"/>
					<cfinvokeargument name="formatos" value="V,V,V,V,M,M"/>
					<cfinvokeargument name="align" value="left, left, center, center, right, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="MaxRows" value="20"/>
					<cfinvokeargument name="formName" value="listaNAPSreversion"/>
					<cfinvokeargument name="PageIndex" value="13"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="lineaRoja" value="CPNAPPFingresos LT CPNAPPFconsumos"/>
				</cfinvoke>
			</div>
		<cf_web_portlet_end>
	</td>
  </tr>
</cfif>

  <tr>
    <td align="center">&nbsp;</td>
  </tr>
<cfquery name="rsListaNAPSReversion" datasource="#Session.DSN#">
		Select 
			a.CPNAPnum,
			a.CPPid,
			a.CPCano,
			a.CPCmes,
			case a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
			a.CPNAPmoduloOri as Modulo,
			a.CPNAPdocumentoOri as Documento,
			a.CPNAPreferenciaOri DocReferencia, 
			a.CPNAPfechaOri as FechaDoc,
			a.CPNAPfecha as FechaAutorizacion,
			'<img style=''cursor=pointer;'' alt=''Consulta el NAP de Reversión'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNAPreversion(' #_Cat#
				<cf_dbfunction name="to_char" args="a.CPNAPnum" datasource="#session.dsn#">
				#_Cat# ');''>'
			as Consulta
	   from CPNAP a
	  where a.Ecodigo = #session.ecodigo# 
		and a.CPNAPnumReversado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.CPNAPnum#">
	order by a.CPNAPnum
</cfquery>
<cfif rsListaNAPSReversion.recordCount GT 0>
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">
		<cf_web_portlet_start titulo="Movimientos de Reversion o Anulación del NAP" width=70%>
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsListaNAPSReversion#"/>
				<cfinvokeargument name="desplegar" value="CPNAPnum, Modulo, Documento, DocReferencia, FechaDoc, FechaAutorizacion, Consulta"/>
				<cfinvokeargument name="etiquetas" value="NAP, M&oacute;dulo, Documento, Referencia, Fecha Documento, Fecha Autorizaci&oacute;n, "/>
				<cfinvokeargument name="formatos" value="V,V,V,V,D,DT,S"/>
				<cfinvokeargument name="align" value="left, center, left, left, center, center,center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="formName" value="listaNAPSreversion"/>
				<cfinvokeargument name="PageIndex" value="13"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="debug" value="N"/>
			</cfinvoke>
		<cf_web_portlet_end>
	</td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
</cfif>
  <tr>
    <td align="center">
		<input type="button" name="btnRegresar" class="btnAnterior" value="Regresar" onClick="javascript: history.back();">
        <input type="button" name="btnimprimir" class="btnimprimir" value="Imprimir" onclick="popup();">
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

		function fnConsultaNAPreversion(NAP){
			var param  = "NAP=" + NAP;
			document.listaNAPSreversion.nosubmit=true;
			
			if (NAP != "") {
				document.listaNAPSreversion.action = 'ConsNAP.cfm?' + param;
				document.listaNAPSreversion.submit();
			}
			return false;
		}
		function popup(imprimir,w,h,format)
		{
		var PARAM  = "ConsNAP-PopUp.cfm?CPNAPnum=#Form.CPNAPnum#<cfif isdefined("url.chkCeros")>&chkCeros=1</cfif>";
		if(!w) w = 400;
		if(!h) h = 200;

		if(imprimir) PARAM = PARAM + '&imprimir=true&format=' + format;
		args = 'left=250,top=250,scrollbars=yes,resizable=yes,width='+w+',height='+h;
		windowOpener (PARAM,'popUpWin',args, w, h);
		}
		
		function windowOpener(url, name, args, width, height, cerrar) 
		{
			if (typeof(popupWin) != "object")
				{popupWin = window.open(url,name,args);} 
			else {
				if (!popupWin.closed){popupWin.location.href = url;} 
				else {popupWin = window.open(url, name,args);}
			     }
			popupWin.focus();
			popupWin.resizeTo(width,height);
		}
	</script>
</cfoutput>

