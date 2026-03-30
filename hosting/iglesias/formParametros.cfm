
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	function validar(){
		document.form1.monto.value = qf(document.form1.monto);
	}
</script>

 <!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#session.DSN#">
		select Pvalor
		from MEParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select Pvalor from MEParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- obtiene los datos,  si ya existen --->
<cfset PvalorPagoRegistro = ObtenerDato(10)>		<!--- Paga registro --->
<cfset PvalorProyecto     = ObtenerDato(20)>		<!--- Proyecto donde se contabiliza el registro --->
<cfset PvalorMonto        = ObtenerDato(30)>		<!--- Monto de cobro --->

<!--- valida la existencia de los datos --->
<cfif PvalorPagoRegistro.RecordCount gt 0 ><cfset existePagoRegistro = true ><cfelse><cfset existePagoRegistro = false ></cfif>		<!--- Paga por registro --->
<cfif PvalorProyecto.RecordCount gt 0 ><cfset existeProyecto = 1 ><cfelse><cfset existeProyecto = 0 ></cfif>					<!--- Proyecto --->
<cfif PvalorMonto.RecordCount gt 0 ><cfset existeMonto = 1 ><cfelse><cfset existeMonto = 0 ></cfif>							<!--- Monto--->

<form action="SQLParametros.cfm" method="post" name="form1" onSubmit="javascript:validar();" >
	<cfoutput>
	<table border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td>&nbsp;</td>
			<td><div align="left"></div></td>
			<td>
				<input name="pago" type="checkbox" <cfif existePagoRegistro eq '1' and trim(PvalorPagoRegistro.Pvalor) neq '0' >checked</cfif> >
				Paga Afiliaci&oacute;n
			</td>
			<td>&nbsp;</td>
		</tr>
		

		<tr>
			<td>&nbsp;</td> 
			<td><div align="left">Proyecto de Cobro:&nbsp;</div>
			</td>
		
			<td>
				<cfquery name="rsProyectos" datasource="#session.DSN#">
					select MEDproyecto,MEDnombre from MEDProyecto where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<select name="proyecto">
					<cfloop query="rsProyectos" >
						<option value="#rsProyectos.MEDproyecto#" <cfif existeProyecto and trim(PvalorProyecto.Pvalor) eq rsProyectos.MEDproyecto >selected</cfif> >#rsProyectos.MEDnombre#</option> 
					</cfloop>
				</select>
			</td>
		
			<td>&nbsp;</td>
		</tr>
		
		<tr>
			<td>&nbsp;</td> 
			<td>Monto por Inscripci&oacute;n:&nbsp;</td>
			<td>
			<input name="monto" type="text" style="text-align: right;" onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif existeMonto and len(trim(PvalorMonto.Pvalor)) gt 0>#LSNumberFormat(PvalorMonto.Pvalor,',9.00')#<cfelse>0.00</cfif>" size="15" maxlength="5" >
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td> 
			<td>Tienda:</td>
			<td>
				<cfquery name="rsTiendas" datasource="asp">
					select Ereferencia, Enombre, Ccache
					from Empresa, Caches
					where Empresa.Cid = Caches.Cid
					<!--- and Empresa.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">--->
				</cfquery>
				
				<cfquery name="rsParametros" datasource="#Session.DSN#">
					select Pvalor
					from MEParametros
					where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="40">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfif rsParametros.RecordCount gt 0 and len(trim(rsParametros.Pvalor)) gt 0>
					<cfset tiendaSel = rsParametros.Pvalor>
				<cfelse>
					<cfset tiendaSel = "">
				</cfif>
				
				<select name="tienda">
					<option value="">(Ninguna)</option>
					<cfloop query="rsTiendas">
						<cfif len(trim(rsTiendas.Ereferencia)) gt 0 and len(trim(rsTiendas.Ccache)) gt 0>
						<cfquery name="rs" datasource="#rsTiendas.Ccache#">
							select 1
							from ArteTienda
							where Ecodigo = #rsTiendas.Ereferencia#
						</cfquery>
						<cfif rs.RecordCount gt 0>
							<option value="#rsTiendas.Ereferencia#" <cfif tiendaSel eq rsTiendas.Ereferencia>selected</cfif>>#rsTiendas.Enombre#</option> 
						</cfif>
						</cfif>
					</cfloop>
				</select>
			</td>
		</tr>

		
		<tr><td colspan="4" align="center">&nbsp;</td></tr>
		<tr><td colspan="4" align="center"><input type="submit" name="btnAceptar" value="Aceptar"></td></tr>

	</table>
	</cfoutput>
</form>