<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PreFactura" default="Pre-Factura" returnvariable="LB_PreFactura" xmlfile="FAprefactura-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Transaccion" default="Transacci&oacute;n" returnvariable="LB_Transaccion" xmlfile="FAprefactura-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Estatus" default="Estatus" returnvariable="LB_Estatus" xmlfile="FAprefactura-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Todas" default="Todas" returnvariable="LB_Todas" xmlfile="FAprefactura-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pendiente" default="Pendiente" returnvariable="LB_Pendiente" xmlfile="FAprefactura-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Estimada" default="Estimada" returnvariable="LB_Estimada" xmlfile="FAprefactura-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" xmlfile="FAprefactura-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cliente" default="Cliente" returnvariable="LB_Cliente" xmlfile="FAprefactura-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="FAprefactura-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Oficina" default="Oficina" returnvariable="LB_Oficina" xmlfile="FAprefactura-filtro.xml"/>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>

<cfif isdefined("url.Bid") and not isdefined("form.Bid") >
	<cfset form.Bid = url.Bid >
</cfif>
<cfif isdefined("url.FAM18DES") and not isdefined("form.FAM18DES") >
	<cfset form.FAM18DES = url.FAM18DES >
</cfif>

<cfquery name="rsMonedas" datasource="#session.dsn#">
	select Mcodigo,Miso4217,Mnombre
    from Monedas 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsTransacciones" datasource="#session.dsn#">
	select PFTcodigo,PFTdescripcion
    from FAPFTransacciones
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsOficinas" datasource="#session.dsn#">
	select Ocodigo,Odescripcion
    from Oficinas
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfoutput>
<form style="margin: 0" action="FAprefactura.cfm" name="form1" method="post">
<!---<input type="hidden" name="tipoCoti" value="#form.tipoCoti#">	Se quita ya no se usa el tipo de Coti --->
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
	<tr>
		<td width="118" align="right" nowrap><strong>#LB_PreFactura#:</strong></td>
		<td width="90" align="left">
			<input name="PFdocumento" type="text" id="PFdocumento" <cfif isdefined('form.PFdocumento')> value="#form.PFdocumento#"</cfif> style="text-align: right" size="20" maxlength="20" tabindex="1">
		</td>
		<td width="55" align="right"><strong>#LB_Transaccion#:</strong></td>
        <td width="99" > 
			<select name="PFTcodigo">
					<option value="-1" <cfif isdefined('form.PFTcodigo') and form.PFTcodigo EQ '-1'> selected</cfif>>-- #LB_Todas# --</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<option value="#PFTcodigo#" <cfif isdefined("Form.PFTcodigo") AND Form.PFTcodigo EQ rsTransacciones.PFTcodigo> selected</cfif>>(#PFTcodigo#)&nbsp;#PFTdescripcion#</option>
						</cfloop>
					</cfif>
				</select>      
        </td>
        <td width="55" align="right"><strong>#LB_Estatus#:</strong></td>
		<td width="99">
			<select name="EstatusPF">
				<option value="-1" <cfif isdefined('form.EstatusPF') and form.EstatusPF EQ '-1'> selected</cfif>>-- #LB_Todas# --</option>
				<option value="R" <cfif isdefined('form.EstatusPF') and form.EstatusPF EQ 'R'> selected</cfif>>Por Asignar</option>
				<option value="P" <cfif isdefined('form.EstatusPF') and form.EstatusPF EQ 'P'> selected</cfif>>#LB_Pendiente#</option>
				<option value="E" <cfif isdefined('form.EstatusPF') and form.EstatusPF EQ 'E'> selected</cfif>>#LB_Estimada#</option>
			</select>	
		</td>	
		<td width="16"><input type="submit" name="btnFiltro"  value="#BTN_Filtrar#"></td>
    </tr>
    <tr>
	    <td width="79" align="right"><strong>#LB_Cliente#:</strong></td>
		<td width="180" align="left"  colspan="3">
			<cfif isdefined('form.SNcodigo') and LEN(trim(form.SNcodigo))>
           		<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="C"  size="55" idquery="#form.SNcodigo#">
	        <cfelse>
			    <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="C" size="55" frame="frame2">
       	    </cfif>			
		</td>
        <td width="55" align="right"><strong>#LB_Moneda#:</strong></td>
        <td width="99"> 
			<select name="Mcodigo">
					<option value="-1" <cfif isdefined('form.Mcodigo') and form.Mcodigo EQ '-1'> selected</cfif>>--#LB_Todas# --</option>
					<cfif isdefined('rsMonedas') and rsMonedas.recordCount GT 0>
						<cfloop query="rsMonedas">
							<option value="#Mcodigo#" <cfif isdefined("Form.Mcodigo") AND Form.Mcodigo EQ rsMonedas.Mcodigo> selected</cfif>>(#Miso4217#)&nbsp;#Mnombre#</option>
						</cfloop>
					</cfif>
				</select>      
        </td>
    </tr>
    <tr>
    	<td colspan="4"> </td>
    	<td align="right"> <strong>#LB_Oficina#:</strong> </td>
        <td>
	    	<select name="Ocodigo">
				<option value="-1" <cfif isdefined('form.Ocodigo') and form.Ocodigo EQ '-1'> selected</cfif>>-- #LB_Todas# --</option>
				<cfif isdefined('rsOficinas') and rsOficinas.recordCount GT 0>
					<cfloop query="rsOficinas">
							<option value="#Ocodigo#" <cfif isdefined("Form.Ocodigo") AND Form.Ocodigo EQ rsOficinas.Ocodigo> selected</cfif>>#Odescripcion#</option>
						</cfloop>
					</cfif>
				</select>   
        </td>
    </tr>
 </table>
</form>
</cfoutput>
