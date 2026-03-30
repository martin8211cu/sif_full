<cfif modo EQ 'cambio'>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetActividad" returnvariable="Actividad">
		<cfinvokeargument name="FPAEid" 	 	 value="#form.FPAEid#">
	</cfinvoke>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#Actividad.ts_rversion#" returnvariable="ts"></cfinvoke>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetNivel" returnvariable="TotalLineas">
		<cfinvokeargument name="FPAEid" 	 	 value="#form.FPAEid#">
	</cfinvoke>
	<cfquery datasource="#session.dsn#" name="tieneEstimaciones">
		select count(1) as cantidad
		from FPDEstimacion a
		where FPAEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.FPAEid#">
	</cfquery>
	<cfquery datasource="#session.dsn#" name="tienePlan">
		select count(1) as cantidad
		from PCGDplanCompras
		where FPAEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.FPAEid#">
	</cfquery>
	<cfif tieneEstimaciones.cantidad gt 0 or tienePlan.cantidad gt 0>
		<cfset estaLigada = true>
	</cfif>
</cfif>
<cfif modoDet EQ 'cambio'>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetNivel" returnvariable="Nivel">
		<cfinvokeargument name="FPAEid" 	 	 value="#form.FPAEid#">
		<cfinvokeargument name="FPADNivel" 	 	 value="#form.FPADNivel#">
	</cfinvoke>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#Actividad.ts_rversion#" returnvariable="ts"></cfinvoke>
	<cfset QueryAddRow(PCEcatidvalue, 1)>
	<cfset QuerySetCell(PCEcatidvalue, "PCEcatid", 		"#Nivel.PCEcatid#", 1)>
	<cfset QuerySetCell(PCEcatidvalue, "PCEcodigo", 	"#Nivel.PCEcodigo#", 1)>
	<cfset QuerySetCell(PCEcatidvalue, "PCEdescripcion", "#Nivel.PCEdescripcion#", 1)>
</cfif>
<cfoutput>
	<form action="ActividadesEmpresa-sql.cfm" method="post" name="AE_Encabezado" onsubmit="return funcregresar();">
		<input type="hidden" name="FPAEid" 		value="#Actividad.FPAEid#" />
		<input type="hidden" name="ts_rversion" value="#ts#">
		<table border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td>Código:
				</td>
				<td><input name="FPAECodigo" type="text" value="#Actividad.FPAECodigo#"  size="50" maxlength="20" tabindex="1">
				</td>
			</tr>
			<tr>
				<td>Descripción:
				</td>
				<td><input name="FPAEDescripcion" type="text" value="#Actividad.FPAEDescripcion#"  size="50" maxlength="100" tabindex="1">
				</td>
			</tr>
			<tr>
				<td>Tipo:
				</td>
				<td>
					<select name="FPAETipo" <cfif estaLigada gt 0>disabled="disabled"</cfif>>
						<option value="G" <cfif #Actividad.FPAETipo# EQ 'G'> selected="selected"</cfif>>Egreso</option>
						<option value="I" <cfif #Actividad.FPAETipo# EQ 'I'> selected="selected"</cfif>>Ingreso</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2"><cf_botones modo='#MODO#' include="regresar"></td>
			</tr>
		</table>
	</form>
	<cf_qforms objForm="objForm2" form="AE_Encabezado">
		<cf_qformsRequiredField name="FPAECodigo" 	 	description="Codigo">
		<cf_qformsRequiredField name="FPAEDescripcion" 	description="Descripción">
	</cf_qforms>	
		<cfif modo EQ 'cambio'>
		<form action="ActividadesEmpresa-sql.cfm" method="post" name="AE_Detalle">
			<input type="hidden" name="FPAEid_key" 		value="#Actividad.FPAEid#" />
			<input type="hidden" name="FPADNivel_key" 	value="#Nivel.FPADNivel#" />
			<input type="hidden" name="ts_rversion" 	value="#ts#">
			<table border="0" cellspacing="1" cellpadding="1" width="100%">
				<tr><td colspan="2" class="tituloAlterno">Niveles</td></tr>
				<tr>
					<td valign="top">
							 <cfinvoke component="sif.Componentes.pListas" method="pLista"
								returnvariable	="Lvar_Lista"
								tabla			="FPActividadD"
								columnas		="FPAEid,FPADNivel,FPADDescripcion FPADDescripcion_lis,case FPADDepende 
																										when 'C' then 'Catálogo al Plan de Cuentas' 
																										when 'N' then 'Actividad del Nivel Anterior' 
																										else 'Desconocido' end as FPADDepende_lis "
								desplegar		="FPADNivel,FPADDescripcion_lis,FPADDepende_lis"
								etiquetas		="Nivel, Descripcion, Dependencia"
								formatos		="S,S,S"
								filtro			="FPAEid = #Actividad.FPAEid# order by FPADNivel"
								incluyeform		="false"
								align			="left,left,left"
								keys			="FPAEid,FPADNivel"
								maxrows			="25"
								showlink		="true"
								formname		="AE_Detalle"
								ira				="ActividadesEmpresa.cfm"/>		
					</td>
					<td>
						<table border="0" cellspacing="1" cellpadding="1">
							<tr>
								<td>Descripción:</td>
								<td><input name="FPADDescripcion"   type="text" value="#Nivel.FPADDescripcion#"  size="50" maxlength="100" tabindex="1">
							</tr>
							<tr>
								<td>Identificador de Nivel:</td>
								<td><input name="FPADIndetificador" type="text" value="#Nivel.FPADIndetificador#" size="50" maxlength="2" tabindex="1">
							</tr>
							<tr>
								<td>Dependencia:</td>
								<td><select name="FPADDepende" onChange="javascript: showChkbox(this.form);">
										<option value="C" <cfif #Nivel.FPADDepende# EQ 'C'> selected="selected"</cfif>>Depende de Catálogo Independiente al Plan de Cuentas</option>
										<option value="N" <cfif TotalLineas.recordCount EQ 0 or Nivel.FPADNivel EQ 1>disabled="disabled"</cfif> <cfif #Nivel.FPADDepende# EQ 'N'> selected="selected"</cfif>>Depende de la Actividad del Nivel Anterior</option>
									</select>
								</td>
							</tr>
							<tr id="tr_catalogo">
								<td>Catalogo al Plan de Cuentas:</td>
								<td><cf_sifcatalogos form="AE_Detalle" readonly="false" query="#PCEcatidvalue#">
							</tr>
							<tr id="tr_Equilibrio">
								<td>Aplica para el Equilibrio Financiero:</td>
								<td><input type="checkbox" name="FPADEquilibrio" value="1" <cfif Nivel.FPADEquilibrio EQ 1>checked="checked"</cfif>/></td>
							<tr>
								<td colspan="2"><cf_botones modo='#modoDet#' name="Agregar Nivel,Nuevo nivel" sufijo="Nivel"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		
	</form>
	<cf_qforms objForm="objForm3" form="AE_Detalle">
		<cf_qformsRequiredField name="FPADDescripcion" 	description="Descripción del Nivel">
	</cf_qforms>	
	</cfif>
</cfoutput>
<script language="JavaScript" type="text/javascript">
	<cfif modo EQ 'cambio'>
		function showChkbox(f)
		{
			var tr_catalogo   = document.getElementById("tr_catalogo");
			var tr_Equilibrio = document.getElementById("tr_Equilibrio");
			
			tr_catalogo.style.display = "";
			tr_Equilibrio.style.display = "";
			
			if (f.FPADDepende.value == 'N')
			{
					f.FPADEquilibrio.checked =false;
					tr_Equilibrio.style.display  = "none";
					tr_catalogo.style.display  = "none";
					objForm3.PCEcatid.required=false;
					objForm3.PCEcatid.description='Catalogo al Plan de Cuentas';					
			}
			else
			{
					objForm3.PCEcatid.required=true;
					objForm3.PCEcatid.description='Catalogo al Plan de Cuentas';
			}
		}
		showChkbox(document.AE_Detalle);
	</cfif>
	function funcregresar(){
		document.AE_Encabezado.FPAETipo.disabled="";
		objForm2.FPAECodigo.required=false;
		objForm2.FPAEDescripcion.required=false;
		return true;
	}
	
</script>