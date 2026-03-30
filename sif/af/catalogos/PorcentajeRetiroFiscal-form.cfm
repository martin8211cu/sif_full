<!--- Consultas para llenar los campos de la pantalla --->
<!--- Categorias --->
<cfquery name="rsCategorias" datasource="#Session.DSN#">
	select ACcodigo, ACcodigodesc, ACdescripcion, ACmascara
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Clases --->
<!--- Se llenan automáticamente cuando cambia la categoria. --->
<cfquery name="rsClases" datasource="#Session.DSN#">
	select a.ACcodigo, a.ACid, a.ACcodigodesc, a.ACdescripcion, a.ACdepreciable, a.ACrevalua
	from AClasificacion a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif isdefined("form.PRFid") and len(trim(form.PRFid))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 	a.Ecodigo,
                a.ACcodigo,
                #PreserveSingleQuotes(Categoria)# as Categoria,
                b.ACdescripcion as Categoriadesc,  
                a.ACid, 
                #PreserveSingleQuotes(Clasificacion)# as Clasificacion,
                c.ACdescripcion as Clasificaciondesc,
                a.PRFid,
                a.PRAnoDesde, 
                a.PRAnoHasta,
                a.PRPorcentaje,
                a.ts_rversion
        from  AFPorcentajeRetiroFiscal a
            inner join ACategoria b 
                on a.Ecodigo 	= b.Ecodigo
                and a.ACcodigo 	=  b.ACcodigo
            inner join AClasificacion c 
                on a.Ecodigo 	= c.Ecodigo
                and a.ACcodigo 	= c.ACcodigo
                and a.ACid 	= c.ACid
        where a.PRFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRFid#">
        	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/UtilesMonto.js"></script>

<!--- Pintado de la Pantalla --->
<cfoutput>
<fieldset>
<legend><strong>Porcentajes de aplicaci&oacute;n Fiscal</strong>&nbsp;</legend>
	<form action="PorcentajeRetiroFiscal-sql.cfm" method="post" name="form1">
		<table width="80%" align="center" border="0" >
			<tr>
				<td align="right"><strong>Categor&iacute;a:</strong></td>
				<td rowspan="2" nowrap colspan="2">
					<cfif isdefined("form.Padre_ACid") and isdefined("form.Padre_ACcodigo")>
						<cfquery name="rsCatClase" datasource="#session.dsn#">
							select 
							b.ACcodigo, 
							<cf_dbfunction name="to_char" args="b.ACcodigodesc"> as Categoria, 
							b.ACdescripcion as Categoriadesc, 
							c.ACid, 
							<cf_dbfunction name="to_char" args="c.ACcodigodesc"> as Clasificacion, 
							c.ACdescripcion as Clasificaciondesc
							from ACategoria b
								inner join AClasificacion c
								on c.Ecodigo = b.Ecodigo 
								and c.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Padre_ACid#">
								and c.ACcodigo = b.ACcodigo
							where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
							and b.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Padre_ACcodigo#">
						</cfquery>
						<cf_sifCatClase query="#rsCatClase#" Modificable="false" tabindex="-1">
					<cfelseif modo NEQ 'ALTA' >
						<cf_sifCatClase query="#rsForm#" Modificable="false" tabindex="-1">
					<cfelse>
						<cf_sifCatClase tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr>
				<td align="right"><strong>Clasificaci&oacute;n:</strong></td>
 			</tr>
			<tr>
				<td align="right"><strong>Años Desde:</strong></td>
				<td colspan="2">
                	<cfif modo NEQ 'ALTA'>
                    	<input type="hidden" name="PRAnoDesde" id="PRAnoDesde" value="#form.PRAnoDesde#" />
                        #form.PRAnoDesde#
                    <cfelse>
                    	<input type="text" name="PRAnoDesde" id="PRAnoDesde" value="" />
                    </cfif>
				</td>
			</tr>	
			<tr>
				<td align="right"><strong>Años Hasta:</strong></td>
				<td colspan="2">
                	<cfif modo NEQ 'ALTA'>
                    	<input type="hidden" name="PRAnoHasta" id="PRAnoHasta" value="#form.PRAnoHasta#" />
                        #form.PRAnoHasta#
                    <cfelse>
                    	<input type="text" name="PRAnoHasta" id="PRAnoHasta" value="" />
                    </cfif>
				</td>
			</tr>	
            <tr>
				<td align="right"><strong>Porcentaje:</strong></td>
				<td colspan="2">
					<input type="text" name="PRPorcentaje" id="PRPorcentaje" value="<cfif (modo NEQ "ALTA")>#form.PRPorcentaje#</cfif>" />
				</td>
			</tr>	
			<tr><td colspan="3">
            	<input type="hidden" name="PRFid" id="PRFid" value="<cfif (modo NEQ "ALTA")>#form.PRFid#</cfif>" />
            </td></tr>

			<tr valign="baseline"> 
				<td colspan="3" align="center" nowrap>
					<!--- <cf_botones modo="#modo#" include="Regresar"> --->
					<cfif isdefined("form.Padre_ACid") and isdefined("form.Padre_ACcodigo")> 
						<cf_botones modo="#modo#" include="Regresar" tabindex="1">
					<cfelse>
						<cf_botones modo="#modo#" tabindex="1">
					</cfif>
				</td>
			</tr>
	
			<tr>
				<td colspan="3">
					<cfset ts = "">
					<cfif modo NEQ "ALTA">
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">        
						</cfinvoke>
					</cfif>
					<input type="hidden" name="modo" value="" >
					<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" >
					<cfif isdefined("form.Padre_ACid")>
						<input type="hidden" name="Padre_ACid" value="#form.Padre_ACid#" >
					</cfif>
					<cfif isdefined("form.Padre_ACcodigo")>
						<input type="hidden" name="Padre_ACcodigo" value="#form.Padre_ACcodigo#" >
					</cfif>
                    <input type="hidden" name="VieneClas" id="VieneClas" value="#form.VieneClas#" />
					<input type="hidden" name="Pagina3" 
						value="
							<cfif isdefined("form.pagenum3") and form.pagenum3 NEQ "">
								#form.pagenum3#
							<cfelseif isdefined("url.PageNum_lista3") and url.PageNum_lista3 NEQ "">
								#url.PageNum_lista3#
							</cfif>">
				</td>
			</tr>
		</table>
	</form>
</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="JavaScript1.2" type="text/javascript">

		function habilitarValidacion() {
			objForm.ACcodigo.required = true;
			objForm.ACid.required = true;
			objForm.PRAnoDesde.required = true;
			objForm.PRAnoHasta.required = true;
			objForm.PRPorcentaje = true;
		}
		function deshabilitarValidacion() {
			objForm.ACcodigo.required = false;
			objForm.ACid.required = false;
			objForm.PRAnoDesde.required = false;
			objForm.PRAnoHasta.required = false;
			objForm.PRPorcentaje = false;
		}
		
		habilitarValidacion();
		
		//validaciones adicionales
		
		function funcRegresar(){
			deshabilitarValidacion();
			<cfif isdefined("form.Padre_ACid") and isdefined("form.Padre_ACcodigo")> 
				location.href = 'AClasificacion.cfm?ACcodigo=#form.Padre_ACcodigo#&ACid=#form.Padre_ACid#';
			</cfif>
			return false;
			
		}

	</script>
</cfoutput>