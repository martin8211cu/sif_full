<html>
<head>
	<style type="text/css">
		.tipoBeca{
			text-align:center;
			background-color:#CCC;
			font-size:18px;
			font-weight:bold;
		}
		
		.columnas{
			font-weight:bold;
			background-color:#CCC;
		}
		
		.titulo{
			font-size:24px;	
			font-weight:bold;
		}
		
		.subtitulo{
			font-size:20px;	
			font-weight:bold;
		}

	</style>
</head>
<body>
<cf_dbfunction name="to_char"	args="db.RHDBEvalor"  len="32000" returnvariable="RHDBEvalor_toChar">
<cfquery name="rsEncabezados" datasource="#session.dsn#">
    select eb.RHTBid, eb.RHEBEid, RHTBdescripcion, de.DEid, DEidentificacion, DEnombre,DEapellido1, DEapellido2
    from RHEBecasEmpleado eb
    	inner join DatosEmpleado de 
        	on de.DEid = eb.DEid
        inner join RHTipoBeca tb
        	on tb.RHTBid = eb.RHTBid
    where eb.Ecodigo = #session.Ecodigo#
      and eb.RHEBEestado = 70
      and tb.RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTBid#">
      and exists (select 1 
      				from RHDBecasEmpleado db
                    where 
                      db.RHEBEid = eb.RHEBEid
					  <cfif isdefined ('form.fecha') and len(trim(form.fecha)) gt 0>
                      and <cf_dbfunction name="to_date"	args="#RHDBEvalor_toChar#"> >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsdateformat(form.fecha)#">
					  and db.RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTBDFid#">
					  </cfif>
                  )
	order by de.DEid
</cfquery>
<cfoutput>
<cf_htmlReportsHeaders irA="repBeneficios.cfm" FileName="repBeneficios.xls" title="Beneficios">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
    	<td class="titulo">Programa de Becas</td>
        <td rowspan="5" align="right" valign="middle" style="padding-right: 30px;"><img src="../../../home/public/logo_cuenta.cfm?CEcodigo=#session.CEcodigo#" height="60" border="0"></td>
    </tr>
    <tr>
    	<td class="titulo">Unidad de Desarrollo de Personal</td>
    </tr>
    <tr>
    	<td class="subtitulo">Departamento de Recursos Humanos de Becas</td>
    </tr>
    <tr>
    	<td class="subtitulo">#session.cenombre#</td>
    </tr>
    <tr>
    	<td class="subtitulo">#session.Enombre#</td>
    </tr>
   	<tr>
    	<td colspan="2">&nbsp;</td>
    </tr>
   <tr><td class="tipoBeca" colspan="2">#rsEncabezados.RHTBdescripcion#</td></tr>
    <tr>
    	<td colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="5">
			<cfset lvarDEid = -1>
            <cfloop query="rsEncabezados">
                <cfquery name="rsColumnas" datasource="#session.dsn#">
                    select RHTBDFid, RHTBDFetiqueta, RHTBDFcapturaA, RHTBDFcapturaB
                    from RHTipoBecaEFormatos eb
                        inner join RHTipoBecaDFormatos db
                            on db.RHTBEFid = eb.RHTBEFid
                    where eb.RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHTBid#">
                      and db.RHTBDFreporte in (2,3)
                      and db.RHTBDFbeneficio = 0
                    order by db.RHTBDForden
                </cfquery>
				<cfif rsEncabezados.DEid neq lvarDEid>
                	<tr><td colspan="#3 + rsColumnas.recordcount#">&nbsp;</td></tr>
                    <tr>
                        <td class="columnas" nowrap>Nombre</td>
                        <td class="columnas" nowrap>Cédula</td>
                        <cfloop query="rsColumnas"><td class="columnas">#rsColumnas.RHTBDFetiqueta#</td></cfloop>
                    </tr>
                </cfif>
                <tr>
                    <td nowrap><cfif rsEncabezados.DEid neq lvarDEid>#rsEncabezados.DEnombre# #rsEncabezados.DEapellido1# #rsEncabezados.DEapellido2#</cfif></td>
                    <td nowrap><cfif rsEncabezados.DEid neq lvarDEid>#rsEncabezados.DEidentificacion#<cfset lvarDEid = rsEncabezados.DEid></cfif></td>
                    <cfloop query="rsColumnas">
                        <cfquery name="rsDetalle" datasource="#session.dsn#">
                            select RHDCBid, RHDBEvalor
                            from RHDBecasEmpleado
                            where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsColumnas.RHTBDFid#">
                              and RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#">
                              and RHDBEversion = 1
                        </cfquery>
                        <cfif rsColumnas.RHTBDFcapturaA neq 5 and len(trim(rsColumnas.RHTBDFcapturaB)) eq 0>
                        	<cfset lvarValorA = rsDetalle.RHDBEvalor>
                            <cfset lvarValorB = "">
                        <cfelseif rsColumnas.RHTBDFcapturaA eq 5 and len(trim(rsColumnas.RHTBDFcapturaB)) eq 0>
                        	<cfset lvarValorA = rsDetalle.RHDCBid>
                            <cfset lvarValorB = "">
                        <cfelseif rsColumnas.RHTBDFcapturaA eq 5 and rsColumnas.RHTBDFcapturaB neq 5>
                        	<cfset lvarValorA = rsDetalle.RHDCBid>
                            <cfset lvarValorB = rsDetalle.RHDBEvalor>
                        <cfelseif rsColumnas.RHTBDFcapturaA neq 5 and rsColumnas.RHTBDFcapturaB neq 5>
                        	<cfset lvarValorA = ListGetAt(rsDetalle.RHDBEvalor,1,'##')>
                            <cfset lvarValorB = ListGetAt(rsDetalle.RHDBEvalor,2,'##')>
                        <cfelseif rsColumnas.RHTBDFcapturaA neq 5 and rsColumnas.RHTBDFcapturaB eq 5>
                        	<cfset lvarValorA = rsDetalle.RHDBEvalor>
                            <cfset lvarValorB = rsDetalle.RHDCBid>
                        </cfif>
                        <cfset valorA = fnGetValor(rsColumnas.RHTBDFcapturaA,lvarValorA)>
                        <cfset valorB = fnGetValor(iif(len(trim(rsColumnas.RHTBDFcapturaB)) gt 0,rsColumnas.RHTBDFcapturaB,-1),lvarValorB)>
                        <td nowrap>#valorA#<cfif len(trim(valorB)) gt 0>&nbsp;&nbsp;#valorB#</cfif></td>
                    </cfloop>
                </tr>
                <tr>
                	<td colspan="2" nowrap><strong>Beneficios</strong></td>
                    <td><strong>Monto</strong></td>
                    <td colspan="#rsColumnas.recordcount - 1#">&nbsp;</td>
                </tr>
                <cfquery name="rsColumnasB" datasource="#session.dsn#">
                    select RHTBDFid, RHTBDFetiqueta, RHTBDFcapturaA, RHTBDFcapturaB
                    from RHTipoBecaEFormatos eb
                        inner join RHTipoBecaDFormatos db
                            on db.RHTBEFid = eb.RHTBEFid
                    where eb.RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHTBid#">
                      and db.RHTBDFreporte in (2,3)
                      and db.RHTBDFbeneficio = 1
                </cfquery>
                <cfloop query="rsColumnasB">
                	<cfquery name="rsDetalleB" datasource="#session.dsn#">
                        select RHDCBid, RHDBEvalor
                        from RHDBecasEmpleado
                        where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsColumnasB.RHTBDFid#">
                          and RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#">
                          and RHDBEversion = 1
                    </cfquery>
                    <cfset lvarMonto = -1>
                	<cfif rsColumnasB.RHTBDFcapturaA eq 2 and len(trim(rsColumnasB.RHTBDFcapturaB)) eq 0>
						<cfset lvarMonto = rsDetalleB.RHDBEvalor>
                        <cfset lvarTipo = rsColumnasB.RHTBDFcapturaA>
                    <cfelseif rsColumnasB.RHTBDFcapturaA eq 2 and len(trim(rsColumnasB.RHTBDFcapturaB)) gt 0>
                        <cfset lvarMonto = ListGetAt(rsDetalle.RHDBEvalor,1,'##')>
                        <cfset lvarTipo = rsColumnasB.RHTBDFcapturaA>
                    <cfelseif rsColumnasB.RHTBDFcapturaA eq 5 and rsColumnasB.RHTBDFcapturaB eq 2>
                        <cfset lvarMonto = rsDetalleB.RHDBEvalor>
                        <cfset lvarTipo = rsColumnasB.RHTBDFcapturaB>
                    <!---<cfelseif rsColumnasB.RHTBDFcapturaA neq 5 and rsColumnasB.RHTBDFcapturaB eq 2>
                        <cfset lvarMonto = ListGetAt(rsDetalle.RHDBEvalor,2,'##')>
                        <cfset lvarTipo = rsColumnasB.RHTBDFcapturaB>--->
                    </cfif>
                    <cfif lvarMonto neq -1>
                    <cfset valorMonto = fnGetValor(lvarTipo,lvarMonto)>
                        <tr>
                            <td colspan="2" nowrap>#rsColumnasB.RHTBDFetiqueta#</td>
                            <td>#valorMonto#</td>
                            <td colspan="#rsColumnas.recordcount - 1#">&nbsp;</td>
                        </tr>
                    </cfif>
                </cfloop>
                <cfquery name="rsBenConceptos" datasource="#session.dsn#">
                    select RHECBdescripcion, RHDCBdescripcion, RHDBEvalor, RHDCBtipo
                    from RHDBecasEmpleado db
                        inner join RHDConceptosBeca dc
                            on dc.RHDCBid = db.RHDCBid
                        inner join RHEConceptosBeca ec
                            on ec.RHECBid = dc.RHECBid
                    where db.RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#">
                        and db.RHTBDFid is null
                        and ec.RHECBbeneficio = 1
                        and db.RHDBEversion = 1
                </cfquery>
                <cfloop query="rsBenConceptos">
                	<cfset valorMonto = "">
                	<cfif rsBenConceptos.RHDCBtipo eq 2>
						<cfset valorMonto = fnGetValor(rsBenConceptos.RHDCBtipo,rsBenConceptos.RHDBEvalor)>
                    </cfif>
                	<tr>
                        <td colspan="2" nowrap>#rsBenConceptos.RHECBdescripcion#(#rsBenConceptos.RHDCBdescripcion#)</td>
                        <td>#valorMonto#</td>
                        <td colspan="#rsColumnas.recordcount - 1#">&nbsp;</td>
                    </tr>
                </cfloop>
            </cfloop>
		</table></td>
    </tr>
    <tr>
    	<td class="columnas" colspan="2">Total de becas es de #rsEncabezados.recordcount#</td>
    </tr>
</table>
</cfoutput>
</body>
</html>
<cffunction name="fnGetValor" access="private" returntype="string">
	<cfargument name="Captura" 	type="numeric" 	required="yes">
    <cfargument name="Valor"   	type="string" 	required="yes">
    
	<cfif Arguments.Captura eq 1>
   		<cfreturn Arguments.Valor>
    <cfelseif Arguments.Captura eq 2>
		<cfset lvarMonto = ListGetAt(Arguments.Valor,1,'|')>
        <cfset lvarMcodigo = ListGetAt(Arguments.Valor,2,'|')>
        <cfquery name="rsMoneda" datasource="#session.dsn#">
            select Mcodigo, Miso4217
            from Monedas
            where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMcodigo#">
        </cfquery>
      	<cfreturn "#rsMoneda.Miso4217#&nbsp;#numberFormat(lvarMonto,',9.99')#">
    <cfelseif Arguments.Captura eq 3>
    	<cfreturn Arguments.Valor>
    <cfelseif Arguments.Captura eq 4>
    	<cfreturn Arguments.Valor>
    <cfelseif Arguments.Captura eq 5>
        <cfquery name="rsConcepto" datasource="#session.dsn#">
            select RHDCBdescripcion
            from RHDConceptosBeca
            where RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Valor#">
        </cfquery>
        <cfreturn rsConcepto.RHDCBdescripcion>
    <cfelse>
    	<cfreturn "">
    </cfif>
</cffunction>
