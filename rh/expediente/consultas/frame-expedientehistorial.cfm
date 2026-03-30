
<!--- Tipo de Expediente --->
<cfquery name="rsTipoExpediente" datasource="#Session.DSN#">
	select TEcodigo, TEdescripcion
	from TipoExpediente
	where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
	and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>

<script language="javascript" type="text/javascript">
	function funcRegresar2() {
		document.form1.BTNHISTORIAL.value = '';
	}
</script>

<cfoutput>
<table cellpadding="2" cellspacing="0" border="0" width="98%" align="center">
  <tr>
	<td colspan="2" class="#Session.preferences.Skin#_thcenter">
		#rsTipoExpediente.TEcodigo# - #rsTipoExpediente.TEdescripcion# (<cf_translate key="LB_ListaDeExpedientes">Lista de Expedientes</cf_translate>)
	</td>
  </tr>



  <tr>
	<td>
		<cfquery datasource="#session.dsn#" name="lista">
			select a.IEid,
				   d.EFEdescripcion as Formato,
				   a.IEfecha as Fecha,
				   '1' as btnHistorial

			from IncidenciasExpediente a
			
			inner join TipoExpediente c
		  	on a.TEid = c.TEid
			
			inner join EFormatosExpediente d
		  	on a.EFEid = d.EFEid

			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			  and a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
			  and a.IEestado = 1

			order by a.IEfecha desc, Formato
		</cfquery>
		<!--- Variable de traduccion --->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Formato"
			Default="Formato"
			returnvariable="LB_Formato"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Fecha"
			Default="Fecha"
			returnvariable="LB_Fecha"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSeEncontraronExpedientesConElCriterioSeleccionado"
			Default="No se encontraron expedientes con el criterio seleccionado"
			returnvariable="MSG_NoSeEncontraronExpedientesConElCriterioSeleccionado"/>
		<cfinvoke
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#lista#"/>
			<cfinvokeargument name="desplegar" value="Formato, Fecha"/>
			<cfinvokeargument name="etiquetas" value="#LB_Formato#, #LB_Fecha#"/>
			<cfinvokeargument name="formatos" value="V,D"/>
			<cfinvokeargument name="align" value="left,center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="keys" value="IEid"/>
			<cfinvokeargument name="MaxRows" value="0"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="incluyeForm" value="false"/>
			<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="EmptyListMsg" value="--- #MSG_NoSeEncontraronExpedientesConElCriterioSeleccionado# ---"/>
		</cfinvoke>
	</td>
  </tr>




  <tr>
	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
	<td colspan="2" align="center">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Regresar"
			Default="Regresar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Regresar"/>		
		<input type="submit" name="btnRegresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript: return funcRegresar2();">
	</td>
  </tr>
  <tr>
	<td colspan="2">&nbsp;</td>
  </tr>
</table>

</cfoutput>
