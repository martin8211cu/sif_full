<cfinvoke key="LB_ListaMapeoCuentas" default="Lista Agrupadores de Cuentas" returnvariable="LB_ListaMapeoCuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Mapeo" default="Mapeo" returnvariable="LB_Mapeo" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultarXMLCuentasCE.xml"/>
<cfinvoke key="LB_filtrar" default="Filtrar" returnvariable="LB_filtrar" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultarXMLCuentasCE.xml"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
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




<cf_dbfunction name="to_char" args="cex.Anio" returnvariable="Anio_char">
<cf_dbfunction name="to_char" args="cex.Mes" returnvariable="Mes_char">
<cf_dbfunction name="to_char" args="cea.CAgrupador" returnvariable="Agrupador_char">
<cf_dbfunction name="to_char" args="cex.Version" returnvariable="Version_char">
<cf_dbfunction name="concat" returnvariable="xmlico" args="<img border=''0'' src=''/cfmx/sif/imagenes/XML-01.png'' title=''Descargar XML'' onClick=javascript:funcGenerarXml('''+#Agrupador_char#+','+#Version_char#+','+#Mes_char#+','+#Anio_char#+''')>" delimiters="+">

<cf_dbfunction name="to_char" args="cex.Anio" returnvariable="Anio_char">
<cf_dbfunction name="to_char" args="cex.Mes" returnvariable="Mes_char">
<cf_dbfunction name="to_char" args="cea.CAgrupador" returnvariable="Agrupador_char">
<cf_dbfunction name="to_char" args="cex.Version" returnvariable="Version_char">
<cf_dbfunction name="concat" returnvariable="deleteico" args="<img border=''0'' src=''/cfmx/sif/imagenes/delete.small.png'' title=''Eliminar XML'' onClick=javascript:funcEliminarXml('''+#Agrupador_char#+','+#Version_char#+','+#Mes_char#+','+#Anio_char#+''')>" delimiters="+">



<cfquery name="periodo" datasource="#Session.DSN#">
	select Speriodo from CGPeriodosProcesados group by Speriodo order by Speriodo desc
</cfquery>

<cfset LvarAction   = 'SQLConsultarXMLCuentasCE.cfm'>
<cfset LvarXMLCuentas = 'SQLDescargarXMLCuentasCE.cfm'>
<cfset LvarEliminarXMLCuentas   = '../generacion/SQLEliminarXMLCuentasCE.cfm'>
<cfset varGEid = -1>
<cfif isdefined("varGE") and varGE EQ 1>
	<cfquery name="rsGEid" datasource="#Session.DSN#">
		SELECT  GEid FROM AnexoGEmpresaDet
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset varGEid = rsGEid.GEid>
	<cfset LvarAction   = '../../../ce/consultas/SQLConsultarXMLCuentasCE.cfm?GE=#varGEid#'>
	<cfset LvarXMLCuentas = '../../../ce/consultas/SQLDescargarXMLCuentasCE.cfm?GE=#varGEid#'>
	<cfset LvarEliminarXMLCuentas   = '../../../ce/generacion/SQLEliminarXMLCuentasCE.cfm?GE=#varGEid#'>
</cfif>

<cfset LvarFiltro   = ''>
<cfset irA   = 'SQLConsultarXMLCuentasDetCE.cfm'>
<cfif isdefined("Form.filtro")>
	<cfset LvarFiltro   = '#Form.filtro#'>

</cfif>

<cfset array_Mapeo = ArrayNew(1)>

<cfif isdefined("form.CAgrupadorCon") >
	<cfif not isdefined("form.modo")>
	<cfoutput>
		<cfset ArrayAppend(array_Mapeo, "#form.Id_Agrupador#")>
		<cfset ArrayAppend(array_Mapeo, "#form.CAgrupadorCon#")>
		<cfset ArrayAppend(array_Mapeo, "#form.Descripcion#")>
	</cfoutput>
	</cfif>
</cfif>

<cfoutput>
	<form action="#LvarAction#" method="post" name="form1" id="form1">
		<div style="background-color:rgb(232,232,232); width:100%">
			<br>
			<table align="center" cellpadding="0" cellspacing="2" border="0" >
				<tr>
					<td nowrap ><strong>#LB_Mapeo#:</strong>&nbsp;</td>
			    	<td align="right" colspan="3">
					<cfset varTable ="CEAgrupadorCuentasSAT a">
			    	<cfif isdefined("varGE") and varGE EQ 1>
						<cfset varTable ="CEAgrupadorCuentasSAT a
											inner join CEMapeoGE b
												on a.CAgrupador = b.Id_Agrupador
												and b.Ecodigo = #Session.Ecodigo#">
					</cfif>
					<cf_conlis
									Campos="Id_Agrupador, CAgrupadorCon = CAgrupador, Descripcion"
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
									Asignar="Id_Agrupador, CAgrupadorCon = CAgrupador, Descripcion"
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
				    <td align="right"><strong>#LB_Estatus#:</strong>&nbsp;</td>
				     <td align="right" style="width:106px">
						<select name="selectEstatus" id="selectMes">
							<option value="0" <cfif not isdefined('form.Estatus')>selected</cfif>>Escoger uno</option>
							<option value="Preparado" <cfif isdefined('form.Estatus')><cfif #form.Estatus# eq 'Preparado'>selected</cfif></cfif>>#LB_Preparado#</option>
							<option value="Generado" <cfif isdefined('form.Estatus')><cfif #form.Estatus# eq 'Generado'>selected</cfif></cfif>>#LB_Generado#</option>
						</select>
					</td>
			     </tr>
			     <tr valign="baseline">
				     <td nowrap align="right"><strong>#LB_Mes#:</strong>&nbsp;</td>
				     <td >
					     <select name="selectMes" id="selectMes">
						     <option value="0" <cfif not isdefined('form.MesS')>selected</cfif>>Escoger uno</option>
						     <option value="01" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '01'>selected</cfif></cfif>>#LB_Enero#</option>
                       		 <option value="02" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '02'>selected</cfif></cfif>>#LB_Febrero#</option>
							 <option value="03" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '03'>selected</cfif></cfif>>#LB_Marzo#</option>
                        	 <option value="04" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '04'>selected</cfif></cfif>>#LB_Abril#</option>
						     <option value="05" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '05'>selected</cfif></cfif>>#LB_Mayo#</option>
                             <option value="06" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '06'>selected</cfif></cfif>>#LB_Junio#</option>
					       	 <option value="07" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '07'>selected</cfif></cfif>>#LB_Julio#</option>
						     <option value="08" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '08'>selected</cfif></cfif>>#LB_Agosto#</option>
                             <option value="09" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '09'>selected</cfif></cfif>>#LB_Septiembre#</option>
						     <option value="10" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '10'>selected</cfif></cfif>>#LB_Octubre#</option>
                             <option value="11" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '11'>selected</cfif></cfif>>#LB_Noviembre#</option>
						     <option value="12" <cfif isdefined('form.MesS')><cfif #form.MesS# eq '12'>selected</cfif></cfif>>#LB_Diciembre#</option>
					     </select>
				     </td>
				     <td align="right" colspan="2">
					    <input type="submit" value="#LB_filtrar#" id="friltrar" name="friltrar" class="btnFiltrar" onclick="return funcFiltrar()">
				    </td>
			     </tr>
			     <cfif isdefined("varGE") and varGE EQ 1>
				     <input type="hidden" id="chkGE" name="chkGE" value="">
				</cfif>
				<cfif isdefined("varGE") and varGE EQ 1>
					<tr>
					     <td colspan="4" align="center">
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
				<td colspan="3">
					<br>
	<cfset fge = "not">
	<cfif isdefined("form.chkGE") or (isdefined("varGE") and varGE EQ 1) >
		<cfset fge = "">
	</cfif>
					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CEXMLEncabezadoCuentas cex INNER JOIN  CEAgrupadorCuentasSAT cea ON  cea.CAgrupador = cex.CAgrupador
						                       AND cea.Version = cex.Version #LvarFiltro# and cex.Ecodigo = #Session.Ecodigo#
						                       AND cex.GEid = #varGEid#"
						columnas  			= "cea.CAgrupador, cea.Descripcion , cex.Version, cex.Anio, cex.Mes, cex.Status,
											   case cex.Status
											   	when 'Generado' then '#xmlico#'
											   	else ''
											   end as icono,
						                       case  cea.Status
						                       	WHEN 'Activo' THEN
						                       		case ((cex.Anio*100) + (cex.Mes))
						                       			when ( select (max(Anio) * 100) + 
                                                        			  (select  max(Mes)as mes from CEXMLEncabezadoCuentas where CAgrupador = cea.CAgrupador 
                                                                        and Ecodigo = #Session.Ecodigo# AND GEid = #varGEid# and Anio in (select max(Anio)
                                                                        from CEXMLEncabezadoCuentas where Ecodigo = #Session.Ecodigo#)) 
                                                               from CEXMLEncabezadoCuentas where CAgrupador = cea.CAgrupador 
                                                               		and Ecodigo = #Session.Ecodigo# AND GEid = #varGEid# ) 
                                                    then '#deleteico#'
						                       			else ''
						                       		end
						                       ELSE ''
						                       END as iconoD"
						desplegar			= "CAgrupador, Descripcion, Version, Anio, Mes, Status, icono, iconoD"
						etiquetas			= "#LB_Codigo#, #LB_Descripcion#,#LB_Descripcion#, #LB_Periodo#, #LB_Mes#, #LB_Estatus#,,"
						formatos			= "S,S,S,S,S,S,U,U"
						filtro				= " 1=1 ORDER BY cea.CAgrupador, cex.Anio, cex.Mes"
						align 				= "Left, Left, Left, Left, Left, Left, Left, Left"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "false"
						formname			= "form1"
					    navegacion			= ""
						mostrar_filtro		= "false"
						filtrar_automatico	= "false"
						showLink			= "true"
						showemptylistmsg	= "true"
						keys				= "CAgrupador,Version,Mes,Anio"
						MaxRows				= "15"
						irA					= "#irA#"
						botones				= ""
						radios              = "N"
						/>
				</td>
			</tr>


		</table>
		<input type="hidden" name="CAgrupadorC"  id="CAgrupadorC" value="">
		<input type="hidden" name="VersionC"  id="VersionC" value="">
		<input type="hidden" name="AnioC"  id="AnioC" value="">
		<input type="hidden" name="MesC"  id="MesC" value="">
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">

	function funcFiltrar(){

		var res;
			 res = true;
		return res;

	}

	function funcGenerarXml(valores){

		valoresA = valores.split(",");
		document.getElementById("CAgrupadorC").value = valoresA[0];
		document.getElementById("VersionC").value = valoresA[1];
	    document.getElementById("MesC").value = valoresA[2];
		document.getElementById("AnioC").value = valoresA[3];

		document.form1.action='<cfoutput>#LvarXMLCuentas#</cfoutput>';
		document.form1.submit();

		document.form1.nosubmit=true;


	}

	function funcEliminarXml(valores){
		var res = false;
		res = confirm("Deseas eliminar el XML correspondiente a este registro.")

		if(res == true){
			valoresA = valores.split(",");
		    document.getElementById("CAgrupadorC").value = valoresA[0];
		    document.getElementById("VersionC").value = valoresA[1];
	        document.getElementById("MesC").value = valoresA[2];
		    document.getElementById("AnioC").value = valoresA[3];

		    document.form1.action='<cfoutput>#LvarEliminarXMLCuentas#</cfoutput>';
		    document.form1.submit();

		}

		document.form1.nosubmit=true;
		return false;


	}


</script>


