<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif isdefined("url.CPcuenta")>	<cfset form.CPcuenta=url.CPcuenta></cfif>
<cfif isdefined("url.CPPid")>		<cfset form.CPPid=url.CPPid></cfif>
<cfif isdefined("url.Ocodigo")>		<cfset form.Ocodigo=url.Ocodigo></cfif>
<cfif isdefined("url.CPCano")>		<cfset form.CPCano=url.CPCano></cfif>
<cfif isdefined("url.CPCmes")>		<cfset form.CPCmes=url.CPCmes></cfif>

<cfset LvarLiquidacion = not isdefined("form.CPCmes")>

<cfparam name="form.CPPid" default="#session.CPPid#">

<cfquery name="rsCuenta" datasource="#Session.DSN#">
	select  a.CPformato as Cuenta,
			coalesce(a.CPdescripcionF,a.CPdescripcion) as Descripcion
	from CPresupuesto a
	where a.Ecodigo = #Session.Ecodigo#
	and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
</cfquery>

<cfinclude template="ConsPresupuesto-rsOficinas.cfm">

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select CPPid,
		   CPPtipoPeriodo,
		   CPPfechaDesde,
		   CPPfechaHasta,
		   CPPfechaUltmodif,
		   Mnombre,
		   CPPestado,
		   'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat#
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat#
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as CPPdescripcion
	from CPresupuestoPeriodo p inner join Monedas m on p.Mcodigo=m.Mcodigo
	where p.Ecodigo = #Session.Ecodigo#
  	  and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
	order by CPPfechaHasta desc, CPPfechaDesde desc
</cfquery>

<cfif not LvarLiquidacion>
	<cfset LvarMes = listToArray("Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre")>
	<cfset LvarMes = LvarMes[form.CPCmes]>
</cfif>
<style type="text/css">
<!--
.pStyle_Monto {font-weight:bold}
-->
</style>
<cf_sifHtml2Word>
	<form method="post" action="ConsPresupuesto-detallesNAP.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
		  <tr>
			<td></td>
			<td class="fileLabel" nowrap width="1" colspan="1" >
				Per&iacute;odo&nbsp;Presupuestario:
			</td>
			<td nowrap colspan="12">
					<cfoutput>#rsPeriodos.CPPdescripcion#</cfoutput>
			</td>
		  </tr>
		  <tr>
		  <td></td>
			<td class="fileLabel" nowrap colspan="1">
				Cuenta de Presupuesto:
			</td>
			<td nowrap colspan="12">
					<cfoutput>
					<input type="hidden" name="CPcuenta" value="#Form.CPcuenta#">
					#rsCuenta.Cuenta# &nbsp;&nbsp;&nbsp;&nbsp;#rsCuenta.Descripcion#</cfoutput>
			</td>
		  </tr>
		  <tr>
		  <td></td>
			<td class="fileLabel" nowrap colspan="1">
				Oficina:
			</td>
			<td nowrap colspan="12">
				<select name="Ocodigo" onChange="javascript: this.form.submit();">
					<cfoutput query="rsOficinas">
						<option value="#rsOficinas.Ocodigo#" <cfif isdefined("session.Ocodigo") AND session.Ocodigo NEQ "" AND rsOficinas.Ocodigo EQ session.Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
					</cfoutput>
				</select>
			</td>
		  </tr>
<cfif not LvarLiquidacion>
		  <tr>
		  <td></td>
			<td class="fileLabel" nowrap colspan="1">
				Mes de Presupuesto:
			</td>
			<td nowrap colspan="12">
				<cfoutput>
				<input type="hidden" name="CPCano" value="#form.CPCano#">
				<input type="hidden" name="CPCmes" value="#form.CPCmes#">
				#form.CPCano# - #LvarMes#
				</cfoutput>
			</td>
		  </tr>
</cfif>
		</table>
	</form>

	<cfquery name="rsListaNAPS" datasource="#Session.DSN#">
		Select
			a.CPNAPnumRef,
			(case when rtrim(a.CPNAPDtipoMov) in ('A', 'M', 'ME','VC', 'T', 'TE')
				  then 'Movimientos de Autorizacion'
				  else 'Movimientos de Consumo' end)
				  as CorteTipo,
			a.CPNAPnum,
			a.CPNAPDlinea,
			a.CPPid,
			a.CPCano,
			a.CPCmes,
			case a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
			a.CPcuenta,
			b.CPNAPmoduloOri as Modulo,
			b.CPNAPdocumentoOri as Documento,
            <cf_dbfunction name='sPart' args='b.CPNAPreferenciaOri,1,10'> as DocReferencia,
			b.CPNAPfechaOri as FechaDoc,
			b.CPNAPfecha as FechaAutorizacion,
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
			a.CPNAPDmonto-a.CPNAPDutilizado as Saldo,
			a.CPNAPDdisponibleAntes as DisponibleAnterior,
			a.CPNAPDdisponibleAntes + a.CPNAPDsigno*a.CPNAPDmonto as DisponibleGenerado,
			c.CPformato as CuentaPresupuesto,
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
 			case
				when a.CPNAPnumRef is not null then
		'<img alt=''Consulta la utilizacion de la Línea de NAP que referencia'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNAPDreferenciado(' #_Cat#
			<cf_dbfunction name="to_char" args="a.CPNAPnumRef" datasource="#session.dsn#">
			 #_Cat# ',' #_Cat#
			<cf_dbfunction name="to_char" args="a.CPNAPDlineaRef" datasource="#session.dsn#">
			 #_Cat# ');''>'
			end as Referencia,
 			case
				when a.CPNAPDreferenciado=1 then
		'<img alt=''Consulta la utilizacion de esta Línea de NAP'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNAPDreferenciado(' #_Cat#
			<cf_dbfunction name="to_char" args="a.CPNAPnum" datasource="#session.dsn#">
			#_Cat# ',' #_Cat#
			<cf_dbfunction name="to_char" args="a.CPNAPDlinea" datasource="#session.dsn#">
			#_Cat# ');''>'
			end as Utilizado
	from CPNAPdetalle a, CPNAP b, CPresupuesto c, CtasMayor m
		where a.Ecodigo = #Session.Ecodigo#
			and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
<cfif not LvarLiquidacion>
  			and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
			and a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
			and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
			and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
<cfelse>
			and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
			and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
			and a.CPNAPDtipoMov in
				(
					select CPNAPDtipoMov
					  from CPLiquidacionParametros
					 where Ecodigo = #Session.Ecodigo#
					   and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
					   and CPLtipoLiquidacion not in ('N','-')
					   and 	case
								when Ctipo = 'A' AND b.CPNAPmoduloOri in ('CMSC','CMOC') AND m.Ctipo = 'A'	 			then 1
								when Ctipo = 'G' AND b.CPNAPmoduloOri in ('CMSC','CMOC') AND m.Ctipo = 'G'	 			then 1
								when Ctipo = 'O' AND b.CPNAPmoduloOri in ('CMSC','CMOC') AND m.Ctipo not in ('A','G') 	then 1
								when Ctipo = 'P' AND b.CPNAPmoduloOri in ('TESP','TEOP') 									then 1
								when Ctipo = 'E' AND b.CPNAPmoduloOri in ('TEAE','TEGE','TECH') 							then 1
								when Ctipo = 'I' AND (select Otipo from Origenes where Oorigen=b.CPNAPmoduloOri) = 'E' 	then 1
								else -1
							end = 1

				)
			and a.CPNAPDmonto - a.CPNAPDutilizado > 0
		    and a.CPPidLiquidacion 	is null				<!--- Unicamente NAPs del período que no hayan sido liquidados --->
		    and a.CPNAPnumRef 		is null				<!--- Unicamente NAPs origenes del movimiento --->
			and b.CPNAPcongelado = 0
</cfif>
			and b.Ecodigo = a.Ecodigo
			and b.CPNAPnum = a.CPNAPnum

			and c.Ecodigo = a.Ecodigo
			and c.CPcuenta = a.CPcuenta

			and m.Ecodigo = c.Ecodigo
			and m.Cmayor = c.Cmayor
		order by CorteTipo, a.CPNAPnum, a.CPNAPnumRef desc, a.CPNAPDsigno*a.CPNAPDmonto desc

	</cfquery>

 <cfinvoke
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsListaNAPS#"/>
	<cfinvokeargument name="cortes" value="CorteTipo">
<cfif not LvarLiquidacion>
	<cfinvokeargument name="desplegar" value="CPNAPnum, Modulo, Documento, DocReferencia, FechaDoc, FechaAutorizacion, TipoControl, CalculoControl, TipoMovimiento, DisponibleAnterior, Signo, Monto, DisponibleGenerado, Referencia, Utilizado"/>
	<cfinvokeargument name="etiquetas" value="NAP, M&oacute;dulo, Documento, Referencia, Fecha Documento, Fecha Autorizaci&oacute;n, Tipo Control, Cálculo Control, Tipo Movimiento, Disponible Anterior, Signo Monto, Monto Autorizado, Disponible Generado, NAP Ref., Utilizado<br>por"/>
	<cfinvokeargument name="formatos" value="V,V,V,V,D,D,V,V,V,M,V,M,M,V,V"/>
	<cfinvokeargument name="align" value="left, left, left, left, center, center, center, center, center, right, center, right, right, center, center"/>
<cfelse>
	<cfinvokeargument name="desplegar" value="CPNAPnum, Modulo, Documento, DocReferencia, FechaDoc, FechaAutorizacion, TipoControl, CalculoControl, TipoMovimiento, Monto, Saldo, Referencia, Utilizado"/>
	<cfinvokeargument name="etiquetas" value="NAP, M&oacute;dulo, Documento, Referencia, Fecha Documento, Fecha Autorizaci&oacute;n, Tipo Control, Cálculo Control, Tipo Movimiento, Monto<BR>Autorizado, Saldo a<BR>Liquidar, NAP Ref., Utilizado<br>por"/>
	<cfinvokeargument name="formatos" value="V,V,V,V,D,D,V,V,V,M,M,V,V"/>
	<cfinvokeargument name="align" value="left, left, left, left, center, center, center, center, center, right, right, center, center"/>
</cfif>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="keys" value="CPNAPnum, CPNAPDlinea, CPPid, CPCano, CPCmes, CPcuenta"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value="listaNAPS"/>
	<cfinvokeargument name="PageIndex" value="3"/>
<cfif LvarLiquidacion>
	<cfinvokeargument name="navegacion" value="&CPcuenta=#form.CPcuenta#&CPPid=#form.CPPid#&Ocodigo=#form.Ocodigo#"/>
<cfelse>
	<cfinvokeargument name="navegacion" value="&CPcuenta=#form.CPcuenta#&CPPid=#form.CPPid#&Ocodigo=#form.Ocodigo#&CPCano=#form.CPCano#&CPCmes=#form.CPCmes#"/>
</cfif>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>

</cf_sifHtml2Word>
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
<table width="100%">
  <tr>
    <td align="center">
		<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: history.back();">&nbsp;&nbsp;
		<!--<input type="button" name="btnimprimir" class="btnimprimir" value="Imprimir" onclick="popup();">-->
	</td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
</table>