
<style type="text/css">
	.well { padding: 25px 10px 15px 10px; margin-top: 10px; margin-bottom: 15px; }
	.form-group { margin-left: 16%; }
	.empleado table { margin-left: 20px; }
	.periodo, .lbperiodo, .formato { margin-left: 15px; }
	.lbperiodo label.mes { margin-left: 130px; }
	.lbperiodo label.year { margin-left: 50px; }
	.buttons { margin-top: 15px; }
</style>


<cfset t = createObject("component", "sif.Componentes.Translate")>
<!----- Etiquetas de traduccion------>
<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','/rh/generales.xml')>
<cfset LB_Mes = t.translate('LB_Mes','Mes','/rh/generales.xml')>
<cfset LB_Ano = t.translate('LB_Ano','Año','/rh/generales.xml')>
<cfset LB_RangoDesde = t.translate('LB_RangoDesde','Rango desde','/rh/generales.xml')>
<cfset LB_RangoHasta = t.translate('LB_RangoHasta','Rango hasta','/rh/generales.xml')>
<cfset LB_Formato = t.translate('LB_Formato','Formato','/rh/generales.xml')>
<cfset LB_HTML = t.translate('LB_HTML','HTML','/rh/generales.xml')>
<cfset LB_PDF = t.translate('LB_PDF','PDF','/rh/generales.xml')>
<cfset LB_Excel = t.translate('LB_Excel','Excel','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_Empleado = t.translate('MSG_Empleado','Debe seleccionar un empleado para realizar la consulta')>

<cfset anoActual = year(now())>

<cfquery name="rsListYears" datasource="#session.DSN#">
    select distinct year(PEdesde) as years
    from HPagosEmpleado
    union 
        select #anoActual# as years from dual   
</cfquery> 

<cfquery name="rsListYears" dbtype="query">
    select * from rsListYears order by years asc
</cfquery> 

<cfif isdefined("form.sAnoDesde") and len(trim(form.sAnoDesde))>
    <cfset lvarYearDesde = form.sAnoDesde >
<cfelseif isdefined("url.sAnoDesde") and len(trim(url.sAnoDesde))>
    <cfset lvarYearDesde = url.sAnoDesde >    
<cfelseif isdefined("url.sAnoDesde") or isdefined("form.sAnoDesde")>
    <cfset lvarYearDesde = '' >     
<cfelse>
    <cfset lvarYearDesde = anoActual >    
</cfif>

<cfif isdefined("form.sAnoHasta") and len(trim(form.sAnoHasta))>
    <cfset lvarYearHasta = form.sAnoHasta >
<cfelseif isdefined("url.sAnoHasta") and len(trim(url.sAnoHasta))>
    <cfset lvarYearHasta = url.sAnoHasta >    
<cfelseif isdefined("url.sAnoHasta") or isdefined("form.sAnoHasta")>
    <cfset lvarYearHasta = '' >     
<cfelse>
    <cfset lvarYearHasta = anoActual >    
</cfif>

<cfset rsMes = getMeses() > <!--- Obtiene los meses a utilizar --->

<div class="row well">	
	<form action="ReporteDetalleIngresosPorEmpleado-sql.cfm" method="post" name="form1">
		<cfoutput>
			<div class="col-sm-12">
				<div class="form-group row"> 
	            	<div class="col-sm-1">
						<label for="empleado"><strong>#LB_Empleado#:</strong></label>
					</div>
					<div class="col-sm-11 empleado">	
						<cf_rhempleado tabindex="1"  AgregarEnLista="True">
					</div>						
	            </div>
			</div>

			<div class="col-sm-12">
				<div class="form-group row"> 	
					<div class="lbperiodo"> 	 
						<label for="mes" class="mes"><strong>#LB_Mes#</strong></label>
						<label for="year" class="year"><strong>#LB_Ano#</strong></label>
					</div>	
					<div class="periodo">
						<label for="rangoDesde"><strong>#LB_RangoDesde#:</strong></label>
						<select name="sMesDesde">
							<cfloop query="rsMes">
					            <option value="#rsMes.codMes#" <cfif isdefined("form.sMesDesde") and form.sMesDesde eq rsMes.codMes>selected</cfif>>#rsMes.mes#</option>
					        </cfloop>	
						</select>
						<select name="sAnoDesde">
	                        <cfloop query="#rsListYears#">
	                            <option value="#years#"<cfif isdefined("lvarYearDesde") and len(trim(lvarYearDesde))>
	                           <cfif rsListYears.years eq lvarYearDesde> selected </cfif></cfif>>#years#</option>
	                        </cfloop>
						</select>			
					</div>	
	            </div>
	        </div>    	

	        <div class="col-sm-12">
				<div class="form-group row">
					<div class="periodo">
						<label for="rangoHasta"><strong>#LB_RangoHasta#:</strong></label>
						<select name="sMesHasta">
							<cfloop query="rsMes">
					            <option value="#rsMes.codMes#" <cfif isdefined("form.sMesHasta") and form.sMesHasta eq rsMes.codMes>selected</cfif>>#rsMes.mes#</option>
					        </cfloop>		
						</select>
						<select name="sAnoHasta">
	                        <cfloop query="#rsListYears#">
	                            <option value="#years#"<cfif isdefined("lvarYearHasta") and len(trim(lvarYearHasta))>
	                           <cfif rsListYears.years eq lvarYearHasta> selected </cfif></cfif>>#years#</option>
	                        </cfloop>
						</select>
					</div>	
				</div>
	        </div> 

	        <div class="col-sm-12">
				<div class="form-group row">
					<div class="formato">
						<label for="formato"> #LB_Formato#: </label>
						<cfparam name="Form.sFormato" default="html">
						<select name="sFormato">
							<option value="html"> #LB_HTML# </option>
							<option value="pdf"> #LB_PDF# </option>
							<option value="excel"> #LB_Excel# </option>
						</select>
					</div> 	
		        </div> 
	        </div> 

	        <div class="col-sm-12">
				<div class="form-group row">
			        <div class="col-sm-10 col-sm-offset-3">
			        	<input type="submit" name="btnFiltrar" class="btnFiltrar" value="#LB_Consultar#" />
			        	<input type="reset" name="btnLimpiar" class="btnLimpiar" value="#LB_Limpiar#" />
			        </div>
		        </div>
		    </div>    
		</cfoutput>
	</form>
</div>	

<cffunction name="getMeses" access="public" output="false" returntype="query">
	<cfquery name="rs" datasource="sifControl">
		select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as codMes, b.VSdesc as mes
		from Idiomas a
		inner join VSidioma b 
		on a.Iid = b.Iid
		where a.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
		order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
	</cfquery>
	<cfreturn rs>
</cffunction>


<!---<cfif isDefined("form.DEid") and len(trim(form.DEid))>
	<script type="text/javascript">
		$("#DEid").val(<cfoutput>#form.DEid#</cfoutput>);
		$("#DEidentificacion").val(<cfoutput>#form.DEidentificacion#</cfoutput>);
		$("#NombreEmp").focus();
	</script>
</cfif>--->
