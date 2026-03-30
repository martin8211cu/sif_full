<cfinclude template="../../Utiles/sifConcat.cfm">

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

<cfset LvarMes = listToArray("Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre")>
<cfset LvarMes = LvarMes[form.CPCmes]>

	<form method="post" action="ConsPresupuesto-detallesNRP.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
		  <tr> 
			<td class="fileLabel" nowrap width="1">
				Per&iacute;odo&nbsp;Presupuestario:
			</td>
			<td nowrap>
					<cfoutput>#rsPeriodos.CPPdescripcion#</cfoutput>
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
						<option value="#rsOficinas.Ocodigo#" <cfif isdefined("session.Ocodigo") AND session.Ocodigo NEQ "" AND rsOficinas.Ocodigo EQ session.Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
					</cfoutput>
				</select>
			</td>
		  </tr>
		  <tr> 
			<td class="fileLabel" nowrap>
				Mes de Presupuesto:
			</td>
			<td nowrap>
				<cfoutput>
				<input type="hidden" name="CPCano" value="#form.CPCano#">
				<input type="hidden" name="CPCmes" value="#form.CPCmes#">
				#form.CPCano# - #LvarMes#
				</cfoutput>
			</td>
		  </tr>
		</table>
	</form>
	
<cfquery name="rslistaNAPS" datasource="#session.DSN#">
	select	(case when rtrim(a.CPNRPDtipoMov) in ('A', 'M', 'ME','VC', 'T', 'TE') 
			  then 'Movimientos de Autorizacion'
			  else 'Movimientos de Compromiso' end) 
			  as CorteTipo,
		a.CPNRPnum,
		a.CPNRPDlinea, 
		a.CPPid,
		a.CPCano,
		a.CPCmes,
		case a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
		a.CPcuenta,
		b.CPNRPmoduloOri as Modulo,
		b.CPNRPdocumentoOri as Documento,
		<cf_dbfunction name='sPart' args='b.CPNRPreferenciaOri,1,10'> as DocReferencia,
		b.CPNRPfechaOri as FechaDoc,
		b.CPNRPfecha as FechaRechazo,
		b.CPNRPtipoCancela,
		b.CPNAPnum, b.UsucodigoAutoriza,
					(case a.CPNRPDtipoMov
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
							else a.CPNRPDtipoMov
					end) as TipoMovimiento,
		case when a.CPNRPDsigno < 0 then '(-)' when a.CPNRPDsigno > 0 then '(+)' else '(n/a)' end as Signo,
		a.CPNRPDmonto as Monto,
		case when b.UsucodigoAutoriza is null
				then a.CPNRPDdisponibleAntes 
				else a.CPNRPDdisponibleAntesAprobar
		end as DisponibleAnterior,
		case when b.UsucodigoAutoriza is null
				then a.CPNRPDpendientesAntes
				else a.CPNRPDpendientesAntesAprobar
		end as Pendientes,
		case when b.UsucodigoAutoriza is null
				then a.CPNRPDdisponibleAntes + a.CPNRPDsigno*a.CPNRPDmonto + a.CPNRPDpendientesAntes
				else a.CPNRPDdisponibleAntesAprobar + a.CPNRPDsigno*a.CPNRPDmonto + a.CPNRPDpendientesAntesAprobar 
		end as DisponibleNeto,
		c.CPformato as CuentaPresupuesto,
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
			'<img alt=''Consulta la utilizacion de la Línea de NAP que referencia'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:fnConsultaNAPDreferenciado(' #_Cat#
				<cf_dbfunction name="to_char" args="a.CPNAPnumRef" datasource="#session.dsn#">
				#_Cat# ',' #_Cat#
				<cf_dbfunction name="to_char" args="a.CPNAPDlineaRef" datasource="#session.dsn#">
				#_Cat#');''>'
		end as Referencia
	from CPNRPdetalle a, CPNRP b, CPresupuesto c
	where a.Ecodigo = #session.ecodigo# 
		and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
 		and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCmes#">
		and a.CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCano#">
		and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
		and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ocodigo#"> 
		and a.Ecodigo = b.Ecodigo
		and a.CPNRPnum = b.CPNRPnum
		and a.CPcuenta = c.CPcuenta
		and a.Ecodigo = c.Ecodigo
		order by CorteTipo, a.CPNRPnum, a.CPNRPDsigno*a.CPNRPDmonto desc
</cfquery>	
 
	
<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rslistaNAPS#"/>
	<cfinvokeargument name="cortes" value="CorteTipo">
	<cfinvokeargument name="desplegar" value="CPNRPnum, Modulo, Documento, DocReferencia, FechaDoc, FechaRechazo, TipoPresupuesto, MetodoControl, TipoMovimiento, DisponibleAnterior, Signo, Monto, Pendientes, DisponibleNeto, Referencia"/>
	<cfinvokeargument name="etiquetas" value="NRP, M&oacute;dulo, Documento, Referencia, Fecha Documento, Fecha Rechazo, Tipo<BR>Control, Cálculo<BR>Control, Tipo Movimiento, Disponible Anterior, Signo Monto, Monto, Disminuciones Pendientes, Disponible Neto, NAP Ref."/>
	<cfinvokeargument name="formatos" value="V,V,V,V,D,D,V,V,V,M,V,M,M,M,V"/>
	<cfinvokeargument name="lineaRoja" value="CPNRPtipoCancela NEQ 0"/>
	<cfinvokeargument name="lineaVerde" value="UsucodigoAutoriza NEQ '' AND CPNAPnum EQ ''"/>
	<cfinvokeargument name="lineaAzul" value="CPNAPnum NEQ ''"/>
	<cfinvokeargument name="align" value="left, left, left, left, center, center, center, center, center, right, center, right, right, right, center"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="keys" value="CPNRPnum, CPNRPDlinea, CPPid, CPCano, CPCmes, CPcuenta"/>
	<cfinvokeargument name="MaxRows" value="0"/>
	<cfinvokeargument name="formName" value="listaNAPS"/>
	<cfinvokeargument name="PageIndex" value="3"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>
		<font color="#000000">&nbsp;&nbsp;(*) NRPs rechazos presupuestarios</font><br>
		<font color="#FF0000">&nbsp;&nbsp;(*) NRPs cancelados</font><br>
		<font color="#00CC00">&nbsp;&nbsp;(*) NRPs aprobados pendientes de aplicar</font><br>
		<font color="#0000FF">&nbsp;&nbsp;(*) NRPs aplicados</font><br>

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
		<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: history.back();">
	</td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
</table>