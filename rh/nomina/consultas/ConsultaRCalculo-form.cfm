<cfif isDefined("Url.Tcodigo") and not isDefined("Form.Tcodigo")>
	<cfset Form.Tcodigo = Url.Tcodigo>
</cfif>
<cfif isDefined("Form.Tcodigo1") and len(trim(Form.Tcodigo1))>
	<cfset Form.Tcodigo = Form.Tcodigo1>
<cfelseif isDefined("Form.Tcodigo2") and len(trim(Form.Tcodigo2))>
	<cfset Form.Tcodigo = Form.Tcodigo2>
</cfif>
<cfif isDefined("Url.CPcodigo") and not isDefined("Form.CPcodigo")>
	<cfset Form.CPcodigo = Url.CPcodigo>
</cfif>
<cfif isDefined("Form.CPcodigo1") and len(trim(Form.CPcodigo1))>
	<cfset Form.CPcodigo = Form.CPcodigo1>
<cfelseif isDefined("Form.CPcodigo2") and len(trim(Form.CPcodigo2))>
	<cfset Form.CPcodigo = Form.CPcodigo2>
</cfif>
<cfif isDefined("Url.DEid") and not isDefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>
<cfif isDefined("Url.chkIncidencias") and not isDefined("Form.chkIncidencias")>
	<cfset Form.chkIncidencias = Url.chkIncidencias>
</cfif>
<cfif isDefined("Url.chkCargas") and not isDefined("Form.chkCargas")>
	<cfset Form.chkCargas = Url.chkCargas>
</cfif>
<cfif isDefined("Url.chkDeducciones") and not isDefined("Form.chkDeducciones")>
	<cfset Form.chkDeducciones = Url.chkDeducciones>
</cfif>
<!--- Consultas --->
<!--- Detalles de la Nómina --->
<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select a.DEid, a.RCNid,b.DEidentificacion,
	{fn concat({fn concat({fn concat({fn concat(
		b.DEapellido1 , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )}  as Nombre, 
	SEsalariobruto, SEincidencias, SErenta, SEcargasempleado, SEdeducciones, SEliquido
	from HSalarioEmpleado a 
	
	inner join DatosEmpleado b
 	  on a.DEid = b.DEid 
	  
	inner join HRCalculoNomina c
	  on a.RCNid = c.RCNid 
	
	inner join CalendarioPagos d
	  on a.RCNid = d.CPid
	
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
  	  and c.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Tcodigo#">
	  and rtrim(d.CPcodigo) = rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPcodigo#">)
	<cfif isDefined("Form.DEid") and len(trim(Form.DEid)) gt 0>
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfif>
</cfquery>

<!--- Consulta Relación de Cálculo --->
<cfif rsDetalle.RecordCount gt 0>
  <!--- Consulta Totales --->
  <cfquery name="rsTDetalle" datasource="#Session.DSN#">
  	select 	sum(SEsalariobruto) as TSEsalariobruto, 
			sum(SEincidencias) as TSEincidencias, 
			sum(SErenta) as TSErenta, 
			sum(SEcargasempleado) as TSEcargasempleado, 
			sum(SEdeducciones) as TSEdeducciones, 
			sum(SEliquido) as TSEliquido
	from HSalarioEmpleado
	where RCNid = #rsDetalle.RCNid#
  </cfquery>
  <cfquery name="rsHRelacionCalculo" datasource="#Session.DSN#">
	select a.RCNid, 
		   rtrim(a.Tcodigo) as Tcodigo, 
		   a.RCDescripcion, 
		   a.RCdesde as RCdesde, 
		   a.RChasta as RChasta,
		   (case a.RCestado 
				when 0 then '<cf_translate key="LB_Proceso">Proceso</cf_translate>'
				when 1 then '<cf_translate key="LB_Calculo">Cálculo</cf_translate>'
				when 2 then '<cf_translate key="LB_Terminado">Terminado</cf_translate>'
				when 3 then '<cf_translate key="LB_Pagado">Pagado</cf_translate>'
				else ''
		   end) as RCestado,
		   a.Usucodigo, 
		   a.Ulocalizacion, 
		   a.ts_rversion,
		   b.Tdescripcion,
		   b.Mcodigo
	from HRCalculoNomina a 
	
	inner join TiposNomina b
	  on a.Tcodigo = b.Tcodigo
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
  </cfquery>
  <cfquery name="rsHCargas" datasource="#Session.DSN#">
	select 	a.DEid, a.DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto
	from HCargasCalculo a 
	
	inner join DCargas b
      on a.DClinea = b.DClinea inner join ECargas c
      on b.ECid = c.ECid
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
  </cfquery>
  <cfquery name="rsHDeducciones" datasource="#Session.DSN#">	
	select  a.DEid, a.DCvalor, b.Ddescripcion, b.Dvalor, b.Dmetodo
	from HDeduccionesCalculo a 
	
	inner join DeduccionesEmpleado b
	  on a.Did = b.Did 
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
  </cfquery>
  <cfquery name="rsHIncidencias" datasource="#Session.DSN#">
	select a.DEid, ICfecha, ICvalor, ICmontores, b.CIdescripcion
	from HIncidenciasCalculo a 
	
	inner join CIncidentes b
	  on a.CIid = b.CIid
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">

  </cfquery>
</cfif>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="785" default="0" returnvariable="UnificaSalarioB"/>

<!--- Datos de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfif rsDetalle.REcordCount gt 0>
	<script language="javascript" type="text/javascript">
		<cfoutput>
			function Ir(RCNid,DEid){
				document.form1.RCNid.value = RCNid;
				document.form1.DEid.value = DEid;
				document.form1.submit();
			}
		</cfoutput>
	</script>
	<cfoutput>
	<form action="../../expediente/consultas/HResultadoCalculo.cfm" method="get" name="form1">
		<input type="hidden" name="RCNid" value="">
		<input type="hidden" name="Tcodigo" value="#Form.Tcodigo#">
		<input type="hidden" name="DEid" value="">
		<input type="hidden" name="CPcodigo" value="#Form.CPcodigo#">
		<input type="hidden" name="Regresar" value="/cfmx/rh/nomina/consultas/ConsultaRCalculo.cfm">
		<cfif isDefined("Form.chkIncidencias")>
			<input type="hidden" name="chkIncidencias" value="1">
		</cfif>
		<cfif isDefined("Form.chkCargas")>
			<input type="hidden" name="chkCargas" value="1">
		</cfif>
		<cfif isDefined("Form.chkDeducciones")>
			<input type="hidden" name="chkDeducciones" value="1">
		</cfif>
	</form>
	</cfoutput>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cfsavecontent variable="Reporte">
		<table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">		
			<tr>
				<td colspan="8" align="center">
					<table width="97%" cellspacing="0" cellpadding="0">
						<cfinvoke key="LB_HistoricoDeNominasAplicadas" default="Hist&oacute;rico de N&oacute;minas Aplicadas" returnvariable="LB_HistoricoDeNominasAplicadas" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_Desde" default="Desde" returnvariable="LB_Desde" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_Hasta" default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_Indefinido" default="Indefinido" returnvariable="LB_Indefinido" component="sif.Componentes.Translate"  method="Translate"/>
						<cfset filtro2= '<b>#LB_Desde#</b> '>
						<cfif len(trim(rsHRelacionCalculo.RCdesde))>
							<cfset filtro2= filtro2 & LSDateFormat(rsHRelacionCalculo.RCdesde,'dd/mm/yyyy')>
						<cfelse>
							<cfset filtro2=filtro2 &' '& LB_Indefinido>
						</cfif>
						<cfif len(trim(rsHRelacionCalculo.RChasta))>
							<cfset filtro2= filtro2 & ' <b>#LB_Hasta#</b>  '& LSDateFormat(rsHRelacionCalculo.RChasta,'dd/mm/yyyy')>
						<cfelse>
							<cfset filtro2= filtro2 & ' <b>#LB_Hasta#</b>  '& LB_Indefinido>
						</cfif>
						<cf_EncReporte
							Titulo="#LB_HistoricoDeNominasAplicadas#"
							Color="##E3EDEF"
							cols="8"		
							filtro1="<b>#rsHRelacionCalculo.Tdescripcion# - #rsHRelacionCalculo.RCDescripcion#</b>"			
							filtro2="#filtro2#"
						>
				</td>
			</tr>
	  
			<tr> 
			  <td colspan="8">&nbsp;</td>
			</tr>
			<!--- Resumen: Totales de RSDetalle --->
			<tr> 
			  <td nowrap class="tituloListas" align="left"><cf_translate key="LB_Empleados">Empleados</cf_translate> :&nbsp;</td>
			  <td nowrap class="tituloListas" align="left">&nbsp;</td>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_Bruto">Bruto</cf_translate> :&nbsp;</td>
			 <cfif not UnificaSalarioB> <td nowrap class="tituloListas" align="right"><cf_translate key="LB_Incidencias">Incidencias</cf_translate> :&nbsp;</td></cfif>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_Renta">Renta</cf_translate> :&nbsp;</td>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_CargasEmpleado">Cargas Empleado</cf_translate> :&nbsp;</td>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_Deducciones">Deducciones</cf_translate> :&nbsp;</td>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_Liquido">Líquido</cf_translate> :&nbsp;</td>
			</tr>
			<cfoutput query="rsTDetalle">
				<tr class="listaNon" onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='##FFFFFF';">
				  <td nowrap class="FileLabel" align="left">#rsDetalle.RecordCount#&nbsp;</td>
				  <td nowrap class="FileLabel" align="left">Resumen General&nbsp;</td>
				  <td nowrap class="FileLabel" align="right"><cfif not UnificaSalarioB>#LSCurrencyFormat(TSEsalariobruto,'none')#<cfelse>#LSCurrencyFormat(TSEsalariobruto+TSEincidencias,'none')#</cfif>&nbsp;</td>
				  <cfif not UnificaSalarioB><td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSEincidencias,'none')#&nbsp;</td></cfif>
				  <td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSErenta,'none')#&nbsp;</td>
				  <td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSEcargasempleado,'none')#&nbsp;</td>
				  <td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSEdeducciones,'none')#&nbsp;</td>
				  <td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSEliquido,'none')#&nbsp;</td>
				</tr>
			</cfoutput>
			<tr> 
			  <td colspan="8">&nbsp;</td>
			</tr>
			<tr> 
			  <td nowrap class="tituloListas" align="left"><cf_translate key="LB_Cedula">Cédula</cf_translate> :&nbsp;</td>
			  <td nowrap class="tituloListas" align="left"><cf_translate key="LB_Nombre">Nombre</cf_translate> :&nbsp;</td>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_Bruto">Bruto</cf_translate> :&nbsp;</td>
			  <cfif not UnificaSalarioB><td nowrap class="tituloListas" align="right"><cf_translate key="LB_Incidencias">Incidencias</cf_translate> :&nbsp;</td></cfif>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_Renta">Renta</cf_translate> :&nbsp;</td>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_CargasEmpleado">Cargas Empleado</cf_translate> :&nbsp;</td>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_Deducciones">Deducciones</cf_translate> :&nbsp;</td>
			  <td nowrap class="tituloListas" align="right"><cf_translate key="LB_Liquido">Líquido</cf_translate> :&nbsp;</td>
			</tr>

			<cfoutput query="rsDetalle"> 
				<tr style="cursor:hand;" class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
				  onmouseover="style.backgroundColor='##E4E8F3';" 
				  onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"
				  onClick="javascript:Ir(#rsDetalle.RCNid#,#rsDetalle.DEid#)"> 
					<td nowrap>#rsDetalle.DEidentificacion#</td>
					<td nowrap>#rsDetalle.Nombre#</td>
					<td nowrap align="right"><cfif not UnificaSalarioB>#LSCurrencyFormat(rsDetalle.SEsalariobruto,'none')#<cfelse>#LSCurrencyFormat(rsDetalle.SEsalariobruto+rsDetalle.SEincidencias,'none')#</cfif></td>
					<cfif not UnificaSalarioB><td nowrap align="right">#LSCurrencyFormat(rsDetalle.SEincidencias,'none')#</td></cfif>
					<td nowrap align="right">#LSCurrencyFormat(rsDetalle.SErenta,'none')#</td>
					<td nowrap align="right">#LSCurrencyFormat(rsDetalle.SEcargasempleado,'none')#</td>
					<td nowrap align="right">#LSCurrencyFormat(rsDetalle.SEdeducciones,'none')#</td>
					<td nowrap align="right">#LSCurrencyFormat(rsDetalle.SEliquido,'none')#</td>
				</tr>
				<!--- Incidencias --->
				<cfif isDefined("Form.chkIncidencias")>
					<cfquery name="rsTemp" dbtype="query">
						select * from rsHIncidencias where DEid = #rsDetalle.DEid#
					</cfquery>
					<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
						onmouseover="style.backgroundColor='##E4E8F3';" 
						onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
						<td nowrap>&nbsp;</td>
						<td nowrap colspan="7" ><strong><em><cf_translate key="LB_Incidencias">Incidencias</cf_translate></em></strong></td>
					</tr>
					<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
						onmouseover="style.backgroundColor='##E4E8F3';" 
						onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
						<td nowrap>&nbsp;</td>
						<td nowrap class="FileLabel" align="left"><cf_translate key="LB_Fecha">Fecha</cf_translate> :&nbsp;</td>
						<td nowrap class="FileLabel" colspan="4" align="left"><cf_translate key="LB_Concepto">Concepto</cf_translate> :&nbsp;</td>
						<td nowrap class="FileLabel" align="right"><cf_translate key="LB_Valor">Valor</cf_translate> :&nbsp;</td>
						<td nowrap class="FileLabel" align="right"><cf_translate key="LB_MontoResultante">Monto Resultante</cf_translate> :&nbsp;</td>
					</tr>
					<cfif rsTemp.RecordCount gt 0>
						<cfloop query="rsTemp">
							<tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
								onmouseover="style.backgroundColor='##E4E8F3';" 
								onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
							  <td nowrap>&nbsp;</td>
							  <td nowrap> 
								#LSDateFormat(rsTemp.ICfecha,'dd/mm/yyyy')#</td>
							  <td nowrap colspan="4"> 
								#rsTemp.CIdescripcion#</td>
							  <td nowrap align="right"> #rsTemp.ICvalor# </td>
							  <td nowrap align="right"> #LSCurrencyFormat(rsTemp.ICmontores,'none')# </td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
							onmouseover="style.backgroundColor='##E4E8F3';" 
							onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
						<td colspan="8" align="center"><cf_translate key="LB_NoHayIncidenciasAsociadasAlEmpleado">No hay incidencias asociadas al empleado</cf_translate></td>
					  </tr>
					</cfif>
					<tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
						onmouseover="style.backgroundColor='##E4E8F3';" 
						onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					  <td colspan="8">&nbsp;</td>
					</tr>
				</cfif>
				<!--- Cargas --->
				<cfif isDefined("Form.chkCargas")>
					<cfquery name="rsTemp" dbtype="query">
						select * from rsHCargas where DEid = #rsDetalle.DEid# 
					</cfquery>
					<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
						onmouseover="style.backgroundColor='##E4E8F3';" 
						onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					  <td nowrap>&nbsp;</td>
					  <td nowrap colspan="7"><strong><em><cf_translate key="LB_Cargas">Cargas</cf_translate></em></strong></td>
					</tr>
					<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
						onmouseover="style.backgroundColor='##E4E8F3';" 
						onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
						<td nowrap>&nbsp;</td>
						<td nowrap class="FileLabel" colspan="5" align="left"><cf_translate key="LB_Descripcion">Descripción</cf_translate> :&nbsp;</td>
						<td nowrap class="FileLabel" align="right"><cf_translate key="LB_MontoPatrono">Monto Patrono</cf_translate> :&nbsp;</td>
						<td nowrap class="FileLabel" align="right"><cf_translate key="LB_MontoEmpleado">Monto Empleado</cf_translate> :&nbsp;</td>
					</tr>
					<cfif rsTemp.RecordCount gt 0>
						<cfloop query="rsTemp">
							<tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
								onmouseover="style.backgroundColor='##E4E8F3';" 
								onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
							  <td nowrap>&nbsp;</td>
							  <td nowrap colspan="5"> 
								#rsTemp.DCdescripcion#</td>
							  <td nowrap align="right"> #LSCurrencyFormat(rsTemp.CCvalorpat,'none')# </td>
							  <td nowrap align="right"> #LSCurrencyFormat(rsTemp.CCvaloremp,'none')# </td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
							onmouseover="style.backgroundColor='##E4E8F3';" 
							onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
							<td colspan="8" align="center"><cf_translate key="LB_NoHayCargasAsociadasAlEmpleado">No hay cargas asociadas al empleado</cf_translate></td>
						</tr>
					</cfif>
					<tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
						onmouseover="style.backgroundColor='##E4E8F3';" 
						onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					  <td colspan="8">&nbsp;</td>
					</tr>
				</cfif>
				<!--- Deducciones --->
				<cfif isDefined("Form.chkDeducciones")>
					<cfquery name="rsTemp" dbtype="query">
						select * from rsHDeducciones where DEid = #rsDetalle.DEid# 
					</cfquery>
					<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
						onmouseover="style.backgroundColor='##E4E8F3';" 
						onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
						<td nowrap>&nbsp;</td>
						<td nowrap colspan="7"><strong><em><cf_translate key="LB_Deducciones">Deducciones</cf_translate></em></strong></td>
					</tr>
					<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
						onmouseover="style.backgroundColor='##E4E8F3';" 
						onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
						<td nowrap>&nbsp;</td>
						<td nowrap class="FileLabel" colspan="5" align="left"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate> :&nbsp;</td>
						<td nowrap class="FileLabel" align="right"><cf_translate key="LB_Valor">Valor</cf_translate> :&nbsp;</td>
						<td nowrap class="FileLabel" align="right"><cf_translate key="LB_Monto esultante">Monto Resultante</cf_translate> :&nbsp;</td>
					</tr>
					<cfif rsTemp.RecordCount gt 0>
						<cfloop query="rsTemp">
							<tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
								onmouseover="style.backgroundColor='##E4E8F3';" 
								onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
								<td nowrap>&nbsp;</td>
								<td nowrap colspan="5">#rsTemp.Ddescripcion#</td>
								<td nowrap align="right">
								<cfif Dmetodo neq 0>
									#LSCurrencyFormat(Dvalor,'none')# 
								<cfelse>
									#LSCurrencyFormat(Dvalor,'none')# % 
								</cfif>
								</td>
								<td nowrap align="right"> #LSCurrencyFormat(rsTemp.DCvalor,'none')# </td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
							onmouseover="style.backgroundColor='##E4E8F3';" 
							onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
							<td colspan="8" align="center"><cf_translate key="LB_NoHayDeduccionesAsociadasAlEmpleado">No hay deducciones asociadas al empleado</cf_translate></td>
						  </tr>
					</cfif>
					<tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> 
						onmouseover="style.backgroundColor='##E4E8F3';" 
						onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					  <td colspan="8">&nbsp;</td>
					</tr>
				</cfif>
			</cfoutput> 
			<tr> 
			  <td colspan="8">&nbsp;</td>
			</tr>
			<td colspan="8" align="center"> <strong>*** <cf_translate key="LB_FinDelReporte">Fin del Reporte</cf_translate> *** </strong> 
			</td>
			<tr> 
			  <td colspan="8">&nbsp;</td>
			</tr>
			
			</table>
	</cfsavecontent>
	<cfoutput>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_HistoricoDeNominasAplicadas"
		Default="Hist&oacute;rico de N&oacute;minas Aplicadas"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_HistoricoDeNominasAplicadas"/>		

		<!--- <cfif not isdefined("url.imprimir")>
			<cf_sifHTML2Word listTitle="#LB_HistoricoDeNominasAplicadas#">
				#Reporte#
			</cf_sifHTML2Word>
		<cfelse>
			#Reporte#
		</cfif> --->
		<cfset LvarFileName = "LB_HistoricoDeNominasAplicadas#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
		
		<cfif isdefined('form.HNA')> 
			<cfset varIrA ="ConsultaRCalculo.cfm?HNA=1">
		<cfelse>	
			<cfset varIrA ="ConsultaRCalculo.cfm">
		</cfif>

		<cf_htmlReportsHeaders 
			title="#LB_HistoricoDeNominasAplicadas#" 
			filename="#LvarFileName#"
			irA="#varIrA#"
			back="no"
			back2="yes" >
			
		<cfif not isdefined("form.btnDownload")>
			<cf_templatecss>
		</cfif>	
		#Reporte#
		
		
	</cfoutput>
<cfelse>
	<table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
	<tr>
		<tr> 
		  <td colspan="8">&nbsp;</td>
		</tr>
		  <td colspan="8" align="center"> 
		  <strong>*** <cf_translate key="MSG_LaConsultaNoGeneroNingunResultado ">La Consulta No Gener&oacute; Ning&uacute;n Resultado </cf_translate> *** </strong> </td>
		<tr> 
		  <td colspan="8">&nbsp;</td>
		</tr>
	</tr>
	</table>	
</cfif>