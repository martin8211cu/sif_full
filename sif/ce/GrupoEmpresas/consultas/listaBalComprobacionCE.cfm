<cfinvoke key="LB_ListaMapeoCuentas" default="Lista Agrupadores de Cuentas" returnvariable="LB_ListaMapeoCuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="formEliminarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" xmlfile="formEliminarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlfile="formEliminarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="formEliminarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate" xmlfile="formGenerarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Enero" default="Enero" returnvariable="LB_Enero" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Febrero" default="Febrero" returnvariable="LB_Febrero" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Marzo" default="Marzo" returnvariable="LB_Marzo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Abril" default="Abril" returnvariable="LB_Abril" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Mayo" default="Mayo" returnvariable="LB_Mayo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Junio" default="Junio" returnvariable="LB_Junio" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Julio" default="Julio" returnvariable="LB_Julio" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Ogosto" default="Agosto" returnvariable="LB_Agosto" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Septiembre" default="Septiembre" returnvariable="LB_Septiembre" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Octube" default="Octubre" returnvariable="LB_Octubre" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Niviembre" default="Noviembre" returnvariable="LB_Noviembre" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Dicienbre" default="Diciembre" returnvariable="LB_Diciembre" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Preparado" default="Preparado" returnvariable="LB_Preparado" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Generado" default="Generado" returnvariable="LB_Generado" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Codigo" default="Codigo Mapeo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Version" default="Versión" returnvariable="LB_Version" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Estatus" default="Estatus" returnvariable="LB_Estatus" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>


<cfquery name="periodo" datasource="#Session.DSN#">
	select Speriodo from CGPeriodosProcesados group by Speriodo
</cfquery>

<cfset LvarAction   = 'SQLEliminarXMLCuentasCE.cfm'>
<cfset LvarFiltro   = ''>

<cfif isdefined("Form.filtro")>
	<cfset LvarFiltro   = '#Form.filtro#'>

</cfif>
<cfset array_Mapeo = ArrayNew(1)>

<cfif isdefined("form.CAgrupador") and len(form.CAgrupador) GT 0>
	<cfoutput>
		<cfset ArrayAppend(array_Mapeo, "#form.Id_Agrupador#")>
		<cfset ArrayAppend(array_Mapeo, "#form.CAgrupador#")>
		<cfset ArrayAppend(array_Mapeo, "#form.Descripcion#")>
	</cfoutput>
</cfif>

<cfif isdefined("form.delBal") and form.delBal NEQ "">
	<cfquery name="rsBal" datasource="#Session.DSN#">
		select CEBestatus from CEBalanzaSAT
			where Ecodigo = #Session.Ecodigo#
			and CEBalanzaId = #form.delBal#
	</cfquery>
	<cfif rsBal.CEBestatus GT 1>
		<cfquery name="updBal" datasource="#Session.DSN#">
			update CEBalanzaSAT set CEBestatus = CEBestatus - 1
				where Ecodigo = #Session.Ecodigo#
				and CEBalanzaId = #form.delBal#
		</cfquery>
	<cfelse>
		<cfquery name="delDetBal" datasource="#Session.DSN#">
			delete from  CEBalanzaDetSAT
				where Ecodigo = #Session.Ecodigo#
				and CEBalanzaId = #form.delBal#
		</cfquery>
		<cfquery name="delBal" datasource="#Session.DSN#">
			delete from  CEBalanzaSAT
				where Ecodigo = #Session.Ecodigo#
				and CEBalanzaId = #form.delBal#
		</cfquery>
	</cfif>
</cfif>


<cfoutput>
	<cfform action="BalComprobacionCE.cfm" method="post" name="filtroBal">
		<div style="background-color:rgb(232,232,232); width:100%">
			<br>
			<table  width="95%" align="center" cellpadding="0" cellspacing="2" border="0">
				<tr>
				    <td nowrap align="right"><strong>#LB_Periodo#:</strong>&nbsp;</td>
				    <td>
					    <select name="selectPeriodo" id="selectPeriodo">
						    <option value="0" <cfif not isdefined('form.Periodo')>selected</cfif>>Escoger uno</option>
						    <cfloop query="periodo">
							    <option value="#periodo.Speriodo#" <cfif isdefined('form.selectPeriodo')><cfif #form.selectPeriodo# eq #periodo.Speriodo#>selected</cfif></cfif> >#periodo.Speriodo#</option>
						    </cfloop>
					     </select>
					</td>
					<td nowrap align="right"><strong>#LB_Mes#:</strong>&nbsp;</td>
					<td>
						<select name="selectMes" id="selectMes">
							<option value="0" <cfif not isdefined('form.selectMes')>selected</cfif>>Escoger uno</option>
                            <option value="1" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '1'>selected</cfif></cfif>>#LB_Enero#</option>
                            <option value="2" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '2'>selected</cfif></cfif>>#LB_Febrero#</option>
						    <option value="3" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '3'>selected</cfif></cfif>>#LB_Marzo#</option>
                            <option value="4" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '4'>selected</cfif></cfif>>#LB_Abril#</option>
						    <option value="5" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '5'>selected</cfif></cfif>>#LB_Mayo#</option>
                            <option value="6" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '6'>selected</cfif></cfif>>#LB_Junio#</option>
						    <option value="7" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '7'>selected</cfif></cfif>>#LB_Julio#</option>
						    <option value="8" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '8'>selected</cfif></cfif>>#LB_Agosto#</option>
                            <option value="9" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '9'>selected</cfif></cfif>>#LB_Septiembre#</option>
						    <option value="10" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '10'>selected</cfif></cfif>>#LB_Octubre#</option>
                            <option value="11" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '11'>selected</cfif></cfif>>#LB_Noviembre#</option>
						    <option value="12" <cfif isdefined('form.selectMes')><cfif #form.selectMes# eq '12'>selected</cfif></cfif>>#LB_Diciembre#</option>
					    </select>
					</td>
					<td align="right"><input type="submit" value="filtrar" id="friltrar" name="friltrar" class="btnFiltrar" onclick="return funcFiltrar()"></td>
				</tr>

				<tr><td><br></td></tr>
			</table>

		</div>
		<table align="center" cellpadding="0" cellspacing="2" width="100%">
			<br>
			<cfset filtro2 = "CEBestatus in (1,2) and cb.Ecodigo = #Session.Ecodigo#">

			<cfif isdefined("form.selectPeriodo") and form.selectPeriodo GT 0>
				<cfset filtro2 = " #filtro2# and cb.CEBperiodo = #form.selectPeriodo#">
			</cfif>
			<cfif isdefined("form.selectMes") and form.selectMes GT 0>
				<cfset filtro2 = " #filtro2# and cb.CEBmes = #form.selectMes#">
			</cfif>

			<tr>
				<td colspan="3">
					<br>
					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CEBalanzaSAT cb
												inner join CEAgrupadorCuentasSAT ag
													on cb.CAgrupador = ag.CAgrupador
													and cb.GEid <> -1
												inner join CEMapeoGE mge
													on ag.CAgrupador = mge.Id_Agrupador
													and mge.Ecodigo = #Session.Ecodigo#
												left join (SELECT CEBperiodo,CEBmes, isnull(max(CEBTipo),0) CEBTipo, CETipoMoneda,1 as Ultimo
														   FROM CEBalanzaSAT
														   where GEid <> -1
														   group by CEBperiodo,CEBmes , CEBTipo,CETipoMoneda
												) balTipo
													on cb.CEBperiodo = balTipo.CEBperiodo
													and cb.CEBmes = balTipo.CEBmes
                                                    and cb.CETipoMoneda = balTipo.CETipoMoneda
													and isnull(cb.CEBTipo,0) = balTipo.CEBTipo"
						columnas  			= "CEBalanzaId, cb.CEBperiodo, cb.CEBmes, FechaGenera,cb.CAgrupador,Descripcion,
												case CEBestatus
													when 1 then 'Preparado'
													when 2 then 'Generado'
													else ''
												end Estatus,
												case isnull(cb.CEBTipo,0)
													when 0 then 'Normal'
													else 'Complementaria'
												end Tipo,
												case CEBestatus
													when 1 then '<img border=''0'' src=''/cfmx/sif/imagenes/Description.gif'' alt=''Mostrar Balanza'' style=''cursor: pointer;'' onclick=''funcMostrarBal('+ cast(CEBalanzaId as varchar) +');''>'
													when 2 then '<img border=''0'' src=''/cfmx/sif/imagenes/XML-01.png'' alt=''Descargar XML'' style=''cursor: pointer;'' onclick=''funcGenerarXml('+ cast(CEBalanzaId as varchar) +','+ cast(cb.CEBperiodo as varchar) +','+ cast(cb.CEBmes as varchar) +');''>'
													else ''
												end consulta,
                                                case cb.CETipoMoneda when 'L' then 'Local'
                                                				  when 'I' then 'Informe'
                                                end as CETipoMoneda ,
												case Ultimo
													when 1 then
														case CEBestatus
															when 1 then
																	case when cb.CEBperiodo * 100+cb.CEBmes = (select max(cb.CEBperiodo * 100+cb.CEBmes) as PeriodoMes
																								from CEBalanzaSAT cb
																								where CEBestatus in (1,2) and Ecodigo = #Session.Ecodigo#
																								and GEid is not null
                                                                                                and cb.CETipoMoneda = balTipo.CETipoMoneda)
																		then '<img border=''0'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' alt=''Eliminar'' style=''cursor: pointer;'' onclick=''funcBorrarBal('+ cast(CEBalanzaId as varchar) +');''>'
																		else ''
																	end
															when 2 then '<img border=''0'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' alt=''Eliminar'' style=''cursor: pointer;'' onclick=''funcBorrarBal('+ cast(CEBalanzaId as varchar) +');''>'
															else ''
														end
													else ''
												end delimg"
						desplegar			= "CEBperiodo, CEBmes, FechaGenera,CAgrupador,Descripcion,Estatus,Tipo,CETipoMoneda,consulta,delimg"
						etiquetas			= "Periodo,Mes, Fecha,Agrupador,Descripci&oacute;n,Estatus,Tipo,Tipo Moneda"
						formatos			= "S,S,D,S,S,S,S,S,S,S"
						filtro				= "#filtro2# order by cb.CEBperiodo desc, CEBmes desc,Tipo desc"
						align 				= "center,center,center,center,center,center,center,center,center,center"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "false"
						formname			= "filtro"
						navegacion			= ""
						mostrar_filtro		= "false"
						filtrar_automatico	= "false"
						showLink			= "false"
						showemptylistmsg	= "true"
						keys				= "CEBalanzaId"
						MaxRows				= "50"
						irA					= "SQLBalComprobacionCE.cfm"
						/>
				</td>
			</tr>
			<tr>

				<td>
		<input type="hidden" name="CAgrupadorC"  id="CAgrupadorC" value="">
		<input type="hidden" name="VersionC"  id="VersionC" value="">
		<input type="hidden" name="AnioC"  id="AnioC" value="">
		<input type="hidden" name="MesC"  id="MesC" value="">
		<input type="hidden" name="delBal"  id="delBal" value="">
		<input type="hidden" name="mostrarBal"  id="mostrarBal" value="">
		<input type="hidden" name="CEBalanzaIdC"  id="CEBalanzaIdC" value="">
		<input type="hidden" name="CEBperiodoC"  id="CEBperiodoC" value="">
		<input type="hidden" name="CEBmesC"  id="CEBmesC" value="">
				</td>
			</tr>
		</table>
	</cfform>


<script language="javascript" type="text/javascript">

	function funcFiltrar(){
		var res;
			 res = true;
		return res;

	}

	function funcBorrarBal(idBal){
		if(confirm('Deseas eliminar la Balanza de Comprobación?')){
			document.getElementById("delBal").value = idBal;
			document.filtroBal.action='BalComprobacionCE.cfm';
			document.filtroBal.submit();
		}

	}

	function funcMostrarBal(idBal){
		document.getElementById("mostrarBal").value = idBal;
		document.filtroBal.action= "SQLBalComprobacionCE.cfm";
		document.filtroBal.submit();
	}

	function funcGenerarXml(balanza,periodo,mes){

		document.getElementById("CEBalanzaIdC").value = balanza;
		document.getElementById("CEBperiodoC").value = periodo;
		document.getElementById("CEBmesC").value = mes;

		document.filtroBal.action='SQLGenerarXMLBalComprobacion.cfm';
		document.filtroBal.submit();

		document.filtroBal.nosubmit=true;
		document.filtroBal.action= "BalComprobacionCE.cfm";

	}

</script>

</cfoutput>