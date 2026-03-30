
<cfset t = createObject("component","sif.Componentes.Translate")> 
<cfset LB_ReporteCostosSalariales = t.translate('LB_ReporteCostosSalariales','Reporte de Costos Salariales')/>
<cfset LB_Cuenta = t.translate('LB_Cuenta','Cuenta','/rh/generales.xml')/>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')/>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')/>
<cfset LB_Anno = t.translate('LB_Anno','Año','/rh/generales.xml')/>
<cfset LB_Mes = t.translate('LB_Mes','Mes','/rh/generales.xml')/>
<cfset LB_Salario = t.translate('LB_Salario','Salario','/rh/generales.xml')/>
<cfset LB_OtrosIngresos = t.translate('LB_OtrosIngresos','Otros Ingresos','ReporteCostosSalariales.xml')/>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')/>
<cfset LB_subTotal = t.translate('LB_subTotal','Sub-Total','/rh/generales.xml')/>
<cfset LB_CargasSociales = t.translate('LB_CargasSociales','Cargas Sociales','/rh/generales.xml')/>
<cfset LB_Moneda = t.translate('LB_Moneda','Moneda','/rh/generales.xml')/>
<cfset LB_TipoDeCambio = t.translate('LB_TipoDeCambio','Tipo de cambio','/rh/generales.xml')/> 

<cfset LvarFileName = "ReporteCostosSalariales_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cfset lvarMoneda = "">

<cfif isdefined("form.sMoneda")>
	<cfset lvarMoneda = "#LB_Moneda#: #form.sMoneda#">
</cfif> 
 
<cf_htmlReportsHeaders title="#LB_ReporteCostosSalariales#" filename="#LvarFileName#" irA="ReporteCostosSalariales.cfm">
<cf_templatecss/>

<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif> 
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre"  conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfset LB_IICA = rsCEmpresa.CEnombre>


<cfquery name="rsMeses" datasource="sifcontrol">
	select VSdesc, VSvalor 
	from VSidioma 
	where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo='#session.idioma#')
</cfquery> 

<cfset titulocentrado2 = ''>
<cfif rsReporte.recordcount>
	<cfif createDate(year(rsReporte.mesMax), month(rsReporte.mesMax), 1) neq createDate(year(rsReporte.mesMin), month(rsReporte.mesMin), 1) >
		<cfquery dbtype="query" name="rs1">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#month(rsReporte.mesMin)#'
		</cfquery>
		<cfquery dbtype="query" name="rs2">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#month(rsReporte.mesMax)#'
		</cfquery>

		<cfset LB_InformeParaElPeriodo = t.translate('LB_InformeParaElPeriodo','Informe para el periodo','/rh/generales.xml')/>
		<cfset titulocentrado2 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #year(rsReporte.mesMin)# - #rs2.VSdesc# #year(rsReporte.mesMax)#'>
	<cfelse>	
		<cfquery dbtype="query" name="rs1">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#month(rsReporte.mesMax)#'
		</cfquery>

		<cfset LB_InformeAlMesDe = t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
		<cfset titulocentrado2 = '#LB_InformeAlMesDe# #rs1.VSdesc# #year(rsReporte.mesMax)#'>
	</cfif>	
</cfif>

<cf_HeadReport 
    addTitulo1='#LB_IICA#' 
    filtro1='#titulocentrado2#' 
    filtro2="#LB_TipoDeCambio#: #rsReporte.tipocambio# </br>#lvarMoneda#"
    showEmpresa="true" 
    showline="false">

<table class="reporte">
	<cfoutput>
		
        <thead>
			<tr>
				<th>#LB_Cuenta#</th>
				<th>#LB_Codigo#</th>
				<th>#LB_Nombre#</th>
				<th>#LB_Anno#</th>
				<th>#LB_Mes#</th>
				<th>#LB_Salario#</th>
				<th>#LB_OtrosIngresos#</th>
				<cfloop query="#rsCargas#">
					<cfif rsCargas.DClinea neq 0>
						<th>#DCcodigo# - #DCdescripcion#</th>
					</cfif>
				</cfloop>
                <th>#LB_Total#</th>
			</tr>
	    </thead>
    </cfoutput>	
    <tbody>  
    	
		<cfset lvarTOTAL = 0>
        <cfset sub_salario = 0>
        <cfset sub_otrosingresos = 0>
        <cfset sub_total = 0>
        <cfset sub_codigo = ''>
    	<cfoutput query="rsReporte">
			
			<cfif sub_codigo NEQ codigo>
            	<cfif len(trim(sub_codigo))>
                    <tr>
                        <td nowrap="nowrap" align="right" colspan="5"><strong>#LB_subTotal#</strong></td>
                        <td align="right">
                           <strong> <cf_locale name="number" value ="#sub_salario#"/></strong>
                        </td> 
                        <td align="right">
                           <strong> <cf_locale name="number" value ="#sub_otrosingresos#"/></strong>
                        </td> 
                        <cfloop query="#rsCargas#">
                            <td align="right">
                                <strong><cf_locale name="number" value ="#evaluate('sub_carga_#DClinea#')#"/></strong>
                            </td>
                            <cfset 'sub_carga_#DClinea#' = 0> 
                        </cfloop>
                        <td align="right">
                            <strong><cf_locale name="number" value="#sub_total#"/></strong>
                        </td> 
                    </tr>
                    <cfset sub_salario = 0>
                    <cfset sub_otrosingresos = 0>
                    <cfset sub_total = 0>
                </cfif>
                <cfset sub_codigo = codigo>
            </cfif>
           
            <tr>
				<td nowrap="nowrap">#cuenta#</td>
				<td>#codigo#</td>
				<td nowrap="nowrap">#nombre#</td>
				<td>#anno#</td>
				<td>#mes#</td>
				<td align="right">
					<cf_locale name="number" value ="#salario#"/>
					<cfset total = salario>
                    <cfset sub_salario += salario>
				</td> 
				<td align="right">
					<cf_locale name="number" value ="#otrosingresos#"/>
					<cfset total += otrosingresos>
                    <cfset sub_otrosingresos += otrosingresos>
				</td> 
				<cfloop query="#rsCargas#">
					<td align="right">
						<cf_locale name="number" value ="#evaluate('rsReporte.carga_#DClinea#')#"/>
						<cfset total += evaluate('rsReporte.carga_#DClinea#')>
                        <cfparam name="sub_carga_#DClinea#" default="0">
						<cfset 'sub_carga_#DClinea#' =  evaluate('sub_carga_#DClinea#') + evaluate('rsReporte.carga_#DClinea#')>
					</td> 
				</cfloop>
				<td align="right">
					<cf_locale name="number" value="#total#"/>
					<cfset lvarTOTAL += total>
                    <cfset sub_total += total>
				</td> 
			</tr>
        </cfoutput>
        
		<cfif len(trim(sub_salario)) or len(trim(sub_otrosingresos))  or len(trim(sub_total)) >
            <tr>
                <td nowrap="nowrap" align="right" colspan="5"><strong><cfoutput>#LB_subTotal#</cfoutput></strong></td>
                <td align="right">
                   <strong> <cf_locale name="number" value ="#sub_salario#"/></strong>
                </td> 
                <td align="right">
                   <strong> <cf_locale name="number" value ="#sub_otrosingresos#"/></strong>
                </td> 
                <cfloop query="#rsCargas#">
                    <td align="right">
                        <strong><cf_locale name="number" value ="#evaluate('sub_carga_#DClinea#')#"/></strong>
                    </td>
                </cfloop>
                <td align="right">
                    <strong><cf_locale name="number" value="#sub_total#"/></strong>
                </td> 
            </tr>
        </cfif>
    	
        <tr><td colspan="#rsCargas.recordcount + 5#">&nbsp;</td></tr>
    	<cfoutput query="rsTotales"> 
	    	<tr>
				<td align="center" colspan="5"><strong>#LB_Total#</strong></td>
				<td align="right"><strong><cf_locale name="number" value ="#totSalario#"/></strong></td>
				<td align="right"><strong><cf_locale name="number" value ="#totOtrosIngresos#"/></strong></td>
				<cfloop query="#rsCargas#">
					<td align="right">
						<strong><cf_locale name="number" value ="#evaluate('rsTotales.totCarga_#DClinea#')#"/></strong>
					</td> 	
				</cfloop>	
				<td align="right"><strong><cf_locale name="number" value="#lvarTOTAL#"/></strong></td> 
	    	</tr>
    	</cfoutput>
    </tbody>
</table>
 
