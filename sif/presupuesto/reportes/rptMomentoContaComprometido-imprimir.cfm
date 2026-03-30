<cfsetting 	requesttimeout="600"
			enablecfoutputonly="yes">

<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfparam name="form.CPPid" default="#session.CPPid#">
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfset LvarLineasPagina = 55>


<cftry>

<cfif not isdefined("session.rptRnd")><cfset session.rptRnd = int(rand()*10000)></cfif>
	<cfif isdefined("form.btnCancelar")>
		<cfset session.rptMomentoComprometidoimprimir_Cancel = true>
		<cflocation url="rptMomentoContaComprometido.cfm">
		<cfabort>	
</cfif>
    
    <cfinclude template="../../Utiles/sifConcat.cfm">
	<cflock timeout="1" name="rptMomentoContaComprometido_#session.rptRnd#" throwontimeout="yes">
		<cfset structDelete(session, "rptMomentoComprometidoimprimir_Cancel")>

		<cfquery name="rsPeriodo" datasource="#Session.DSN#">
			select 'Periodo' #_Cat# '-' #_Cat# substring(cast(CPPanoMesDesde as varchar),1,4) as Periodo
			from CPresupuestoPeriodo p
			where p.Ecodigo = #Session.Ecodigo#
			  and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		</cfquery>
		
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarCPPid = form.CPPid>
		<cfset LvarPAg = 1>  
		<cfset LvarContL = 5>  
		
        
		<cfquery name="rsConfig" datasource="#Session.DSN#">
			select	b.CPVid, REPLACE(b.Descripcion,' ','_') Descripcion, a.PCEcatid as Catalogo,
					a.Valor
			from CPValidacionConfiguracion a
			inner join CPValidacionValores b
				on a.CPVid = b.CPVid
			Where b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

        <cfset LobjControl = createObject( "component","sif.presupuesto.Componentes.PRES_GeneraTablaValidaPPTO")>
		<cfset myTable = LobjControl.CreaTablaValPresupuesto(#session.dsn#)>

          <cfloop query="rsConfig">
          <cfif #Valor# EQ 'Valor'>
	          <cfset LvarValor = "#rsConfig.Descripcion#">
          <cfelseif #Valor# EQ 'Clasificacion'>
			  <cfset LvarClasificacion = "#rsConfig.Descripcion#">
          <cfelseif #Valor# EQ  'Referencia'>
              <cfset LvarReferencia = "#rsConfig.Descripcion#">
          </cfif>
          
       	</cfloop>
        			<cfquery name="rsDatos" datasource="#Session.DSN#">
                                                   
                        select #LvarClasificacion# as Nivel1,#LvarValor# as Nivel2,#LvarReferencia# as Nivel3,DESCRIPCION,isnull([1],0)as Enero,isnull([2],0) 
                        as Febrero,isnull([3],0)as Marzo,isnull([4],0)as Abril,isnull([5],0)as Mayo,isnull([6],0) as Junio,isnull([7],0)as Julio,
                        isnull([8],0) as Agosto,isnull([9],0)as Septiembre,isnull([10],0)as Octubre,isnull([11],0)as Noviembre,isnull([12],0)as Diciembre
                        FROM( select isnull (sum(B.NAPMonto),0)as MONTO,#LvarClasificacion#,#LvarValor#,#LvarReferencia#,B.CPCCdescripcion as DESCRIPCION,
                        B.CPCmes AS MES 
                        from "#myTable#" as A
                            inner join ( 
                                            select d.CPCCdescripcion,c.CPcuenta,c.CPCano,c.CPCmes, f.CPNAPDmonto-f.CPNAPDutilizado as NAPMonto,c.CPPid,c.CPNAPnum 
                                                from CPresupuestoComprometidasNAPs c
                                            inner join CPNAPdetalle f
                                                on   c.CPPid = f.CPPid
                                                and c.CPcuenta = f.CPcuenta
                                                and f.CPNAPDlinea = c.CPNAPDlinea
                                                and c.CPCmes = f.CPCmes
                                                and c.CPNAPnum = f.CPNAPnum
                                            inner join CPresupuestoComprAut d 
                                                on c.CPPid = d.CPPid and c.CPcuenta = d.CPcuenta and c.Ecodigo = d.Ecodigo 
                                		)as B 
                             on A.CPcuenta = B.CPcuenta
                              where 1=1 
                       
                       <cfif Form.PCCDvalorI NEQ "" and Form.PCCDvalorf  NEQ "" >
                                 and #LvarClasificacion# between <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorI#"> 
                                 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorF#"> 
                                 
                       <cfelseif Form.PCCDvalorI  NEQ "">
                                  AND #LvarClasificacion# >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorI#">         
                       <cfelseif Form.PCDvalorF NEQ "">
                                  AND #LvarClasificacion# <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorF#"> 
                       </cfif>
                                 
                        <cfif Form.PCDvalorI NEQ "" and Form.PCDvalorF  NEQ "" >
                                  and #LvarValor# between <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorI#"> 
                                  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorF#">
                        <cfelseif Form.PCDvalorI  NEQ "">
                                  and #LvarValor#  >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorI#"> 
                        <cfelseif Form.PCDvalorF NEQ "">
                                  and #LvarValor#  <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorF#"> 
                        </cfif>
                         
                        <cfif Form.SubRubroI NEQ "" and Form.SubRubroF  NEQ "" >
                                <cfif Form.SubRubroI EQ Form.SubRubroF >       
                                    and #LvarReferencia# =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SubRubroI#"> 
                                
                        		<cfelseif Form.SubRubroI NEQ "">
                                    and #LvarReferencia# >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SubRubroI#"> 
                        		<cfelseif Form.SubRubroF NEQ "">   
                                     and #LvarReferencia# <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SubRubroF#">
                                </cfif>
                        </cfif>        
 
                Group by #LvarClasificacion#,#LvarValor#,#LvarReferencia#,B.CPCmes,B.CPCCdescripcion )PVT 
                PIVOT (sum(MONTO)for MES in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS Resultado 
               	order by Nivel1

            </cfquery>
     

            
               <cfquery name="rsSubRubro" datasource="#Session.DSN#">
                        select  #LvarClasificacion# as Nivel1,#LvarValor# as Nivel2,isnull([1],0)as Enero,isnull([2],0) as Febrero,isnull([3],0)as Marzo
                            ,isnull([4],0)as Abril,isnull([5],0)as Mayo,isnull([6],0) as Junio,isnull([7],0)as Julio,isnull([8],0) as Agosto,
                            isnull([9],0)as Septiembre,isnull([10],0)as Octubre,isnull([11],0)as Noviembre,isnull([12],0)as Diciembre
                             FROM( select isnull (sum(B.NAPMonto),0)as MONTO, #LvarClasificacion#,#LvarValor#,B.CPCmes AS MES 
                            from "#myTable#" as A
                                inner join ( 
                                select d.CPCCdescripcion,c.CPcuenta,c.CPCano,c.CPCmes, f.CPNAPDmonto-f.CPNAPDutilizado as NAPMonto,c.CPPid,c.CPNAPnum 
                                    from CPresupuestoComprometidasNAPs c
                                inner join CPNAPdetalle f
                                    on   c.CPPid = f.CPPid
                                    and c.CPcuenta = f.CPcuenta
                                    and f.CPNAPDlinea = c.CPNAPDlinea
                                    and c.CPCmes = f.CPCmes
                                    and c.CPNAPnum = f.CPNAPnum
                                inner join CPresupuestoComprAut d 
                                    on c.CPPid = d.CPPid and c.CPcuenta = d.CPcuenta and c.Ecodigo = d.Ecodigo 
                                    )as B 
                                    on A.CPcuenta = B.CPcuenta 
                                                         
                       where 1=1 
                       
                       <cfif Form.PCCDvalorI NEQ "" and Form.PCCDvalorf  NEQ "" >
                                 and #LvarClasificacion# between <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorI#"> 
                                 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorF#"> 
                                 
                       <cfelseif Form.PCCDvalorI  NEQ "">
                                  AND #LvarClasificacion# >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorI#">         
                       <cfelseif Form.PCDvalorF NEQ "">
                                  AND #LvarClasificacion# <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorF#"> 
                       </cfif>
                                 
                        <cfif Form.PCDvalorI NEQ "" and Form.PCDvalorF  NEQ "" >
                                  and #LvarValor# between <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorI#"> 
                                  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorF#">
                        <cfelseif Form.PCDvalorI  NEQ "">
                                  and #LvarValor#  >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorI#"> 
                        <cfelseif Form.PCDvalorF NEQ "">
                                  and #LvarValor#  <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorF#"> 
                        </cfif>
                         
                        <cfif Form.SubRubroI NEQ "" and Form.SubRubroF  NEQ "" >
                                <cfif Form.SubRubroI EQ Form.SubRubroF >       
                                    and #LvarReferencia# =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SubRubroI#"> 
                                
                        		<cfelseif Form.SubRubroI NEQ "">
                                    and #LvarReferencia# >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SubRubroI#"> 
                        		<cfelseif Form.SubRubroF NEQ "">   
                                     and #LvarReferencia# <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SubRubroF#">
                                </cfif>
                        </cfif> 
                                Group by  #LvarClasificacion#,#LvarValor#,B.CPCmes)PVT 
                                PIVOT (sum(MONTO)for MES in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS Resultado 
                                order by  Nivel1
    					
            </cfquery>
            
            
                    
               <cfquery name="rsPrograma" datasource="#Session.DSN#">
                                                   
                                     
                    select  #LvarClasificacion# as Nivel1,isnull([1],0)as Enero,isnull([2],0) as Febrero,isnull([3],0)as Marzo
                           ,isnull([4],0)as Abril,isnull([5],0)as Mayo,isnull([6],0) as Junio,isnull([7],0)as Julio,isnull([8],0) as Agosto,
                            isnull([9],0)as Septiembre,isnull([10],0)as Octubre,isnull([11],0)as Noviembre,isnull([12],0)as Diciembre
                    FROM( 
                            select isnull (sum(B.NAPMonto),0)as MONTO,
                                    #LvarClasificacion#,B.CPCmes AS MES from "#myTable#" as A 
                            inner join ( 
                                    select d.CPCCdescripcion,c.CPcuenta,c.CPCano,c.CPCmes, f.CPNAPDmonto-f.CPNAPDutilizado as NAPMonto,c.CPPid,
                                           c.CPNAPnum from CPresupuestoComprometidasNAPs c
                                inner join CPNAPdetalle f
                                    on   c.CPPid = f.CPPid
                                    and c.CPcuenta = f.CPcuenta
                                    and f.CPNAPDlinea = c.CPNAPDlinea
                                    and c.CPCmes = f.CPCmes
                                    and c.CPNAPnum = f.CPNAPnum
                                inner join CPresupuestoComprAut d 
                                    on c.CPPid = d.CPPid and c.CPcuenta = d.CPcuenta and c.Ecodigo = d.Ecodigo 
                            )as B 
                            on A.CPcuenta = B.CPcuenta 
                                                                                    
                       where 1=1 
                       
                       <cfif Form.PCCDvalorI NEQ "" and Form.PCCDvalorf  NEQ "" >
                                 and #LvarClasificacion# between <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorI#"> 
                                 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorF#"> 
                                 
                       <cfelseif Form.PCCDvalorI  NEQ "">
                                  AND #LvarClasificacion# >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorI#">         
                       <cfelseif Form.PCDvalorF NEQ "">
                                  AND #LvarClasificacion# <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCCDvalorF#"> 
                       </cfif>
                                 
                        <cfif Form.PCDvalorI NEQ "" and Form.PCDvalorF  NEQ "" >
                                  and #LvarValor# between <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorI#"> 
                                  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorF#">
                        <cfelseif Form.PCDvalorI  NEQ "">
                                  and #LvarValor#  >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorI#"> 
                        <cfelseif Form.PCDvalorF NEQ "">
                                  and #LvarValor#  <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCDvalorF#"> 
                        </cfif>
                         
                        <cfif Form.SubRubroI NEQ "" and Form.SubRubroF  NEQ "" >
                                <cfif Form.SubRubroI EQ Form.SubRubroF >       
                                    and #LvarReferencia# =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SubRubroI#"> 
                                
                        		<cfelseif Form.SubRubroI NEQ "">
                                    and #LvarReferencia# >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SubRubroI#"> 
                        		<cfelseif Form.SubRubroF NEQ "">   
                                     and #LvarReferencia# <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SubRubroF#">
                                </cfif>
                        </cfif>
                        
                    Group by  #LvarClasificacion#,B.CPCmes )PVT 
                    PIVOT (sum(MONTO)for MES in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS Resultado
                    order by  Nivel1
    
            </cfquery> 
        
        
        
	<cfif isdefined("btnDownload")>
		<cfset LvarNoCortes = "1">
	</cfif>
	<cf_htmlReportsHeaders 
		title="Reporte de Movimientos de Presupuesto (NAPs)" 
		filename="rptMomentoContaComprometido.xls"
		irA="rptMomentoContaComprometido.cfm" 
		>
	<cfoutput>
				<cfset sbGeneraEstilos()>
				<cfset Encabezado()>
				<cfset Creatabla()>
				<cfset titulos()>
				<cfflush interval="512">
                
                	<cfif isdefined("session.rptMomentoComprometidoimprimir_Cancel")>
						<cfset structDelete(session, "rptMomentoComprometidoimprimir_Cancel")>
						<cf_errorCode	code = "50509" msg = "Reporte Cancelado por el Usuario">
					</cfif>
                    
                    
                  
                    <cfloop query="rsPrograma">
                		<cfset LvarPrograma = "#rsPrograma.Nivel1#">
                           
                        <cfquery name="rsLineasSubRubro" dbtype="query">
                            select * from rsSubRubro
                            where  Nivel1 = '#LvarPrograma#'                    	
                   		</cfquery> 
                                           
                         <cfloop query="rsLineasSubRubro">
                             <cfset LvarRubro = "#rsLineasSubRubro.Nivel2#">
                             
                                  <cfquery name="rsLineas" dbtype="query">
                                        select * from rsDatos
                                        where Nivel2 = '#rsLineasSubRubro.Nivel2#'
                                        and  Nivel1 = '#rsPrograma.Nivel1#'
                                  </cfquery>
                                        
                                <cfloop query="rsLineas">
                                
                        
                                        <tr>
                                    
                                                <td align="center" class="Datos colspan="4""> <font face="Arial" size="-3">#rsLineas.Nivel1#</font></td>
                                                <td align="center" class="Datos"><font face="Arial" size="-3">#rsLineas.Nivel2#</font></td>
                                                <td align="center" class="Datos"><font face="Arial" size="-3">#rsLineas.Nivel3#</font></td>
                                                <td align="left" class="Datos" ><font face="Arial" size="-3">#rsLineas.DESCRIPCION#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Enero#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Febrero#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Marzo#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Abril#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Mayo#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Junio#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Julio#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Agosto#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Septiembre#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Octubre#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Noviembre#</font></td>
                                                <td align="right" class="Datos"><font face="Arial" size="-3">#rsLineas.Diciembre#</font></td>
                                           
                                       </tr> 
                                 </cfloop>
                                        
                                    <tr>             
                                          
                                        <td align="left" class="Datos  colspan="4""><strong><font face="Arial" size="-3">SUBTOTAL #LvarValor# #rsLineasSubRubro.Nivel2#</font></strong></td>
                                        <td align="right" class="Datos"></td>
                                        <td align="right" class="Datos"></td>
                                         <td align="left" class="Datos" ></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Enero#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Febrero#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Marzo#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Abril#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Mayo#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Junio#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Julio#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Agosto#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Septiembre#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Octubre#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Noviembre#</font></u></strong></td>
                                        <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsLineasSubRubro.Diciembre#</font></u></strong></td>
                                       
                                    </tr>
                  
                          </cfloop>
                             			<tr>             
                                              
                                            <td align="left" class="Datos  colspan="4""><strong><u><font face="Arial" size="-3">TOTAL #LvarClasificacion# #rsPrograma.Nivel1#</font></u></strong></td>
                                            <td align="right" class="Datos"></td>
                                            <td align="right" class="Datos"></td>
                                             <td align="left" class="Datos" ></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Enero#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Febrero#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Marzo#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Abril#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Mayo#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Junio#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Julio#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Agosto#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Septiembre#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Octubre#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Noviembre#</font></u></strong></td>
                                            <td align="right" class="Datos"><strong><u><font face="Arial" size="-3">#rsPrograma.Diciembre#</font></u></strong></td>
                                           
                                        </tr>
                           
                                </cfloop>
                         
                  
                  
         
				<cfset Cierratabla()>
			</body>
		</html>
		</cfoutput>

	</cflock>
<cfcatch type="lock">
	<cfoutput>
	<script language="javascript">
		alert('Ya existe un reporte en ejecución, debe esperar a que termine su procesamiento');
		location.href = "rptMomentoContaComprometido.cfm";
	</script>
	</cfoutput>
</cfcatch>
</cftry>

<!--- ************************************************************* --->
<!--- *********    Creación de funciones  			   ************ --->
<!--- ************************************************************* --->
<cffunction name="Encabezado" output="true">
	<table width="100%" border="0">
		<tr>
			<td  class="Header1" colspan="16" align="center">
				<strong>#ucase(session.Enombre)#</strong>
			</td>
		</tr>
		<tr>
			<td  class="Header1" colspan="16" align="center"><strong>REPORTE DEL MOMENTO CONTABLE "COMPROMETIDO"</strong></td>
		</tr>
		<tr>
			<td class="Header" colspan="16" align="center"><strong>#ucase(rsPeriodo.Periodo)#</strong></td>
		</tr>
		<tr>
			<td class="Header" colspan="16" align="center"><strong>PESOS(*)</strong></td>
		</tr>
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Creatabla" output="true">
	<table width="100%" border="0">
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Cierratabla" output="true">
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="titulos" output="true">

  <tr border="0">
    <th width="150" rowspan="2" align="center" class="ColHeader" border="0" ><font face="Arial" size="-3">Programa Presupuestario</font></th>
    <th width="67" rowspan="2" align="center"class="ColHeader" heigth="5"border="0"><font face="Arial" size="-3">Rubro</font></th>
    <th width="82" rowspan="2" align="center" class="ColHeader" heigth="5"border="0"><font face="Arial" size="-3">SubRubro</font></th>
    <th width="200" rowspan="2" align="center" class="ColHeader" heigth="5"border="0"><font face="Arial" size="-3">Descripcion</font></th>
    <th colspan="12" align="center" class="ColHeader" heigth="20"border="0"><font face="Arial" size="-3">Importe del Momento Comprometido</font> </th>
  </tr>
  <tr border="0">
    
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Enero</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Febero</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Marzo</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Abril</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Mayo</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Junio</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Julio</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Agosto</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Septiembre</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Octubre</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Noviembre</font></th>
    <th width="90" align="center" class="ColHeader" heigth="5"><font face="Arial" size="-3">Diciembre</font></th>
  </tr>
 
         
         
         
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="sbGeneraEstilos" output="true">
	<style type="text/css">
	<!--
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		
		.ColHeader 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		8px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##CCCCCC
		}
	
		.Header 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
			text-align:	center;
		}
	
		.Header1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte2 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		7px;
			font-weight: 	bold;
			padding-left: 	10px;
		}
	
		.Corte3 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	bold;
			padding-left: 	20px;
		}
	
		.Corte4 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			padding-left: 	30px;
		}
	
		.Datos 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		7px;
			font-weight: 	none;
			white-space:nowrap;
		}
	
		body
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
		}
	-->
	</style>
</cffunction>

<cffunction name="sbCortePagina" output="true">
	<cfif isdefined("LvarNoCortes")>
		<cfreturn>
</cfif>
	<cfif LvarContL GTE LvarLineasPagina>
		<tr><td><H1 class=Corte_Pagina></H1></td></tr>
		<cfset Cierratabla()>
		<cfset LvarPAg   = LvarPAg + 1>
		<cfset LvarContL = 5> 
		<cfset Encabezado()>
		<cfset Creatabla()>
		<cfset titulos()>
	</cfif>
	<cfset LvarContL = LvarContL + 1>  
</cffunction>
				


