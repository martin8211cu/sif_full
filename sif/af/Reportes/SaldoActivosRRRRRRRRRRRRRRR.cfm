<cfif isdefined("form.btnConsultar")>	
	<cfif isdefined("form.exportar")>
		<cfinclude template="SaldoActivosArc.cfm">
	<cfelse>
		<cfinclude template="SaldoActivosImp.cfm">
	</cfif>
	<cfabort>
</cfif>
<cfif isdefined("form.btnArchivos")>
	<cfinclude template="SaldoActivosArchivos.cfm">
	<cfabort>
</cfif>
<cfset fnObtieneDatos()>
<!---  AREA CONSULTAS  --->
<cf_templateheader title="Saldo de Activos">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start titulo="Saldo de Activos">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<!---  AREA DE PINTADO  --->
		<form action="SaldoActivos.cfm" method="post" name="form1">
			  <table width="100%" border="0">
				<tr>
				  <td  valign="top"width="34%"> 
					<cf_web_portlet_start border="true" titulo="Saldo de Activos" skin="info1">
					<div align="center">
					  <p align="justify">En &eacute;sta consulta se muestra la informaci&oacute;n del saldo de un activo. La consulta se puede realizar por varios criterios como lo son la placa, la categor&iacute;a, la clase , el segmento u oficina,periodo y mes </p>
					</div>
					<cf_web_portlet_end> </td>
				  <td width="1%">&nbsp;</td>
				  <td width="70%">
					<table width="100%" border="0">
					  <tr>
						<td width="20%"><div align="left"><strong>Placa:</strong></div></td>
						<td><cf_sifactivo placa="PLACA" tabindex="1" permitir_retirados=true></td>
						<td align="right">
							<input tabindex="1" type="checkbox" name="resumido" onclick="javascript:if (this.checked){alert('El reporte será resumido por categoría / clase.');}"  />
						</td>
						<td>
							<strong>Resumido</strong>
						</td> 
					  </tr>
					  <tr>
						<td><div align="left"><strong>Categor&iacute;a inicial:</strong></div></td>
						<td rowspan="2"> 
						<cf_sifcatclase 
								nameCat   = "Categoria1"
								nameClas  = "Clase1"
								keyCat    = "CategoriaIni"
								keyClas   = "ClaseIni"
								descCat   = "DEsCategoriaIni"
								descClas  = "DesClaseIni"
								frameCat =	"Cat1"
								frameClas = "Clas1"
								tabindexCat="1"
								tabindexClas="2"
							  >
						</td>
						<td><div align="left"><strong>Final</strong></div></td>
						
						<td rowspan="2">

						<cf_sifcatclase 
								nameCat   = "Categoria2"
								nameClas  = "Clase2"
								keyCat    = "CategoriaFin"
								keyClas   = "ClaseFin"
								descCat   = "DEsCategoriaFin"
								descClas  = "DesClaseFin"
								frameCat  =	"Cat2"
								frameClas = "Clas2"
								tabindexCat="1"
								tabindexClas="2"
							  > 
							</td>
					  </tr>
					  <tr>
						<td><div align="left"><strong>Clase inicial:</strong></div></td>
						<td><div align="left"><strong>Final</strong></div></td>
						<td>
						</td>
					  </tr>
                      <tr>
						<td><div align="left"><strong>Departamento Desde:</strong></div></td>
						<td>
						  <select name="DepartamentoDes" tabindex="2">
							<option value="" selected></option>
							<cfoutput query="rsDepartamentos">
							  <option value="#Deptocodigo#">#Deptocodigo#-#Ddescripcion#</option>
							</cfoutput>
						  </select>
						</td>
						<td><div align="left"><strong>Hasta</strong></div></td>
						<td>
						  <select name="DepartamentoHas" tabindex="2">
							<option value="" selected></option>
							<cfoutput query="rsDepartamentos">
							  <option value="#Deptocodigo#">#Deptocodigo#-#Ddescripcion#</option>
							</cfoutput>
						  </select>
						</td>
					  </tr>
					  <tr>
						<td><div align="left"><strong>Oficina inicial:</strong></div></td>
						<td>
						  <select name="OficinaIni" tabindex="2">
							<option value="" selected></option>
							<cfoutput query="rsOficinas">
							  <option value="#Oficodigo#">#Oficodigo#-#Odescripcion#</option>
							</cfoutput>
						  </select>
						</td>
						<td><div align="left"><strong>Final</strong></div></td>
						<td>
						  <select name="OficinaFin" tabindex="2">
							<option value="" selected></option>
							<cfoutput query="rsOficinas">
							  <option value="#Oficodigo#">#Oficodigo#-#Odescripcion#</option>
							</cfoutput>
						  </select>
						</td>
					  </tr>
					  <tr>
						<td><div align="left"><strong>Perido:</strong></div></td>
						<td>
						  <select name="Periodo" onChange="javascript:CambiarMes();" tabindex="2">
							<cfoutput query="rsPeriodo">
							  <option value="#Pvalor#">#Pvalor#</option>
							</cfoutput>
						  </select>
						</td>
						<td><div align="left"><strong>Mes:</strong></div></td>
						<td>
						  <select name="Mes" tabindex="2">
						  </select>
						</td>
					  </tr>

					  <tr>
						<td>&nbsp;</td>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="1%"><input tabindex="2" type="checkbox" name="exportar" id="exportar" value="ok" /></td>
									<td>Exportar a archivo plano</td>
								</tr>
							</table>
						</td>
					  </tr>
					  <tr>
						<td colspan="4" align="center">
							<cf_botones values="Consultar,Limpiar,Archivos"  tabindex="3">
						</td>
					  </tr>
				  </table></td>
				</tr>
			  </table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">				
	function fnLimpiar() {
		document.form1.Aid.value = '';
	}
	
	function funcConsultar() {
		if (document.form1.PLACA.value == "") {
			document.form1.Aid.value = '';
			document.form1.Adescripcion.value = '';							
			return true;
		} else {
			return true;
		}
	}
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
	document.form1.PLACA.focus();
</script>

<cffunction name="fnObtieneDatos" access="private" output="no">
		<cfquery name="rsPeriodo" datasource="#session.dsn#">
			select distinct Speriodo as Pvalor
            from CGPeriodosProcesados
            where Ecodigo = #session.Ecodigo#
            order by Pvalor desc
		</cfquery>
        
		<cfquery name="rsMes" datasource="#session.dsn#">
			select Pvalor as Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
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
		<cfquery name="rsOficinas" datasource="#session.dsn#">
			select Ocodigo,Oficodigo,Odescripcion 
			from  Oficinas
			where Ecodigo = #session.Ecodigo#
			order by Oficodigo
		</cfquery>
        <cfquery name="rsDepartamentos" datasource="#session.dsn#">
			select 
            	Dcodigo,
                Deptocodigo,
                Ddescripcion
			from  Departamentos
			where Ecodigo = #session.Ecodigo#
			order by Deptocodigo
		</cfquery>
</cffunction>
