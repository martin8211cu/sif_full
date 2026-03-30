<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar,TCcodigo) as TCcodigo
			 , TCnombre
			 , TCtexto
			 , TCtipoCalculo
			 , TCsql
			 , TCcomponente
			 , TCmetodo
			 , modulo
			 , TCmeses
			 , timestamp
		from TarifaCalculoIndicador
		where TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
	</cfquery>
</cfif>

<cfquery name="rsModulos" datasource="#session.DSN#">
	Select  modulo
		, nombre
	from Modulo
	where activo = 1
	order by orden
</cfquery>

<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<script language="JavaScript" src="../js/qForms/qforms.js">//</script>
<form action="TarifaCalculo_SQL.cfm" method="post" name="formTarifaCalculo">
	<cfoutput>
		<cfif modo NEQ 'ALTA'>
			<cfset ts = "">	
			<cfinvoke component="aspAdmin.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.timestamp#"/>
			</cfinvoke>
			<input type="hidden" name="timestamp" value="#ts#" size="32">		
			<input name="TCcodigo" type="hidden" value="#form.TCcodigo#">
		</cfif>
	
			
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr> 
        <td width="10%"></td>
        <td width="59%"></td>
        <td width="30%"></td>
        <td width="1%"></td>
      </tr>
      <tr> 
        <td colspan="4" align="center" class="tituloMantenimiento"> <cfif modo eq "ALTA">
            Nuevo Indicador 
            <cfelse>
            Modificar Indicador</cfif> </td>
      </tr>
      <tr> 
        <td colspan="2"><strong>Nombre Indicador</strong></td>
        <td><strong>M&oacute;dulo</strong></td>
        <td>&nbsp;</td>
      </tr>
      <tr> 
        <td colspan="2"> <input name="TCnombre" type="text" id="TCnombre3" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.TCnombre#</cfif>" size="60" maxlength="60"></td>
        <td><select name="modulo" id="select9">
            <option value=""></option>
            <cfloop query="rsModulos">
              <option value="#rsModulos.modulo#" <cfif modo NEQ 'ALTA' and rsForm.modulo EQ rsModulos.modulo> selected</cfif>>#rsModulos.modulo#</option>
            </cfloop>
          </select></td>
        <td>&nbsp;</td>
      </tr>
      <tr> 
        <td colspan="2"><strong>Explicaci&oacute;n</strong></td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr> 
        <td colspan="4"> <textarea name="TCtexto" cols="80" rows="4" id="textarea4" style="font-size: xx-small;font-family: Verdana, Arial, Helvetica, sans-serif;"><cfif modo neq 'ALTA'>#rsForm.TCtexto#</cfif></textarea></td>
      </tr>
      <tr> 
        <td nowrap><strong>Tipo C&aacute;lculo&nbsp;&nbsp;</strong></td>
        <td colspan="3" rowspan="2"> <table id="Etiq_1" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr> 
              <td colspan="2"><strong>Componente Java</strong></td>
            </tr>
            <tr> 
              <td colspan="2"><input name="TCcomponente" type="text" id="TCcomponente" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.TCcomponente#</cfif>" size="40" maxlength="40"></td>
            </tr>
            <tr> 
              <td valign="top"><strong>M&eacute;todo:&nbsp;</strong></td>
              <td>function BigDecimal metodo (BigDecimal Ecodigo, GregorianCalendar 
                Finicio, GregorianCalendar Ffinal) </td>
            </tr>
            <tr> 
              <td colspan="2"><input name="TCmetodo" type="text" id="TCmetodo" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.TCmetodo#</cfif>" size="40" maxlength="40"></td>
            </tr>
          </table>
          <table id="divSQL" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr> 
              <td valign="top"> <strong>SQL:&nbsp;&nbsp;</strong> </td>
              <td>debe retornar un &uacute;nico valor y puede utilizar en el filtro 
                @Ecodigo numeric, @Finicio datetime, @Final datetime</td>
            </tr>
            <tr> 
              <td colspan="2"><textarea name="TCsql" style="font-size: xx-small;font-family: Verdana, Arial, Helvetica, sans-serif;" cols="50" rows="4" id="textarea2"><cfif modo neq 'ALTA'>#rsForm.TCsql#</cfif></textarea></td>
            </tr>
          </table></td>
      </tr>
      <tr> 
        <td height="80" valign="top"><select name="TCtipoCalculo" id="select5" onChange="javascript: cambioTipo(this);">
            <option value="F" <cfif modo NEQ 'ALTA' and rsForm.TCtipoCalculo EQ 'F'> selected</cfif>>Fijo</option>
            <option value="S" <cfif modo NEQ 'ALTA' and rsForm.TCtipoCalculo EQ 'S'> selected</cfif>>SQL</option>
            <option value="J" <cfif modo NEQ 'ALTA' and rsForm.TCtipoCalculo EQ 'J'> selected</cfif>>Java</option>
          </select></td>
      </tr>
      <tr> 
        <td colspan="2"><strong>Periodicidad de Pago Default</strong></td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr> 
        <td colspan="2"><select name="TCmeses">
            <option value="1"<cfif modo NEQ "ALTA" AND rsForm.TCmeses EQ "1"> selected</cfif>>Mes 
            vencido</option>
            <option value="12"<cfif modo NEQ "ALTA" AND rsForm.TCmeses EQ "12"> selected</cfif>>Año 
            vencido</option>
            <option value="0"<cfif modo NEQ "ALTA" AND rsForm.TCmeses EQ "0"> selected</cfif>>Pago 
            inicial</option>
            <option value="2"<cfif modo NEQ "ALTA" AND rsForm.TCmeses EQ "2"> selected</cfif>>Bimestre 
            vencido</option>
            <option value="3"<cfif modo NEQ "ALTA" AND rsForm.TCmeses EQ "3"> selected</cfif>>Trimestre 
            vencido</option>
            <option value="4"<cfif modo NEQ "ALTA" AND rsForm.TCmeses EQ "4"> selected</cfif>>Cuatrimestre 
            vencido</option>
            <option value="6"<cfif modo NEQ "ALTA" AND rsForm.TCmeses EQ "6"> selected</cfif>>Semestre 
            vencido</option>
          </select></td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td>&nbsp; </td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr> 
        <td colspan="4" align="center"> <cfset mensajeDelete = "¿Desea Eliminar el Indicador Tarifario ?"> 
          <cfinclude template="../portlets/pBotones.cfm"> </td>
      </tr>
    </table>
	</cfoutput>	  
</form>	  

<cfif modo NEQ 'ALTA'>
	<table width="95%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>
			<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Rangos Defaults de Tarifa">		
				<table width="100%" border="0" cellspacing="0" cellpadding="0">	
				  <tr>
					<td valign="top">	
 						<cfinvoke component="aspAdmin.Componentes.pListasASP" 
								  method="pLista" 
								  returnvariable="pListaFormaPagoDatos">
							<cfinvokeargument name="tabla" value="TarifaRangosDefaults t"/>
							<cfinvokeargument name="columnas" value="
									convert(varchar,TCcodigo) as TCcodigo
									,case convert(varchar,TRDhasta) 
										when '999999999999999' then '<script language=''JavaScript''>if (document.Ultimo) { document.Anterior = document.Ultimo; document.write(''> '' + document.Ultimo); } else document.write(''Tarifa''); 0</script>'
										else convert(varchar,TRDhasta)+'<script language=''JavaScript''>if (document.Ultimo) document.Anterior = document.Ultimo; document.Ultimo='+convert(varchar,TRDhasta)+'</script>'
									end as TRDhastaDespl
									, convert(varchar,TRDhasta) as TRDhasta
									, TRDhasta as TRDhastaOrder
									, convert(varchar,TRDtarifaFija) as TRDtarifaFija
									, convert(varchar,TRDtarifaVariable) as TRDtarifaVariable"/>
							<cfinvokeargument name="desplegar" value="TRDhastaDespl, TRDtarifaFija,TRDtarifaVariable"/>
							<cfinvokeargument name="etiquetas" value="Hasta,Fija, Variable"/>
							<cfinvokeargument name="formatos"  value=""/>
							<cfinvokeargument name="filtro" value=" TCcodigo= #form.TCcodigo# order by TRDhastaOrder"/>
							<cfinvokeargument name="align" value="right,right,right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="keys" value="TCcodigo,TRDhasta"/>
							<cfinvokeargument name="irA" value="TarifaCalculo.cfm"/>
							<cfinvokeargument name="formName" value="form_listaRangosDefaults"/>
						</cfinvoke>
					</td>
					<td valign="top">&nbsp;</td>
					<td valign="top">
						<cfinclude template="TarifaCalculoRangos_form.cfm">
					</td>
				  </tr>
				</table>
			
			</cf_web_portlet>
		</td>
	  </tr>
	</table>
</cfif>

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.TCnombre.required = false;
		objForm.TCtipoCalculo.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.TCnombre.required = true;
		objForm.TCtipoCalculo.required = true;				
	}	
//---------------------------------------------------------------------------------------
	function cambioTipo(obj){
		var divEtiq_1 = document.getElementById('Etiq_1');
		var divSQL  = document.getElementById('divSQL');		
		
		if (obj.value == 'F') {//	Fijo
			divEtiq_1.style.display = 'none';
			divSQL.style.display  = 'none';			
		}else if ((obj.value == 'S')) {//	SQL
			divSQL.style.display  = '';
			divEtiq_1.style.display = 'none';
		}else if (obj.value == 'J') {//	JAVA
			divSQL.style.display  = 'none';
			divEtiq_1.style.display = '';
		}	
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formTarifaCalculo");
//---------------------------------------------------------------------------------------
	objForm.TCnombre.required = true;
	objForm.TCnombre.description = "Nombre";				
	objForm.TCtipoCalculo.required = true;
	objForm.TCtipoCalculo.description = "Tipo de Cálculo";				
	cambioTipo(document.formTarifaCalculo.TCtipoCalculo)
</script>