<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif isdefined("session.CPPid") and Len(Trim(session.CPPid))
  and isdefined("Form.CPcuenta") and Len(Trim(Form.CPcuenta))
  and isdefined("Form.CPCano") and Len(Trim(Form.CPCano))
  and isdefined("Form.CPCmes") and Len(Trim(Form.CPCmes))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfquery name="rsCuenta" datasource="#Session.DSN#">
	select CPformato as Cuenta, coalesce(CPdescripcionF, CPdescripcion) as Descripcion, 
			(select CPCPcalculoControl from CPCuentaPeriodo where Ecodigo=p.Ecodigo and CPPid=#session.CPPid# and CPcuenta=p.CPcuenta) 
				as CPCPcalculoControl,
			coalesce(case (select CPCPcalculoControl from CPCuentaPeriodo where Ecodigo=p.Ecodigo and CPPid=#session.CPPid# and CPcuenta=p.CPcuenta)
				when 1 then 'MENSUAL' 
				when 2 then 'ACUMULADO'
				else 'TOTAL'
			end, 'N/A')	as CalculoControl
	from CPresupuesto p
	where Ecodigo = #Session.Ecodigo#
	and CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
</cfquery>

<cfinclude template="ConsPresupuesto-rsOficinas.cfm">

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select CPPid, 
				'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as Pdescripcion,
		   CPPtipoPeriodo, 
		   CPPfechaDesde, 
		   CPPfechaHasta, 
		   CPPfechaUltmodif, 
		   Mnombre, 
		   CPPestado
	from CPresupuestoPeriodo p inner join Monedas m on p.Mcodigo=m.Mcodigo
	where p.Ecodigo = #Session.Ecodigo#
	  and p.CPPid = #session.CPPid#
	order by CPPfechaHasta desc, CPPfechaDesde desc
</cfquery>
<cfquery name="rsCuenta" datasource="#Session.DSN#">
	select CPformato as Cuenta, coalesce(CPdescripcionF, CPdescripcion) as Descripcion, 
			(select CPCPcalculoControl from CPCuentaPeriodo where Ecodigo=p.Ecodigo and CPPid=#session.CPPid# and CPcuenta=p.CPcuenta) 
				as CPCPcalculoControl,
			coalesce(case (select CPCPcalculoControl from CPCuentaPeriodo where Ecodigo=p.Ecodigo and CPPid=#session.CPPid# and CPcuenta=p.CPcuenta)
				when 1 then 'MENSUAL' 
				when 2 then 'ACUMULADO'
				else 'TOTAL'
			end, 'N/A')	as CalculoControl
	from CPresupuesto p
	where Ecodigo = #Session.Ecodigo#
	and CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
</cfquery>


<table width="100%"  border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td colspan="2">
		<form name="frmCta" method="post" action="ConsPresupuesto.cfm" style="margin:0;width=100%;">
		<br>
		<table id="tabCtas" width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
		  <tr> 
			<td class="fileLabel" nowrap width="1">
				Per&iacute;odo&nbsp;Presupuestario:
			</td>
			<td nowrap>
					<cfoutput>#rsPeriodos.Pdescripcion#</cfoutput>
			</td>
		  </tr>
		  <tr> 
			<td class="fileLabel" nowrap>
				Cuenta de Presupuesto:
			</td>
			<td nowrap>
					<cfoutput>
					<input type="hidden" name="CPcuenta" value="#Form.CPcuenta#">
					#rsCuenta.Cuenta# &nbsp;&nbsp;&nbsp;&nbsp;#rsCuenta.Descripcion#</cfoutput>
			</td>
		  </tr>
		  <tr> 
			<td class="fileLabel" nowrap>
				Oficina:
			</td>
			<td nowrap>
				<select name="Ocodigo" onChange="javascript: this.form.submit();">
					<cfoutput query="rsOficinas"> 
						<option value="#rsOficinas.Ocodigo#" <cfif isdefined("session.Ocodigo") AND session.Ocodigo NEQ "" AND rsOficinas.Ocodigo EQ session.Ocodigo>selected</cfif>>#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#</option>
					</cfoutput>
					<cfif rsOficinas.recordCount EQ 0>
						<option value="-1">(La cuenta no está formulada en ninguna oficina)</option>
					</cfif>
				</select>
			</td>
		  </tr>
		</table>
		</form>
	</td>
  </tr>
  <tr>
    <td width="50%" valign="top">
		&nbsp;&nbsp;Método de Cálculo de Control:&nbsp;&nbsp;&nbsp;<cfoutput>#rsCuenta.CalculoControl#</cfoutput>
		<cfset LvarSelect = 
			"a.CPCano, a.CPCmes, a.Ocodigo,
			 case a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
			 a.CPCpresupuestado as PresupuestoOriginal,
				a.CPCpresupuestado			+
				a.CPCmodificado 			+ 
				a.CPCmodificacion_Excesos +
				a.CPCvariacion				+
				a.CPCtrasladado 			+
				a.CPCtrasladadoE 			as AutorizadoMes, 
			(select sum(
							b.CPCpresupuestado			+
							b.CPCmodificado				+
							b.CPCmodificacion_Excesos +
							b.CPCvariacion				+
							b.CPCtrasladado 			+
							b.CPCtrasladadoE
						)
				  from CPresupuestoControl b
				 where b.CPPid    = a.CPPid
				   and b.CPcuenta = a.CPcuenta
				   and b.Ocodigo = #session.Ocodigo#">
		<cfif rsCuenta.CPCPcalculoControl NEQ 2>
			<cfset LvarSelect = LvarSelect & " " &
				   "and b.CPCano = a.CPCano
				    and b.CPCmes = a.CPCmes">
		<cfelseif rsCuenta.CPCPcalculoControl EQ 2>
			<cfset LvarSelect = LvarSelect & " " &
				   "and (   b.CPCano < a.CPCano OR
							b.CPCano = a.CPCano
						and b.CPCmes <= a.CPCmes
					   )">
		</cfif>
		<cfset LvarSelect = LvarSelect & " " &
			") as PresupuestoAutorizado, 
			 (select sum(
							b.CPCreservado_Anterior 	+
							b.CPCcomprometido_Anterior 	+
							b.CPCreservado_Presupuesto 	+
							b.CPCreservado		+ 
							b.CPCcomprometido	+ 
							b.CPCejecutado + b.CPCejecutadoNC
						)
				  from CPresupuestoControl b
				 where b.CPPid    = a.CPPid
				   and b.CPcuenta = a.CPcuenta
				   and b.Ocodigo = #session.Ocodigo#">
		<cfif rsCuenta.CPCPcalculoControl NEQ 2>
			<cfset LvarSelect = LvarSelect & " " &
				   "and b.CPCano = a.CPCano
				    and b.CPCmes = a.CPCmes">
		<cfelseif rsCuenta.CPCPcalculoControl EQ 2>
			<cfset LvarSelect = LvarSelect & " " &
				   "and (   b.CPCano < a.CPCano OR
							b.CPCano = a.CPCano
						and b.CPCmes <= a.CPCmes
					   )">
		</cfif>
		<cfset LvarSelect = LvarSelect & " " &
			") as PresupuestoConsumido,
			(select sum(
							b.CPCpresupuestado			+
							b.CPCmodificado 			+ 
							b.CPCmodificacion_Excesos +
							b.CPCvariacion				+
							b.CPCtrasladado				+
							b.CPCtrasladadoE			-
							b.CPCreservado_Anterior 	-
							b.CPCcomprometido_Anterior 	-
							b.CPCreservado_Presupuesto 	-
							b.CPCreservado		- 
							b.CPCcomprometido	- 
							b.CPCejecutado - b.CPCejecutadoNC
						)
				  from CPresupuestoControl b
				 where b.CPPid    = a.CPPid
				   and b.CPcuenta = a.CPcuenta
				   and b.Ocodigo = #session.Ocodigo#">
		<cfif rsCuenta.CPCPcalculoControl NEQ 2>
			<cfset LvarSelect = LvarSelect & " " &
				   "and b.CPCano = a.CPCano
				    and b.CPCmes = a.CPCmes">
		<cfelseif rsCuenta.CPCPcalculoControl EQ 2>
			<cfset LvarSelect = LvarSelect & " " &
				   "and (   b.CPCano < a.CPCano OR
							b.CPCano = a.CPCano
						and b.CPCmes <= a.CPCmes
					   )">
		</cfif>
		<cfset LvarSelect = LvarSelect & " " &
			") as PresupuestoDisponible,
			 '#session.CPPid#' as CPPid,
			 '#Form.CPcuenta#' as CPcuenta">
		<cfif rsCuenta.CPCPcalculoControl EQ 3>
			<cfquery name="rsPresupuestoControlTotal" datasource="#Session.DSN#">
				select coalesce(
					   sum(	a.CPCpresupuestado			+
							a.CPCmodificado				+
							a.CPCmodificacion_Excesos +
							a.CPCvariacion				+
							a.CPCtrasladado				+
							a.CPCtrasladadoE			-
							a.CPCreservado_Anterior 	-
							a.CPCcomprometido_Anterior 	-
							a.CPCreservado_Presupuesto 	-
							a.CPCreservado		- 
							a.CPCcomprometido	- 
							a.CPCejecutado - a.CPCejecutadoNC
						)
						,0) as PresupuestoDisponible
				  from CPresupuestoControl a
				 where a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CPPid#">
				   and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
				   and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ocodigo#">
			</cfquery>
			<cfset LvarSelect = LvarSelect & " " &
				", #rsPresupuestoControlTotal.PresupuestoDisponible# as DisponibleTotal">
		</cfif>

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pLista"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="CPresupuestoControl a"/>
			<cfinvokeargument name="columnas" value="#LvarSelect#"/>
			<cfif rsCuenta.CPCPcalculoControl EQ 1>
				<cfinvokeargument name="desplegar" value="CPCano, MesDescripcion, PresupuestoAutorizado, PresupuestoConsumido, PresupuestoDisponible"/>
				<cfinvokeargument name="formatos" value="V,V,M,M,M"/>
				<cfinvokeargument name="align" value="left, left, right, right, right"/>
				<cfinvokeargument name="etiquetas" value="A&ntilde;o, Mes, Autorizado, Consumido, Disponible"/>
			<cfelseif rsCuenta.CPCPcalculoControl EQ 2>
				<cfinvokeargument name="desplegar" value="CPCano, MesDescripcion, PresupuestoOriginal, AutorizadoMes, PresupuestoAutorizado, PresupuestoConsumido, PresupuestoDisponible"/>
				<cfinvokeargument name="formatos" value="V,V,M,M,M,M,M"/>
				<cfinvokeargument name="align" value="left, left, right, right, right, right, right"/>
				<cfinvokeargument name="etiquetas" value="A&ntilde;o, Mes, Presupuesto<BR>Original, Autorizado<BR>del Mes, Autorizado<BR>Acumulado, Consumido<BR>Acumulado, Disponible<BR>Acumulado"/>
			<cfelse>
				<cfinvokeargument name="desplegar" value="CPCano, MesDescripcion, PresupuestoAutorizado, PresupuestoConsumido, PresupuestoDisponible, DisponibleTotal"/>
				<cfinvokeargument name="formatos" value="V,V,M,M,M,M"/>
				<cfinvokeargument name="align" value="left, left, right, right, right, right"/>
				<cfinvokeargument name="etiquetas" value="A&ntilde;o, Mes, Autorizado<BR>del Mes, Consumido<BR>del Mes, Disponible<BR>del Mes, Disponible<BR>Total"/>
			</cfif>
			<cfif rsCuenta.CPCPcalculoControl EQ 3>
				<cfinvokeargument name="totales" value="PresupuestoAutorizado,PresupuestoConsumido,PresupuestoDisponible"/>
			</cfif>
			<cfinvokeargument name="filtro" value=" a.Ecodigo = #Session.Ecodigo# 
													and a.CPPid = #session.CPPid#
													and a.CPcuenta = #Form.CPcuenta#
													and a.Ocodigo = #session.Ocodigo#
													order by a.CPCano, a.CPCmes
												"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
			<cfinvokeargument name="keys" value="CPPid, CPcuenta, CPCano, CPCmes"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="formName" value="listaPresupuestoControl"/>
			<cfinvokeargument name="PageIndex" value="2"/>
			<cfinvokeargument name="debug" value="N"/>
		</cfinvoke>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<cfoutput>
		<input type="button" value="Regresar" onclick="location.href='#GetFileFromPath(GetTemplatePath())#?1&_';" />
		</cfoutput>
	</td>
    <td valign="top" align="center">
		<cfif modo EQ "CAMBIO">
			<cfinclude template="ConsPresupuestoControl.cfm">
		<cfelseif pListaRet GT 0>
			<br>
		  	<strong>Seleccione uno de los presupuestos de la lista</strong>
		<cfelse>
			<br>
			<font color="##FF0000">
			<strong>No hay ningún presupuesto programado para este periodo, cuenta y oficina</strong>
			</font>
		</cfif>
	</td>
  </tr>
</table>
