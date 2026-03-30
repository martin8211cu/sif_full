<cfquery datasource="#session.dsn#" name="rsOBP">
	select p.OBPid, p.OBPcodigo, p.OBPdescripcion, p.PCEcatidObr, p.CFformatoPry
		, c.PCEcodigo, c.PCEdescripcion, c.PCElongitud, c.PCEempresa, c.PCEoficina
		, tp.OBTPtipoCtaLiquidacion
	  from OBproyecto p
	  	inner join OBtipoProyecto tp
			on tp.OBTPid = p.OBTPid
	  	inner join PCECatalogo c
			on c.PCEcatid = p.PCEcatidObr
	 where p.OBPid = #session.obras.OBPid#
</cfquery>
<cfset LvarCuentaLiquidacion = rsOBP.OBTPtipoCtaLiquidacion GT 1>
<cfif rsOBP.OBTPtipoCtaLiquidacion EQ 0>
	<cfset LvarTipoCtaLiquidacion = "Cada Cuenta de la Obra">
<cfelseif rsOBP.OBTPtipoCtaLiquidacion EQ 1>
	<cfset LvarTipoCtaLiquidacion = "Cada Cuenta de la Obra con niveles sustituidos">
<cfelseif rsOBP.OBTPtipoCtaLiquidacion EQ 2>
	<cfset LvarTipoCtaLiquidacion = "Una única Cuenta de Liquidación">
<cfelseif rsOBP.OBTPtipoCtaLiquidacion EQ 3>
	<cfset LvarTipoCtaLiquidacion = "Una Cuenta de Liquidación por Activo">
<cfelseif rsOBP.OBTPtipoCtaLiquidacion EQ 99>
	<cfset LvarTipoCtaLiquidacion = "Liquidación Externa">
	<div  style="text-align:center;color:#FF0000;">
		<strong  style="text-align:center">Liquidación Externa, el sistema solo registra la Liquidación</strong>
	</div>
	<cfreturn>
</cfif>
<cfquery datasource="#session.dsn#" name="rsOBL">
	select a.OBOid
	     , a.OBOLid
	     , a.CFidActivo
	<cfif rsOBP.OBTPtipoCtaLiquidacion EQ 1>
	     , def.CFformatoLiquidacion
	<cfelse>
	     , a.CFformatoLiquidacion
	</cfif>
		 , '-1' as CcuentaLiquidacion
	     , a.CFcuentaActivo, 		'-1' as CcuentaActivo
	     , a.OBOLporcentaje
	     , a.OBOLmonto
		 , a.OBOLactivo
		 , a.GATid
	     , a.BMUsucodigo
	     , a.ts_rversion
		 , o.OBOtipoValorLiq
		 , o.OBOmontoLiq
		 , o.OBOLidDefault
		 , o.OBOcodigo, o.OBOdescripcion
		 , case when o.OBOLidDefault = a.OBOLid then 1 else 0 end as Ldefault
	  from OBobra o
	  	  left join OBobraLiquidacion a
			on a.OBOid = o.OBOid
		   and a.OBOLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOLid#" null="#Len(form.OBOLid) Is 0#">
	<cfif rsOBP.OBTPtipoCtaLiquidacion EQ 1>
	  	  left join OBobraLiquidacion def
			on def.OBOid  = o.OBOid
		   and def.OBOLid = o.OBOLidDefault
	</cfif>
	 where o.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
</cfquery>

<cfquery datasource="#session.dsn#" name="rsSQL">
	select count(1) as cantidad
	  from OBobraLiquidacion
	 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
</cfquery>
<cfset LvarPrimerDato = rsSQL.cantidad EQ 0>

<cfoutput>
<form name="form1" id="form1" method="post" action="OBobraLiquidacion_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Datos de Liquidación de la Obra
			</td>
		</tr>

		<tr>
			<td valign="top" nowrap>
				<strong>Proyecto</strong>
			</td>
			<td valign="top">
				<strong>#rsOBP.OBPcodigo# - #rsOBP.OBPdescripcion#</strong>
			</td>
		</tr>
		
		<tr>
			<td valign="top" nowrap>
				<strong>Obra</strong>
			</td>
			<td valign="top">
				<strong>#rsOBL.OBOcodigo# - #rsOBL.OBOdescripcion#</strong>
			</td>
		</tr>
		
		<tr>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td valign="top" nowrap>
				<cfif rsOBP.OBTPtipoCtaLiquidacion EQ 2>
					<strong>Cuenta Única de Liquidación&nbsp;<BR>(Igual para toda la Obra)</strong>
				<cfelse>
					<strong>Cuenta de Liquidación&nbsp;</strong>
				</cfif>
			</td>
			<td valign="top">
			<cfif LvarCuentaLiquidacion>
				<cf_cuentaObra name="CFformatoLiquidacion" OBOid="#form.OBOid#" value="#rsOBL.CFformatoLiquidacion#" onEnter="">
			<cfelse>
				<strong>#LvarTipoCtaLiquidacion#</strong>
				<input type="hidden" name="CFformatoLiquidacion" value="">
			</cfif>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Monto a Liquidar</strong>
			</td>
			<td valign="top" nowrap>
				<strong>#numberformat(rsOBL.OBOmontoLiq,",0.00")#</strong>
		<cfif rsOBL.OBOtipoValorLiq EQ "M">
			<cfquery name="rsOBOL_TOT" datasource="#session.dsn#">
				select 	coalesce(sum(OBOLmonto),0) as total
				  from OBobraLiquidacion
				 where OBOid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
			</cfquery>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>Total Asignado:&nbsp;&nbsp;</strong>
				<strong>#numberformat(rsOBOL_TOT.total,",0.00")#</strong>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>Diferencia:&nbsp;&nbsp;</strong>
				<font <cfif rsOBOL_TOT.total-rsOBL.OBOmontoLiq NEQ 0>color="##FF0000"</cfif>>
				<strong>#numberformat(rsOBOL_TOT.total-rsOBL.OBOmontoLiq,",0.00")#</strong>
				</font>
		</cfif>
			</td>
		</tr>

	</table>
	<cfinclude template="OBLactivo_form.cfm">

	<input type="hidden" name="Ecodigo" value="#session.Ecodigo#">
	<input type="hidden" name="OBOid" value="#form.OBOid#">
	<input type="hidden" name="OBOLid" value="#HTMLEditFormat(rsOBL.OBOLid)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsOBL.BMUsucodigo)#">
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsOBL.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">

</form>
</cfoutput>
<script language="javascript">
	function fnConCeros(LprmHilera, LprmLong)
	{
		LprmHilera = fnTrim(LprmHilera);
		var s = "";
		for (var i=0;i<LprmLong;i++) s=s+"0";
		return fnRight(s + LprmHilera, LprmLong);
	}		 

	function fnRight(LprmHilera, LprmLong)
	{
		var LvarTot = LprmHilera.length;
		return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
	}
	function fnLTrim(LvarHilera)
	{
		return LvarHilera.replace(/^\s+/,'');
	}
	function fnRTrim(LvarHilera)
	{
		return LvarHilera.replace(/\s+$/,'');
	}
	function fnTrim(LvarHilera)
	{
	   return fnRTrim(fnLTrim(LvarHilera));
	}
</script>
