<cf_templateheader title="Detalle de las Addendas">
	<!--- Forzar a modificar el form.modo por undefined, que viene como CAMBIO desde la lista anterior (Lista de addendas)--->
	<cfif not isdefined("cambio")>
		<cfset form.modo = JavaCast("null", 0) />
	</cfif>
	
	<cfset titulo = 'Detalle de Addendas'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="3">
				</td>
			</tr>
			<tr>
				<td valign="top"> 
				    <cfquery datasource = "#Session.DSN#" name = "total_add_det_query">
						select * from AddendasDetalle
						where ADDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDid#">
					</cfquery> 
					<cfif total_add_det_query.recordCount GT 0>
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="AddendasDetalle"/>
							<cfinvokeargument name="columnas" value="ADDDetalleid, ADDid, CODIGO, VALOR, TIPO"/>
							<cfinvokeargument name="desplegar" value="CODIGO, VALOR, TIPO"/>
							<cfinvokeargument name="etiquetas" value="Codigo, Valor, Tipo"/>
							<cfinvokeargument name="formatos" value="S, S, S"/>
							<cfinvokeargument name="filtro" value="ADDid = #form.ADDid#"/> 
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="S"/>
							<cfinvokeargument name="keys" value="ADDDetalleid, ADDid"/>
							<cfinvokeargument name="irA" value="AgregarAddendasDetalle.cfm?cambio=true"/>
						</cfinvoke>
					<cfelse>
					    <p style = "text-align: right;"><cfoutput>Sin detalle para la addenda</cfoutput></p>
					</cfif> 
				</td>				
				<td valign="top">
				    <cfinclude template="AgregarAddendasDetalle_form.cfm">
				</td>
			</tr>
			<tr>
			    <td align="center">
					<input type="button" class = "btnAnterior" onclick="Regresar();" value="Regresar">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	

<script type="text/javascript" language="JavaScript1.2" >
	function Regresar(){
		location.href = 'listaAddendas.cfm';
	}
</script>