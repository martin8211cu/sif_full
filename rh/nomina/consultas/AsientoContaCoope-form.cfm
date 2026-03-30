<cf_templatecss>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Asiento_de_Contabilidad" Default="Asiento de Contabilidad" returnvariable="LB_Titulo"/>
<cf_dbtemp name="Rcuentas" returnvariable="Rcuentas" datasource="#session.DSN#">
	<cf_dbtempcol name="RCNid" type="numeric" mandatory="no">
	<cf_dbtempcol name="Ecodigo" type="int" mandatory="no">
	<cf_dbtempcol name="tiporeg" type="int" mandatory="no">
	<cf_dbtempcol name="DEid" type="numeric" mandatory="no">
	<cf_dbtempcol name="referencia" type="numeric" mandatory="no">
	<cf_dbtempcol name="Cformato" type="char(100)" mandatory="no">
	<cf_dbtempcol name="Ccuenta" type="numeric" mandatory="no">
	<cf_dbtempcol name="CFcuenta" type="numeric" mandatory="no">
	<cf_dbtempcol name="tipo" type="char(1)" mandatory="no">
	<cf_dbtempcol name="montores" type="money" mandatory="no">
	<cf_dbtempcol name="CFid" type="numeric" mandatory="no">
	<cf_dbtempcol name="CFcodigo" type="char(10)" mandatory="no">
</cf_dbtemp>



<cfquery name="RC" datasource="#session.DSN#">
	insert into #Rcuentas# (RCNid, Ecodigo,tiporeg, DEid,referencia,Cformato, Ccuenta,  CFcuenta, tipo, montores,CFid,CFcodigo)
		select a.RCNid, a.Ecodigo,a.tiporeg, a.DEid,a.referencia,a.Cformato, a.Ccuenta, a.CFcuenta, a.tipo, a.montores, a.CFid, c.CFcodigo
			from RCuentasTipo a, HRCalculoNomina b, CFuncional c
				where a.RCNid = b.RCNid 
					and a.CFid = c.CFid
					and b.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
					and b.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
<!---					and DEid in (360,526)--->
</cfquery>

<!---<cfquery name="RC" datasource="#session.DSN#">
	update #Rcuentas# set tipo = 'D' 
		where montores > 0 and tipo = 'C'
</cfquery>--->

<cfquery name="RC" datasource="#session.DSN#">
	update #Rcuentas# set tipo = 'C', montores  = montores * -1
		where montores < 0 and tipo = 'D'
</cfquery>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select  Cformato,'01' as CodEmpresa, 
			'01' as CodMoneda, 
			''  as NumAsiento, 
			'0' TipoDoc, 
			sum(montores) as Monto, 
			tipo as TipoMov, 
			RCDescripcion as Descripcion,
			min(a.RCNid) as RCNid,
			<cfqueryparam cfsqltype="cf_sql_date" value="#url.desde#"> as fecha,
			<cf_dbfunction name="string_part" args="Cformato,2,3"> as CtaMayor,
			<cf_dbfunction name="string_part" args="Cformato,6,2"> as CtaNivel2,
			<cf_dbfunction name="string_part" args="Cformato,9,3"> as CtaNivel3,
			<cf_dbfunction name="string_part" args="Cformato,13,2"> as CtaNivel4,
			<cf_dbfunction name="string_part" args="Cformato,16,4"> as CtaNivel5,
			a.CFcodigo as CentroCosto,
			rtrim(substring(Cformato,16,4)) as Sucursal
			
	from #Rcuentas# a, HRCalculoNomina b  		
	where a.RCNid = b.RCNid 
		and b.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
		and b.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	group by a.Cformato, tipo, RCDescripcion, a.CFcodigo
</cfquery>


<!---<cf_dump var="#rsDatos#">--->

<style>
	.encabezado{
	vertical-align:bottom; 
	border-right:1px solid black;
	border-bottom:1px solid black;
	border-top:1px solid black;
	background-color:F1F1F1;
	}
</style>
<cfset parametros= '?desde=#url.desde#&hasta=#url.hasta#'>

<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
		<td>
			<cfinvoke key="LB_AsientoDeContabilidad" default="Asiento de Contabilidad" returnvariable="LB_AsientoDeContabilidad" component="sif.Componentes.Translate"  method="Translate"/>
			<cf_EncReporte
				Titulo="#LB_AsientoDeContabilidad#"
				Color="##E3EDEF"
			>
		</td>
	</tr>
	<!----==================== ENCABEZADO ANTERIOR ====================
	<tr>
		<td align="center"><strong><cf_translate key="LB_AsientoDeContabilidad">Asiento de Contabilidad</cf_translate></strong></td>
	</tr>
	---->
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="100%">			
			<cf_htmlReportsHeaders 
				irA="AsientoContaCoope-filtro.cfm"
				FileName="asientocconta#LSDateFormat(now(),'yyyymmdd')#_#LSDateFormat(now(),'hhmm')#_#session.Usucodigo#.xls"					
				title="#LB_Titulo#"
				param="#parametros#"
				method="get">
			<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
				<tr>
       				<td class="encabezado"><cf_translate key="LB_Num_mov">NUMERO_MOVIMIENTO</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Usu">USUARIO</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Secuencia">SECUENCIA_REGLON</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_FechaMov">FECHA_MOVIMIENTO</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Deb-Cred">DEBITO_CREDITO</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Monto">MONTO_MOVIMIENTO</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_MontoLocal">MONTO_MOVIMIENTO_LOCAL</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_MovAjuste">MOVIMIENTO_AJUSTE</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_CodEmpresa">CODIGO_EMPESA</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Cta_Mayor">NIVEL_1</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Cta_Nivel2">NIVEL_2</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Cta_Nivel3">NIVEL_3</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Cta_Nivel4">NIVEL_4</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Cta_Nivel5">NIVEL_5</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Cta_Nivel6">NIVEL_6</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Cta_Nivel7">NIVEL_7</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Cta_Nivel8">NIVEL_8</cf_translate></td>
					<td class="encabezado"><cf_translate key="LB_Cod_Moneda">COD_MONEDA</cf_translate></td>
					<td class="encabezado">CODIGO_AUXILIAR</td>
					<td class="encabezado">DESCRIPCION</td>
					<td class="encabezado">REFERENCIA</td>
					<td class="encabezado">NUMERO_AUTORIZACION</td>
					<td class="encabezado">USUARIO_AUTORIZADOR</td>
					<td class="encabezado">TASA_CAMBIO</td>
					<td class="encabezado">FECHA_TIPO_CAMBIO</td>
					<td class="encabezado">CODIGO_COMPANIA</td>
					<td class="encabezado">NUMERO_REFERENCIA</td>
					<td class="encabezado">CENTRO_DE_COSTO</td>
					<td class="encabezado">CODIGO_PRESUPUESTO</td>
					<td class="encabezado">CLASE_PRESUPUESTO</td>
					<td class="encabezado">NUMERO_ORDEN</td>
					<td class="encabezado">NUMERO_ITEM_ORDEN</td>
					<td class="encabezado">CODIGO_AUXILIAR_REF</td>
					<td class="encabezado">REFERENCIA_ORIGEN</td>
					<cfset count=1>
				<cfoutput query="rsDatos">
					<cfquery name="datosN" datasource="#session.DSN#">
						select CPcodigo,CPmes, CPperiodo
						from CalendarioPagos
						where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#">
					</cfquery>
					<tr>
						<td valign="top">&nbsp;01#datosN.CPmes##datosN.CPperiodo#</td>
						<td valign="top">CSNOMINA</td>
						<td valign="top">#count#</td>
						<td valign="top">#LSDateFormat(fecha,'dd/mm/yyyy')#</td>
						<td valign="top">#TipoMov#</td>
						<td valign="top"><cfif TipoMov EQ 'C' >-</cfif>#LSNumberFormat(Monto, ',9.00')#</td>
						<td valign="top"><cfif TipoMov EQ 'C' >-</cfif>#LSNumberFormat(Monto, ',9.00')#</td>
						<td valign="top">N</td>
						<td valign="top">1</td>
						<td valign="top">&nbsp;#CtaMayor#</td>
						<td valign="top">&nbsp;#CtaNivel2#</td>
						<td valign="top">&nbsp;#CtaNivel3#</td>
						<td valign="top">&nbsp;#CtaNivel4#</td>
						<td valign="top">&nbsp;#CtaNivel5#</td>
						<td valign="top">&nbsp;0000</td>
						<td valign="top">&nbsp;0000</td>
						<td valign="top">&nbsp;0000</td>
						<td>1</td>
						<td>&nbsp;</td>
						<td>ASIENTO PLANILLA #datosN.CPcodigo#</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td><cfif Sucursal EQ '1001'>#CentroCosto#<cfelse>&nbsp;</cfif></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<cfset count=count+1>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
<script>
function fnImgBack()
	{window.parent.location.href = '/cfmx/sif/rh/nomina/consultas/AsientoContaCoope-filtro.cfm';}
</script>
