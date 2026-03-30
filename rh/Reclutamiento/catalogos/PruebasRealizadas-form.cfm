
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Nuevo"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarElRegistro"
	Default="Desea eliminar el registro"
	returnvariable="MSG_DeseaEliminarElRegistro"/>
			
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Prueba"
	Default="Prueba"
	returnvariable="LB_Prueba"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeLaPrueba"
	Default="Fecha de la prueba"
	returnvariable="LB_FechaDeLaPrueba"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Resultado"
	Default="Resultado"
	returnvariable="LB_Resultado"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Observaciones"
	Default="Observaciones"
	returnvariable="LB_Observaciones"/>

	
<cfset modoPruebas = "ALTA">
<cfif isdefined("form.RHPcodigopr") and len(trim(form.RHPcodigopr))>
	<cfset modoPruebas = "CAMBIO">
</cfif>
<cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
<cfquery name="rsPruebas" datasource="#session.DSN#">
	select RHPcodigopr,#LvarRHPdescripcionpr# as RHPdescripcionpr  
	from RHPruebas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif modoPruebas neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select RHPcodigopr,RHPfecha,RHPNota,RHPobservaciones,ts_rversion
		from RHPruebasOferente
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
			and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">	
		</cfif>	
		and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigopr#">
	</cfquery>
</cfif>

<cfoutput>

<form name="formPruebasRealizadas" action="PruebasRealizadas-sql.cfm" method="post">
	<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
	<input type="hidden" name="RHOid" value="<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>#form.RHOid#</cfif>">
	<input name="sel" type="hidden" value="1">
	<input type="hidden" name="o" value="6">		
	<table width="100%" cellpadding="2" cellspacing="0">
      <tr>
        <td width="20%" align="right"><strong>#LB_Prueba#:&nbsp;</strong></td>
        <td width="32%">
				<select name="RHPcodigopr" id="RHPcodigopr">
					<option value="">(<cf_translate key="CMB_Seleccione_una_prueba">Seleccione una prueba</cf_translate>)</option>
					<cfloop query="rsPruebas">
					  <option value="#rsPruebas.RHPcodigopr#" <cfif modoPruebas NEQ 'ALTA' and rsPruebas.RHPcodigopr EQ data.RHPcodigopr>selected</cfif>>#HTMLEditFormat(rsPruebas.RHPdescripcionpr)#</option>
					</cfloop>
				</select>
		</td>
      </tr>
      <tr>
        <td align="right" nowrap><strong>#LB_FechaDeLaPrueba#:&nbsp;</strong></td>
        <td>
			<cfif modoPruebas NEQ 'ALTA'>
				<cf_sifcalendario form="formPruebasRealizadas" value="#LSDateFormat(data.RHPfecha, "DD/MM/YYYY")#" name="RHPfecha">	
			<cfelse>
				<cf_sifcalendario form="formPruebasRealizadas" value="" name="RHPfecha">	
			</cfif>
		

		 </td>
      </tr>
      <tr>
        <td align="right"><strong>#LB_Resultado#:&nbsp;</strong></td>
        <td>
			<input 
			name="RHPNota" 
			type="text" 
			id="RHPNota"  
			style="text-align: right;" 
			onBlur="javascript: fm(this,2);"  
			onFocus="javascript:this.value=qf(this); this.select();"  
			onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
			value="<cfif modoPruebas NEQ 'ALTA'><cfoutput>#data.RHPNota#</cfoutput><cfelse>0.00</cfif>">		
	
		</td>
      </tr>
	  <tr>
        <td align="center" colspan="2"><strong>#LB_Observaciones#</strong></td>
      </tr>
	   <tr>
        <td a colspan="2">
			<textarea name="RHPobservaciones" id="RHPobservaciones" rows="6" style="width: 100%;"><cfif modoPruebas neq 'ALTA'>#trim(data.RHPobservaciones)#</cfif></textarea>
			
			
			<!--- <cfif modoPruebas neq 'ALTA'>
				<cf_rheditorhtml name="RHPobservaciones" width="99%" height="200" value="#trim(data.RHPobservaciones)#">
			<cfelse>
				<cf_rheditorhtml name="RHPobservaciones" width="99%" height="200">
			</cfif>	 --->	
		</td>
      </tr>
      <!--- Botones --->
      <tr>
        <td colspan="4">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4" align="center">
          <cfif modoPruebas eq 'ALTA'>
            <input type="submit" name="Alta" value="#BTN_Agregar#" onClick="javascript: habilitarValidacion();">
            <input type="reset" name="Limpiar" value="#BTN_Limpiar#">
            <cfelse>
            <input type="submit" name="Cambio" value="#BTN_Modificar#" onClick="habilitarValidacion();">
            <input type="submit" name="Baja" value="#BTN_Eliminar#" onClick="if ( confirm('#MSG_DeseaEliminarElRegistro#') ){deshabilitarValidacion(); return true;} return false;">
            <input type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="deshabilitarValidacion();">
          </cfif>        </td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
      </tr>
    </table>
	<cfif modoPruebas neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="tab" value="6">
	</cfif>
</form>
</cfoutput>
<!--- FUNCIONES Y DEMAS EN JAVASCRIPT ---->
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>

<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm4 = new qForm("formPruebasRealizadas");
	
	<cfoutput>
		objForm4.RHPcodigopr.required = true;
		objForm4.RHPcodigopr.description="#LB_Prueba#";		
		objForm4.RHPfecha.required= true;
		objForm4.RHPfecha.description="#LB_FechaDeLaPrueba#";	
	</cfoutput>
	
	function habilitarValidacion(){
		objForm4.RHPcodigopr.required = true;
		objForm4.RHPfecha.required = true;
	}

	function deshabilitarValidacion(){
		objForm4.RHPcodigopr.required = false;
		objForm4.RHPfecha.required = false;
	}
	function funcHabilitar(){
	}		
</script>

