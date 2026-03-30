<cf_templateheader title="Reporte de Centros Funcionales">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte de Centros Funcionales">
<!---Querys--->
<cfif not isdefined("form.btnConsultar")>
		<!---Encuentra El perido del Auxiliar--->
		<cfquery name="rsPeriodo" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Pcodigo = 50
				and Mcodigo = 'GN'
		</cfquery>

		<cfset rsPeriodos = QueryNew("Pvalor")>
		<cfset temp = QueryAddRow(rsPeriodos,3)>
		<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-2,1)>
		<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,2)>
		<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor,3)>
		
		<!---Encuentra El mes del Auxiliar--->
		<cfquery name="rsMes" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Pcodigo = 60
			and Mcodigo = 'GN'
		</cfquery>
		<cfquery name="rsMeses" datasource="sifControl">
			select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
			from Idiomas a, VSidioma b 
			where a.Icodigo = '#Session.Idioma#'
			and b.VSgrupo = 1
			and a.Iid = b.Iid
			order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
		</cfquery>
		
		<!---Encuentra La Oficina--->
		<cfquery name="rsOficinas" datasource="#session.dsn#">
			select 
					Ocodigo,
					Oficodigo,
					Odescripcion 
			from  Oficinas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by Oficodigo
		</cfquery>
		
		<!---Encuentra el Departamento--->
		<cfquery name="rsDepartamento" datasource="#session.dsn#">
			select	
					Dcodigo,
					Deptocodigo,
					Ddescripcion
			from Departamentos
			where Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by Deptocodigo
		</cfquery>
</cfif>
<!---  AREA DE PINTADO  --->
<form action="CFReporteform.cfm" method="post" name="form1">
	<cfoutput>				  
		<table width="100%" border="0">
			<tr>
				<td align="left" nowrap="nowrap"><div align="right"><strong>Perido:</strong></div></td>
				<td>
					<!---Pinta El perido del Auxiliar--->
					<select name="Periodo" onChange="javascript:CambiarMes();" tabindex="1">
						<cfloop query="rsPeriodos">
							<option value="#Pvalor#">#Pvalor#</option>
						</cfloop>
					</select>
				</td>
				<td align="left" nowrap="nowrap"><div align="right"><strong>Mes:</strong></div></td>
				<td>
					<!---Pinta El mes del Auxiliar--->
					<select name="Mes" tabindex="1">
					</select>
				</td>
			</tr>
			<tr>
				<td align="left" nowrap="nowrap"><div align="right"><strong>Oficina inicial:</strong></div></td>
				<td>
					<!---Pinta La Oficina Inicial--->
					<select name="OficinaIni" tabindex="1">
						<cfloop query="rsOficinas">
							<option value="#Oficodigo#">#Oficodigo#-#Odescripcion#</option>
						</cfloop>
					</select>
				</td>
				<td><div align="right"><strong>Oficina Final:</strong></div></td>
				<td>
					<!---Pinta La Oficina Final--->
					<select name="OficinaFin" tabindex="1">
						<cfloop query="rsOficinas">
							<option value="#Oficodigo#">#Oficodigo#-#Odescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td><div align="right"><strong>Departamento inicial:</strong></div></td>
				<td>
					<!---Pinta Departamento Inicial--->
					<select name="DepaIni" tabindex="1">
						<cfloop query="rsDepartamento">
							<option value="#Deptocodigo#">#Deptocodigo#-#Ddescripcion#</option>
						</cfloop>
					</select>
				</td>
				<td><div align="right"><strong>Departamento Final:</strong></div></td>
				<td>
					<!---Pinta Departamento Final--->
					<select name="DepaFin" tabindex="1">
						<cfloop query="rsDepartamento">
							<option value="#Deptocodigo#">#Deptocodigo#-#Ddescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr> 
				<td align="left"><cf_translate key="LB_CentroResponsable">
				  <div align="right"><strong>Centro Resp.Inicial:</strong></div>
				</cf_translate>
				  <div align="right"></div></td>
				<td  valign="middle" nowrap>    
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_SeleccioneElCentroFuncionalResponsable"
						Default="Seleccione el Centro Funcional Responsable"
						returnvariable="MSG_SeleccioneElCentroFuncionalResponsable"/>
						<cf_rhcfuncional tabindex="1" form="form1" size="30" id="CFpkresp" name="CFcodigorespIni"
							titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1">
				</td>
				<td align="left"><cf_translate key="LB_CentroResponsable">
				  <div align="right"><strong>Centro Resp.Final:</strong></div>
				</cf_translate>
				  <div align="right"></div></td>
				<td  valign="middle" nowrap>    
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_SeleccioneElCentroFuncionalResponsable"
						Default="Seleccione el Centro Funcional Responsable"
						returnvariable="MSG_SeleccioneElCentroFuncionalResponsable"/>
						<cf_rhcfuncional tabindex="1" form="form1" size="30" id="CFpkresp" name="CFcodigorespFin" 
							titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1">
				</td>
			</tr>
			<tr>
				<td align="left" nowrap="nowrap" colspan="4">
					<input tabindex="1" type="checkbox" name="gast" />
					<strong>Cuenta de Gasto</strong>
					&nbsp;&nbsp;
					<input tabindex="1" type="checkbox" name="inven" />
					<strong>Cuenta Inventario</strong>
					<input tabindex="1" type="checkbox" name="inver" />
					<strong>Cuenta Inversión</strong>
					&nbsp;&nbsp;
					<input tabindex="1" type="checkbox" name="act" />
					<strong>Cuenta Activos</strong>
					&nbsp;&nbsp;
					<input tabindex="1" type="checkbox" name="ingr" />
					<strong>Cuenta Ingreso</strong>
					&nbsp;&nbsp;
					<input tabindex="1" type="checkbox" name="Otrosingr" />
					<strong>Cuenta Otros Ingresos</strong>
					&nbsp;&nbsp;
					<input tabindex="1" type="checkbox" name="Otrosgast" />
					<strong>Cuenta Otros Gastos</strong>
					
				</td>
			</tr>	
			<tr>
				<td align="center" valign="top" colspan="4">
					<cf_botones values="Consultar,Exportar,Limpiar"  tabindex="2">
				</td>
			</tr>
		</table>
	</cfoutput>
</form>
	<cf_web_portlet_end>
	<cf_templatefooter>
	
<script language="javascript" type="text/javascript">				
		function CambiarMes(){
			var oCombo = document.form1.Mes;
			var vPeriodo = document.form1.Periodo.value;
			var cont = 0;
			oCombo.length=0;
			<cfoutput query="rsMeses">
			if ( (#Trim(rsPeriodo.Pvalor)# > vPeriodo) || ((#Trim(rsPeriodo.Pvalor)# == vPeriodo) && (#Trim(rsMes.Pvalor)# >= #rsMeses.Pvalor#)) ){
				oCombo.length=cont+1;
				oCombo.options[cont].value='#Trim(rsMeses.Pvalor)#';
				oCombo.options[cont].text='#Trim(rsMeses.Pdescripcion)#';
				<cfif rsMeses.Pvalor eq rsMes.Pvalor>
				if (#Trim(rsPeriodo.Pvalor)# == vPeriodo)
					oCombo.options[cont].selected = true;
				</cfif>
			cont++;
			};
			</cfoutput>
		}
		CambiarMes();
</script>
<!--- Para que se utiliza este qform's--->


