<cfinvoke key="LB_ListaMapeoCuentas" default="Lista Agrupadores de Cuentas" returnvariable="LB_ListaMapeoCuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="formGenerarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" xmlfile="formGenerarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlfile="formGenerarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Mapeo" default="Mapeo" returnvariable="LB_Mapeo" component="sif.Componentes.Translate" method="Translate" xmlfile="formGenerarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="formGenerarXMLCuentasCE.xml"/>
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
<cfinvoke key="LB_Codigo" default="Codigo Mapeo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Version" default="Versión" returnvariable="LB_Version" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Estatus" default="Estatus" returnvariable="LB_Estatus" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>


<cfquery name="periodo" datasource="#Session.DSN#">
	select Speriodo from CGPeriodosProcesados group by Speriodo order by Speriodo desc
</cfquery>

<cfset LvarAction   = 'SQLGenerarXMLCuentasCE.cfm'>
<cfset irA   = 'SQLGenerarXMLCuentasCE.cfm'>
<cfset varGEid = -1>
<cfif isdefined("varGE") and varGE EQ 1>
	<cfquery name="rsGEid" datasource="#Session.DSN#">
		SELECT  GEid FROM AnexoGEmpresaDet
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset varGEid = rsGEid.GEid>
	<cfset LvarAction   = '../../../ce/generacion/SQLGenerarXMLCuentasCE.cfm?GE=#varGEid#'>
	<cfset irA   = '../../../ce/generacion/SQLGenerarXMLCuentasCE.cfm?GE=#varGEid#'>
</cfif>
<cfset LvarFiltro   = ''>

<cfif isdefined("Form.filtro")>
	<cfset LvarFiltro   = '#Form.filtro#'>

</cfif>
<cfset array_Mapeo = ArrayNew(1)>

<cfif isdefined("form.CAgrupador")>
	<cfoutput>
		<cfset ArrayAppend(array_Mapeo, "#form.Id_Agrupador#")>
		<cfset ArrayAppend(array_Mapeo, "#form.CAgrupador#")>
		<cfset ArrayAppend(array_Mapeo, "#form.Descripcion#")>
	</cfoutput>
</cfif>

<cfoutput>
	<cfform action="#LvarAction#" method="post" name="form1">
		<div style="background-color:rgb(232,232,232); width:100%">
			<br>
			<table align="center" cellpadding="0" cellspacing="2" >
				<tr>
					<td nowrap align="right"><strong>#LB_Mapeo#:</strong>&nbsp;</td>
			    	<td >
				    	<cfset varTable ="CEAgrupadorCuentasSAT a">
				    	<cfif isdefined("varGE") and varGE EQ 1>
							<cfset varTable ="CEAgrupadorCuentasSAT a
												inner join CEMapeoGE b
													on a.CAgrupador = b.Id_Agrupador
													and b.Ecodigo = #Session.Ecodigo#">
						</cfif>
					<cf_conlis
									Campos="Id_Agrupador, CAgrupador, Descripcion"
									Desplegables="N,S,S"
									Modificables="N,S,N"
									Size="0,10,65"
									tabindex="1"
									Title="#LB_ListaMapeocuentas#"
									Tabla="#varTable#"
									Columnas="a.Id_Agrupador, a.CAgrupador, a.Descripcion"
									Filtro= "Status = 'Activo'"
									Desplegar="CAgrupador, Descripcion"
									Etiquetas="#LB_Codigo#, #LB_Nombre#"
									filtrar_por="CAgrupador, Descripcion"
									Formatos="S,S"
									Align="left,left"
									form="form1"
									valuesarray = "#array_Mapeo#"
									Asignar="Id_Agrupador, CAgrupador, Descripcion"
									Asignarformatos="S,S,S"
									/>
				     </td>
				</tr>
				<tr valign="baseline">
					<td nowrap align="right"><strong>#LB_Periodo#:</strong>&nbsp;</td>
					<td >
						<select name="selectPeriodo" id="selectPeriodo">
							<option value="0" <cfif not isdefined('form.Periodo')>selected</cfif>>Escoger uno</option>
							<cfloop query="periodo">
								<option value="#periodo.Speriodo#" <cfif isdefined('form.Periodo')><cfif #form.Periodo# eq #periodo.Speriodo#>selected</cfif></cfif> >#periodo.Speriodo#</option>
						    </cfloop>
					    </select>
				    </td>
				    <td>
					    <input type="submit" value="filtrar" id="friltrar" name="friltrar" class="btnFiltrar" onclick="return funcFiltrar()">
				    </td>
			     </tr>
			     <tr valign="baseline">
				     <td nowrap align="right"><strong>#LB_Mes#:</strong>&nbsp;</td>
				     <td >
					     <select name="selectMes" id="selectMes">
						     <option value="0" <cfif not isdefined('form.Mes')>selected</cfif>>Escoger uno</option>
						     <option value="01" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '01'>selected</cfif></cfif>>#LB_Enero#</option>
                       		 <option value="02" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '02'>selected</cfif></cfif>>#LB_Febrero#</option>
							 <option value="03" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '03'>selected</cfif></cfif>>#LB_Marzo#</option>
                        	 <option value="04" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '04'>selected</cfif></cfif>>#LB_Abril#</option>
						     <option value="05" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '05'>selected</cfif></cfif>>#LB_Mayo#</option>
                             <option value="06" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '06'>selected</cfif></cfif>>#LB_Junio#</option>
					       	 <option value="07" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '07'>selected</cfif></cfif>>#LB_Julio#</option>
						     <option value="08" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '08'>selected</cfif></cfif>>#LB_Agosto#</option>
                             <option value="09" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '09'>selected</cfif></cfif>>#LB_Septiembre#</option>
						     <option value="10" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '10'>selected</cfif></cfif>>#LB_Octubre#</option>
                             <option value="11" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '11'>selected</cfif></cfif>>#LB_Noviembre#</option>
						     <option value="12" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '12'>selected</cfif></cfif>>#LB_Diciembre#</option>
					     </select>
				     </td>
			     </tr>
			    <cfif isdefined("varGE") and varGE EQ 1>
					<tr>
					     <td colspan="3" align="center">
							<cfquery name="rsGrupoEmpresa" datasource="#Session.DSN#">
								SELECT  a.GEnombre FROM AnexoGEmpresa a
								inner join AnexoGEmpresaDet b
									on a.GEid = b.GEid
								where b.Ecodigo = #Session.Ecodigo#
							</cfquery>
							<p style="font-size: 10px; text-align: center; font-weight:bold;">#rsGrupoEmpresa.GEnombre#</p>
						</td>
					</tr>
				</cfif>
			     <tr>
				     <td><br></td>
				</tr>

		  </table>
		</div>

		<table align="center" cellpadding="0" cellspacing="2" width="100%" >
			<br>
			<tr>
				<cfset fGE = "not">
				<cfif isdefined("varGE") and varGE EQ 1>
					<cfset fGE = "">
				</cfif>
				<td colspan="3">
					<br>
					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CEXMLEncabezadoCuentas cex INNER JOIN  CEAgrupadorCuentasSAT cea ON  cea.CAgrupador = cex.CAgrupador
						                       AND cea.Version = cex.Version AND cex.GEid = #varGEid# AND cex.Status='Preparado' #LvarFiltro# and cex.Ecodigo = #Session.Ecodigo#"
						columnas  			= "cea.CAgrupador, cea.Descripcion, cex.Version, cex.Anio, cex.Mes, cex.Status"
						desplegar			= "CAgrupador, Descripcion, Version, Anio, Mes, Status"
						etiquetas			= "#LB_Codigo#, #LB_Descripcion#,#LB_Version#, #LB_Periodo#, #LB_Mes#, #LB_Estatus#"
						formatos			= "S,S,S,S,S,S"
						filtro				= "1=1 order by cea.CAgrupador, cex.Version, cex.Anio, cex.Mes"
						align 				= "Left, Left, Left, Left, Left, Left"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "false"
						formname			= "form1"
					    navegacion			= ""
						mostrar_filtro		= "false"
						filtrar_automatico	= "true"
						showLink			= "true"
						showemptylistmsg	= "true"
						keys				= "CAgrupador,Version,Mes,Anio"
						MaxRows				= "15"
						irA					= ""
						radios              = "S"
						/>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="3" align="center" valign="middle">
					<cf_sifIncluirSelloDigital nombre="Bal">
					<input type="submit" name="Generar_XML" id="Generar_XML" value="Generar" class="btnGuardar" onClick="return funcGenerar_XML();">
					<input type="button" name="Refrescar_XML" id="Refrescar_XML" value="Refrescar" class="btnNormal" onClick="return funcRefrescar();" style="display:none">
				</td>
			</tr>

		</table>
		<input type="hidden" name="CAgrupadorC"  id="CAgrupadorC" value="">
		<input type="hidden" name="VersionC"  id="VersionC" value="">
		<input type="hidden" name="AnioC"  id="AnioC" value="">
		<input type="hidden" name="MesC"  id="MesC" value="">
		<input type="hidden" name="generar"  id="generar" value="">
	</cfform>
</cfoutput>

<script language="javascript" type="text/javascript">

	function funcFiltrar(){
		var res;
			 res = true;
		return res;

	}
	function funcRefrescar(){
		window.location.href="../generacion/GenerarXMLCuentasCE.cfm";
	}


	function funcGenerar_XML(){
		var res = false;
		var valC = 0;
		var valCA;

		for(a=0;a<document.getElementsByName("chk").length;a++){
				if(document.getElementsByName("chk")[a].checked){
					valC=document.getElementsByName("chk")[a].value;
			    }
		}

		if(valC != 0){
			valCA = valC.split("|");
			document.getElementById("CAgrupadorC").value = valCA[0];
		    document.getElementById("VersionC").value = valCA[1];
	    	document.getElementById("MesC").value = valCA[2];
		    document.getElementById("AnioC").value = valCA[3];
		    var valid = true
		    var vCHK_BAL = document.getElementById('chk_Bal');
		    if(vCHK_BAL){
			    if(vCHK_BAL.checked){
			    	if(document.getElementById('psw_Bal').value == '' ||
					document.getElementById('key_Bal').value == '' ||
					document.getElementById('cer_Bal').value == '')
						valid = false;
			    }
		    }
		    if(valid){
			    res = confirm("Deseas generar el XML correspondiente a este registro.");
			    if(res){
			    	document.getElementById("generar").value = "1";
			    	document.getElementById('Generar_XML').style.display = 'none';
			    	document.getElementById('Refrescar_XML').style.display = '';
			    }
		    }
		}else{
			alert('Seleccione un Mapeo');
		}

		return res;

	}


</script>


