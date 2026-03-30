<!--- ************************************************************* --->
<!---  				EXTRAE EL PERIODO POR DEFECTO 					--->
<!--- ************************************************************* --->
	<cfquery name="rsPeriodos" datasource="#Session.DSN#">
		select CPPid
		from CPresupuestoPeriodo p
		where p.Ecodigo = #Session.Ecodigo#
		  and p.CPPestado <> 0
	</cfquery>

	<cfparam name="form.CPPid"	default="#rsPeriodos.CPPid#">
	<cfset session.CPPid = form.CPPid>


<cfinclude template="../../Utiles/sifConcat.cfm">

	
    
    <!---Para el Programa--->
    
    	<cfquery name="rsPrograma" datasource="#session.dsn#">
          
                select distinct d.PCCDvalor, d.PCCDdescripcion from CPValidacionConfiguracion a
                inner join PCDCatalogo b
                on a.PCEcatid = b.PCEcatid
                inner join PCDClasificacionCatalogo c
                on c.PCDcatid = b.PCDcatid
                inner join PCClasificacionD d
                on c.PCCEclaid = d.PCCEclaid
                where Valor = 'Clasificacion'

       	</cfquery>
        
        <cfset MSG_Rubro = "HOLA">
        

       
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<form name="form1" method="post" action="rptMomentoContaComprometido-imprimir.cfm" onSubmit="return sbSubmit();">
<table width="100%" border="0">
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Reporte:
		</td>
		<td colspan="3">
			<cfoutput>
			<strong> Reporte del momento contable Comprometido</strong>
			</cfoutput>
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Período Presupuestario:
		</td>
		<td colspan="2">
		<cf_cboCPPid value="#session.CPPid#" onChange="this.form.action='';this.form.submit();" CPPestado="1,2">
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<tr>
		<td nowrap>
			Programa Inicial:
		</td>
            <td><select name="PCCDvalorI" tabindex="2">
                     <option value="">(Sin Clasificar)</option>
                      <cfoutput query="rsPrograma">
                          <option value="#PCCDvalor#">#PCCDvalor# - #PCCDdescripcion#</option>
                      </cfoutput>
                 </select>
            </td>
        
        <td  nowrap>
        	Programa Final:
        </td>
            <td><select name="PCCDvalorF" tabindex="2">
	     		 <option value="">(Sin Clasificar)</option>
				  <cfoutput query="rsPrograma">
              		  <option value="#PCCDvalor#">#PCCDvalor# - #PCCDdescripcion#</option>
            	  </cfoutput>
       			 </select>
        	</td>
		
				
</tr>

<!--- ************************************************************* --->
	<tr>
		<td  >
			Rubro Inicial:
		</td>
						<td>
							<cf_conlis title="Lista de Rubros"
									campos = "PCDvalorI, PCDdescripcionI" 
                                    id = "RubroI"
									desplegables = "S,S" 
									modificables = "N,N" 
									size = "0,35"
									tabla="PCDCatalogo a inner join PCECatalogo b on a.PCEcatid = b.PCEcatid"
									columnas="a.PCDvalor as PCDvalorI, a.PCDdescripcion as PCDdescripcionI"
									filtro="b.PCEdescripcion like 'RUBROS%' and b.PCEactivo = 1 order by a.PCDvalor"
									desplegar="PCDvalorI,PCDdescripcionI"
									etiquetas="Codigo,Descripci&oacute;n"
									formatos="S,S"
                         
									align="left,left"
									asignar="PCDvalorI, PCDdescripcionI"
									asignarformatos="S,S"
									showEmptyListMsg="true"
									debug="false"
									tabindex="1"
                                    form="form1"
									filtrar_por="a.PCDvalor, a.PCDdescripcion" >
						</td>
         <td>
			Rubro Final:
		 </td>
        
        <td>							
								
							<cf_conlis title="Lista de Rubros"
									campos = "PCDvalorF, PCDdescripcionF" 
									desplegables = "S,S" 
									modificables = "N,N" 
									size = "0,35"
									tabla="PCDCatalogo a inner join PCECatalogo b on a.PCEcatid = b.PCEcatid"
									columnas="a.PCDvalor as PCDvalorF, a.PCDdescripcion as PCDdescripcionF"
									filtro="b.PCEdescripcion like 'RUBROS%' and b.PCEactivo = 1 order by a.PCDvalor"
									desplegar="PCDvalorF,PCDdescripcionF"
									etiquetas="Codigo,Descripci&oacute;n"
									formatos="S,S"
									align="left,left"
									asignar="PCDvalorF, PCDdescripcionF"
									asignarformatos="S,S"
									showEmptyListMsg="true"
									debug="false"
									tabindex="1"
									filtrar_por="a.PCDvalor, a.PCDdescripcion" >
		</td>
	</tr>
    
								
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		
		<td nowrap>
			SubRubro Inicial:
		</td>
				<td>
                        
                    <cf_conlis title="Lista de SubRubros"
                        campos = "SubRubroI, Descripcion" 
                        desplegables = "S,S" 
                        modificables = "N,N" 
                        size = "0,35"
                        tabla="PCDCatalogo a inner join PCDCatalogo b on a.PCEcatid = b.PCEcatidref"
                        columnas="a.PCDvalor as SubRubroI, a.PCDdescripcion as Descripcion"
                        filtro="b.PCDvalor = $PCDvalorI,numeric$ order by a.PCDvalor"
                        desplegar="SubRubroI,Descripcion"
                        etiquetas="Codigo,Descripci&oacute;n"
                        formatos="S,S"
                        filtrar_por="a.PCDvalor"
                        Align="left,left"
                        asignar="SubRubroI, Descripcion"
                        Asignarformatos="S,S"/>
				</td>
            
         <td>
        SubRubro Final:
        </td>         
		        <td>              
                    <cf_conlis title="Lista de SubRubros"
                        campos = "SubRubroF, DescripcionF" 
                        desplegables = "S,S" 
                        modificables = "N,N" 
                        size = "0,35"
                        tabla="PCDCatalogo a inner join PCDCatalogo b on a.PCEcatid = b.PCEcatidref"
                        columnas="a.PCDvalor as SubRubroF, a.PCDdescripcion as DescripcionF"
                        filtro="b.PCDvalor = $PCDvalorF,numeric$ order by a.PCDvalor"
                        desplegar="SubRubroF,DescripcionF"
                        etiquetas="Codigo,Descripci&oacute;n"
                        formatos="S,S"
                        filtrar_por="a.PCDvalor"
                        Align="left,left"
                        asignar="SubRubroF, DescripcionF"
                        Asignarformatos="S,S"/>
               </td>




		
	</tr>	


<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<cf_btnImprimir name="rptMomentoContaComprometido" TipoPagina="Carta Horizontal (Letter Landscape)">
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
</table>
</form>
<script>
	var GvarSubmit = false;
	function sbSubmit()
	{
		GvarSubmit = true;
		return true;
	}

</script>


 