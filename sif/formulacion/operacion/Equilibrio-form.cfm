<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="GetEquilibrio" returnvariable="rsEquilibrio">
	<cfinvokeargument name="FPEEestado" value="#Status#">
	<cfinvokeargument name="CPPid" 		value="#form.CPPid#">
</cfinvoke>
<cfif rsEquilibrio.FPTVTipo neq -1>
	<cfset FPO = false>
	<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CreateQueryGeneral" returnvariable="query">
		<cfinvokeargument name="CPPid" 			value="#form.CPPid#">
	</cfinvoke>
<cfelse>
	<cfset FPO = true>
</cfif>
<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="GetTotales" returnvariable="Totales">
	<cfinvokeargument name="CPPid" 			value="#form.CPPid#">
	<cfinvokeargument name="FPO" 			value="#FPO#">
	<cfif not FPO>
		<cfinvokeargument name="query"		value="#query#">
	</cfif>
</cfinvoke>

<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="GetNiveles" returnvariable="NivelEquilibrio">
	<cfinvokeargument name="CPPid" 			value="#form.CPPid#">
	<cfinvokeargument name="FPO" 			value="#FPO#">
	<cfif not FPO>
		<cfinvokeargument name="query"		value="#query#">
	</cfif>
</cfinvoke>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<script language="javascript1.2" type="text/javascript">
	
	var classTemp = "";
	
	function fnOcultar(id,expresion,nivel){
		ing = document.getElementById("ing_"+id);
		eng = document.getElementById("eng_"+id);
		<cfif not FPO>
		ding = document.getElementById("ding_"+id);
		deng = document.getElementById("deng_"+id);
		</cfif>
		equ = document.getElementById("equ_"+id);
		
		ing.className = (ing.className != "novisible" ? "novisible" : "visible");
		eng.className = (eng.className != "novisible" ? "novisible" : "visible");
		<cfif not FPO>
		ding.className = (ding.className != "novisible" ? "novisible" : "visible");
		deng.className = (deng.className != "novisible" ? "novisible" : "visible");
		</cfif>
		equ.className = (equ.className != "novisible" ? "novisible" : "visible");
		
		tabla = document.getElementById("contenedorEquilibrio");
		x = tabla.getElementsByTagName('tr');
		for (var i=2;i<x.length;i++){
			if (x[i].id.toString().match(expresion)){
				x[i].style.display = (ing.className != "visible" ? "" : "none");
				if(nivel){
					x[i].style.display = (x[i].id.toString().match(/_cf$/) ? "none" : x[i].style.display);
					s = x[i].getElementsByTagName('span');
					for (var e=0;e<s.length;e++)
						s[e].className = "visible";
					t = x[i].getElementsByTagName('th');
					for (var f=0;f<t.length;f++)
						t[f].className = (t[f].className == "subtitulo arriba" ? "subtitulo abajo" : t[f].className);
				}
			}
		}
		tr = document.getElementById("encabezado_"+id);
		tr.className = (tr.className == "subtitulo abajo" ? "subtitulo arriba" : "subtitulo abajo")
	}
		
	var popup_win = false;

	function fnOpenPopUp(CPPid,PCDcatid,CFid,FPAEid){
		
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		var PARAM  = "Equilibrio-popUp.cfm?CPPid="+CPPid+"&PCDcatid="+PCDcatid+"&CFid="+CFid+"&FPAEid="+FPAEid;
		popup_win = open(PARAM,'EquilibrioFinanciero','left=150,top=150,scrollbars=yes,resizable=yes,width=850,height=500');
		return false;
	}
	
	function fnCambiarClass(e,obj){
		if(e == 'over'){
			classTemp = obj.className
			obj.className = classTemp + "ALT";
		}else if(e == 'out'){
			obj.className = classTemp;
		}
	}
	
	function fnCambiarExpansion(obj){
		if(obj.checked){
			tabla = document.getElementById("contenedorEquilibrio");
			x = tabla.getElementsByTagName('tr');
			for (var i=4;i<x.length - 3;i++){
				span = x[i].getElementsByTagName('span');
				for (var e=0;e<span.length;e++)
					span[e].className = "novisible";
				th = x[i].getElementsByTagName('th');
				for (var f=0;f<th.length;f++)
					th[f].className = "subtitulo arriba";
				x[i].style.display = "";
			}
		}else{
			tabla = document.getElementById("contenedorEquilibrio");
			tr = tabla.getElementsByTagName('tr');
			for (var i=4;i<tr.length - 3;i++){
				if(tr[i].className == 'clicact'){
					span = x[i].getElementsByTagName('span');
					for (var e=0;e<span.length;e++)
						span[e].className = "visible";
					th = x[i].getElementsByTagName('th');
					for (var f=0;f<th.length;f++)
						th[f].className = "subtitulo abajo";
				}else if(tr[i].className){
					tr[i].style.display = "none";
				}
			}
		}
	}
</script>
<cfoutput>
<style type="text/css">
	.StyleError {
		color: ##FF0000;
		font-style: italic;
	}
	
	.tabla {
		width: 1000px;
		padding: 0;
		margin: 0;
		border: 0;
	}
	
	th {
		font: bold 11px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
		color: ##4f6b72;
		border: 1px solid ##C1DAD7;
		letter-spacing: 2px;
		text-transform: uppercase;
		text-align: center;
		padding: 6px 6px 6px 12px;
	}
	
	.monto{
		text-align:right;
		font-weight:bold;
	}
	
	.subtotal{
		text-align:left;
		font-weight:bold;
	}
	
	.actmonto{
		background: ##F5FAFA;
	}
	
	.cfmonto{
		background:##E1F2FB;
	}
	
	.subtitulo{
		border: 0;
		font: bold 10px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
		text-align:left;
	}

	.abajo{
		background-image: url(/cfmx/sif/imagenes/abajo.gif);
		background-repeat:no-repeat;
	}

	.arriba{
		background-image: url(/cfmx/sif/imagenes/arriba.gif);
		background-repeat:no-repeat;
	}
	
	.clicact{
		cursor:pointer;
		background: ##F5FAFA;
	}
	
	.clicactALT{
		cursor:pointer;
		background:##EBB389;
	}
	
	.cliccf{
		cursor:pointer;
		background: ##E1F2FB;
	}
	
	.cliccfALT{
		cursor:pointer;
		background:##EBB389;
	}
	
	.visible{
		display:block;
	}
	.novisible{
		display:none;
	}
	
</style>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name='to_char' args='{fn year(d.CPPfechaDesde)}' returnvariable="CPPfechaDesde">
<cf_dbfunction name='to_char' args='{fn year(d.CPPfechaHasta)}' returnvariable="CPPfechaHasta">
<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select distinct a.CPPid as value,  case d.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
		#_Cat# ' de ' #_Cat# 
	 case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
		#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
		#_Cat# ' a ' #_Cat# 
	 case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
		#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
	 as description
	from FPEEstimacion a inner join CPresupuestoPeriodo d on a.Ecodigo = d.Ecodigo and a.CPPid  = d.CPPid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
</cfquery>
<table class="tabla" border="0" cellspacing="0" id="contenedorEquilibrio">
	<tr><td colspan="13" align="center"><cfoutput><strong>#rsPeriodo.description#</strong></cfoutput></td></tr>
	<tr><td colspan="13" align="center">&nbsp;</td></tr>
	<tr class="tituloListas">
		<th>Nivel De Equilibrio</th>
		<th>Centro Funcional</th>
		<th colspan="2">Actividad</th>
		<th colspan="2">Ingresos</th>
		<cfif not FPO><th colspan="2">Dif. Ingresos</th></cfif>
		<th colspan="2">Egresos</th>
		<cfif not FPO><th colspan="2">Dif. Egresos</th></cfif>
		<th>Equilibrio</th>
	</tr>
	<tr>
		<td><input type="checkbox" name="expandir" id="expandir" onclick="fnCambiarExpansion(this);">Expandir Todo</td>
		<td colspan="<cfif not FPO>12<cfelse>8</cfif>">&nbsp;</td>
	</tr>
	<!---Niveles del equilibrio Finaciero--->
	<cfoutput>
	<cfloop query="NivelEquilibrio">
		<tr class="clicact" onclick="fnOcultar(#NivelEquilibrio.PCDcatid#,/^#NivelEquilibrio.PCDcatid#/,1)" onmouseover="fnCambiarClass('over',this);" onmouseout="fnCambiarClass('out',this);">
			<th class="subtitulo arriba" colspan="3" id="encabezado_#PCDcatid#">&nbsp;#PCDdescripcion#</td>
			<td width="1px">&nbsp;</td>
			<td class="monto"><span class="novisible" id="ing_#NivelEquilibrio.PCDcatid#">#formatoMoneda(NivelEquilibrio.TotalIngresos)#</span></td>
			<cfif not FPO><td width="1px">&nbsp;</td>
			<td class="monto"><span class="novisible" id="ding_#NivelEquilibrio.PCDcatid#">#formatoMoneda(NivelEquilibrio.Dif_TotalIngresos)#</span></td></cfif>
			<td width="1px">&nbsp;</td>
			<td class="monto"><span class="novisible" id="eng_#NivelEquilibrio.PCDcatid#">#formatoMoneda(NivelEquilibrio.TotalEgresos)#</span></td>
			<cfif not FPO><td width="1px">&nbsp;</td>
			<td class="monto"><span class="novisible" id="deng_#NivelEquilibrio.PCDcatid#">#formatoMoneda(NivelEquilibrio.Dif_TotalEgresos)#</span></td></cfif>
			<td width="1px">&nbsp;</td>
			<td class="monto"><span class="novisible" id="equ_#NivelEquilibrio.PCDcatid#">#formatoMoneda(NivelEquilibrio.Equilibrio)#</span></td>
		</tr>
		<!---Centro Funcional--->
		<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="GetCentrosF" returnvariable="CentrosF">
			<cfinvokeargument name="CPPid" 			value="#form.CPPid#">
			<cfinvokeargument name="PCDcatid" 		value="#NivelEquilibrio.PCDcatid#">
			<cfinvokeargument name="FPO" 			value="#FPO#">
			<cfif not FPO>
				<cfinvokeargument name="query" 		value="#query#">
			</cfif>
		</cfinvoke>
		<cfloop query="CentrosF">
			<tr class="cliccf" onclick="fnOcultar('#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#',/^#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#/)" id="#NivelEquilibrio.PCDcatid#"  onmouseover="fnCambiarClass('over',this);" onmouseout="fnCambiarClass('out',this);">
				<td>&nbsp;</td>
				<th class="subtitulo arriba" colspan="2" id="encabezado_#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#">&nbsp;#CFdescripcion#&nbsp;<cfif CentrosF.FPEEestado eq 2><img src="/cfmx/sif/imagenes/CxP02_T.gif" width="16" height="16" title="Click para editar" alt="Click para Editar" onclick="fnEditar(#CentrosF.FPEEid#,1,'#CentrosF.FPTVTipo#');" style="cursor:pointer"/></cfif></td>
				<td width="1px">&nbsp;</td>
				<td class="monto"><span class="novisible" id="ing_#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#">#formatoMoneda(CentrosF.TotalIngresos)#</span></td>
				<cfif not FPO><td width="1px">&nbsp;</td>
				<td class="monto"><span class="novisible" id="ding_#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#">#formatoMoneda(CentrosF.Dif_TotalIngresos)#</span></td></cfif>
				<td width="1px">&nbsp;</td>
				<td class="monto"><span class="novisible" id="eng_#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#">#formatoMoneda(CentrosF.TotalEgresos)#</span></td>
				<cfif not FPO><td width="1px">&nbsp;</td>
				<td class="monto"><span class="novisible" id="deng_#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#">#formatoMoneda(CentrosF.Dif_TotalEgresos)#</span></td></cfif>
				<td width="1px">&nbsp;</td>
				<td class="monto"><span class="novisible" id="equ_#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#">#formatoMoneda(CentrosF.Equilibrio)#</span></td>
			</tr>
			<!---Actividades--->
			<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="GetActividad" returnvariable="Actividad">
				<cfinvokeargument name="CPPid" 			value="#form.CPPid#">
				<cfinvokeargument name="PCDcatid" 		value="#NivelEquilibrio.PCDcatid#">
				<cfinvokeargument name="CFid" 			value="#CentrosF.CFid#">
				<cfinvokeargument name="FPO" 			value="#FPO#">
				<cfif not FPO>
					<cfinvokeargument name="query" 		value="#query#">
				</cfif>
			</cfinvoke>
			<cfloop query="Actividad">
				<tr class="actividad" id="#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#_cf">
					<td colspan="2">&nbsp;</td>
					<td nowrap><cfif CentrosF.FPEEestado eq 2>&nbsp;<a style="cursor:pointer" onclick="javascript: fnOpenPopUp(#CPPid#,#NivelEquilibrio.PCDcatid#,#CentrosF.CFid#,#Actividad.FPAEid#);">- #Actividad.FPAEDescripcion#</a><cfelse>- #Actividad.FPAEDescripcion#</cfif></td>
					<td width="1px">&nbsp;</td>
					<td align="right">#formatoMoneda(Actividad.TotalIngresos)#</td>
					<cfif not FPO><td width="1px">&nbsp;</td>
					<td align="right">#formatoMoneda(Actividad.Dif_TotalIngresos)#</td></cfif>
					<td width="1px">&nbsp;</td>
					<td align="right">#formatoMoneda(Actividad.TotalEgresos)#</td>
					<cfif not FPO><td width="1px">&nbsp;</td>
					<td align="right">#formatoMoneda(Actividad.Dif_TotalEgresos)#</td></cfif>
					<td width="1px">&nbsp;</td>
					<td align="right">#formatoMoneda(Actividad.Equilibrio)#</td>
				</tr>
			</cfloop>
			<tr class="espacio" id="#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#_cf"><td colspan="<cfif not FPO>13<cfelse>9</cfif>">&nbsp;</td></tr>
			<!---Total para el centro Funcional--->
			<tr class="subtotal" id="#NivelEquilibrio.PCDcatid#_#CentrosF.CFid#_cf">
				<td>&nbsp;</td>
				<td class="cfmonto subtotal">Sub-Total</td>
				<td class="cfmonto">&nbsp;</td>
				<td width="1px">&nbsp;</td>
				<td class="monto">#formatoMoneda(CentrosF.TotalIngresos)#</td>
				<cfif not FPO><td width="1px">&nbsp;</td>
				<td class="monto">#formatoMoneda(CentrosF.Dif_TotalIngresos)#</td></cfif>
				<td width="1px">&nbsp;</td>
				<td class="monto">#formatoMoneda(CentrosF.TotalEgresos)#</td>
				<cfif not FPO><td width="1px">&nbsp;</td>
				<td class="monto">#formatoMoneda(CentrosF.Dif_TotalEgresos)#</td></cfif>
				<td width="1px">&nbsp;</td>
				<td class="monto">#formatoMoneda(CentrosF.Equilibrio)#</td>
			</tr>
			<tr class="espacio" id="#NivelEquilibrio.PCDcatid#"><td colspan="<cfif not FPO>13<cfelse>9</cfif>">&nbsp;</td></tr>
		</cfloop>
			<!---Total para el Nivel--->
			<tr class="monto actmonto" id="#PCDcatid#">
				<td colspan="3" align="left">Total</td>
				<td width="1px">&nbsp;</td>
				<td>#formatoMoneda(NivelEquilibrio.TotalIngresos)#</td>
				<cfif not FPO><td width="1px">&nbsp;</td>
				<td>#formatoMoneda(NivelEquilibrio.Dif_TotalIngresos)#</td></cfif>
				<td width="1px">&nbsp;</td>
				<td>#formatoMoneda(NivelEquilibrio.TotalEgresos)#</td>
				<cfif not FPO><td width="1px">&nbsp;</td>
				<td>#formatoMoneda(NivelEquilibrio.Dif_TotalEgresos)#</td></cfif>
				<td width="1px">&nbsp;</td>
				<td>#formatoMoneda(NivelEquilibrio.Equilibrio)#</td>
			</tr>
			<tr><td colspan="<cfif not FPO>13<cfelse>9</cfif>">&nbsp;</td></tr>
			<script language="javascript1.2" type="text/javascript">
				fnOcultar(#NivelEquilibrio.PCDcatid#,/^#NivelEquilibrio.PCDcatid#/,1);
			</script>
	</cfloop>
	</cfoutput>
	<tr class="monto actmonto">
		<td colspan="3" align="left">TOTALES GENERALES</td>
		<td width="1px">&nbsp;</td>
		<td>#formatoMoneda(Totales.TotalIngresos)#</td>
		<cfif not FPO><td width="1px">&nbsp;</td>
		<td>#formatoMoneda(Totales.Dif_TotalIngresos)#</td></cfif>
		<td width="1px">&nbsp;</td>
		<td>#formatoMoneda(Totales.TotalEgresos)#</td>
		<cfif not FPO><td width="1px">&nbsp;</td>
		<td>#formatoMoneda(Totales.Dif_TotalEgresos)#</td></cfif>
		<td width="1px">&nbsp;</td>
		<td>#formatoMoneda(Totales.Equilibrio)#</td>
	</tr>
	<tr><td colspan="<cfif not FPO>13<cfelse>9</cfif>">&nbsp;</td></tr>
		<tr><td colspan="<cfif not FPO>13<cfelse>9</cfif>" align="center">
		<cfset Desbalanceado = false>
		<cfloop query="NivelEquilibrio">
			<cfif NivelEquilibrio.Equilibrio NEQ 0>
				<cfset Desbalanceado = true>
				<cfbreak>
			</cfif>
		</cfloop>
			<cfif rsEquilibrio.EnPreparacion GT 0>
				<span class="StyleError"><img src="../../imagenes/deletestop.gif"/> No se puede enviar la estimación a aprobación Interna, ya que existen #rsEquilibrio.EnPreparacion# centros funcionales sin enviar su estimación, deben descartarse o finalizarse.</span>
			<cfelseif rsEquilibrio.EnAprobacion GT 0>
				<span class="StyleError"><img src="../../imagenes/deletestop.gif"/> No se puede enviar la estimación a aprobación Interna, ya que existen #rsEquilibrio.EnAprobacion# centros funcionales con su estimación en aprobación, deben descartarse o finalizarse.</span>
			<cfelseif Desbalanceado>
				<span class="StyleError"><img src="../../imagenes/deletestop.gif"/> No se puede enviar la estimación a aprobación Interna, ya que aun se encuentra des balanceada.</span>
			<cfelse>
				<form name="form1" action="Equilibrio-sql.cfm" method="post" onsubmit="return fnSubmitButon(this);">
					<input name="CPPid" 		value="#form.CPPid#" 	type="hidden" />
					<input name="CurrentPage" 	value="#CurrentPage#" 	type="hidden" />
					<input name="Estado" 		value="#Status#" 		type="hidden" />
					<cfif listfind('3,4',rsEquilibrio.FPEEestado)>
						<input name="RegresarE" 	value="Regresar a Equilibrio" type="submit" class="btnNormal" onclick="fnBotonSelecionado(this.name)"/>
					</cfif>
					<cfif rsEquilibrio.FPEEestado EQ 2>
						<input name="EnviarAprobarI" value="Enviar a Aprobación Interna" type="submit" class="btnNormal" onclick="fnBotonSelecionado(this.name)"/>
					<cfelseif rsEquilibrio.FPEEestado EQ 3>
						<input name="EnviarAprobarE" value="Enviar a Aprobación Externa" type="submit" class="btnNormal" onclick="fnBotonSelecionado(this.name)"/>
					<cfelseif rsEquilibrio.FPEEestado EQ 4 and (rsEquilibrio.FPTVTipo EQ -1 or rsEquilibrio.FPTVTipo eq 0)>
						<input name="generarFormulacion" value="Generar Formulación Presupuestal" type="submit" class="btnNormal" onclick="fnBotonSelecionado(this.name)"/>
					<cfelseif rsEquilibrio.FPEEestado EQ 4 and (rsEquilibrio.FPTVTipo eq 2 or rsEquilibrio.FPTVTipo eq 3)>
						<input name="generarVariacion" value="Generar Variación" type="submit" class="btnNormal" onclick="fnBotonSelecionado(this.name)"/>
					</cfif>
				</form>
			</cfif>
		</td>
		</tr>
</table>
<form name="formEdi" action="Equilibrio-sql.cfm" method="post">
	<input name="FPEEid" 		type="hidden" value="" />
	<input name="FPEPid" 		type="hidden" value="-1" />
	<input name="FPDElinea" 	type="hidden" value="-1" />
	<input name="tab" 			type="hidden" value="-1" />
	<input name="CurrentPage" 	type="hidden" value="" />
	<input name="Equilibrio" 	type="hidden" value="" />
</form>

<script language="javascript1.2" type="text/javascript">

	var boton = "";
	
	function fnBotonSelecionado(botonSel){
		boton = botonSel;
	}	
	
	function fnEditar(FPEEid,tab,tipo,FPEPid,FPDElinea){
		f = document.formEdi;
		if(tipo != '-1')
			f.CurrentPage.value ="VariacionPresupuestal-Admin.cfm";
		else
			f.CurrentPage.value ="EstimacionGI-Admin.cfm";
		f.FPEEid.value = FPEEid;
		f.FPEPid.value = (FPEPid ? FPEPid : -1);
		f.FPDElinea.value = (FPDElinea ? FPDElinea : -1);
		f.tab.value = (tab ? tab : -1);
		f.submit();
	}
	
	function fnSubmitButon(form){
		if(boton == 'RegresarE')
			msgconfirm = 'Esta seguro que desea regresar la Estimación de Fuentes de Financiamiento y Egresos en estado <cfif rsEquilibrio.FPEEestado EQ 3>Aprobación Interna<cfelseif rsEquilibrio.FPEEestado EQ 4>Aprobación Externa</cfif> al estado de Equilibrio';
		else if (boton == 'EnviarAprobarI')
			msgconfirm = 'Esta seguro que desea Enviar a Aprobación Interna la Estimación de Fuentes de Financiamiento y Egresos';
		else if (boton == 'EnviarAprobarE')
			msgconfirm = 'Esta seguro que desea Enviar a Aprobación Externa la Estimación de Fuentes de Financiamiento y Egresos';
		else
			msgconfirm = 'Esta seguro que desea generar la formulación con la Estimación de Fuentes de Financiamiento y Egresos';
		if(confirm(msgconfirm))
			return true;
		else
			return false;
	}
	fnCambiarExpansion(document.getElementById("expandir"));
	
</script>
</cfoutput>
<cffunction name="formatoMoneda"  access="public" returntype="string">
	<cfargument name="cantidad"   type="numeric" required="yes">
	<cfreturn numberFormat(Arguments.cantidad,',9.0000')>
</cffunction>
