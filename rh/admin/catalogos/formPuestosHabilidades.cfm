<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Codigo" default="Codigo"  returnvariable="LB_CodigoJS" component="sif.Componentes.Translate"  method="Translate" />	
<cfinvoke key="LB_Descripcion" default="Descripcion"  returnvariable="LB_DescripcionJS" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_Peso" default="Peso"  returnvariable="LB_Peso" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_GrupoDeNiveles" default="Grupo de niveles"  returnvariable="LB_GrupoDeNiveles" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="MSG_LaSumaDeLosPesosDeLosComportamientosDebeSerCien" default="La suma de los pesos de los comportamientos debe ser cien" returnvariable="MSG_SumaPesos" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke Key="MSG_DeseaEliminarElDetalle" Default="Desea Eliminar el Detalle" returnvariable="MSG_DeseaEliminarElDetalle" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Modificar" Default="Modificar" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar"component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Limpiar" Default="Limpiar"returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_ElCodigoDeHabilidadYaExisteDefinaUnoDistinto" Default="El Código de Habilidad ya existe, defina uno distinto" returnvariable="MSG_ElCodigoDeHabilidadYaExisteDefinaUnoDistinto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Codigo" Default="Código" returnvariable="MSG_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_Descripcion" Default="Descripción" returnvariable="MSG_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_OrdenDelItem" Default="Orden del Item" returnvariable="MSG_OrdenDelItem"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DescripcionDeItem" Default="Descripción de Item" returnvariable="MSG_DescripcionDeItem" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ListaDeFactores" Default="Lista de Factores" returnvariable="MSG_ListaDeFactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeEncontraronFactores" Default="No se econtraron Factores" returnvariable="MSG_NoSeEncontraronFactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ListaDeSubfactores" Default="Lista de Subfactores" returnvariable="MSG_ListaDeSubfactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeEncontraronSubfactores" Default="No se econtraron subfactores" returnvariable="MSG_NoSeEncontraronSubfactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Factor" Default="Factor" returnvariable="MSG_Factor"component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
	<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="675" default="" returnvariable="UsaGrados"/>
<cfif len(trim(UsaGrados)) eq 0>
	<cfset UsaGrados = false>
</cfif>
<cfquery name="data" datasource="#session.DSN#">
	select b.PCnombre, b.PCid, b.PCcodigo
	from RHEvaluacionCuestionarios a
			inner join PortalCuestionario b
				on a.PCid = b.PCid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and PCtipo in (0,30) 	<!--- solo puede ver los tipos: cuestionario y test --->
</cfquery>

<cfquery name="data_bezinger" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=450
</cfquery>
<cf_dbfunction name="length" args="RHIHdescripcion" returnvariable="RHIHdescripcion_length">
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cf_dbfunction name="sPart" args="RHIHdescripcion,1,37" returnvariable="RHIHdescripcion_sPart">
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.dsn#">
		select upper(rtrim(RHHcodigo)) as RHHcodigo, RHHdescripcion, RHHdescdet, PCid,
		RHHubicacionB,ts_rversion,RHHFid,RHHSFid
		from RHHabilidades
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
	</cfquery>
	<cfquery name="rsDet" datasource="#session.dsn#"><!--- Lista de Items de la habilidad --->
		select RHIHid, RHHid, RHIHdescripcion, RHIHorden, 
		case 
		when <cf_dbfunction name="length"	args="RHIHdescripcion"> > 40
			then <cf_dbfunction name="sPart" args="RHIHdescripcion,1,37"> 
			#_CAT# '...'
			else RHIHdescripcion end RHIHdescripcionshort
		from RHIHabilidad
		where RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
		order by RHIHorden
	</cfquery>
	<cfquery name="rsMaxDet" dbtype="query">
		select max(RHIHorden)+1 as nextOrden from rsDet
	</cfquery>
	<cfset nextOrden = iif(len(trim(rsMaxDet.nextOrden)) gt 0,rsMaxDet.nextOrden, 1)>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select upper(rtrim(RHHcodigo)) as RHHcodigo
	from RHHabilidades
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	<cfif modo neq 'ALTA'>
	//carga el mantenimiento del detalle

	</cfif>
	//-->
</script>

<form name="form1" method="post" action="SQLPuestosHabilidades.cfm">
  <cfoutput>
	<table width="100%" border="0" cellspacing="2" cellpadding="0">
		<tr><td colspan="2">&nbsp;</td></tr>
    	<tr> 
      		<td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
			<td nowrap>
				<input name="RHHcodigo" type="text"  size="10" maxlength="5" tabindex="1"
				value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHHcodigo)#</cfif>"  
				onFocus="javascript:this.select();" style="text-transform:uppercase;">
			</td>
		</tr>
		
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td nowrap>
				<input name="RHHdescripcion" type="text" tabindex="1"
					value="<cfif modo neq 'ALTA'>#rsForm.RHHdescripcion#</cfif>" size="53" maxlength="100" onFocus="javascript:this.select();"></td>
		</tr>
		
		<tr style="display:<cfif NOT UsaGrados>none</cfif>">
			<td nowrap align="right"><cf_translate key="LB_Factor">Factor</cf_translate>:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA' and LEN(TRIM(rsform.RHHFid))>
					<cfquery name="rsFactor" datasource="#session.DSN#">
						select RHHFid,RHHFcodigo,RHHFdescripcion
						from RHHFactores
						where RHHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.RHHFid#">
					</cfquery>
					<cfset vArrayFactor=ArrayNew(1)>
					<cfset ArrayAppend(vArrayFactor,rsFactor.RHHFid)>
					<cfset ArrayAppend(vArrayFactor,rsFactor.RHHFcodigo)>
					<cfset ArrayAppend(vArrayFactor,rsFactor.RHHFdescripcion)>
				<cfelse><cfset vArrayFactor=ArrayNew(1)></cfif>
				<cf_conlis
					campos="RHHFid,RHHFcodigo,RHHFdescripcion"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,10,25"
					title="#MSG_ListaDeFactores#"
					tabla="RHHFactores"
					columnas="RHHFid,RHHFcodigo,RHHFdescripcion"
					desplegar="RHHFcodigo,RHHFdescripcion"
					filtrar_por="RHHFcodigo,RHHFdescripcion"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					asignar="RHHFid,RHHFcodigo,RHHFdescripcion"
					asignarformatos="S, S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- #MSG_NoSeEncontraronFactores# --"
					tabindex="1"
					valuesArray="#vArrayFactor#"
                    funcion="fnLimpiar()"
                    funcionValorEnBlanco="fnLimpiar()">
			</td>
		</tr>
		<tr style="display:<cfif NOT UsaGrados>none</cfif>">
			<td nowrap align="right"><cf_translate key="LB_Factor">Subfactor</cf_translate>:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA' and LEN(TRIM(rsForm.RHHFid)) and LEN(TRIM(rsForm.RHHSFid))>
					<cfquery name="rsSFactor" datasource="#session.DSN#">
						select RHHSFid,RHHSFcodigo,RHHSFdescripcion
						from RHHSubfactores
						where RHHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHHFid#">
						  and RHHSFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHHSFid#">
					</cfquery>
					<cfset vArraySFactor=ArrayNew(1)>
					<cfset ArrayAppend(vArraySFactor,rsSFactor.RHHSFid)>
					<cfset ArrayAppend(vArraySFactor,rsSFactor.RHHSFcodigo)>
					<cfset ArrayAppend(vArraySFactor,rsSFactor.RHHSFdescripcion)>
				<cfelse><cfset vArraySFactor=ArrayNew(1)></cfif>
				<cf_conlis
					campos="RHHSFid,RHHSFcodigo,RHHSFdescripcion"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,10,25"
					title="#MSG_ListaDeSubfactores#"
					tabla="RHHSubfactores"
					columnas="RHHSFid,RHHSFcodigo,RHHSFdescripcion"
					filtro="RHHFid = $RHHFid,numeric$"
					desplegar="RHHSFcodigo,RHHSFdescripcion"
					filtrar_por="RHHSFcodigo,RHHSFdescripcion"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					asignar="RHHSFid,RHHSFcodigo,RHHSFdescripcion"
					asignarformatos="S, S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- #MSG_NoSeEncontraronSubfactores# --"
					tabindex="1"
					valuesArray="#vArraySFactor#">
			</td>
		</tr>
		<tr>
		  	<td nowrap align="right"><cf_translate key="LB_DecripcionDetallada">Descripci&oacute;n Detallada</cf_translate>:&nbsp;</div></td>
		  	<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">
				<cfif modo EQ "CAMBIO">
					<cf_sifeditorhtml name="RHHdescdet" value="#Trim(rsForm.RHHdescdet)#" tabindex="1">
				<cfelse>
					<cf_sifeditorhtml name="RHHdescdet" tabindex="1">
				</cfif>
			</td>
	  	</tr>
		<tr>
	  		<td nowrap align="right"><cf_translate key="LB_CuestionarioPredeterminado">Cuestionario Predeterminado</cf_translate>:&nbsp;</td>
	  		<td>
				<select id="PCid" name="PCid" tabindex="1">
					<option value="" <cfif modo neq 'ALTA'>selected</cfif>>--- <cf_translate key="CMB_NoEspecificado" XmlFile="/rh/generales.xml">No especificado</cf_translate> ---</option>
					<cfloop query="data">
						<option value="#data.PCid#" <cfif isdefined("rsForm") and rsForm.PCid EQ data.PCid>selected</cfif>>#HTMLEditFormat(data.PCcodigo)#-#HTMLEditFormat(data.PCnombre)# </option>
					</cfloop>
				</select>
			</td>
		</tr>
		<cfif data_bezinger.Pvalor eq 1 >
			<tr align="center">
				<td align="right" nowrap><strong><cf_translate key="LB_UbicacionBenziger">Ubicaci&oacute;n Benziger</cf_translate>:&nbsp;</strong></div></td>
			  	<td align="left" >
					<select name="RHHubicacionB" tabindex="1">
						<option value="">--- <cf_translate key="CMB_NoEspecificado" XmlFile="/rh/generales.xml">No especificado</cf_translate> ---</option>
						<option value="BL" <cfif modo neq 'ALTA' and rsForm.RHHubicacionB eq 'BL' >selected</cfif>><cf_translate key="CMB_BasalIzquierdo">Basal Izquierdo</cf_translate></option>
						<option value="BR" <cfif modo neq 'ALTA' and rsForm.RHHubicacionB eq 'BR' >selected</cfif>><cf_translate key="CMB_BasalDerecho">Basal Derecho</cf_translate></option>
						<option value="FR" <cfif modo neq 'ALTA' and rsForm.RHHubicacionB eq 'FR' >selected</cfif>><cf_translate key="CMB_FrontalDerecho">Frontal Derecho</cf_translate></option>
						<option value="FL" <cfif modo neq 'ALTA' and rsForm.RHHubicacionB eq 'FL' >selected</cfif>><cf_translate key="CMB_FrontalIzquierdo">Frontal Izquierdo</cf_translate></option>
					</select>
			  	</td>
			</tr> 
		</cfif>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
			<cfset tabindex=1>
			<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
		</tr>
		<cfif modo neq 'ALTA'>
				<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2" align="center"><cfinclude template="itemsHabilidad.cfm"></td></tr>
		</cfif>
		
	<cfif modo neq 'ALTA'>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center"><cfinclude template="comportamientosHabilidad.cfm"></td>
		</tr>
	</cfif> 

	<tr><td colspan="2">&nbsp;</td></tr>

	<cfif modo NEQ 'ALTA'>
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<tr>
			<td>
				<input type="hidden" name="ts_rversion" value="#ts#">
				<input type="hidden" name="RHHid" value="#form.RHHid#">
			</td>
		</tr>
	</cfif>
  </table>  
  </cfoutput>
</form>
	
	
<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "FFFFCC";
	objForm = new qForm("form1");

	function _Field_CodigoNoExiste(){
		<cfoutput query="rsCodigos">
			if (("#ucase(trim(RHHcodigo))#"==this.obj.value.toUpperCase())
			<cfif modo neq "ALTA">
			&&("#ucase(trim(rsForm.RHHcodigo))#"!=this.obj.value.toUpperCase())
			</cfif>
			)
				this.error = "#MSG_ElCodigoDeHabilidadYaExisteDefinaUnoDistinto#.";
		</cfoutput>
	}	

	_addValidator("isCods", _Field_CodigoNoExiste);
<cfoutput>
	objForm.RHHcodigo.required = true;
	objForm.RHHcodigo.description="#MSG_Codigo#";
	objForm.RHHcodigo.validateCods();
	
	objForm.RHHdescripcion.required = true;
	objForm.RHHdescripcion.description="#MSG_Descripcion#";
	objForm.RHHFid.description="#MSG_Factor#";
	/*========================== Para los comportamientos =================================*/
	<cfif modo neq 'ALTA'>
		objForm.RHCOcodigo.description="#LB_CodigoJS#";
		objForm.RHCOdescripcion.description="#LB_DescripcionJS#";
		objForm.RHCOpeso.description="#LB_Peso#";
		objForm.RHGNid.description="#LB_GrupoDeNiveles#";
	</cfif>
	function deshabilitarValidacionComp(){
		objForm.RHCOcodigo.required = false;
		objForm.RHCOdescripcion.required = false;
		objForm.RHCOpeso.required = false;
		objForm.RHGNid.required = false;
	}
	
	function habilitarValidacionComp(){
		objForm.RHCOcodigo.required = true;
		objForm.RHCOdescripcion.required = true;
		objForm.RHCOpeso.required = true;
		objForm.RHGNid.required = true;				
	}
	/*=========================================================================*/
</cfoutput>	
	function deshabilitarValidacion(){
		objForm.RHHcodigo.required = false;
		objForm.RHHdescripcion.required = false;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
			deshabilitarValidacionComp();
		</cfif>
	}

	function habilitarValidacion(){	
		objForm.RHHcodigo.required = true;
		objForm.RHHdescripcion.required = true;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
			deshabilitarValidacionComp();
		</cfif>
	}
	
	<cfif modo neq 'ALTA'>
		//objForm.RHDCGcodigo.required = true;
<cfoutput>
		objForm.RHIHorden.description="#MSG_OrdenDelItem#";
		
		//objForm.RHDCGdescripcion.required = true;
		objForm.RHIHdescripcion.description="#MSG_DescripcionDeItem#";
</cfoutput>
		function deshabilitarValidacionDet(){
			objForm.RHIHorden.required = false;
			objForm.RHIHdescripcion.required = false;
		}
	
		function habilitarValidacionDet(){
			objForm.RHIHorden.required = true;
			objForm.RHIHdescripcion.required = true;
		}

		objForm.RHIHorden.obj.focus();
	<cfelse>
		objForm.RHHcodigo.obj.focus();
	</cfif>
	
	
	function fnLimpiar(){
		document.form1.RHHSFid.value = "";
		document.form1.RHHSFcodigo.value = "";
		document.form1.RHHSFdescripcion.value = "";

	}
</script>