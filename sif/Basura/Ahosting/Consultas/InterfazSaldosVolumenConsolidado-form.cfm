<!--- 
	Creado por Alejandro Bolaños ABG
		Fecha: 22 de Octubre 2010
 --->

<cf_templateheader title="Modulo Integracion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Generación de Volúmenes de Venta Consolidado'>

<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">

<cffunction name="ObtenParametro" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
    <cfargument name="pdescripcion" type="string" required="true">	
	<cfquery name="rsParametro" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfif rsParametro.recordcount EQ 0 OR len(rsParametro.Pvalor) EQ 0>
    	<cfswitch expression="#Arguments.pcodigo#">
            <cfcase value="1140">
        		<cfthrow message="La empresa no pertenece a ningun grupo de empresas, no es posible consolidar">    	
            </cfcase>
            <cfcase value="1120">
        		<cfthrow message="La consolidación de volumenes, solo se puede realizar en la empresa de eliminación del grupo">    	
            </cfcase>
            <cfdefaultcase>
            	<cfthrow message="El parametro #Arguments.pdescripcion# NO esta definido para esta empresa">
            </cfdefaultcase>
        </cfswitch>
    <cfelse>
        <cfreturn #rsParametro#>
    </cfif>
</cffunction>

<cftry>
	<!--- Obitne Grupo de Empresa, Empresa de Eliminacion --->
    <cfset gpoElimina = ObtenParametro(1140, "Grupo Eliminacion")>
    <cfset empElimina = ObtenParametro(1120, "Empresa Eliminacion")>

	<!--- Periodo y Mes posibles de Procesar --->
    <cfquery name="rsPeriodo" datasource="#session.dsn#">
        select min(convert(int,Pvalor)) as Periodo
        from Parametros 
        where Pcodigo = 50
        and Ecodigo in 
        	(select Ecodigo from AnexoGEmpresaDet where GEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#gpoElimina.Pvalor#">)
        and Ecodigo != <cfqueryparam cfsqltype="cf_sql_integer" value="#empElimina.Pvalor#">
	</cfquery>
    <cfset PeriodoInicio = rsPeriodo.Periodo - 3>    
    <cfquery name="rsMes" datasource="#session.dsn#">
        select min(convert(int,Pvalor)) as Mes
        from Parametros 
        where Pcodigo = 60
        and Ecodigo in 
        	(select Ecodigo from AnexoGEmpresaDet where GEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#gpoElimina.Pvalor#">)
        and Ecodigo != <cfqueryparam cfsqltype="cf_sql_integer" value="#empElimina.Pvalor#">
	</cfquery>    
	
    <cfoutput>
        <form name="form1" method="post" action="interfazSaldosVolumenConsolidado-sql.cfm">
            <fieldset><legend align="left">Generacón de Volumenes</legend>
                <table width="99" cellpadding="" cellspacing="0" border="0" align="center"> 	
                    
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>		
                        <td align="left"><strong>Periodo:</strong></td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                            <select name="fltPeriodo" tabindex="1">
                                <option value="-1" selected="selected">-Seleccionar-</option>
                                <cfloop from="#PeriodoInicio#" to="#rsPeriodo.Periodo#" step="1" index="Periodo">
                                    <option value="#Periodo#">#Periodo#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr>		
                        <td align="left"><strong>Mes:</strong></td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                            <select name="fltMes" tabindex="2">
                                <option value="-1" selected="selected">-Seleccionar-</option>
                                <cfloop from="1" to="12" step="1" index="Mes">
                                    <cfswitch expression="#Mes#">
                                    	<cfcase value="1">
                                        	<option value="#Mes#">Enero</option>
                                        </cfcase>
                                        <cfcase value="2">
                                        	<option value="#Mes#">Febrero</option>
                                        </cfcase>
                                        <cfcase value="3">
                                        	<option value="#Mes#">Marzo</option>
                                        </cfcase>
                                        <cfcase value="4">
                                        	<option value="#Mes#">Abril</option>
                                        </cfcase>
                                        <cfcase value="5">
                                        	<option value="#Mes#">Mayo</option>
                                        </cfcase>
                                        <cfcase value="6">
                                        	<option value="#Mes#">Junio</option>
                                        </cfcase>
                                        <cfcase value="7">
                                        	<option value="#Mes#">Julio</option>
                                        </cfcase>
                                        <cfcase value="8">
                                        	<option value="#Mes#">Agosto</option>
                                        </cfcase>
                                        <cfcase value="9">
                                        	<option value="#Mes#">Septiembre</option>
                                        </cfcase>
                                        <cfcase value="10">
                                        	<option value="#Mes#">Octubre</option>
                                        </cfcase>
                                        <cfcase value="11">
                                        	<option value="#Mes#">Noviembre</option>
                                        </cfcase>
                                        <cfcase value="12">
                                        	<option value="#Mes#">Diciembre</option>
                                        </cfcase>
                                        <cfdefaultcase>
                                        	<option value="-1">Error</option>
                                        </cfdefaultcase>	
                                    </cfswitch>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                </table>
        	</fieldset>    	        
        </form>
        
    </cfoutput>
<cfcatch>
	<cfthrow message="#cfcatch.Message#">
</cfcatch>
</cftry>
<!---    
    <cfquery name="rsPeriodo" datasource="sifinterfaces">
        select distinct(E.Periodo) as Periodo from ESIFLD_Facturas_Venta E
        inner join DSIFLD_Facturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
        inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
        where E.Periodo is not null and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        order by E.Periodo desc
    </cfquery>
    
    <cfquery name="rsMes" datasource="sifControl">
            select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
            from Idiomas a, VSidioma b 
            where a.Icodigo = '#Session.Idioma#'
                and a.Iid = b.Iid
                and b.VSgrupo = 1
            order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
    </cfquery>
    
    <cfquery name="rsAñoMes" datasource="#session.dsn#">
        select convert(integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=   "#Session.Ecodigo#"> and Pcodigo = 60)) - 1  as Mes,
        case convert (integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=     "#Session.Ecodigo#"> and Pcodigo = 60)) - 1 when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then    'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when    10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as NomMes,
        (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                    					    "#Session.Ecodigo#"> and Pcodigo = 50) as Año
    </cfquery>
    
    <cfoutput>
        <form name="form1" method="post" action="interfazSaldosVolumen-sql.cfm">
        <fieldset><legend align="left">Filtros</legend>
        <table width="99" cellpadding="" cellspacing="0" border="0" align="center"> 	
            
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>		
                    <td align="left"><strong>Periodo:	</strong></td>
                    
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                        <select name="fltPeriodo" tabindex="5">
                            <cfloop query="rsPeriodo">
                                <option value="#rsPeriodo.Periodo#" <cfif #rsAñoMes.Año# EQ "#rsPeriodo.Periodo#">selected</cfif>>#rsPeriodo.Periodo#
                                </option>
                            </cfloop>
                        </select>
                    </td>
                    </tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
                    <td align="left"><strong>Mes: </strong></td>
                    <td>
                        <select name="fltMes" tabindex="5"> 
                                <cfloop query="rsMes">
                                <option value="#rsMes.VSvalor#" <cfif #rsAñoMes.Mes# EQ "#rsMes.VSvalor#">selected</cfif>>#rsMes.VSdesc#</option>     
                                </cfloop>
                        </select>
                    </td>
                    </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                    
                        <tr><td colspan="2"><cf_botones values="Seleccionar" names="Seleccionar"></td></tr>
                        <tr><td colspan="2">&nbsp;</td></tr>
            </fieldset>		
            </table>
            
        </form>
        
    </cfoutput> --->
    <cf_web_portlet_end>
    <cf_templatefooter>
    <cf_qforms form = 'form1'>
    
    <script language="javascript" type="text/javascript">
        function funcSeleccionar()
            {
                var mensaje = '';
                if (document.form1.fltPeriodo.value == '-1'){
                    mensaje += '- Periodo\n';
                }
                if (document.form1.fltMes.value == '-1'){
                    mensaje += '- Mes\n';
                }
                if (mensaje != ''){
                    alert('Los siguientes campos son requeridos:\n\n' + mensaje)
                    return false;
                }
                return true;
            }	
    </script>


