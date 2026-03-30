<!--- <cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfset lvarValorN = "">
<cfset lvarValorS = "">
<cfif #nivel.Pvalor# neq '-1'>
	<cfset lvarValorN = "AND (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor -1#">
	<cfelse>
	<cfset lvarValorS = "and cc.Cmovimiento = 'S'">
</cfif>

<cfset LvarOrden = ''>
<cfif #valOrden.RecordCount# eq 0>
<cfset LvarOrden = "">
<cfelse>
	<cfif #valOrden.Pvalor# eq 'N'>
		<cfset LvarOrden = " INNER JOIN CtasMayor cm ON cc.Cmayor = cm.Cmayor AND cm.Ctipo <> 'O'  and cm.Ecodigo = cc.Ecodigo">
	</cfif>
</cfif> --->
<!--- Cuentas que no estan en la empresa de eliminacion  --->
<cfset errIndex = 0>
<cfset myarray=arraynew(2)>
<cfif isdefined("form.btnCrear")>
	<cfinvoke component="sif.Componentes.ErrorProceso" method="delErrors">
		<cfinvokeargument name="Spcodigo"   	value="CECTASNOINC">
	    <cfinvokeargument name="Ecodigo"   		value="#session.Ecodigo#">
	</cfinvoke>
	<cfquery name="subcuentas" datasource="#Session.DSN#">
		SELECT distinct Cformato
		FROM CContables a
		inner join Empresas e
			on a.Ecodigo = e.Ecodigo
		inner join CtasMayor cm
			on a.Cmayor = cm.Cmayor
			and a.Ecodigo = cm.Ecodigo
		INNER JOIN PCDCatalogoCuenta b
			on a.Ccuenta = b.Ccuentaniv
			and b.PCDCniv <= (	select isnull(Pvalor,2) Pvalor from Parametros where Ecodigo = #Session.Ecodigo# and Pcodigo = 200080) -1
		left join CCInactivas cci
			on a.Ccuenta = cci.Ccuenta
			and getdate() BETWEEN CCIdesde and CCIhasta
		Where
			a.Ecodigo in (
				SELECT  Ecodigo
				FROM AnexoGEmpresaDet
				where GEid = (
					SELECT  GEid
					FROM AnexoGEmpresaDet
					where Ecodigo = #Session.Ecodigo#)
			)
		and a.Cmovimiento = 'S'
		AND not Exists (select Cformato from CContables b where Ecodigo = #Session.Ecodigo# and a.Cformato = b.Cformato)
		and cci.CCIid is null
		order by Cformato
	</cfquery>
		<cfobject component="sif/Componentes/ErrorProceso" name="errorP">
		<cfinvoke component="#errorP#" method="delErrors" returnvariable="error">
			<cfinvokeargument name="Spcodigo" value="CECTANOICLUD">
			<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
		</cfinvoke>

		<cfloop query="subcuentas"> <!--- por cada cuenta --->
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" 		value="#trim(subcuentas.Cformato)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_DSN" 				value="#Session.DSN#"/>
				<cfinvokeargument name="Lprm_Ecodigo" 			value="#Session.Ecodigo#"/>
			</cfinvoke>
			<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
				<cfset mensaje="ERROR">
				<cfquery name="rsEmpresa" datasource="#session.dsn#">
					SELECT  Edescripcion FROM Empresas where Ecodigo = #Session.Ecodigo#
				</cfquery>
				<cfset errIndex = errIndex + 1>
				<cfinvoke component="#errorP#" method="insertErrors" returnvariable="error">
			        <cfinvokeargument name="Spcodigo" value="CECTANOICLUD">
			        <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
			        <cfinvokeargument name="Descripcion" value="#LvarError#">
			        <cfinvokeargument name="Valor" value="#trim(rsEmpresa.Edescripcion)#">
		        </cfinvoke>
			    <cfset myarray[errIndex][1] = "#trim(rsEmpresa.Edescripcion)#">
			    <cfset myarray[errIndex][2] = "#LvarError#">
				<cfset LvarCcuenta = -1>
				<!--- <cfthrow message="#LvarError#"> --->
			</cfif>
			<cfset LvarCcuenta = request.PC_GeneraCFctaAnt.Ccuenta>
		</cfloop>
</cfif>

<cfquery name="rsCuentNoInclu" datasource="#Session.DSN#">
	SELECT distinct Cformato,
		a.Ecodigo,
		e.Edescripcion empresa,
		a.Cdescripcion,
		a.Cmovimiento
	FROM CContables a
	inner join Empresas e
		on a.Ecodigo = e.Ecodigo
	inner join CtasMayor cm
		on a.Cmayor = cm.Cmayor
		and a.Ecodigo = cm.Ecodigo
	INNER JOIN PCDCatalogoCuenta b
		on a.Ccuenta = b.Ccuentaniv
		and b.PCDCniv <= (	select isnull(Pvalor,2) Pvalor from Parametros where Ecodigo = #Session.Ecodigo# and Pcodigo = 200080) -1
	left join CCInactivas cci
		on a.Ccuenta = cci.Ccuenta
		and getdate() BETWEEN CCIdesde and CCIhasta
	Where
		a.Ecodigo in (
			SELECT  Ecodigo
			FROM AnexoGEmpresaDet
			where GEid = (
				SELECT  GEid
				FROM AnexoGEmpresaDet
				where Ecodigo = #Session.Ecodigo#)
		)
	AND not Exists (select Cformato from CContables b where Ecodigo = #Session.Ecodigo# and a.Cformato = b.Cformato)
	and cci.CCIid is null
	order by Cformato
</cfquery>

<cfquery name="Empresas" datasource="#Session.DSN#">
	select
		Ecodigo,
		Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>



<cfhtmlhead text="
<style type='text/css'>
td {  font-size: 11px; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
a {
	text-decoration: none;
	color: ##000000;
}
.listaCorte { font-size: 11px; font-weight:bold; background-color:##CCCCCC; text-align:left;}
.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}
.tituloSub { background-color:##FFFFFF; font-weight: bolder; text-align: center; vertical-align: middle; font-size: smaller; border-color: black black ##CCCCCC; border-style: inset; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
.tituloListas {

	font-weight: bolder;
	vertical-align: middle;
	padding: 5px;
	background-color: ##F5F5F5;
}
</style>">
<cfif rsCuentNoInclu.recordCount GT 0>
	<form name="frmCrearCtas" action="SQLCuentasNoIncluidasCEGE.cfm" method="post" id="frmCrearCtas">
	<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="8" align="center">
				<input type="submit" value="Crear Todas las Cuentas" id="btnCrear" name="btnCrear" class="btnAgregar">
			</td>
		</tr>
		<tr>
			<td colspan="5">
				<p style="font-size: 10px; text-align: center; font-weight:bold;">Solo se generar&aacute;n las Cuentas de &uacute;ltimo nivel.</p>
			</td>
		</tr>
	</table>
	</form>
</cfif>
<cfinvoke key="LB_Titulo" default="Cuentas No incluidas" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLCuentasNoIncluidasCEGE.xml"/>
<cfinvoke key="LB_Empresa" default="Empresa en la que se encuentra" returnvariable="LB_Empresa" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLCuentasNoIncluidasCEGE.xml"/>
<cfinvoke key="LB_CDescripcion" default="Descripcion" returnvariable="LB_CDescripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLCuentasNoIncluidasCEGE.xml"/>
<cfinvoke key="LB_Formato" default="Cuenta" returnvariable="LB_Formato" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLCuentasNoIncluidasCEGE.xml"/>

<cfset Title = "Cuentas No incluidas">
<cfset FileName = "CuentasNoIncluidas">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
<cfset LvarIrA  = 'ReporteMapeoCuentasCEGrupEmp.cfm'>

<cfset varParam = "">
<cfif isdefined("form.btnCrear") and isdefined("myarray") and ArrayLen(myarray) GT 0>
	<cfset varParam = "&Error=1">
</cfif>

<cf_htmlreportsheaders title="#Title#" filename="#FileName#.xls" download="yes" ira="#LvarIrA#" param="#varParam#">
	<!--- <cf_dump var ="#EmpList#"> --->

<cfif (isdefined("form.btnCrear") and isdefined("myarray") and ArrayLen(myarray) GT 0) or isdefined("url.Error")>
	<cfset Title = "Errores creando Cuentas No incluidas">
	<cfset FileName = "ErrCuentasNoIncluidas">
	<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

	<cfquery name="selectError" datasource="#session.dsn#">
		SELECT Valor,Descripcion
		FROM ErrorProceso
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			AND Spcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="CECTANOICLUD">
			and Usucodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">
	</cfquery>

	<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
	<cfset LvarIrA  = 'CatalogoCuentasSATCE.cfm'>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr bgcolor="E2E2E2" class="subTitulo">
            <td valign="middle" width="30%"><strong>Empresa</strong></td>
            <td valign="middle"><strong><strong>Error</strong></td>
        </tr>
        <cfset actRow = 1>
		<cfloop query="selectError">
			<tr style="cursor: pointer;" onMouseOver="javascript: style.color = 'red';" onMouseOut="javascript: style.color = 'black';"
				<cfif actRow MOD 2>
					bgcolor="white"
				<cfelse>
					bgcolor="#F8F8F8"
				</cfif>
				>
					<td>
						<cfoutput>#selectError.Valor#</cfoutput>
					</td>
					<td>
						<cfoutput>#selectError.Descripcion#</cfoutput>
					</td>
				</tr>
				<cfset actRow = actRow + 1>
		</cfloop>
	</table>
<cfelse>
	<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="0">
		<cfoutput>
		<tr class="area">
			<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
		</tr>
		<tr class="area">
			<td align="center" colspan="8" nowrap><strong>#LB_Titulo#</strong></td>
		</tr>
		<tr>
			<td colspan="8" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
		</tr>
	    <tr>
			<td colspan="8" class="listaCorte"></td>
		</tr>
	    <tr class="tituloListas">
			<td colspan="2"><strong>#LB_Formato#</strong></td>
			<td colspan="4"><strong>#LB_CDescripcion#</strong></td>
			<td colspan="2"><strong>#LB_Empresa#</strong></td>
			<td colspan="2"><strong>Ultimo Nivel</strong></td>
		</tr>
		</cfoutput>
		<!--- <cfflush interval="3"> Demora demasiado con esta etiqueta--->
		<cfoutput query="rsCuentNoInclu">
				<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td colspan="2">
						#rsCuentNoInclu.Cformato#
					</td>
					<td colspan="2">
						#rsCuentNoInclu.Cdescripcion#
					</td>
					<td colspan="4">
						#rsCuentNoInclu.empresa#
					</td>
					<td align="center">#rsCuentNoInclu.Cmovimiento#</td>
				</tr>
		</cfoutput>
	</table>
</cfif>