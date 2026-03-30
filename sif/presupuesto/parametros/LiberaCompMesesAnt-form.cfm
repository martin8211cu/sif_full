<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DeseaReversarComp" default ="Desea Liberar los Compromisos" returnvariable="MSG_DeseaReversarComp" xmlfile = "ReversarComp.xml">

<cfinclude template="../../Utiles/sifConcat.cfm">

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>
<cfset LB_PeriododelPres = t.Translate('LB_PeriododelPres','Período del Presupuesto')>
<cfset LB_CuentadePres = t.Translate('LB_CuentadePres','Cuenta de Presupuesto')>
<cfset LB_EliminarCta = t.Translate('LB_EliminarCta','¿Desea Eliminar la Cuenta?')>
<cfset LB_Periodo = t.Translate('LB_Periodo','Periodo')>
<cfset LB_Mes = t.Translate('LB_Mes','Mes')>
<cfset LB_Compromiso = t.Translate('LB_Compromiso','Compromiso')>
<cfset LB_Ampliaciones = t.Translate('LB_ Ampliaciones','Ampliaciones')>
<cfset LB_NuevoMontoa = t.Translate('LB_NuevoMontoa','Nuevo Monto a')>
<cfset LB_Original = t.Translate('LB_Original','Original')>
<cfset LB_Reducciones = t.Translate('LB_Reducciones','Reducciones')>
<cfset LB_Modificado = t.Translate('LB_Modificado','Modificado')>
<cfset LB_Comprometer = t.Translate('LB_Comprometer','Comprometer')>
<cfset BTN_Eliminar = t.Translate('BTN_Eliminar','Eliminar','/sif/generales.xml')>
<cfset BTN_Regresar = t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_btnGuardar = t.Translate('LB_btnGuardar','Guardar','/sif/generales.xml')>
<!---<cfset LB_btnReset = t.Translate('LB_btnReset','Reset')>--->
<cfset LB_MesCerrado = t.Translate('LB_MesCerrado','Mes Cerrado')>

<cfif isdefined("url.NAP") and Len(Trim(url.NAP))>
	<cfset form.CPNAPnum = url.NAP>
<cfelseif isdefined("url.CPNAPnum") and Len(Trim(url.CPNAPnum))>
	<cfset form.CPNAPnum = url.CPNAPnum>
</cfif>

<!--- <cf_dump var="#form#"> --->

<form method="post" name="frmCPPid" action="LiberaCompMesesAnt-SQL.cfm">
	<table border="0" width="100%">
            <tr>
                <td colspan="2">&nbsp;</td>
                <td colspan="2">
                    <strong>Período del Presupuesto</strong>:&nbsp;
                </td>
				<td>&nbsp;</td>
				<td>
					<strong>Mes</strong>:&nbsp;
				</td>
				<td>&nbsp;</td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
                <td colspan="2">
                    <cfquery name="rsCPPeriodos" datasource="#Session.DSN#">
						select 	CPPid,
								CPPtipoPeriodo,
								CPPfechaDesde,
								CPPfechaHasta,
								CPPanoMesDesde,
								CPPanoMesHasta,
								CPPestado,
								'Presupuesto ' #_Cat#
									case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
									#_Cat# ' de ' #_Cat#
									case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
									#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
									#_Cat# ' a ' #_Cat#
									case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
									#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
								as Descripcion
						 from CPresupuestoPeriodo p
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and CPPestado in (1)
						order by CPPfechaDesde desc
					</cfquery>

						<select name="CPPid"
							id="CPPid"
							onChange="javascript:document.frmCPPid.submit();"
						>
							<cfoutput query="rsCPPeriodos">
							<option value="#rsCPPeriodos.CPPid#" <cfif isdefined("form.CPPid") and form.CPPid EQ #CPPid# > selected </cfif> >
								#rsCPPeriodos.Descripcion#
						   	</option>
						   	</cfoutput>
						</select>
                </td>
				<td>&nbsp;</td>
				<td>
					<cfquery name = "rsCPPidAct" datasource="#Session.DSN#">
						select max(CPPid) CPPid from CPresupuestoPeriodo where CPPestado = 1
					</cfquery>

					<cfquery name = "rsMesesComp" datasource="#Session.DSN#">
							   SELECT distinct nd.CPCmes,
								 	case nd.CPCmes
								     when 1 then '#CMB_Enero#'
								     when 2 then '#CMB_Febrero#'
								     when 3 then '#CMB_Marzo#'
								     when 4 then '#CMB_Abril#'
								     when 5 then '#CMB_Mayo#'
								     when 6 then '#CMB_Junio#'
								     when 7 then '#CMB_Julio#'
								     when 8 then '#CMB_Agosto#'
								     when 9 then '#CMB_Septiembre#'
								     when 10 then '#CMB_Octubre#'
								     when 11 then '#CMB_Noviembre#'
								     when 12 then '#CMB_Diciembre#'
								     else ''
								    end as Mes
								from  CPresupuestoComprometidasNAPs cpn
								inner join CPNAPdetalle nd
									on cpn.CPNAPnum = nd.CPNAPnum
									and cpn.CPNAPDlinea = nd.CPNAPDlinea
									and cpn.CPCano = nd.CPCano
									and cpn.CPCmes = nd.CPCmes
									and cpn.CPcuenta = nd.CPcuenta
								where nd.CPNAPDmonto - nd.CPNAPDutilizado <> 0
									<!----and nd.CPNAPDutilizado >= 0---->
									<cfif isdefined("form.CPPid") and form.CPPid eq rsCPPidAct.CPPid>
										and cpn.CPCmes < (select Pvalor from Parametros where Pcodigo = 60)
										and cpn.CPPid = #rsCPPidAct.CPPid#
									<cfelseif isdefined("form.CPPid")>
										and cpn.CPPid = #form.CPPid#
									<cfelse>
										and cpn.CPPid = #rsCPPidAct.CPPid#
										and cpn.CPCmes < (select Pvalor from Parametros where Pcodigo = 60)
									</cfif>
								order by nd.CPCmes
					</cfquery>
					<!--- <cf_dump var="#form#"> --->
					<SELECT NAME="cmbMeses">
						<CFOUTPUT QUERY="rsMesesComp">
							<OPTION VALUE="#CPCmes#" <cfif isdefined("form.cmbMeses") and form.cmbMeses EQ #CPCmes# > selected </cfif> >
								#Mes#
							</OPTION>
						</CFOUTPUT>
					</SELECT>

				</td>
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="btnConsultar" value="Consultar"/>
					<input type="submit" name="btnLiberar" value="Liberar" onclick="return confirm('Desea Reversar los Compromisos?')"/>
				</td>
            </tr>
        </table>
		<table border="0" width="100%">
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
									a.CPNAPDmonto as Monto, a.CPNAPDutilizado Utilizado,
									a.CPNAPDmonto - a.CPNAPDutilizado Saldo,
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
									end as CalculoControl
							from CPNAPdetalle a
							inner join CPresupuesto b
								on b.CPcuenta = a.CPcuenta
								and b.Ecodigo  = a.Ecodigo
							inner join CPresupuestoComprometidasNAPs cpn
								on cpn.CPNAPnum = a.CPNAPnum
								and cpn.CPNAPDlinea = a.CPNAPDlinea
								and cpn.CPCano = a.CPCano
								and cpn.CPCmes = a.CPCmes
								and cpn.CPcuenta = a.CPcuenta
							where a.Ecodigo = #session.ecodigo#
								<cfif isdefined("form.CPPid")>
									and cpn.CPPid = #form.CPPid#
								<cfelse>
									and cpn.CPPid = #rsCPPidAct.CPPid#
								</cfif>
								<cfif isdefined("Form.cmbMeses")>
									and cpn.CPCmes = #Form.cmbMeses#
								<cfelse>
									<cfquery name="rsFirstMes" dbtype="query">
										select CPCmes from rsMesesComp
									</cfquery>
									<cfif rsFirstMes.recordCount GT 0>
										and cpn.CPCmes = #rsFirstMes.CPCmes#
									<cfelse>
										and cpn.CPCmes = 0
									</cfif>
								</cfif>
								and a.CPNAPDmonto - a.CPNAPDutilizado <> 0
								<!---and a.CPNAPDutilizado >= 0 ---->
							order by a.CPNAPDlinea
						</cfquery>

						<cfinvoke
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsListaNAP_ME#"/>
							<cfinvokeargument name="desplegar" value="CPNAPnum,CPNAPDlinea, CuentaPresupuesto, TipoControl, CalculoControl, TipoMovimiento, Monto, Utilizado, Saldo"/>
							<cfinvokeargument name="etiquetas" value="NAP,Linea, Cuenta<BR>Presupuesto, Tipo<BR>Control, Cálculo<BR>Control, Tipo<BR>Movimiento,Monto<BR>Autorizado,Monto<BR>Utilizado, Saldo"/>
							<cfinvokeargument name="formatos" value="V,V,V,V,V,V,V,V,M,M,M"/>
							<cfinvokeargument name="align" value="left,left,left, center, center, center, right, right, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value=""/>
							<cfinvokeargument name="MaxRows" value="20"/>
							<cfinvokeargument name="formName" value="listaNAPSME"/>
							<cfinvokeargument name="PageIndex" value="11"/>
							<cfinvokeargument name="showLink" value="false"/>
							<cfinvokeargument name="debug" value="N"/>
						</cfinvoke>
					<cf_web_portlet_end>
					<BR>
				</td>
		</tr>
	</table>
</form>

<cfif not isdefined("Form.CPNAPnum") OR Form.CPNAPnum EQ "" OR isdefined("LvarNAP")>
	<script language="javascript" src="../../js/utilesMonto.js"></script>
	<br><br><br>


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


