<cfset LvarAdmObr = isdefined("LvarAdmObr")>
<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<cfquery datasource="#session.dsn#" name="rsOBO">
	select 	tp.OBTPtipoCtaLiquidacion, tp.Cmayor,
			p.OBPid, p.OBPcodigo, p.OBPdescripcion, 
			o.OBOid, o.OBOcodigo, o.OBOdescripcion, o.OBOtipoValorLiq, o.OBOmontoLiq
			, OBCliquidacion
	  from OBobra o
	  	inner join OBproyecto p
			inner join OBtipoProyecto tp
				inner join OBctasMayor cm
				   on cm.Ecodigo	= #session.Ecodigo#
				  and cm.Cmayor		= tp.Cmayor
				on tp.OBTPid = p.OBTPid
			on p.OBPid = o.OBPid
	 where o.OBOid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
</cfquery>

<cfif rsOBO.OBCliquidacion NEQ "1" OR rsOBO.OBTPtipoCtaLiquidacion EQ 99>
	<cfset LvarTipoCtaLiquidacion = "Liquidación Externa">
	<cflocation url="OBobraLiquidacion_sql.cfm?OP=L&OBOid=#form.OBOid#">
<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 0>
	<cfset LvarTipoCtaLiquidacion = "Cada Cuenta de la Obra">
<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 1>
	<cfset LvarTipoCtaLiquidacion = "Cada Cuenta de la Obra con niveles sustituidos">
<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 2>
	<cfset LvarTipoCtaLiquidacion = "Una única Cuenta de Liquidación">
<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 3>
	<cfset LvarTipoCtaLiquidacion = "Una Cuenta de Liquidación por Activo">
</cfif>

<cfoutput>
<table>
		<tr>
			<td colspan="3" class="subTitulo">
				Datos de Liquidación de la Obra y Activos a Generar
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Proyecto</strong>
			</td>
			<td valign="top">
				&nbsp;&nbsp;&nbsp;
			</td>
			<td valign="top" nowrap>
				<strong>#rsOBO.OBPcodigo# - #rsOBO.OBPdescripcion#</strong>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Obra</strong>
			</td>
			<td valign="top">
				&nbsp;&nbsp;&nbsp;
			</td>
			<td valign="top" nowrap>
				<strong>#rsOBO.OBOcodigo# - #rsOBO.OBOdescripcion#</strong>
			</td>
		</tr>

		<tr>
			<td valign="top" nowrap>
				<strong>Tipo Cuenta Liquidacion</strong>
			</td>
			<td valign="top">
				&nbsp;&nbsp;&nbsp;
			</td>
			<td valign="top">
				<strong>#LvarTipoCtaLiquidacion#</strong>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Monto a Liquidar</strong>
			</td>
			<td valign="top">
				&nbsp;&nbsp;&nbsp;
			</td>
			<td valign="top" nowrap>
				<strong>#numberformat(rsOBO.OBOmontoLiq,",0.00")#</strong>
		<cfif rsOBO.OBOtipoValorLiq EQ "M">
			<cfquery name="rsOBL" datasource="#session.dsn#">
				select 	coalesce(sum(OBOLmonto),0) as total
				  from OBobraLiquidacion
				 where OBOid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
			</cfquery>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>Total Asignado:&nbsp;&nbsp;</strong>
				<strong>#numberformat(rsOBL.total,",0.00")#</strong>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>Diferencia:&nbsp;&nbsp;</strong>
				<font <cfif rsOBL.total-rsOBO.OBOmontoLiq NEQ 0>color="##FF0000"</cfif>>
				<strong>#numberformat(rsOBL.total-rsOBO.OBOmontoLiq,",0.00")#</strong>
				</font>
		</cfif>
			</td>
		</tr>
</table>
</cfoutput>
<cfif LvarAdmObr>
	<cfset LvarBotones = "Nuevo,Liquidar,Regresar,Calcular_Monto">
<cfelse>
	<cfset LvarBotones = "Nuevo,Calcular_Monto">
</cfif>

<cfif rsOBO.OBOtipoValorLiq EQ "P">
	<cfset LvarDesplegar = "CtaLiquidacion, OBOLactivo, ctaActivo, OBOLporcentaje">
	<cfset LvarEtiquetas = "Cuenta Liquidación,Activo,Cta.Activo,Porcentaje (%)">
<cfelse>
	<cfset LvarDesplegar = "CtaLiquidacion, OBOLactivo, ctaActivo, OBOLmonto">
	<cfset LvarEtiquetas = "Cuenta Liquidación,Activo,Cta.Activo,Monto">
</cfif>
<cfif rsOBO.OBTPtipoCtaLiquidacion EQ 0>
	<cfset LvarCtaLiquidacion = "'Cada Cuenta de la Obra'">
<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 1>
	<cfset LvarCtaLiquidacion = "'Cada Cuenta de la Obra con niveles sustituidos'">
<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 2>
	<cfset LvarCtaLiquidacion = "rtrim(l.CFformatoLiquidacion)">
<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 3>
	<cfset LvarCtaLiquidacion = "rtrim(l.CFformatoLiquidacion)">
<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 99>
	<cfset LvarCtaLiquidacion = "rtrim(l.CFformatoLiquidacion)">
</cfif>
<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla=
		"OBobraLiquidacion l 
			inner join OBobra obo
				on obo.OBOid = l.OBOid
			inner join CFinanciera ca
				on ca.CFcuenta = l.CFcuentaActivo
			inner join CFuncional cf
				inner join Oficinas o
					on o.Ecodigo = cf.Ecodigo
				   and o.Ocodigo = cf.Ocodigo
				on cf.CFid = l.CFidActivo
		"
	columnas="'Oficina: ' #_CAT# o.Oficodigo #_CAT# ' - ' #_CAT# o.Odescripcion as Oficina, 
				'Centro Funcional: ' #_CAT# cf.CFcodigo #_CAT# ' - ' #_CAT# cf.CFdescripcion as CentroFuncional, 
				l.OBOLactivo, 
				l.OBOid, obo.OBOLidDefault, l.OBOLid, 
				round(l.OBOLporcentaje*100,0) as OBOLporcentaje, l.OBOLmonto, 
				#LvarCtaLiquidacion# as CtaLiquidacion, ca.CFformato as CtaActivo, #session.Ecodigo# as Ecodigo, 1 as OP"
	filtro="l.OBOid=#form.OBOid# order by o.Oficodigo, cf.CFcodigo"
	cortes="Oficina, CentroFuncional"
	desplegar="#LvarDesplegar#"
	etiquetas="#LvarEtiquetas#"
	formatos="S,S,S,U"
	align="left,left,left,right"
	ira="OBobra.cfm"
	form_method="post"
	keys="Ecodigo,OBOid,OBOLid"

	mostrar_filtro="yes"
	filtrar_automatico="yes"
	filtrar_por="CFformatoLiquidacion, OBOLactivo, OBOLporcentaje, ca.CFformato"

	botones="#LvarBotones#"
	pageIndex="3"
	LineaAzul="OBOLidDefault EQ OBOLid"
	formname="listaLiquidacion"
/>
<script language="javascript">
	function funcNuevo()
	{
		location.href = "OBobra.cfm?OP=L&btnNuevo&OBOid=<cfoutput>#form.OBOid#</cfoutput>";
		return false;
	}
	function funcRegresar()
	{
		location.href = "OBobra.cfm?OBOid=<cfoutput>#form.OBOid#</cfoutput>";
		return false;
	}
	function funcCalcular_Monto()
	{
		location.href = "OBobraLiquidacion_sql.cfm?OP=C&OBOid=<cfoutput>#form.OBOid#</cfoutput>";
		return false;
	}
	function funcLiquidar()
	{
		if (!confirm("¿Desea ejecutar el proceso de liquidación de la obra?"))
			return false;
		location.href = "OBobraLiquidacion_sql.cfm?OP=L&OBOid=<cfoutput>#form.OBOid#</cfoutput>";
		return false;
	}
	document.listaLiquidacion.OBOID.value = "<cfoutput>#form.OBOid#</cfoutput>";
	document.listaLiquidacion.OP.value = "L";
</script>
