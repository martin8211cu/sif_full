<cf_templatecssreport>
<script language="javascript">
	function fnclose()
	{
	window.close();
	}
</script>
<cfif isdefined('form.btnimprimir')>
	<cfset w = 800>
	<cfset h = 800>
	<cfif ListFind('Excel,RTF',form.format)>
		<cfset w = false>
		<cfset h = false>
	</cfif>
	<script language="javascript">
		window.opener.popup(true,<cfoutput>#w#</cfoutput>,<cfoutput>#h#</cfoutput>,"<cfoutput>#form.format#</cfoutput>");
	</script>
<cfelseif isdefined('url.imprimir')>
	<cfoutput>
		<cfset crearQuerys(url.CPNAPnum,isdefined('url.chkCeros'))>
        <cfreport format="#url.format#" query="rsReporte" template="ConsNAP.cfr">
			<cfreportparam name="Periodo" 			value="#rsEncabezado.CPPdescripcion#">
			<cfreportparam name="NAP" 				value="#rsEncabezado.CPNAPnum#">
			<cfreportparam name="TAutorizado" 		value="#rsTotal.Monto#">
			<cfreportparam name="Mes" 				value="#rsEncabezado.CPCano#-#rsEncabezado.MesDescripcion#">
			<cfreportparam name="AutorizadoPor"		value="#rsUsuarioAutoriza.NombreCompleto#">
			<cfreportparam name="FechaAutorizacion"	value="#LSDateFormat(rsEncabezado.CPNAPfecha,'dd/mm/yyyy')# #LSTimeFormat(rsEncabezado.CPNAPfecha,'HH:MM:SS')#">
			<cfreportparam name="Modulo"			value="#rsEncabezado.Modulo#">
			<cfreportparam name="Documento"			value="#rsEncabezado.CPNAPdocumentoOri#">
			<cfreportparam name="Fecha"				value="#LSDateFormat(rsEncabezado.CPNAPfechaOri,'dd/mm/yyyy')#">
			<cfreportparam name="Usuario"			value="#rsUsuarioOrigen.NombreCompleto#">
			<cfreportparam name="Referencia"		value="#rsEncabezado.CPNAPreferenciaOri#">
        </cfreport>
	</cfoutput>
</cfif>
<cf_web_portlet_start titulo="Autorizacion Presupuestaria">
	<form name="form1" action="ConsNAP-PopUp.cfm" method="post">
        <table border="0" align="center">
            <tr>
                <td>
                    Impresion de Autorizacion Presupuestaria
                </td>
            </tr>
            <tr>
                <td>Formato:
					<select name="format" id="format">
						<option value="Excel">Excel</option>
						<option value="FlashPaper">FlashPaper</option>
						<option value="PDF">PDF</option>
						<option value="RTF">RTF</option>
					</select>
				</td>
            </tr>
            <tr>
                <td align="center">
                    <input type="submit" name="btnimprimir" class="btnimprimir" value="Imprimir">
                    <input type="button" name="btnNormal" 	class="btnNormal" 	value="Cerrar" onclick="fnclose();">
					
                </td>
            </tr>
        </table>
     </form>
<cf_web_portlet_end>
<cffunction name="crearQuerys" access="private">
	<cfargument name="CPNAPnum" type="numeric" required="yes">
	<cfargument name="chkCeros" type="boolean" required="no" default="true">
	
	<cf_dbfunction name="OP_concat"  returnvariable="_Cat">
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select napE.CPNAPnum, 'Presupuesto ' #_Cat#
			case CPPtipoPeriodo 
				when 1 then 'Mensual' 
				when 2 then 'Bimestral' 
				when 3 then 'Trimestral' 
				when 4 then 'Cuatrimestral' 
				when 6 then 'Semestral' 
				when 12 then 'Anual' 
			else '' end #_Cat# ' de ' #_Cat# 
			case {fn month(CPPfechaDesde)} 
				when 1 then 'Enero' 
				when 2 then 'Febrero' 
				when 3 then 'Marzo' 
				when 4 then 'Abril' 
				when 5 then 'Mayo' 
				when 6 then 'Junio' 
				when 7 then 'Julio' 
				when 8 then 'Agosto' 
				when 9 then 'Setiembre' 
				when 10 then 'Octubre' 
				when 11 then 'Noviembre' 
				when 12 then 'Diciembre' 
				else '' end #_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}"> #_Cat# ' a ' #_Cat# 
			case {fn month(CPPfechaHasta)} 
				when 1 then 'Enero' 
				when 2 then 'Febrero' 
				when 3 then 'Marzo' 
				when 4 then 'Abril' 
				when 5 then 'Mayo'
				when 6 then 'Junio' 
				when 7 then 'Julio' 
				when 8 then 'Agosto' 
				when 9 then 'Setiembre' 
				when 10 then 'Octubre' 
				when 11 then 'Noviembre' 
				when 12 then 'Diciembre' 
				else '' end #_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as CPPdescripcion,
		   	napE.CPPid, CPPtipoPeriodo, CPPfechaDesde, CPPfechaHasta, napE.CPCano, napE.CPCmes, 
		   	case napE.CPCmes 
		   		when 1 then 'Enero' 
				when 2 then 'Febrero' 
				when 3 then 'Marzo' 
				when 4 then 'Abril' 
				when 5 then 'Mayo' 
				when 6 then 'Junio' 
				when 7 then 'Julio' 
				when 8 then 'Agosto' 
				when 9 then 'Setiembre' 
				when 10 then 'Octubre' 
				when 11 then 'Noviembre' 
				when 12 then 'Diciembre' 
				else '' end 
			as MesDescripcion, CPNAPfecha, CPNAPmoduloOri #_Cat# ' - ' #_Cat#coalesce(Odescripcion,'') as Modulo, 
			CPNAPdocumentoOri, CPNAPreferenciaOri, CPNAPfechaOri, CPNAPnumReversado, UsucodigoOri, UsucodigoAutoriza, CPOid
		from CPNAP napE
			inner join CPresupuestoPeriodo cpp
				on cpp.CPPid = napE.CPPid
			left outer join Origenes ori
				on ori.Oorigen = napE.CPNAPmoduloOri
		where napE.Ecodigo = #Session.Ecodigo#
		  and napE.CPNAPnum = #Arguments.CPNAPnum#
	</cfquery>
	<cfif rsEncabezado.recordCount gt 0>
		<cfquery name="rsTotal" datasource="#Session.DSN#">
			select sum(CPNAPDsigno * CPNAPDmonto) as Monto
			  from CPNAPdetalle a
			 where a.Ecodigo = #Session.Ecodigo#
			   and a.CPNAPnum = #Arguments.CPNAPnum#
		</cfquery>
		<cfif rsTotal.Monto EQ "">
			<cfset rsTotal.Monto = 0>
		</cfif>
	</cfif>
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
	<cfquery name="rsOrderBy" datasource="#Session.DSN#">
		select	CPCano, CPCmes, CPcuenta, Ocodigo, count(abs(CPNAPDlinea)) as Cantidad
		from 	CPNAPdetalle
		where	Ecodigo = #Session.Ecodigo# 
		  and 	CPNAPnum = #Arguments.CPNAPnum#
		group 	by CPCano, CPCmes, CPcuenta, Ocodigo
		having	count(abs(CPNAPDlinea)) > 1
	</cfquery>
	<cfset LvarOrderByLinea = (rsOrderBy.CPcuenta EQ "")>
	<cfquery name="rsReporte" datasource="#Session.DSN#">
		Select a.CPNAPnum, a.CPNAPDlinea, a.CPPid,
			<cf_dbfunction name="to_char" args="a.CPCano" datasource="#session.dsn#"> #_Cat# '-' #_Cat#
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
			a.CPcuenta, o.Odescripcion,
			(case a.CPNAPDtipoMov
				when 'A'  	then 'Aprobación'
				when 'M'  	then 'Modificación'
				when 'ME'  	then 'Modificación<BR>Extraordinaria'
				when 'VC' 	then 'Variación<BR>Cambiaria'
				when 'T'  	then 'Traslado'
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
			a.CPNAPDdisponibleAntes + a.CPNAPDsigno * a.CPNAPDmonto as DisponibleGenerado,
			a.CPNAPDconExceso,
			cp.CPformato as CuentaPresupuesto,
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
			end as CalculoControl
		from CPNAPdetalle a
			inner join CPresupuesto cp
				on cp.CPcuenta = a.CPcuenta and cp.Ecodigo  = a.Ecodigo
			inner join Oficinas o
				on o.Ecodigo = a.Ecodigo and o.Ocodigo = a.Ocodigo
		where a.Ecodigo = #session.ecodigo# 
	  	  and a.CPNAPnum = #Arguments.CPNAPnum#
		<cfif Arguments.chkCeros>
		  and a.CPNAPDmonto <> 0
		</cfif>
		<cfif LvarOrderByLinea>
	    order by abs(a.CPNAPDlinea), a.CPNAPDsigno * a.CPNAPDmonto desc
		<cfelse>
	  	order by a.CPCano, a.CPCmes, cp.CPformato, o.Oficodigo, a.CPNAPDsigno * a.CPNAPDmonto desc
		</cfif>
	</cfquery>
</cffunction>