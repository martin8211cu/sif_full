<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Enero" default="Enero" returnvariable="LB_Enero" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Febrero" default="Febrero" returnvariable="LB_Febrero" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Marzo" default="Marzo" returnvariable="LB_Marzo" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Abril" default="Abril" returnvariable="LB_Abril" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Mayo" default="Mayo" returnvariable="LB_Mayo" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Junio" default="Junio" returnvariable="LB_Junio" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Julio" default="Julio" returnvariable="LB_Julio" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Ogosto" default="Agosto" returnvariable="LB_Agosto" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Septiembre" default="Septiembre" returnvariable="LB_Septiembre" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Octube" default="Octubre" returnvariable="LB_Octubre" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Niviembre" default="Noviembre" returnvariable="LB_Noviembre" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>
<cfinvoke key="LB_Dicienbre" default="Diciembre" returnvariable="LB_Diciembre" component="sif.Componentes.Translate" method="Translate" xmlfile="listaBalGeneracionCE.xml"/>


<cfquery name="periodo" datasource="#Session.DSN#">
	select Speriodo from CGPeriodosProcesados group by Speriodo order by Speriodo desc
</cfquery>

<cfset LvarAction   = 'BalGeneracionCE.cfm'>
<cfif isdefined("varGE") and varGE EQ 1>
	<cfset LvarAction   = '../../../ce/GrupoEmpresas/generacion/BalGeneracionCE.cfm?GE=1'>
</cfif>
<cfoutput>
	<form action="#LvarAction#" method="post" name="filtroBal" id="filtroBal" enctype="multipart/form-data">
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
				<cfif isdefined("varGE") and varGE EQ 1>
					<input type="hidden" id="chkGE" name="chkGE" value="">
				</cfif>
				<cfif isdefined("varGE") and varGE EQ 1>
					<tr>
					     <td colspan="5" align="center">
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
				<tr><td><br></td></tr>
			</table>
		</div>
		<table align="center" cellpadding="0" cellspacing="2" width="100%">
			<br>
			<cfset filtro2 = "CEBestatus = 1 and cb.Ecodigo = #Session.Ecodigo#">

			<cfif isdefined("form.selectPeriodo") and form.selectPeriodo GT 0>
				<cfset filtro2 = " #filtro2# and CEBperiodo = #form.selectPeriodo#">
			</cfif>
			<cfif isdefined("form.selectMes") and form.selectMes GT 0>
				<cfset filtro2 = " #filtro2# and CEBmes = #form.selectMes#">
			</cfif>
<cfset fge = " and cb.GEid = -1">
<cfif isdefined("form.chkGE") or isdefined("varGE") and varGE EQ 1>
	<cfset fge = " and cb.GEid = (SELECT  GEid FROM AnexoGEmpresaDet where Ecodigo = #Session.Ecodigo#)">
</cfif>
			<tr>
				<td colspan="3">
					<br>
					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CEBalanzaSAT cb
												inner join CEAgrupadorCuentasSAT ag
													on cb.CAgrupador = ag.CAgrupador"
						columnas  			= "CEBalanzaId, CEBperiodo, CEBmes, FechaGenera,Descripcion,
												case isnull(CEBTipo,0)
													when 0 then 'Normal'
													else 'Complementaria'
												end Tipo"
						desplegar			= "CEBperiodo, CEBmes, FechaGenera,Descripcion,tipo"
						etiquetas			= "Periodo,Mes, Fecha,Agrupador,Tipo"
						formatos			= "S,S,D,S,S,S,S"
						filtro				= "#filtro2# #fge# order by CEBperiodo desc, CEBmes desc"
						align 				= "Left, Left, Left,Left,Left"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "true"
						formname			= "filtro"
						navegacion			= ""
						mostrar_filtro		= "false"
						filtrar_automatico	= "false"
						showLink			= "true"
						showemptylistmsg	= "true"
						keys				= "CEBalanzaId,CEBperiodo,CEBmes"
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

		<input type="hidden" name="CEBalanzaIdC"  id="CEBalanzaIdC" value="Generar">
		<input type="hidden" name="CEBperiodoC"  id="CEBperiodoC" value="">
		<input type="hidden" name="CEBmesC"  id="CEBmesC" value="">
		<input type="hidden" name="MesC"  id="MesC" value="">
		<input type="hidden" name="delBal"  id="delBal" value="">
		<input type="hidden" name="mostrarBal"  id="mostrarBal" value="">
	</form>

</cfoutput>

<script language="javascript" type="text/javascript">
	function funcRefrescar(){
		window.location.href="../generacion/BalGeneracionCE.cfm";
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
			document.getElementById("CEBalanzaIdC").value = valCA[0];
		    document.getElementById("CEBperiodoC").value = valCA[1];
	    	document.getElementById("CEBmesC").value = valCA[2];
	    	document.filtroBal.action='../consultas/SQLGenerarXMLBalComprobacion.cfm';
	    	document.getElementById('Generar_XML').style.display = 'none';
			document.getElementById('Refrescar_XML').style.display = '';
			var chk_Bal= document.getElementById('chk_Bal');
			if(chk_Bal){
				if(chk_Bal.checked){
			    	if(document.getElementById('psw_Bal').value != '' &&
					document.getElementById('key_Bal').value != '' &&
					document.getElementById('cer_Bal').value != '')
						res = true;
				}else{
		        	res = true;
		        }
			}else{
				res = true;
			}
		}else{
			alert('Seleccione una Balanza');
		}

		return res;

	}

</script>

