<cfparam name="modo" default="ALTA">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="CONAVI - Parámetros">
<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Parámetros de Estimación">

<!-------->
<cfset LvarPeriodo = "">
<cfset LvarPeaje = "">
    <cfif isdefined('form.COEPeriodo') and isdefined('form.Pid') and len(trim(form.COEPeriodo)) and len(trim(form.Pid))>
		<cfset modo = "CAMBIO">
		<cfset LvarPeriodo = form.COEPeriodo>
		<cfset LvarPeaje = form.Pid>
	<cfelseif IsDefined('url.Periodo') and isdefined('url.Peaje') and len(trim(url.Periodo)) and len(trim(url.Peaje))>
	    <cfset LvarPeriodo = url.Periodo>
		<cfset LvarPeaje = url.Peaje>
	</cfif>


		<cfquery name="rsVehiculos" datasource="#session.dsn#">
		   Select 
			  pv.PVdescripcion,
			  pv.PVid
			from PVehiculos pv
			where Ecodigo = #session.ecodigo#
			 </cfquery>
		<cfquery name="rsPeajes" datasource="#session.dsn#">
		   Select 
			  pe.Pdescripcion,
			  pe.Pid
			from Peaje pe
			where Ecodigo = #session.ecodigo#
		</cfquery>	
		<cfif rsVehiculos.recordcount  eq 0>
         <cfoutput>
	        <script language="javascript1.2" type="text/javascript">	 
	           alert("No existen vehículos definidos, favor crearlos en el catálogo de vehículos");
	           window.parent.location='EstParametros.cfm';
	        </script>		 
	      </cfoutput>
		</cfif>  
		  
	 	<cfif rsPeajes.recordcount  eq 0>
         <cfoutput>
	        <script language="javascript1.2" type="text/javascript">	 
	           alert("No existen peajes definidos, favor crearlos en el catálogo de peajes");
	           window.parent.location='EstParametros.cfm';
	        </script>		 
	      </cfoutput>
		</cfif>	   
		  	
<!---'#LvarMiso4217#'--->

<cfif LvarPeriodo neq '' and  LvarPeaje neq ''>
<cfset modo= "CAMBIO">

<!----Si viene definido el periodo y el peaje---->
		<cfquery name="rsParametrosPeaje" datasource="#session.dsn#">
			  select 
			  co.COEid, 
			  co.Ecodigo,
			  co.COEPeriodo, 
			  pv.PVdescripcion,
			  pe.Pdescripcion,
			  co.Pid,
			  pv.PVid,
			  co.COEPorcVariacion,
			  co.COEPerInicial,
			  co.COEMesInicial,
			  co.COEPerFinal,
			  co.COEMesFinal
		   from PVehiculos pv
			  left outer join COEstimacionIng co
				on  pv.PVid = co.PVid
				and co.COEPeriodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarPeriodo#">
				and co.Pid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarPeaje#">
			  left outer join Peaje pe
			  on co.Pid =  pe.Pid
			  where pv.Ecodigo = #session.Ecodigo#
	  </cfquery>
	  
		<table width="100%" border="1" align="center">
		  <tr>
		   <td width="" align="center" ><strong>Año: <cfdump var="#LvarPeriodo#"> - Peaje <cfdump var="#rsParametrosPeaje.Pdescripcion#"></strong>
		   </td>
		 </tr>
		 </table>
			<table width="700" border="0" align="center" bordercolor="#999999">
			 <tr bgcolor="#999999">
				<td width="129"><div align="center"><strong>Tipo Vehículo</strong></div></td>
				<td width="92"><div align="center"><strong>Porcentaje</strong></div></td>
				<td width="128"><div align="center"><strong>Periodo Inicial</strong></div></td>
				<td width="98"><div align="center"><strong>Mes Inicial</strong></div></td>
				<td width="120"><div align="center"><strong>Periodo Final</strong></div></td>
				<td width="93"><div align="center"><strong>Mes Final</strong></div></td>
			  </tr>
			</table>
			<form action="EstParametrosSQL.cfm" method="post" name="form1">
			<input type="hidden" name="Periodo" value="<cfoutput>#LvarPeriodo#</cfoutput>" />
			<input type="hidden" name="Peaje" value="<cfoutput>#LvarPeaje#</cfoutput>" />
			<input type="hidden" name="descrip" value="<cfoutput>#rsParametrosPeaje.Pdescripcion#</cfoutput>"/>
			<input type="hidden" name="modo" value="CAMBIO" />
			<cfoutput query="rsParametrosPeaje">
			<table width="699" border="0" align="center">
			  <tr>
				<td width="129"><div align="center"><strong>
				 <!---<input type="hidden" name="Pvid" value="#rsVehiculos.PVid#"/>--->
				 <input type="hidden" name="Pvid" value="#rsParametrosPeaje.PVid#"/>
				  <cfdump var="#rsParametrosPeaje.PVdescripcion#">
				</strong></div></td>
				<td width="91"><div align="center">
				 <!--- <input name="Porc" type="text" value="#rsParametrosPeaje.COEPorcVariacion#" size="8" maxlength="3"/>--->
				  <cf_inputNumber name="Porc"  value="#rsParametrosPeaje.COEPorcVariacion#" enteros="3" decimales="4" negativos="false" comas="no">
				  %
				</div></td>
				<td width="128"> 
				<div align="center">
				 <!--- <input name="PerInicial" type="text" value="#rsParametrosPeaje.COEPerInicial#" size="8"/>--->
				  <select name="PerInicial"> 
					<option value="2007"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2007 > selected</cfif>>2007</option>
					<option value="2008"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2008 > selected</cfif>>2008</option>
					<option value="2009"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2009 > selected</cfif>>2009</option>
					<option value="2010"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2010 > selected</cfif>>2010</option>
					<option value="2011"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2011 > selected</cfif>>2011</option>
					<option value="2012"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2012 > selected</cfif>>2012</option>
					<option value="2013"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2013 > selected</cfif>>2013</option>
					<option value="2014"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2014 > selected</cfif>>2014</option>
					<option value="2015"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2015 > selected</cfif>>2015</option>
					<option value="2016"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2016 > selected</cfif>>2016</option>
					<option value="2017"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2017 > selected</cfif>>2017</option>
					<option value="2018"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2018 > selected</cfif>>2018</option>
					<option value="2019"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2019 > selected</cfif>>2019</option>
					<option value="2020"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2020 > selected</cfif>>2020</option>
					<option value="2021"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2021 > selected</cfif>>2021</option>
					<option value="2022"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2022 > selected</cfif>>2022</option>
					<option value="2023"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2023 > selected</cfif>>2023</option>
					<option value="2024"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2024 > selected</cfif>>2024</option>
					<option value="2025"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2025 > selected</cfif>>2025</option>
					<option value="2026"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2026 > selected</cfif>>2026</option>
					<option value="2027"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2027 > selected</cfif>>2027</option>
					<option value="2028"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2028 > selected</cfif>>2028</option>
					<option value="2029"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2029 > selected</cfif>>2029</option>
					<option value="2030"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerInicial EQ 2030 > selected</cfif>>2030</option>
					</select>
				   </div>
				</td>
				<td width="98"><div align="center">
				<select name="MesInicial"> 
					<option value="1" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 1> selected</cfif>>Enero</option>
					<option value="2" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 2> selected</cfif>>Febrero</option>
					<option value="3" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 3> selected</cfif>>Marzo</option>
					<option value="4" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 4> selected</cfif>>Abril</option>
					<option value="5" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 5> selected</cfif>>Mayo</option>
					<option value="6" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 6> selected</cfif>>Junio</option>
					<option value="7" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 7> selected</cfif>>Julio</option>
					<option value="8" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 8> selected</cfif>>Agosto</option>
					<option value="9" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 9> selected</cfif>>Setiembre</option>
					<option value="10" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 10> selected</cfif>>Octubre</option>
					<option value="11" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 11> selected</cfif>>Noviembre</option>
					<option value="12" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesInicial EQ 12> selected</cfif>>Diciembre</option>
				</select>
				</div></td>
				<td width="120"><div align="center">
				 <!--- <input name="PerFinal" type="text" value="#rsParametrosPeaje.COEPerFinal#" size="8"/>--->
				  <select name="PerFinal"> 
					<option value="2007"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2007 > selected</cfif>>2007</option>
					<option value="2008"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2008 > selected</cfif>>2008</option>
					<option value="2009"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2009 > selected</cfif>>2009</option>
					<option value="2010"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2010 > selected</cfif>>2010</option>
					<option value="2011"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2011 > selected</cfif>>2011</option>
					<option value="2012"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2012 > selected</cfif>>2012</option>
					<option value="2013"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2013 > selected</cfif>>2013</option>
					<option value="2014"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2014 > selected</cfif>>2014</option>
					<option value="2015"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2015 > selected</cfif>>2015</option>
					<option value="2016"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2016 > selected</cfif>>2016</option>
					<option value="2017"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2017 > selected</cfif>>2017</option>
					<option value="2018"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2018 > selected</cfif>>2018</option>
					<option value="2019"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2019 > selected</cfif>>2019</option>
					<option value="2020"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2020 > selected</cfif>>2020</option>
					<option value="2021"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2021 > selected</cfif>>2021</option>
					<option value="2022"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2022 > selected</cfif>>2022</option>
					<option value="2023"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2023 > selected</cfif>>2023</option>
					<option value="2024"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2024 > selected</cfif>>2024</option>
					<option value="2025"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2025 > selected</cfif>>2025</option>
					<option value="2026"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2026 > selected</cfif>>2026</option>
					<option value="2027"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2027 > selected</cfif>>2027</option>
					<option value="2028"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2028 > selected</cfif>>2028</option>
					<option value="2029"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2029 > selected</cfif>>2029</option>
					<option value="2030"<cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEPerFinal EQ 2030 > selected</cfif>>2030</option>
				</select>
				</div></td>
				<td width="93"><div align="center">
				<select name="MesFinal"> 
					<option value="1" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 1> selected</cfif>>Enero</option>
					<option value="2" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 2> selected</cfif>>Febrero</option>
					<option value="3" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 3> selected</cfif>>Marzo</option>
					<option value="4" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 4> selected</cfif>>Abril</option>
					<option value="5" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 5> selected</cfif>>Mayo</option>
					<option value="6" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 6> selected</cfif>>Junio</option>
					<option value="7" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 7> selected</cfif>>Julio</option>
					<option value="8" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 8> selected</cfif>>Agosto</option>
					<option value="9" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 9> selected</cfif>>Setiembre</option>
					<option value="10" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 10> selected</cfif>>Octubre</option>
					<option value="11" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 11> selected</cfif>>Noviembre</option>
					<option value="12" <cfif modo NEQ 'ALTA' and rsParametrosPeaje.COEMesFinal EQ 12> selected</cfif>>Diciembre</option>
				</select>
				</div></td>
			  </tr>
			</table>
			</cfoutput>
		  <cf_botones names="Cambio" values="Modificar" include= "Regresar"> 			
		</form>
	
<cfelse>
	<cfset modo= "ALTA">
			<form action="EstParametrosSQL.cfm" method="post" name="form2" onsubmit="return validarPeaje(this);">
			<table width="700" border="1" align="center">
			  <tr>
				 <input type="hidden" name="BMUsucodigo" value="#session.usucodigo#" />
				 <input type="hidden" name="modo" value="ALTA" />
			   <td width="" align="center" ><strong>Año: 
			   <select name="Periodo"> 
					<option value="2007">2007</option>
					<option value="2008">2008</option>
					<option value="2009">2009</option>
					<option value="2010">2010</option>
					<option value="2011">2011</option>
					<option value="2012">2012</option>
					<option value="2013">2013</option>
					<option value="2014">2014</option>
					<option value="2015">2015</option>
					<option value="2016">2016</option>
					<option value="2017">2017</option>
					<option value="2018">2018</option>
					<option value="2019">2019</option>
					<option value="2020">2020</option>
					<option value="2021">2021</option>
					<option value="2022">2022</option>
					<option value="2023">2023</option>
					<option value="2024">2024</option>
					<option value="2025">2025</option>
					<option value="2026">2026</option>
					<option value="2027">2027</option>
					<option value="2028">2028</option>
					<option value="2029">2029</option>
					<option value="2030">2030</option>
				</select> - Peaje 
				<select name="Peaje" id="Peaje">
				<option value="">Seleccione</option>
				  <cfoutput query="rsPeajes">
					<option value="#rsPeajes.Pid#">#rsPeajes.Pdescripcion#</option>
				</cfoutput>
				</select>
			   </td>
			 </tr>
			 </table>
			<table width="700" border="0" align="center" bordercolor="#999999">
			 <tr bgcolor="#999999">
				<td width="129"><div align="center"><strong>Tipo Vehículo</strong></div></td>
				<td width="92"><div align="center"><strong>Porcentaje</strong></div></td>
				<td width="128"><div align="center"><strong>Periodo Inicial</strong></div></td>
				<td width="98"><div align="center"><strong>Mes Inicial</strong></div></td>
				<td width="120"><div align="center"><strong>Periodo Final</strong></div></td>
				<td width="93"><div align="center"><strong>Mes Final</strong></div></td>
			  </tr>
			</table>
			<cfif rsVehiculos.recordcount gt 0>
			 <cfoutput query="rsVehiculos">
					<table width="699" border="0" align="center">
					  <tr>
						<td width="129"><div align="center"><strong>
						  <cfdump var="#rsVehiculos.PVdescripcion#">
						  <input type="hidden" name="Pvid" value="#rsVehiculos.PVid#"/>						   
						</strong></div></td>
						<td width="91"><div align="center">
						  <!---<cfinput type="text" name="Porc" id="Porc" value="0" required="yes" size="8" maxlength="4" validate="numeric" validateat="onblur">--->
						  <cf_inputNumber name="Porc"  value="0" enteros="3" decimales="4" negativos="false" comas="no">
						  %
						</div></td>
						<td width="128"><div align="center">
						<select name="PerInicial"> 
							<option value="2007">2007</option>
							<option value="2008">2008</option>
							<option value="2009">2009</option>
							<option value="2010">2010</option>
							<option value="2011">2011</option>
							<option value="2012">2012</option>
							<option value="2013">2013</option>
							<option value="2014">2014</option>
							<option value="2015">2015</option>
							<option value="2016">2016</option>
							<option value="2017">2017</option>
							<option value="2018">2018</option>
							<option value="2019">2019</option>
							<option value="2020">2020</option>
							<option value="2021">2021</option>
							<option value="2022">2022</option>
							<option value="2023">2023</option>
							<option value="2024">2024</option>
							<option value="2025">2025</option>
							<option value="2026">2026</option>
							<option value="2027">2027</option>
							<option value="2028">2028</option>
							<option value="2029">2029</option>
							<option value="2030">2030</option>
						</select>
						</div></td>
						<td width="98"><div align="center">
						<select name="MesInicial"> 
							<option value="1">Enero</option>
							<option value="2">Febrero</option>
							<option value="3">Marzo</option>
							<option value="4">Abril</option>
							<option value="5">Mayo</option>
							<option value="6">Junio</option>
							<option value="7">Julio</option>
							<option value="8">Agosto</option>
							<option value="9">Setiembre</option>
							<option value="10">Octubre</option>
							<option value="11">Noviembre</option>
							<option value="12">Diciembre</option>
						</select>
						</div></td>
						<td width="120"><div align="center">
						   <select name="PerFinal"> 
							<option value="2007">2007</option>
							<option value="2008">2008</option>
							<option value="2009">2009</option>
							<option value="2010">2010</option>
							<option value="2011">2011</option>
							<option value="2012">2012</option>
							<option value="2013">2013</option>
							<option value="2014">2014</option>
							<option value="2015">2015</option>
							<option value="2016">2016</option>
							<option value="2017">2017</option>
							<option value="2018">2018</option>
							<option value="2019">2019</option>
							<option value="2020">2020</option>
							<option value="2021">2021</option>
							<option value="2022">2022</option>
							<option value="2023">2023</option>
							<option value="2024">2024</option>
							<option value="2025">2025</option>
							<option value="2026">2026</option>
							<option value="2027">2027</option>
							<option value="2028">2028</option>
							<option value="2029">2029</option>
							<option value="2030">2030</option>
						</select>
						</div></td>
						<td width="93"><div align="center">
						<select name="MesFinal"> 
							<option value="1">Enero</option>
							<option value="2">Febrero</option>
							<option value="3">Marzo</option>
							<option value="4">Abril</option>
							<option value="5">Mayo</option>
							<option value="6">Junio</option>
							<option value="7">Julio</option>
							<option value="8">Agosto</option>
							<option value="9">Setiembre</option>
							<option value="10">Octubre</option>
							<option value="11">Noviembre</option>
							<option value="12">Diciembre</option>
						</select>
						</div></td>
					  </tr>
					</table>
				</cfoutput>
				<cf_botones modo="#modo#" include="Regresar" >		
			   
			  </cfif>
			  
		   </form>
	</cfif>	
<cfoutput>
<script language= "javascript1.2" type="text/javascript">
	 var GvarValidar = true;
	 function funcRegresar()
	 {
	 	GvarValidar = false;
	 }
	 
     function validarPeaje(inp)
	 {
		if(GvarValidar && document.getElementById("Peaje").value.length < 1)  
		{
			alert("Seleccione un Peaje");
			return false;	
		}
		return true;
	}
</script>
</cfoutput>	
<cf_web_portlet_end>
<cf_templatefooter>