	<cfoutput> <strong>getBaseTemplatePath:</strong>#getBaseTemplatePath()#</cfoutput><br />
    <cfoutput><strong>ExpandPath:</strong> #expandPath("/")#</cfoutput><br />
	<cfoutput> <strong>len:</strong>#len(expandPath("/"))#</cfoutput><br />
    
<cfset LvarTemplate = mid(getBaseTemplatePath(),len(expandPath("/")),200)>
	<cfoutput> <strong>LvarTemplate:</strong>#LvarTemplate#</cfoutput><br />
    <cfoutput> <strong>replace:</strong>#replace(LvarTemplate,"\","/","ALL")#</cfoutput><br />
<cfset LvarTemplate = '/cfmx' & replace(LvarTemplate,"\","/","ALL")>
	<cfoutput>#LvarTemplate#</cfoutput>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("url.NRP") and Len(Trim(url.NRP))>
	<cfset form.CPNRPnum = url.NRP>
<cfelseif isdefined("url.CPNRPnum") and Len(Trim(url.CPNRPnum))>
	<cfset form.CPNRPnum = url.CPNRPnum>
<cfelseif isdefined("url.ERROR_NRP") and Len(Trim(url.ERROR_NRP))>
	<cfset form.CPNRPnum = url.ERROR_NRP>
	<cfset LvarERROR_NRP = "RECHAZO EN CONTROL PRESUPUESTARIO: El documento generó el Numero de Rechazo Presupuestario NRP=#form.CPNRPnum# porque existe un exceso de presupuesto no autorizado">
	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
			window.onload = new Function("alert('#LvarERROR_NRP#');");
		</cfoutput>
	</script>
</cfif>
<cfif isdefined("url._")>
	<cfif isdefined("session.navegacion")>
		<cfset structDelete(session,"navegacion")>
	</cfif>
</cfif>

<cfif isdefined("url.CPPid")>
	<cfset form.CPPid = url.CPPid>
</cfif>

<cfquery name="rsSQL" datasource="#Session.DSN#">
	select m.Mcodigo, m.Mnombre
	  from Monedas m, Empresas e
	 where e.Ecodigo = #Session.Ecodigo#
	   and m.Mcodigo = e.Mcodigo
	   and m.Ecodigo = e.Ecodigo
</cfquery>
<cfif find(",",rsSQL.Mnombre) GT 0>
	<cfset LvarMnombreEmpresa = trim(mid(rsSQL.Mnombre,find(",",rsSQL.Mnombre)+1,100))>
<cfelse>	
	<cfset LvarMnombreEmpresa = rsSQL.Mnombre>
</cfif>
<cfset LvarMcodigoEmpresa = rsSQL.Mcodigo>

<cfset navegacion = "">
<cfif isdefined("Form.CPNRPnum") and Len(Trim(Form.CPNRPnum))>
	<cfset navegacion = navegacion & "CPNRPnum=" & Form.CPNRPnum>
</cfif>


<cfif isdefined("Form.CPNRPnum") AND Form.CPNRPnum NEQ "">
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select CPNRPnum, 
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
			   CPNRPfecha, 
			   CPNRPmoduloOri#_Cat#' - '#_Cat#coalesce(Odescripcion,'') as Modulo, 
			   CPNRPdocumentoOri,
			   CPNRPreferenciaOri,
			   CPNRPfechaOri,
			   UsucodigoOri,
			   UsucodigoAutoriza, CPNRPfechaAutoriza,
			   CPNRPtipoCancela, 
			   UsucodigoCancela, coalesce(CPNRPfechaCancela,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(2000,1,1)#">) as CPNRPfechaCancela, 
			   CPNAPnum
		from CPNRP a
			inner join CPresupuestoPeriodo p
				on  a.Ecodigo = p.Ecodigo
				and a.CPPid = p.CPPid
			left outer join Origenes b
				on a.CPNRPmoduloOri = b.Oorigen
		where a.Ecodigo = #Session.Ecodigo#
		and a.CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">
		
	</cfquery>
	
	<!--- ver http://10.7.7.198/cfmx/sif/presupuesto/consultas/ConsNAP.cfm , compararlo 
	      2) ver http://10.7.7.198/cfmx/sif/presupuesto/versiones/versionesComun.cfm?cvid=517&cmayor=0020&cpresup=-100
		     no respeta los combos al agregar ---> 

	<cfif rsEncabezado.recordCount EQ 0>
		<cfset LvarNRPerror = Form.CPNRPnum>
	<cfelseif isdefined("LvarAprobacionNRP")>
		<cfset LvarMostrarHistoria = true>
		<cfif rsEncabezado.UsucodigoAutoriza NEQ "" OR rsEncabezado.CPNRPtipoCancela NEQ "0">
			<cfset LvarNRPerror = Form.CPNRPnum>
		</cfif>
	<cfelseif isdefined("LvarCancelacionNRP")>
		<cfset LvarMostrarHistoria = true>
		<cfif rsEncabezado.UsucodigoAutoriza EQ "" OR rsEncabezado.CPNRPtipoCancela NEQ "0" OR rsEncabezado.CPNAPnum NEQ "">
			<cfset LvarNRPerror = Form.CPNRPnum>
		</cfif>
	<cfelse>
		<cfset LvarMostrarHistoria = (rsEncabezado.UsucodigoAutoriza NEQ "")>
	</cfif>
</cfif>
<style type="text/css">
<!--
.style1 {color: #FF0000}
.pStyle_Signo {font-weight:bold}
.pStyle_Monto {font-weight:bold}

-->
</style>


<cfif not isdefined("Form.CPNRPnum") OR Form.CPNRPnum EQ "" OR isdefined("LvarNRPerror")>
	<br><br><br>
	<form method="post">
	<div align="center" style="font-weight:bold;">
	Numero de Rechazo Presupuestario NRP:&nbsp;&nbsp;
	<script language="javascript" src="../../js/utilesMonto.js"></script>
	<input name="CPNRPnum" id="CPNRPnum" 
			onblur="fm(this,-1);" 
			onfocus="javascript:this.value=qf(this); this.select();"  
			size="10" onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">&nbsp;&nbsp;
	<input type="submit" value="Aceptar">
	<br><br>
	<cfif isdefined("LvarNRPerror")>
		<cfoutput>
		<span class="style1">
		<cfif isdefined("LvarAprobacionNRP")>
			<cfif rsEncabezado.UsucodigoAutoriza NEQ "">
				El NRP=#Form.CPNRPnum# ya fue aprobado el #LSDateFormat(rsEncabezado.CPNRPfechaAutoriza)# a las #LSTimeFormat(rsEncabezado.CPNRPfechaAutoriza)#<BR>
				<cfif isdefined("rsEncabezado") AND rsEncabezado.CPNAPnum NEQ "">
				y fue aplicado con el NAP=#rsEncabezado.CPNAPnum#
				<cfelseif isdefined("rsEncabezado") AND rsEncabezado.CPNRPtipoCancela NEQ "0">
					pero fue cancelado el #LSDateFormat(rsEncabezado.CPNRPfechaCancela)# a las #LSTimeFormat(rsEncabezado.CPNRPfechaCancela)#<BR>
					<cfif isdefined("rsEncabezado") AND rsEncabezado.CPNRPtipoCancela EQ "1">
						porque el Documento Original se reintentó aplicar pero fue modificado posterior a su Rechazo original, y por tanto tiene asignado otro NRP
					<cfelseif isdefined("rsEncabezado") AND rsEncabezado.CPNRPtipoCancela EQ "2">
						porque el Documento Original se reintentó aplicar y no se Rechazó Presupuestariamente, y por tanto tiene asignado un NAP
					<cfelseif isdefined("rsEncabezado") AND rsEncabezado.CPNRPtipoCancela EQ "3">
						porque el Documento Original se reintentó aplicar y tenía abierto el control presupuestario de su Módulo Origen, y por tanto tiene asignado un NAP
					<cfelseif isdefined("rsEncabezado") AND rsEncabezado.CPNRPtipoCancela EQ "10">
						en forma manual
					</cfif>
				<cfelse>
				pero no se ha aplicado el Documento Original
				</cfif>
			<cfelseif isdefined("rsRestrictivo") AND rsRestrictivo.RecordCount GT 0>
				El NRP=#Form.CPNRPnum# es restrictivo y no se puede aprobar
			<cfelse>
				No existe el NRP=#Form.CPNRPnum#
			</cfif>
		<cfelseif isdefined("LvarCancelacionNRP")>
			<cfif isdefined("rsEncabezado") AND rsEncabezado.UsucodigoAutoriza EQ "">
				El NRP=#Form.CPNRPnum# no ha sido aprobado
			<cfelseif isdefined("rsEncabezado") AND rsEncabezado.CPNRPtipoCancela EQ "1">
				El NRP=#Form.CPNRPnum# fue generado para un Documento que se reintentó aplicar y se había modificado posterior a su Rechazo original, y por tanto tiene asignado otro NRP
			<cfelseif isdefined("rsEncabezado") AND rsEncabezado.CPNRPtipoCancela EQ "2">
				El NRP=#Form.CPNRPnum# fue generado para un Documento que se reintentó aplicar y no se Rechazó Presupuestariamente, y por tanto ya tiene asignado un NAP
			<cfelseif isdefined("rsEncabezado") AND rsEncabezado.CPNRPtipoCancela EQ "3">
				El NRP=#Form.CPNRPnum# fue generado para un Documento que se reintentó aplicar y tenía abierto el control presupuestario de su Módulo Origen, y por tanto ya tiene asignado un NAP
			<cfelseif isdefined("rsEncabezado") AND rsEncabezado.CPNRPtipoCancela EQ "10">
				El NRP=#Form.CPNRPnum# fue cancelado el #LSDateFormat(rsEncabezado.CPNRPfechaCancela)# a las #LSTimeFormat(rsEncabezado.CPNRPfechaCancela)#
			<cfelse>
				No existe el NRP=#Form.CPNRPnum#
			</cfif>
		<cfelse>
			No existe el NRP=#Form.CPNRPnum#
		</cfif>
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

<cfquery name="rsTotal" datasource="#Session.DSN#">
	select sum(CPNRPDsigno*CPNRPDmonto) as Monto
	  from CPNRPdetalle a
	 where a.Ecodigo = #Session.Ecodigo#
	   and a.CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">
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

<cfif rsEncabezado.UsucodigoAutoriza NEQ "">
	<cfquery name="rsUsuarioAutoriza" datasource="asp">
		select b.Pnombre #_Cat# rtrim(' ' #_Cat# b.Papellido1 #_Cat# rtrim(' ' #_Cat# b.Papellido2)) as NombreCompleto
		from Usuario a, DatosPersonales b
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.UsucodigoAutoriza#">
		  and a.Uestado = 1
		  and a.Utemporal = 0
		  and a.datos_personales = b.datos_personales
	</cfquery>
</cfif>

<cfset rsUsuarioCancela.NombreCompleto = "">
<cfif rsEncabezado.UsucodigoCancela NEQ "">
	<cfquery name="rsUsuarioCancela" datasource="asp">
		select b.Pnombre #_Cat# rtrim(' ' #_Cat# b.Papellido1 #_Cat# rtrim(' ' #_Cat# b.Papellido2)) as NombreCompleto
		from Usuario a, DatosPersonales b
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.UsucodigoCancela#">
		  and a.Uestado = 1
		  and a.Utemporal = 0
		  and a.datos_personales = b.datos_personales
	</cfquery>
</cfif>

<cfif rsEncabezado.CPNAPnum NEQ "">
	<cfquery name="rsNAPaplicacion" datasource="#Session.DSN#">
		select CPNAPfecha, UsucodigoOri
 		  from CPNAP
		 where Ecodigo = #Session.Ecodigo#
		   and CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.CPNAPnum#">
	</cfquery>
	<cfquery name="rsUsuarioAplica" datasource="asp">
		select b.Pnombre #_Cat# rtrim(' ' #_Cat# b.Papellido1 #_Cat# rtrim(' ' #_Cat# b.Papellido2)) as NombreCompleto
		from Usuario a, DatosPersonales b
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	      and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNAPaplicacion.UsucodigoOri#">
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
		<cf_web_portlet_start titulo="Numero de Rechazo Presupuestario">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2" bgcolor="##E5E5E5">
		  <tr>
			<td rowspan="3" align="right" nowrap class="fileLabel">DOCUMENTO RECHAZO</td>
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
			<td align="right" nowrap class="fileLabel">NRP:</td>
			<td nowrap>
				#rsEncabezado.CPNRPnum#
			</td>
			<td align="right" nowrap class="fileLabel">Fecha Rechazo:</td>
			<td colspan="3" nowrap>
				#LSDateFormat(rsEncabezado.CPNRPfecha,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezado.CPNRPfecha,'HH:MM:SS')#
			</td>
		  </tr>
			<tr>
			  <td class="fileLabel" align="right" nowrap>Total Rechazado:</td>
			  <td colspan="3">#LSCurrencyFormat(rsTotal.monto,'none')# (#LvarMnombreEmpresa#)</td>
			</tr>
		  <tr><td style="height:1px; background-color:##999999" colspan="8"></td></tr>
		  <tr>
			<td rowspan="2" align="right" nowrap class="fileLabel">DOCUMENTO ORIGINAL</td>
			<td class="fileLabel" align="right" nowrap>M&oacute;dulo:</td>
			<td nowrap colspan="3">#rsEncabezado.Modulo#</td>
			<td class="fileLabel" align="right" nowrap>Referencia:</td>
			<td nowrap>#rsEncabezado.CPNRPreferenciaOri#&nbsp;</td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>Documento:</td>
			<td nowrap>#rsEncabezado.CPNRPdocumentoOri#</td>
			<td class="fileLabel" align="right" nowrap>Fecha:</td>
			<td nowrap>#LSDateFormat(rsEncabezado.CPNRPfechaOri,'dd/mm/yyyy')#</td>
			<td class="fileLabel" align="right" nowrap>Usuario: </td>
			<td nowrap colspan="3">#rsUsuarioOrigen.NombreCompleto#</td>
		  </tr>
		  <cfif rsEncabezado.UsucodigoAutoriza NEQ "">
		  <tr><td style="height:1px; background-color:##999999" colspan="8"></td></tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>APROBACION</td>
			<td class="fileLabel" align="right" nowrap><cfif rsEncabezado.UsucodigoAutoriza EQ "">NO<cfelse>OK </cfif></td>
			<td nowrap>&nbsp;</td>
			<td class="fileLabel" align="right" nowrap>Fecha Aprobacion:</td>
			<td nowrap>#LSDateFormat(rsEncabezado.CPNRPfechaAutoriza,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezado.CPNRPfechaAutoriza,'HH:MM:SS')#</td>
			<td class="fileLabel" align="right" nowrap>Aprobado por:</td>
			<td nowrap>#rsUsuarioAutoriza.NombreCompleto#</td>
		  </tr>
			  <cfif rsEncabezado.CPNAPnum NEQ "">
			  <tr><td style="height:1px; background-color:##999999" colspan="8"></td></tr>
			  <tr>
				<td class="fileLabel" align="right" nowrap>APLICACION</td>
				<td align="right" nowrap class="fileLabel style1">
					<a style="text-decoration:underline; color:##333399" href="../consultas/ConsNAP.cfm?NAP=#rsEncabezado.CPNAPnum#">NAP:</a>
				</td>
				<td nowrap>
					<a style="text-decoration:underline; color:##333399" href="../consultas/ConsNAP.cfm?NAP=#rsEncabezado.CPNAPnum#">#rsEncabezado.CPNAPnum#</a>
				</td>
				<td class="fileLabel" align="right" nowrap>Fecha Aplicacion:</td>
				<td nowrap>#LSDateFormat(rsNAPaplicacion.CPNAPfecha,'dd/mm/yyyy')# #LSTimeFormat(rsNAPaplicacion.CPNAPfecha,'HH:MM:SS')#</td>
				<td class="fileLabel" align="right" nowrap>Aplicado por:</td>
				<td nowrap>#rsUsuarioAplica.NombreCompleto#</td>
			  </tr>
			  </cfif>
		  </cfif>
		  <cfif rsEncabezado.CPNRPtipoCancela NEQ "0">
		  <tr><td style="height:1px; background-color:##999999" colspan="8"></td></tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>CANCELACION <cfif rsEncabezado.CPNRPtipoCancela EQ "10">MANUAL<cfelse>AUTOMÁTICA</cfif></td>
			<td nowrap>&nbsp;</td>
		  	<td  class="fileLabel style1" colspan="6">
				<cfif rsEncabezado.CPNRPtipoCancela EQ "1">
					El Documento Original fue modificado, la aprobación de este NRP queda inhabilitada
				<cfelseif rsEncabezado.CPNRPtipoCancela EQ "2">
					El Documento se reintentó aplicar y no fue Rechazado Presupuestariamente, ya tiene asigando un NAP
				<cfelseif rsEncabezado.CPNRPtipoCancela EQ "3">
					El Documento se reintentó aplicar y tenía abierto el control presupuestario de su modulo origen, ya tiene asigando un NAP
				<cfelseif rsEncabezado.CPNRPtipoCancela EQ "10">
					El NRP aprobado pero pendiente de aplicar fue cancelado manualmente
				</cfif>
			</td>
		</tr>
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td class="fileLabel" align="right" nowrap>Fecha Cancelacion:</td>
			<td nowrap>#LSDateFormat(rsEncabezado.CPNRPfechaCancela,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezado.CPNRPfechaCancela,'HH:MM:SS')#</td>
			<td class="fileLabel" align="right" nowrap>Cancelado por:</td>
			<td nowrap>#rsUsuarioCancela.NombreCompleto#</td>
		  </tr>
		  </cfif>
		  </tr>
		</table>
		<cf_web_portlet_end>
		</cfoutput>
	</td>
  </tr>
  <cfflush interval="64">
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">&nbsp;</td>
  </tr>
  <tr>
    <td align="center" style="padding-left: 10px; padding-right: 10px;">
		<cfif isdefined("LvarAprobacionNRP")>
			<cfset rsLista = fnCalculaLista()>
			<cfquery name="rsRestrictivo" dbtype="query">
				select count(1) as cantidad
				  from rsLista
				 where CPCPtipoControl = 2
				   and DisponibleNeto < 0
			</cfquery>
			<cfset LvarHayRestrictivos = rsRestrictivo.cantidad GT 0>
		<cfelse>
			<cfset rsLista = fnQueryLista()>
		</cfif>

		<cfif isdefined("url.Lin")>
			<cfif not LvarMostrarHistoria>
				<cf_errorCode	code = "50464" msg = "La Historia del NRP no se permite en este momento">
			</cfif>
			<cf_web_portlet_start titulo="Historia de la línea del NRP">
				<cfoutput>
				<table width="60%" align="center">
					<tr>
						<td>
							Linea
						</td>
						<td>
							#rsLista.CPNRPDlinea#
						</td>
					</tr>
					<tr>
						<td>
							Mes
						</td>
						<td>
							 #rsLista.MesDescripcion#
						</td>
					</tr>
					<tr>
						<td>
							Cuenta Presupuesto
						</td>
						<td>
							 #rsLista.CuentaPresupuesto#
						</td>
					</tr>
					<tr>
						<td>
							Oficina
						</td>
						<td>
							 #rsLista.Oficodigo# - #rsLista.Odescripcion#
						</td>
					</tr>
					<tr>
						<td>
							Tipo Control
						</td>
						<td>
							#rsLista.TipoControl#
						</td>
					</tr>
					<tr>
						<td>
							Cálculo Control
						</td>
						<td>
							#rsLista.CalculoControl#
						</td>
					</tr>
					<tr>
						<td>
							Tipo Movimiento
						</td>
						<td>
							#rsLista.TipoMovimiento#
						</td>
					</tr>
					<tr>
						<td>&nbsp;
							
						</td>
						<td>&nbsp;
							
						</td>
					</tr>
					<tr>
						<td>
							<strong>DATOS HISTORICOS DEL RECHAZO (1)</strong>
						</td>
						<td>
						</td>
					</tr>
					<tr>
						<td>
							Disponible Antes del Rechazo
						</td>
						<td align="right">
							#LsCurrencyFormat(rsLista.CPNRPDdisponibleAntes,"none")#
						</td>
					</tr>
					<tr>
						<td>
							Monto Movimiento
						</td>
						<td align="right">
							#rsLista.Signo#&nbsp;#LsCurrencyFormat(rsLista.Monto,"none")#
						</td>
					</tr>
					<tr>
						<td>
							Rechazos Aprobados Pendientes <strong>(4)</strong> antes Rechazo
						</td>
						<td align="right">
							#LsCurrencyFormat(rsLista.CPNRPDpendientesAntes,'none')#
						</td>
					</tr>
					<tr <cfif rsLista.CPNRPDconExceso> style="color:##FF0000"</cfif>>
						<td>
							Disponible Neto Rechazado
				<cfif rsLista.CPNRPDconExceso EQ "1">
							(<strong>Provocó Rechazo Presupuestario</strong>)
				</cfif>
						</td>
						<td align="right">
							#LsCurrencyFormat(rsLista.DisponibleNeto,'none')#
						</td>
					</tr>
					<tr>
						<td>&nbsp;
							
						</td>
						<td>&nbsp;
							
						</td>
					</tr>
					<tr>
						<td>
							<strong>DATOS HISTORICOS DE LA APROBACION (2)</strong>
						</td>
						<td>
						</td>
					</tr>
					<tr>
						<td>
							Disponible Antes de la Aprobación
						</td>
						<td align="right">
							#LsCurrencyFormat(rsLista.CPNRPDdisponibleAntesAprobar,'none')#
						</td>
					</tr>
					<tr>
						<td>
							Monto Movimiento
						</td>
						<td align="right">
							#rsLista.Signo#&nbsp;#LsCurrencyFormat(rsLista.Monto,'none')#
						</td>
					</tr>
					<tr>
						<td>
							Rechazos Aprobados Pendientes antes de la Aprobación
						</td>
						<td align="right">
							#LsCurrencyFormat(rsLista.CPNRPDpendientesAntesAprobar,'none')#
						</td>
					</tr>
					<cfif rsNRPD_TOT.DisponibleNetoTotal eq "">
						<cfset rsNRPD_TOT.DisponibleNetoTotal = 0>
					</cfif>
					<cfset LvarExcesoAprobar = rsLista.CPCPtipoControl NEQ "0" AND rsNRPD_TOT.DisponibleNetoTotal lt 0>
					<tr <cfif LvarExcesoAprobar and rsNRPD_TOT.MovimientosCuenta EQ 1> style="color:##FF0000"</cfif>>
						<td>
							Disponible Neto en el momento de la Aprobación
							<cfif LvarExcesoAprobar and rsNRPD_TOT.MovimientosCuenta EQ 1>
								<cfif rsLista.CPCPtipoControl EQ "1">
									<BR>(<strong>Puede generar Exceso</strong>)
								<cfelseif rsLista.CPCPtipoControl EQ "2">
									<BR>(<strong>No permite la Aprobación</strong>)
								</cfif>
							</cfif>
						</td>
						<td align="right">
							#LsCurrencyFormat(rsLista.DisponibleNetoAprobar,'none')#
						</td>
					</tr>
			<cfif LvarExcesoAprobar>
					<tr>
						<td>&nbsp;
							
						</td>
						<td>&nbsp;
							
						</td>
					</tr>
				<cfif rsNRPD_TOT.MovimientosCuenta GT 1>
					<tr <cfif rsNRPD_TOT.DisponibleNetoTotal lt 0> style="color:##FF0000"</cfif>>
						<td>
							Disponible Neto Final de la Cuenta durante la Aprobación
							<cfif LvarExcesoAprobar>
								<cfif rsLista.CPCPtipoControl EQ "1">
									<BR>(<strong>Puede generar Exceso</strong>)
								<cfelseif rsLista.CPCPtipoControl EQ "2">
									<BR>(<strong>No permite la Aprobación</strong>)
								</cfif>
							</cfif>
						</td>
						<td align="right">
							#LsCurrencyFormat(rsNRPD_TOT.DisponibleNetoTotal,'none')#
						</td>
					</tr>
				</cfif>
					<tr>
						<td>
							Excesos Autorizados en el momento de la Aprobación
						</td>
						<td align="right">
							#LsCurrencyFormat(rsLista.CPNRPDextraordinAntesAprobar,'none')#
						</td>
					</tr>
				<cfif rsLista.CPCPtipoControl EQ "1">
					<tr>
						<td>
							<strong>Máximo Posible de Excesos Totales aceptados en la Aprobación</strong>
						</td>
						<td align="right">
							<strong>#LsCurrencyFormat(rsLista.CPNRPDextraordinAntesAprobar-rsNRPD_TOT.DisponibleNetoTotal,'none')#</strong>
						</td>
					</tr>
				</cfif>
			</cfif>
			<cfif rsEncabezado.CPNAPnum NEQ "">
				<cfquery name="rsNAPD" datasource="#Session.DSN#">
					select	case when a.CPNAPDsigno >= 0 then '(+)' else '(-)' end as Signo,
							a.CPNAPDmonto as Monto,
							a.CPNAPDdisponibleAntes,
							a.CPNAPDdisponibleAntes + a.CPNAPDsigno*a.CPNAPDmonto as CPNAPDdisponibleGenerado
					from 	CPNAPdetalle a
						inner join CPNAP b
							on b.Ecodigo = #Session.Ecodigo# 
							  and b.Ecodigo = a.Ecodigo 
							  and b.CPNAPnum = a.CPNAPnum
					where	a.Ecodigo = #Session.Ecodigo# 
					  and 	a.CPNAPnum = #rsEncabezado.CPNAPnum#
					  and 	a.CPNAPDlinea = #url.Lin#
				</cfquery>
				<cfquery name="rsNAP_ME" datasource="#Session.DSN#">
					select	exD.CPNAPDmonto as Excedente
					  from 	CPNAP exE
						inner join CPNAPdetalle exD
							 on exD.Ecodigo 	= #Session.Ecodigo# 
							and exD.CPcuenta 	= #rsLista.CPcuenta#
						    and exD.CPCano		= #rsLista.CPCano#
						    and exD.CPCmes		= #rsLista.CPCmes#
						    and exD.Ocodigo		= #rsLista.Ocodigo#
							and exD.Ecodigo 	= exE.Ecodigo
							and exD.CPNAPnum 	= exE.CPNAPnum
					where	exE.Ecodigo = #Session.Ecodigo# 
					  and 	exE.CPNAPnumModificado = #rsEncabezado.CPNAPnum#
				</cfquery>
				<cfquery name="rsNRPD_TOT" datasource="#Session.DSN#">
					select 	count(1) as MovimientosCuenta,
							min (coalesce(x.CPNRPDdisponibleAntesAprobar,0) + x.CPNRPDsigno*x.CPNRPDmonto + coalesce(x.CPNRPDpendientesAntesAprobar,0)) as DisponibleNetoTotal
					  from CPNRPdetalle x
					 where x.Ecodigo 	= #Session.Ecodigo# 
					   and x.CPNRPnum 	= #rsEncabezado.CPNRPnum#
					   and x.CPcuenta 	= #rsLista.CPcuenta#
					   and x.CPCano		= #rsLista.CPCano#
					   and x.CPCmes		= #rsLista.CPCmes#
					   and x.Ocodigo	= #rsLista.Ocodigo#
				</cfquery>
					<tr>
						<td>&nbsp;
							
						</td>
						<td>&nbsp;
							
						</td>
					</tr>
					<tr>
						<td>
							<strong>DATOS HISTORICOS DE LA APLICACION  (3)</strong> (NAP: #rsEncabezado.CPNAPnum#)
						</td>
						<td>
						</td>
					</tr>
					<tr>
						<td>
							Modificacion Extraordinaria Generada Antes de la Aplicacion
						</td>
						<td align="right">
							#LsCurrencyFormat(rsNAP_ME.Excedente,'none')#
						</td>
					</tr>
					<tr>
						<td>
							Disponible Antes de la Aplicacion
						</td>
						<td align="right">
							#LsCurrencyFormat(rsNAPD.CPNAPDdisponibleAntes,'none')#
						</td>
					</tr>
					<tr>
						<td>
							Monto Movimiento
						</td>
						<td align="right">
							#rsNAPD.Signo#&nbsp;#LsCurrencyFormat(rsNAPD.Monto,'none')#
						</td>
					</tr>
					<tr>
						<td>
							Disponible Real Generado
						</td>
						<td align="right">
							#LsCurrencyFormat(rsNAPD.CPNAPDdisponibleGenerado,'none')#
						</td>
					</tr>
			</cfif>					
					<tr>
						<td>&nbsp;
							
						</td>
						<td>&nbsp;
							
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<table>
								<tr>
									<td width="1" valign="top">
										<strong>(*)</strong>
									</td>
									<td>
								<cfif rsLista.CPCPtipoControl EQ "0">
										Una Cuenta Presupuestaria cuyo Tipo de Control sea Abierto, no genera ni Rechazo ni Exceso Presupuestario.
								<cfelseif rsLista.CPCPtipoControl EQ "1">
										Una Cuenta Presupuestaria cuyo Tipo de Control sea Restringido, puede generar Rechazo Presupuestario y puede ser Aprobado.
								<cfelseif rsLista.CPCPtipoControl EQ "2">
										Una Cuenta Presupuestaria cuyo Tipo de Control sea Restrictivo, puede generar Rechazo Presupuestario pero no pueden ser Aprobado (no generan Excesos), y generarán Modificación Extraordinaria únicamente si se excede su presupuesto cuando son enviados desde un Módulo Origen cuyo Control haya sido Abierto.
								</cfif>
									</td>
								</tr>
							<cfif rsLista.CPCPtipoControl EQ "1">
								<tr>
									<td width="1" valign="top">
										<strong>(1)</strong>
									</td>
									<td>
										La línea del documento provoca un rechazo presupuestario únicamente cuando genera un Disponible Neto negativo (Disponible Anterior - Monto - Pendientes)
									</td>
								</tr>
								<tr>
									<td width="1" valign="top">
										<strong>(2)</strong>
									</td>
									<td>
										El documento podría generar un Exceso o Modificación Extraordinaria cuando genera un Disponible Neto Final negativo para la misma cuenta, oficina, año y mes de presupuesto.<BR>
										Sin embargo, la Modificación Extraordinaria se generará en el momento de la Aplicación, y su monto dependerá del orden en que se apliquen los documentos con NRPs pendientes, por cancelación de NRPs Aprobados pendientes de aplicar y por otros documentos que den fondos a la cuenta. Es posible que durante la aplicación no se genere Modificación Extraordinaria.<BR>
										Sin embargo, aunque no se pueda determinar el monto exacto de la Modificación Extraordinaria que se generará en la aplicación futura del documento, durante la Aprobación del NRP se está aceptando que la cuenta pueda llegar en algún momento a excederse, <strong>como máximo</strong>, en el monto de 'Máximo Posible de Excedentes Totales aceptados en la Aprobación'.
									</td>
								</tr>
								<tr>
									<td width="1" valign="top">
										<strong>(3)</strong>
									</td>
									<td>
										El monto de la Modificación Extraordinaria durante la Aplicación del Documento queda determinado por el monto negativo generado del Disponible Real Final (Disponible Anterior - Monto) para la misma cuenta, oficina, año y mes de presupuesto.
									</td>
								</tr>
								<tr>
									<td width="1" valign="top">
										<strong>(4)</strong>
									</td>
									<td>
										Los Rechazos Aprobados Pendientes de Aplicar son el total de movimientos por Documento que disminuyen el Presupuesto de una cuenta, oficina, año y mes de presupuesto, para todos aquellos NRPs que han sido Aprobados pero que están pendientes de Aplicación y no han sido Cancelados.<BR>
										Su objetivo es determinar cuando se debe provocar un Rechazo Presupuestario (NRP) y determinar el Máximo Posible de Excedentes Totales aceptados durante la Aprobación.
									</td>
								</tr>
							</cfif>
							</table>
						</td>
					</tr>
				</table>
				</cfoutput>
			<cf_web_portlet_end>
		<cfelse>
			<cf_web_portlet_start titulo="Detalle del NRP">
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="CPNRPDlinea, MesDescripcion, CuentaPresupuesto, Oficodigo, TipoControl, CalculoControl, TipoMovimiento, DisponibleAnterior, Signo, Monto, Pendientes, DisponibleNeto, Historia"/>
					<cfif LvarMostrarHistoria>
						<cfinvokeargument name="etiquetas" value="Lin., Mes, Cuenta<br>Presupuesto, Oficina, Tipo<br>Control, Cálculo<br>Control, Tipo<br>Movimiento,Disponible<br>Antes de<br>Aprobación,Signo<BR>Monto,Monto<BR>Movimiento, Rechazos<BR>Pendientes<BR>antes Aprobar, Disponible<br>Neto<BR>Pendiente, Historia<BR>Línea"/>
					<cfelse>
						<cfinvokeargument name="etiquetas" value="Lin., Mes, Cuenta<br>Presupuesto, Oficina, Tipo<br>Control, Cálculo<br>Control, Tipo<br>Movimiento,Disponible<br>Antes de<br>Rechazo,Signo<BR>Monto,Monto<BR>Rechazado, Rechazos<BR>Pendientes<BR>antes Rechazo, Disponible<br>Neto<BR>Rechazado, "/>
					</cfif>
					<cfinvokeargument name="formatos" value="V,V,V,V,V,V,V,M,S,M,M,M,V"/>
					<cfinvokeargument name="lineaRoja" value="CPNRPDconExceso EQ 1"/>
					<cfinvokeargument name="align" value="right, center, left, left, center, center, center, right, center, right, right, right, center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="formName" value="listaNRPS"/>
					<cfinvokeargument name="MaxRows" value="0"/>
					<cfinvokeargument name="PageIndex" value="10"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			<cf_web_portlet_end>
			</td>
		</tr>
		<tr>
			<td class="style1">&nbsp;&nbsp;&nbsp;(*) Movimientos que provocaron el Rechazo Presupuestario</td>
		</tr>
			<cfif isdefined("LvarAprobacionNRP")>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;(1) Unicamente los movimientos con 'Disponibles Netos Pendientes' negativos podrían generar Excesos</td>
				</tr>
			</cfif>

		</cfif>
	
  
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
<cfoutput>
	<cfset LvarTemplate = mid(getBaseTemplatePath(),len(expandPath("/")),200)>
	<cfset LvarTemplate = '/cfmx' & replace(LvarTemplate,"\","/","ALL")>
	<script language="javascript1.2" type="text/javascript">
		function fnConsultaNRP(NRP, LIN){
			var param  = "NRP=" + NRP + "&LIN=" + LIN;
			<cfif LvarMostrarHistoria>
				param  = param + "&A=1";
			</cfif>
			document.listaNRPS.nosubmit=true;
			
			if (NRP != "" && LIN != "") {
				document.location.href = '#LvarTemplate#?' + param;
			}
			return false;
		}
	</script>
</cfoutput>

<cffunction name="fnCalculaLista" returntype="query">
	<cftransaction>
		<cfinvoke 
		 component="sif.Componentes.PRES_Presupuesto"
		 method="sbAjustaNrpAprobar">
			<cfinvokeargument name="NRP" value="#Form.CPNRPnum#"/>
			<cfinvokeargument name="Conexion" value="#session.dsn#"/>
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
		</cfinvoke>

		<cfset rsLista = fnQueryLista()>
		<cftransaction action="rollback" />
	</cftransaction>
	<cfreturn rsLista>
</cffunction>

<cffunction name="fnQueryLista" returntype="query">
	<cfif not isdefined("url.lin")>
		<cfquery name="rsOrderBy" datasource="#Session.DSN#">
			select	CPCano, CPCmes, CPcuenta, Ocodigo, 
					count(abs(CPNRPDlinea)) as Cantidad
			from 	CPNRPdetalle
			where	Ecodigo = #Session.Ecodigo# 
			  and 	CPNRPnum = #Form.CPNRPnum#
			group 	by CPCano, CPCmes, CPcuenta, Ocodigo
			having	count(abs(CPNRPDlinea)) > 1
		</cfquery>
		<cfset LvarOrderByLinea = (rsOrderBy.CPcuenta EQ "")>
	</cfif>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsLista" datasource="#Session.DSN#">
		select	a.CPNRPnum,
				a.CPNRPDlinea, 
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
				o.Odescripcion, o.Oficodigo,
				(case a.CPNRPDtipoMov
					when 'A'  	then 'Presupuesto<BR>Ordinario'
					when 'M'  	then 'Presupuesto<BR>Extraordinario'
					when 'ME'  	then 'Excesos<BR>Autorizados'
					when 'VC' 	then 'Variación<BR>Cambiaria'
					when 'T'  	then 'Traslado<BR>Interno'
					when 'TE'  	then 'Traslado<BR>Aut.Externa'
					when 'RA' 	then 'Reserva<BR>Per.Ant.'
					when 'CA' 	then 'Compromiso<BR>Per.Ant.'
					when 'RP' 	then 'Provisión<BR>Presupuestaria'
					when 'RC' 	then 'Reserva'
					when 'CC' 	then 'Compromiso'
					when 'E'  	then 'Ejecución'
					else ''
				end) as TipoMovimiento,
				case when a.CPNRPDsigno >= 0 then '(+)' else '(-)' end as Signo,
				a.CPNRPDmonto as Monto,
				a.CPNRPDconExceso,
				b.CPformato as CuentaPresupuesto,
				a.CPCPtipoControl,
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
				end as CalculoControl, 
				<cfif isdefined("url.lin")>  <!--- Pantalla de Consulta --->
					a.CPcuenta, a.CPCano, a.CPCmes, a.Ocodigo,
					a.CPNRPDdisponibleAntes,
					a.CPNRPDpendientesAntes,
					a.CPNRPDdisponibleAntes + a.CPNRPDsigno*a.CPNRPDmonto + a.CPNRPDpendientesAntes as DisponibleNeto,
					a.CPNRPDdisponibleAntesAprobar,
					a.CPNRPDpendientesAntesAprobar,
					coalesce(a.CPNRPDdisponibleAntesAprobar,0) + a.CPNRPDsigno*a.CPNRPDmonto + coalesce(a.CPNRPDpendientesAntesAprobar,0) as DisponibleNetoAprobar,
					coalesce(a.CPNRPDextraordinAntesAprobar,0) as CPNRPDextraordinAntesAprobar
				<cfelse>
					<cfif LvarMostrarHistoria>
						a.CPNRPDdisponibleAntesAprobar as DisponibleAnterior,
						a.CPNRPDpendientesAntesAprobar as Pendientes,
						a.CPNRPDdisponibleAntesAprobar + a.CPNRPDsigno*a.CPNRPDmonto + a.CPNRPDpendientesAntesAprobar as DisponibleNeto,
					<cfelse>
						a.CPNRPDdisponibleAntes as DisponibleAnterior,
						a.CPNRPDpendientesAntes as Pendientes,
						a.CPNRPDdisponibleAntes + a.CPNRPDsigno*a.CPNRPDmonto + a.CPNRPDpendientesAntes as DisponibleNeto,
					</cfif>
					<cfif LvarMostrarHistoria>
						'<img style=''cursor=pointer;'' alt=''Consulta la información Histórica de la linea del NRP'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNRP(' #_Cat#
						<cf_dbfunction name="to_char" args="a.CPNRPnum" datasource="#session.DSN#">
						 #_Cat#','#_Cat#
						<cf_dbfunction name="to_char" args="a.CPNRPDlinea" datasource="#session.DSN#">
						 #_Cat#');''>'
					<cfelse>
					' '
					</cfif>
					as Historia
				</cfif>
		from 	CPNRPdetalle a
					left join CPresupuesto b
						 on b.CPcuenta = a.CPcuenta
						and b.Ecodigo  = a.Ecodigo
					left join Oficinas o
						 on o.Ecodigo = a.Ecodigo
						and o.Ocodigo = a.Ocodigo
		where	a.Ecodigo = #Session.Ecodigo# 
		  and 	a.CPNRPnum = #Form.CPNRPnum#
		<cfif isdefined("url.Lin")>
		  and 	a.CPNRPDlinea = #url.Lin#
		<cfelseif LvarOrderByLinea>
		  order by abs(a.CPNRPDlinea), a.CPNRPDsigno*a.CPNRPDmonto desc
		<cfelse>
		  order by a.CPCano, a.CPCmes, b.CPformato, o.Oficodigo, a.CPNRPDsigno*a.CPNRPDmonto desc
		</cfif>
	</cfquery>
	<cfif isdefined("url.Lin")>
		<cfquery name="rsNRPD_TOT" datasource="#Session.DSN#">
			select 	count(1) as MovimientosCuenta,
					min (coalesce(x.CPNRPDdisponibleAntesAprobar,0) + x.CPNRPDsigno*x.CPNRPDmonto + coalesce(x.CPNRPDpendientesAntesAprobar,0)) 
					as DisponibleNetoTotal
			  from CPNRPdetalle x
			 where x.Ecodigo 	= #Session.Ecodigo# 
			   and x.CPNRPnum 	= #form.CPNRPnum#
			   and x.CPcuenta 	= #rsLista.CPcuenta#
			   and x.CPCano		= #rsLista.CPCano#
			   and x.CPCmes		= #rsLista.CPCmes#
			   and x.Ocodigo	= #rsLista.Ocodigo#
		</cfquery>
	</cfif>
	<cfreturn rsLista>
</cffunction>



