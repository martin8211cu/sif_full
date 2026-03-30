<!--- 
	tipoCoti = 1 - Prefacturas
	tipoCoti = 2 - Cotizaciones
 --->
<cfif isdefined('url.tipoCoti') and url.tipoCoti NEQ ''>
	<cfparam name="form.tipoCoti" default="#url.tipoCoti#">
</cfif>

<cfset varTitulo = "">
<cfif left(form.tipoCoti,1) EQ '1'>
	<!--- Prefacturas	 --->	
	<cfset varTitulo = " Prefacturas">			
<cfelseif left(form.tipoCoti, 1) EQ '2'>
	<!--- Registro de Cotizaciones --->
	<cfset varTitulo = " Registro de Cotizaciones">
</cfif>

<cf_templateheader title="Punto de Venta #varTitulo#">
	<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#varTitulo#">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<cfinclude template="../../portlets/pNavegacion.cfm">
				</td>
			</tr>
			<tr align="center">
				<td  valign="top">
					<cfif (isdefined("Form.NumeroCot") and len(trim(form.NumeroCot))) or (isdefined("Form.btnNuevo"))>
						<cfif left(form.tipoCoti,1) EQ '1'>
							<cfinclude template="prefactura-form.cfm">
						<cfelseif left(form.tipoCoti,1) EQ '2'>
							<cfinclude template="cotizaciones-form.cfm">
						<cfelse>
							<cf_errorCode	code = "50576" msg = "El parametro es incorrecto">
						</cfif>
						
					<cfelse>
						<!--- Filtro para la lista --->
						<cfinclude template="cotizaciones-filtro.cfm">
						<cfquery name="rsCotiz" datasource="#session.dsn#">
							Select 
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipoCoti#"> as tipoCoti,
								NumeroCot, CDCnombre, 
								case Estatus
									when 0 then 'Digitada'
									when 1 then 'Terminada'
									when 2 then 'Anulada'
									when 3 then 'Vencida'
								end Estatus,
								Estatus as estado
							from FACotizacionesE fac
								inner join ClientesDetallistasCorp c
									on c.CDCcodigo=fac.CDCcodigo
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and Estatus in (0,1,2,3,4)
								<cfif left(form.tipoCoti, 1) EQ '2'>
									<!--- Solo Cotizaciones --->
									and TipoTransaccion=0
								<cfelseif left(form.tipoCoti, 1) EQ '1'>
									<!--- Solo Pre-Facturas --->
									and TipoTransaccion not in (0)								
								</cfif>											
								<cfif isdefined('form.Estatus_F') and len(trim(form.Estatus_F)) and form.Estatus_F NEQ '-1'>
									and Estatus=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Estatus_F#">
								</cfif>
								<cfif isdefined('form.CDCcodigo_F') and len(trim(form.CDCcodigo_F))>
									and fac.CDCcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CDCcodigo_F#">
								</cfif>
								<cfif isdefined('form.NumeroCot_F') and len(trim(form.NumeroCot_F)) and form.NumeroCot_F GT 0>
									and NumeroCot=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot_F#">
								</cfif>		
						</cfquery>
						
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsCotiz#"/>
								<cfinvokeargument name="desplegar" value="NumeroCot, CDCnombre, Estatus"/>
								<cfinvokeargument name="etiquetas" value="Cotizaci&oacute;n,Cliente, Estatus"/>
								<cfinvokeargument name="formatos" value="I, V, V"/>
								<cfinvokeargument name="align" value="left, left, left"/>
								<cfinvokeargument name="ajustar" value="N, N, N"/>
								<cfinvokeargument name="irA" value="cotizaciones.cfm"/>
								<cfinvokeargument name="keys" value="NumeroCot"/>
								<cfinvokeargument name="checkboxes" value="S"/>
								<cfinvokeargument name="botones" value="Nuevo,Aplicar"/>
								<cfinvokeargument name="formName" value="frListaCoti"/>
								<cfinvokeargument name="showemptylistmsg" value="true"/>
						</cfinvoke>
					</cfif>
				</td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	function funcNuevo(){	
		document.frListaCoti.TIPOCOTI.value = '<cfoutput>#form.tipoCoti#</cfoutput>';
	}
	// Aplicar
	function algunoMarcado(){
		var aplica = false;
		if (document.frListaCoti.chk) {
			if (document.frListaCoti.chk.value) {
				aplica = document.frListaCoti.chk.checked;
			}else{
				for (var i=0; i<document.frListaCoti.chk.length; i++) {
					if (document.frListaCoti.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm("¿Está seguro de que desea aplicar las cotizaciones seleccionadas?"));
		} else {
			alert('Debe seleccionar al menos una cotización antes de Aplicar');
			return false;
		}
	}
	function funcAplicar() {
		document.frListaCoti.TIPOCOTI.value = '<cfoutput>#form.tipoCoti#</cfoutput>';
		if (algunoMarcado())
			document.frListaCoti.action = "cotizaciones-sql.cfm";
		else
			return false;
	}	
</script>


