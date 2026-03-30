<cf_navegacion name="nrp">
<cf_navegacion name="ano">
<cf_navegacion name="mes">
<cf_navegacion name="ofi" default="">
<cf_navegacion name="sec" default="">
<cf_navegacion name="filtro_CPformato" default="">
<cf_navegacion name="filtro_CPdescripcion" default="">
<cf_navegacion name="filtro_CPCPtipoControl" default="">
<cf_navegacion name="filtro_CPCPcalculoControl" default="">
<cf_navegacion name="filtro_Ocodigo" default="">
<cfif url.ofi NEQ "">
	<cf_navegacion name="filtro_Ocodigo" value="#url.ofi#">
</cfif>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfif isdefined("url.query")>
	<cfset LvarWin = "window.parent">
<cfelse>
	<cfset LvarWin = "window.opener">
</cfif>
<cfoutput>
<script language="javascript"> 
	function funcFiltrar(){
		var errores = "";
		if (errores.length) {
			alert('Se presentaron los siguientes errores:\n\n'+errores);
			return false;
		}
		document.lista.action="ConlisPopUp.cfm?c=8";
		return true;
	}
	function asignarCPcuenta(CPcuenta,CPformato,CPdescripcion,CPCPtipoControl,CPCPcalculoControl, CPCdisponible, Ocodigo, Oficodigo, Odescripcion)
	{
			if (#LvarWin#.document.formOri.CPcuenta)
					#LvarWin#.document.formOri.CPcuenta.value = rtrim(CPcuenta);
			if (#LvarWin#.document.formOri.CPformato)
					#LvarWin#.document.formOri.CPformato.value = rtrim(CPformato);
			if (#LvarWin#.document.formOri.CPdescripcion)
					#LvarWin#.document.formOri.CPdescripcion.value = rtrim(CPdescripcion);
			if (#LvarWin#.document.formOri.CPCPtipoControl)
			{
				CPCPtipoControl = rtrim(CPCPtipoControl);
				if (CPCPtipoControl == 0)
					#LvarWin#.document.formOri.CPCPtipoControl.value = "Abierto";
				else if (CPCPtipoControl == 1)
					#LvarWin#.document.formOri.CPCPtipoControl.value = "Restringido";
				else if (CPCPtipoControl == 2)
					#LvarWin#.document.formOri.CPCPtipoControl.value = "Restrictivo";
				else
					#LvarWin#.document.formOri.CPCPcalculoControl.value = "";
			}
			if (#LvarWin#.document.formOri.CPCPcalculoControl)
			{
				CPCPcalculoControl = rtrim(CPCPcalculoControl);
				if (CPCPcalculoControl == 1)
					#LvarWin#.document.formOri.CPCPcalculoControl.value = "Mensual";
				else if (CPCPcalculoControl == 2)
					#LvarWin#.document.formOri.CPCPcalculoControl.value = "Acumulado";
				else if (CPCPcalculoControl == 3)
					#LvarWin#.document.formOri.CPCPcalculoControl.value = "Total";
				else
					#LvarWin#.document.formOri.CPCPcalculoControl.value = "";
			}

			if (#LvarWin#.document.formOri.CPCdisponible)
					#LvarWin#.document.formOri.CPCdisponible.value = rtrim(fm(CPCdisponible,2));

			if (#LvarWin#.document.formOri.Ocodigo && Ocodigo != "")
			{
				if (#LvarWin#.document.formOri.Ocodigo)
						#LvarWin#.document.formOri.Ocodigo.value = rtrim(Ocodigo);
				if (#LvarWin#.document.formOri.Oficodigo)
						#LvarWin#.document.formOri.Oficodigo.value = rtrim(Oficodigo);
				if (#LvarWin#.document.formOri.Odescripcion)
						#LvarWin#.document.formOri.Odescripcion.value = rtrim(Odescripcion);
			}
			window.close(); 
	}
	
	function rtrim(sString) 
	{
		if (sString == "")
			return "";
		while (sString.substring(sString.length-1, sString.length) == ' ')
			sString = sString.substring(0,sString.length-1);
		return sString;
	}
</script>
</cfoutput>
<cfquery name="rsNRP" datasource="#Session.DSN#">
	select	CPPid
	from 	CPNRP a
	where	a.Ecodigo = #Session.Ecodigo# 
	  and 	a.CPNRPnum = #url.NRP#
</cfquery>

<cfinvoke	component			= "sif.Componentes.PRES_Presupuesto"
			method				= "fnTipoPresupuesto"
			returnVariable		= "LvarCPTCtipo"

			CPPid				= "#rsNRP.CPPid#"
			Ctipo				= "cm.Ctipo"
			CPresupuestoAlias	= "p"
			IncluirCOSTOS		= "false"
>
<cfquery name="rsLista" datasource="#session.dsn#">
	select 	Ocodigo, Oficodigo, Odescripcion, CPcuenta, CPformato, CPdescripcion, CPCPtipoControl, TipoControl, CPCPcalculoControl, CalculoControl,
			min(CPCdisponible) as CPCdisponible
	  from (
			select o.Ocodigo, o.Oficodigo, o.Odescripcion, p.CPcuenta, p.CPformato, p.CPdescripcion, 
					CPCPtipoControl,	case CPCPtipoControl 	when 0 then 'Abierto' when 1 then 'Restringido' when 2 then 'Restrictivo' end as TipoControl,
					CPCPcalculoControl, case CPCPcalculoControl when 1 then 'Mensual' when 2 then 'Acumulado' when 3 then 'Total' end as CalculoControl,
					coalesce(
						(select sum(
									CPCpresupuestado + CPCmodificado + CPCmodificacion_Excesos + CPCvariacion + CPCtrasladado + CPCtrasladadoE
									- CPCreservado_Anterior - CPCcomprometido_Anterior 
									- CPCreservado_Presupuesto
									- CPCreservado - CPCcomprometido
									- CPCejecutado - CPCejecutadoNC
									+ CPCnrpsPendientes)
						  from CPresupuestoControl d
						 where d.Ecodigo	= s.Ecodigo
						   and d.CPPid		= s.CPPid
						   and d.CPCanoMes	>= case cp.CPCPcalculoControl when 1 then s.CPCanoMes when 2 then 0				else 0		end
						   and d.CPCanoMes	<= case cp.CPCPcalculoControl when 1 then s.CPCanoMes when 2 then s.CPCanoMes	else 600001 end
						   and d.CPcuenta	= s.CPcuenta
						   and d.Ocodigo	= s.Ocodigo
					),0) 
					+
					coalesce(
						(select sum(CPNRPDsigno*CPNRPDmonto)
						   from CPNRPdetalle
						  where	Ecodigo		= #Session.Ecodigo# 
						    and CPNRPnum	= #url.NRP#
							and CPPid		= s.CPPid
							and CPCano		= s.CPCano
							and CPCmes		= s.CPCmes
							and CPcuenta	= s.CPcuenta
							and Ocodigo		= s.Ocodigo
					),0) 
					as CPCdisponible
			  from CPresupuestoControl s
				inner join CPresupuesto p 			on p.CPcuenta = s.CPcuenta
				inner join Oficinas o				on o.Ecodigo  = s.Ecodigo and o.Ocodigo = s.Ocodigo
				inner join CtasMayor cm				on cm.Ecodigo = p.Ecodigo and cm.Cmayor = p.Cmayor
				inner join CPCuentaPeriodo cp		on cp.Ecodigo = s.Ecodigo and cp.CPPid=s.CPPid and cp.CPcuenta = s.CPcuenta
			 where s.Ecodigo	= #Session.Ecodigo#
			   and s.CPPid		= #rsNRP.CPPid#
			   and s.CPCanoMes	>= #url.ano*100+url.mes#
			   and s.CPCanoMes	<= case cp.CPCPcalculoControl when 2 then 600001 else #url.ano*100+url.mes# end
			<cfif url.filtro_CPformato NEQ "">
			   and p.CPformato like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.filtro_CPformato#%">
			</cfif>
			<cfif url.filtro_CPdescripcion NEQ "">
			   and p.CPdescripcion like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.filtro_CPdescripcion#%">
			</cfif>
			<cfif url.filtro_Ocodigo NEQ "">
			   and s.Ocodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_Ocodigo#">
			</cfif>
			<cfif url.filtro_CPCPtipoControl NEQ "">
			   and CPCPtipoControl = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.filtro_CPCPtipoControl#">
			</cfif>
			<cfif url.filtro_CPCPcalculoControl NEQ "">
			   and CPCPcalculoControl = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.filtro_CPCPcalculoControl#">
			</cfif>

			   and #preserveSingleQuotes(LvarCPTCtipo)# = 'E' 
			   and CPCPtipoControl <> 0
			   and 	(
			   		select count(1)
					  from CPNRPtrasladoOri
					 where	Ecodigo = #Session.Ecodigo# 
					   and 	CPNRPnum = #url.NRP#
					   and	CPcuenta = s.CPcuenta
					   and  Ocodigo	 = s.Ocodigo
					<cfif url.sec NEQ "">
					   and  CPNRPTsecuencia	<> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.sec#">
					</cfif>
					) = 0
	  		) as tabla
	 group by Ocodigo, Oficodigo, Odescripcion, CPcuenta, CPformato, CPdescripcion, CPCPtipoControl, TipoControl, CPCPcalculoControl, CalculoControl
	having min(CPCdisponible) > 0								
	 order by CPformato, Oficodigo
</cfquery>

<cfoutput>
<cfif NOT isdefined("url.query")>
	<cf_templatecss>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="center" class="tituloAlterno">Lista de Cuentas de Presupuesto de Egresos con Fondos Disponibles<BR>para el <cfoutput>#url.ano#-#numberFormat(url.mes,"00")#</cfoutput></td>
		</tr>
	</table>
	<cfset LvarQUERY_STRING = replace(cgi.QUERY_STRING,"&ofi=#url.ofi#","")>
	<form name="formLista" method="post" action="conlis_CPcuenta_query.cfm?#LvarQUERY_STRING#" style="margin:0px;">
	<cfoutput>
	<input type="hidden" name="ano" value="#url.ano#" />
	<input type="hidden" name="mes" value="#url.mes#" />
	<input type="hidden" name="nrp" value="#url.nrp#" />
	</cfoutput>
	<table class="PlistaTable" align="center" border="0" cellspacing="0" cellpadding="0" width="100%"> 
		<tr>
			<td class="tituloListas" align="right" nowrap><strong>Cuenta:&nbsp;</strong></td>
			<td class="tituloListas" align="left" nowrap>
				<input 	type="text" size="50" maxlength="100" onfocus="this.select()" 
					name="filtro_CPformato" value="#form.filtro_CPformato#">
			</td>
			<td class="tituloListas" align="right" nowrap><strong>Descripcion:&nbsp;</strong></td>
			<td class="tituloListas" align="left" nowrap colspan="2">
				<input 	type="text" size="50" maxlength="100" onfocus="this.select()" 
					name="filtro_CPdescripcion" value="#form.filtro_CPdescripcion#">
			</td>
		</tr>
		<tr>
			<td class="tituloListas" align="right" nowrap><strong>Tipo Control:&nbsp;</strong></td>
			<td class="tituloListas" align="left" nowrap>
				<select name="filtro_CPCPtipoControl">
					<option value=""></option>
					<option value="0" disabled="disabled">0 = Abierto</option>
					<option value="1" <cfif form.filtro_CPCPtipoControl EQ 1>selected</cfif>>1 = Restringido</option>
					<option value="2" <cfif form.filtro_CPCPtipoControl EQ 2>selected</cfif>>2 = Restrictivo</option>
				</select>
			</td>
			<td class="tituloListas" align="right" nowrap><strong>Cálculo Control:&nbsp;</strong></td>
			<td class="tituloListas" align="left" nowrap>
				<select name="filtro_CPCPcalculoControl">
					<option value=""></option>
					<option value="1" <cfif form.filtro_CPCPcalculoControl EQ 1>selected</cfif>>1 = Mensual</option>
					<option value="2" <cfif form.filtro_CPCPcalculoControl EQ 2>selected</cfif>>2 = Acumulado</option>
					<option value="3" <cfif form.filtro_CPCPcalculoControl EQ 3>selected</cfif>>3 = Total</option>
				</select>
			</td>
			<td class="tituloListas" align="center" nowrap rowspan="2">
				<input type="submit" value="Filtrar" class="btnFiltrar">
			</td>
		</tr>
		<tr>
			<td class="tituloListas" align="right" nowrap><strong>Oficina:&nbsp;</strong></td>
			<td class="tituloListas" align="left" nowrap colspan="3">
				<input type="hidden" name="filtro_Ocodigo" value="" />
				<cf_conlis title="Lista de Oficinas"
					campos = "Ocodigo, Oficodigo, Odescripcion" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,10,60"
					tabla="Oficinas"
					columnas="Ocodigo, Oficodigo, Odescripcion"
					filtro="Ecodigo = #Session.Ecodigo# order by Oficodigo"
					desplegar="Oficodigo, Odescripcion"
					etiquetas="C&oacute;digo, Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					asignar="Ocodigo, Oficodigo, Odescripcion, filtro_Ocodigo=Ocodigo"
					asignarformatos="S,S,S,S"
					showEmptyListMsg="true"
					debug="false"
					tabindex="1"
					form="formLista"
					traerInicial	= "#form.filtro_Ocodigo NEQ ''#"
					traerFiltro		= "Ocodigo = #form.filtro_Ocodigo#"
				>
			</td>
		</tr>
		<tr><td colspan="10">
			<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="CPformato, CPdescripcion, TipoControl, CalculoControl, Oficodigo, CPCdisponible"/>
				<cfinvokeargument name="etiquetas" value="Cuenta, Descripcion, Tipo<BR>Control, Cálculo<BR>Control, Oficina, <font color='##00AA66'>Disponible<BR>a&nbsp;Trasladar</font>"/>
				<cfinvokeargument name="formatos" value="V,V,V,V,V,M"/>
				<cfinvokeargument name="align" value="left, left, left, left, left, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="formName" value="formLista"/>
				<cfinvokeargument name="includeForm" value="no"/>
				<cfinvokeargument name="MaxRows" value="28"/>
				<cfinvokeargument name="PageIndex" value="10"/>
				<cfinvokeargument name="showLink" value="true"/>
				<cfinvokeargument name="mostrar_filtro" value="false"/>
				<cfinvokeargument name="filtrar_automatico" value="false"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="funcion" value="asignarCPcuenta"/>
				<cfinvokeargument name="fparams" value="CPcuenta,CPformato,CPdescripcion,CPCPtipoControl,CPCPcalculoControl, CPCdisponible, Ocodigo, Oficodigo, Odescripcion"/>
			</cfinvoke>
		</td></tr>
		<tr><td colspan="10" style="border-top:solid 1px ##CCCCCC; color:'##00AA66'">
		(*) <strong>El Disponible a Trasladar corresponde sólo a Disponibles Positivos de Cuentas de Egreso Restringidas o Restrictivas, con los siguientes cálculos:</strong><BR>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Control Mensual:   Disponible Neto del Mes + Movimientos del Documento<BR>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Control Total:	   Disponible Neto del Periodo + Movimientos del Documento<BR>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Control Acumulado: El Menor entre los Disponibles Netos Acum.  + Movs.Doc de cada uno de los meses desde el Mes del doc. hasta el final de periodo
		</td></tr>
		</table>
	</form>
<cfelse>
	<script>
		<cfif rsLista.recordcount EQ 1>
			asignarCPcuenta("#rsLista.CPcuenta#","#rsLista.CPformato#","#rsLista.CPdescripcion#","#rsLista.CPCPtipoControl#","#rsLista.CPCPcalculoControl#","#rsLista.CPCdisponible#","#rsLista.Ocodigo#","#rsLista.Oficodigo#","#rsLista.Odescripcion#")
		<cfelseif rsLista.recordcount EQ 0>
			asignarCPcuenta("","","","","","","","","");
		<cfelse>
			asignarCPcuenta("#rsLista.CPcuenta#","#rsLista.CPformato#","#rsLista.CPdescripcion#","#rsLista.CPCPtipoControl#","#rsLista.CPCPcalculoControl#","","","","")
		</cfif>
	</script>
</cfif>
</cfoutput>
