	<cfinclude template="Funciones.cfm">
	<cfquery datasource="#Session.DSN#" name="rsEmpresa">
		select Edescripcion from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfif isdefined("url.periodo")>
		<cfparam name="Form.periodo" default="#url.periodo#">
	</cfif>
	<cfif isdefined("url.mes")>
		<cfparam name="Form.mes" default="#url.mes#">
	</cfif>
	<cfif isdefined("url.nivel")>
		<cfparam name="Form.nivel" default="#url.nivel#">
	</cfif>
	<cfif isdefined("url.ceros")>
		<cfparam name="Form.ceros" default="#url.ceros#">
	</cfif>

	<cfif isdefined("Form.Nivel") and Form.Nivel neq "-1">
		<cfset varNivel = Form.Nivel>
	<cfelse>
		<cfset varNivel = "0">
	</cfif>

	<cfif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "0">
		<cfset varMonedas = Form.Moneda>
	<cfelse>
		<cfset varMonedas = Form.mcodigoopt>
	</cfif>

	<cftransaction>	
		<cfinvoke returnvariable="rsProc" component="sif.Componentes.CG_EstadoResultadosCF" method="estadoResultados" 
			Ecodigo="#Session.Ecodigo#"
			periodo="#Form.periodo#"
			mes="#Form.mes#"
			ceros="N"
			nivel = "#varNivel#"
			dependencias = "#isdefined('form.dependencias')#"
			Mcodigo="#varMonedas#"
			CFid="#form.CFid#"	>

		</cfinvoke>			
	</cftransaction>
	


<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">

<cf_sifHTML2Word titulo="Estado de Resultados">
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size:12px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>

<cfquery name="rsMayor" dbtype="query">
	select *
	from rsProc
	where nivel = 0
	order by corte, mayor, formato
</cfquery>

<cfif isdefined("form.CFid") and len(trim(CFid))>
	<cfquery name="cf" datasource="#session.DSN#">
		select CFdescripcion
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
</cfif>


<cfoutput>
	<table width="77%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
    	<tr><td colspan="6" align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="4"><strong>#session.Enombre#</strong></font></td></tr>
    	<tr><td colspan="6" align="center"><b><font face="Times New Roman, Times, serif" size="4">Estado de Resultados</font></b></td></tr>
		<cfif isdefined("cf")>
			<tr><td colspan="6" align="center"><b><font face="Times New Roman, Times, serif" size="3">Centro Funcional: #cf.CFdescripcion#</font></b></td></tr>
		</cfif>
    	<tr>
			<td colspan="6" align="center" style="padding-right: 20px">
				<b>Mes:</b>&nbsp;
          		#ListGetAt(meses, Form.mes, ',')#&nbsp;
				<b>Período:</b>&nbsp;
				#Form.periodo#
			</td>
    	</tr>
		<tr><td colspan="6">&nbsp;</td></tr>
		<cfset corteR = 0>
		<cfset corteCtaMayor = 0>
		<cfloop query="rsMayor"> 
			<!--- PINTAR EL CORTE POR SUBTIPO --->
			<cfif rsMayor.corte NEQ corteR>
				<cfset corteR = rsMayor.corte>
				<cfset corteCtaMayor = 0>
				<cfif rsMayor.currentRow NEQ 1>
				<tr><td colspan="6" class="bottomline">&nbsp;</td></tr>
				</cfif>
				<cfquery name="rsSaldo" dbtype="query">
					select sum(saldofin) as total
					from rsProc
					where corte = <cfqueryparam cfsqltype="cf_sql_integer" value="#corteR#">
					and nivel = 0
				</cfquery>
				<tr> 
					<td width="50%" colspan="4" align="left" nowrap class="encabReporte">#rsMayor.ntipo#</td>
					<td width="34%" colspan="2" class="encabReporte" align="right">
						#LSNumberFormat(rsSaldo.total, ',9.00()')#
					</td>
				</tr>
			</cfif>

			<!--- PINTAR EL CORTE POR CUENTA DE MAYOR EXCEPTO QUE SEA IGUAL A 0 O IGUAL A UNA CUENTA MAYOR ANTERIOR --->
			<cfif corteCtaMayor NEQ rsMayor.mayor>
				<cfset corteCtaMayor = rsMayor.mayor>
				<cfquery name="rsSaldo" dbtype="query">
					select formato, descrip, saldofin as total
					from rsProc
					where corte = <cfqueryparam cfsqltype="cf_sql_integer" value="#corteR#">
					and mayor = '#corteCtaMayor#'
					and nivel = 0
				</cfquery>
				<tr> 
					<td width="50%" colspan="4" align="left" nowrap class="tituloListas"><font size="2"><strong>#rsSaldo.formato# - #rsSaldo.descrip#</strong></font></td>
					<td width="34%" colspan="2" class="tituloListas" align="right">
						<font size="2" <cfif rsSaldo.total LT 0>color="##FF0000"</cfif>>
						<strong>#LSNumberFormat(rsSaldo.total, ',9.00()')#</strong>
						</font>
					</td>
				</tr>
			</cfif>
			
			<!--- OBTENER TODAS LAS SUBCUENTAS DE LA CUENTA MAYOR --->
			<cfquery name="rsSubCuenta" dbtype="query">
				select *
				from rsProc
				where corte = <cfqueryparam cfsqltype="cf_sql_integer" value="#corteR#">
				and mayor = '#corteCtaMayor#'
				and nivel <> 0
				order by formato
			</cfquery>
			
			<cfloop query="rsSubCuenta"> 
				<tr style="padding:2px; " <cfif rsSubCuenta.nivel EQ 0>class="tituloListas"</cfif>> 
					<td width="50%" align="left" nowrap> 
						<cfif rsSubCuenta.nivel EQ 0>
							<font size="2"><strong>#formato# #descrip#</strong></font>
						<cfelse>
							<cfset LvarCont = rsSubCuenta.nivel>
							<cfloop condition="LvarCont NEQ 0">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<cfset LvarCont = LvarCont - 1>
							</cfloop>
							#formato# #descrip#
						</cfif>
					</td>
					<td align="right">
						<cfif rsSubCuenta.nivel GT 1>
							<cfif rsSubCuenta.saldofin GTE 0>#LSNumberFormat(rsSubCuenta.saldofin,'999,999,999,999,999.00')# 
							<cfelse><font color="##FF0000">#LSNumberFormat(rsSubCuenta.saldofin,'999,999,999,999,999.00()')#</font> 
							</cfif>
						</cfif>
					</td>
					<td colspan="2" align="right">
						<cfif rsSubCuenta.nivel EQ 1>
							<cfif rsSubCuenta.saldofin GTE 0>#LSNumberFormat(rsSubCuenta.saldofin,'999,999,999,999,999.00')# 
							<cfelse><font color="##FF0000">#LSNumberFormat(rsSubCuenta.saldofin,'999,999,999,999,999.00()')#</font> 
							</cfif>
						</cfif>
					</td>
					<td>&nbsp;</td>
					<td align="right">&nbsp;</td>
				</tr>
			</cfloop>
		</cfloop>
    <tr> 
      <td colspan="6">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="6"><div align="center">------------------ Fin del Reporte ------------------</div></td>
    </tr>
  </table>
  <br />
</cfoutput>
</cf_sifHTML2Word>