 <cfparam name="form.CHK_IntegracionModuloTesoreria" default="0">

<cfif isdefined('form.btnGuardar')>
	<cfinvoke component="rh.Componentes.RHParametros" method="Set">
        <cfinvokeargument name="Pcodigo" 		value="545">
        <cfinvokeargument name="pdescripcion" 	value="Integración con módulo de tesorería">
        <cfinvokeargument name="pvalor" 		value="#form.CHK_IntegracionModuloTesoreria#">
	</cfinvoke>
	<cfinvoke component="sif.Componentes.Parametros" method="Set">
        <cfinvokeargument name="Pcodigo" 		value="15780">
        <cfinvokeargument name="mcodigo" 		value="RH">
        <cfinvokeargument name="pdescripcion" 	value="Transacción para Pago de Salarios">
         <cfinvokeargument name="pvalor" 		value="#form.BTid#">
	</cfinvoke>
    <cfparam name="form.RhBancoResumido" default="N">
    <cfinvoke component="sif.Componentes.Parametros" method="Set">
        <cfinvokeargument name="Pcodigo" 		value="15781">
        <cfinvokeargument name="mcodigo" 		value="RH">
        <cfinvokeargument name="pdescripcion" 	value="Generar Movimiento Bancario de Nomina Resumido">
        <cfinvokeargument name="pvalor" 		value="#form.RhBancoResumido#">
	</cfinvoke>
</cfif>
<cfinvoke component="sif.Componentes.Parametros" method="Get" returnvariable="Param15780">
	<cfinvokeargument name="Pcodigo" value="15780">
    <cfinvokeargument name="Default" value="-1">
</cfinvoke>
<cfinvoke component="sif.Componentes.Parametros" method="Get" returnvariable="Param15781">
	<cfinvokeargument name="Pcodigo" value="15781">
    <cfinvokeargument name="Default" value="N">
</cfinvoke>
<cfinvoke component="rh.Componentes.RHParametros" method="Get" returnvariable="Param545">
	<cfinvokeargument name="Pvalor"  value="545">
    <cfinvokeargument name="Default" value="0">
</cfinvoke>

<cfquery name="rsBTransacciones" datasource="#session.dsn#">
	select BTid, BTtipo, BTdescripcion
		from BTransacciones
    where BTtipo  = 'C'
	  and Ecodigo = #session.Ecodigo#
</cfquery>

<cf_templateheader title="Tesoreria Vrs Nomina">
	<cf_web_portlet_start border="true" titulo="Configuración de Integración con Nomina" skin="#Session.Preferences.Skin#">
   		<form name="fmParam" method="post" action="Parametros.cfm">
        	<cfoutput>
				<div class="row">
					<div class="col-xs-6" align="right">
						<cf_translate key="CHK_IntegracionConModuloTesoreria">Integración de Nomina y tesorería</cf_translate>:	
					</div>
					<div class="col-xs-6" align="left">
						<input name="CHK_IntegracionModuloTesoreria" type="checkbox" value="1" tabindex="1" <cfif trim(Param545) eq '1' >checked</cfif>>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-6" align="right">
						Generar Movimiento Bancario resumido:
					</div>
					<div class="col-xs-6" align="left">
						<input name="RhBancoResumido" type="checkbox" value="S" <cfif Param15781 EQ 'S'>checked="checked"</cfif> />	
					</div>
				</div>
				<div class="row">
					<div class="col-xs-6" align="right">
						Transacción para Pago de Salarios:	
					</div>
					<div class="col-xs-6" align="left">
						<select name="BTid" tabindex="4" onchange="if(selectedIndex != 0) asignatipo(options[selectedIndex].title);"> 
							<option value="">-- Seleccione una Transacción --</option>
							<cfloop query="rsBTransacciones">
								<option  title="#rsBTransacciones.BTtipo#" <cfif Param15780 EQ rsBTransacciones.BTid> selected</cfif> value="#rsBTransacciones.BTid#">#rsBTransacciones.BTdescripcion#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12" align="center">
						<input type="submit" name="btnGuardar" value="Guardar" class="btnGuardar"/>
					</div>
				</div>
        	</cfoutput>
        </form>

    <h4>Integración de Nomina y Tesoreria</h4>
		<p>La Integración no se encuentra implementada con la contabilización desde históricos</p>
		<p>La integración no se encuentra implementada con asiento de nomina NO unificado.</p>
		<p>La integracion no se encuentra implementada para liquidaciones laborales<p>
		<p>La integracion no se encuentra implementada para Pago de Aguinaldo<p>
	<cf_web_portlet_end>
<cf_templatefooter>
