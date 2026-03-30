<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConciliacionderentaAnual"  Default="Conciliación de renta Anual" returnvariable="LB_ConciliacionderentaAnual"/>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif isdefined('form.CFid') and LEN(TRIM(form.CFid))>
	<cfif isdefined('form.ChkIncluyeDep')>
        <cfquery name="rsCFs" datasource="#session.dsn#">
            select CFid 
            	from CFuncional 
             where CFpath like '%'#_Cat# (select CFcodigo from CFuncional where CFid = #form.CFid#) #_Cat# '/%'
        </cfquery>
        <cfset listCFs = valuelist(rsCFs.CFid)>
    <cfelse>
        <cfset listCFs = form.CFid>
    </cfif>
</cfif>
<cfquery name="rsliquidacion" datasource="#session.dsn#">
	<!---Empleados Activos a la Fecha Hasta del Periodo de renta--->
    select e.CFcodigo #_Cat# '-' #_Cat# e.CFdescripcion CentroFuncional, a.DEid, b.DEidentificacion, b.DEnombre #_Cat# b.DEapellido1 #_Cat# b.DEapellido2 as Nombre, DEdato3,
    	Coalesce(RHLIVAplanilla_A,0) RHLIVAplanilla_A, 
        Coalesce(RHLRentaRetenida,0) RHLRentaRetenida,
        'Activo' as Estado
        
    	from RHLiquidacionRenta a
        	inner join DatosEmpleado b
            	on b.DEid = a.DEid
          	inner join LineaTiempo c
            	on c.DEid = a.DEid
            inner join RHPlazas d
            	on d.RHPid = c.RHPid
            inner join CFuncional e
            	on e.CFid = d.CFid
    where a.Ecodigo = #session.Ecodigo#
          and a.EIRid   = #form.EIRid#
          and a.Tipo    = 'L'
          and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.FechaHasta#"> between c.LTdesde and c.LThasta
      	  and a.Estado  = 40
      <cfif isdefined('listCFs') and LEN(TRIM(listCFs))>
          and e.CFid in (#listCFs#)
      </cfif>
      
      UNION ALL
      
      select e.CFcodigo #_Cat# '-' #_Cat# e.CFdescripcion CentroFuncional, a.DEid, b.DEidentificacion, b.DEnombre #_Cat# b.DEapellido1 #_Cat# b.DEapellido2 as Nombre, DEdato3,
    	Coalesce(RHLIVAplanilla_A,0) RHLIVAplanilla_A, 
        Coalesce(RHLRentaRetenida,0) RHLRentaRetenida,
        'Inactivo' as Estado
        
    	from RHLiquidacionRenta a
        	inner join DatosEmpleado b
            	on b.DEid = a.DEid
          	inner join LineaTiempo c
            	on c.DEid = a.DEid
            inner join RHPlazas d
            	on d.RHPid = c.RHPid
            inner join CFuncional e
            	on e.CFid = d.CFid
    where a.Ecodigo = #session.Ecodigo#
          and a.EIRid   = #form.EIRid#
          and a.Tipo    = 'L'
          and c.LTdesde = (select Max(LTdesde) from LineaTiempo f where f.DEid = b.DEid)
          and (select count(1) from LineaTiempo g where <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.FechaHasta#"> between g.LTdesde and g.LThasta and g.DEid = b.DEid) = 0
      	  and a.Estado  = 40 
      <cfif isdefined('listCFs') and LEN(TRIM(listCFs))>
          and e.CFid in (#listCFs#)
      </cfif>
      order by 1
</cfquery>
<cfset ComProyRenta    = createobject("component","rh.Componentes.RH_ProyeccionRenta")>
<cfset rsFRentaBruta   = ComProyRenta.GetLineasReporte('GLRB')> <!---Renta Bruta--->
<cfset rsFDeduc 	   = ComProyRenta.GetLineasReporte('GLRD')> <!---Deducciones--->
<cfset ListRentaBruta  = ValueList(rsFRentaBruta.RHCRPTid)>
<cfset ListDeducciones = ValueList(rsFDeduc.RHCRPTid)>
<cfset Space = "&nbsp;&nbsp;">
<cf_templatecss>
<table align="center">
	<tr><td>
        <cf_htmlReportsHeaders title= "#LB_ConciliacionderentaAnual#" filename="conciliacionRentaAnual.xls" irA="ConciliacionRentaAnual.cfm">
		<cf_EncReporte Titulo="#LB_ConciliacionderentaAnual#" filtro1="#form.PeriodoLiquidacion#<br>#form.CFcodigo# #form.CFdescripcion#">
	</td></tr>
	<cfif rsliquidacion.Recordcount>
    	<cfloop query="rsliquidacion">
        	<cfif rsliquidacion.CurrentRow EQ 1 OR trim(CFAnt) NEQ trim(rsliquidacion.CentroFuncional)>
            	<cfset printCF = true>
            <cfelse>
            <cfset printCF = false>
            </cfif>
            <cfif printCF>
                <cfif rsliquidacion.CurrentRow NEQ 1>
                     </table>
                     </td></tr>
                </cfif>
                <cfset CFAnt   = rsliquidacion.CentroFuncional>
               <tr><td><cfoutput><strong>Centro Funcional: #rsliquidacion.CentroFuncional#</strong></cfoutput></td></tr>
               <tr><td>
                    <table border="1" width="100%" align="center" cellpadding="0" cellspacing="0">
                        <tr>
							<cfoutput>
                                <td class="tituloListas">#Space#NIT</td>
                                <td class="tituloListas">#Space#Identificación</td>
                                <td class="tituloListas">#Space#Empleado</td>
                                <td class="tituloListas">#Space#Estatus</td>
                                <td class="tituloListas">#Space#Renta Neta</td>
                                <td class="tituloListas">#Space#Renta Imponible</td>
                                <td class="tituloListas">#Space#Impuesto Determinado</td>
                                <td class="tituloListas">#Space#Credito IVA</td>
                                <td class="tituloListas">#Space#Retenciones de este Periodo</td>
                                <td class="tituloListas">#Space#Ajuste de Retenciones</td>
                            </cfoutput>
                   		</tr>
              </cfif>
                
               <cfquery name="rsTenoRB" datasource="#session.dsn#">
                    select Coalesce(sum(MontoAutorizado),0) MontoAutorizado
                     from RHDLiquidacionRenta
                     where EIRid 	= <cf_JDBCquery_param cfsqltype="cf_sql_numeric" value="#form.EIRid#">
                       and Nversion = <cf_JDBCquery_param cfsqltype="cf_sql_numeric" value="1">
                       and DEid 	= <cf_JDBCquery_param cfsqltype="cf_sql_numeric" value="#rsliquidacion.DEid#">
                       and Tipo 	= <cf_JDBCquery_param cfsqltype="cf_sql_varchar" value="L">
                       and RHCRPTid in (#ListRentaBruta#)
                </cfquery>											
                <cfquery name="rsTenoDed" datasource="#session.dsn#">
                    select Coalesce(sum(MontoAutorizado),0) MontoAutorizado
                     from RHDLiquidacionRenta
                     where EIRid 	= <cf_JDBCquery_param cfsqltype="cf_sql_numeric" value="#form.EIRid#">
                       and Nversion = <cf_JDBCquery_param cfsqltype="cf_sql_numeric" value="1">
                       and DEid 	= <cf_JDBCquery_param cfsqltype="cf_sql_numeric" value="#rsliquidacion.DEid#">
                       and Tipo 	= <cf_JDBCquery_param cfsqltype="cf_sql_varchar" value="L">
                       and RHCRPTid in (#ListDeducciones#)
                 </cfquery>
                <cfset Lvar_ImpDet = ComProyRenta.ObtieneRenta(form.EIRid,rsTenoRB.MontoAutorizado - rsTenoDed.MontoAutorizado)>
               <cfoutput>
               	<cfif currentRow mod 2>
                	<cfset classtd = "listaPar">
               	<cfelse>
                  	<cfset classtd = "listaNon">
                </cfif>
                    <tr>
                        <td class="#classtd#" align="center">#Space##rsliquidacion.DEdato3##Space#</td>
                        <td class="#classtd#" align="center">#Space##rsliquidacion.DEidentificacion##Space#</td>
                        <td class="#classtd#" align="center">#Space##rsliquidacion.Nombre##Space#</td>
                        <td class="#classtd#" align="center">#Space##rsliquidacion.Estado##Space#</td>
                        <td class="#classtd#" align="right">#Space##LSCurrencyFormat(rsTenoRB.MontoAutorizado,'none')##Space#</td>
                        <td class="#classtd#" align="right">#Space##LSCurrencyFormat(rsTenoRB.MontoAutorizado - rsTenoDed.MontoAutorizado,'none')##Space#</td>
                        <td class="#classtd#" align="right">#Space##LSCurrencyFormat(Lvar_ImpDet,'none')##Space#</td>
                        <td class="#classtd#" align="right">#Space##LSCurrencyFormat(rsliquidacion.RHLIVAplanilla_A,'none')##Space#</td>
                        <td class="#classtd#" align="right">#Space##LSCurrencyFormat(rsliquidacion.RHLRentaRetenida,'none')##Space#</td>
                        <td class="#classtd#" align="right">#Space##LSCurrencyFormat(rsliquidacion.RHLIVAplanilla_A - Lvar_ImpDet,'none')##Space#</td>
                    </tr>
              </cfoutput>
        	</cfloop>
            <tr><td colspan="10" align="center">---Ultima Línea---</td></tr>
         </table>
	<cfelse>
        <table border="0" align="center">
            <tr>
                <td>
                    ---No se encontraron registros que cumplan con los filtros especificados--
                </td>
            </tr>
        </table>
	</cfif>
	</td></tr>
</table>